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
  config = mkIf (userConfig.devStack.container == "docker") {
    users.users.${userConfig.username}.extraGroups = [ "docker" ];
    # Configure Docker
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;

      # Docker filesystem
      storageDriver = "btrfs";

      # Auto cleaner
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "--all" ];
      };

      # Daemon configuration
      daemon.settings = {
        dns = [
          "1.1.1.1"
          "8.8.8.8"
        ];
        registry-mirrors = [ "https://mirror.gcr.io" ];
        storage-driver = "overlay2";
        log-driver = "journald";
      };
    };

    # Docker-related packages
    environment.systemPackages = with pkgs; [
      docker # Docker CLI
      docker-compose # Container orchestration
      docker-buildx # Advanced build features
      lazydocker # Docker TUI
      dive # Explore container layers
      kubectl # Kubernetes CLI
      k9s # Kubernetes TUI
      kind # Kubernetes in Docker
      helm # Kubernetes package manager
    ];
  };
}
