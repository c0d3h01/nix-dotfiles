{
  pkgs,
  lib,
  userConfig,
  ...
}:
let
  inherit (lib) optionals;
  isWorkstation = userConfig.machineConfig.workstation.enable;
in
{
  home.packages =
    with pkgs;
    [
      # Terminal Utilities
      tmux
      xclip
      tree
      stow
      file
      icdiff
      glances
      just
      gdu
      imagemagick
    ]
    ++ [
      # Language Servers
      lua-language-server
      nil
    ]
    ++ optionals isWorkstation [
      # Desk App
      (callPackage ./notion-app { })
    ];
}
