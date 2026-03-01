{...}: {
  imports = [
    # keep-sorted start
    ./grub.nix
    ./limine.nix
    ./systemd.nix
    # keep-sorted end
  ];

  # Bootloader.
  boot.loader = {
    timeout = 5;
    efi.canTouchEfiVariables = true;
  };
}
