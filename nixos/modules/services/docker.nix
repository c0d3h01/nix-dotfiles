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
    storageDriver = "overlay2";

    # Auto cleanup - runs weekly, removes all unused images
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = ["--all"];
    };

    # Daemon settings
    daemon.settings = {
      # DNS: Cloudflare + Google for reliability
      dns = [
        "1.1.1.1"
        "8.8.8.8"
      ];

      # Mirror to speed up pulls and avoid rate limits
      registry-mirrors = ["https://mirror.gcr.io"];

      # Integrate with systemd logging (view: journalctl -u docker)
      log-driver = "journald";
    };
  };

  # Docker and container tools
  environment.systemPackages = with pkgs; [
    docker # Docker CLI
    docker-compose # Multi-container apps
    docker-buildx # Advanced build features
    lazydocker # Docker TUI (launch: lazydocker)
    dive # Image layer analyzer (usage: dive <image>)
    kubectl # Kubernetes CLI
    k9s # Kubernetes TUI
    kind # Local K8s clusters
    helm # K8s package manager
    hadolint # Dockerfile linter
    trivy # Container security scanner
  ];
}
