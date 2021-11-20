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

Installing AUR Software
"
# You can solve users running this script as root with this and then doing the same for the next for statement. However I will leave this up to you.

echo "CLONING: PARU"
cd ~
git clone "https://aur.archlinux.org/paru.git"
cd ${HOME}/paru
makepkg -si --noconfirm
cd ~
touch "$HOME/.cache/zshhistory"
git clone "https://github.com/ChrisTitusTech/zsh"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/powerlevel10k
ln -s "$HOME/zsh/.zshrc" $HOME/.zshrc

PKGS=(
'beignet-git'
'btop'
#'brave-bin' # Brave Browser
'dxvk-bin' # DXVK DirectX to Vulcan
'lightly-git'
#'lightlyshaders-git'
'lineageos-devel'
'microsoft-edge-dev-bin'
'nerd-fonts-complete'
'newflasher-git'
#'noto-fonts-emoji'
'octopi-dev'
'octopi-notifier-frameworks'
'pacaur'
'pikaur'
'papirus-icon-theme'
'ocs-url' # install packages from websites
'sddm-nordic-theme-git'
'stacer'
'teamviewer'
#'ttf-wps-fonts'
#'wps-office'
'xperia-flashtool-git'
'youtube-dl'
)

for PKG in "${PKGS[@]}"; do
    paru -S --noconfirm $PKG
done

export PATH=$PATH:~/.local/bin
cp -r $HOME/ArchTitus/dotfiles/* $HOME/.config/
pip install konsave
konsave -i $HOME/ArchTitus/kde.knsv
sleep 1
konsave -a kde

echo -ne "
-------------------------------------------------------------------------
                    SYSTEM READY FOR 3-post-setup.sh
-------------------------------------------------------------------------
"
exit
