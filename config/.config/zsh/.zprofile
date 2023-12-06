# /etc/zsh/zprofile
# Used for executing commands at start for all users.
# Read when starting as a login shell.
# Please note that on Arch Linux, by default it contains one line which sources /etc/profile.

# /etc/profile
# This file should be sourced by all POSIX sh-compatible shells upon login: 
# it sets up $PATH and other environment variables and application-specific (/etc/profile.d/*.sh) settings upon login.

# $ZDOTDIR/.zprofile
# It's for login shells.
# It is basically the same as .zlogin except that it's sourced before .zshrc
# .zprofile is meant as an alternative to .zlogin
# Used for executing user's commands at start
# will be read when starting as a login shell.
# Typically used to autostart graphical sessions and to set session-wide environment variables.
################################################################################
# Set Prompt 

# Enable colors
autoload -U colors && colors
