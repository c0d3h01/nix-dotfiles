{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optionals mkIf mkMerge mkAfter;
  # Core runtime libraries needed by a large class of prebuilt binaries.
  baseLibs = with pkgs; [
    glibc # C runtime + ld-linux
    stdenv.cc.cc.lib # libstdc++
    zlib
    bzip2
    xz
    zstd
    openssl
    curl # libcurl
    expat
    libxml2
    icu
    libsodium
    libunwind
    libuuid
    attr
    acl
    libffi
    gmp
    sqlite
    libsecret
    libssh
    libusb1
    nspr
    nss
    libnotify
    fontconfig
    freetype
    harfbuzz
    util-linux # for libblkid, libmount, libuuid
  ];

  # Extra generic libs frequently required but not always necessary.
  extendedLibs = with pkgs; [
    # Compression / archiving already mostly covered.
    fuse3
    libsodium
    # Image / media codecs often needed by GUI apps
    libpng
    libjpeg
    libtiff
    libwebp
    # DBus at runtime
    dbus
  ];

  # GUI/graphics stack.
  graphicsLibs = with pkgs; [
    # Core GTK / GL / X / Wayland relevant libs
    glib
    pango
    cairo
    gdk-pixbuf
    atk
    at-spi2-atk
    at-spi2-core
    gtk3
    gtk4
    libxkbcommon
    mesa
    libglvnd
    vulkan-loader
    vulkan-memory-allocator
    libdrm
    libva
    libva-vdpau-driver
    libappindicator-gtk3
    # X11 libs commonly referenced
    xorg.libX11
    xorg.libXext
    xorg.libXfixes
    xorg.libXdamage
    xorg.libXcomposite
    xorg.libXrender
    xorg.libXrandr
    xorg.libXcursor
    xorg.libXi
    xorg.libXtst
    xorg.libXScrnSaver
    xorg.libxcb
    xorg.libxkbfile
    xorg.libxshmfence
    # Audio
    alsa-lib
    pipewire
  ];

  optionalSystemdLibs = with pkgs; [
    systemd
  ];

  finalLibs =
    baseLibs
    ++ extendedLibs
    ++ optionals (
      config.services.xserver.enable || config.programs.hyprland.enable || config.programs.sway.enable
    ) graphicsLibs
    ++ optionalSystemdLibs;

in
{
  programs.nix-ld = {
    enable = true;
    # Only runtime libraries. Avoid build tools here.
    libraries = finalLibs;
  };

  # A quick way to inspect what nix-ld will expose
  # (purely informational; remove if you don't want the derivation).
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "show-nix-ld-libs" ''
      echo "Effective nix-ld runtime library path:"
      echo "${lib.makeLibraryPath finalLibs}"
    '')
  ];

  # Foreign binaries frequently and want clearer diagnostics:
  # environment.variables.LD_DEBUG = "libs"; # Uncomment temporarily for troubleshooting missing libs.
}

