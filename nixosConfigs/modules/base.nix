{
  lib,
  userConfig,
  hostName,
  ...
}:

{
  # Basic system configuration that applies to all machines

  # Set hostname
  networking.hostName = userConfig.hostname;

  # System state version
  system.stateVersion = lib.trivial.release;

  programs.zsh.enable = true;
  # Create the main user
  users.users.${userConfig.username} = {
    uid = lib.mkDefault 1000;
    isNormalUser = true;
    description = userConfig.fullName;
    shell = "/run/current-system/sw/bin/zsh";
    extraGroups = [
      "wheel"
      "nix"
      "networkmanager"
      "systemd-journal"
      "audio"
      "pipewire"
      "video"
      "input"
      "plugdev"
      "lp"
      "tss"
      "power"
      "wireshark"
      "mysql"
      "cloudflared"
    ];
  };

  # Enable sudo for wheel group
  security.sudo.wheelNeedsPassword = false;

  # Configure X11
  services.xserver = lib.mkIf userConfig.machineConfig.workstation {
    enable = true;
    xkb = {
      layout = "us";
      variant = ""; # Standard QWERTY
      options = "grp:alt_shift_toggle";
    };

    # Drivers will be detected & set itself
    videoDrivers = [
      "modesetting"
      "fbdev"
    ];
  };

  # Timezone and locale - INDIAN timing
  time.timeZone = "Asia/Kolkata";
  i18n = {
    defaultLocale = "en_IN";
    extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };
  };
}
