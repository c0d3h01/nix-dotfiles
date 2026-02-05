{
  pkgs,
  lib,
  userConfig,
  ...
}: let
  inherit (lib) mkIf;
in {
  # Add user to docker group for non-root access
  users.users.${userConfig.username}.extraGroups = [ "docker" ];

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
    docker # Docker CLI
    docker-compose # Multi-container apps
    docker-buildx # Advanced build features
    lazydocker # Docker TUI (launch: lazydocker)
    dive # Image layer analyzer (usage: dive <image>)
    hadolint # Dockerfile linter
    trivy # Container security scanner

    kubernetes
    kompose # Convert docker-compose to
    kubectl # Kubernetes CLI
    k9s # Kubernetes TUI
    kind # Local K8s clusters
    kubernetes-helm # Kubernetes package manager
    lens # Kubernetes IDE
  ];
}
