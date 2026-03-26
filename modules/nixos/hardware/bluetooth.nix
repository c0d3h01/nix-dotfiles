{
  config,
  lib,
  hostProfile,
  ...
}: {
  hardware.bluetooth = {
    enable = true;
    # Power on Bluetooth adapter at boot
    powerOnBoot = true;

    settings = {
      General = {
        # Enable experimental features (LE Audio, etc.)
        Experimental = true;
        # Make device discoverable faster
        FastConnectable = true;
        # Improve compatibility with various devices
        KernelExperimental = "true";
      };
      Policy = {
        # Auto-enable services for connected devices
        AutoEnable = true;
      };
      # Low-latency tweaks for audio/mouse
      General = {
        # Reduce latency for HID devices
        FastIdleTimeout = "1";
      };
    };
  };

  # Enable bluetooth service restart on failure
  systemd.services.bluetooth.serviceConfig.Restart = "on-failure";
}
