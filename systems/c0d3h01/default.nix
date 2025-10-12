{
  lib,
  userConfig,
  ...
}:
let
  # Check if current user is c0d3h01
  isC0d3h01 = userConfig.username == "c0d3h01";
  ssh-keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSjL8HGjiSAnLHupMZin095bql7A8+UDfc7t9XCZs8l" ];
in
{
  imports = [
    ./hardware.nix
  ];

  users.users = lib.mkIf isC0d3h01 {
    root = {
      # Allow the user to log in as root without a password.
      hashedPassword = "";
      openssh.authorizedKeys.keys = ssh-keys;
    };

    c0d3h01 = {
      home = "/home/c0d3h01";
      hashedPassword = "$y$j9T$zv/9zYffWILQWXz9xwMaa0$oKN.JemKWm/KA4p.mO3rzSIS.ODD7jQeeG5NbvQ0Wa5";
      openssh.authorizedKeys.keys = ssh-keys;
    };
  };
}
