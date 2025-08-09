{
  c0d3h01 = {
    /**
      Primary laptop based userConfigs
      Default shell: zsh
      Secrets management: sops, sops-nix
      Filesystem: btrfs with subvolumes \
      Mount points: Disko config
    */

    username = "c0d3h01";
    hostname = "nixos";
    fullName = "Harshal Sawant";
    system = "x86_64-linux";

    machineConfig = {
      type = "laptop"; # Options = "laptop" | "server"
      workstation = true; # Proper GUI support & apps
      bootloader = "systemd"; # Options = "systemd" | "grub"
      cpuType = "amd"; # Options = "amd" | "intel"
      gpuType = "amd"; # Options = "amd" | "nvidia" | "intel"
      gaming = false;
      networking.backend = "iwd"; # Options = "iwd" | "wpa_supplicant"
    };

    desktopEnv = {
      theme = "dark";
      windowManager = "gnome"; # Options = "gnome" | "kde"
    };

    devStack = {
      ollama = true;
      tabby = false;
      virtualisation = true;
      wine = false; # WinApps with 32 bit support
      monitoring = false; # Monitoring grouped tools
      container = "podman"; # Options = "docker" | "podman"
      db = true; # Mysql - DBMS
    };
  };
}
