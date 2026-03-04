# Purpose: Developer CLI tools and language toolchains for a workstation user
{pkgs, ...}: {
  home.packages = with pkgs; [
    # ── Archiving & file utilities ──────────────────────────────────────
    file
    p7zip
    tree
    unzip
    zip

    # ── Build toolchains ────────────────────────────────────────────────
    clang
    cmake
    gcc
    gnumake
    openssl.dev
    pkg-config

    # ── Data wrangling ──────────────────────────────────────────────────
    jq
    yq-go

    # ── Language runtimes ───────────────────────────────────────────────
    nodejs
    python3

    # ── Modern CLI replacements ─────────────────────────────────────────
    duf # df replacement (disk usage)
    eza # ls replacement
    fd # find replacement
    hyperfine # command benchmarking
    ncdu # interactive disk usage
    tldr # simplified man pages
    tokei # code statistics

    # ── Monitoring ──────────────────────────────────────────────────────
    btop
    htop

    # ── Networking & HTTP ───────────────────────────────────────────────
    curl
    dnsutils # dig, nslookup
    httpie
    nmap
    socat
    traceroute
    wget

    # ── System debugging ────────────────────────────────────────────────
    gdb
    lsof
    ltrace
    pciutils # lspci
    strace
    tcpdump
    usbutils # lsusb
  ];
}
