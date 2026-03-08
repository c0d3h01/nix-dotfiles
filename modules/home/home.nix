{
  config,
  pkgs,
  userConfig,
  ...
}: {
  home = {
    inherit (userConfig) username;
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${config.home.username}"
      else "/home/${config.home.username}";

    stateVersion = "25.11";
    enableNixpkgsReleaseCheck = false;
  };

  dotfiles.home.features = {
    ghostty.enable = true;
    wezterm.enable = false;
    alacritty.enable = false;
    kitty.enable = false;
    spicetify.enable = true;
    openclaw.enable = false;
  };
}
