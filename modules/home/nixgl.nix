{
  lib,
  pkgs,
  ...
}: let
  isNixOS = builtins.pathExists /etc/NIXOS;
  hasNixGL = !isNixOS && (pkgs ? nixgl) && (pkgs.nixgl ? nixGLIntel);
in {
  config = lib.mkIf hasNixGL {
    home.packages = [pkgs.nixgl.nixGLIntel];
  };
}
