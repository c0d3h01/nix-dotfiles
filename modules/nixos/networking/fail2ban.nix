{
  lib,
  userConfig,
  ...
}: let
  isWorkstation = userConfig.workstation or false;
in {
  services.fail2ban = lib.mkIf isWorkstation {
    enable = true;

    banaction = "nftables-multiport";
    banaction-allports = "nftables-allports";
    bantime = "12h";
    maxretry = 5;

    jails.DEFAULT.settings = {
      # Applied to all jails unless overridden
      findtime = "10m";
      logencoding = "UTF-8";
    };

    jails = {
      sshd = {
        enabled = true;
        settings = {
          port = "ssh";
          filter = "sshd";
          logpath = "%(sshd_log)s";
          maxretry = 4;
          bantime = "24h";
          findtime = "10m";
          ignoreip = "127.0.0.1/8 ::1";
        };
      };

      recidive = {
        enabled = true;
        settings = {
          filter = "recidive";
          logpath = "%(syslog_authpriv)s";
          bantime = "7d";
          findtime = "1d";
          maxretry = 5;
        };
      };
    };
  };
}
