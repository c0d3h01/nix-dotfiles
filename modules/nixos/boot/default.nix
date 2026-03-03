{...}: {
  imports = [
    ./grub.nix
    ./limine.nix
    ./systemd-boot.nix
  ];

  boot.loader = {
    timeout = 5;
    efi.canTouchEfiVariables = true;
  };
}
