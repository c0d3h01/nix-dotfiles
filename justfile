switch:
    sudo nixos-rebuild switch --flake '.#devbox'

home:
    home-manager switch --flake .#c0d3h01@devbox

test:
    nixos-rebuild test --flake .#devbox

update:
    nix flake update

check:
    nix flake check

deve:
    devenv shell -v