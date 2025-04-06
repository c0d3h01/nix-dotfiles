{ pkgs
, ...
}:
{
  environment.systemPackages = with pkgs; [
    (pkgs.python312.withPackages (ps: with ps; [
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
    ]))
    pyright
    ruff
  ];
}

