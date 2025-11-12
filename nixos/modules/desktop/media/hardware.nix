{ lib, userConfig, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf (userConfig.machineConfig.windowManager == "kde") {
    hardware = {
      bluetooth.enable = true;
      bluetooth.powerOnBoot = true;
    };
  };
}
