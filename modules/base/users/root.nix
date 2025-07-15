{ lib, _class, ... }:

{
  users.users.root = lib.mkIf (_class == "nixos") {
    initialPassword = "root";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSjL8HGjiSAnLHupMZin095bql7A8+UDfc7t9XCZs8l harshalsawant.dev@gmail.com"
    ];
  };
}
