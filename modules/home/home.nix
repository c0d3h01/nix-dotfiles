{
  config,
  userConfig,
  pkgs,
  ...
}: {
  imports = [
    ./direnv.nix
    ./dev.nix
    ./lsp.nix
    ./packages.nix
    ./secrets.nix
    ./shell.nix
    ./spicetify.nix
    ./tmux.nix
    ./xdg.nix
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
