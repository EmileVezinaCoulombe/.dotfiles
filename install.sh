#!/usr/bin/env zsh
STOW_FOLDERS="btop,firefox,git,kitty,micro,neofetch,nvim,tmux,VSCodium,wakatime,zsh"
STOW_FOLDERS=$STOW_FOLDERS

# TODO: rm
if [[ -z $DOTFILES ]]; then
    DOTFILES=$HOME/.dotfiles
    DOTFILES=$DOTFILES
fi


pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    echo "stow $folder"
    stow -D $folder
    stow $folder
done
popd
