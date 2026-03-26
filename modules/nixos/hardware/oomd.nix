{lib, ...}: let
  inherit (lib) mkDefault;
in {
  systemd = {
    oomd = {
      enable = true;
      enableRootSlice = true;
      enableUserSlices = true;
      enableSystemSlice = true;
      settings.OOM = {
        DefaultMemoryPressureDurationSec = "8s";
        DefaultSwapUsedLimit = "40%";
      };
    };

    services.nix-daemon.serviceConfig.OOMScoreAdjust = mkDefault 500;
  };
}
