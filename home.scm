;; Este archivo "home-environment" se puede pasar a 'guix home reconfigure'
;; para reproducir el contenido de su perfil.  Esto es "simbólico": sólo
;; especifica nombres de paquete.  Para reproducir el mismo perfil exacto, también
;; necesita capturar los canales que están siendo usados, como son devueltos por "guix describe".
;; Vea la sección "Replicando Guix" en el manual.

(use-modules (foundation packages tree-sitter)
             (gnu home)
             (gnu packages)
             (gnu packages fonts)
             (gnu packages shellutils)
             (gnu packages tree-sitter)
             (gnu services)
             (gnu services configuration)
             (gnu home services)
             (gnu home services desktop)
             (gnu home services shells)
             (gnu home services sound)
             (guix packages)
             (guix gexp))

(define (nvim-tree-sitter package name)
  (list (string-append "nvim/parser/" name ".so")
        (file-append package "/lib/tree-sitter/libtree-sitter-" name ".so")))

;;;
;;; direnv
;;;

(define-configuration/no-serialization home-direnv-configuration
  (package
    (package direnv)
    "The direnv package to use.")
  (bash?
    (boolean #t)
    "Configure Bash with direnv.")
  (fish?
    (boolean #f)
    "Configure Fish with direnv.")
  (zsh?
    (boolean #f)
    "Configure ZSH with direnv."))

(define (home-direnv-binary config)
  (file-append (home-direnv-configuration-package config) "/bin/direnv"))

(define (home-direnv-bash-extension config)
  (home-bash-extension
    (bashrc
      (if (home-direnv-configuration-bash? config)
          (list (mixed-text-file
                  "bashrc"
                  "eval \"$(" (home-direnv-binary config) " hook bash)\""))
          '()))))

(define (home-direnv-fish-extension config)
  (home-fish-extension
    (config
      (if (home-direnv-configuration-fish? config)
          (list (mixed-text-file
                  "bashrc" (home-direnv-binary config) " hook fish | source"))
          '()))))

(define (home-direnv-zsh-extension config)
  (home-zsh-extension
    (zshrc
      (if (home-direnv-configuration-zsh? config)
          (list (mixed-text-file
                  "bashrc"
                  "eval \"$(" (home-direnv-binary config) " hook zsh)\""))
          '()))))

(define (home-direnv-packages config)
  (list (home-direnv-configuration-package config)))

(define home-direnv-service-type
  (service-type
    (name 'direnv)
    (extensions (list (service-extension home-bash-service-type
                                         home-direnv-bash-extension)
                      (service-extension home-fish-service-type
                                         home-direnv-fish-extension)
                      (service-extension home-zsh-service-type
                                         home-direnv-zsh-extension)
                      (service-extension home-profile-service-type
                                         home-direnv-packages)))
    (default-value (home-direnv-configuration))
    (description "Install and configure direnv.")))

;;;
;;; Home environment.
;;;

(home-environment
  ;; Below is the list of packages that will show up in your
  ;; Home profile, under ~/.guix-home/profile.
  (packages
    (specifications->packages
      (list "bat"
            "bison"
            "btop"
            "clang"
            "distrobox"
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
            "tmux"
            "vim-nerdtree"
            "ungoogled-chromium"
            "wl-clipboard"
            "zathura"
            "zathura-pdf-mupdf")))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
   (list (service home-bash-service-type
                  (home-bash-configuration
                   (aliases '(("grep" . "grep --color=auto")
                              ("ll" . "ls -l")
                              ("ls" . "ls -p --color=auto")))
                   (bashrc
                    (list (local-file ".bashrc" "bashrc")))
                   (bash-profile
                    (list (local-file ".bash_profile" "bash_profile")))))

         (service home-direnv-service-type)

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
                              (local-file "init.lua" "init.lua"))
                        (nvim-tree-sitter tree-sitter-bash "bash")
                        (nvim-tree-sitter tree-sitter-c "c")
                        (nvim-tree-sitter tree-sitter-cmake "cmake")
                        (nvim-tree-sitter tree-sitter-cpp "cpp")
                        (nvim-tree-sitter tree-sitter-json "json")
                        (nvim-tree-sitter tree-sitter-lua "lua")
                        (nvim-tree-sitter tree-sitter-markdown "markdown")
                        (nvim-tree-sitter tree-sitter-meson "meson")
                        (nvim-tree-sitter tree-sitter-org "org")
                        (nvim-tree-sitter tree-sitter-python "python")
                        (nvim-tree-sitter tree-sitter-ruby "ruby")
                        (nvim-tree-sitter tree-sitter-rust "rust")
                        (nvim-tree-sitter tree-sitter-scala "scala")
                        (nvim-tree-sitter tree-sitter-scheme "scheme")
                        (nvim-tree-sitter tree-sitter-slint-unofficial "slint")))

         (service home-files-service-type
                  (list (list ".local/share/fonts/DejaVuSans.ttf"
                              (file-append font-dejavu "/share/fonts/truetype/DejaVuSans.ttf"))
                        (list ".var/app/com.visualstudio.code/config/Code/User/settings.json"
                              (local-file "vscode-settings.json" "settings.json")))))))
