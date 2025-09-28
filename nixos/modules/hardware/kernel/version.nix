{ pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_xanmod_stable;
}
