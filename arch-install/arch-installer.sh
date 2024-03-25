#!/usr/bin/env bash

# sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
# locale-gen
#timedatectl --no-ask-password set-ntp 1
#localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_TIME="en_US.UTF-8"
#ln -s "/usr/share/zoneinfo/${TIME_ZONE}" "/etc/localtime"

###############################################################################
# Set variables
AUR_HELPER="paru"
KEYMAP="us"
FS="btrfs"

PACMAN_PKGS=$(pwd)"/pkgs-files/pacman-pkgs.txt"
AUR_PKGS=$(pwd)"/pkgs-files/aur-pkgs.txt"
TIME_ZONE="$(curl --fail https://ipapi.co/timezone)"

###############################################################################
# Requirements
pacman -S gum

###############################################################################
# Colors
COLOR1="#1793d1"
COLOR2="#ffa69e"
COLOR3="#faf3dd"
COLOR4="#b8f2e6"
COLOR5="#2b303a"

COLOR_TEXT=$COLOR1
COLOR_TEXT_2=$COLOR4
COLOR_BORDER=$COLOR4
COLOR_WARNING=$COLOR2

###############################################################################
# Utiles
logo() {

	LOGO="
🅐 🅡 🅒 🅗  ____  ____  _    _
        (  - \(_  _)( \/\/ )
         ) _ <  )(   )    (
        (____/ (__) (__/\__)
"
	gum style "${LOGO:1:-1}" --foreground $COLOR_TEXT --border-foreground $COLOR_BORDER --margin "2 2" --padding "0 1" --border rounded --align center
}

log_error() {
    gum log "$1" -l "error" --time "ansic"
}

section() {
        gum style "$1" --bold --foreground $COLOR_TEXT --border-foreground $COLOR_BORDER --margin "2 2" --padding "1 10" --border rounded --align center
}

sub_section() {
        gum style "▌ $1" --foreground $COLOR_TEXT --background $COLOR5 --border-foreground $COLOR_BORDER --margin "2 2" --padding "0 1" --align center
}

warning_section() {
    gum style "$1" --border double --foreground $COLOR_WARNING --margin "1 1" --padding "0 1"
}

get_input() {
    local INPUT
    INPUT=$(gum input --prompt "$1" --placeholder "$2" --prompt.foreground $COLOR_TEXT_2)

    if (gum confirm --default "Keep $1 $INPUT")
    then
        echo "$INPUT"
    else
        get_input "$1" "$2"
    fi
}

get_password() {
    local PASSWORD_I
    PASSWORD_I=$(gum input --prompt "Type your Password > " --placeholder "password" --password  --prompt.foreground $COLOR_WARNING)

    local PASSWORD_I_RETYPED
    PASSWORD_I_RETYPED=$(gum input --prompt "Retype your Password > " --placeholder "password" --password  --prompt.foreground $COLOR_WARNING)

	if [[ "$PASSWORD_I" != "$PASSWORD_I_RETYPED" ]]; then
        warning_section "Passwords didn't match"
		get_password
	fi

    local PROMPT_RETYPE_PASSWORD_I
    if (gum confirm --default "Look at your password")
    then
        PROMPT_RETYPE_PASSWORD_I="Keep your Password : $PASSWORD_I"
    else
        PROMPT_RETYPE_PASSWORD_I="Keep your password"
    fi

    if (gum confirm --default "$PROMPT_RETYPE_PASSWORD_I")
    then
        echo "$PASSWORD_I"
    else
        get_password
    fi
}

confirm_pkgs_file() {
    sub_section "Confirming install file $1"
    if ( gum confirm --default "Verify pkgs file before install" )
    then
        gum pager < "$1"

        if ( gum confirm --default "Editing the file" )
        then
            $EDITOR "$1"
        fi
    fi
}

install_pacman_pkgs() {
    confirm_pkgs_file "$PACMAN_PKGS"
    sudo pacman -S --noconfirm --needed - < "$PACMAN_PKGS"
}

install_aur_pkgs() {
    pacman -S --noconfirm --needed $AUR_HELPER
    confirm_pkgs_file "$AUR_HELPER"
    $AUR_HELPER -S --noconfirm --needed - < "$AUR_PKGS"
}

get_disk() {
    DISKS_OPTIONS=$(lsblk -n --output TYPE,KNAME,SIZE)
    IFS=$'\n' DISKS_OPTIONS_SORTED=($(echo "$DISKS_OPTIONS" | awk '$1 == "disk" {print $0}' | sort -h -r -k 3))

    gum choose "${DISKS_OPTIONS_SORTED[@]}"
}

confirm_continue_installation() {
    CONFIRM="
                                
       THE NEXT SECTION WILL NUKE ALL DATA ON THE DISK    
                                

                    Do you want to proced?
"

    if (gum confirm --default "$CONFIRM"); then
        gum style "You chose to live dangerously. I like it. Proceeding   ..." --underline --margin "0 1" --foreground $COLOR_TEXT
    else
        log_error "User Aborded"
        exit
    fi
}

get_swap_size() {
    IFS=' ' read -r -A DISK <<< "$1"
    DISK_SIZE="${DISK[3]}"
    IFS="." read -r -A DISK_SIZE_INT <<< "$DISK_SIZE"
    DISK_SIZE_INT="${DISK_SIZE_INT[1]}"
    SWAP_SIZE=$(gum filter $(seq 1 $((DISK_SIZE_INT / 4))) --placeholder "Swap size")
}

###############################################################################
# Set user
section "Setup user"

sub_section "Setup username"
USERNAME_I=$(get_input "Username > " "name")

sub_section "Setup Password"
PASSWORD_I=$(get_password)

sub_section "Setup Hostname"
HOSTNAME_I=$(get_input "Hostname > " "name")

###############################################################################
# 1.5 Set keymaps & font
section "Setup Language & set locale"
localectl --no-ask-password set-keymap "${KEYMAP}"

pacman -S --noconfirm --needed ttf-jetbrains-mono
setfont ttf-jetbrains-mono

# 1.8 Update the system clock
sub_section "Update timezone"
timedatectl --no-ask-password set-timezone "${TIME_ZONE}"

###############################################################################
# 1.9 Partition the disks

section "Partition the disks"
confirm_continue_installation

sub_section "Disk selection"
DISK=$(get_disk)

SWAP_SIZE=$(get_swap_size "$DISK")

# TODO: cleanup the rest

sub_section "Format the partitions"
mkdir /mnt

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



if [[ "${DISK}" =~ "nvme" ]]; then
    sub_section "Partitioning nvme"
	partition2=${DISK}p2
	partition3=${DISK}p3
else
    sub_section "Partitioning ssd / hard drive"
	partition2=${DISK}2
	partition3=${DISK}3
fi

if [[ "${FS}" == "btrfs" ]]; then
    sub_section "File system Btrfs"
	# mkfs.vfat -F32 -n "EFIBOOT" "${partition2}"
	# mkfs.ext4 -L ROOT "${partition3}"
	# mount -t ext4 "${partition3}" "/mnt"
fi

# mount target
mkdir -p /mnt/boot/efi
mount -t vfat -L EFIBOOT /mnt/boot/


section "Mounting Arch on Main Drive"

pacstrap /mnt base base-devel linux linux-firmware vim nano sudo archlinux-keyring wget libnewt --noconfirm --needed
echo "keyserver hkp://keyserver.ubuntu.com" >>/mnt/etc/pacman.d/gnupg/gpg.conf
cp -R "${SCRIPT_DIR}" /mnt/root/
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

genfstab -L /mnt >>/mnt/etc/fstab
echo " 
  Generated /etc/fstab:
"
cat /mnt/etc/fstab


###############################################################################


timedatectl set-ntp true

# Keyring
pacman -S --noconfirm --needed archlinux-keyring

# 
pacman -S --noconfirm --needed pacman-contrib

# Mirrors
pacman -S --noconfirm --needed reflector

# Sync Utile
pacman -S --noconfirm --needed rsync
pacman -S --noconfirm --needed curl

# Greeter
pacman -S --noconfirm --needed grub


###############################################################################
# ISO
section "ISO"

ISO_COUNTRY=$(curl -4 ifconfig.co/country-iso)
sub_section "Setting up mirrors '$ISO_COUNTRY' $ISO_COUNTRY"

# Enable Parallel Downloads
sed -i 's/^#ParallelDownloads/ParallelDownloads/' "/etc/pacman.conf"

# Make backup
cp "/etc/pacman.d/mirrorlist" "/etc/pacman.d/mirrorlist.backup"

reflector -a 48 -c "$ISO_COUNTRY" -f 5 -l 20 --sort rate --save "/etc/pacman.d/mirrorlist"

section "Network Setup"

pacman -S --noconfirm --needed networkmanager dhclient
systemctl enable --now NetworkManager

section "MAKEFLAGS & COMPRESSXZ"
nc=$(grep -c ^processor /proc/cpuinfo)

TOTAL_MEM=$(cat /proc/meminfo | grep -i 'memtotal' | grep -o '[[:digit:]]*')
if [[ $TOTAL_MEM -gt 8000000 ]]; then
	sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$nc\"/g" /etc/makepkg.conf
	sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g" /etc/makepkg.conf
fi

section "Set temp user"
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

section "Set parallel downloading"
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

section "Enable multilib"
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm --needed

section "Pacman pkgs install from $PACMAN_PKGS"
install_pacman_pkgs

section "Installing ucode"
proc_type=$(lscpu)
if grep -E "GenuineIntel" <<<"${proc_type}"; then
	pacman -S --noconfirm --needed intel-ucode
elif grep -E "AuthenticAMD" <<<"${proc_type}"; then
	pacman -S --noconfirm --needed amd-ucode
fi

section "Installing Graphics drivers"
# Graphics Drivers find and install
gpu_type=$(lspci)
if grep -E "NVIDIA|GeForce" <<<"${gpu_type}"; then
	pacman -S --noconfirm --needed nvidia nvidia-xconfig
elif lspci | grep 'VGA' | grep -E "Radeon|AMD"; then
	pacman -S --noconfirm --needed xf86-video-amdgpu
else
	pacman -S --noconfirm --needed libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa
fi

section "Adding User"
if [ "$(whoami)" = "root" ]; then
	groupadd libvirt
	useradd -m -G wheel,libvirt -s "/bin/bash" "$USERNAME_I "
	echo "$USERNAME_I created, home directory created, added to wheel and libvirt group, default shell set to /bin/bash"

	# use chpasswd to enter $USERNAME_I:$password
	echo "$USERNAME_I:$PASSWORD_I" | chpasswd
	echo "$USERNAME_I password set"

	chown -R "$USERNAME_I: /home/$USERNAME_I/"

	# enter $HOSTNAME_I to /etc/hostname
	echo "$HOSTNAME_I" >/etc/hostname
else
    log_error "Not executed as root"
fi

section "Installing Aur Packages"
install_aur_pkgs
# cd "$HOME"
# mkdir "/home/$USERNAME_I/.cache"
# touch "/home/$USERNAME_I/.cache/zshhistory"


export PATH=$PATH:~/.local/bin

section "Enabling Login Display Manager"
systemctl enable gdm.service

section "Enabling systemctl Services"

systemctl enable cups.service
ntpd -qg
systemctl enable ntpd.service
systemctl disable dhcpcd.service
systemctl stop dhcpcd.service
systemctl enable NetworkManager.service
systemctl enable bluetooth
systemctl enable avahi-daemon.service

section "Cleanup"

# Remove temp user
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^%wheel ALL=(ALL:ALL) NOPASSWD: ALL/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Replace in the same state
cd "$(pwd)" || exit


INSTALL_COMPLETE=$(gum style "Installation complete!
you are on" --foreground $COLOR_TEXT --align center --underline --bold)
LOGO_COMPLETE=$(logo)
gum join --align center --vertical "$INSTALL_COMPLETE" "$LOGO_COMPLETE"
