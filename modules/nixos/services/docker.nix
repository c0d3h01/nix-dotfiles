{
  pkgs,
  lib,
  hostConfig,
  ...
}: {
  users.users.${hostConfig.username}.extraGroups = ["docker"];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;

    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = ["--all" "--volumes"];
    };

    daemon.settings = {
      live-restore = true;
      iptables = true;
      log-driver = "json-file";
      log-opts = {
        max-size = "10m";
        max-file = "3";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    docker-buildx
    lazydocker
  ];
}
