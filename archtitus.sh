#!/bin/bash
# Find the name of the folder the scripts are in
export SCRIPTHOME="$(basename -- $PWD)"
    setfont ter-v22b
    bash startup.sh
    bash 0-preinstall.sh
    source /mnt/root/$SCRIPTHOME/install.conf
    SCRIPTHOME=$SCRIPTHOME arch-chroot /mnt /root/$SCRIPTHOME/1-setup.sh
    SCRIPTHOME=$SCRIPTHOME arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/$SCRIPTHOME/2-user.sh
    SCRIPTHOME=$SCRIPTHOME arch-chroot /mnt /root/$SCRIPTHOME/3-post-setup.sh
