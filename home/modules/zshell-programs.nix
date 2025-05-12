{
  lib,
  pkgs,
  ...
}:
let
  darkgray = "242"; # Starship
in
{
  programs = {

    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        prettybat
      ];
    };

    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };

    eza = {
      enable = true;
      extraOptions = [
        "--classify"
        "--color-scale"
        "--git"
        "--group-directories-first"
      ];
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [
        "--color=dark"
        "--color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe"
        "--color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef"
      ];
    };

    ripgrep = {
      enable = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
