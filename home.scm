(use-modules ;(formal-verification packages emacs)
             (gnu home)
             (gnu packages)
             (gnu packages fonts)
             (gnu packages maths)
             (gnu packages shellutils)
             (gnu packages tree-sitter)
             (gnu services)
             (gnu services configuration)
             (gnu home services)
             (gnu home services desktop)
             (gnu home services guix)
             (gnu home services shells)
             (gnu home services sound)
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

;;;
;;; Home environment.
;;;

(home-environment
 (packages
  (specifications->packages
   (list "btop"
         "distrobox"
         "fd"
         "font-dejavu"
         "flatpak"
         "ghex"
         "git"
         "icecat"
         "librewolf"
         "just"
         "libreoffice"
         "neovim"
         "neovim-coqtail"
         "neovim-packer"
         "openocd"
         "openrgb"
         "openssh"
         "ripgrep"
         "speedcrunch"
         "strace"
         "tmux"
         "vim-nerdtree"
         "wl-clipboard")))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
   (list (service home-bash-service-type
                  (home-bash-configuration
                   (aliases '(("grep" . "grep --color=auto")
                              ("ll" . "ls -l")
                              ("ls" . "ls -p --color=auto")))
                   (bash-profile
                    (list (local-file ".bash_profile" "bash_profile")))
                   (bashrc
                    (list (mixed-text-file
                            "bashrc"
                            "export PATH=$PATH:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.nix-profile/bin")))))

         (service home-direnv-bash-service-type)

         (service home-dbus-service-type)

         (service home-pipewire-service-type)

         (simple-service 'custom-environment-variables
                         home-environment-variables-service-type
                         '(("EDITOR" . "nvim")
                           ("PATH" . "$PATH:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.nix-profile/bin")))

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
                        (list ".config/nvim/ftdetect/why3.vim"
                              (file-append why3 "/share/why3/vim/ftdetect/why3.vim"))
                        (list ".config/nvim/syntax/why3.vim"
                              (file-append why3 "/share/why3/vim/syntax/why3.vim"))
                        (list ".var/app/com.visualstudio.code/config/Code/User/settings.json"
                              (local-file "vscode-settings.json" "settings.json")))))))
