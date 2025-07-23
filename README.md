# **c0d3h01 Dotfiles**

These are my personal dotfiles, managed with [Nix Flakes](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake) and [Home Manager](https://nix-community.github.io/home-manager/).

---

## **Requirements**

* **Nix** (latest stable version).
  Install Nix using:

  ```bash
  sh <(curl -L https://nixos.org/nix/install)
  ```

* **SELinux Disabled** (required on SELinux-enabled systems).
  Nix has compatibility issues with SELinux. Disable it by editing `/etc/selinux/config`:

  ```bash
  sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
  sudo reboot
  ```

---

## **Installation**

### **Apply Home Manager Configuration**

Run the following command to switch to your Home Manager configuration directly from GitHub:

```bash
nix run github:nix-community/home-manager -- switch \
  --flake 'github:c0d3h01/dotfiles#c0d3h01@fedora'
```

---

## **Updating**

To update the flake inputs and reapply the configuration:

```bash
nix flake update --flake github:c0d3h01/dotfiles
nix run github:nix-community/home-manager -- switch \
  --flake 'github:c0d3h01/dotfiles#c0d3h01@fedora'
```

---

## **Optional: Local Clone**

If you want to edit your dotfiles locally:

```bash
git clone https://github.com/c0d3h01/dotfiles
cd dotfiles
nix run github:nix-community/home-manager -- switch \
  --flake '.#c0d3h01@fedora'
```

---

## **System Rebuild (NixOS Only)**

If your flake includes a NixOS system configuration:

```bash
sudo nixos-rebuild switch --flake 'github:c0d3h01/dotfiles#fedora'
```

---

## **Bootstrap on a Fresh System**

To bootstrap everything on a new system with a single command:

```bash
nix run github:nix-community/home-manager -- switch \
  --flake 'github:c0d3h01/dotfiles#c0d3h01@fedora'
```
