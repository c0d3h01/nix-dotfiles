{
  pkgs,
  self,
  config,
  ...
}:
let
  inherit (self.lib) anyHome;

  qh = anyHome config;
in
{
  # home-manager is so strange and needs these declared multiple times
  programs = {
    fish.enable = qh (c: c.programs.fish.enable);
    zsh.enable = qh (c: c.programs.zsh.enable);
  };

  garden.packages = {
    # GNU core utilities (rewritten in rust)
    # a good idea for usage on macOS too
    inherit (pkgs)
      uutils-coreutils-noprefix

      # Code editors
      vscode-fhs

      # Communication apps
      slack
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
      ;
  };
}
