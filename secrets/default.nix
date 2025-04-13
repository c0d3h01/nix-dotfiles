{
  config,
  pkgs,
  inputs,
  ...
}:
{

  imports = [ inputs.agenix.nixosModules.default ];
  environment.systemPackages = [
    inputs.agenix.packages.x86_64-linux.default
    pkgs.age
  ];
  age = {
    secrets = import ./secrets.nix;
  };
}
