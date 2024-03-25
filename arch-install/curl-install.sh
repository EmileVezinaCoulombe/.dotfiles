#!/bin/bash
# Upgrade pacman
pacman -Syy --noconfirm

# Installing git

echo "Installing git."
pacman -Sy --noconfirm --needed git

echo "Cloning dotfiles"
git clone https://github.com/emilevezinacoulombe/dotfiles

echo "Executing Arch install"

cd "dotfiles/arch-install/" || exit

exec ./install.sh
