# Services — Docker container runtime with security hardening
{
  pkgs,
  lib,
  hostConfig,
  ...
}: {
  # Non-root docker access for the main user
  users.users.${hostConfig.username}.extraGroups = ["docker"];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;

    # Weekly prune of unused images, containers, volumes
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = ["--all" "--volumes"];
    };

    # Daemon hardening
    daemon.settings = {
      # Keep containers running during daemon restart
      live-restore = true;
      # Use iptables for container networking (works with nftables backend)
      iptables = true;
      # Log rotation — prevent runaway container logs from filling disk
      log-driver = "json-file";
      log-opts = {
        max-size = "10m";
        max-file = "3";
      };
    };
  };

  # Docker CLI tools
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    docker-buildx
    lazydocker
  ];
}
