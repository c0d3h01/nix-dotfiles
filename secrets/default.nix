{
  inputs,
  config,
  userConfig,
  ...
}:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    age = {
      keyFile = "/etc/sops/sops-secrets-key.txt";
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
      ];
    };

    secrets = {
      "ssh-host" = {
        sopsFile = ./c0d3h01/ssh-host.enc;
        path = "/run/secrets/ssh";
        format = "binary";
      };
      "element" = {
        sopsFile = ./c0d3h01/element.enc;
        path = "/run/secrets/element";
        format = "binary";
      };
    };
  };
}
