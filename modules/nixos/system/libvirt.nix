{pkgs, ...}: {
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd = {
      enable = false;
      qemu.package = pkgs.qemu_kvm;
      onBoot = "ignore";
      onShutdown = "suspend";
    };
  };
}
