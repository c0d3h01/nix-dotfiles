{
  config,
  userConfig,
  pkgs,
  nixgl,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.lib.nixGL) wrap;
  cfg = userConfig.machineConfig;
in
{
  config = mkIf cfg.glApps {
    # NixGL configuration for GPU support
    nixGL = {
      vulkan.enable = true;
      inherit (nixgl) packages;
      defaultWrapper = "mesaPrime";
      offloadWrapper = "mesaPrime";
      installScripts = [ "mesaPrime" ];
    };

    # Desktop applications with GL support
    home.packages = with wrap pkgs; [
      # vscode
    ];
  };
}
