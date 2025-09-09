{ pkgs, lib, ... }:

{
  networking.firewall = {
    enable = true;
    package = pkgs.iptables;
    allowPing = false;

    # make a much smaller and easier to read log
    logReversePathDrops = true;
    logRefusedConnections = false;

    # Don't filter DHCP packets, according to nixops-libvirtd
    checkReversePath = lib.mkForce false;

    # TCP Ports
    allowedTCPPorts = [
      443 # (Same as above)
      1716 # GSConnect / KDE Connect
      8080 # HTTP
    ];

    # UDP Ports
    allowedUDPPorts = [
      1716 # gsconnect
    ];
  };
}
