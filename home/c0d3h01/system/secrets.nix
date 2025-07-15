{
  lib,
  self,
  config,
  ...
}:
let
  inherit (self.lib) mkSystemSecret;
in
{
  sops.secrets = {
    keys-gpg = { };
    keys-gh = { };
    keys-gh-pub = { };
    keys-email = { };
  };
}
