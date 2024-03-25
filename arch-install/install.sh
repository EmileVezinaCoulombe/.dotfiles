#!/bin/bash

###############################################################################
# Personal Arch installer

###############################################################################
# Set variables
CWD="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
LOG_FILE="/var/log/arch-install.log"

###############################################################################
# Installation

(bash "$CWD/arch-installer.sh") |& tee "$LOG_FILE"
