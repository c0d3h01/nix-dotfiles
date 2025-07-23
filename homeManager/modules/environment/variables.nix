{ config, self, ... }:
let
  editor = "nvim";
  browser = "firefox";
  terminal = "ghostty";
  pager = "less";
  manpager = "less -R";
  flakePath = "${self}";
in
{
  home.sessionVariables = {
    EDITOR = editor;
    GIT_EDITOR = editor;
    VISUAL = editor;
    BROWSER = browser;
    TERMINAL = terminal;
    SYSTEMD_PAGERSECURE = "true";
    PAGER = pager;
    MANPAGER = manpager;
    FLAKE = flakePath;
    NH_FLAKE = flakePath;
    DO_NOT_TRACK = 1;
  };
}
