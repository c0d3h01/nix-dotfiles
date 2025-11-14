{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      inherit (pkgs) lib;
    in
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
            "plugins/*"
            ".envrc"
            "*.lock"
            "*.patch"
            "*.age"
          ];

          formatter = {
            actionlint.command = "actionlint";
            actionlint.includes = [
              ".github/workflows/*.yml"
              ".github/workflows/*.yaml"
            ];

            mypy.command = "mypy";
            mypy.options = [
              "--ignore-missing-imports"
              "--show-error-codes"
            ];
            mypy.includes = [ "*.py" ];
            mypy.excludes = [ "home/.jupyter/*" ];

            deadnix.command = "deadnix";
            deadnix.includes = [ "*.nix" ];

            keep-sorted.command = "keep-sorted";
            keep-sorted.includes = [ "*" ];

            nixfmt.command = "nixfmt";
            nixfmt.includes = [ "*.nix" ];

            shellcheck.command = "shellcheck";
            shellcheck.includes = [
              "*.sh"
              "*.bash"
            ];

            shfmt.command = "shfmt";
            shfmt.options = [
              "-s"
              "-w"
              "-i"
              "2"
            ];
            shfmt.includes = [
              "*.sh"
              "*.bashrc"
              "*.bash_profile"
              "*.zshrc"
              "*.envrc"
              "*.envrc.private-template"
            ];

            statix.command = "statix-fix";
            statix.includes = [ "*.nix" ];

            stylua.command = "stylua";
            stylua.includes = [ "*.lua" ];

            taplo.command = "taplo";
            taplo.options = "format";
            taplo.includes = [ "*.toml" ];
          };
        };
      };
    };
}
