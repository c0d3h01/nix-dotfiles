{
  lib,
  config,
  userConfig,
  ...
}:
let
  inherit (lib) mkIf;
  iftrue = userConfig.machineConfig.server.enable;
in
{
  config = mkIf iftrue {
    # limit systemd journal size
    # https://wiki.archlinux.org/title/Systemd/Journal#Persistent_journals
    services.journald.extraConfig = ''
      SystemMaxUse=100M
      RuntimeMaxUse=50M
      SystemMaxFileSize=50M
    '';
  };
}

