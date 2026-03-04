.PHONY: help rebuild home check fmt clean install-nix partition install-nixos troubleshoot-mount troubleshoot-enter troubleshoot
MAKEFLAGS += --no-print-directory
.DEFAULT_GOAL := help

# ── Defaults ──────────────────────────────────────────────────────────────
HOST ?= $(shell hostname)
DISK ?= /dev/nvme0n1
MNT ?= /mnt
USER ?= $(shell whoami)

# ── Positional shorthand: `make rebuild laptop` ──────────────────────────
CMD := $(firstword $(MAKECMDGOALS))
ARG := $(word 2,$(MAKECMDGOALS))
ifneq ($(filter rebuild home partition install-nixos,$(CMD)),)
  ifeq ($(HOST),$(shell hostname))
    ifneq ($(ARG),)
      HOST := $(ARG)
      .PHONY: $(ARG)
$(ARG):
	@:
    endif
  endif
endif

# ── Targets ───────────────────────────────────────────────────────────────
help: ## Show this help
	@printf "\033[1mUsage:\033[0m make \033[36m<target>\033[0m [HOST=<host>]\n\n"
	@grep -E '^[a-z-]+:.*##' $(MAKEFILE_LIST) \
		| awk -F ':.*## ' '{printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'
	@printf "\nDefaults:  HOST=%s  USER=%s\n" "$(HOST)" "$(USER)"

rebuild: _need-host ## NixOS rebuild switch
	sudo nixos-rebuild switch --flake ".#$(HOST)"

home: _need-host ## Home Manager switch
	home-manager switch --flake ".#$(USER)@$(HOST)"

install-nix: ## Install Nix package manager (multi-user)
	curl -L https://nixos.org/nix/install | sh -s -- --daemon

partition: ## Partition + format + mount via scripts/partition.sh (DESTRUCTIVE)
	sudo ./scripts/partition.sh $(DISK)

install-nixos: _need-host ## Run nixos-install from local flake
	sudo nixos-install --flake ".#$(HOST)" --no-root-passwd

troubleshoot-mount: ## Mount BTRFS subvolumes + EFI for rescue (by label)
	sudo mount -t btrfs -o subvol=/@ /dev/disk/by-label/nixos-root "$(MNT)"
	sudo mkdir -p "$(MNT)/home" "$(MNT)/nix" "$(MNT)/var/tmp" "$(MNT)/var/log" "$(MNT)/boot"
	sudo mount -t btrfs -o subvol=/@home /dev/disk/by-label/nixos-root "$(MNT)/home"
	sudo mount -t btrfs -o subvol=/@nix /dev/disk/by-label/nixos-root "$(MNT)/nix"
	sudo mount -t btrfs -o subvol=/@tmp /dev/disk/by-label/nixos-root "$(MNT)/var/tmp"
	sudo mount -t btrfs -o subvol=/@log /dev/disk/by-label/nixos-root "$(MNT)/var/log"
	sudo mount /dev/disk/by-label/NIXBOOT "$(MNT)/boot"

troubleshoot-enter: troubleshoot-mount ## Enter installed NixOS environment via nixos-enter
	sudo nixos-enter --root "$(MNT)"

troubleshoot: troubleshoot-enter ## Full troubleshooting flow


check: ## Flake check (all systems)
	nix flake check --all-systems

fmt: ## Format all Nix files
	nix fmt

clean: ## GC + optimise Nix store
	sudo nix-collect-garbage -d
	nix store optimise

# ── Helpers ───────────────────────────────────────────────────────────────
_need-host:
	@test -n "$(HOST)" || { echo "Usage: make $(CMD) HOST=<host>"; exit 1; }
