{
  lib,
  config,
  ...
}:
let
  inherit (lib) elem mkIf;
in
{
  config = mkIf (elem "c0d3h01" config.garden.system.users) {
    home-manager.users.c0d3h01.garden = { };

    users.users.c0d3h01 = {
      hashedPassword = "$6$aXq5Okrj6w0/MKTc$Bx9M4vijoRTa7wd8W0.xOr.kItJo4o9RYcvWto/o7VybA9DIG2GcFYPw0W6Y1wZZ0C/RIuaJOkrCCa.4slxGG.";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSjL8HGjiSAnLHupMZin095bql7A8+UDfc7t9XCZs8l harshalsawant.dev@gmail.com"
      ];
    };
  };
}
