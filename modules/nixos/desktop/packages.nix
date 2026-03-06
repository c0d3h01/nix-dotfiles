{
  hostProfile,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) optionals;
  inherit (hostProfile) isWorkstation;

  desktopApps = with pkgs; [
    vscode-fhs
    brave
    antigravity-fhs
    postman
    github-desktop
    slack
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
