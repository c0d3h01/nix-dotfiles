{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    myModules.python.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Install Python modules";
    };
  };

  config = lib.mkIf config.myModules.python.enable {

    environment.systemPackages = with pkgs; [
      (pkgs.python313.withPackages (
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
