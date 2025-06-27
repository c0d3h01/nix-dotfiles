# localhost dotfiles

## Fresh Installation

```bash
# Clone the repository

$ git clone https://github.com/c0d3h01/dotfiles.git

$ cd dotfiles

# Partition and format disk with Disko

$ just bootstrap
```

## Existing System

```bash
# Clone the repository

$ git clone https://github.com/c0d3h01/dotfiles.git

$ cd dotfiles

# Apply NixOS system configuration

$ just switch

# Apply Home manager user configuration

$ just home
```
