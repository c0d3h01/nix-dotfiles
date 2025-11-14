{
  lib,
  pkgs,
  inputs,
  userConfig,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  imports = [
    inputs.spicetify.homeManagerModules.default
  ];

  programs.spicetify = mkIf userConfig.machineConfig.workstation (
    let
      spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = true;
      theme = spicePkgs.themes.sleek;
      colorScheme = "Nord";

      enabledCustomApps = with spicePkgs.apps; [
        ncsVisualizer
        newReleases
      ];

      enabledExtensions = with spicePkgs.extensions; [
        beautifulLyrics
        goToSong
        history
        adblock
      ];
    }
  );
}
