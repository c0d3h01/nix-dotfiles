{
  userConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) optionals;
  isWorkstation = userConfig.workstation;

  # DESKTOP APPLICATIONS
  desktopApps = with pkgs; [
    vscode-fhs
    postman
    github-desktop
    drawio
    burpsuite
  ];

in {
  environment.systemPackages = (optionals isWorkstation desktopApps);
}
