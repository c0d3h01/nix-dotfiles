# Purpose: home-manager entry point — auto-imports all module groups
{
  config,
  pkgs,
  userConfig,
  ...
}: {
  imports = [
    # keep-sorted start
    ./cli
    ./core
    ./dev
    ./media
    ./shell
    ./terminal
    # keep-sorted end
  ];

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
