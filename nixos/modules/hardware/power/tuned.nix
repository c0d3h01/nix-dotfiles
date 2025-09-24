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
    services = {
      tuned = {
        enable = true;

        # auto magically change the profile based on the battery charging state
        # ppdSettings.main.battery_detection = true;
      };
    };
  };
}
