{
  pkgs,
  config,
  lib,
  userConfig,
  ...
}:
{
  config = lib.mkIf userConfig.machineConfig.workstation {
    # Default browser
    programs.firefox.enable = true;

    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
      dumpcap.enable = true;
      usbmon.enable = true;
    };

    # Environment packages - only install if GUI is available
    environment.systemPackages =
      with pkgs;
      [
        # Terminal
        ghostty
        neovim # Editor

        # Development tools
        # android-studio-full
        vscode-fhs
        # jetbrains.webstorm
        # jetbrains.pycharm-community-bin
        postman
        github-desktop
        # drawio

        # Communication apps
        # slack
        vesktop # Better Discord client
        telegram-desktop
        zoom-us
        # element-desktop # Matrix client
        # signal-desktop

        # Productivity apps
        # libreoffice
        obsidian

        # Media and content creation
        # gimp # Image editing

        # System utilities
        # anydesk # Remote desktop
        # qbittorrent # Torrent client

        # Finance
        electrum # Bitcoin wallet
      ]
      ++ lib.optionals userConfig.machineConfig.gaming [
        # Gaming (conditional)
        lutris
        heroic
        mangohud
      ]
      ++ lib.optionals userConfig.devStack.wine [
        # Wine for Windows applications
        wineWowPackages.stable
        winetricks
      ];
  };
}
