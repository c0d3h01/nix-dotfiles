{
  pkgs,
  lib,
  userConfig,
  ...
}: let
  inherit (lib) mkForce;
in {
  networking = {
    nftables.enable = true;

    firewall = {
      enable = true;

      allowedTCPPorts = [
        22
        80
        443
        59010
        59011
        8080
      ];
      allowedUDPPorts = [
        59010
        59011
      ];

      # allowedTCPPortRanges = [];
      # allowedUDPPortRanges = [];

      # make a much smaller and easier to read log
      logReversePathDrops = true;
      logRefusedConnections = false;

      # Don't filter DHCP packets, according to nixops-libvirtd
      checkReversePath = mkForce false;
    };
  };
}
