{ config, pkgs, ... }:

{
  imports = [
    # ./android.nix
    ./devtools
    # ./printing.nix
    # ./vm.nix
  ];

  # System configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      max-jobs = "auto";
      cores = 0;
      # Cache configuration
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431Cz7knE28jzE3KFW4c9fPyNn6zhG3QHw="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Enable flatpak support
  # services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal ];
  };

  # Development environment packages
  environment.systemPackages =
    let
      # Group packages by category for better organization
      devTools = with pkgs; [
        # Utilities
        nix-ld

        # Editors and IDEs
        vscode-fhs
        jetbrains.webstorm

        # Version control
        git
        github-desktop

        # JavaScript/TypeScript
        nodejs
        nodePackages.node2nix
        nodePackages.typescript
        nodePackages.typescript-language-server
        nodePackages.vscode-langservers-extracted
        nodePackages.prettier
        nodePackages.eslint

        # Java
        openjdk
        gradle

        # C/C++
        clang
        gnumake
        cmake
        ninja

        # Graphics libraries
        glib
        glfw
        glew
        glm
        sfml

        # API Development
        postman
      ];

      communicationApps = with pkgs; [
        discord
        telegram-desktop
        slack
        zoom-us
        element-desktop
      ];

      desktopApps = with pkgs; [
        # Custom patched Notion
        (pkgs.callPackage ./notion-app-enhanced { })
        libreoffice
        tor-browser
        spotify
        transmission_4-gtk
        google-chrome
        anydesk
      ];

      networkingTools = with pkgs; [
        metasploit
        nmap
        wireshark
        tcpdump
      ];
    in
    devTools ++ communicationApps ++ desktopApps ++ networkingTools;
}
