#!/usr/bin/env bash

set -e

# Define colors
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
null='\033[0m'

# Define variables
REPO_URL="https://github.com/c0d3h01/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
HOST_NAME="c0d3h01"
FLAKE_TARGET="NixOS"

echo -e "${GREEN}Starting installation...${null}"

echo -e "${YELLOW}Installing git...${null}"
nix-env -iA git &> /dev/null

echo -e "${CYAN}Cloning dotfiles...${null}"
git clone "$REPO_URL" "$DOTFILES_DIR" &> /dev/null

cd "$DOTFILES_DIR"

echo -e "${BLUE}Updating flake...${null}"
nix flake update &> /dev/null

echo -e "${RED}Removing old hardware config...${null}"
rm -f "./hosts/$HOST_NAME/hardware-configuration.nix"

echo -e "${YELLOW}Copying current hardware config...${null}"
cp /etc/nixos/hardware-configuration.nix "./hosts/$HOST_NAME/"

echo -e "${MAGENTA}Rebuilding system with flake...${null}"
sudo nixos-rebuild switch --flake ".#$FLAKE_TARGET" --fast --option extra-experimental-features 'nix-command flakes'

echo -e "${GREEN}Installation complete!${null}"
