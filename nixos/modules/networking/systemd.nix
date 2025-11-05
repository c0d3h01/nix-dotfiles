{
  # systemd DNS resolver daemon
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    dnsovertls = "true";
  };

  # Faster boot: don't block on network-online
  systemd.network.wait-online.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
}
