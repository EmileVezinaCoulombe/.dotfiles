#!/usr/bin/env bash

logo() {
	echo -ne "
    ╭────────────────────────────────╮
    │🅐 🅡 🅒 🅗  ____  ____  _    _     │
    │        (  - \(_  _)( \/\/ )    │
    │         ) _ <  )(   )    (     │
    │        (____/ (__) (__/\__)    │
    ╰────────────────────────────────╯
"
}

###############################################################################
# Set user

get_password() {
	read -rs -p "Please enter password: " PASSWORD1
	echo -ne "\n"
	read -rs -p "Please re-enter password: " PASSWORD2
	echo -ne "\n"
	if [[ "$PASSWORD1" == "$PASSWORD2" ]]; then
		RESULT="$PASSWORD1"
	else
		echo -ne "ERROR! Passwords do not match. \n"
		get_password
	fi
}

# Set user name info
read -p "What's your litle user name: " USERNAME

get_password
PASSWORD="$RESULT"

read -rep "Now send me your hostname: " NAME_OF_MACHINE

###############################################################################
# Set variables
CWD="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
USER_DOTFILES_PATH="/home/$USERNAME/.dotfiles/"
USER_CWD="/home/$USERNAME/.dotfiles/arch-installer/"
PACMAN_PKGS="pacman-pkgs.txt"
AUR_PKGS="aur-pkgs.txt"

TIME_ZONE="$(curl --fail https://ipapi.co/timezone)"
AUR_HELPER="paru"

###############################################################################
# Keyboard mapping.
KEYMAP=us

###############################################################################
# File systems


###############################################################################
# TODO

timedatectl set-ntp true

pacman -S --noconfirm archlinux-keyring
pacman -S --noconfirm --needed pacman-contrib ttf-jetbrains-mono reflector rsync grub

setfont ttf-jetbrains-mono

###############################################################################
# ISO

echo "

╭────────────────────────────────╮
│  Setting up                    │  
│  '$ISO_COUNTRY' $ISO_COUNTRY   │
│  mirrors for faster downloads  │
╰────────────────────────────────╯

"

ISO_COUNTRY=$(curl -4 ifconfig.co/country-iso)

# Enable Parallel Downloads
sed -i 's/^#ParallelDownloads/ParallelDownloads/' "/etc/pacman.conf"

# Make backup
cp "/etc/pacman.d/mirrorlist" "/etc/pacman.d/mirrorlist.backup"

reflector -a 48 -c "$ISO_COUNTRY" -f 5 -l 20 --sort rate --save "/etc/pacman.d/mirrorlist"

###############################################################################
# Disk selection
echo "

                          
       THIS WILL NUKE ALL DATA ON THE DISK    
                           

"
echo -ne "    Do you want to proceed? (y/n): \n   "
read choice

case "$choice" in
y | Y | yes | Yes)
	logo
	echo -e "You chose to live dangerously. I like it. Proceeding   ... \n"
	;;
n | N | no | No)
	echo "You chose no. Exiting..."
	exit
	;;
*)
	echo "Invalid choice. Please enter 'y' or 'n'."
	;;
esac

# options=($(lsblk -n --output TYPE,KNAME,SIZE | awk '$1=="disk"{print "/dev/"$2"|"$3}'))
# disk=${options[$?]%|*}
disk=$(lsblk -n --output KNAME,SIZE -t disk | awk '{print "/dev/"$1"|"$2}' | tail -n 1)
echo "Disk : ${disk%|*}"
echo "Size : ${disk#*|}"
DISK="${disk%|*}"

MOUNT_OPTIONS "noatime,compress=zstd,ssd,commit=120"
mkdir /mnt &>/dev/null # Hiding error message if any
pacman -S --noconfirm --needed gptfdisk btrfs-progs glibc

umount -A --recursive /mnt # make sure everything is unmounted before we start
# disk prep
sgdisk -Z "${DISK}"         # zap all on disk
sgdisk -a 2048 -o "${DISK}" # new gpt disk 2048 alignment

# create partitions
sgdisk -n 1::+1M --typecode=1:ef02 --change-name=1:'BIOSBOOT' "${DISK}"  # partition 1 (BIOS Boot Partition)
sgdisk -n 2::+300M --typecode=2:ef00 --change-name=2:'EFIBOOT' "${DISK}" # partition 2 (UEFI Boot Partition)
sgdisk -n 3::-0 --typecode=3:8300 --change-name=3:'ROOT' "${DISK}"       # partition 3 (Root), default start, remaining
if [[ ! -d "/sys/firmware/efi" ]]; then                                  # Checking for bios system
	sgdisk -A 1:set:2 "${DISK}"
fi
partprobe "${DISK}" # reread partition table to ensure it is correct

###############################################################################
# Filesystems

echo "

╭────────────────────────╮
│  Creating Filesystems  │
╰────────────────────────╯

"

if [[ "${DISK}" =~ "nvme" ]]; then
	partition2=${DISK}p2
	partition3=${DISK}p3
else
	partition2=${DISK}2
	partition3=${DISK}3
fi

if [[ "${FS}" == "ext4" ]]; then
	mkfs.vfat -F32 -n "EFIBOOT" "${partition2}"
	mkfs.ext4 -L ROOT "${partition3}"
	mount -t ext4 "${partition3}" "/mnt"
fi

# mount target
mkdir -p /mnt/boot/efi
mount -t vfat -L EFIBOOT /mnt/boot/

echo "

╭──────────────────────╮
│  Arch on Main Drive  │
╰──────────────────────╯

"

pacstrap /mnt base base-devel linux linux-firmware vim nano sudo archlinux-keyring wget libnewt --noconfirm --needed
echo "keyserver hkp://keyserver.ubuntu.com" >>/mnt/etc/pacman.d/gnupg/gpg.conf
cp -R "${SCRIPT_DIR}" /mnt/root/
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

genfstab -L /mnt >>/mnt/etc/fstab
echo " 
  Generated /etc/fstab:
"
cat /mnt/etc/fstab

echo "

╭───────────────────────╮
│  GRUB install & check │
╰───────────────────────╯

"

if [[ ! -d "/sys/firmware/efi" ]]; then
	grub-install --boot-directory=/mnt/boot "${DISK}"
else
	pacstrap /mnt efibootmgr --noconfirm --needed
fi

echo -ne "
-------------------------------------------------------------------------
                    Network Setup 
-------------------------------------------------------------------------
"
pacman -S --noconfirm --needed networkmanager dhclient
systemctl enable --now NetworkManager

echo -ne "
-------------------------------------------------------------------------
                    Setting up mirrors for optimal download 
-------------------------------------------------------------------------
"
pacman -S --noconfirm --needed pacman-contrib curl
pacman -S --noconfirm --needed reflector rsync grub arch-install-scripts git
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

nc=$(grep -c ^processor /proc/cpuinfo)

echo -ne "
-------------------------------------------------------------------------
                    You have '$nc' cores. And
			changing the makeflags for '$nc' cores. Aswell as
				changing the compression settings.
-------------------------------------------------------------------------
"

TOTAL_MEM=$(cat /proc/meminfo | grep -i 'memtotal' | grep -o '[[:digit:]]*')
if [[ $TOTAL_MEM -gt 8000000 ]]; then
	sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$nc\"/g" /etc/makepkg.conf
	sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g" /etc/makepkg.conf
fi

echo -ne "
-------------------------------------------------------------------------
                    Setup Language to US and set locale
-------------------------------------------------------------------------
"
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone "${TIME_ZONE}"
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_TIME="en_US.UTF-8"
ln -s "/usr/share/zoneinfo/${TIME_ZONE}" "/etc/localtime"
# Set keymaps
localectl --no-ask-password set-keymap "${KEYMAP}"

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

#Add parallel downloading
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm --needed

echo -ne "
-------------------------------------------------------------------------
                    Installing Base System
-------------------------------------------------------------------------
"
# sed $INSTALL_TYPE is using install type to check for MINIMAL installation, if it's true, stop
# stop the script and move on, not installing any more packages below that line

while IFS= read line; do
	echo "INSTALLING: ${line}"
	sudo pacman -S --noconfirm --needed "${line}"
done <"$PACMAN_PKGS"

echo -ne "
-------------------------------------------------------------------------
                    Installing Microcode
-------------------------------------------------------------------------
"
# determine processor type and install microcode
proc_type=$(lscpu)
if grep -E "GenuineIntel" <<<"${proc_type}"; then
	echo "Installing Intel microcode"
	pacman -S --noconfirm --needed intel-ucode
	proc_ucode=intel-ucode.img
elif grep -E "AuthenticAMD" <<<"${proc_type}"; then
	echo "Installing AMD microcode"
	pacman -S --noconfirm --needed amd-ucode
	proc_ucode=amd-ucode.img
fi

echo -ne "
-------------------------------------------------------------------------
                    Installing Graphics Drivers
-------------------------------------------------------------------------
"
# Graphics Drivers find and install
gpu_type=$(lspci)
if grep -E "NVIDIA|GeForce" <<<"${gpu_type}"; then
	pacman -S --noconfirm --needed nvidia
	nvidia-xconfig
elif lspci | grep 'VGA' | grep -E "Radeon|AMD"; then
	pacman -S --noconfirm --needed xf86-video-amdgpu
elif grep -E "Integrated Graphics Controller" <<<"${gpu_type}"; then
	pacman -S --noconfirm --needed libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa
elif grep -E "Intel Corporation UHD" <<<"${gpu_type}"; then
	pacman -S --needed --noconfirm libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa
fi

echo -ne "
-------------------------------------------------------------------------
                    Adding User
-------------------------------------------------------------------------
"
if [ "$(whoami)" = "root" ]; then
	groupadd libvirt
	useradd -m -G wheel,libvirt -s "/bin/bash" "$USERNAME "
	echo "$USERNAME created, home directory created, added to wheel and libvirt group, default shell set to /bin/bash"

	# use chpasswd to enter $USERNAME:$password
	echo "$USERNAME:$PASSWORD" | chpasswd
	echo "$USERNAME password set"

	cp -R "$HOME/dotfiles" "$USER_DOTFILES_PATH"
	chown -R "$USERNAME: /home/$USERNAME/"
	echo "Dotfiles copied to home directory"

	# enter $NAME_OF_MACHINE to /etc/hostname
	echo "$NAME_OF_MACHINE" >/etc/hostname
else
	echo "You are already a user proceed with aur installs"
fi

echo -ne "
-------------------------------------------------------------------------
                    Installing Aur Packages
-------------------------------------------------------------------------
"

cd "$HOME"
mkdir "/home/$USERNAME/.cache"
touch "/home/$USERNAME/.cache/zshhistory"

cd "$HOME"
git clone "https://aur.archlinux.org/$AUR_HELPER.git"
cd "$HOME/$AUR_HELPER"
makepkg -si --noconfirm
cd "$HOME"

while IFS= read line; do
	echo "INSTALLING: ${line}"
	$AUR_HELPER -S --noconfirm --needed "${line}"
done <"$AUR_PKGS"

export PATH=$PATH:~/.local/bin

echo -ne "
-------------------------------------------------------------------------
Final Setup and Configurations
GRUB EFI Bootloader Install & Check
-------------------------------------------------------------------------
"

if [[ -d "/sys/firmware/efi" ]]; then
	grub-install --efi-directory=/boot "${DISK}"
fi

echo -ne "
-------------------------------------------------------------------------
               Creating (and Theming) Grub Boot Menu
-------------------------------------------------------------------------
"
# set kernel parameter for decrypting the drive
if [[ "${FS}" == "luks" ]]; then
	sed -i "s%GRUB_CMDLINE_LINUX_DEFAULT=\"%GRUB_CMDLINE_LINUX_DEFAULT=\"cryptdevice=UUID=${ENCRYPTED_PARTITION_UUID}:ROOT root=/dev/mapper/ROOT %g" /etc/default/grub
fi
# set kernel parameter for adding splash screen
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& splash /' /etc/default/grub

echo -ne "
-------------------------------------------------------------------------
               Enabling (and Theming) Login Display Manager
-------------------------------------------------------------------------
"

systemctl enable gdm.service

echo -ne "
-------------------------------------------------------------------------
                    Enabling Essential Services
-------------------------------------------------------------------------
"

systemctl enable cups.service
echo "  Cups enabled"
ntpd -qg
systemctl enable ntpd.service
echo "  NTP enabled"
systemctl disable dhcpcd.service
echo "  DHCP disabled"
systemctl stop dhcpcd.service
echo "  DHCP stopped"
systemctl enable NetworkManager.service
echo "  NetworkManager enabled"
systemctl enable bluetooth
echo "  Bluetooth enabled"
systemctl enable avahi-daemon.service
echo "  Avahi enabled"

echo -ne "
-------------------------------------------------------------------------
                    Cleaning
-------------------------------------------------------------------------
"
# Remove no password sudo rights
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^%wheel ALL=(ALL:ALL) NOPASSWD: ALL/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Replace in the same state
cd "$(pwd)"
