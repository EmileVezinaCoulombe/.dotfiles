#!/usr/bin/env zsh
STOW_FOLDERS="atuin,btop,firefox,git,kitty,micro,neofetch,nvim,tmux,VSCodium,wakatime,zsh"
# TODO place zcompdump else where
rm "~/.config/zsh/.zcompdump"

if [[ -z $DOTFILES ]]; then
    DOTFILES=$HOME/.dotfiles
fi

STOW_FOLDERS=$STOW_FOLDERS DOTFILES=$DOTFILES

pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    stow -D $folder
    stow $folder
done
popd
