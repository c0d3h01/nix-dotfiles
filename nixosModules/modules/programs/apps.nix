{
  pkgs,
  ...
}:

{
  # <-- Environment packages -->
  environment.systemPackages = with pkgs; [

    # Browsers
    firefox

    # Notion Enhancer With patches
    (pkgs.callPackage ./_notion-app-enhanced { })

    # Terminal
    kitty

    # Code editors
    vscode-fhs
    jetbrains.webstorm
    jetbrains.pycharm-community-bin

    # Communication apps
    slack
    vesktop
    telegram-desktop
    zoom-us
    element-desktop
    signal-desktop

    # Common desktop apps
    postman
    github-desktop
    anydesk
    drawio
    electrum
    qbittorrent
    obs-studio
    libreoffice-qt6-fresh
    obsidian
  ];
}
