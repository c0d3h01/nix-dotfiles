{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.home.features.wezterm;
in {
  options.dotfiles.home.features.wezterm = {
    enable = mkEnableOption "Wezterm terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      package = pkgs.wrapWithNixGL pkgs.wezterm "wezterm";
    };
  };
}
