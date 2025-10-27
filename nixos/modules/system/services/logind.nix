{
  lib,
  config,
  userConfig,
  ...
}:
let
  inherit (lib) mkIf;
  isLaptop = userConfig.machineConfig.laptop.enable;
in
{
  config = mkIf isLaptop {
    # Let logind manage power actions on laptops
    services.logind = {
      settings.Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchDocked = "ignore";
        HandlePowerKey = "suspend-then-hibernate";
        HandleLidSwitchExternalPower = "suspend-then-hibernate";
      };
    };
  };
}

