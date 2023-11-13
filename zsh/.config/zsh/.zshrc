# /etc/zsh/zshrc
# Used for setting interactive shell configuration and executing commands for all users,
# will be read when starting as an interactive shell.

# $ZDOTDIR/.zshrc
# Used for setting user's interactive shell configuration and executing commands,
# will be read when starting as an interactive shell.
# Set options for the interactive shell there with the setopt and unsetopt commands.
################################################################################
# PATH extension
export PATH="/.local/bin/nvim:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH="$PYENV_ROOT/bin:$PATH"

if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.local/bin/personal" ]; then
    PATH="$HOME/.local/bin/personal:$PATH"
fi

if [ -d "$PYENV_ROOT/bin" ]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
fi

################################################################################
# Source
source "$ZALIASES"
source "$ZFUNCTIONS"

################################################################################
# History
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$XDG_CACHE_HOME/zsh/history"
setopt INC_APPEND_HISTORY # Incrementaly append history
export HISTTIMEFORMAT="[%F %T] "
setopt EXTENDED_HISTORY     # Add Timestamp to history
setopt HIST_FIND_NO_DUPS    # Don't view duplicate when searching <C-R>
setopt HIST_IGNORE_ALL_DUPS # Don't add duplicate in history

################################################################################
# Plugins
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zap-zsh/vim"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "MichaelAquilina/zsh-you-should-use"
plug "hlissner/zsh-autopair"

plug "zap-zsh/exa"
plug "zsh-users/zsh-syntax-highlighting"

plug "zap-zsh/fzf"
plug "wintermi/zsh-rust"
# plug "wintermi/zsh-golang"

################################################################################
## Completions

autoload -Uz compinit
compinit -u

################################################################################
# Rice 🍚
# Starship 🚀
# https://github.com/starship/starship
eval "$(starship init zsh)"
# PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b ".zsh

################################################################################
# Apps

# IDEA
# HACK: needed after a bug the flatpack don't work
# bug from https://intellij-support.jetbrains.com/hc/en-us/community/posts/10865358461202-Intellij-cannot-launch-because-process-2-already-running
if [ -d "$HOME/Applications/idea" ]; then
    export PATH="$HOME/Applications/idea/bin/:$PATH"
else
    echo "Install IDEA: https://www.jetbrains.com/idea/download/download-thanks.html?platform=linux"
    echo "extract tar in $HOME/Applications/"
    echo "It shoud contain $HOME/Applications/idea/bin"
fi


# Neovim
if [ -d "$HOME/neovim" ]; then
    export PATH="$HOME/neovim/bin:$PATH"
else
    echo "Install neovim: https://github.com/neovim/neovim/releases/tag/stable"
    echo "extract tar in $HOME/neovim"
fi

# NVM, NPM and NODE.zsh
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# GVM
# TODO: bat error
# [[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

## direnv
eval "$(direnv hook zsh)"

## Pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Cargo
if [ -d "$HOME/.cargo" ]; then
    . "$HOME/.cargo/env"
else
    echo "Install cargo: https://www.rust-lang.org/tools/install"
fi

# Deno
if [ -d "$HOME/.deno/" ]; then
    export DENO_INSTALL="$HOME/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"
else
    echo "Install Deno: https://docs.deno.com/runtime/manual/getting_started/installation"
fi

# Luaver
if [ -d "$HOME/.luaver/" ]; then
    . "$HOME/.luaver/luaver"
else
    echo "Install luaver: https://dhavalkapil.com/luaver/"
fi

# SDKMAN TO WORK!!!
if [ -d "$HOME/.sdkman" ]; then
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
else
    echo "Install sdkman: https://sdkman.io/"
fi


# NNN
## More plugins : https://github.com/jarun/nnn/tree/master/plugins#running-commands-as-plugin
NNN_PLUG_DEFAULT='p:preview-tui;d:dragdrop'
export NNN_PLUG="$NNN_PLUG_DEFAULT;"

export NNN_TRASH=2

## OneDark
## BLK="04" CHR="04" DIR="04" EXE="00" REG="00" HARDLINK="00" SYMLINK="06" MISSING="00" ORPHAN="01" FIFO="0F" SOCK="0F" OTHER="02"
## Nord
BLK="0B" CHR="0B" DIR="04" EXE="06" REG="00" HARDLINK="06" SYMLINK="06" MISSING="00" ORPHAN="09" FIFO="06" SOCK="0B" OTHER="06"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"
export NNN_FIFO="/tmp/nnn.fifo"

## Bookmarks
Bookmarks="b:$HOME/.config/nnn/bookmarks"
Documents="d:$HOME/Documents"
Downloads="D:$HOME/Downloads/"
export NNN_BMS="$Bookmarks;$Documents;$Downloads"

################################################################################
# Validate install
source "$ZDOTDIR/zsh-safe-install"

################################################################################
# Fixes
export HISTFILE="$XDG_CACHE_HOME/zsh/history"
