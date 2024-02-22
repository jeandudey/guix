;; Este archivo "home-environment" se puede pasar a 'guix home reconfigure'
;; para reproducir el contenido de su perfil.  Esto es "simbólico": sólo
;; especifica nombres de paquete.  Para reproducir el mismo perfil exacto, también
;; necesita capturar los canales que están siendo usados, como son devueltos por "guix describe".
;; Vea la sección "Replicando Guix" en el manual.

(use-modules (foundation packages tree-sitter)
             (gnu home)
             (gnu packages)
             (gnu packages fonts)
             (gnu packages tree-sitter)
             (gnu services)
             (gnu home services)
             (gnu home services desktop)
             (gnu home services shells)
             (gnu home services sound)
             (guix gexp))

(define (nvim-tree-sitter package name)
  (list (string-append "nvim/parser/" name ".so")
        (file-append package "/lib/tree-sitter/libtree-sitter-" name ".so")))

(home-environment
  ;; Below is the list of packages that will show up in your
  ;; Home profile, under ~/.guix-home/profile.
  (packages
    (specifications->packages
      (list "bat"
            "bison"
            "btop"
            "clang"
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
            "neovim"
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
            "wl-clipboard")))

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

         (service home-dbus-service-type)

         (service home-pipewire-service-type)

         (simple-service 'custom-environment-variables
                         home-environment-variables-service-type
                         '(("CC" . "gcc")
                           ("EDITOR" . "nvim")))

         (service home-xdg-configuration-files-service-type
                  (list (list "git/config"
                              (local-file "gitconfig" "gitconfig"))
                        (list "git/ignore"
                              (local-file "gitignore" "gitignore"))
                        (list "nvim/init.lua"
                              (local-file "init.lua" "init.lua"))
                        (nvim-tree-sitter tree-sitter-bash "bash")
                        (nvim-tree-sitter tree-sitter-markdown "markdown")
                        (nvim-tree-sitter tree-sitter-meson "meson")
                        (nvim-tree-sitter tree-sitter-org "org")
                        (nvim-tree-sitter tree-sitter-rust "rust")
                        (nvim-tree-sitter tree-sitter-scheme "scheme")
                        (nvim-tree-sitter tree-sitter-slint-unofficial "slint")))

         (service home-files-service-type
                  (list (list ".local/share/fonts/DejaVuSans.ttf"
                              (file-append font-dejavu "/share/fonts/truetype/DejaVuSans.ttf"))
                        (list ".var/app/com.visualstudio.code/config/Code/User/settings.json"
                              (local-file "vscode-settings.json" "settings.json")))))))
