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
      enableOnBoot = false;
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "--all" ];
      };
      # Better daemon configuration
      daemon.settings = {
        log-driver = "json-file";
        log-opts = {
          max-size = "10m";
          max-file = "3";
        };
        default-shm-size = "2g";
        # Enable experimental features for buildx
        experimental = true;
        features = {
          buildkit = true;
        };
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

    # Enable Docker socket activation (start on first use)
    systemd.sockets.docker.wantedBy = lib.mkForce [ ];
  };
}

