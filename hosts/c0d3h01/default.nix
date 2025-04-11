{ pkgs
, user
, ...
}: {

  imports = [
    ../../modules
    ../../secrets
    ./hardware-configuration.nix
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

  users.users.${user.username} = {
    description = "${user.fullName}";
    isNormalUser = true;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    home = "/home/${user.username}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
    ];
    # passwordFile = config.age.secrets.passwordFile;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMHEDTYxp5o3ZLpEg4fWjXZ/MctVco8R9qYVfE0tIn+ c0d3h01@gmail.com"
    ];
  };
}
