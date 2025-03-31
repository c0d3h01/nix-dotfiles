#!/bin/bash

# Ensure we're running the script as root to avoid permission issues
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root (use sudo)"
    exit 1
fi

# Install Git
echo "Installing Git..."
nix-env -iA nixos.git

# Clone the dotfiles repository
echo "Cloning the dotfiles repository..."
git clone https://github.com/c0d3h01/dotfiles.git ~/

# Navigate to the dotfiles directory
cd ~/dotfiles

# Generate NixOS configuration
echo "Generating NixOS configuration..."
nixos-generate-config

# Copy hardware configuration to the nix directory
echo "Copying hardware configuration..."
cp /etc/nixos/hardware-configuration.nix nix/

# Rebuild NixOS system with the new configuration
echo "Rebuilding NixOS system..."
nixos-rebuild switch --flake .#NixOS --fast

echo "Dotfiles installation and NixOS rebuild complete!"
