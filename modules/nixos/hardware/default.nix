# Hardware — base platform, firmware, initrd, storage, graphics
{
  imports = [
    # keep-sorted start
    ./base.nix
    ./filesystem.nix
    ./graphics.nix
    ./udev.nix
    ./zram.nix
    # keep-sorted end
  ];
}
