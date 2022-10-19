#!/usr/bin/env bash

# ========================================================================
# 	Setup repositories
# ========================================================================

# speed up dnf
sudo echo "fastestmirror=True" >> /etc/dnf/dnf.conf
sudo echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
sudo echo "keepcache=True" >> /etc/dnf/dnf.conf

# enable rpmfusion
sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# enable flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-modify --enable flathub

# ========================================================================
# 	Install and remove packages
# ========================================================================

# remove unnecessary packages
sudo dnf -y remove gnome-shell-extension-background-logo totem cheese gnome-maps rhythmbox libre-office-*
sudo dnf -y autoremove

# update system packages
sudo dnf -y upgrade --refresh

# install multimedia codecs
sudo dnf -y groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

PACKAGE_LIST=(
    emacs
    nvidia-driver
    nvidia-vaapi-driver
    steam
    transmission
    vlc
    zile
)

FLATPAK_LIST=(
    flathub com.spotify.Client
    flathub org.gnome.World.Secrets
    flathub com.usebottles.bottles
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


# ========================================================================
# 	Gnome settings
# ========================================================================

gsettings set org.gnome.desktop.interface monospace-font-name 'Source Code Pro 12'
gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'

gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'minimize'
gsettings set org.gnome.desktop.wm.preferences theme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

gsettings set org.gnome.desktop.calendar show-weekdate true


# ========================================================================
# 	Keybindings
# ========================================================================

gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings close "['<Control>q']"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super>t"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "gnome-terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Launch terminal"


# ========================================================================
# 	Dotfiles
# ========================================================================

make clean
make copy

printf "************************************************************************\n"
printf "                    Script executed successfully.                       \n"
printf "      Please reboot your computer for everything to take effect.        \n"
printf "************************************************************************\n"

sleep 5
