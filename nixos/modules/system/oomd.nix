{ lib, ... }:
{
  systemd = {
    # Systemd OOMd
    oomd = {
      enable = lib.mkDefault true;
      enableRootSlice = true;
      enableUserSlices = true;
      enableSystemSlice = true;
      settings.OOM.DefaultMemoryPressureDurationSec = "20s";
    };

    services.nix-daemon.serviceConfig.OOMScoreAdjust = lib.mkDefault 350;
  };
}
