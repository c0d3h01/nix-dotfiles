{
  config,
  lib,
  pkgs,
  declarative,
  ...
}:

{
  options = {
    myModules.podman.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Install podman tools";
    };
  };

  config = lib.mkIf config.myModules.podman.enable {

    users.users.${declarative.username}.extraGroups = [ "podman" ];
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
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
