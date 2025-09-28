{
  config,
  lib,
  pkgs,
  userConfig,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = userConfig.machineConfig.gpuType;
  isWorskstaion = userConfig.machineConfig.workstation.enable;
in
{
  config = mkIf (cfg == "amd") {

    # xorg drivers
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.graphics = lib.mkIf isWorskstaion {
      enable = true;

      extraPackages = with pkgs; [
        mesa
        amdvlk
        libva-vdpau-driver
      ];

      enable32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [
        mesa
        amdvlk
        libva-vdpau-driver
      ];
    };

    # Environment variables
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "radeonsi";
      VDPAU_DRIVER = "radeonsi";
      MOZ_X11_EGL = "1"; # For Firefox
    };
  };
}
