{pkgs, ...}: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  environment.systemPackages = with pkgs; [
    podman-compose
    docker-buildx
    kubectl
  ];
}
