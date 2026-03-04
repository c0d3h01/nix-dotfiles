# AGENTS.md — NixOS Dotfiles Repo

> Agents working in this repo: read this file completely before touching anything.
> Every rule here exists because violating it breaks the build or breaks reproducibility.

---

## 0. BEFORE YOU WRITE A SINGLE LINE

Run these. Read the output. Do not proceed until you understand the current state:

```bash
# Understand the module tree
find . -name "*.nix" | sort

# Check what hosts exist
ls hosts/

# Check what home-manager profiles exist
ls home/

# Understand the flake inputs currently pinned
nix flake metadata

# See what's broken right now
nix flake check 2>&1
```

Never assume the repo structure. Always read it first.

---

## 1. REPO STRUCTURE — DO NOT DEVIATE

```
flake.nix                  # Entry point. Inputs + outputs only. No config logic here.
flake.lock                 # Never edit manually.
lib/                       # Custom lib functions only. No system config here.
modules/
  nixos/                   # NixOS system modules (root-owned config)
  home/                    # home-manager modules (user-space config)
hosts/
  <hostname>/
    default.nix            # Host entry: imports only. hardware-configuration.nix + profile modules.
    hardware-configuration.nix
home/
  <username>/
    default.nix            # User entry: imports only.
pkgs/                      # Custom/override packages
overlays/                  # Nixpkgs overlays
secrets/                   # sops-nix encrypted secrets only. No plaintext ever.
```

If a file doesn't fit this structure, create the correct directory. Do not put things in wrong places because it's convenient.

---

## 2. MODULE RULES — ENFORCED

### Every module file MUST:

1. Start with: `# Purpose: <one sentence describing exactly what this configures>`
2. Have a top-level `options` block if it exposes any user-facing configuration
3. Have a `config = lib.mkIf cfg.enable { ... }` block guarded by its own enable option
4. Import only `lib`, `pkgs`, `config` that it actually uses

### Minimal correct module skeleton:

```nix
# Purpose: Configures <X> for <reason>
{ config, lib, pkgs, ... }:

let
  cfg = config.<namespace>.<moduleName>;
in {
  options.<namespace>.<moduleName> = {
    enable = lib.mkEnableOption "<what this module does>";

    # Add options here. Every option needs: type, default, description.
    # Example:
    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 12;
      description = "Font size in points.";
    };
  };

  config = lib.mkIf cfg.enable {
    # implementation here
  };
}
```

Do not write modules that lack `options` and `config` separation. Monolithic configs are rejected.

---

## 3. WHAT GOES WHERE — HARD RULES

| Config Type | Location |
|---|---|
| Systemd services, kernel params, filesystems, networking | `modules/nixos/` |
| User applications, shell config, dotfiles, fonts | `modules/home/` |
| Secret values (passwords, keys, tokens) | `secrets/` via sops-nix |
| Machine-specific hardware quirks | `hosts/<hostname>/hardware-configuration.nix` |
| Shared logic reused across modules | `lib/` |
| Custom packages not in nixpkgs | `pkgs/` |
| Nixpkgs patches/version overrides | `overlays/` |

Violation example: Do NOT put `users.users` config inside a home-manager module. Do NOT put `programs.neovim` (user app) inside a NixOS system module.

---

## 4. SECRETS — NON-NEGOTIABLE

- **Zero plaintext secrets anywhere in `.nix` files.** Not even in comments.
- All secrets go through sops-nix: `sops.secrets.<name>.owner = "<user>";`
- Reference secrets via: `config.sops.secrets.<name>.path`
- Never use `builtins.readFile` on a file that contains a secret
- Never use environment variables to pass secrets into Nix expressions

If you don't know how sops-nix works in this repo, read `secrets/` and `modules/nixos/sops.nix` before touching anything secret-adjacent.

---

## 5. FLAKE RULES

### `flake.nix` must follow this pattern:

```nix
{
  description = "<repo description>";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Every non-nixpkgs input MUST declare: nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";  # REQUIRED. Prevents duplicate nixpkgs in closure.
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";  # REQUIRED.
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # outputs only — no pkgs.lib calls at top level, no config logic
  };
}
```

**Every input that transitively depends on nixpkgs must have `inputs.nixpkgs.follows = "nixpkgs"`.** No exceptions. Omitting this creates duplicate nixpkgs evaluation and breaks binary cache hits.

---

## 6. NIX EXPRESSION RULES

### Use lib functions. Do not reinvent them.

| Instead of | Use |
|---|---|
| `if x then [a] else []` | `lib.optional x a` |
| `if x then [a b] else []` | `lib.optionals x [a b]` |
| `if x then { a = 1; } else {}` | `lib.optionalAttrs x { a = 1; }` |
| `list1 ++ list2 ++ list3` (nested) | `lib.flatten [list1 list2 list3]` |
| `builtins.concatStringsSep` | `lib.concatStringsSep` |

### Priority modifiers — use exactly as defined:

- `lib.mkDefault v` — sets a value that can be overridden downstream. Use for sensible defaults.
- `lib.mkForce v` — overrides everything. Use **only** when you explicitly need to win a merge conflict. Document why with a comment.
- `lib.mkIf cond v` — conditional. Use instead of ternary where the false case is "no config".
- `lib.mkMerge [a b]` — merges attribute sets. Use when building config from multiple sources.

**Never use `lib.mkForce` as a lazy fix for merge conflicts you don't understand.**

### Sorting:

All option sets within a `config` or `options` block are sorted alphabetically by key. Non-negotiable. Unsorted blocks will be rejected in review.

---

## 7. MAKING CHANGES — EXACT WORKFLOW

### Adding a new NixOS module:

1. Create `modules/nixos/<name>.nix` using the skeleton from §2
2. Add `imports = [ ../modules/nixos/<name>.nix ];` in the relevant host's `default.nix`
3. Enable it: `<namespace>.<name>.enable = true;` in the host config
4. Run: `nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel`
5. Fix all errors before committing

### Adding a new home-manager module:

1. Create `modules/home/<name>.nix` using the skeleton from §2
2. Add to the relevant user's `home/<username>/default.nix` imports
3. Run: `nix build .#homeConfigurations.<user>.activationPackage`
4. Fix all errors before committing

### Modifying an existing module:

1. Read the whole file first
2. Check all hosts/users that import it: `grep -r "<module-name>" --include="*.nix"`
3. Make the change
4. Rebuild every affected host/user profile
5. Never modify a module without checking its blast radius

### Adding a package:

- If it's in nixpkgs: add to `environment.systemPackages` (NixOS) or `home.packages` (home-manager)
- If it needs patching: add to `overlays/` with a comment explaining the patch and linking the upstream issue
- If it doesn't exist in nixpkgs: add to `pkgs/` as a proper derivation, not an inline `pkgs.stdenv.mkDerivation` buried in a module

---

## 8. VALIDATION — RUN BEFORE EVERY COMMIT

```bash
# Full flake check (catches eval errors across all outputs)
nix flake check

# Build a specific host (catches missing options, type errors)
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel

# Build a specific home profile
nix build .#homeConfigurations.<user>.activationPackage

# Check for unused inputs (cleanup)
nix flake metadata | grep -A999 "Inputs:"

# Formatting (if alejandra or nixpkgs-fmt is in devShell)
alejandra . -- --check
# or
nixpkgs-fmt --check .
```

A commit that breaks `nix flake check` is a broken commit. Do not leave the repo in a broken state.

---

## 9. WHAT AGENTS MUST NEVER DO

- **Never truncate output.** If you're generating a Nix file, generate the complete file. No `# ... rest of module here` placeholders.
- **Never use `with pkgs;` at module top-level.** It pollutes scope and makes deps invisible. Use explicit `pkgs.<name>`.
- **Never hardcode paths** like `/home/username/` — use `config.home.homeDirectory` or `config.users.users.<name>.home`.
- **Never write `environment.etc` for secrets.** Use sops-nix.
- **Never add `allowUnfree = true` globally** without a comment listing exactly which packages require it and why.
- **Never modify `flake.lock` manually.** Run `nix flake update <input>` if an update is needed.
- **Never use `builtins.fetchTarball` or `builtins.fetchGit` inside modules.** All external sources go through flake inputs.
- **Never set `nix.settings.experimental-features` without checking it's not already set elsewhere** — duplicate settings cause eval errors.

---

## 10. WHEN YOU HIT AN ERROR

1. Read the full error. Nix errors tell you the exact file and line.
2. If it's a type error: check `lib.types.*` — you're passing the wrong type to an option.
3. If it's "infinite recursion": you have a circular `config` reference. Use `lib.mkDefault` or restructure.
4. If it's "attribute X missing": the module defining that option isn't imported. Check the import chain.
5. If it's a hash mismatch in a fetcher: run `nix flake update` or fix the `hash` attribute.
6. Do not paper over errors with `lib.mkForce`. Understand the conflict first.

---

## 11. RESPONSE FORMAT FOR CODE GENERATION

When generating any `.nix` file:

1. State what the file does in one sentence
2. List every NixOS/home-manager option you're setting and why (not what — why)
3. List any tradeoffs or alternatives you considered and rejected
4. Output the complete file — no truncation, no placeholders
5. State exactly where the file goes in the repo and what imports it

When answering questions about options or behavior:
- Cite the exact nixpkgs module source path (e.g., `nixos/modules/services/networking/openssh.nix`)
- Or cite the NixOS manual section
- Do not cite blog posts
