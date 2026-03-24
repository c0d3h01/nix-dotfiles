{
  lib,
  pkgs,
  hostProfile,
  ...
}: let
  inherit (lib) mkIf mkDefault;
in {
  # AMD GPU & CPU Configuration
  hardware.graphics = mkIf hostProfile.isWorkstation {
    enable = mkDefault true;
    extraPackages = with pkgs; [
      amdvlk
      vulkan-tools
      libva-vdpau-driver

      # Only for - ROCm (HIP/CLR)
      # rocmPackages.clr
      # rocmPackages.clr.icd
      # rocmPackages.hip
      # rocmPackages.miopen-hip
    ];

    enable32Bit = mkDefault true;
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  # Enable OpenCL - ROCM only.
  # hardware.amdgpu.opencl.enable = mkDefault true;

  # CPU: Use performance governor
  # powerManagement.cpuFreqGovernor = "performance";

  # Use the open-source amdgpu driver
  services.xserver.videoDrivers = mkDefault ["amdgpu"];

  # AMD CPU Microcode
  hardware.cpu.amd.updateMicrocode = mkDefault true;
}
