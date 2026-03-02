# Boot — shared loader settings + backend selection
{...}: {
  imports = [
    # keep-sorted start
    ./grub.nix
    ./limine.nix
    ./systemd-boot.nix
    # keep-sorted end
  ];

  boot.loader = {
    timeout = 5;
    efi.canTouchEfiVariables = true;
  };
}
