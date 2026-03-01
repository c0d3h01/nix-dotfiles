{
  lib,
  userConfig,
  ...
}: let
  selected = userConfig.bootloader or "systemd";
in {
  boot.loader.systemd-boot = lib.mkIf (selected == "systemd") {
    enable = true;
    configurationLimit = 15;
    editor = false;
  };
}
