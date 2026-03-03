{lib, ...}: {
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    dnsovertls = "opportunistic";
    fallbackDns = [
      "1.1.1.1#cloudflare-dns.com"
      "9.9.9.9#dns.quad9.net"
    ];
  };

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";

    wifi = {
      powersave = lib.mkForce false;
      macAddress = "random";
      scanRandMacAddress = true;
    };

    ethernet.macAddress = "random";
  };
}
