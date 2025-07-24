{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (callPackage ./patch {})
  ];
}