{
  inputs,
  config,
  userConfig,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./direnv.nix
    ./ghostty.nix
    ./gnome.nix
    ./htop.nix
    ./integration.nix
    ./nix-your-shell.nix
    ./nixgl.nix
    ./packages.nix
    ./secrets.nix
    ./spicetify.nix
    ./starship.nix
    ./themes.nix
    ./variables.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home = {
    inherit (userConfig) username;
    homeDirectory =
      if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";
    stateVersion = lib.trivial.release;
  };
}
