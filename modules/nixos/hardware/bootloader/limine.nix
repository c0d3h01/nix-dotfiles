{
  lib,
  userConfig,
  ...
}: let
  selected = userConfig.bootloader or "systemd";
in {
  boot.loader = lib.mkIf (selected == "limine") {
    # Make Limine the active bootloader.
    grub.enable = lib.mkForce false;
    systemd-boot.enable = lib.mkForce false;

    limine = {
      enable = true;
      efiSupport = true;
      biosSupport = false;
      maxGenerations = 15;
      enableEditor = false;
    };
  };
}
