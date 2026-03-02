# Purpose: core home-manager infra — session variables, XDG, secrets
{config, ...}: {
  imports = [
    # keep-sorted start
    ./secrets.nix
    ./xdg.nix
    # keep-sorted end
  ];

  home.sessionVariables = {
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
}
