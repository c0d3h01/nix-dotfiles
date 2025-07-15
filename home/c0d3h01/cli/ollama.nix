{ lib, config, ... }:

let
  inherit (lib) mkIf;
in
{
  config = mkIf config.garden.profiles.workstation.enable {
    services.ollama.enable = true;
  };
}
