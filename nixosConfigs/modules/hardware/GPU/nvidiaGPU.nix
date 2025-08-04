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
  config = mkIf (cfg == "nvidia") {
    hardware.graphics = {
      enable = true;

      extraPackages = with pkgs; [
        libva
        libvdpau
        vulkan-loader
        nvidia-vaapi-driver
        nvidia-vulkan-vaapi
      ];

      enable32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
        libvdpau
        vulkan-loader
      ];
    };

    # NVIDIA driver configuration
    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = lib.mkDefault false;
      nvidiaSettings = true;
    };

    # Essential GPU utilities
    environment.systemPackages = with pkgs; [
      glxinfo
      vulkan-tools
      libva-utils
      vdpauinfo
    ];

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
    }
    // lib.optionalAttrs config.hardware.nvidia.prime.offload.enable {
      __NV_PRIME_RENDER_OFFLOAD = "1";
      __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __VK_LAYER_NV_optimus = "NVIDIA_only";
    };
  };
}
