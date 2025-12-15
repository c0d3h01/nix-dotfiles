# Installation

## Apply Home Manager Configuration

```bash
# Run Home Manager switch configs
$> nix run github:nix-community/home-manager -- switch \
  --flake 'github:c0d3h01/nix-config#harshal@firuslab'
```

---

## NixOS Clean User Installation

```bash
# Partition and format disk with Disko
$> sudo nix --experimental-features "nix-command flakes" run \
  github:nix-community/disko/latest -- \
  --mode destroy,format,mount \
  --yes-wipe-all-disks \
  --flake github:c0d3h01/nix-config#laptop

# Install NixOS
$> sudo nixos-install --flake github:c0d3h01/nix-config#laptop \
  --no-root-passwd
```
