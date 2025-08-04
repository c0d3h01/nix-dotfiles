{ pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    package = pkgs.iptables;
    allowPing = false;

    # make a much smaller and easier to read log
    logReversePathDrops = true;
    logRefusedConnections = false;

    # TCP Ports
    allowedTCPPorts = [
      22 # SSH
      80 # (If running a local web dev server)
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
