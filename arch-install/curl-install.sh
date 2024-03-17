#!/bin/bash
#
# Installing git

echo "Installing git."
pacman -Sy --noconfirm --needed git glibc

echo "Cloning dotfiles"
git clone https://github.com/emilevezinacoulombe/dotfiles

echo "Executing Arch install"

cd "dotfiles/arch-install/"

exec ./install.sh
