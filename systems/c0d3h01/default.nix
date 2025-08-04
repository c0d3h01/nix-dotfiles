{
  config,
  lib,
  userConfig,
  ...
}:
let
  # Check if current user is c0d3h01
  isC0d3h01 = userConfig.username == "c0d3h01";
in
{
  imports = [
    ./disko-btrfs.nix
  ];

  sops.secrets.keys-password.neededForUsers = true;
  sops.secrets.keys-password = { };

  users.users = lib.mkIf isC0d3h01 {
    root = {
      # Allow the user to log in as root without a password.
      hashedPassword = "";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSjL8HGjiSAnLHupMZin095bql7A8+UDfc7t9XCZs8l"
      ];
    };

    c0d3h01 = {
      home = "/home/c0d3h01";
      hashedPasswordFile = config.sops.secrets.keys-password.path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSjL8HGjiSAnLHupMZin095bql7A8+UDfc7t9XCZs8l"
      ];
      extraGroups = [
        "adbusers"
        "wireshark"
        "usbmon"
      ];
    };
  };
}
