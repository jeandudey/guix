(use-modules (gnu bootloader)
             (gnu bootloader u-boot)
             (gnu machine)
             (gnu machine ssh)
             (gnu packages admin)
             (gnu packages bootloaders)
             (gnu packages containers)
             (gnu packages certs)
             (gnu packages linux)
             (gnu packages ssh)
             (gnu packages terminals)
             (gnu services admin)
             (gnu services avahi)
             (gnu services base)
             (gnu services certbot)
             (gnu services desktop)
             (gnu services networking)
             (gnu services monitoring)
             (gnu services security)
             (gnu services ssh)
             (gnu services shepherd)
             (gnu services web)
             (gnu system file-systems)
             (gnu system nss)
             (gnu system uuid)
             (guix gexp))

(define %system
  (operating-system
   (host-name "rockpro64")
   (timezone "Europe/Madrid")
   (locale "es_ES.utf8")

   (bootloader (bootloader-configuration
                (targets (list "/dev/mmcblk2"))
                (bootloader u-boot-rockpro64-rk3399-bootloader)))
  
   (initrd-modules '())
   (kernel linux-libre-arm64-generic)
   (kernel-arguments '("console=ttyS2,1500000"))
  
   (file-systems (cons* (file-system
                          (device (uuid "4bc5b0a7-9a37-428f-ac3e-e7720d5d5c07"))
                          (mount-point "/")
                          (type "ext4")
                          (flags '(no-atime)))
                        %base-file-systems))
  
   (users (cons* (user-account (name "jeandudey")
                               (comment "Jean-Pierre De Jesus DIAZ")
                               (group "users")
                               (supplementary-groups '("wheel")))
                 %base-user-accounts))
  
   (name-service-switch %mdns-host-lookup-nss)
  
   (packages
    (cons* lm-sensors
           nss-certs
           %base-packages))

   (services
    (cons* (service dhcp-client-service-type)

           (service ntp-service-type)

           (service openssh-service-type)

           (service unattended-upgrade-service-type)

           (service elogind-service-type)

           ;; Install alacritty terminfo files so that programs over SSH
           ;; display colors correctly, without installing alacritty
           ;; completely.
           (extra-special-file
             "/usr/share/terminfo/a/alacritty"
             (file-append alacritty "/share/terminfo/a/alacritty"))

           (extra-special-file
             "/usr/share/terminfo/a/alacritty-direct"
             (file-append alacritty "/share/terminfo/a/alacritty-direct"))

           %base-services))))

%system
