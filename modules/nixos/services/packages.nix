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
    google-chrome
    vscode-fhs
    postman
    github-desktop
    element-desktop
    signal-desktop
    telegram-desktop
    discord
    slack
    zoom-us
    drawio
    libreoffice-still
    librewolf-bin
    wezterm
    burpsuite
  ];

  # DEVELOPMENT & SYSTEM TOOLS
  corePackages = with pkgs; [
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
    zstd
    hashcat
    nmap
    metasploit
    armitage
    sqlmap
  ];
in {
  environment.systemPackages =
    corePackages
    ++ (optionals isWorkstation desktopApps);
}
