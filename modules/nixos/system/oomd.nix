{lib, ...}: {
  systemd.oomd = {
    enable = lib.mkDefault true;
    enableRootSlice = true;
    enableUserSlices = true;
    enableSystemSlice = true;
  };

  systemd.services.nix-daemon.serviceConfig = {
    OOMPolicy = "continue";
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "80%";
  };
}
