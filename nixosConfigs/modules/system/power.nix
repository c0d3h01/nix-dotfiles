{
  lib,
  userConfig,
  ...
}:
let
  isLaptop = userConfig.machine ? hasBattery && userConfig.machine.hasBattery;
in
{
  # Performance optimizations
  powerManagement = lib.mkIf isLaptop {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };
}
