{
  config,
  lib,
  pkgs,
  declarative,
  ...
}:

{
  options = {
    myModules.docker.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Docker tools installation";
    };
  };

  config = lib.mkIf config.myModules.docker.enable {

    users.users.${declarative.username}.extraGroups = [ "docker" ];
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;
    };
    virtualisation.docker.extraOptions = ''
      --default-shm-size=2g
    '';
    environment.systemPackages = with pkgs; [
      docker
      docker-compose
      lazydocker
      kubectl
      kind
    ];
  };
}
