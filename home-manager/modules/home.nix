{
  config,
  userConfig,
  pkgs,
  ...
}: {
  imports = [
    ./direnv.nix
    # ./dotfiles.nix
    ./packages.nix
    ./secrets.nix
    ./spicetify.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home = {
    inherit (userConfig) username;
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${config.home.username}"
      else "/home/${config.home.username}";
    stateVersion = "25.11";
    enableNixpkgsReleaseCheck = false;
  };
}
