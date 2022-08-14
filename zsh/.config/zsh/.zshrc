export ZDOTDIR=$HOME/.config/zsh
# XDG Paths
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# Enable colors and change prompt:
autoload -U colors && colors

# History
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.cache/zsh/history
setopt INC_APPEND_HISTORY # Incrementaly append history
export HISTTIMEFORMAT="[%F %T] "
setopt EXTENDED_HISTORY # Add Timestamp to history
setopt HIST_FIND_NO_DUPS # Don't view duplicate when searching <C-R>
setopt HIST_IGNORE_ALL_DUPS # Don't add duplicate in history
export export PATH="/.local/bin/lvim:$PATH"

# Load aliases and shortcuts if existent.
source "$ZDOTDIR/zsh-functions"
zsh_add_file "zsh-exports"
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-prompt"

# Plugins
## completions
autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION
zstyle ':completion:*' menu select
zsh_add_plugin "zsh-users/zsh-autosuggestions"

# Apps

## NVM and NPM
## direnv
eval "$(direnv hook zsh)"

## luaver
[ -s ~/.luaver/luaver ] && . ~/.luaver/luaver

## Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

## conda
__conda_setup="$('/home/emile/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/emile/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/emile/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/emile/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# Basic auto/tab complete:
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPS="--extended"
export FZF_DEFAULT_COMMAND="fdfind --type f --type d --type s -H -E .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fpath=($fpath "$HOME/.config/zsh/.zfunctions")


## Spaceship-propt
# https://starship.rs/
# https://github.com/spaceship-prompt/spaceship-prompt/blob/master/docs/options.md 
### Order
SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  package       # Package version
  gradle        # Gradle section
  maven         # Maven section
  node          # Node.js section
  ruby          # Ruby section
  elixir        # Elixir section
  xcode         # Xcode section
  swift         # Swift section
  golang        # Go section
  php           # PHP section
  rust          # Rust section
  haskell       # Haskell Stack section
  julia         # Julia section
  docker        # Docker section
  aws           # Amazon Web Services section
  gcloud        # Google Cloud Platform section
  venv          # virtualenv section
  conda         # conda virtualenv section
  # pyenv         # Pyenv section
  dotnet        # .NET section
  ember         # Ember.js section
  kubectl       # Kubectl context section
  terraform     # Terraform workspace section
  ibmcloud      # IBM Cloud section
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
### Python
SPACESHIP_VENV_SYMBOL=🐍
SPACESHIP_VENV_COLOR=yellow
### Directory
SPACESHIP_DIR_TRUNC=2
SPACESHIP_DIR_TRUNC_REPO=false
### VI-mode
SPACESHIP_VI_MODE_SHOW=false
autoload -U promptinit; promptinit
prompt spaceship
fpath=($fpath "~/.config/zsh/.zfunctions")
