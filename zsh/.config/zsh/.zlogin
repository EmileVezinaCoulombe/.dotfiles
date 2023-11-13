# /etc/zsh/zlogin 
# Used for executing commands for all users at ending of initial progress,  
# will be read when starting as a login shell.


# $ZDOTDIR/.zlogin 
# Used for executing user's commands at ending of initial progress, 
# will be read when starting as a login shell. 
# Typically used to autostart command line utilities. 
# Should not be used to autostart graphical sessions, 
# as at this point the session might contain configuration meant only for an interactive shell.
# It is sourced on the start of a login shell but after .zshrc, if the shell is also interactive.
