{ userConfig, ... }:
{

  imports = [
    # Foldors
    ./applications
    ./c0d3h01
    ./desktop
    ./devtools

    # Modules
    ./audio.nix
    ./boot.nix
    ./fonts.nix
    ./hardware.nix
    ./networking.nix
    ./nix.nix
    ./security.nix
    ./services.nix
  ];

  system.stateVersion = userConfig.stateVersion;
  networking.hostName = userConfig.hostname;
}
