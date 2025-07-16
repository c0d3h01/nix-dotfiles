{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (self.lib) mkSystemSecret;

  cfg = config.secrets;
in
{
  options.secrets = {
    enable = mkEnableOption "Home Manager Secrets";
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      keys-gpg = { };
      keys-gh = { };
      keys-gh-pub = { };
      keys-email = { };
    };
  };
}
