{ lib, ... }:
{
  # Core networking configuration
  networking = {
    # Enable NetworkManager
    networkmanager = {
      enable = true;
      # Disable WiFi power saving
      wifi.powersave = lib.mkDefault false;
    };

    # DNS configuration
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];

    # Firewall configuration
    firewall = {
      enable = true;
      allowedTCPPorts = [ 1716 ];
      allowedUDPPorts = [ 1716 ];
    };
  };

  # DNS resolution service
  services.resolved = {
    enable = true;
    dnssec = "false";
    extraConfig = ''
      Cache=yes
      DNSStubListener=yes
      MulticastDNS=yes
    '';
  };

  # Disable waiting for network to be online at boot
  systemd.network.wait-online.enable = false;
}
