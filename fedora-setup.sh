#!/bin/bash

printf "Fedora post-installation script is running..."

printf "Removing superflous software..."
sudo dnf -y remove gnome-shell-extension-background-logo totem cheese gnome-maps rhythmbox libre-office-*
sudo dnf -y autoremove

printf "Enabling third-party repositories..."
sudo dnf -y install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y install \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf -y upgrade --refresh

printf "Installing multimedia codecs..."
sudo dnf -y groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

PACKAGE_LIST=(
    emacs
    nvidia-driver
    steam
    vlc
)

for package_name in ${PACKAGE_LIST[@]}; do
    if ! sudo dnf list --installed | grep -q "^\<$package_name\>"; then
        printf "Installing $package_name..."
        sudo dnf install -y "$package_name"
        printf "$package_name installed."
    else
        printf "$package_name is already installed."
    fi
done

printf "Setting up Emacs..."
git clone https://github.com/rhmaa/emacs.d.git ~/.config/emacs
printf "alias em=\"emacs -nw\"" >> ~/.bashrc

printf "Enabling flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --enable flathub

FLATPAK_LIST=(
    flathub com.spotify.Client
    flathub org.gnome.World.Secrets
    flathub com.usebottles.bottles
    com.discordapp.Discord
)

for flatpak_name in ${FLATPAK_LIST[@]}; do
    printf "Installing $flatpak_name..."
    sleep 1
    flatpak install -y "$flatpak_name"
done

flatpak update -y

printf "Fixing the plymouth boot screen..."
sudo plymouth-set-default-theme details -R

printf "Fixing Gnome..."
gsettings set org.gnome.desktop.interface monospace-font-name 'Source Code Pro 12'
gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'

gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'minimize'
gsettings set org.gnome.desktop.wm.preferences theme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

gsettings set org.gnome.desktop.calendar show-weekdate true

printf "Script done. Reboot the system for all changes to take effect."
