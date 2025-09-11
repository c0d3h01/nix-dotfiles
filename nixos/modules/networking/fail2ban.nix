{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkForce;
in
{
  services.fail2ban = {
    enable = true;

    # nftables firewall (IPv4/IPv6).
    banaction = "nftables-multiport";

    # Keep allowlist tight for safety.
    ignoreIP = [
      "127.0.0.0/8"
      "::1"
      # "203.0.113.42"   # example: your admin IP
      # "2001:db8::/32"  # example: your admin IPv6 range
    ];

    # Progressive bans with a cap; no cross-jail compounding for safety.
    bantime-increment = {
      enable = true;
      overalljails = false;
      rndtime = "5m";
      multipliers = "2 4 8 16 32 64 128 256";
      maxtime = "168h"; # 1 week max
    };

    jails = {
      DEFAULT = {
        settings = mkForce {
          backend = "systemd";
          bantime = "1h";
          findtime = "10m";
          maxretry = 5;
          usedns = "no";
          dbpurgeage = "14d";
        };
      };

      sshd = {
        settings = {
          enabled = true;
          port = "ssh";
          filter = "sshd";
          backend = "systemd";
          journalmatch = "_SYSTEMD_UNIT=sshd.service";
        };
      };
    };
  };
}
