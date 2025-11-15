{
  config,
  userConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = userConfig.machineConfig;
in
{
  config = mkIf cfg.glApps {
    # nix-gl configuration for GPU support
    nixGL = {
      packages = pkgs.nixgl.auto.nixGLDefault;
      defaultWrapper = "mesa";
      installScripts = [ "mesa" ];
    };
  };
}