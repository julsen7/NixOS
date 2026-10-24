# NIXOS

## Installation

Boot from USB-stick with Nixos-minimal. Change host.
Internet via nmtui or LAN cable, then:

```bash
sudo -i

parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart root ext4 512MB -8GB
parted /dev/nvme0n1 -- mkpart swap linux-swap -8GB 100%
parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB
parted /dev/nvme0n1 -- set 3 esp on

mkfs.ext4 -L nixos /dev/nvme0n1p1
mkswap -L swap /dev/nvme0n1p2
mkfs.fat -F 32 -n boot /dev/nvme0n1p3

mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
swapon /dev/nvme0n1p2
lsblk -f

nixos-install --flake github:julsen7/nixos#HOST --root /mnt
```

## Other information

Wallpapers:

- <https://www.wallpaperflare.com/>
- <https://4kwallpapers.com/>
