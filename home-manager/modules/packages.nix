{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wezterm
    gitFull
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
  ];
}
