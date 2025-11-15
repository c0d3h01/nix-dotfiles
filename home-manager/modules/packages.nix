{
  userConfig,
  pkgs,
  config,
  ...
}:
let
  cfg = userConfig.machineConfig.glApps;
  wrap = pkg: if cfg then config.lib.nixGL.wrap pkg else pkg;
in
{
  programs.wezterm = {
    enable = true;
    package = wrap pkgs.wezterm;
  };

  home.packages = with pkgs; [
    gitFull
    git-lfs
    lazygit
    neovim
    starship
    bat
    lsd
    fd
    ripgrep
    zoxide
    tmux
    fzf
    mise
    direnv
    nix-direnv
    (callPackage ./notion-app { })
  ];
}
