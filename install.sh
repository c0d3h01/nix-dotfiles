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
if [ ! -f "$SCRIPT_DIR/system/hardware-configuration.nix" ]; then
  echo "Generating hardware configuration..."
  sudo nixos-generate-config --show-hardware-config > $SCRIPT_DIR/nix/hardware-configuration.nix
fi

# Enable Flakes and nix-command in /etc/nixos/configuration.nix
if ! grep -q 'experimental-features = \[ "nix-command" "flakes" \]' /etc/nixos/configuration.nix; then
  echo "Enabling Flakes and nix-command..."
  echo '
# Enable Nix Flakes
{ nix.settings = { experimental-features = [ "nix-command" "flakes" ]; }; }' | sudo tee -a /etc/nixos/configuration.nix
fi

# Rebuild system using flake
echo "Applying system configuration..."
sudo nixos-rebuild switch --flake . --upgrade --show-trace

echo "✅ Setup complete! Your system is now configured."
