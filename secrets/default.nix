{
  userConfig,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.agenix.nixosModules.default
  ];
  age.identityPaths = [ "/home/${userConfig.username}/.ssh/id_ed25519" ];
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.x86_64-linux.default
    age
  ];
}
