# BoraOS x86_64 - User Build Guide

## Quick Start

```bash
# 1. Get the source
git clone https://github.com/BGirginn/BoraOS.git
cd BoraOS/Bora_OS_x86

# 2. Build ISO (requires x86_64 Arch Linux)
sudo ./build/build-x86.sh

# 3. Find your ISO
ls -lh build/out/boraos-0.1-x86_64.iso
```

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Building the ISO](#building-the-iso)
3. [Understanding the Build](#understanding-the-build)
4. [Testing the ISO](#testing-the-iso)
5. [Installation](#installation)
6. [Post-Installation](#post-installation)
7. [Customization](#customization)
8. [Troubleshooting](#troubleshooting)
9. [FAQ](#faq)

---

## Prerequisites

### System Requirements

**Build System (Host)**:
- Operating System: Arch Linux x86_64
- CPU: 2+ cores (4+ recommended)
- RAM: 4GB minimum (8GB+ recommended)
- Disk Space: 10GB free minimum (20GB+ recommended)
- Network: Active internet connection

**Target System (for Installation)**:
- CPU: x86_64 processor (Intel/AMD)
- RAM: 2GB minimum (4GB+ recommended)
- Disk: 20GB+ for installation
- Graphics: Intel/AMD (Vulkan support recommended)
- Boot: UEFI or Legacy BIOS

### Required Packages

Install dependencies on your Arch Linux build system:

```bash
sudo pacman -Syu
sudo pacman -S archiso
```

**Optional but recommended**:
```bash
sudo pacman -S qemu-full  # For testing ISO in VM
```

### Permission Check

The build process requires root privileges:
```bash
# Verify you have sudo access
sudo -v
```

---

## Building the ISO

### Step-by-Step Build

1. **Navigate to build directory**:
```bash
cd /path/to/BoraOS/Bora_OS_x86
```

2. **Run the build script**:
```bash
sudo ./build/build-x86.sh
```

3. **Wait for completion** (~10-20 minutes):
   - You'll see a progress bar
   - Logs are written to `build/logs/`
   - Errors will be displayed in red

4. **Locate your ISO**:
```bash
ls -lh build/out/boraos-0.1-x86_64.iso
```

### Expected Output

```
╔═══════════════════════════════════════════════════════════════╗
║              BoraOS x86_64 Build System v0.1                 ║
╚═══════════════════════════════════════════════════════════════╝

[1/7] Prepare ARM64 Build Environment
[2/7] Clean Previous Build
[3/7] Sync ARM64 Profile Files
[4/7] Configure ARM64 Bootloader
[5/7] Build ARM64 Image/ISO
[6/7] Finalize ARM64 Output
[7/7] Generate Checksums

╔═══════════════════════════════════════════════════════════════╗
║                   BUILD COMPLETED!                            ║
╚═══════════════════════════════════════════════════════════════╝

ISO Location: /path/to/build/out/boraos-0.1-x86_64.iso
ISO Size: 1.2 GB
```

### Build Artifacts

After successful build:
```
build/
├── out/
│   ├── boraos-0.1-x86_64.iso         # Bootable ISO
│   ├── boraos-0.1-x86_64.iso.sha256  # Checksum
│   └── SHA256SUMS                     # All checksums
├── logs/
│   ├── mkarchiso.log                 # Complete build log
│   └── build_YYYYMMDD_HHMMSS.log    # Timestamped log
└── work/                              # Build cache (safe to delete)
```

---

## Understanding the Build

### Build Pipeline

The build process runs 7 automated steps:

| Step | Script | Purpose | Duration |
|------|--------|---------|-----------|
| 1 | prepare_environment_x86.sh | System checks | <1 min |
| 2 | clean_previous_build.sh | Cleanup | <1 min |
| 3 | sync_profile_x86.sh | Copy files | <1 min |
| 4 | build_bootloader_x86.sh | Verify bootloaders | <1 min |
| 5 | build_image_x86.sh | Create ISO | 8-15 min |
| 6 | finalize_x86.sh | Rename/finalize | <1 min |
| 7 | generate_checksums.sh | Generate SHA256 | <1 min |

### What Gets Included

**129 Packages**:
- Base system (Arch Linux)
- Linux kernel + firmware
- Hyprland desktop (Wayland)
- Firefox web browser
- System utilities
- Development tools (optional)

**Bootloaders**:
- GRUB (UEFI)
- Syslinux (BIOS)
- systemd-boot (UEFI alternative)

**Desktop Environment**:
- Hyprland (tiling window manager)
- Waybar (status bar)
- Firefox (web browser)
- Alacritty (terminal)
- Rofi (launcher)

---

## Testing the ISO

### Option 1: Virtual Machine (QEMU)

**Fastest testing method**:

```bash
# UEFI boot
qemu-system-x86_64 \
  -enable-kvm \
  -m 4096 \
  -cdrom build/out/boraos-0.1-x86_64.iso \
  -boot d

# Legacy BIOS boot
qemu-system-x86_64 \
  -enable-kvm \
  -m 4096 \
  -cdrom build/out/boraos-0.1-x86_64.iso \
  -boot d \
  -bios /usr/share/qemu/bios.bin
```

### Option 2: VirtualBox

1. Create new VM:
   - Type: Linux
   - Version: Arch Linux (64-bit)
   - RAM: 4096 MB
   - Disk: 20 GB (for installation test)

2. Mount ISO:
   - Settings → Storage → Add optical drive
   - Select `boraos-0.1-x86_64.iso`

3. Boot and test

### Option 3: Physical USB

⚠️ **WARNING**: This will erase the USB drive!

```bash
# Identify USB device (e.g., /dev/sdb)
lsblk

# Write ISO (REPLACE /dev/sdX with your USB device!)
sudo dd if=build/out/boraos-0.1-x86_64.iso \
        of=/dev/sdX \
        bs=4M \
        status=progress \
        conv=fsync

# Wait for completion
sudo sync
```

**Boot from USB**:
1. Insert USB drive
2. Restart computer
3. Enter BIOS/UEFI (usually F2, F12, Del, or Esc)
4. Select USB device
5. Boot

---

## Installation

### Live Environment

When you boot the ISO:
- Auto-login as `liveuser`
- Passwordless sudo (live environment only!)
- Network should connect automatically (NetworkManager)

### Installation Methods

#### Method 1: Guided Install (Recommended)

```bash
# Launch archinstall (TUI installer)
sudo archinstall
```

**Follow prompts**:
1. Select language/locale
2. Choose keyboard layout
3. Partition disk (or use auto-partition)
4. Select installation profile: "Minimal"
5. Set user account and password
6. Configure network

#### Method 2: Manual Install

Full manual installation guide:
```bash
# 1. Partition disk
cfdisk /dev/sda  # or your target disk

# 2. Format partitions
mkfs.ext4 /dev/sda2  # root
mkfs.fat -F32 /dev/sda1  # EFI (if UEFI)

# 3. Mount
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot  # if UEFI

# 4. Install base
pacstrap /mnt base linux linux-firmware

# 5. Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# 6. Chroot
arch-chroot /mnt

# 7. Configure system
# (set timezone, locale, hostname, etc.)

# 8. Install bootloader
# ... see Arch Wiki for details
```

---

## Post-Installation

### CRITICAL: Security Hardening

⚠️ **IMPORTANT**: The live ISO uses passwordless sudo. After installation to disk:

```bash
# Run the security hardening script
sudo /usr/local/bin/boraos-post-install-security.sh
```

**This script will**:
- Remove NOPASSWD sudo
- Enforce password requirements
- Optionally enable firewall

See [SECURITY.md](../SECURITY.md) for details.

### First Boot Steps

1. **Set passwords** (if not done during install):
```bash
passwd  # Your user password
sudo passwd root  # Root password (optional)
```

2. **Update system**:
```bash
sudo pacman -Syu
```

3. **Enable firewall** (recommended):
```bash
sudo pacman -S ufw
sudo systemctl enable --now ufw
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

4. **Configure locale** (if needed):
```bash
# For Turkish
sudo localectl set-locale LANG=tr_TR.UTF-8
sudo localectl set-keymap trq
```

---

## Customization

### Before Building

#### Modify Package List

Edit `packages.x86_64`:
```bash
nano packages.x86_64

# Add packages (must be in official repos):
chromium
libreoffice-fresh
gimp
```

#### Customize Desktop

Edit Hyprland config:
```bash
nano airootfs/root/.config/hypr/hyprland.conf

# Change keybindings, wallpaper, etc.
```

#### Add Your Files

Place files in `airootfs/`:
```bash
# Example: Add custom script
mkdir -p airootfs/usr/local/bin
echo '#!/bin/bash' > airootfs/usr/local/bin/myscript.sh
echo 'echo "Hello BoraOS!"' >> airootfs/usr/local/bin/myscript.sh
chmod +x airootfs/usr/local/bin/myscript.sh
```

### After Building

Can't modify ISO directly. Rebuild with changes.

---

## Troubleshooting

### Build Issues

#### "mkarchiso: command not found"
```bash
sudo pacman -S archiso
```

#### "Permission denied"
```bash
# Build script requires root
sudo ./build/build-x86.sh
```

#### "No space left on device"
```bash
# Clean package cache
sudo pacman -Sc

# Clean old builds
sudo rm -rf build/work build/out

# Check space
df -h
```

#### "Package not found: packagename"
```bash
# Verify package exists
pacman -Ss packagename

# Check if in AUR (not supported)
# If in AUR, must remove from packages.x86_64
```

### Boot Issues

#### ISO won't boot in VM
- Ensure KVM is enabled: `lsmod | grep kvm`
- Try without `-enable-kvm` flag
- Increase RAM: `-m 4096` or higher

#### USB won't boot on real hardware
- Verify secure boot is disabled
-  Check boot order in BIOS
- Try different USB port (USB 2.0 vs 3.0)
- Re-write USB with different tool (Etcher, Rufus)

### Runtime Issues

#### Black screen after boot
- Try "Safe Mode" boot option (nomodeset)
- Check graphics drivers

#### No network
```bash
# Check NetworkManager
systemctl status NetworkManager
systemctl start NetworkManager

# Connect to WiFi
nmtui
```

#### No sound
```bash
# Check PipeWire
systemctl --user status pipewire
systemctl --user start pipewire
```

---

## FAQ

**Q: How long does the build take?**  
A: 10-20 minutes depending on system speed and network.

**Q: Can I build on non-Arch Linux?**  
A: No. Requires x86_64 Arch Linux with archiso package.

**Q: Can I add AUR packages?**  
A: Not in standard build. Install AUR helper after installation.

**Q: ISO size?**  
A: Approximately 1.2 GB

**Q: License?**  
A: Packages retain their original licenses (mostly GPL/MIT).

**Q: Is it safe?**  
A: Based on official Arch Linux packages. Review code yourself.

**Q: Can I customize everything?**  
A: Yes! Edit files in `airootfs/` and `packages.x86_64` before building.

**Q: Do I need to rebuild for updates?**  
A: ISO is snapshot. Once installed, update with `pacman -Syu`.

**Q: Where can I get help?**  
A: Check GitHub issues: https://github.com/BGirginn/BoraOS

---

**Documentation**:
- Technical details: [BUILD_README.md](BUILD_README.md)
- Security guide: [../SECURITY.md](../SECURITY.md)
- Main README: [../README.md](../README.md)

**Last Updated**: 2025-12-04  
**Version**: 0.1  
**Architecture**: x86_64
