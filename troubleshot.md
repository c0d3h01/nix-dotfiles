# Troubleshooting NixOS Enter with Btrfs Subvolumes

## Make enter into chroot

```bash
sudo mkdir -p /mnt
sudo mount -o subvol=@ /dev/nvme0n1p3 /mnt
sudo mount -o subvol=@home /dev/nvme0n1p3 /mnt/home
sudo mount -o subvol=@nix /dev/nvme0n1p3 /mnt/nix
sudo mount -o subvol=@cache /dev/nvme0n1p3 /mnt/var/cache
sudo mount -o subvol=@log /dev/nvme0n1p3 /mnt/var/log
sudo mount /dev/nvme0n1p1 /mnt/boot
sudo mount -o bind,ro /etc/resolv.conf /mnt/etc/resolv.conf
sudo nixos-enter --root /mnt
```

## In chroot only!

```bash
sudo mount --rbind /dev /mnt/dev
sudo mount --make-rslave /mnt/dev
sudo mount --rbind /proc /mnt/proc
sudo mount --make-rslave /mnt/proc
sudo mount --rbind /sys /mnt/sys
sudo mount --make-rslave /mnt/sys
```

## Umount all mounts

```bash
exit
sudo umount -Rl /mnt/dev
sudo umount -Rl /mnt/proc
sudo umount -Rl /mnt/sys
sudo umount /mnt/boot
sudo umount /mnt/var/log
sudo umount /mnt/var/cache
sudo umount /mnt/nix
sudo umount /mnt/home
sudo umount /mnt
```
