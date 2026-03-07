# NixOS Dotfiles

Declarative NixOS workstation configuration — one flake, modular NixOS and Home Manager modules, profile-driven host management, declarative disk partitioning, and encrypted secrets.

## How It Works

Everything starts from `flake.nix`. A single `make rebuild laptop` evaluates every module, resolves conditional logic based on the host's profile, and produces a complete system closure.

```
flake.nix
  └─ flake-parts
       └─ flake/
            ├─ hosts.nix       ← builds NixOS + Home Manager configs per host
            ├─ overlays.nix    ← nixpkgs overlays
            ├─ dev-shell.nix   ← nix develop environment
            └─ formatter.nix   ← treefmt (alejandra, deadnix, statix, etc.)
```

### Data Flow

```
hosts/default.nix           ← declare hosts, users, and profile flags
        │
        ▼
flake/hosts.nix             ← extract main user, build hostConfig, wire modules
        │
        ▼
modules/nixos/profile.nix   ← derive hostProfile (isWorkstation, windowManager,
        │                      bootloader) and expose via _module.args
        ▼
modules/nixos/*              ← read hostProfile to conditionally activate
modules/home/*               ← receive userConfig via extraSpecialArgs
```

No module hard-codes a hostname, username, or machine-specific value. All identity flows through `hostConfig` / `userConfig` / `hostProfile`.

---

## Repository Layout

```
flake.nix              # Inputs + flake-parts wiring
flake.lock             # Pinned deps (never edit manually)
Makefile               # All operational commands
flake/                 # Flake submodules (hosts, overlays, devshell, formatter)
hosts/                 # Per-host configs (users, filesystems, SSH keys)
scripts/               # Operational scripts (partitioning)
modules/nixos/         # System-level NixOS modules (grouped by category)
modules/home/          # User-level Home Manager modules (grouped by category)
secrets/               # sops-encrypted secrets (age)
```

Module categories are discoverable by browsing the directory tree — each subdirectory under `modules/nixos/` and `modules/home/` is a self-contained feature group with its own `default.nix` that imports everything inside it.

---

## Host Management

### Defining a Host

All hosts are declared in a single registry — `hosts/default.nix`:

```nix
{
  laptop = {
    system = "x86_64-linux";
    modules = [./laptop];          # host-specific directory

    users.c0d3h01 = {
      isMainUser = true;           # drives hostConfig
      fullName = "Harshal Sawant";
      workstation = true;          # gates desktop features
      windowManager = "gnome";     # selects DE
    };

    bootloader = "limine";         # selects bootloader
  };
}
```

| Field                        | Purpose                                                |
| ---------------------------- | ------------------------------------------------------ |
| `system`                     | Target architecture                                    |
| `modules`                    | Host-specific config directory (filesystems, SSH keys) |
| `users.<name>.isMainUser`    | Primary user — their flags drive the host profile      |
| `users.<name>.workstation`   | Enables desktop apps, GPU 32-bit, AppImage, scheduler  |
| `users.<name>.windowManager` | Desktop environment: `gnome` / `kde` / `xfce`          |
| `bootloader`                 | Bootloader: `limine` / `systemd` / `grub`              |

### How the Build Works

`flake/hosts.nix` orchestrates everything:

1. Reads the host registry
2. Finds the main user (`isMainUser = true`)
3. Builds a flat `hostConfig` attrset (hostname, username, system, bootloader, user flags)
4. Registers each host via `easy-hosts` with shared NixOS modules + home-manager
5. Wires Home Manager for the main user with `userConfig` as `extraSpecialArgs`
6. Exports standalone `homeConfigurations` for every `user@host` pair

### Profile Derivation

`modules/nixos/profile.nix` transforms raw host flags into typed values every module can query:

```
hostConfig.workstation = true       →  hostProfile.isWorkstation = true
hostConfig.windowManager = "gnome"  →  hostProfile.windowManager = "gnome"
hostConfig.bootloader = "limine"    →  hostProfile.bootloader = "limine"
```

Assertions validate allowed values at evaluation time — invalid profiles fail the build, not the runtime.

### Adding a New Host

1. Add an entry to `hosts/default.nix`
2. Create `hosts/<name>/default.nix` (SSH keys, user passwords)
3. Create `hosts/<name>/filesystems.nix` (label-based mounts — copy from an existing host)
4. Build: `nix build .#nixosConfigurations.<name>.config.system.build.toplevel`

---

## Module System

### Architecture

Both NixOS and Home Manager modules follow a single pattern:

```
modules/{nixos,home}/<category>/
  default.nix   ← imports all .nix files in the directory
  foo.nix       ← config = lib.mkIf <condition> { ... };
  bar.nix       ← config = lib.mkIf <condition> { ... };
```

**Every module is always imported.** Activation is controlled inside each module via `lib.mkIf` on profile values — not through selective imports. This means:

- **Add a new module** → drop a `.nix` file in the right category, add it to that category's `default.nix` imports. No other file changes needed.
- **Remove a module** → delete the file and its import line. Nothing else breaks.
- **All features are visible** from the directory listing alone.

### NixOS Modules (`modules/nixos/`)

System-level configuration grouped into categories: boot, desktop, hardware, networking, nix, security, services, and system. A central `profile.nix` derives `hostProfile` that all other modules read.

Modules activate conditionally based on profile flags:

```nix
# Only one bootloader activates
config = lib.mkIf (hostProfile.bootloader == "limine") { ... };

# Only one DE activates
config = lib.mkIf (hostProfile.windowManager == "gnome") { ... };

# Workstation-only features
config = lib.mkIf hostProfile.isWorkstation { ... };
```

### Home Manager Modules (`modules/home/`)

User-level configuration grouped into categories: cli, core, dev, media, shell, and terminal. The root `default.nix` sets user identity (`home.username`, `homeDirectory`) from `userConfig`.

Some modules use opt-in enable options for heavyweight features:

```nix
options.dotfiles.home.features.spicetify.enable = lib.mkEnableOption "Spicetify";
config = lib.mkIf (cfg.enable && userConfig.workstation) { ... };
```

---

## Secrets

Encrypted with [sops-nix](https://github.com/Mic92/sops-nix) using age keys derived from SSH ed25519 keys.

- **System-level**: key from `/etc/ssh/ssh_host_ed25519_key`
- **User-level**: key from `~/.ssh/id_ed25519`
- **Store**: `secrets/default.yaml`

Reference in modules via `config.sops.secrets.<name>.path` — never inline plaintext.

---

## Commands

All operations via `Makefile` (run `make help` for the full list):

```bash
make rebuild [HOST]       # NixOS rebuild switch
make home [HOST]          # Home Manager switch
make check                # nix flake check --all-systems
make fmt                  # Format everything (treefmt)
make clean                # GC + store optimise

# Fresh install
make partition DISK=/dev/nvme0n1  # Partition + format + mount (DESTRUCTIVE)
make install-nixos [HOST]         # nixos-install from flake

# Rescue
make troubleshoot         # Mount subvolumes by label + nixos-enter
```

`HOST` defaults to the current hostname. Positional shorthand: `make rebuild laptop`.

Partitioning uses `scripts/partition.sh` which creates GPT partitions with fixed labels (`nixos-boot`, `nixos-swap`, `nixos-root`). NixOS mounts by label, so the config works on any disk without changes.

---

## Installation

```bash
# Boot NixOS ISO, then:
git clone https://github.com/c0d3h01/dotfiles && cd dotfiles
make partition DISK=/dev/nvme0n1   # partition + format + mount (destructive)
make install-nixos laptop          # install system
reboot
```
