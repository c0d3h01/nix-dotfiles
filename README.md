# NixOS Dotfiles (Nix Flake + Home Manager)

[![Flake CI - checks, inputs](https://github.com/c0d3h01/nix-config/actions/workflows/flake-validator.yml/badge.svg)](https://github.com/c0d3h01/nix-config/actions/workflows/flake-validator.yml)
[![Auto fmt src](https://github.com/c0d3h01/nix-config/actions/workflows/auto-fmt.yml/badge.svg)](https://github.com/c0d3h01/nix-config/actions/workflows/auto-fmt.yml)
[![Flake.lock: update Nix dependencies](https://github.com/c0d3h01/nix-config/actions/workflows/flocks-updator.yml/badge.svg)](https://github.com/c0d3h01/nix-config/actions/workflows/flocks-updator.yml)
[![Update submodules](https://github.com/c0d3h01/nix-config/actions/workflows/submodules.yml/badge.svg)](https://github.com/c0d3h01/nix-config/actions/workflows/submodules.yml)
[![License](https://img.shields.io/github/license/c0d3h01/nix-config)](https://github.com/c0d3h01/nix-config/blob/master/LICENSE)

Personal NixOS dotfiles and Nix flake configuration for a GNOME laptop workstation. Focused on reproducible systems, developer tooling, and modular Home Manager profiles.

## Highlights

- Flake-based NixOS + Home Manager setup on `nixos-unstable`.
- Disko-powered installs and partitioning.
- sops-nix secrets management.
- Modular system, networking, and Nix settings.
- CLI and developer tools plus workstation extras.
- GNOME desktop configuration.

## Repository Layout

- `flake/`: Flake parts (nixos + home outputs, devshells, formatter).
- `hosts/`: Host definitions and configs.
- `modules/nixos/`: NixOS modules (hardware, networking, services, system, nix).
- `modules/home/`: Home Manager modules (cli, programs, environment, services).
- `dotconfigs/`: Managed dotfiles and app configs.
- `secrets/`: Encrypted secrets for sops-nix.

## Hosts

| Host | System | Username | Hostname | WM/DE | Notes |
| --- | --- | --- | --- | --- | --- |
| `laptop` | `x86_64-linux` | `c0d3h01` | `nixos` | `gnome` | `workstation = true` |

## Quick Start

### Switch NixOS Configuration

```bash
sudo nixos-rebuild switch --flake .#laptop
```

### Apply Home Manager Only

```bash
nix run github:nix-community/home-manager -- switch --flake '.#laptop'
```

## NixOS Clean Install (Disko)

```bash
sudo nix --experimental-features "nix-command flakes" run \
  github:nix-community/disko/latest -- \
  --mode destroy,format,mount \
  --yes-wipe-all-disks \
  --flake github:c0d3h01/nix-config#laptop

sudo nixos-install --flake github:c0d3h01/nix-config#laptop --no-root-passwd
```

## Notable Nix Settings

- Flakes and `nix-command` enabled with a pinned registry.
- XDG base directories enabled for Nix-related state.
- Binary caches: `cache.nixos.org` and `nix-community`.
- Auto-optimization, parallel builds, and verbose traces for debugging.
