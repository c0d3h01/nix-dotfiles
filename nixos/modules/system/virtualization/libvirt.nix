{
  lib,
  pkgs,
  userConfig,
  ...
}:

{
  config = lib.mkIf userConfig.devStack.virtualisation.enable {
    programs.virt-manager.enable = true;
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.package = pkgs.qemu_kvm;
        onBoot = "ignore";
        onShutdown = "suspend";
      };
    };
  };
}

