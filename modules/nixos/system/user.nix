{
  pkgs,
  hostConfig,
  ...
}: {
  # Identity & Time
  networking.hostName = "nixos";
  time.timeZone = "Asia/Kolkata";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = ["en_IN/UTF-8"];
  i18n.extraLocaleSettings = {
    LC_CTYPE = "en_US.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_COLLATE = "en_US.UTF-8";
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # System State Version
  system.stateVersion = "25.11";

  # Shell Environment
  programs.zsh.enable = true;

  # User Configuration
  users.users = {
    c0d3h01 = {
      isNormalUser = true;
      createHome = true;
      description = "Harshal Sawant";
      shell = pkgs.zsh;

      extraGroups = [
        "wheel"
        "users"
        "networkmanager"
      ];
    };

    anon = {
      isNormalUser = true;
      createHome = true;
      description = "Anony";

      extraGroups = [
        "networkmanager"
      ];
    };
  };
}
