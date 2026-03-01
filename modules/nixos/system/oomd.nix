{lib, ...}: {
  # systemd-oomd kills runaway processes before the kernel OOM killer
  # freezes the entire desktop.  Nix builds are expendable; GNOME is not.
  systemd.oomd = {
    enable = lib.mkDefault true;
    enableRootSlice = true;
    enableUserSlices = true;
    enableSystemSlice = true;
  };

  # Let a killed nix build fail gracefully without tearing down the daemon
  systemd.services.nix-daemon.serviceConfig = {
    OOMPolicy = "continue";
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "80%";
  };
}
