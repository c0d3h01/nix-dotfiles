{
  inputs,
  userConfig,
  self,
  ...
}:
{
  imports = [ inputs.sops.nixosModules.sops ];

  sops = {
    defaultSopsFile = "${self}/secrets/${userConfig.username}.yaml";
    gnupg.sshKeyPaths = [ ];
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
