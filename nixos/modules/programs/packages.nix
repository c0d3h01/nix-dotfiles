{
  userConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) optionals;
  isWorkstation = userConfig.machineConfig.workstation;

  # DESKTOP APPLICATIONS
  desktopApps = with pkgs; [
    brave
    vscode-fhs
    postman
    github-desktop
    drawio
    libreoffice-still
    arduino
  ];

  # DEVELOPMENT & SYSTEM TOOLS
  devSystemTools = with pkgs; [
    # Development
    gdb
    mold
    sccache
    nil
    nixd
    gcc
    clang
    zig
    rustup
    openjdk17
    lld
    nasm

    # System Utilities
    ouch
    psmisc
    colordiff
    sipcalc
    openssl
    lsof
    inxi
    strace
    ltrace
    bandwhich
    man-pages
    rsync
    tig
    binutils
    usbutils
    pciutils
    minicom
    cutecom
    flashrom
    iperf
    wget
    curl
    iw
    tcpdump
    netcat
    mtr
    whois
    dnsutils
    tcpflow
    tcpreplay
    bandwhich
    netcat-gnu
    netmask
    fping
    darkstat
    wavemon
    swaks
    sipp
    sipsak

    # Libraries
    glibc
    glfw
    gtk3

    # File & Storage
    p7zip
    unrar
    lvm2
    cifs-utils
    nfs-utils
    samba
    atftp
    util-linux
    cabextract
    mlocate
  ];
in {
  environment.systemPackages = (optionals isWorkstation desktopApps) ++ devSystemTools;
}
