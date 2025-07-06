{
  pkgs,
  userConfig,
  ...
}:

{
  users.users.${userConfig.username}.extraGroups = [
    "podman"
    "docker"
  ];
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    dive
    lazydocker
    docker-compose
    podman-desktop
    kind
    kubectl
  ];
}
