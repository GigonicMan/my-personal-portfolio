#!/bin/bash
#
#   Script Name:    install-brady-theme.sh
#   Description:    Installs the Brady theme for your terminal
#   Author:         Brady Adams
#   Date:           02-07-2026
#   Version:        0.1.0
#


# Error Handling
# set -euo pipefail

# Script constants
SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_NAME

# Configuration variables (modify as needed)

bash_source="$HOME/.bashrc"

# Text Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

# Emojis
EMOJI_SUCCESS="✅"
EMOJI_ERROR="❌"
EMOJI_WARNING="⚠️"
EMOJI_INFO="ℹ️"
EMOJI_DEBUG="🐛"

# Functions

# Usage function, modify as needed for your scripts
usage() {
    echo "Usage: $SCRIPT_NAME [options]"
    echo ""
    echo "Options:"
    echo "-h, --help  Show this help message"

}

install_theme() {
    clear
    echo -e "${EMOJI_INFO}  ${GREEN}Installing Brady theme...${NC}"
    echo ""
    
    # Update package lists and install dependencies
    echo "${EMOJI_INFO}  ${CYAN}Updating package lists...${NC}"
    sudo apt update && sudo apt upgrade -y

    if ! sudo apt update && sudo apt upgrade -y; then
        echo -e "${EMOJI_ERROR}${RED} Error updating package lists and dependencies...${NC}"
        exit 1
    fi
    echo ""

    # Install Starship
    echo -e "${EMOJI_INFO}  ${CYAN}Installing Starship...${NC}"
    curl -sS https://starship.rs/install.sh | sh

    if ! curl -sS https://starship.rs/install.sh | sh; then
        echo -e "${EMOJI_ERROR}${RED} Error installing starship...${NC}"
        exit 1
    fi
    echo ""

    # Enable starship in .bashrc
    echo 'eval "$(starship init bash)"' >> "$bash_source"
    if ! echo 'eval "$(starship init bash)"' >> ~/.bashrc; then
        echo -e "${EMOJI_ERROR}${RED} Error: could not enable starship in ~/.bashrc...${NC}"
    fi
    # Reload bash config (apply immediately)
    source "$bash_source"

    # Create starship config  from a preset
    starship preset nerd-font-symbols -o ~/.config/starship.toml



}

# Main script starts here
main() {
    # Parse arguments
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        usage
        exit 0
    fi

    # Your logic here (function calls)
    install_theme
}

# Run main with all arguments
main "$@"


# =============================================
# TESTING YOUR SCRIPT
# =============================================
# 1. Make Executable: chmod +x [script].sh
# 2. Run ./[script.sh]
# 3. Validate with: shellcheck [script].sh
# =============================================

