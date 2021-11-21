#!/usr/bin/env bash
echo -ne "
-------------------------------------------------------------------------
   █████╗ ██████╗  ██████╗██╗  ██╗████████╗██╗████████╗██╗   ██╗███████╗
  ██╔══██╗██╔══██╗██╔════╝██║  ██║╚══██╔══╝██║╚══██╔══╝██║   ██║██╔════╝
  ███████║██████╔╝██║     ███████║   ██║   ██║   ██║   ██║   ██║███████╗
  ██╔══██║██╔══██╗██║     ██╔══██║   ██║   ██║   ██║   ██║   ██║╚════██║
  ██║  ██║██║  ██║╚██████╗██║  ██║   ██║   ██║   ██║   ╚██████╔╝███████║
  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝   ╚═╝    ╚═════╝ ╚══════╝
-------------------------------------------------------------------------
                    Automated Arch Linux Installer
-------------------------------------------------------------------------
"
source setup.conf
echo -ne "
-------------------------------------------------------------------------
                    Network Setup 
-------------------------------------------------------------------------
"
pacman -S networkmanager dhclient --noconfirm --needed
systemctl enable --now NetworkManager
echo -ne "
-------------------------------------------------------------------------
                    Setting up mirrors for optimal download 
-------------------------------------------------------------------------
"
pacman -S --noconfirm pacman-contrib curl
pacman -S --noconfirm reflector rsync
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

nc=$(grep -c ^processor /proc/cpuinfo)
echo -ne "
-------------------------------------------------------------------------
                    You have " $nc" cores. And
			changing the makeflags for "$nc" cores. Aswell as
				changing the compression settings.
-------------------------------------------------------------------------
"
TOTALMEM=$(cat /proc/meminfo | grep -i 'memtotal' | grep -o '[[:digit:]]*')
if [[  $TOTALMEM -gt 8000000 ]]; then
sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$nc\"/g" /etc/makepkg.conf
echo "Changing the compression settings for "$nc" cores."
sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g" /etc/makepkg.conf
fi
echo -ne "
-------------------------------------------------------------------------
                    Setup Language to US and set locale  
-------------------------------------------------------------------------
"
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone ${timezone}
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_TIME="en_US.UTF-8"

# Set keymaps
localectl --no-ask-password set-keymap ${keymap}

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

#Add parallel downloading
sed -i 's/^#Para/Para/' /etc/pacman.conf

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm
echo -ne "
-------------------------------------------------------------------------
                    Installing Base System  
-------------------------------------------------------------------------
"
PKGS=(
'mesa' # Essential Xorg First
'xorg'
'xorg-server'
'xorg-apps'
'xorg-drivers'
'xorg-xkill'
'xorg-xinit'
'plasma-desktop' # KDE Load second
'alsa-plugins' # audio plugins
'alsa-utils' # audio utils
'android-tools'
'android-udev'
'apparmor' #extra
'ark' # compression
'audiocd-kio' 
'audit'
'autoconf' # build
'automake' # build
'base'
'base-devel'
'bind'
'binutils'
'bison'
'bluedevil'
'bluez'
'bluez-libs'
'bluez-utils'
'breeze'
'breeze-gtk'
'bridge-utils'
'btrfs-progs'
'ccache'
'clang'
'clementine' #extra
'cpio' #extra
'cronie'
'cups'
'devede'
'dialog'
'dolphin'
'dosfstools'
'dtc'
'efibootmgr' # EFI boot
'egl-wayland'
'exfat-utils'
'extra-cmake-modules'
'fakeroot' #extra
'ffmpegthumbs' #extra
'filelight'
'flex'
'fuse2'
'fuse3'
'fuseiso'
'gamemode'
'gcc'
'gedit' #extra
'gedit-plugins' #extra
'gimp' # Photo editing
'git'
'gnome-contacts'
'gnome-screenshot'
'gnome-weather'
'gparted' 
'grub'
'gst-libav'
'gst-plugins-bad'
'gst-plugins-ugly'
'guake'
'gwenview'
'hardinfo'
'handbrake'
'haveged'
'hplip'
'htop'
'inetutils'
'inkscape'
'jdk-openjdk' # Java 17
'jq'
'karchive' #extra
'kauth' #extra
'kcodecs'
'kcompletion'
'kcoreaddons'
'kde-gtk-config'
'kdeplasma-addons'
'kdialog' #extra
'kgamma5'
'khotkeys'
'kinfocenter'
'konsole'
'kscreen'
'kvantum-qt5'
'kwalletmanager' #extra
'kwayland-integration'
'kwrited'
'latte-dock'
'libappindicator-gtk3'
'libdvdcss'
'libnewt'
'libtool'
'lld'
'llvm'
'lsof'
'lxtask' #extra
'lzip'
'lzop'
'make'
'mono'
'mplayer' #extra
'mpv'
'mtools' #extra
'nano'
'neofetch'
'networkmanager'
'ntfs-3g'
'ntp'
'obs-studio'
'openbsd-netcat'
'openssh'
'os-prober'
'oxygen'
'p7zip'
'pacman-contrib'
'pacmanlogviewer'
'patchelf'
'plasma-firewall'
'plasma-nm'
'plasma-pa'
'plasma-thunderbolt'
'powerdevil'
'print-manager'
'psensor'
'pulseaudio'
'pulseaudio-alsa'
'pulseaudio-bluetooth'
'python2-distlib'
'python-notify2'
'python-pip'
'python-psutil'
'python-pyqt5'
'python-pyxdg' #extra
'python-yaml'
'qemu'
'redshift' #extra
'rpm' #extra
'rsync'
'sddm'
'sddm-kcm'
#'simg2img' #removed
'sudo'
'swtpm'
'systemsettings'
'telegram-desktop' #extra
'terminus-font'
'tlp' #extra
'ttf-liberation' #extra
'traceroute'
'ufw'
'unclutter' #extra
'unrar'
'unzip'
'usbutils'
'wget'
'which'
'wine-gecko'
'wine-mono'
'xdg-desktop-portal-kde'
'xdg-user-dirs'
'xsane'
'zeroconf-ioslave'
'zip'
'zsh'
'zsh-syntax-highlighting'
'zsh-autosuggestions'
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

echo -ne "
-------------------------------------------------------------------------
                    Installing Microcode
-------------------------------------------------------------------------
"
# determine processor type and install microcode
# 
proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
	GenuineIntel)
		print "Installing Intel microcode"
		pacman -S --noconfirm intel-ucode
		proc_ucode=intel-ucode.img
		;;
	AuthenticAMD)
		print "Installing AMD microcode"
		pacman -S --noconfirm amd-ucode
		proc_ucode=amd-ucode.img
		;;
esac	
echo -ne "
-------------------------------------------------------------------------
                    Installing Graphics Drivers
-------------------------------------------------------------------------
"
# Graphics Drivers find and install
if lspci | grep -E "NVIDIA|GeForce"; then
    pacman -S nvidia --noconfirm --needed
	nvidia-xconfig
elif lspci | grep -E "Radeon"; then
    pacman -S xf86-video-amdgpu --noconfirm --needed
elif lspci | grep -E "Integrated Graphics Controller"; then
    pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
fi

echo -e "\nDone!\n"
if ! source install.conf; then
	read -p "Please enter username:" username
echo "username=$username" >> ${HOME}/ArchTitus/install.conf
fi
if [ $(whoami) = "root"  ];
then
    useradd -m -G wheel -s /bin/bash $username 
	passwd $username
	cp -R /root/ArchTitus /home/$username/
    chown -R $username: /home/$username/ArchTitus
	read -p "Please name your machine:" nameofmachine
	echo $nameofmachine > /etc/hostname
else
	echo -ne "
-------------------------------------------------------------------------
                    SYSTEM READY FOR 2-user.sh
-------------------------------------------------------------------------
"
fi

