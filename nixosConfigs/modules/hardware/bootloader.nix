{ lib, userConfig, ... }:
let
  # Boot loader selection
  useSystemdBoot = userConfig.machine.bootloader == "systemd";
  useGrub = userConfig.machine.bootloader == "grub";
in
{
  boot.loader = {
    timeout = lib.mkForce 5;

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    # GRUB
    grub = {
      enable = useGrub;
      efiSupport = true;
      devices = [ "nodev" ]; # For UEFI
      useOSProber = true;
      memtest86.enable = true;
    };

    # systemd-boot
    systemd-boot = {
      enable = useSystemdBoot;
      configurationLimit = 15;
      memtest86.enable = true;
      consoleMode = "auto";
    };
  };
}
