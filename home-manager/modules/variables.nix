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
    GIT_SIGNING_KEY = "B4242C21BAF74B7C";
    GIT_EDITOR = editor;
    GIT_DEFAULT_BRANCH = "master";
    EDITOR = editor;
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
