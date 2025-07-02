{ lib, ... }:

{
  security.sudo.execWheelOnly = lib.mkForce false;

  networking.firewall = {
    enable = true;
    allowPing = false;

    # TCP Ports
    allowedTCPPorts = [
      22 # SSH
      80 # (If running a local web dev server)
      443 # (Same as above)
      1716 # GSConnect / KDE Connect
    ];

    # UDP Ports
    allowedUDPPorts = [
      1716 # gsconnect
    ];
  };
}
