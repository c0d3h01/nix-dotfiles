# Personal `localhost` dotfiles

* _Declarative NixOS configuration with Flakes & Home Manager_

## Fresh Installation

```bash
# Clone the repository
git clone https://github.com/c0d3h01/dotfiles.git
cd dotfiles

# Partition and format disk with Disko
sudo nix --experimental-features "nix-command flakes" run \
  github:nix-community/disko/latest -- \
  --mode destroy,format,mount ./machines/installer/disko-config.nix

# Only for low ram devices!
sudo mkdir /mnt/swap
sudo chattr +C /mnt/swap
sudo dd if=/dev/zero of=/mnt/swap/swapfile bs=1M count=8048 status=progress
sudo chmod 600 /mnt/swap/swapfile
sudo mkswap /mnt/swap/swapfile
sudo swapon /mnt/swap/swapfile

# Install NixOS
sudo nixos-install --flake .#devbox
```

<<<<<<< Updated upstream
#### One-liner for fresh installation

```bash
sudo nix run \
  'github:nix-community/disko/latest#disko-install' -- \
  --flake github:c0d3h01/dotfiles#devbox \
  --disk <disk-name> <disk-device>
```

### Existing System
||||||| Stash base
### Existing System
=======
## Existing System
>>>>>>> Stashed changes

```bash
# Clone the repository
git clone https://github.com/c0d3h01/dotfiles.git
cd dotfiles

# Apply system configuration
sudo nixos-rebuild switch --flake .#devbox

# Apply user configuration
home-manager switch --flake .#c0d3h01@devbox
```
