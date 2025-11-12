{
  userConfig,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf userConfig.machineConfig.workstation.enable {
    # AppImage support
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
