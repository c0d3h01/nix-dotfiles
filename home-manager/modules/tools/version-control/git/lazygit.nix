{ config, ... }:
{
  programs.lazygit = {
    inherit (config.programs.git) enable;

    settings = {
      update.method = "never";

      gui = {
        nerdFontsVersion = 3;
        authorColors.isabel = "#f5c2e7";
      };

      git = {
        overrideGpg = true;
        paging = {
          colorArg = "always";
          pager = "delta --paging=never";
        };
      };
    };
  };
}


