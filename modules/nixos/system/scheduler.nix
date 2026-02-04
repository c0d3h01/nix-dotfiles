{
  lib,
  userConfig,
  ...
}: let
  isWorkstation = userConfig.workstation or false;
in
  lib.mkMerge [
    {
      services.irqbalance.enable = lib.mkDefault isWorkstation;

      services.scx = {
        enable = isWorkstation;
        scheduler = lib.mkDefault "scx_lavd";
        extraArgs = lib.mkDefault [
          "--performance"
          "--log-level"
          "warn"
        ];
      };
    }

    # If the scheduler crashes, restart quickly so we don't sit on the fallback scheduler for long.
    (lib.mkIf isWorkstation {
      systemd.services.scx.serviceConfig.RestartSec = lib.mkDefault 1;
    })
  ]
