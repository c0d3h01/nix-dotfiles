HOST ?= $(shell hostname)
DISK ?= /dev/nvme0n1
MNT  ?= /mnt
USER ?= $(shell whoami)

NIX_FLAGS := --extra-experimental-features "nix-command flakes"

.PHONY: help rebuild home partition install-nix install-nixos mount-rescue troubleshoot swap-on swap-off check fmt clean

help: ## Show this help
	@echo "Usage: make <target> [HOST=<host>]"
	@echo ""
	@echo "Targets:"
	@echo "  rebuild          NixOS rebuild switch"
	@echo "  home             Home Manager switch (standalone)"
	@echo "  partition        Partition + format + mount (DESTRUCTIVE)"
	@echo "  install-nix      Install Nix package manager (multi-user)"
	@echo "  install-nixos    Run nixos-install from local flake"
	@echo "  mount-rescue     Mount BTRFS subvolumes for rescue"
	@echo "  troubleshoot     Mount + enter NixOS rescue environment"
	@echo "  swap-on          Create temporary swapfile for installation"
	@echo "  swap-off         Remove temporary swapfile"
	@echo "  check            Flake check (all systems)"
	@echo "  fmt              Format all Nix files"
	@echo "  clean            GC + optimise Nix store"
	@echo ""
	@echo "Defaults: HOST=$(HOST), USER=$(USER), DISK=$(DISK)"

rebuild:
	@test -n "$(HOST)" || { echo "Error: HOST is empty"; exit 1; }
	sudo nixos-rebuild switch --flake ".#$(HOST)"

home:
	@test -n "$(HOST)" || { echo "Error: HOST is empty"; exit 1; }
	home-manager $(NIX_FLAGS) switch --flake ".#$(USER)@$(HOST)"

partition:
	sudo nix $(NIX_FLAGS) run .#partition -- $(DISK) $(MNT)

install-nix:
	nix $(NIX_FLAGS) run .#install-nix

install-nixos:
	@test -n "$(HOST)" || { echo "Error: HOST is empty"; exit 1; }
	sudo nix $(NIX_FLAGS) run .#nixos-install -- --flake ".#$(HOST)" --no-root-passwd

mount-rescue:
	sudo nix $(NIX_FLAGS) run .#mount-rescue -- $(MNT)

troubleshoot:
	sudo nix $(NIX_FLAGS) run .#troubleshoot -- $(MNT)

swap-on:
	sudo nix $(NIX_FLAGS) run .#swap-on -- $(MNT)

swap-off:
	sudo nix $(NIX_FLAGS) run .#swap-off -- $(MNT)

check:
	nix $(NIX_FLAGS) flake check --all-systems

fmt:
	nix $(NIX_FLAGS) fmt

clean:
	sudo nix-collect-garbage -d
	nix $(NIX_FLAGS) store optimise
