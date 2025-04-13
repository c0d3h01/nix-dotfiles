{
  config,
  pkgs,
  lib,
  ...
}:

let
  fastfetchConfigFile = ./config.jsonc;
in
{
  # Create a symlink to the config.jsonc file
  home.file = {
    source = fastfetchConfigFile;
    target = "${config.home.homeDirectory}/.config/fastfetch/config.jsonc";
  };
}
