{
  perSystem = { pkgs, config, ... }: {
    devShells = {
      default = pkgs.mkShellNoCC {
        name = "dotfiles";
        meta.description = "Development shell for this configuration";

        DIRENV_LOG_FORMAT = "";

        packages = [
          pkgs.just
          pkgs.cocogitto
          pkgs.gitMinimal
          pkgs.age
          (pkgs.git-crypt.override { git = pkgs.gitMinimal; })
          pkgs.sops
          config.formatter
          pkgs.nix-output-monitor
        ];

        inputsFrom = [ config.formatter ];
      };
    };
  };
}

