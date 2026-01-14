;; -*- mode: scheme; -*-

(use-modules (gnu)
             (gnu system nss)
             (guix build-system trivial)
             (guix channels)
             (guix gexp)
             (guix packages)
             (guix utils)
             (nongnu packages linux)
             (nongnu system linux-initrd))

(use-service-modules desktop
                     docker
                     linux
                     nix
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

(operating-system
  (host-name "jeandudey")
  (timezone %timezone)
  (locale "en_US.utf8")

  (kernel linux)
  (kernel-arguments '("amd_pstate=active"
                      "rd.driver.blacklist=nouveau"
                      "modprobe.blacklist=nouveau"
                      "amdgpu.gpu_recovery=1"
                      "amdgpu.dcdebugmask=0x10"))
  (initrd microcode-initrd)
  (firmware (list linux-firmware))

  ;; Choose US English keyboard layout.  The "altgr-intl"
  ;; variant provides dead keys for accented characters.
  (keyboard-layout (keyboard-layout "es" "altgr-intl"))

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
                                        "docker" "libvirt")))
               %base-user-accounts))

  (packages (append (list gvfs
                          virt-manager)
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

                          (service containerd-service-type)

                          (service docker-service-type)

                          (service nix-service-type
                                   (nix-configuration
                                    (sandbox #f)))

                          (service kernel-module-loader-service-type
                                   '("nct6775"))

                          (service qemu-binfmt-service-type
                                   (qemu-binfmt-configuration
                                     (platforms
                                       (lookup-qemu-platforms "arm" "aarch64"))))

                          (service libvirt-service-type
                                   (libvirt-configuration
                                     (unix-sock-group "libvirt")))

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
                            (discover? #t)
                            (substitute-urls
                              (append (list "https://substitutes.nonguix.org")
                                      %default-substitute-urls))
                            (authorized-keys
                              (append (list (local-file "keys/substitutes.nonguix.org.pub"))
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
