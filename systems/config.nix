{
  c0d3h01 = {
    username = "c0d3h01";
    hostname = "eva";
    fullName = "Harshal Sawant";
    system = "x86_64-linux";

    machineConfig = {
      server.enable = false;
      laptop.enable = true;
      workstation.enable = true;
      bootloader = "systemd"; # Options = "systemd" | "grub"
      cpuType = "amd"; # Options = "amd" | "intel"
      gpuType = "amd"; # Options = "amd" | "nvidia" | "intel"
      networking.backend = "wpa_supplicant"; # Options = "iwd" | "wpa_supplicant"
      windowManager = "gnome"; # Options = "gnome" | "kde"
    };

    devStack = {
      ollama.enable = false;
      tabby.enable = false;
      virtualisation.enable = false; # VM
      monitoring.enable = false; # Monitoring grouped tools
      container = "podman"; # Options = "docker" | "podman"
      sql.enable = false; # Mysql - DBMS
    };
  };
}
