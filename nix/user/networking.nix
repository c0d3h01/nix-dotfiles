{ lib, ... }:
{
  # Core networking configuration
  networking = {
    networkmanager = {
      enable = true;
      # Disable WiFi power saving
      settings.connection."wifi.powersave" = lib.mkForce 2;
      # Use systemd-resolved for DNS
      dns = lib.mkForce "none";
      # Efficient connection config in one block
      connectionConfig = {
        "connection.mdns" = 2;
        "ipv4.dns-priority" = -1;
        "ipv6.dns-priority" = -1;
      };
    };

    # Direct DNS configuration
    nameservers = [
      # Cloudflare DNS (IPv4 + IPv6)
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];

    # Prevent DNS config overwrites
    dhcpcd.extraConfig = "nohook resolv.conf";

    # Firewall
    firewall = {
      enable = true;
      allowedTCPPorts = [ 1716 ];
      allowedUDPPorts = [ 1716 ];
    };
  };

  # DNS resolution service
  services.resolved = {
    enable = true;
    # Performance optimizations
    dnssec = "false"; # Disable DNSSEC for faster resolution
    extraConfig = ''
      Cache=yes
      DNSStubListener=yes
      MulticastDNS=yes
      DNSOverTLS=opportunistic
    '';
  };

  # Disable waiting for network to be online
  systemd.network.wait-online.enable = false;
}
