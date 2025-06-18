{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.x86_64-linux.default
    age
  ];

  age = {
    identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    secrets = {
      ssh-key.file = ./ssh-key.age;
      element-key.file = ./element-key.age;
    };
  };
}
