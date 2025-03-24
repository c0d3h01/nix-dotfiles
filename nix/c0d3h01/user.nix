{ config, pkgs, username, ... }:

{
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  services.timesyncd.enable = true;

  # -*- Define a user account -*-
  users.users.${username} = {
    description = "Harshal Sawant";

    isNormalUser = true;

    home = "/home/${username}";
    shell = pkgs.zsh;

    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "dialout"
      "plugdev"
      "kvm" # hardware acceleration
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINcq9uTCVusCJRWgHTj8u4sdvvuXfPZcinAYTbNZW+eI c0d3h01@gmail.com"
    ];
  };

  # Enable Zsh shell (alternative to Bash)
  programs.zsh.enable = true;

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
}
