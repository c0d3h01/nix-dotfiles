{
  lib,
  userConfig,
  ...
}: let
  selected = userConfig.bootloader or "systemd";
in {
  boot.loader.grub = lib.mkIf (selected == "grub") {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = false;
    configurationLimit = 15;
  };
}
