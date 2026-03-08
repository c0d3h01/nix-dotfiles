{
  programs.vesktop = {
    enable = true;
    settings = {
      # System integration
      appBadge = false;
      arRPC = true;
      checkUpdates = false;
      customTitleBar = false;
      disableMinSize = true;
      minimizeToTray = false;
      tray = false;
      staticTitle = true;
      discordBranch = "stable";

      # Performance
      hardwareAcceleration = true;
      openLinksWithElectron = false; # open links in system browser, not electron

      # Theming
      splashTheming = true;
      splashBackground = "#000000";
      splashColor = "#ffffff";
      splashAnimationDuration = 500; # ms

      # Window behavior
      saveWindowState = true; # remember size/position across restarts
      disableAudioControl = false; # keep OS audio control integration
    };

    vencord.settings = {
      autoUpdate = false;
      autoUpdateNotification = false;
      useQuickCss = true;
      enableReactDevtools = false;
      frameless = false;
      transparent = false;
      winCtrlQ = false;
      disableMinSize = true;
      winNativeTitleBar = false;
    };
  };
}
