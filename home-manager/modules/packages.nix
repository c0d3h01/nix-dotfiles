{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wezterm
    gitFull
    starship
    bat
    lsd
    fd
    ripgrep
  ];
}