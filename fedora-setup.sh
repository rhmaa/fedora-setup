#!/bin/bash

echo "Fedora post-installation script is running..."

echo "Removing superflous software..."
sleep 2
sudo dnf -y remove gnome-shell-extension-background-logo totem cheese gnome-maps firefox
sudo dnf -y autoremove

echo "Enabling third-party repositories..."
sleep 2
sudo dnf -y install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y install \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf -y upgrade --refresh

echo "Installing multimedia codecs..."
sleep 2
sudo dnf -y groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

PACKAGE_LIST=(
    bottles
    emacs
    gnome-extensions-app
    gnome-tweaks
    golang
    keepassxc
    nvidia-driver
    steam
    vlc
    wget
)

for package_name in ${PACKAGE_LIST[@]}; do
    if ! sudo dnf list --installed | grep -q "^\<$package_name\>"; then
        echo "Installing $package_name..."
        sleep 2
        sudo dnf install -y "$package_name"
        echo "$package_name installed."
    else
        echo "$package_name is already installed."
    fi
done

echo "Installing Microsoft Edge..."
sleep 2
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
sudo dnf config-manager --setopt=packages.microsoft.com_yumrepos_edge.name="Microsoft Edge for Fedora" --save
sudo dnf update --refresh
sudo dnf -y install microsoft-edge-stable

echo "Setting up git..."
sleep 2
git config --global user.name "Rikard Hevosmaa"
git config --global user.email "rikard@hevosmaa.net"
git config --global core.editor "emacs -Q -nw"

echo "Setting up a Go programming workspace..."
sleep 2
mkdir -p $HOME/Code/go/{bin,pkg,src}
echo GOPATH=$HOME/Code/go >> ~/.bashrc
echo PATH=$PATH:$GOPATH/bin >> ~/.bashrc

echo "Setting up Emacs..."
sleep 2
git clone https://github.com/hevosmaa/emacs.d.git ~/.config/emacs
echo "alias em=\"emacs -nw\"" >> ~/.bashrc

echo "Enabling flathub..."
sleep 2
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-modify --enable flathub

FLATPAK_LIST=(
    flathub com.spotify.Client
    com.discordapp.Discord
)

for flatpak_name in ${FLATPAK_LIST[@]}; do
    if ! sudo dnf list --installed | grep -q "^\<$flatpak_name\>"; then
        echo "Installing $flatpak_name..."
        sleep 2
        sudo dnf install -y "$flatpak_name"
        echo "$fkatpak_name installed."
    else
        echo "$flatpak_name is already installed."
    fi
done

echo "Fedora post-installation script has been successfully executed."
echo "Please reboot the system."

sleep 10
