{
  pkgs,
  config,
  lib,
  userConfig,
  ...
}:
{
  config = lib.mkIf userConfig.machine.workstation {
    programs.obs-studio = {
      enable = true;

      package = pkgs.obs-studio.override {
        cudaSupport = true;
      };

      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
        obs-vkcapture
      ];
    };
  };
}
