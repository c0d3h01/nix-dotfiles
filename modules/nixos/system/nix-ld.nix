# System — nix-ld, AppImage, Flatpak — run non-Nix binaries
{
  pkgs,
  lib,
  config,
  hostProfile,
  ...
}: {
  # ── nix-ld — dynamic linker for unpatched binaries ──────────────────
  programs.nix-ld.enable = lib.mkDefault true;
  programs.nix-ld.libraries = with pkgs;
    [
      acl
      attr
      bzip2
      dbus
      expat
      fontconfig
      freetype
      fuse3
      icu
      libnotify
      libsodium
      libssh
      libunwind
      libusb1
      libuuid
      nspr
      nss
      stdenv.cc.cc
      util-linux
      zlib
      zstd
    ]
    ++ lib.optionals config.hardware.graphics.enable [
      pipewire
      cups
      libxkbcommon
      pango
      mesa
      libdrm
      libglvnd
      libpulseaudio
      atk
      cairo
      alsa-lib
      at-spi2-atk
      at-spi2-core
      gdk-pixbuf
      glib
      gtk3
      libGL
      libappindicator-gtk3
      vulkan-loader
      libx11
      libxscrnsaver
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxrandr
      libxrender
      libxtst
      libxcb
      libxkbfile
      libxshmfence
    ];

  # ── AppImage — binfmt registration for .AppImage files ──────────────
  programs.appimage = {
    enable = hostProfile.isWorkstation;
    binfmt = true;
  };

  # ── Flatpak — disabled by default, enable if needed ─────────────────
  # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  services.flatpak.enable = lib.mkIf hostProfile.isWorkstation false;
}
