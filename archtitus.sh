#!/bin/bash
# Find the name of the folder the scripts are in
export SCRIPTHOME="$(basename -- $PWD)"
    setfont ter-v22b
    bash startup.sh
    bash 0-preinstall.sh
    source /mnt/root/ArchTitus/install.conf
    arch-chroot /mnt /root/ArchTitus/ArchTitus/1-setup.sh
    arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/ArchTitus/ArchTitus/2-user.sh
    arch-chroot /mnt /root/ArchTitus/ArchTitus/3-post-setup.sh
