{
  lib,
  pkgs,
  userConfig,
  ...
}: {
  hardware.graphics = {
    enable = lib.mkDefault true;
    enable32Bit = lib.mkDefault (userConfig.workstation or false);

    extraPackages = lib.mkIf (userConfig.workstation or false) (with pkgs; [
      rocmPackages.clr # Vulkan driver
      rocmPackages.clr.icd # OpenCL for parallel compute
    ]);
  };

  services.xserver.videoDrivers = lib.mkDefault ["amdgpu"];
  hardware.amdgpu.opencl.enable = lib.mkDefault true;
}
