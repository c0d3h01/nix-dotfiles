{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.myModules.pythonTools = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Install Python tools and libraries in user environment";
  };

  config = lib.mkIf config.myModules.pythonTools {
    home.packages = with pkgs; [
      (python312.withPackages (
        ps: with ps; [
          pip
          virtualenv
          jupyter
          sympy
          numpy
          scipy
          pandas
          scikit-learn
          matplotlib
          torch
        ]
      ))
      pyright
      ruff
    ];
  };
}
