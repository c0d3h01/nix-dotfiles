{
  inputs,
  config,
  pkgs,
  userConfig,
  ...
}:
let
  c0d3h01 = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSjL8HGjiSAnLHupMZin095bql7A8+UDfc7t9XCZs8l harshalsawant.dev@gmail.com"
  ];

  hashedPass = "$6$aXq5Okrj6w0/MKTc$Bx9M4vijoRTa7wd8W0.xOr.kItJo4o9RYcvWto/o7VybA9DIG2GcFYPw0W6Y1wZZ0C/RIuaJOkrCCa.4slxGG.";
in
{
  imports = [
    # inputs.sops-nix.nixosModules.sops

    ../installer.nix
    ../../nixosModules
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

  users.mutableUsers = false;

  # sops.age = {
  #   keyFile = "/home/c0d3h01/.config/sops/age/keys.txt";
  #   sshKeyPaths = [
  #     "/home/c0d3h01/.ssh/id_ed25519"
  #   ];
  # };

  # sops.secrets = {
  #   "passwd" = {
  #     neededForUsers = true;
  #     sopsFile = ../../secrets/c0d3h01/passwd.enc;
  #     path = "/run/secrets/passwd";
  #     format = "binary";
  #   };
  # };

  users.users = {
    root = {
      # Allow the user to log in as root without a password.
      hashedPassword = "";
      openssh.authorizedKeys.keys = c0d3h01;
    };

    ${userConfig.username} = {
      description = userConfig.fullName;
      isNormalUser = true;
      shell = "/run/current-system/sw/bin/zsh";
      home = "/home/${userConfig.username}";
      # hashedPasswordFile = config.sops.secrets.passwd.path;
      hashedPassword = hashedPass;
      openssh.authorizedKeys.keys = c0d3h01;
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
  };
}
