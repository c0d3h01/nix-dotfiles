{
  lib,
  pkgs,
  hostProfile,
  ...
}: {
  hardware.graphics = {
    enable = lib.mkDefault true;
    enable32Bit = lib.mkDefault hostProfile.isWorkstation;

    extraPackages = lib.mkIf hostProfile.isWorkstation (with pkgs; [
      rocmPackages.clr # Vulkan driver
      rocmPackages.clr.icd # OpenCL for parallel compute
    ]);
  };

  services.xserver.videoDrivers = lib.mkDefault ["amdgpu"];
  hardware.amdgpu.opencl.enable = lib.mkDefault true;
}
