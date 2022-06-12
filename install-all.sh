#!/usr/bin/env zsh

sudo apt update
sudo apt upgrade

# Varibles
INSTALL_CMD = sudo apt install

# Functions
install () {
    $INSTALL_CMD $1
}

cmd_exist () {
    if [ ! command -v $1 &> /dev/null ]; then
        return 1 # false
    else
        return 0 # true
    fi
}

install_cmd () {
    if [ ! cmd_exist $1 ]; then
        install $1
    fi
}

install_flatpack () {
    if [ grep -q "$1"]; then
        flatpack install $1
    fi
}

# Installation
cd ~

install_cmd zsh
install_cmd fd-find
install_cmd ripgrep
install_cmd stow
install_cmd xsel

# NVM
if [ ! cmd_exist nvm ]; then
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi

nvm install 18
nvm use 18
nvm alias default 18

# git
if [ ! cmd_exist git ]; then
    install_cmd git-all
fi
npm install --location=global git-stats
npm install --location=global git-stats-importer
pip install --user git-fame

if [ ! cmd_exist lazygit ]; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit
fi

# fzf
if [ ! cmd_exist fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi


# Nvim
if [ ! cmd_exist nvim ]; then
    wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb
    install ./nvim-linux64.deb
    rm nvim-linux64.deb
fi

# gh
if [ ! cmd_exist gh ]; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    install gh
fi
gh extension install mislav/gh-branch
gh extension install dlvhdr/gh-dash
gh extension install maximousblk/gh-fire
gh extension install kawarimidoll/gh-graph
gh extension install meiji163/gh-notify
gh extension install seachicken/gh-poi
gh extension install vilmibm/gh-screensaver
gh extension install korosuke613/gh-user-stars
gh extension install sheepla/gh-userfetch

# pyenv
if [ ! cmd_exist pyenv ]; then
    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
fi

# Flatpack
install_cmd flatpack
install_flatpack com.getpostman.Postman
install_flatpack com.github.IsmaelMartinez.teams_for_linux
install_flatpack com.github.jeromerobert.pdfarranger
install_flatpack com.github.maoschanz.drawing
install_flatpack com.nextcloud.desktopclient.nextcloud
install_flatpack com.slack.Slack
install_flatpack com.spotify.Client
install_flatpack com.uploadedlobster.peek
install_flatpack com.github.xournalpp.xournalpp
install_flatpack io.dbeaver.DBeaverCommunity
install_flatpack io.gitlab.librewolf-community
install_flatpack md.obsidian.Obsidian
install_flatpack net.ankiweb.Anki
install_flatpack org.gnome.Boxes
install_flatpack org.gnome.Devhelp
install_flatpack org.kde.okular
install_flatpack org.kicad.KiCad
install_flatpack org.mozilla.Thunderbird
install_flatpack org.onlyoffice.desktopeditors
install_flatpack org.qownnotes.QOwnNotes
install_flatpack org.raspberrypi.rpi-imager
install_flatpack org.signal.Signal

# Python
pip install --user magic-wormhole
pip install --user debugpy
pip install --user pynvim

# npm
npm i --location=global neovim

# install config files and reload
. ~/.dotfiles/install.sh
source ~/.config/zsh/.zshrc
