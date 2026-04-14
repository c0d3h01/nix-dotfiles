{
  lib,
  hostConfig,
  ...
}: let
  hostProfile = {
    windowManager = hostConfig.windowManager or "gnome";
  };
in {
  _module.args.hostProfile = hostProfile;

  assertions = [
    {
      assertion = lib.elem hostProfile.windowManager [
        "gnome"
        "plasma"
      ];
      message = "hostConfig.windowManager must be one of: gnome, plasma";
    }
  ];
}
