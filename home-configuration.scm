;; Este archivo "home-environment" se puede pasar a 'guix home reconfigure'
;; para reproducir el contenido de su perfil.  Esto es "simbólico": sólo
;; especifica nombres de paquete.  Para reproducir el mismo perfil exacto, también
;; necesita capturar los canales que están siendo usados, como son devueltos por "guix describe".
;; Vea la sección "Replicando Guix" en el manual.

(use-modules (gnu home)
             (gnu packages)
             (gnu services)
             (guix gexp)
	     (gnu home services)
             (gnu home services shells))

(home-environment
  ;; Below is the list of packages that will show up in your
  ;; Home profile, under ~/.guix-home/profile.
  (packages
    (specifications->packages
      (list "bat"
            "bison"
            "btop"
            "fd"
            "flatpak"
            "flex"
            "gcc-toolchain"
            "ghex"
            "git"
            "icecat"
            "libreoffice"
            "m4"
            "make"
            "ncurses"
            "neovim"
            "openssh"
            "pkg-config"
            "ripgrep"
            "speedcrunch"
            "telegram-desktop"
            "tmux"
            "ungoogled-chromium"
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
                   (bashrc
                    (list (local-file ".bashrc" "bashrc")))
                   (bash-profile
                    (list (local-file ".bash_profile" "bash_profile")))))

        (service home-xdg-configuration-files-service-type
                 (list (list "nvim/init.lua"
                             (local-file "init.lua" "init.lua"))
                       (list "git/config"
                             (local-file "gitconfig" "gitconfig")))))))
