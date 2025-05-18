{ pkgs, userConfig, ... }:

{
  imports = [
    ../installer/disko-config.nix
    ./hardware.nix
    ../../nixos
    ../../apps
    ../../secrets
  ];

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

  users.users.${userConfig.username} = {
    description = userConfig.fullName;
    isNormalUser = true;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    home = "/home/${userConfig.username}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "adbusers"
      "wireshark"
      "usbmon"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOGOsLJ8MvzMo4QMjZYUhObxB565LmF+0PWf3RGClCOQ harshalsawant.dev@gmail.com"
    ];
  };
}
