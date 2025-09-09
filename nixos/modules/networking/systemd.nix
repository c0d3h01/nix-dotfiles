{
  # systemd DNS resolver daemon
  services.resolved.enable = true;

  # Faster boot: don't block on network-online
  systemd.network.wait-online.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;

  # disable networkd and resolved from being restarted on configuration changes
  # also prevents failures from services that are restarted instead of stopped
  systemd.services.systemd-networkd.stopIfChanged = false;
  systemd.services.systemd-resolved.stopIfChanged = false;
}
