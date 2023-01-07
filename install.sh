#!/bin/bash

# Variables
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0;0m'

# Main

echo -e "${CYAN}* Cloning zshPlug${NC}"
git clone https://github.com/Atlas34/zshPlug.git "$HOME/.local/share/zshPlug" > /dev/null 2>&1
mkdir -p "$HOME/.local/share/zshPlug/plugins"

echo -e "${CYAN}* Updating .zshrc${NC}"
# check if ZDOTDIR is set, and if it is, check if ZDOTDIR/.zshrc exists
zshrc="${ZDOTDIR:-$HOME}/.zshrc"
touch "${zshrc}"

if ! grep -q '[[ -f "${HOME}/.local/share/zshPlug/zshPlug.zsh" ]] && source "${HOME}/.local/share/zshPlug/zshPlug.zsh"' "${zshrc}"
then
    echo "[[ -f \"${HOME}/.local/share/zshPlug/zshPlug.zsh\" ]] && source \"${HOME}/.local/share/zshPlug/zshPlug.zsh\"" >> ${zshrc}
fi
echo -e "${CYAN}* Done installing zshPlug${NC}"

# vim: ft=bash ts=4 sw=4 sts=4 et
