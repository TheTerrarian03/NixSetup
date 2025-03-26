sudo -s

# disk partitioning
lsblk  # find /dev/sdX, the drive you want to install to

# open fdisk and create GUID partition scheme
fdisk
g

# new partition of 500M for EFI
n
[enter]
[enter]
+500M

# new partition of 4096M for SWAP
n
[enter]
[enter]
+4096M

# rest of free space for rest of nix
n
[enter]
[enter]
[enter]

# change partition 1 to EFI (boot)
t
1
1

# change partition 2 to SWAP
t
2
19

# write to disk
w

# format partitions
mkfs.fat -F 32 -n boot /dev/sda1  # for boot
mkfs.ext4 -L nixos /dev/sda3      # for home
mkswap -L swap /dev/sda2          # for swap
swapon /dev/sda2                  # enable swap

# make folder for & mount main partition
mkdir -p /mnt
mount /dev/sda3 /mnt

# make folder for & mount boot partition
mkdir -p /mnt/boot
mount -o umask=077 /dev/sda1 /mnt/boot

# make & edit nixos config file
nixos-generate-config --root /mnt
nano /mnt/etc/nixos/configuration.nix

... stuff for setup

config files:
- ~/.config/openbox/autostart