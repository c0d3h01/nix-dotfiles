{
  pkgs,
  hostConfig,
  ...
}: {
  # Identity & Time
  networking.hostName = hostConfig.hostname;
  time.timeZone = "Asia/Kolkata";

  # Locale (UTF-8)
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
    LC_ALL = "en_IN";
  };

  # System State Version
  system.stateVersion = hostConfig.stateVersion;

  # Shell Environment
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Primary User Configuration
  users.groups.${hostConfig.username} = {};

  users.users.${hostConfig.username} = {
    isNormalUser = true;
    createHome = true;
    description = hostConfig.fullName;
    group = hostConfig.username;
    shell = pkgs.zsh;

    extraGroups = [
      "wheel" # Sudo access
      "audio" # Sound/PipeWire
      "video" # GPU acceleration
      "networkmanager" # Network control
    ];
  };
}
