# ArchTitus Installer Script

<img src=./titusarch.png />

This README contains all the steps to have a fully functional Arch Linux with KDE desktop, suited ideally for Android devs


## System Description
This is a completely automated arch install of the KDE desktop environment on Arch Linux. 
Now though, the user has the abillity to choose their own desktop; GNOME, KDE, XFCE, MATE, BUDGIE, CINNAMON, DEEPIN, LXDE, OPENBOX, XFCE

## Special Feature
Network Manager is replaced with Connection Manager (connman), and after your first boot you will need to open Connman UI Setup from the applications menu.
You will want to set in the preferences to `Enable Start Options from GUI`, `Retain State`, `Enable Tooltips`, `Advanced Control`, `Start Minimized`, `Enable Autostart`
Also wpa suppicant is replaced with iwd, and if you find you have an issue with bluetooth, then try to disable iwd, unmask wpa supplicant, enable bluetooth, and then re-enable iwd and mask wpa supplicant.

## Create Arch ISO
Download ArchISO from [HERE](https://archlinux.org/download/) and put it on a USB drive with [Etcher](https://www.balena.io/etcher/), [Ventoy](https://www.ventoy.net/en/index.html), or [Rufus](https://rufus.ie/en/)
or on linux you can use dd command

## Boot Arch ISO
From the initial prompt type the following commands:

```
pacman -Sy git && git clone https://github.com/yehonatan2020/ArchTitus && cd A* && ./archtitus.sh
```
## For Wifi
1: Run `iwctl`

2: Run `device list`, and find your device name.

3: Run `station [device name] scan`

4: Run `station [device name] get-networks`

5: Find your network, and run `station [device name] connect [network name]`

6: Enter your password and run `exit`. You can test if you have internet connection by running `ping google.com`. 

## Troubleshooting
__[Arch Linux Installation Guide](https://github.com/rickellis/Arch-Linux-Install-Guide)__

## Credits
- Original packages script was a post install cleanup script called ArchMatic located here: https://github.com/rickellis/ArchMatic
- Thanks to ChrisTitus as this is a fork from his work
