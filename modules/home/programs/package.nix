{pkgs, ...}: {
  home.packages = with pkgs; [
    freecad
    openscad
    kicad
    cura-appimage
    arduino-ide
    graphviz
  ];
}
