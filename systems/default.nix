{ self, inputs, ... }:
{
  imports = [ inputs.easy-hosts.flakeModule ];

  config.easy-hosts = {
    # additionalClasses = {
    #   wsl = "nixos";
    # };

    perClass = class: {
      modules = [
        # import the class module, this contains the common configurations between all systems of the same class
        "${self}/modules/${class}/default.nix"
      ];
    };

    # This is the list of system configuration
    #
    # the defaults consists of the following:
    #  arch = "x86_64";
    #  class = "nixos";
    #  modules = [ ];
    #  specialArgs = { };
    hosts = {
      # Main nixos admin user
      c0d3h01 = { };
    };
  };
}
