# Purpose: User account, locale, hostname, and developer environment base config
{
  lib,
  pkgs,
  hostConfig,
  hostProfile,
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

  documentation = {
    dev.enable = false;
    man.enable = false;
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  users.users.${hostConfig.username} = {
    isNormalUser = true;
    createHome = true;
    description = hostConfig.fullName;
    shell = pkgs.zsh;

    extraGroups = [
      "adbusers" # Android USB debugging
      "audio"
      "dialout" # Serial ports (USB-UART, Arduino, etc.)
      "input" # Direct input device access
      "kvm" # KVM hardware acceleration for VMs
      "networkmanager"
      "plugdev" # USB peripherals
      "video"
      "wheel"
    ];
  };
}
