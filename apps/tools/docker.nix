{
  config,
  lib,
  pkgs,
  userConfig,
  ...
}:

{
  options = {
    myModules.dockerTools = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Docker tools installation";
    };
  };

  config = lib.mkIf config.myModules.dockerTools {

    users.users.${userConfig.username}.extraGroups = [ "docker" ];
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
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
