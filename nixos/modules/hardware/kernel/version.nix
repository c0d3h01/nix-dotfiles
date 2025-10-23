{ pkgs, ... }:
{
  # boot.kernelPackages = pkgs.linuxPackages_xanmod_stable;
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
}
