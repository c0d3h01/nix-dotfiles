{
  pkgs,
  userConfig,
  lib,
  ...
}:
{
  services.scx = lib.mkIf userConfig.machineConfig.workstation.enable {
    enable = true;
    scheduler = "scx_bpfland";
    package = pkgs.scx.rustscheds;
  };
}

