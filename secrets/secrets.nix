let
  keys = import ../keys.nix;
in
with keys;
{
  # "ssh-private-key.age" = {
  #   file = ./ssh-private-key.age;
  #   owner = "root";
  #   group = "root";
  #   mode = "600";
  #   publicKeys = [ keys.c0d3h01 ];
  # };
}
