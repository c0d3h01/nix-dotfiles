{
  # systemd DNS resolver daemon
  services.resolved.enable = true;

  systemd.network.wait-online.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
}
