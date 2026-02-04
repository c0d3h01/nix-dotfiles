{
  perSystem = {pkgs, ...}: let
    inherit (pkgs) lib;
  in {
    formatter = pkgs.treefmt.withConfig {
      runtimeInputs = with pkgs; [
        actionlint
        deadnix
        keep-sorted
        alejandra
        shellcheck
        shfmt
        statix
        stylua
        taplo
        yamlfmt
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
          ".github"
          "secrets/*"
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
            includes = ["*.py"];
            excludes = ["home/.jupyter/*"];
            options = [
              "--ignore-missing-imports"
              "--show-error-codes"
            ];
          };

          deadnix = {
            command = "deadnix";
            includes = ["*.nix"];
          };

          yamlfmt = {
            command = "yamlfmt";
            options = [
              "-formatter"
              "retain_line_breaks_single=true"
            ];
            includes = [
              "*.yml"
              "*.yaml"
            ];
          };

          keep-sorted = {
            command = "keep-sorted";
            includes = [
              "*.nix"
              "*.toml"
              "*.json"
            ];
          };

          alejandra = {
            command = "alejandra";
            includes = ["*.nix"];
          };

          shellcheck = {
            command = "shellcheck";
            includes = [
              "*.sh"
              "*.bash"
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
            ];
          };

          statix = {
            command = "statix-fix";
            includes = ["*.nix"];
          };

          stylua = {
            command = "stylua";
            includes = ["*.lua"];
          };

          taplo = {
            command = "taplo";
            options = "format";
            includes = ["*.toml"];
          };
        };
      };
    };
  };
}
