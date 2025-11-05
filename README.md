# **c0d3h01's dotfiles**

## README

- These are my personal dotfiles, managed with [Nix Flakes](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake) and [Home Manager](https://nix-community.github.io/home-manager/).  

[Hardware details](https://github.com/c0d3h01/dotfiles/blob/master/docs/hardware.md)

---

## Installation

### Apply Home Manager Configuration

```bash
# Run Home Manager switch configs
$> nix run github:nix-community/home-manager -- switch \
  --flake 'github:c0d3h01/dotfiles#harshal@firuslab'
```

---

## NixOS Clean User Installation

```bash
# Partition and format disk with Disko
$> sudo nix --experimental-features "nix-command flakes" run \
  github:nix-community/disko/latest -- \
  --mode destroy,format,mount \
  --yes-wipe-all-disks \
  --flake github:c0d3h01/dotfiles#laptop

# Install NixOS
$> sudo nixos-install --flake github:c0d3h01/dotfiles#laptop \
  --no-root-passwd
```
