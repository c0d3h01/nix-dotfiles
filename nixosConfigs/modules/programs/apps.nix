{
  pkgs,
  config,
  lib,
  userConfig,
  ...
}:
{
  # System programs - only enable if GUI is available

  config = lib.mkIf userConfig.machine.workstation {
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
        vscode-fhs
        jetbrains.webstorm
        jetbrains.pycharm-community-bin
        postman
        github-desktop
        drawio

        # Communication apps
        slack
        vesktop # Better Discord client
        telegram-desktop
        zoom-us
        element-desktop # Matrix client
        signal-desktop

        # Productivity apps
        libreoffice
        obsidian

        # Media and content creation
        gimp # Image editing

        # System utilities
        anydesk # Remote desktop
        qbittorrent # Torrent client

        # Finance
        electrum # Bitcoin wallet
      ]
      ++ lib.optionals userConfig.machine.gaming [
        # Gaming (conditional)
        lutris
        heroic
        mangohud
      ]
      ++ lib.optionals userConfig.dev.wine [
        # Wine for Windows applications
        wineWowPackages.stable
        winetricks
      ];
  };
}
