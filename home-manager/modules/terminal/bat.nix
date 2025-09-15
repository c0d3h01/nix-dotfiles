{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
  };
}
