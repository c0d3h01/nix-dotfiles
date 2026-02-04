{
  perSystem = {pkgs, ...}: {
    devShells.nixpkgs = pkgs.mkShellNoCC {
      name = "nixpkgs";
      meta.description = "Development shell for Nixpkgs work";

      packages = builtins.attrValues {
        inherit
          (pkgs)
          # Package creation helpers
          nurl
          nix-init
          # Nixpkgs dev tools
          hydra-check
          nixpkgs-lint
          nixpkgs-review
          nixpkgs-hammering
          # Nix helpers
          nix-melt
          nix-tree
          nix-inspect
          nix-search-cli
          ;
      };
    };
  };
}
