{
  config,
  inputs,
  self,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
  hosts = import ../hosts;
  overlay = config.flake.overlays.default;
  homeModule = self + /modules/home;

  mainUser = hostCfg: let
    found =
      builtins.filter
      (name: hostCfg.users.${name}.isMainUser or false)
      (builtins.attrNames hostCfg.users);
  in
    builtins.head found;

  mkPkgs = system:
    import inputs.nixpkgs {
      inherit system;
      overlays = [overlay];
      config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };
    };

  mkEasyHost = hostName: hostCfg: let
    primary = mainUser hostCfg;
    userCfg = hostCfg.users.${primary};
  in {
    arch = builtins.head (lib.splitString "-" hostCfg.system);
    class = "nixos";
    path = builtins.head hostCfg.modules;
    specialArgs.hostConfig =
      {
        hostname = hostName;
        username = primary;
        inherit (hostCfg) system bootloader;
      }
      // userCfg;
  };

  mkAllHomeConfigs = let
    perHost = hostName: hostCfg:
      lib.mapAttrsToList (
        userName: userCfg:
          lib.nameValuePair "${userName}@${hostName}" (
            inputs.home-manager.lib.homeManagerConfiguration {
              pkgs = mkPkgs hostCfg.system;
              extraSpecialArgs = {
                inherit inputs self;
                userConfig =
                  userCfg
                  // {
                    username = userName;
                    hostname = hostName;
                    inherit (hostCfg) system;
                  };
              };
              modules = [homeModule];
            }
          )
      )
      hostCfg.users;
  in
    builtins.listToAttrs (
      builtins.concatLists (
        lib.mapAttrsToList perHost hosts
      )
    );
in {
  imports = [
    inputs.easy-hosts.flakeModule
    inputs.home-manager.flakeModules.home-manager
  ];

  easy-hosts = {
    shared.modules = [
      (self + /modules/nixos)
      inputs.disko.nixosModules.disko
      inputs.home-manager.nixosModules.home-manager
      {
        nixpkgs.overlays = [config.flake.overlays.default];
      }
      (
        {hostConfig, ...}: {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "bak";
            extraSpecialArgs = {
              inherit inputs self;
              userConfig =
                hostConfig
                // {
                  inherit (hostConfig) username hostname system;
                };
            };
            users.${hostConfig.username}.imports = [
              homeModule
            ];
          };
        }
      )
    ];

    hosts = builtins.mapAttrs mkEasyHost hosts;
  };

  flake = {
    homeModules.default = homeModule;
    homeConfigurations = mkAllHomeConfigs;
  };
}
