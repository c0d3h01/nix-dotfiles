{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  name = "dev-environment";
  buildInputs = [
    # C/C++ tools
    pkgs.clang
    pkgs.gcc
    pkgs.pkg-config
    pkgs.gnumake
    pkgs.cmake
    pkgs.ninja
    pkgs.glib

    # GTK & Graphics
    pkgs.gtk3
    pkgs.glfw
    pkgs.glew
    pkgs.glm
  ];

  shellHook = ''
    export PKG_CONFIG_PATH="${pkgs.gtk3}/lib/pkgconfig:$PKG_CONFIG_PATH"
    echo "Start developing env..."
  '';
}
