{
  lib,
  hostConfig,
  ...
}: let
  hostProfile = {
    isWorkstation = hostConfig.workstation or false;
    windowManager = hostConfig.windowManager or "gnome";
    bootloader = hostConfig.bootloader or "systemd";
  };
in {
  _module.args.hostProfile = hostProfile;

  assertions = [
    {
      assertion = lib.elem hostProfile.windowManager [
        "gnome"
        "kde"
        "xfce"
      ];
      message = "hostConfig.windowManager must be one of: gnome, kde, xfce.";
    }
    {
      assertion = lib.elem hostProfile.bootloader [
        "systemd"
        "limine"
        "grub"
      ];
      message = "hostConfig.bootloader must be one of: systemd, limine, grub.";
    }
  ];
}
