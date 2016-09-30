#!/bin/bash
#
# Usefull commands:
#   vcsh list
#
# Examine .config/mr/available.d and .config/mr/config.d

pushd $HOME; sudo apt-get update

if ! sh -c 'which git 2>/dev/null'; then sudo apt-get install git; done
git config --global user.name "Vasiliy Kevroletin"
git config --global user.email kevroletin@gmail.com
git config --global push.default simple

sudo apt-get install vcsh mr emacs24-nox zsh ranger ispell
sudo chsh `whoami` `which zsh`

vcsh clone https://github.com/vkevroletin/dotfiles.mr
mr checkout
