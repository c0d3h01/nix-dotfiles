{
  security = {
    auditd.enable = true;

    audit = {
      enable = true;
      backlogLimit = 8192;
      failureMode = "printk";
      rules = [ "-a exit,always -F arch=b64 -S execve" ];
    };
  };

  systemd.timers."clean-audit-log" = {
    description = "Periodically clean audit log";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services."clean-audit-log" = {
    script = ''
      set -eu
      if [[ $(stat -c "%s" /var/log/audit/audit.log) -gt 524288000 ]]; then
        echo "Clearing Audit Log";
        rm -rvf /var/log/audit/audit.log;
        echo "Done!"
      fi
    '';

    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
