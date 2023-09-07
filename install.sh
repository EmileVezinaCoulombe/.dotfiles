#!/usr/bin/env zsh
STOW_FOLDERS="nvim,zsh,kitty,fonts,git,gitui,tmux"

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
