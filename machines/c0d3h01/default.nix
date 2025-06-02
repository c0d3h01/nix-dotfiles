{
  config,
  pkgs,
  userConfig,
  ...
}:

{
  imports = [
    ../installer/disko-config.nix
    ./hardware.nix
    ../../nixosModules
    ../../secrets
  ];

  age.secrets.ssh.file = ../../secrets/ssh.age;
  documentation.enable = false;

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

  # Configure keymap in x11
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
    videoDrivers = [ "amdgpu" ];
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id.indexOf("org.freedesktop.udisks2.filesystem-mount") == 0 &&
            subject.isInGroup("users")) {
            return polkit.Result.YES;
        }
    });
  '';

  users.users.${userConfig.username} = {
    description = userConfig.fullName;
    isNormalUser = true;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    hashedPasswordFile = config.age.secrets.ssh.path;
    home = "/home/${userConfig.username}";
    openssh.authorizedKeys.keys = [
      (builtins.readFile ../../secrets/ssh.pub)
    ];
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "adbusers"
      "wireshark"
      "usbmon"
    ];
  };
}
