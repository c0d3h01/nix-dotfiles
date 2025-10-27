{ config, ... }:
{
  programs.eza = {
    enable = true;
    icons = "auto";

    enableNushellIntegration = false;

    extraOptions = [
      "--group"
      "--group-directories-first"
      "--header"
      "--no-permissions"
      "--octal-permissions"
    ];
  };
}


