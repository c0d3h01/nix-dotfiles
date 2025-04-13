{
  pkgs,
  userConfig,
  ...
}:
{
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
  ];
}
