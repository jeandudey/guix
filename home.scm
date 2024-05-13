(use-modules (foundation packages tree-sitter)
             (gnu home)
             (gnu packages)
             (gnu packages emacs-xyz)
             (gnu packages fonts)
             (gnu packages shellutils)
             (gnu packages tree-sitter)
             (gnu services)
             (gnu services configuration)
             (gnu home services)
             (gnu home services desktop)
             (gnu home services guix)
             (gnu home services shells)
             (gnu home services sound)
             (guix build-system emacs)
             (guix git-download)
             ((guix licenses) #:prefix license:)
             (guix packages)
             (guix gexp)
             (ice-9 pretty-print))

;;;
;;; direnv
;;;

(define-configuration/no-serialization home-direnv-configuration
  (package
    (package direnv)
    "The direnv package to use."))

(define (home-direnv-binary config)
  (file-append (home-direnv-configuration-package config) "/bin/direnv"))

(define (home-direnv-bash-extension config)
  (home-bash-extension
    (bashrc
      (list (mixed-text-file
              "bashrc"
              "eval \"$(" (home-direnv-binary config) " hook bash)\"")))))

(define (home-direnv-fish-extension config)
  (home-fish-extension
    (config
      (list (mixed-text-file
              "bashrc" (home-direnv-binary config) " hook fish | source")))))

(define (home-direnv-zsh-extension config)
  (home-zsh-extension
    (zshrc
      (list (mixed-text-file
              "bashrc"
              "eval \"$(" (home-direnv-binary config) " hook zsh)\"")))))

(define (home-direnv-packages config)
  (list (home-direnv-configuration-package config)))

(define home-direnv-bash-service-type
  (service-type
    (name 'direnv)
    (extensions (list (service-extension home-bash-service-type
                                         home-direnv-bash-extension)
                      (service-extension home-profile-service-type
                                         home-direnv-packages)))
    (default-value (home-direnv-configuration))
    (description "Install and configure direnv for Bash.")))

(define home-direnv-fish-service-type
  (service-type
    (name 'direnv)
    (extensions (list (service-extension home-fish-service-type
                                         home-direnv-fish-extension)
                      (service-extension home-profile-service-type
                                         home-direnv-packages)))
    (default-value (home-direnv-configuration))
    (description "Install and configure direnv for Fish.")))

(define home-direnv-zsh-service-type
  (service-type
    (name 'direnv)
    (extensions (list (service-extension home-zsh-service-type
                                         home-direnv-zsh-extension)
                      (service-extension home-profile-service-type
                                         home-direnv-packages)))
    (default-value (home-direnv-configuration))
    (description "Install and configure direnv for ZSH.")))

;;;
;;; Emacs
;;;

(define init.el
  (local-file "init.el" "init.el"))

(define emacs-quick-peek
  (let ((commit "03a276086795faad46a142454fc3e28cab058b70")
        (revision "0"))
    (package
      (name "emacs-quick-peek")
      (version (git-version "1.0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                       (url "https://github.com/cpitclaudel/quick-peek")
                       (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1kzsphzc9n80v6vf00dr2id9qkm78wqa6sb2ncnasgga6qj358ql"))))
      (build-system emacs-build-system)
      (home-page "https://github.com/cpitclaudel/quick-peek")
      (synopsis "Inline windows for Emacs")
      (description "This package provides an Emacs library for creating inline
windows or pop-ups.")
      (license license:gpl3+))))

(define emacs-fstar-mode
  (let ((commit "6e5d3ea858f3c8a9d01161d9089909c2b22fdfca")
        (revision "0"))
    (package
      (name "emacs-fstar-mode")
      (version (git-version "0.0.0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                       (url "https://github.com/FStarLang/fstar-mode.el")
                       (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1z1mcmmrfx1nx3d3374wb7qykzdc3qh9ssgs2wz7b5vnv9cbdfn6"))))
      (build-system emacs-build-system)
      (propagated-inputs (list emacs-company
                               emacs-company-quickhelp
                               emacs-dash
                               emacs-flycheck
                               emacs-quick-peek
                               emacs-yasnippet))
      (home-page "https://github.com/FStarLang/fstar-mode.el")
      (synopsis "Major Emacs mode for editing F* (FStar) code")
      (description "This package provides an Emacs mode for editing F* (FStar)
code.")
      (license license:asl2.0))))

;;;
;;; Home environment.
;;;

(home-environment
 (packages
  (append
   (specifications->packages
    (list "bat"
          "bison"
          "btop"
          "clang"
          "distrobox"
          "emacs"
          "emacs-dracula-theme"
          "emacs-evil"
          "emacs-geiser"
          "emacs-geiser-guile"
          "emacs-lsp-mode"
          "emacs-lsp-treemacs"
          "emacs-treemacs"
          "emacs-treemacs-extra"
          "emacs-yasnippet"
          "emacs-yasnippet-snippets"
          "font-google-noto-emoji"
          "fd"
          "flatpak"
          "flex"
          "gcc-toolchain"
          "ghex"
          "git"
          "hexyl"
          "icecat"
          "just"
          "libreoffice"
          "m4"
          "make"
          "ncurses"
          "neomutt"
          "neovim"
          "neovim-coqtail"
          "neovim-packer"
          "openocd"
          "openrgb"
          "openssh"
          "pkg-config"
          "rust"
          "rust:cargo"
          "rust:tools"
          "ripgrep"
          "speedcrunch"
          "strace"
          "slint-lsp"
          "telegram-desktop"
          "tree-sitter-bash"
          "tree-sitter-c"
          "tree-sitter-cmake"
          "tree-sitter-cpp"
          "tree-sitter-dockerfile"
          "tree-sitter-java"
          "tree-sitter-javascript"
          "tree-sitter-html"
          "tree-sitter-json"
          "tree-sitter-lua"
          "tree-sitter-markdown"
          "tree-sitter-meson"
          "tree-sitter-org"
          "tree-sitter-python"
          "tree-sitter-ruby"
          "tree-sitter-rust"
          "tree-sitter-scala"
          "tree-sitter-scheme"
          "tree-sitter-slint-unofficial"
          "tmux"
          "vim-nerdtree"
          "ungoogled-chromium"
          "wl-clipboard"
          "zathura"
          "zathura-pdf-mupdf"))
   (list emacs-fstar-mode)))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
   (list (service home-bash-service-type
                  (home-bash-configuration
                   (aliases '(("grep" . "grep --color=auto")
                              ("ll" . "ls -l")
                              ("ls" . "ls -p --color=auto")))
                   (bash-profile
                    (list (local-file ".bash_profile" "bash_profile")))))

         (service home-direnv-bash-service-type)

         (service home-dbus-service-type)

         (service home-pipewire-service-type)

         (simple-service 'custom-environment-variables
                         home-environment-variables-service-type
                         '(("CC" . "gcc")
                           ("EDITOR" . "nvim")
                           ("PATH" . "$PATH:$HOME/.cargo/bin:$HOME/.local/bin")))

         (service home-xdg-configuration-files-service-type
                  (list (list "mimeapps.list"
                              (local-file "mimeapps.list" "mimeapps.list"))
                        (list "git/config"
                              (local-file "gitconfig" "gitconfig"))
                        (list "git/ignore"
                              (local-file "gitignore" "gitignore"))
                        (list "nvim/init.lua"
                              (local-file "init.lua" "init.lua"))))

         (service home-files-service-type
                  (list (list ".emacs" init.el)
                        (list ".local/share/fonts/DejaVuSans.ttf"
                              (file-append font-dejavu "/share/fonts/truetype/DejaVuSans.ttf"))
                        (list ".var/app/com.visualstudio.code/config/Code/User/settings.json"
                              (local-file "vscode-settings.json" "settings.json")))))))
