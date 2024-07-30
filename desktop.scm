;; -*- mode: scheme; -*-

(use-modules (gnu)
             (gnu system nss)
             (guix channels)
             (guix utils)
             (guix gexp)
             (nongnu packages linux)
             (nongnu system linux-initrd))

(use-service-modules desktop
                     docker
                     linux
                     sddm
                     ssh
                     virtualization
                     xorg)

(use-package-modules certs
                     containers
                     docker
                     embedded
                     firmware
                     games
                     gnome
                     hardware
                     virtualization)

(define %timezone "Europe/Madrid")

(define %childhurd-os
  (operating-system
    (inherit %hurd-vm-operating-system)
    (timezone %timezone)
    (users (cons (user-account
                  (name "jeandudey")
                  (comment "Jean-Pierre De Jesus DIAZ")
                  (group "users")
                  (supplementary-groups '("wheel")))
                 %base-user-accounts))
    (services
     ;; Modify the SSH configuration to allow login as "root"
     ;; and as "charlie" using public key authentication.
     (modify-services (operating-system-user-services
                       %hurd-vm-operating-system)
       (openssh-service-type
        config => (openssh-configuration
                   (inherit config)
                   (authorized-keys
                    `(("jeandudey" ,(local-file "ssh/id_ed25519.pub"))))))))))


(operating-system
  (host-name "jeandudey")
  (timezone %timezone)
  (locale "en_US.utf8")

  (kernel linux)
  (kernel-arguments '("amd_pstate=active"
                      "quiet"))
  (initrd microcode-initrd)
  (firmware (list linux-firmware))

  ;; Choose US English keyboard layout.  The "altgr-intl"
  ;; variant provides dead keys for accented characters.
  (keyboard-layout (keyboard-layout "us" "altgr-intl"))

  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /boot/efi.
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets '("/boot/efi"))
                (theme
                 (grub-theme
                  (gfxmode '("1920x1080x32" "auto"))))
                (keyboard-layout keyboard-layout)))

  (file-systems (append
                 (list (file-system
                         (device (file-system-label "linux-root"))
                         (mount-point "/")
                         (type "ext4"))
                       (file-system
                         (device (file-system-label "linux-home"))
                         (mount-point "/home")
                         (type "ext4"))
                       (file-system
                         (device (uuid "D8B1-7D62" 'fat))
                         (mount-point "/boot/efi")
                         (type "vfat")))
                 %base-file-systems))

  (swap-devices (list (swap-space
                       (target "/swapfile"))))

  (users (cons (user-account
                (name "jeandudey")
                (comment "Jean-Pierre De Jesus DIAZ")
                (group "users")
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video"
                                        "kvm" "dialout"
                                        "docker")))
               %base-user-accounts))

  (packages (append (list gvfs)
                    %base-packages))

  ;; Add GNOME and Xfce---we can choose at the log-in screen
  ;; by clicking the gear.  Use the "desktop" services, which
  ;; include the X11 log-in service, networking with
  ;; NetworkManager, and more.
  (services (append (list (service gnome-desktop-service-type)

                          (service gnome-keyring-service-type)

                          (service bluetooth-service-type
                                   (bluetooth-configuration
                                     (auto-enable? #t)))

                          (service docker-service-type)

                          (service kernel-module-loader-service-type
                                   '("nct6775"))

                          (service qemu-binfmt-service-type
                                   (qemu-binfmt-configuration
                                     (platforms
                                       (lookup-qemu-platforms "arm" "aarch64"))))
                          (service hurd-vm-service-type
                                   (hurd-vm-configuration
                                     (os %childhurd-os)
                                     (disk-size (* 10000 (expt 2 20)))
                                     (memory-size 4096)))

                          (set-xorg-configuration
                            (xorg-configuration
                              (keyboard-layout keyboard-layout)))

                          (udev-rules-service 'openocd openocd)

                          (udev-rules-service 'openrgb openrgb)

                          (udev-rules-service 'steam-devices steam-devices-udev-rules))

                     (modify-services %desktop-services
                       (gdm-service-type config =>
                         (gdm-configuration
                           (inherit config)
                           (wayland? #t)))
                        
                        (guix-service-type config => (guix-configuration
                          (inherit config)
                            (substitute-urls
                              (append (list "https://substitutes.nonguix.org")
                                      %default-substitute-urls))
                            (authorized-keys
                              (append (list (plain-file "nonguix.pub"
                                                        "(public-key 
 (ecc
  (curve Ed25519)
  (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)
  )
 )"))
                                      %default-authorized-guix-keys))
                            (channels
                              (append (list (channel
                                              (name 'nonguix)
                                              (url "https://gitlab.com/nonguix/nonguix")
                                              (introduction
                                                (make-channel-introduction
                                                 "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
                                                 (openpgp-fingerprint
                                                  "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))
                                      %default-channels)))))))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
