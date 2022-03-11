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
                        SCRIPTHOME: ArchTitus
-------------------------------------------------------------------------

Final Setup and Configurations
GRUB EFI Bootloader Install & Check
"
source ${HOME}/ArchTitus/configs/setup.conf

if [[ -d "/sys/firmware/efi" ]]; then
  grub-install --efi-directory=/boot ${DISK}
fi
echo -ne "
-------------------------------------------------------------------------
              Grub Theming
-------------------------------------------------------------------------
"
cp -r  ${HOME}/ArchTitus/configs/usr/share/wallpaper/real-wood /usr/share/wallpapers
echo 'GRUB_COLOR_NORMAL="white/black"' >> /etc/default/grub
echo 'GRUB_COLOR_HIGHLIGHT="light-cyan/black"' >> /etc/default/grub
echo 'GRUB_BACKGROUND="/usr/share/wallpapers/real-wood/real-wood.jpg"' >> /etc/default/grub
echo -ne "
-------------------------------------------------------------------------
               Creating Grub Boot Menu
-------------------------------------------------------------------------
"
# set kernel parameter for decrypting the drive
if [[ "${FS}" == "luks" ]]; then
  sed -i "s%GRUB_CMDLINE_LINUX_DEFAULT=\"%GRUB_CMDLINE_LINUX_DEFAULT=\"cryptdevice=UUID=${ENCRYPTED_PARTITION_UUID}:ROOT root=/dev/mapper/ROOT %g" /etc/default/grub
fi
# set kernel parameter for adding splash screen
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& splash /' /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg

echo -ne "
-------------------------------------------------------------------------
               Enabling (and Theming) Login Display Manager
-------------------------------------------------------------------------
"
if [[ ${DESKTOP_ENV} == "kde" ]]; then
  systemctl enable sddm.service
if [[ ${INSTALL_TYPE} == "FULL" ]]; then
  echo -e "Setting SDDM Theme..."
  echo [Theme] >>  /etc/sddm.conf
  echo Current=Nordic >> /etc/sddm.conf
fi

elif [[ "${DESKTOP_ENV}" == "gnome" ]]; then
  systemctl enable gdm.service

elif [[ "${DESKTOP_ENV}" == "lxde" ]]; then
  systemctl enable lxdm.service

elif [[ "${DESKTOP_ENV}" == "openbox" ]]; then
  systemctl enable lightdm.service
  if [[ "${INSTALL_TYPE}" == "FULL" ]]; then
    # Set default lightdm-webkit2-greeter theme to Litarvan
    sed -i 's/^webkit_theme\s*=\s*\(.*\)/webkit_theme = litarvan #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf
    # Set default lightdm greeter to lightdm-webkit2-greeter
    sed -i 's/#greeter-session=example.*/greeter-session=lightdm-webkit2-greeter/g' /etc/lightdm/lightdm.conf
  fi

else
  if [[ ! "${DESKTOP_ENV}" == "server"  ]]; then
  sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter
  systemctl enable lightdm.service
  fi
fi

echo -ne "
-------------------------------------------------------------------------
                    Enabling Essential Services
-------------------------------------------------------------------------
"
  # services part of the base installation
  systemctl enable connman
echo "  Connection Manager enabled"
  systemctl disable NetworkManager

  # services part of full installation
  systemctl enable cups
  echo "  Cups enabled"
  ntpd -qg
  systemctl enable ntpd.service
  echo "  NTP enabled"
  systemctl disable dhcpcd.service
  echo "  DHCP disabled"
  systemctl stop dhcpcd.service
  echo "  DHCP stopped"
  systemctl enable bluetooth
  echo "  Bluetooth enabled"
  systemctl enable apparmor
  systemctl enable fstrim.timer
  echo "   fstrim enabled"
  systemctl enable iwd
  echo "   iwd enabled"
  systemctl mask wpa_supplicant
  systemctl enable tlp
  echo "   tlp enabled"
  
  sudo rm $HOME/.config/kdedefaults/kdeglobals
  touch $HOME/.config/kdedefaults/kdeglobals
  echo "[General]" >> $HOME/.config/kdedefaults/kdeglobals
  echo "ColorScheme=BreezeDark" >> $HOME/.config/kdedefaults/kdeglobals
   echo "[Icons]" >> $HOME/.config/kdedefaults/kdeglobals
   echo "Theme=breeze-dark" >> $HOME/.config/kdedefaults/kdeglobals
    echo "[KDE]" >> $HOME/.config/kdedefaults/kdeglobals
     echo "[widgetStyle=kvantum]" >> $HOME/.config/kdedefaults/kdeglobals
       kvantummanager --set Qogir-dark
   
   sudo ln -S /usr/bin/gnome-text-editor /usr/bin/gedit
   sudo ln -S /usr/bin/paru /usr/bin/yay
    sudo rm -r /usr/bin/baloo*
  sudo rm -r /usr/lib/baloo*
  rm -r ${HOME}/powerlevel10k
  rm -r ${HOME}/paru
  rm -r ${HOME}/zsh

if [[ "${FS}" == "luks" || "${FS}" == "btrfs" ]]; then
echo -ne "
-------------------------------------------------------------------------
                    Creating Snapper Config
-------------------------------------------------------------------------
"

SNAPPER_CONF="$HOME/ArchTitus/configs/etc/snapper/configs/root"
mkdir -p /etc/snapper/configs/
cp -rfv ${SNAPPER_CONF} /etc/snapper/configs/

SNAPPER_CONF_D="$HOME/ArchTitus/configs/etc/conf.d/snapper"
mkdir -p /etc/conf.d/
cp -rfv ${SNAPPER_CONF_D} /etc/conf.d/

fi

echo -ne "
-------------------------------------------------------------------------
               Enabling (and Theming) Plymouth Boot Splash
-------------------------------------------------------------------------
"
PLYMOUTH_THEMES_DIR="$HOME/ArchTitus/configs/usr/share/plymouth/themes"
PLYMOUTH_THEME="arch-glow" # can grab from config later if we allow selection
mkdir -p /usr/share/plymouth/themes
echo 'Installing Plymouth theme...'
cp -rf ${PLYMOUTH_THEMES_DIR}/${PLYMOUTH_THEME} /usr/share/plymouth/themes
if  [[ "${FS}" == "luks" ]]; then
  sed -i 's/HOOKS=(base udev*/& plymouth/' /etc/mkinitcpio.conf # add plymouth after base udev
  sed -i 's/HOOKS=(base udev \(.*block\) /&plymouth-/' /etc/mkinitcpio.conf # create plymouth-encrypt after block hook
else
  sed -i 's/HOOKS=(base udev*/& plymouth/' /etc/mkinitcpio.conf # add plymouth after base udev
fi
plymouth-set-default-theme -R arch-glow # sets the theme and runs mkinitcpio
echo 'Plymouth theme installed'

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

rm -r $HOME/ArchTitus
rm -r /home/$USERNAME/ArchTitus
rm -r $HOME/powerlevel10k
rm -r /home/$USERNAME/powerlevel10k
rm -r $HOME/zsh
rm -r /home/$USERNAME/zsh
rm -r $HOME/paru
rm -r /home/$USERNAME/paru
rm -r $HOME/*log
rm -r /home/$USERNAME/*log

# Replace in the same state
cd $pwd
