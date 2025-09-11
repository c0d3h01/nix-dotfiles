{
  lib,
  userConfig,
  config,
  ...
}:
{
  config = lib.mkIf userConfig.machineConfig.workstation.enable {
    # we need dconf to interact with gtk
    programs.dconf.enable = true;

    # gnome's keyring manager
    services.gnome.gnome-keyring.enable = true;

    # GUI secrets manager
    programs.seahorse.enable = true;

    # Automount service
    services.udisks2.enable = true;
  };
}
