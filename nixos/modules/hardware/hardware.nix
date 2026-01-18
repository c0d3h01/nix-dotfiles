{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "ahci"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [];
      systemd.enable = true;
      compressor = "zstd";
      compressorArgs = ["-3" "-T0"];
    };

    kernelModules = ["kvm-amd"];

    # kernel params
    kernelParams = [
      "mitigations=off"
    ];

    # Tmpfs: Conservative 40% (2.4GB) to prevent OOM on 6GB system
    tmp = {
      useTmpfs = true;
      tmpfsSize = "40%";
    };

    supportedFilesystems = ["ntfs" "exfat" "vfat"];
  };

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault true;
    enableRedistributableFirmware = true;
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = "x86_64-linux";

  # Firmware updates
  services.fwupd = {
    enable = true;
    daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
  };

  # ACPI/backlight
  services.acpid.enable = true;
  hardware.acpilight.enable = true;
}
