{
  boot.loader = {
    timeout = 5;
    efi.canTouchEfiVariables = true;

    grub = {
      enable = true;
      efiSupport = true;
      devices = ["nodev"];
      configurationLimit = 15;
      efiInstallAsRemovable = false;
      useOSProber = false;
    };
  };
}
