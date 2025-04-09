{ lib
, ...
}:

{
  programs.sway = {
    enable = true;
    extraPackages = lib.mkForce [ ];
  };
}
