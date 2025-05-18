{
  config,
  lib,
  pkgs,
  userConfig,
  ...
}:

{
  options = {
    myModules.podmanTools = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Install podman tools";
    };
  };

  config = lib.mkIf config.myModules.podmanTools {

    users.users.${userConfig.username}.extraGroups = [ "podman" ];
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };
    virtualisation.containers.containersConf.settings = {
      containers.dns_servers = [
        "8.8.8.8"
        "8.8.4.4"
      ];
    };
    environment.systemPackages = with pkgs; [
      dive
      podman-compose
      podman-desktop
      kind
      kubectl
    ];
  };
}
