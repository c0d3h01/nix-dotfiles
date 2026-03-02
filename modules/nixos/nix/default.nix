# Nix — daemon settings, package policy, store maintenance
{
  imports = [
    # keep-sorted start
    ./config.nix
    ./optimise.nix
    ./settings.nix
    # keep-sorted end
  ];
}
