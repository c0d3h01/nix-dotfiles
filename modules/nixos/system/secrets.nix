{
  inputs,
  self,
  ...
}: {
  imports = [
    # keep-sorted start
    inputs.sops.nixosModules.sops
    # keep-sorted end
  ];

  sops = {
    defaultSopsFile = "${self}/secrets/default.yaml";
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  };
}
