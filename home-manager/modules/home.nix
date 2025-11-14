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
    ./gnome.nix
    ./htop.nix
    ./nix-your-shell.nix
    ./nixgl.nix
    ./packages.nix
    ./secrets.nix
    ./spicetify.nix
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
