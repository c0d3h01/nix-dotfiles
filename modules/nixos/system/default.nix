# System — core system services, fonts, audio, packages, user management
{
  imports = [
    # keep-sorted start
    ./audio.nix
    ./diff.nix
    ./fonts.nix
    ./nix-ld.nix
    ./oomd.nix
    ./packages.nix
    ./printing.nix
    ./scheduler.nix
    ./user.nix
    ./xserver.nix
    # keep-sorted end
  ];
}
