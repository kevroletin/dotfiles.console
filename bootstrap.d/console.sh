#!/bin/sh

PACKAGES="vcsh mr zsh ranger ispell lynx vim"
echo "=== Installing $PACKAGES ==="
sudo apt-get install $PACKAGES

echo "=== Changing default shell to zsh ==="
sudo chsh `whoami` `which zsh`

while true; do
    read -p "Do you wish to install console version of emacs? " yn
    case $yn in
        [Yy]* ) sudo apt-get install emacs24-nox; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
