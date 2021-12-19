#!/bin/bash
    setfont ter-v22b
    bash startup.sh
    bash 0-preinstall.sh
    arch-chroot /mnt /root/ArchTitus/ArchTitus/1-setup.sh
    source /mnt/root/ArchTitus/ArchTitus/install.conf
    arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/ArchTitus/ArchTitus/2-user.sh
    arch-chroot /mnt /root/ArchTitus/ArchTitus/3-post-setup.sh
