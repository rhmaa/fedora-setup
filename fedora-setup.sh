#!/usr/bin/env bash

#
# Repositories.
#

printf "Setting up repositories and installing packages\n"

# enable rpmfusion
sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# enable flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-modify --enable flathub

#
# Packages.
#

# remove unnecessary packages
sudo dnf -y remove gnome-shell-extension-background-logo gnome-tour totem cheese gnome-maps rhythmbox libreoffice-*
sudo dnf -y autoremove

# update system packages
sudo dnf -y upgrade --refresh

# install multimedia codecs
sudo dnf -y groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

PACKAGE_LIST=(
    emacs-nox
    nvidia-driver
    nvidia-vaapi-driver
    steam
    transmission
    vlc
    rxvt-unicode
    xclip
)

FLATPAK_LIST=(
    flathub com.spotify.Client
    flathub org.gnome.World.Secrets
    flathub com.usebottles.bottles
    flathub com.github.tchx84.Flatseal
    com.discordapp.Discord
)

# install rpm packages
for package_name in ${PACKAGE_LIST[@]}; do
    if ! sudo dnf list --installed | grep -q "^\<$package_name\>"; then
        sudo dnf install -y "$package_name"
    else
        printf "$package_name is already installed.\n"
    fi
done

# install flatpaks
for flatpak_name in ${FLATPAK_LIST[@]}; do
    printf "Installing $flatpak_name...\n"
    sleep 1
    flatpak install -y "$flatpak_name"
done

flatpak update -y

#
# Make gtk3 applications look like gtk4 applications.
#

printf "Fixing theming of legacy applications\n"

wget https://github.com/lassekongo83/adw-gtk3/releases/download/v4.2/adw-gtk3v4-2.tar.xz
tar -xf adw-gtk*.tar.xz
if [[ ! -d $HOME/.local/share/themes ]]
then
    mkdir $HOME/.local/share/themes
fi
mv adw-gtk3 $HOME/.local/share/themes/
mv adw-gtk3-dark $HOME/.local/share/themes/
rm -rf adw-gtk*.tar.xz

#
# Gnome settings.
#

printf "Setting up Gnome\n"

gsettings set org.gnome.desktop.interface monospace-font-name 'Source Code Pro 12'
gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'

gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'minimize'
gsettings set org.gnome.desktop.wm.preferences focus-mode 'mouse'
gsettings set org.gnome.desktop.wm.preferences theme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'

gsettings set org.gnome.Evince.Default dual-page true
gsettings set org.gnome.Evince.Default inverted-colors false
gsettings set org.gnome.Evince.Default continous false
gsettings set org.gnome.Evince.Default sizing-mode 'fit-page'
gsettings set org.gnome.Evince.Default show-sidebar false

gsettings get org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings get org.gnome.nautilus.list-view default-zoom-level 'small'
gsettings set org.gnome.nautilus.list-view default-visible-columns "['name', 'size', 'type', 'group', 'date_modified']"

gsettings set org.gnome.desktop.calendar show-weekdate true

gsettings set org.gnome.software allow-updates false
gsettings set org.gnome.software download-updates false

sudo sed -i 's/utilities-terminal/org.gnome.Terminal/g' /usr/share/applications/rxvt-unicode.desktop

#
# Keybinds.
#

printf "Setting up keybinds\n"

gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings move-to-center "['<Super>c']"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super>t"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "urxvt"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Launch terminal"

#
# OpenVPN
#

printf "Downloading VPN settings\n"
wget https://www.privateinternetaccess.com/openvpn/openvpn-strong.zip
unzip openvpn-strong.zip sweden.ovpn denmark.ovpn
rm openvpn-strong.zip
printf "Load the .ovpn file in the Gnome Control Panel.\n\n"

#
# Dotfiles.
#

printf "Setting up dotfiles\n"

git clone https://github.com/rhmaa/dotfiles.git
cd dotfiles
make clean
make copy
cd ~/
rm -rf ./dotfiles

printf "Script has finished execution.\n"
printf "Please reboot the computer for everything to take effect.\n\n" 

sleep 5
