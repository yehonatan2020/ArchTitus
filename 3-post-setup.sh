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
                    SCRIPTHOME: $SCRIPTHOME
-------------------------------------------------------------------------

Final Setup and Configurations
GRUB EFI Bootloader Install & Check
"
source /root/$SCRIPTHOME/setup.conf
if [[ -d "/sys/firmware/efi" ]]; then
    grub-install --efi-directory=/boot ${DISK}
    # set kernel parameter for decrypting the drive
if [[ "${FS}" == "luks" ]]; then
sed -i "s%GRUB_CMDLINE_LINUX_DEFAULT=\"%GRUB_CMDLINE_LINUX_DEFAULT=\"cryptdevice=UUID=${encryped_partition_uuid}:ROOT root=/dev/mapper/ROOT %g" /etc/default/grub
fi
grub-mkconfig -o /boot/grub/grub.cfg

echo -ne "
-------------------------------------------------------------------------
                    Enabling Login Display Manager
-------------------------------------------------------------------------
"
systemctl enable sddm.service
echo -ne "
-------------------------------------------------------------------------
                    Setting up SDDM Theme
-------------------------------------------------------------------------
"
cat <<EOF > /etc/sddm.conf
[Theme]
Current=Nordic
EOF

echo -ne "
-------------------------------------------------------------------------
                    Enabling Essential Services
-------------------------------------------------------------------------
"
systemctl enable apparmor
systemctl enable fstrim.timer
systemctl enable bluetooth
systemctl enable tlp
systemctl enable cups
systemctl enable NetworkManager

sudo ln -s /usr/bin/paru /usr/bin/yay
sudo rm -r /root/ArchTitus
sudo rm -r /usr/bin/baloo*
sudo rm -r /usr/lib/baloo*

echo -ne "
-------------------------------------------------------------------------
                    Cleaning 
-------------------------------------------------------------------------
"
# Remove no password sudo rights
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

rm -r /root/$SCRIPTHOME
rm -r /home/$username/$SCRIPTHOME
# Replace in the same state
cd $pwd
echo "
###############################################################################
# Done - Please Eject Install Media and Reboot
###############################################################################
"
