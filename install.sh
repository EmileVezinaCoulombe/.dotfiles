#!/usr/bin/env bash
STOW_FOLDERS="config,firefox,git,wallpaper"
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
    stow --restow $folder
done
popd
