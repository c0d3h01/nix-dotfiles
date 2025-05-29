{
  inputs,
  ...
}:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/c0d3h01/.config/sops/age/keys.txt";
}
