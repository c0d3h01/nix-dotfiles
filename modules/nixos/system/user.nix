# System — user management, hostname, timezone, locale
{
  lib,
  pkgs,
  hostConfig,
  ...
}: {
  # Hostname from host registry
  networking.hostName = hostConfig.hostname;

  # Timezone
  time.timeZone = "Asia/Kolkata";

  # Internationalisation
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
  };

  # System state version
  system.stateVersion = "25.11";

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Default shell — zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Default browser
  programs.firefox.enable = true;

  # Main user account
  users.users.${hostConfig.username} = {
    isNormalUser = true;
    createHome = true;
    description = hostConfig.fullName;
    shell = pkgs.zsh;

    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ];
  };
}
