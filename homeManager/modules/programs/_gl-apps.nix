{
  config,
  lib,
  pkgs,
  nixgl,
  ...
}:

{
  # NixGL configuration for GPU support
  nixGL = {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
    offloadWrapper = "mesa";
    installScripts = [ "mesa" ];
  };

  # Desktop applications with GL support
  home.packages =
    with pkgs;
    let
      glApps = [
        ghostty
        vscode
        slack
        vesktop
        element-desktop
        signal-desktop
        postman
        github-desktop
        anydesk
        drawio
        electrum
        qbittorrent
        obs-studio
        obsidian
      ];
      wrappedApps = map (pkg: config.lib.nixGL.wrap pkg) glApps;

      # Custom packages without wrapping
      customApps = [
        (callPackage ./_notion-app-enhanced { })
      ];
    in
    wrappedApps ++ customApps;
}
