{lib, ...}: {
  networking = {
    nftables.enable = true;

    firewall = {
      enable = true;

      allowedTCPPorts = [
        22 # SSH
        80 # HTTP
        443 # HTTPS
        8080 # dev server
        59010 # custom
        59011 # custom
      ];
      allowedUDPPorts = [
        59010
        59011
      ];

      logReversePathDrops = true;
      logRefusedConnections = false;

      checkReversePath = lib.mkForce "loose";
    };
  };
}
