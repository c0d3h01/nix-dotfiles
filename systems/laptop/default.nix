{
  inputs,
  lib,
  userConfig,
  ...
}:
let
  isUsr = userConfig.username == "harshal";
  ssh-keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSjL8HGjiSAnLHupMZin095bql7A8+UDfc7t9XCZs8l" ];
in
{
  imports = [
    ./hardware.nix
  ];

  users.users = lib.mkIf isUsr {
    root = {
      # Allow the user to log in as root without a password.
      hashedPassword = "";
      openssh.authorizedKeys.keys = ssh-keys;
    };

    harshal = {
      home = "/home/harshal";
      hashedPassword = "$y$j9T$zv/9zYffWILQWXz9xwMaa0$oKN.JemKWm/KA4p.mO3rzSIS.ODD7jQeeG5NbvQ0Wa5";
      openssh.authorizedKeys.keys = ssh-keys;
    };
  };
}
