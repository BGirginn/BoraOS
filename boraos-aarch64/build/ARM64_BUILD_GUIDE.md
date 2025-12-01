# ARM64 Build Guide - Arch Linux ARM VM

## Problem: archiso Not Available

`archiso` is not available in Arch Linux ARM repositories by default. Here are solutions:

## Option 1: Install archiso from AUR

```bash
# Install dependencies
sudo pacman -S --needed git base-devel squashfs-tools uboot-tools

# Clone and build archiso from AUR
cd ~
git clone https://aur.archlinux.org/archiso.git
cd archiso
makepkg -si
```

After installing, proceed with normal build:
```bash
cd /path/to/BoraOS/boraos-aarch64
sudo ./build/build-arm.sh
```

## Option 2: Manual Build Without archiso

If archiso fails, you can manually create a bootable ARM64 image:

### Step 1: Create Base System
```bash
cd ~/BoraOS/boraos-aarch64

# Create working directory
sudo mkdir -p build/work/rootfs

# Bootstrap base system
sudo pacstrap -C pacman.conf build/work/rootfs base linux-aarch64 linux-firmware
```

### Step 2: Install Packages
```bash
# Install packages from packages.aarch64
sudo arch-chroot build/work/rootfs pacman -S --needed $(cat packages.aarch64)
```

### Step 3: Configure System
```bash
# Copy configurations
sudo cp -r airootfs/* build/work/rootfs/

# Set up basic system
sudo arch-chroot build/work/rootfs /bin/bash << 'EOF'
# Set locale
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Enable services
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable sddm
EOF
```

### Step 4: Create SquashFS
```bash
# Create compressed filesystem
sudo mksquashfs build/work/rootfs build/work/rootfs.sfs \
    -comp zstd -Xcompression-level 15 -b 1M
```

### Step 5: Create Bootable Image

**For UEFI ARM64:**
```bash
# Create ISO structure
sudo mkdir -p build/work/iso/boot/grub

# Copy kernel and initramfs
sudo cp build/work/rootfs/boot/vmlinuz-linux-aarch64 build/work/iso/boot/
sudo cp build/work/rootfs/boot/initramfs-linux-aarch64.img build/work/iso/boot/

# Copy squashfs
sudo mkdir -p build/work/iso/arch/aarch64
sudo mv build/work/rootfs.sfs build/work/iso/arch/aarch64/airootfs.sfs

# Create ISO
sudo grub-mkrescue -o build/out/boraos-arm-0.1-aarch64.iso build/work/iso
```

**For Raspberry Pi:**
```bash
# Create raw disk image (4GB)
dd if=/dev/zero of=build/out/boraos-arm-0.1-aarch64.img bs=1M count=4096

# Partition
parted build/out/boraos-arm-0.1-aarch64.img mklabel msdos
parted build/out/boraos-arm-0.1-aarch64.img mkpart primary fat32 1MiB 256MiB
parted build/out/boraos-arm-0.1-aarch64.img mkpart primary ext4 256MiB 100%

# Format and copy files (requires loop device mounting)
```

## Option 3: Cross-Compile from x86_64

Build the ISO on an x86_64 Arch Linux system with proper cross-compilation tools.

This is complex and not recommended for first builds.

---

## Recommended Approach

**For quick testing**: Use Option 1 (AUR archiso)

**For production**: Set up proper x86_64 build environment or use GitHub Actions for automated builds

---

## Troubleshooting

### AUR Build Fails
```bash
# Install missing dependencies
sudo pacman -S --needed fakeroot binutils
```

### pacstrap Not Found
```bash
sudo pacman -S arch-install-scripts
```

### Permission Denied
Make sure you're running build commands with `sudo`
