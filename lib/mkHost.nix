{
  inputs,
  self,
}: {
  hostname,
  username,
  fullName,
  system ? "x86_64-linux",
  isNixOS ? true,
  bootloader ? "systemd",
  windowManager ? "gnome",
  workstation ? true,
  stateVersion ? "25.11",
  nixosModules ? [],
  homeModules ? [],
}: let
  inherit (inputs.nixpkgs) lib;

  # Shared extra arguments passed into every NixOS and HM module via specialArgs.
  specialArgs = {
    inherit inputs self system username fullName hostname;
    hostConfig = {
      inherit
        hostname
        username
        fullName
        system
        isNixOS
        bootloader
        windowManager
        workstation
        stateVersion
        ;
    };
  };

  # pkgs is used exclusively by the standalone `home` configuration below.
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [inputs.nur.overlays.default];
  };

  # Shared Home Manager integration block injected into the NixOS modules list.
  hmNixosModule = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs = specialArgs;
      users.${username}.imports = [(self + /modules/home)] ++ homeModules;
    };
  };
in {
  # NixOS system with Home Manager baked in.
  nixos =
    if !isNixOS
    then null
    else
      lib.nixosSystem {
        inherit system specialArgs;
        modules =
          [(self + /modules/nixos)]
          ++ nixosModules
          ++ [
            inputs.home-manager.nixosModules.home-manager
            hmNixosModule
          ];
      };

  # Standalone Home Manager configuration.
  home = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = specialArgs;
    modules = [(self + /modules/home)] ++ homeModules;
  };

  # Metadata surfaced to flake.nix for output key construction.
  meta = {inherit hostname username system;};
}
