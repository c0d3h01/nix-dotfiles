{
  pkgs,
  config,
  lib,
  userConfig,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf (userConfig.devStack.container == "podman") {
    users.users.${userConfig.username}.extraGroups = [
      "podman"
      "docker"
    ];

    # Configure Podman
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
      # Enable automatic container updates
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    # Container-related packages
    environment.systemPackages = with pkgs; [
      dive # Explore container layers
      lazydocker # Docker/Podman TUI
      docker-compose # Container orchestration
      podman-compose # Podman-native compose
      podman-desktop # GUI for Podman
      kind # Kubernetes in Docker
      kubectl # Kubernetes CLI
      k9s # Kubernetes TUI
      buildah # Container building tool
      skopeo # Container image operations
    ];

    # Enable container registry authentication
    virtualisation.containers = {
      enable = true;
      registries.search = [
        "docker.io"
        "registry.fedoraproject.org"
        "quay.io"
        "registry.access.redhat.com"
        "registry.centos.org"
      ];
    };
  };
}
