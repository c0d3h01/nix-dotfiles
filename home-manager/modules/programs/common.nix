{
  pkgs,
  lib,
  userConfig,
  ...
}:
let
  isWorkstation = userConfig.machineConfig.workstation.enable;
in
{
  home.packages =
    with pkgs;
    [
      # Terminal Utilities
      tmux
      xclip
      curl
      wget
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
    ++ lib.optionals isWorkstation [
      # Desk App
      (callPackage ./notion-app { })
    ];
}
