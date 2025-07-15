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
  config = mkIf config.garden.profiles.workstation.enable {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
      dumpcap.enable = true;
      usbmon.enable = true;
    };
  };
}
