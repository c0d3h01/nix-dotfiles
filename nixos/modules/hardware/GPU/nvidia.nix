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
  config = mkIf (cfg == "nvidia") {

    # xorg drivers
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.graphics = lib.mkIf isWorskstaion {
      enable = true;

      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        nvidia-vulkan-vaapi
      ];

      enable32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [
        nvidia-vaapi-driver
        nvidia-vulkan-vaapi
      ];
    };

    # NVIDIA driver configuration
    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = lib.mkDefault false;
      nvidiaSettings = true;
      nvidiaPersistenced = true;
      dynamicBoost.enable = true;
    };

    boot = {
      kernelParams = [
        "nvidia-drm.modeset=1"
      ];
      blacklistedKernelModules = [ "nouveau" ];
    };

    # Environment variables
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      VDPAU_DRIVER = "nvidia";
      MOZ_X11_EGL = "1"; # For Firefox
    };
  };
}
