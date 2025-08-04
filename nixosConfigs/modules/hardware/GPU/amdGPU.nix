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
  config = mkIf (cfg == "amd") {
    hardware.graphics = {
      enable = true;

      extraPackages = with pkgs; [
        libva
        libvdpau
        vulkan-tools
        rocmPackages.clr
      ];

      enable32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
        libvdpau
        vulkan-loader
      ];
    };

    # Essential GPU utilities
    environment.systemPackages = with pkgs; [
      glxinfo
      vulkan-tools
      libva-utils
      clinfo
    ];

    boot.kernelParams = [
      "amdgpu.si_support=1"
      "amdgpu.cik_support=1"
    ];

    # Environment variables
    environment.sessionVariables = {
      # VA-API driver selection
      LIBVA_DRIVER_NAME = "radeonsi";

      # VDPAU driver selection
      VDPAU_DRIVER = "radeonsi";
    };
  };
}
