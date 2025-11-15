{
  config,
  userConfig,
  lib,
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
      packages = lib.nixGL.auto.nixGLDefault;
      defaultWrapper = "mesa";
      installScripts = [ "mesa" ];
    };
  };
}