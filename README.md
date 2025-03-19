[![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%40with%40Nix&color=41439a)](https://builtwithnix.org)

## 📂 Dotfiles Structure
```
.
├── LICENSE
├── README.md
├── README_TREE.md
├── assets
│   └── wallpaper.png
├── flake.lock
├── flake.nix
├── home
│   ├── home.nix
│   └── modules
│       ├── default.nix
│       ├── firefox
│       ├── git
│       ├── kitty
│       ├── neovim
│       └── zshell
├── nix
│   ├── apps
│   │   ├── default.nix
│   │   ├── devtools
│   │   ├── notion-app-enhanced
│   │   ├── printing.nix
│   │   └── steam.nix
│   ├── configuration.nix
│   ├── hardware.nix
│   ├── tweaks
│   │   ├── default.nix
│   │   ├── kernel.nix
│   │   └── tlp.nix
│   └── user
│       ├── audio.nix
│       ├── default.nix
│       ├── desktop.nix
│       ├── fonts.nix
│       ├── networking.nix
│       └── user.nix
├── scripts
│   └── install.sh
└── shell.nix
```
