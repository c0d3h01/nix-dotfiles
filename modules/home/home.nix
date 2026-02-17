{
  config,
  userConfig,
  pkgs,
  ...
}: {
  imports = [
    ./cli
    ./programs
    ./service
  ];

  # enable - Home Manager.
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
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "google-chrome-stable";
      PAGER = "less -FR";
      DIFFTOOL = "icdiff";
      LC_ALL = "en_IN.UTF-8";
      LANG = "en_IN.UTF-8";
      TERM = "xterm-256color";

      XDG_CACHE_HOME = "${config.xdg.cacheHome}";
      XDG_CONFIG_HOME = "${config.xdg.configHome}";
      XDG_DATA_HOME = "${config.xdg.dataHome}";
      XDG_STATE_HOME = "${config.xdg.stateHome}";
    };

    packages = with pkgs; [
      freecad
      openscad
      kicad
      cura-appimage
      arduino-ide
      graphviz

      # langservers
      nil
      nixd
      bash-language-server
      typescript-language-server
      vscode-langservers-extracted
      eslint
      html-tidy
      pyright
      gopls
      clang-tools
      lua-language-server
      yaml-language-server
      taplo
      dockerfile-language-server
      terraform-ls
      marksman
      sqls
    ];
  };

  xdg = lib.mkForce {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  programs.less = {
    enable = true;
    config = ''
      i quit
    '';
  };
}
