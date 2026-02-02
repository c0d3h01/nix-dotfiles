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
    brave
    google-chrome
    vscode-fhs
    postman
    github-desktop
    element-desktop
    telegram-desktop
    discord
    slack
    zoom-us
    drawio
    libreoffice-still
    librewolf-bin
    wezterm
  ];

  # DEVELOPMENT & SYSTEM TOOLS
  devSystemTools = with pkgs; [
    gdb
    mold
    sccache
    nil
    gcc
    clang
    zig
    rustup
    openjdk17
    lld
    ouch
    colordiff
    openssl
    inxi
    rsync
    iperf
    wget
    curl
  ];
in {
  environment.systemPackages = (optionals isWorkstation desktopApps) ++ devSystemTools;
}
