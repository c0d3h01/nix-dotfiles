{
  networking.networkmanager.enable = true;

  # Hand DNS to systemd-resolved
  networking.networkmanager.dns = "systemd-resolved";

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade"; # Use DNSSEC when upstream supports it
    dnsovertls = "opportunistic"; # Try TLS, fall back silently

    # Ordered fallback resolvers
    fallbackDns = [
      "1.1.1.1#cloudflare-dns.com"
      "1.0.0.1#cloudflare-dns.com"
      "9.9.9.9#dns.quad9.net"
      "2620:fe::fe#dns.quad9.net"
    ];

    # Disable legacy noisy protocols
    llmnr = "false"; # Disable LLMNR

    # extraConfig lines map directly to resolved.conf options not exposed above
    extraConfig = ''
      Cache=yes
      DNSStubListener=yes
    '';
  };

  # Faster boot: don't block on network-online (ok for workstation)
  systemd.network.wait-online.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
}
