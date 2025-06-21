{
  users.users.c0d3h01.extraGroups = [
    "libvirtd"
    "kvm"
  ];
  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm;
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
    qemu = {
      package = pkgs.qemu_kvm;
    };
  };
}
