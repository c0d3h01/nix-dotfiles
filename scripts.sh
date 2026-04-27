#!/usr/bin/env bash

set -e

DISK="${1:-}"
MODE="${2:-install}"

BOOT=""
ROOT=""

LABEL_BOOT="NIX-BOOT"
LABEL_ROOT="nix-root"

check_args() {
  if [[ -z "$DISK" ]]; then
    echo "Usage: sudo $0 /dev/nvme0n1 [install|rescue]"
    exit 1
  fi

  BOOT="${DISK}p1"
  ROOT="${DISK}p2"
}

partition_disk() {
  parted $DISK --script \
    mklabel gpt \
    mkpart ESP fat32 1MiB 513MiB \
    set 1 esp on \
    mkpart primary 513MiB 100%
}

format_fs() {
  mkfs.vfat -F32 -n $LABEL_BOOT $BOOT
  mkfs.btrfs -f -L $LABEL_ROOT $ROOT
}

create_subvols() {
  mount $ROOT /mnt

  btrfs subvolume create /mnt/@
  btrfs subvolume create /mnt/@home
  btrfs subvolume create /mnt/@nix
  btrfs subvolume create /mnt/@var
}

mount_fs() {
  umount /mnt

  mount -o subvol=@,noatime,compress=zstd:3 $ROOT /mnt

  mkdir -p /mnt/home
  mount -o subvol=@home,noatime,compress=zstd:3 $ROOT /mnt/home

  mkdir -p /mnt/nix
  mount -o subvol=@nix,noatime,compress=zstd:3 $ROOT /mnt/nix

  mkdir -p /mnt/var
  mount -o subvol=@var,noatime,compress=zstd:3 $ROOT /mnt/var

  mkdir -p /mnt/boot
  mount $BOOT /mnt/boot
}

create_swap() {
  btrfs filesystem mkswapfile --size 7G /mnt/var/swapfile
  swapon /mnt/var/swapfile
}

generate_nixos() {
  nixos-generate-config --root /mnt
}

install_nixos() {
  nixos-install
}

rescue_mode() {
  echo "[RESCUE MODE] Mounting existing system..."

  mount -o subvol=@,noatime,compress=zstd:3 $ROOT /mnt
  mkdir -p /mnt/home /mnt/nix /mnt/var /mnt/boot

  mount -o subvol=@home,noatime,compress=zstd:3 $ROOT /mnt/home
  mount -o subvol=@nix,noatime,compress=zstd:3 $ROOT /mnt/nix
  mount -o subvol=@var,noatime,compress=zstd:3 $ROOT /mnt/var
  mount $BOOT /mnt/boot

  swapon /mnt/var/swapfile 2>/dev/null || true

  echo "[RESCUE MODE] System mounted at /mnt"
}

install_mode() {
  partition_disk
  format_fs
  create_subvols
  mount_fs
  create_swap
  generate_nixos
  install_nixos
}

main() {
  check_args

  if [[ "$MODE" == "rescue" ]]; then
    rescue_mode
  else
    install_mode
  fi
}

main
