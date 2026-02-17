#!/usr/bin/env bash
set -euo pipefail

DISK="${1:-/dev/nvme0n1}"
MNT="/mnt"

# Partition layout (disko hardware0x0.nix)
BOOT="${DISK}p1"
ROOT="${DISK}p3"

echo ">> Mounting $DISK to $MNT ..."

# Btrfs subvolumes
mount -o subvol=/@,compress=zstd:3,noatime        "$ROOT" "$MNT"
mkdir -p "$MNT"/{boot,home,nix,var/log,var/tmp}
mount -o subvol=/@home,compress=zstd:3,noatime    "$ROOT" "$MNT/home"
mount -o subvol=/@nix,compress=zstd:3,noatime     "$ROOT" "$MNT/nix"
mount -o subvol=/@log,compress=zstd:3,noatime     "$ROOT" "$MNT/var/log"
mount -o subvol=/@tmp,compress=zstd:3,noatime     "$ROOT" "$MNT/var/tmp"

# EFI boot
mount "$BOOT" "$MNT/boot"

# Pseudo filesystems
mount --bind /dev  "$MNT/dev"
mount --bind /proc "$MNT/proc"
mount --bind /sys  "$MNT/sys"
mount --bind /run  "$MNT/run"

echo ">> Entering chroot ..."
nixos-enter --root "$MNT"

echo ">> Cleaning up mounts ..."
umount -R "$MNT"
echo ">> Done."
