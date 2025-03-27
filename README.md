<img src="assets/image.png" alt="Custom Image" height="100"/>

## 📂 **Dotfiles Installation**
```bash
sudo nixos-rebuild switch --flake github:c0d3h01/dotfiles#NixOS --fast
```

## **Helper functions ⤵**

### 🔄 **Refresh Git Cloning While Building**
If you need to **force a fresh clone of the repository** while rebuilding, use `--refresh`:
```bash
sudo nixos-rebuild switch --flake github:c0d3h01/dotfiles#NixOS --refresh
```

### 🚀 **Use Impure Mode (`--impure`)**
By default, **Nix flakes enforce purity**, meaning they strictly use the configurations and dependencies defined in your flake. However, if you need to allow system state (like `/etc/nixos/hardware-configuration.nix`) to influence the rebuild, use `--impure`:
```bash
sudo nixos-rebuild switch --flake github:c0d3h01/dotfiles#NixOS --impure
```
🔹 **When to use `--impure`?**  
- If you **don’t want to apply** the `hardware-configuration.nix` from your dotfiles and instead use the one in `/etc/nixos/`.  
- If you have **system-dependent configurations** that should not be overridden by the flake.  

### 📁 **Dotfiles Structure**
- ⟶ [Click HERE!](https://github.com/c0d3h01/dotfiles/blob/main/structure.md)
