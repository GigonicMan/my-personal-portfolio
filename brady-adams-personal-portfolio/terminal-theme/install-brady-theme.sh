#!/bin/bash
#
#   Script Name:    install-brady-theme.sh
#   Description:    Installs the Brady theme for your terminal
#   Author:         Brady Adams
#   Date:           02-07-2026
#   Version:        0.1.0
#


# Error Handling
set -euo pipefail

# Script constants
SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_NAME

# Configuration variables (modify as needed)

arg="${1:-}"
bashrc="${HOME}/.bashrc"
STARSHIP_INIT='eval "$(starship init bash)"'
STARSHIP_TOML="${HOME}/.config/starship.toml"

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

# Divider
DIVIDER="======================================================="

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
    echo "$DIVIDER"
    echo ""
    
    # Update package lists
    echo "${EMOJI_INFO}  ${CYAN}Updating package lists...${NC}"

    if ! (sudo apt update); then
        echo -e "${EMOJI_ERROR}${RED} ERROR: updating package lists and dependencies...${NC}"
        exit 1
    fi
    echo "$DIVIDER"
    echo ""

    # Install Starship

    echo -e "${EMOJI_INFO}${CYAN}Installing Starship...${NC}"
    

    if ! (curl -fsS https://starship.rs/install.sh | sh && command -v starship >/dev/null); then
        echo -e "${EMOJI_ERROR}${RED}       FAILURE: Starship install or verification failed...${NC}"
        exit 1
    else
        echo "${EMOJI_SUCCESS}${GREEN}      SUCCESS: Starship was retrieved.${NC}"
    fi
    echo "$DIVIDER"
    echo ""

    # Check if ~/.bashrc exists
    if [ ! -f "$bashrc" ]; then
        echo "${EMOJI_WARNING}${YELLOW}     $bashrc not found. Creating it now.${NC}"
        touch "$bashrc"
        echo "${EMOJI_SUCCESS}${GREEN}      File created successfully.${NC}"
    else
        echo "${EMOJI_SUCCESS}${GREEN}      $bashrc already exists.${NC}"
    fi
    echo "$DIVIDER"
    echo ""


    echo -e "${EMOJI_INFO}  ${CYAN}Enabling Starship in $bashrc...${NC}"
    # Ensure bashrc exists
    if [[ ! -f "$bashrc" ]]; then
        echo -e "${EMOJI_WARNING}${YELLOW}      $bashrc not found. Creating it now.${NC}"
        touch "$bashrc"
    fi

    # Add init  line only if its not already present
    if grep -Fqx "$STARSHIP_INIT" "$bashrc"; then
        echo -e "${EMOJI_SUCCESS}${GREEN}       Starship init already present in $bashrc (skipping).${NC}"
    else
        echo "$STARSHIP_INIT" >> "$bashrc"
        echo -e "${EMOJI_SUCCESS}${GREEN}       Added Starship init line to $bashrc.${NC}"
    fi
    echo "$DIVIDER"
    echo ""
    
    

    # Ensure ~/.config exists
    echo -e "${EMOJI_INFO}${CYAN}Ensuring ~/.config exists...${NC}"
    mkdir -p "$HOME/.config"
    echo -e "${EMOJI_SUCCESS}${GREEN} ~/.config ready.${NC}"
    echo "$DIVIDER"

    echo -e "${EMOJI_INFO}  ${CYAN}Writing Starship config...${NC}"

    if ! starship preset nerd-font-symbols -o "$STARSHIP_TOML"; then
        echo -e "${EMOJI_ERROR}${RED}       ERROR: starship preset command failed.${NC}"
        exit 1
    fi

    if [[ ! -s "$STARSHIP_TOML" ]]; then
        echo -e "${EMOJI_ERROR}${RED}       ERROR: $STARSHIP_TOML was not created or is empty.${NC}"
        exit 1
    fi

    echo -e "${EMOJI_SUCCESS}${GREEN}       SUCCESS: starship.toml created at $STARSHIP_TOML.${NC}"

    echo "$DIVIDER"
    echo ""


    echo -e "${EMOJI_INFO}${CYAN}Next Step(s):${NC}"
    echo -e "   Run: ${YELLOW}source \"$bashrc\"${NC}"
    echo -e "   OR:  ${YELLOW}open a new terminal tab.${NC}"
    echo ""

}

# Main script starts here
main() {
    # Parse arguments
    if [[ "$arg" == "-h" || "$arg" == "--help" ]]; then
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

