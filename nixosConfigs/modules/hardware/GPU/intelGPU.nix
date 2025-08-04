{
  config,
  lib,
  pkgs,
  userConfig,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = userConfig.machine.gpuType;
in
{
  config = mkIf (cfg == "intel") {
    hardware.graphics = {
      enable = true;

      extraPackages = with pkgs; [
        libva
        libvdpau
        vulkan-loader
        intel-media-driver
        libva-vdpau-driver
        intel-compute-runtime
        vpl-gpu-rt # Quick Sync Video
      ];

      enable32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
        libvdpau
        vulkan-loader
        intel-media-driver
        libva-vdpau-driver
        intel-compute-runtime
      ];
    };

    # Essential GPU utilities
    environment.systemPackages = with pkgs; [
      glxinfo
      vulkan-tools
      libva-utils
      clinfo
      intel-gpu-tools
    ];

    boot.kernelParams = [
      "i915.enable_fbc=1"
      "i915.enable_psr=1"
      "i915.enable_guc=3"
    ];

    # Environment variables for optimal GPU performance
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
      VDPAU_DRIVER = "iHD";
      OCL_ICD_VENDORS = "intel";
    };
  };
}
