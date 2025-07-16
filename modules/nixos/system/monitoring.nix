{ lib, config, ... }:
let
  inherit (lib) mkIf mkDefault;
in
{
  services = {
    # monitor and control temperature
    thermald.enable = mkIf (config.garden.device.cpu == "intel") true;

    # enable smartd monitoering
    smartd.enable = true;

    # Not using lvm
    lvm.enable = mkDefault false;
  };
}
