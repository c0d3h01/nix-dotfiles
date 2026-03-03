{
  lib,
  pkgs,
  hostConfig,
  ...
}: {
  networking.hostName = hostConfig.hostname;

  time.timeZone = "Asia/Kolkata";

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

  system.stateVersion = "25.11";

  environment.localBinInPath = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.firefox.enable = true;

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
