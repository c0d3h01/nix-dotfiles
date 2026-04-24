{
  # Early OOM killer to prevent system hangs before systemd-oomd kicks in
  services.earlyoom = {
    enable = true;
    enableNotifications = true;

    # Kill processes when memory is critically low
    freeMemThreshold = 5; # Trigger at 5% free memory
    freeSwapThreshold = 10; # Trigger at 10% free swap

    extraArgs = [
      "--prefer"
      "-100" # Prefer killing processes with high memory usage
      "--avoid"
      "sshd"
      "--avoid"
      "systemd"
      "--avoid"
      "dbus"
      "--avoid"
      "NetworkManager"
    ];
  };
}
