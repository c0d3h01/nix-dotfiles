# Networking — nftables firewall
{lib, ...}: {
  networking = {
    # nftables is the modern replacement for iptables
    nftables.enable = true;

    firewall = {
      enable = true;

      # ── Allowed ports ─────────────────────────────────────────────────
      allowedTCPPorts = [
        22 # SSH
        80 # HTTP
        443 # HTTPS
        8080 # dev server
        59010 # custom
        59011 # custom
      ];
      allowedUDPPorts = [
        59010
        59011
      ];

      # ── Logging ─────────────────────────────────────────────────────
      # Log reverse-path drops (spoofed source detection)
      logReversePathDrops = true;
      # Don't spam logs with refused connections
      logRefusedConnections = false;

      # ── Reverse-path filtering ──────────────────────────────────────
      # Loose mode — required for libvirtd DHCP / WireGuard
      checkReversePath = lib.mkForce "loose";
    };
  };
}
