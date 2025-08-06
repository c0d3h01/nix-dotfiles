{
  config,
  userConfig,
  pkgs,
  lib,
  ...
}:

{
  config = lib.mkIf userConfig.machineConfig.workstation {
    programs.dconf.enable = true;

    services = {
      gvfs.enable = true;
      udisks2.enable = true;

      dbus = {
        enable = true;
        implementation = "broker";
        packages = with pkgs; [
          dconf
          gcr_4
          udisks2
        ];
      };
    };
  };
}
