{
  lib,
  pkgs,
  config,
  ...
}:
{
  programs.gh = {
    enable = true;

    extensions = {
      pkgs.gh-cal
      pkgs.gh-copilot
      pkgs.gh-eco
    };

    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };
}