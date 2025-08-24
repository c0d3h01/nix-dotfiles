{
  lib,
  config,
  userConfig,
  ...
}:
{
  config = lib.mkIf (userConfig.machineConfig.type == "laptop") {
    # Let logind manage power actions on laptops
    services.logind = {
      lidSwitch = "suspend-then-hibernate";
      lidSwitchExternalPower = "suspend-then-hibernate";
      lidSwitchDocked = "ignore";
      powerKey = "suspend-then-hibernate";
    };

    systemd.sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=yes
      AllowSuspendThenHibernate=yes
      AllowHybridSleep=yes
      HibernateDelaySec=45min
    '';
  };
}
