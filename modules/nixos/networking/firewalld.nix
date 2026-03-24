{
  lib,
  pkgs,
  ...
}: {
  networking = {
    nftables.enable = true;

    firewall = {
      backend = "firewalld";
      checkReversePath = lib.mkForce "loose";
      logRefusedConnections = false;
      logReversePathDrops = true;

      allowedTCPPorts = [
        22
        80
        443
        8080
        59010
        59011
      ];

      allowedUDPPorts = [
        59010
        59011
      ];
    };
  };

  services.firewalld = {
    enable = true;
    package = pkgs.firewalld-gui;
    settings.FirewallBackend = "nftables";
  };
}
