# exposed as flake.outputs.overlays
{inputs}: {
  nixgl = inputs.nixgl.overlays.default;
  nur = inputs.nur.overlays.default;
  nixglWrapper = import ./nixgl-wrapper.nix {isNixOS = false;};
}
