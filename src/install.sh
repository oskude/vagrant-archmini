#!/usr/bin/bash
set -o verbose
set -o xtrace

################################################################################
# Prepare disk
################################################################################
sgdisk /dev/sda --zap-all
sgdisk /dev/sda -n 1:0:0 -t 1:8304 -c 1:'root' -A 1:set:2
sleep 1 # without this by-partlabel is not yet populated
mkfs.ext4 -T small -O \^64bit /dev/disk/by-partlabel/root
mount /dev/disk/by-partlabel/root /mnt

################################################################################
# Install mini-base
################################################################################
cat <<-'EOF' > /etc/pacman.d/mirrorlist
	Server = http://mirrors.kernel.org/archlinux/$repo/os/$arch
EOF
cp pacman.conf /etc/pacman.conf
cp noextract /etc/pacman.d/noextract
pacstrap /mnt filesystem linux systemd bash pacman
rm /mnt/var/cache/pacman/pkg/*
cp /etc/pacman.conf /mnt/etc/pacman.conf
cp noextract /mnt/etc/pacman.d/
ln -sf /usr/share/zoneinfo/UTC /mnt/etc/localtime
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
# we don't need perl with openssl
arch-chroot /mnt pacman --noconfirm -Rddnsu perl
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
	APPEND root=PARTLABEL=root init=/usr/lib/systemd/systemd rw
	INITRD ../initramfs-linux.img
EOF

################################################################################
# Remove non-critical
################################################################################
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
