{
  lib,
  pkgs,
  userConfig,
  ...
}: {
  # Set hostname
  networking.hostName = userConfig.hostname;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
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

  # Zsh program enabled as default user
  programs.zsh.enable = true;

  # Default browser
  programs.firefox.enable = true;

  # Create the main user
  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = userConfig.fullName;

    # z - shell default for users
    shell = pkgs.zsh;

    # Add global user groups
    extraGroups = [
      "wheel"
      "networkmanager"
      "git"
    ];
  };
}
