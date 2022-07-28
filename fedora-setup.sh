#!/bin/bash

echo "Fedora post-installation script is running..."

echo "Removing superflous software..."
sleep 2
sudo dnf -y remove gnome-shell-extension-background-logo totem cheese gnome-maps
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
    nvidia-driver
    discord
    emacs
    keepassxc
    golang
    gnome-tweaks
    bottles
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

echo "Setting up git..."
sleep 2
git config --global user.name "Rikard Hevosmaa"
git config --global user.email "rikard@hevosmaa.net"
git config --global core.editor "emacs -Q -nw"

echo "Setting up a Go programming workspace..."
sleep 2
mkdir -p $HOME/golang/{bin,pkg,src}
echo GOPATH=$HOME/golang >> ~/.profile
echo PATH=$PATH:$GOPATH/bin >> ~/.profile

echo "Setting up Emacs..."
sleep 2
git clone https://github.com/hevosmaa/emacs.d.git ~/.config/emacs
echo "alias em=\"emacs -nw\"" >> ~/.bashrc

echo "Fedora post-installation script has been successfully executed."
echo "Enjoy your new operating system!"

sleep 10
