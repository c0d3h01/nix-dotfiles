{
  laptop = {
    username = "harshal";
    hostname = "firuslab";
    fullName = "Harshal Sawant";
    system = "x86_64-linux";

    machineConfig = {
      server.enable = false;
      laptop.enable = true;
      workstation = true;
      bootloader = "systemd"; # Options = "systemd" | "grub"
      cpuType = "amd"; # Options = "amd" | "intel"
      gpuType = "amd"; # Options = "amd" | "nvidia" | "intel"
      networking.backend = "wpa_supplicant"; # Options = "iwd" | "wpa_supplicant"
      windowManager = "gnome"; # Options = "gnome" | "kde"
      theme = false;
      glApps = false;
    };

    devStack = {
      flutterdevEnable = false;
      container = "docker"; # Options = "docker" | "podman"
    };
  };
}
