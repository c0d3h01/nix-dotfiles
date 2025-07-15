{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.garden.profiles.laptop.enable {
    services.undervolt = mkIf (config.garden.device.cpu == "intel") {
      enable = true;
      tempBat = 65;
      package = pkgs.undervolt;
    };
  };
}
