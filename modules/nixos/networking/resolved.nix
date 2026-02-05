{
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "allow-downgrade";
      DNSOverTLS = "opportunistic";
      LLMNR = "false";
      MulticastDNS = "false";
      DNS = [
        "9.9.9.9#dns.quad9.net"
        "149.112.112.112#dns.quad9.net"
        "1.1.1.1#cloudflare-dns.com"
        "1.0.0.1#cloudflare-dns.com"
      ];
      FallbackDNS = [
        "2620:fe::fe#dns.quad9.net"
        "2606:4700:4700::1111#cloudflare-dns.com"
      ];
    };
  };
}
