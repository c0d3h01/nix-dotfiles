{
  config,
  userConfig,
  pkgs,
  lib,
  ...
}:

{
  config = lib.mkIf userConfig.machineConfig.workstation.enable {
    services.dbus.enable = true;
    services.dbus.implementation = "broker";
    # systemd.services.dbus.environment.DBUS_DEBUG = "0";
  };
}

