{
  lib,
  userConfig,
  ...
}: let
  selected = userConfig.bootloader or "systemd";
in {
  imports = [
    # keep-sorted start
    ./grub.nix
    ./limine.nix
    ./systemd.nix
    # keep-sorted end
  ];

  # Bootloader.
  boot.loader = {
    timeout = 5;
    efi.canTouchEfiVariables = true;
  };

  assertions = [
    {
      assertion = lib.elem selected [
        "systemd"
        "limine"
        "grub"
      ];
      message = "userConfig.bootloader must be one of: systemd, limine, grub.";
    }
  ];
}
