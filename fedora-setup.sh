#!/bin/bash

echo "Fedora post-installation script is running..."

sleep 10

echo "Removing superflous software..."
sudo dnf -y remove gnome-shell-extension-background-logo totem cheese gnome-maps
sudo dnf autoremove -y

echo "Enabling third-party repositories..."
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf upgrade --refresh

echo "Installing multimedia codecs..."
sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

PACKAGE_LIST=(
    nvidia-driver
    discord
    emacs
    keepassx
    git
    golang
    gnome-tweaks
    steam
    vlc
    wget
    wine
    winetricks
)

for package_name in ${PACKAGE_LIST[@]}; do
    if ! sudo dnf list --installed | grep -q "^\<$package_name\>"; then
        echo "Installing $package_name..."
        sleep .5
        sudo dnf install -y "$package_name"
        echo "$package_name installed."
    else
        echo "$package_name is already installed."
    fi
done

if ! sudo dnf list --installed | grep -q git; then
    echo "Setting up git..."
    git config --global user.name "Rikard Hevosmaa"
    git config --global user.email "rikard@hevosmaa.net"
fi

if ! sudo dnf list --installed | grep -q golang; then
    echo "Setting up a Go programming workspace..."
    mkdir -p $HOME/golang/{bin,pkg,src}
    echo GOPATH=$HOME/golang >> ~/.profile
    echo PATH=$PATH:$GOPATH/bin >> ~/.profile
fi

if ! sudo dnf list --installed | grep -q git; then
    echo "Setting up Emacs..."
    git https://github.com/hevosmaa/emacs.d.git ~/.config/emacs
    echo "alias em = emacs -nw" >> ~/.profile
fi

echo "Fedora post-installation script has been successfully executed."
echo "Enjoy your new operating system!"

sleep 10
