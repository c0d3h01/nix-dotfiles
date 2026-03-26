{
  pkgs,
  hostConfig,
  ...
}: {
  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
    dockerCompat = true;
    dockerSocket.enable = true;

    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = ["--all" "--volumes"];
    };
  };

  users.users.${hostConfig.username}.autoSubUidGidRange = true;

  environment.systemPackages = with pkgs; [
    podman-desktop
    podman-compose
    docker-buildx
    skopeo
    kubectl
  ];
}
