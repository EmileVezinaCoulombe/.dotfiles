#!/usr/bin/env zsh
STOW_FOLDERS="config,firefox,fonts,git,wallpaper"

if [[ -z $DOTFILES ]]; then
    DOTFILES=$HOME/.dotfiles
fi


pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    echo "Stowing $folder..."
    stow -D $folder 2>/dev/null
    stow -t $HOME $folder
done
popd
