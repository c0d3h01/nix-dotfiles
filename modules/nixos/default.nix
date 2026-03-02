# NixOS modules — top-level entry point
{
  imports = [
    # keep-sorted start
    ./boot
    ./desktop
    ./hardware
    ./kernel
    ./networking
    ./nix
    ./profile.nix
    ./security
    ./services
    ./system
    # keep-sorted end
  ];
}
