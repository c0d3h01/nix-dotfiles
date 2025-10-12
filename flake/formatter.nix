{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.treefmt.withConfig {
        runtimeInputs = with pkgs; [
          actionlint
          deadnix
          keep-sorted
          nixfmt
          shellcheck
          shfmt
          statix
          stylua
          taplo
          mypy

          (writeShellScriptBin "statix-fix" ''
            for file in "$@"; do
              ${lib.getExe statix} fix "$file"
            done
          '')
        ];

        settings = {
          on-unmatched = "info";
          tree-root-file = "flake.nix";

          excludes = [
            "secrets/*"
            "gdb/*"
            "home/.config/zsh/*"
            ".envrc"
            "*.lock"
            "*.patch"
            "*.age"
          ];

          formatter = {
            actionlint = {
              command = "actionlint";
              includes = [
                ".github/workflows/*.yml"
                ".github/workflows/*.yaml"
              ];
            };

            mypy = {
              command = "mypy";
              options = [
                "--ignore-missing-imports"
                "--show-error-codes"
              ];
              includes = [ "*.py" ];
              excludes = [
                "home/.jupyter/*"
              ];
            };

            deadnix = {
              command = "deadnix";
              includes = [ "*.nix" ];
            };

            keep-sorted = {
              command = "keep-sorted";
              includes = [ "*" ];
            };

            nixfmt = {
              command = "nixfmt";
              includes = [ "*.nix" ];
            };

            shellcheck = {
              command = "shellcheck";
              includes = [
                "*.sh"
                "*.bash"
                # direnv
              ];
            };

            shfmt = {
              command = "shfmt";
              options = [
                "-s"
                "-w"
                "-i"
                "2"
              ];
              includes = [
                "*.sh"
                "*.bashrc"
                "*.bash_profile"
                "*.zshrc"
                "*.envrc"
                "*.envrc.private-template"
                # direnv
              ];
            };

            statix = {
              command = "statix-fix";
              includes = [ "*.nix" ];
            };

            stylua = {
              command = "stylua";
              includes = [ "*.lua" ];
            };

            taplo = {
              command = "taplo";
              options = "format";
              includes = [ "*.toml" ];
            };
          };
        };
      };
    };
}
