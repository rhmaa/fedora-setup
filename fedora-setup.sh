#!/bin/bash

echo "Fedora post-installation script is running..."

echo "Removing superflous software..."
sleep 1
sudo dnf -y remove gnome-shell-extension-background-logo totem cheese gnome-maps rhythmbox
sudo dnf -y autoremove

echo "Enabling third-party repositories..."
sleep 1
sudo dnf -y install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y install \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf -y upgrade --refresh

echo "Installing multimedia codecs..."
sleep 1
sudo dnf -y groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

PACKAGE_LIST=(
    emacs
    golang
    nvidia-driver
    steam
    vlc
)

for package_name in ${PACKAGE_LIST[@]}; do
    if ! sudo dnf list --installed | grep -q "^\<$package_name\>"; then
        echo "Installing $package_name..."
        sleep 1
        sudo dnf install -y "$package_name"
        echo "$package_name installed."
    else
        echo "$package_name is already installed."
    fi
done

echo "Setting up git..."
sleep 1
git config --global user.name "Rikard Hevosmaa"
git config --global user.email "rikard@hevosmaa.net"
git config --global core.editor "emacs -Q -nw"

echo "Setting up a Go programming workspace..."
sleep 1
mkdir -p $HOME/Code/go/{bin,pkg,src}
echo GOPATH=$HOME/Code/go >> ~/.bashrc
echo PATH=$PATH:$GOPATH/bin >> ~/.bashrc

echo "Setting up Emacs..."
sleep 1
git clone https://github.com/hevosmaa/emacs.d.git ~/.config/emacs
echo "alias em=\"emacs -nw\"" >> ~/.bashrc

echo "Enabling flathub..."
sleep 1
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --enable flathub

FLATPAK_LIST=(
    flathub com.spotify.Client
    flathub org.gnome.World.Secrets
    flathub com.usebottles.bottles
    com.discordapp.Discord
)

for flatpak_name in ${FLATPAK_LIST[@]}; do
    echo "Installing $flatpak_name..."
    sleep 1
    flatpak install -y "$flatpak_name"
done

flatpak update -y

echo "Fixing the plymouth boot screen..."
sudo plymouth-set-default-theme details -R

echo "Fixing Gnome..."
gsettings set org.gtk.Settings.FileChooser sort-directories-first true
gsettings set org.gtk.Settings.FileChooser show-type-column true
gsettings set org.gnome.nautilus.list-view use-tree-view true
gsettings set org.gnome.nautilus.list-view default-zoom-level 'small'

gsettings set org.gnome.desktop.interface monospace-font-name 'Source Code Pro 12'
gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'

gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'minimize'
gsettings set org.gnome.desktop.wm.preferences theme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

gsettings set org.gnome.desktop.calendar show-weekdate true

gsettings set org.gnome.TextEditor highlight-current-line true
gsettings set org.gnome.TextEditor show-map true
gsettings set org.gnome.TextEditor show-line-numbers true
gsettings set org.gnome.TextEditor show-right-margin true
gsettings set org.gnome.TextEditor tab-width 'uint32 4'
gsettings set org.gnome.TextEditor indent-style 'space'

echo "Fedora post-installation script has been successfully executed."
echo "Please reboot the system for all changes to take effect."

sleep 5
