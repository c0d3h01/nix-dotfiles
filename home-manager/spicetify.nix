{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
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
      ];
    };

  dconf.settings."org/maliit/keyboard/maliit" = {
    enabled-languages = [
      "en"
    ];
    device = "tablet";
  };
}
