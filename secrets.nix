{ config, agenix, system, username, ... }:

{
  age.identityPaths = [ "/home/${username}/dotfiles/secrets/keys/default.key" ];
  imports = [ agenix.nixosModules.default ];
  environment.systemPackages = [ agenix.packages.${system}.default ];
  age.secrets = {
    wifi-password = {
      file = ./secrets/wifi-password.age;
      owner = "${username}";
    };
  };
}
