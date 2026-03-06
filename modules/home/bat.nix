{pkgs, ...}: {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [batdiff batman batgrep batwatch];
    config = {
      pager = "less -FR";
      theme = "Catppuccin Mocha";
    };
  };
}
