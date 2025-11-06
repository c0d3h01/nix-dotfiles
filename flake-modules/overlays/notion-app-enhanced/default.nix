_: {
  flake.overlays.notion-app-enhanced = final: prev: {
    notion-app-enhanced = prev.callPackage ./package.nix { };
  };
}
