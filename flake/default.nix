# Purpose: auto-imports all flake-parts modules in this directory
{
  imports = [
    # keep-sorted start
    ./dev-shell.nix
    ./formatter.nix
    ./hosts.nix
    ./overlays.nix
    # keep-sorted end
  ];
}
