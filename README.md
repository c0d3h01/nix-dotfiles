# Nix Config

Personal NixOS + Home Manager configuration with a focus on developer tooling.

## Highlights

- Home Manager module for core CLI/dev tools with optional workstation extras.
- LSP/language tooling module for editors.

## Home Manager Module Notes

- Base dev tools are always installed via `modules/home/dev.nix`.
- Workstation-only tools (compilers, toolchains, Docker, DBs, GUI helpers) are gated behind `userConfig.workstation = true`.
- Language servers and related tooling live in `modules/home/lsp.nix`.

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
