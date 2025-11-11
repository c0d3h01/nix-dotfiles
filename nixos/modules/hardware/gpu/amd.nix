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

    # auto-epp for amd active pstate.
    # services.auto-epp.enable = true;

    # OpenCL support using ROCM runtime library
    hardware.amdgpu.opencl.enable = true;

    hardware.graphics = lib.mkIf isWorskstaion {
      enable = true;
      enable32Bit = true;

      # extraPackages = with pkgs; [
      # ];

      # extraPackages32 = with pkgs.pkgsi686Linux; [
      # ];
    };

    # LACT - Linux AMDGPU Controller
    environment.systemPackages = with pkgs; [ lact ];
    systemd.packages = with pkgs; [ lact ];
    systemd.services.lactd.wantedBy = [ "multi-user.target" ];

    # Environment variables for optimal GPU performance
    environment.variables.AMD_VULKAN_ICD = "RADV";
  };
}
