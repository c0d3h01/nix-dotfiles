#!/bin/sh

# Define dotfiles location
SCRIPT_DIR=~/dotfiles

# Check if dotfiles repo exists, clone if not
if [ ! -d "$SCRIPT_DIR/.git" ]; then
  echo "Cloning dotfiles..."
  git clone https://github.com/c0d3h01/dotfiles $SCRIPT_DIR
fi

# Change to dotfiles directory
cd $SCRIPT_DIR || exit 1

# Ensure hardware configuration exists
if [ ! -f "$SCRIPT_DIR/nix/hardware.nix" ]; then
  echo "Generating hardware configuration..."
  sudo nixos-generate-config --show-hardware-config >$SCRIPT_DIR/nix/hardware.nix
fi

# Rebuild system using flake
echo "Applying system configuration..."
sudo nixos-rebuild switch --flake . --upgrade --show-trace --option experimental-features "nix-command flakes"

echo "✅ Setup complete! Your system is now configured."
