#!/usr/bin/bash
set -o verbose
set -o xtrace

################################################################################
# Prepare disk
################################################################################
sgdisk /dev/sda --zap-all
sgdisk /dev/sda -n 1:0:0 -t 1:8300 -A 1:set:2
mkfs.ext4 -T small -O \^64bit /dev/sda1
mount /dev/sda1 /mnt

################################################################################
# Install mini-base
################################################################################
cat <<-'EOF' > /etc/pacman.d/mirrorlist
	Server = http://mirrors.kernel.org/archlinux/$repo/os/$arch
EOF
cat <<-'EOF' > /etc/pacman.conf
	[options]
	HoldPkg = pacman glibc
	Architecture = auto
	SigLevel = Required DatabaseOptional
	LocalFileSigLevel = Optional
	CheckSpace
	# You might need some of these!
	NoExtract = usr/lib/libgo.*
	NoExtract = usr/lib/libgfortran
	NoExtract = usr/bin/systemd-analyze
	NoExtract = usr/bin/sqldiff
	NoExtract = usr/bin/showdb
	NoExtract = usr/bin/showwal
	NoExtract = usr/bin/showjournal
	NoExtract = usr/bin/showstat4
	NoExtract = usr/lib/gconv/*
	NoExtract = usr/lib/firmware/*
	NoExtract = usr/share/file/*
	NoExtract = usr/share/kbd/*
	NoExtract = usr/share/iana-etc/*
	NoExtract = usr/lib/udev/hwdb.d/*
	# Uncritical
	NoExtract = usr/share/man/*
	NoExtract = usr/share/doc/*
	NoExtract = usr/share/locale/*
	NoExtract = usr/include/*
	NoExtract = usr/share/i18n/*
	NoExtract = usr/share/info/*
	NoExtract = usr/share/licenses/*
	NoExtract = usr/share/gtk-doc/*
	NoExtract = usr/share/texinfo/*
	NoExtract = usr/share/zoneinfo/*
	NoExtract = !usr/share/zoneinfo/UTC
	# Terminfo
	NoExtract = usr/share/terminfo/*
	NoExtract = !usr/share/terminfo/l/*
	NoExtract = !usr/share/terminfo/x/*
	# Kernel modules
	NoExtract = usr/lib/modules/*
	NoExtract = !usr/lib/modules/*/extramodules
	NoExtract = !usr/lib/modules/extramodules-*-ARCH/version
	NoExtract = !usr/lib/modules/extramodules-*-ARCH/vboxguest.ko.gz
	NoExtract = !usr/lib/modules/extramodules-*-ARCH/vboxsf.ko.gz
	NoExtract = !usr/lib/modules/extramodules-*-ARCH/vboxvideo.ko.gz
	NoExtract = !usr/lib/modules/*/modules.*
	NoExtract = !usr/lib/modules/*/extramodules/vboxguest.ko.gz
	NoExtract = !usr/lib/modules/*/extramodules/vboxsf.ko.gz
	NoExtract = !usr/lib/modules/*/extramodules/vboxvideo.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/arch/x86/crypto/aes-x86_64.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/arch/x86/crypto/aesni-intel.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/arch/x86/crypto/crc32-pclmul.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/arch/x86/crypto/crc32c-intel.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/arch/x86/crypto/crct10dif-pclmul.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/arch/x86/crypto/ghash-clmulni-intel.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/arch/x86/crypto/glue_helper.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/arch/x86/events/intel/intel-rapl-perf.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/crypto/ablk_helper.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/crypto/cryptd.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/crypto/gf128mul.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/crypto/lrw.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/acpi/ac.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/acpi/battery.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/acpi/button.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/acpi/video.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/ata/ata_generic.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/ata/ata_piix.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/ata/libata.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/ata/pata_acpi.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/char/agp/intel-agp.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/char/agp/intel-gtt.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/char/ppdev.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/char/tpm/tpm.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/char/tpm/tpm_tis.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/char/tpm/tpm_tis_core.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/cpufreq/acpi-cpufreq.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/gpu/drm/drm.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/gpu/drm/drm_kms_helper.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/gpu/drm/ttm/ttm.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/i2c/busses/i2c-piix4.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/input/evdev.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/input/input-leds.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/input/joydev.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/input/keyboard/atkbd.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/input/misc/pcspkr.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/input/mouse/psmouse.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/input/mousedev.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/input/serio/i8042.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/input/serio/libps2.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/input/serio/serio.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/input/serio/serio_raw.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/leds/led-class.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/macintosh/mac_hid.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/net/ethernet/intel/e1000/e1000.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/net/fjes/fjes.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/net/virtio_net.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/parport/parport.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/parport/parport_pc.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/scsi/scsi_mod.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/scsi/sd_mod.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/thermal/intel_powerclamp.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/video/fbdev/core/fb_sys_fops.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/video/fbdev/core/syscopyarea.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/video/fbdev/core/sysfillrect.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/video/fbdev/core/sysimgblt.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/virtio/virtio.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/virtio/virtio_pci.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/drivers/virtio/virtio_ring.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/fs/crypto/fscrypto.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/fs/ext4/ext4.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/fs/jbd2/jbd2.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/fs/mbcache.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/lib/crc16.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/net/ipv4/netfilter/ip_tables.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/net/netfilter/x_tables.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/net/rfkill/rfkill.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/net/sched/sch_fq_codel.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/net/wireless/cfg80211.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/sound/ac97_bus.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/sound/core/snd-pcm.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/sound/core/snd-timer.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/sound/core/snd.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/sound/pci/ac97/snd-ac97-codec.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/sound/pci/snd-intel8x0.ko.gz
	NoExtract = !usr/lib/modules/*/kernel/sound/soundcore.ko.gz
	[core]
	Include = /etc/pacman.d/mirrorlist
	[extra]
	Include = /etc/pacman.d/mirrorlist
	[community]
	Include = /etc/pacman.d/mirrorlist
EOF
pacman -Sy
pacstrap /mnt filesystem linux systemd bash pacman
rm /mnt/var/cache/pacman/pkg/*
cp /etc/pacman.conf /mnt/etc/pacman.conf
ln -s /usr/share/zoneinfo/UTC /mnt/etc/localtime
cat <<-'EOF' > /mnt/etc/hostname
	archmini
EOF
cat <<-'EOF' > /mnt/etc/locale.conf
	LANG=C
EOF
cat <<-'EOF' > /mnt/etc/fstab
	tmpfs /var/log             tmpfs rw 0 0
	tmpfs /var/cache           tmpfs rw 0 0
	tmpfs /var/lib/pacman/sync tmpfs rw 0 0
EOF
cat <<-'EOF' > /mnt/etc/mkinitcpio.d/linux.preset
	ALL_config="/etc/mkinitcpio.conf"
	ALL_kver="/boot/vmlinuz-linux"
	PRESETS=('default')
	default_image="/boot/initramfs-linux.img"
EOF
rm /mnt/boot/initramfs-linux-fallback.img
arch-chroot /mnt mkinitcpio -p linux

################################################################################
# Vagrant specifics
################################################################################
arch-chroot /mnt pacman -S --noconfirm \
	systemd-sysvcompat \
	openssh \
	sudo \
	sed \
	virtualbox-guest-utils-nox \
	virtualbox-guest-modules-arch \
	iproute2 \
	netctl \
	dhcpcd
rm /mnt/var/cache/pacman/pkg/*
cat <<-'EOF' > /mnt/etc/ssh/sshd_config
	UseDNS no
EOF
cat <<-'EOF' > /mnt/etc/sudoers.d/vagrant
	vagrant ALL=(ALL) NOPASSWD: ALL
EOF
cat <<-'EOF' > /mnt/etc/netctl/wired-dhcp
	Description='A basic dhcp ethernet connection'
	Interface=enp0s3
	Connection=ethernet
	IP=dhcp
EOF
arch-chroot /mnt systemctl enable sshd.socket
arch-chroot /mnt netctl enable wired-dhcp
arch-chroot /mnt ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
arch-chroot /mnt ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
arch-chroot /mnt <<-'EOF'
	useradd -m vagrant
	chpasswd <<<"vagrant:vagrant"
	echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
	install -d -o vagrant -g vagrant -m 0700 /home/vagrant/.ssh
	curl -Lo /home/vagrant/.ssh/authorized_keys 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
	chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
	chmod 0600 /home/vagrant/.ssh/authorized_keys
EOF

################################################################################
# Install bootloader
################################################################################
arch-chroot /mnt pacman -S --noconfirm syslinux
arch-chroot /mnt syslinux-install_update -im
rm /mnt/var/cache/pacman/pkg/*
cat <<-'EOF'> /mnt/boot/syslinux/syslinux.cfg
	PROMPT 1
	TIMEOUT 1
	DEFAULT arch
	LABEL arch
	MENU LABEL Arch Linux
	LINUX ../vmlinuz-linux
	APPEND root=/dev/sda1 init=/usr/lib/systemd/systemd rw
	INITRD ../initramfs-linux.img
EOF

################################################################################
# Remove non-critical
################################################################################
arch-chroot /mnt pacman --noconfirm -Rddnsu perl texinfo
rm -rf /mnt/usr/lib/syslinux/*
rm -rf /mnt/var/log/*
rm -rf /mnt/var/cache/*
rm -rf /mnt/var/lib/pacman/sync/*
rm -rf /mnt/usr/lib/syslinux/*
rm -rf /mnt/lost+found

################################################################################
# Exit
################################################################################
cp /install.log /mnt/
dd if=/dev/zero of=/mnt/moarzeros bs=1M
rm /mnt/moarzeros
sync
umount /mnt
systemctl reboot
