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
    element-desktop
    telegram-desktop
    discord
    drawio
    burpsuite
    ghidra
  ];
in {
  environment.systemPackages = optionals isWorkstation desktopApps;
}
