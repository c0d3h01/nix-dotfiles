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
    garden.packages = {
      # Notion Enhancer With patches
      notion-app-enhanced = pkgs.callPackage ./notion-app-enhanced { };
    };
  };
}
