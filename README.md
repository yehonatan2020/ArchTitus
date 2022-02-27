# ArchTitus Installer Script

<img src="https://i.imgur.com/YiNMnan.png" />

This README contains all the steps to have a fully functional Arch Linux with KDE desktop, suited ideally for Android devs

---
## Create Arch ISO

Download ArchISO from [HERE](https://archlinux.org/download/) and put it on a USB drive with [Etcher](https://www.balena.io/etcher/), [Ventoy](https://www.ventoy.net/en/index.html), or [Rufus](https://rufus.ie/en/)
or on linux you can use dd command


## Boot Arch ISO

From the initial prompt type the following commands:

```
pacman -Sy git
git clone https://github.com/yehonatan2020/ArchTitus
cd ArchTitus
./archtitus.sh
```

### System Description
This is completely automated arch install of the KDE desktop environment on arch.

#Special Feature
Network Manager is replaced with Connection Manager (connman), and after your first boot you will need to open Connman UI Setup from the applications menu.
You will want to set in the preferences to `Enable Start Options from GUI`, `Retain State`, `Enable Tooltips`, `Advanced Control`, `Start Minimized`, `Enable Autostart`
Also wpa suppicant is replaced with iwd, and if you find you have an issue with bluetooth, then try to disable iwd, unmask wpa supplicant, enable bluetooth, and then re-enable iwd and mask wpa supplicant.

## Troubleshooting

__[Arch Linux Installation Guide](https://github.com/rickellis/Arch-Linux-Install-Guide)__

### For Wifi

#1: Run `iwctl`

#2: Run `device list`, and find your device name.

#3: Run `station [device name] scan`

#4: Run `station [device name] get-networks`

#5: Find your network, and run `station [device name] connect [network name]`, enter your password and run `exit`. You can test if you have internet connection by running `ping google.com`. 

## Credits

- Original packages script was a post install cleanup script called ArchMatic located here: https://github.com/rickellis/ArchMatic
- Thank you to all the folks that helped during the creation from YouTube Chat! Here are all those Livestreams showing the creation: <https://www.youtube.com/watch?v=IkMCtkDIhe8&list=PLc7fktTRMBowNaBTsDHlL6X3P3ViX3tYg>
