<!-- <div align="center">
  <img src="assets/README/fastfetch.png" width="600" alt="Fastfetch Screenshot" />
</div> -->

## Overview

- This repository contains my personal NixOS configurations and dotfiles.

> [!CAUTION]  
> These host system and home configurations are published for my system configurations. They are specifically tailored for my hardware and should not be used directly on other systems. Attempting to build and deploy these configurations to other systems without appropriate modifications can lead to unbootable machines and data loss.

> [!NOTE]  
> I intentionally do not provide copy/pastable commands for building, switching, or installing any of these configurations given the risks mentioned above.


## Installation 

```bash
$ sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./hosts/laptop/disko.nix

$ sudo nixos-install --flake .#NixOS
```

## Stow (Home configs)

```bash
$ stow config
```