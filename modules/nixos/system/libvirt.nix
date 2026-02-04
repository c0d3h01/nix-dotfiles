{pkgs, ...}: {
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm;
      onBoot = "ignore";
      onShutdown = "suspend";
    };
  };
}
