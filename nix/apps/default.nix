{ config, pkgs, ... }:

{
  imports = [
    ./devtools
    ./printing.nix
  ];

  # -*- Allow unfree softwares -*-
  nixpkgs.config.allowUnfree = true;

  # -*- Allow Nix experimental-features enable -*-
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # -*-[ Automatic cleanup ]-*-
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.settings.auto-optimise-store = true;

  # Enables nix-ld to run dynamically linked binaries outside the Nix store
  programs.nix-ld.enable = true;

  # flatpak Apps
  # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  # services.flatpak.enable = true;
  # xdg.portal.enable = true;

  # Limit Nix Build Jobs
  nix.settings.max-jobs = 2;
  nix.settings.substituters = [ "https://cache.nixos.org" ];
  nix.settings.trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431Cz7knE28jzE3KFW4c9fPyNn6zhG3QHw=" ];

  environment.systemPackages = with pkgs; [
    # Notion fix patch
    (pkgs.callPackage ./notion-app-enhanced { })
    notion-app-enhanced # Notion Desktop

    # -*- Desktop GUI Apps -*-
    jetbrains.webstorm
    discord
    telegram-desktop
    github-desktop
    vscodium
    slack
    zoom-us
    anydesk
    libreoffice
    element-desktop
    tor-browser
    spotify
    transmission_4-gtk
    google-chrome
    postman

    # Networking tools.
    metasploit # msfconsole 
    nmap

    # Java.
    zulu23

    # Development tools.
    nodejs
    yarn

    # C/C++ tools
    clang
    gnumake
    cmake
    ninja
    glib
    glfw
    glew
    glm
  ];
}

