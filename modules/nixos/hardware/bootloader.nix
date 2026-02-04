{lib, ...}: {
  # Bootloader.
  boot.loader = {
    timeout = 5;
    efi.canTouchEfiVariables = lib.mkDefault true;

    systemd-boot = {
      enable = true;
      configurationLimit = lib.mkDefault 15;
      editor = false;
    };
  };
}
