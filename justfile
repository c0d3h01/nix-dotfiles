switch:
    sudo nixos-rebuild switch --flake '.#devbox'

home:
    home-manager switch --flake '.#c0d3h01@devbox'

test:
    nixos-rebuild test --flake '.#devbox'

update:
    nix flake update

check:
    nix flake check

deve:
    devenv shell -v

swapon:
    btrfs filesystem mkswapfile --size 4G swapfile
    sudo swapon swapfile

swapoff:
    sudo swapoff swapfile
    rm swapfile

help:
    @echo "Available commands:"
    @echo "  switch - Rebuild and switch to the new configuration"
    @echo "  home - Apply home-manager configuration"
    @echo "  test - Test the current configuration"
    @echo "  update - Update the flake inputs"
    @echo "  check - Check the flake for errors"
    @echo "  deve - Enter the development environment"
    @echo "  help - Show this help message"
