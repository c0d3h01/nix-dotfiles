{
  pkgs,
  userConfig,
  lib,
  ...
}: let
  isWorkstation = userConfig.workstation or false;

  cli = with pkgs; [
    tree
    glances
    stow
    imagemagick
    mise
  ];

  apps = [];
in {
  home.packages =
    cli
    ++ lib.optionals isWorkstation apps;
}
