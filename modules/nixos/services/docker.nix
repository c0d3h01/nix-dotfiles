{
  pkgs,
  lib,
  userConfig,
  ...
}: let
  inherit (lib) mkIf;
in {
  # Add user to docker group for non-root access
  users.users.${userConfig.username}.extraGroups = ["docker"];

  # Docker Configuration
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = ["--all"];
    };
  };

  # Docker and container tools
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    docker-buildx
    lazydocker
  ];
}
