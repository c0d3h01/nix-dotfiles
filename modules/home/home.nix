{
  config,
  pkgs,
  userConfig,
  ...
}: {
  imports = [
    # keep-sorted start
    ./git
    ./shell
    ./bat.nix
    ./dircolors.nix
    ./direnv.nix
    ./fzf.nix
    ./neovim.nix
    ./openclaw.nix
    ./ripgrep.nix
    ./secrets.nix
    ./spicetify.nix
    ./tmux.nix
    ./wezterm.nix
    ./xdg.nix
    ./yt-dlp.nix
    ./zoxide.nix
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

    sessionVariables = {
      BROWSER = "firefox";
      DIFFTOOL = "icdiff";
      EDITOR = "nvim";
      LANG = "en_IN.UTF-8";
      LC_ALL = "en_IN.UTF-8";
      PAGER = "less -FR";
      TERM = "xterm-256color";
      VISUAL = "nvim";

      XDG_CACHE_HOME = "${config.xdg.cacheHome}";
      XDG_CONFIG_HOME = "${config.xdg.configHome}";
      XDG_DATA_HOME = "${config.xdg.dataHome}";
      XDG_STATE_HOME = "${config.xdg.stateHome}";
    };
  };
}
