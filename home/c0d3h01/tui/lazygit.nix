{ config, ... }:
{
  config.programs.lazygit = {
    inherit (config.garden.profiles.workstation) enable;

    settings = {
      update.method = "never";

      gui = {
        nerdFontsVersion = 3;
        authorColors = {
          c0d3h01 = "#f5c2e7";
        };
      };

      git.paging = {
        colorArg = "always";
        pager = "delta --paging=never";
      };
    };
  };
}
