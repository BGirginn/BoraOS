# BoraOS 0.1 ARM64 - Reproducible Build System

## Overview

This directory contains the complete reproducible build pipeline for creating the BoraOS ARM64 ISO/Image. The build system supports two target platforms:

- **UEFI ARM64 systems** (Apple Silicon, ARM servers) → ISO output
- **Raspberry Pi 4/5** → Raw disk image output

---

## Build Scripts

### Master Build Script
- **build-arm.sh** - Main build orchestrator (run this)

### Individual Build Scripts (in build/scripts/)
1. **prepare_environment_arm.sh** - Verify ARM64 system and set up environment
2. **clean_previous_build.sh** - Remove previous build artifacts
3. **sync_profile_arm.sh** - Copy profile files with deterministic timestamps
4. **build_bootloader_arm.sh** - Configure bootloader (GRUB or U-Boot)
5. **build_image_arm.sh** - Build the ARM64 image/ISO
6. **finalize_arm.sh** - Rename and organize output files
7. **generate_checksums.sh** - Create SHA256 checksums

---

## Quick Start

### Prerequisites
- **ARM64 system** running Arch Linux ARM (aarch64)
- Root access
- Minimum 4GB RAM
- Minimum 10GB free disk space

### Install Required Tools
```bash
sudo pacman -S --needed archiso git base-devel squashfs-tools uboot-tools
```

### Build the ISO/Image

#### For UEFI ARM64 (default)
```bash
# Navigate to ARM64 directory
cd /path/to/BoraOS/boraos-aarch64

# Run the master build script
sudo ./build/build-arm.sh
```

#### For Raspberry Pi
```bash
# Set bootloader type to U-Boot
export BOOTLOADER_TYPE=uboot

# Run the build
sudo ./build/build-arm.sh
```

### Output
- **UEFI ISO**: `build/out/boraos-arm-0.1-aarch64.iso`
- **RPi Image**: `build/out/boraos-arm-0.1-aarch64.img`
- **Checksum**: `build/out/SHA256SUMS`
- **Logs**: `build/logs/`

---

## Platform-Specific Instructions

### Raspberry Pi 4/5

1. Build the image:
```bash
export BOOTLOADER_TYPE=uboot
sudo ./build/build-arm.sh
```

2. Write to SD card:
```bash
# Find SD card device
lsblk

# Write image (replace /dev/sdX with your SD card)
sudo dd if=build/out/boraos-arm-0.1-aarch64.img of=/dev/sdX bs=4M status=progress
sudo sync
```

3. Insert SD card and boot

### Apple Silicon Mac (with Asahi Linux)

1. Build the ISO:
```bash
# Default GRUB bootloader
sudo ./build/build-arm.sh
```

2. Use with UTM or Asahi installer

### ARM64 UEFI Systems

1. Build the ISO:
```bash
sudo ./build/build-arm.sh
```

2. Write to USB or use in VM

---

## Reproducibility

### Fixed Settings
All builds use these deterministic settings:

```bash
SOURCE_DATE_EPOCH=1704067200   # Jan 1, 2024 00:00 UTC
LANG=C
LC_ALL=C
TZ=UTC
UMASK=0022
```

### Deterministic Features
- ✅ Fixed timestamps on all files
- ✅ Sorted file ordering in squashfs
- ✅ Consistent compression settings (zstd level 15)
- ✅ Fixed umask (0022)
- ✅ Locale set to C
- ✅ Timezone set to UTC

### Verification
To verify reproducibility, build twice and compare:

```bash
# First build
sudo ./build/build-arm.sh
cp build/out/boraos-arm-0.1-aarch64.iso boraos-arm-build1.iso

# Clean and rebuild
sudo ./build/scripts/clean_previous_build.sh
sudo ./build/build-arm.sh
cp build/out/boraos-arm-0.1-aarch64.iso boraos-arm-build2.iso

# Compare
sha256sum boraos-arm-build1.iso boraos-arm-build2.iso
# Should produce identical checksums
```

---

## Directory Structure

```
boraos-aarch64/
├── build/
│   ├── build-arm.sh             # Master build script
│   ├── environment.sh           # Reproducibility variables (generated)
│   ├── scripts/
│   │   ├── prepare_environment_arm.sh
│   │   ├── clean_previous_build.sh
│   │   ├── sync_profile_arm.sh
│   │   ├── build_bootloader_arm.sh
│   │   ├── build_image_arm.sh
│   │   ├── finalize_arm.sh
│   │   └── generate_checksums.sh
│   ├── work/                    # Working directory (created during build)
│   ├── out/                     # Output directory (ISO/IMG location)
│   └── logs/                    # Build logs
├── profiledef.sh                # ArchISO ARM64 profile
├── pacman.conf                  # Pacman config (Arch Linux ARM repos)
├── packages.aarch64             # ARM64 package list
├── airootfs/                    # Root filesystem overlay
└── README.md                    # Platform-specific README
```

---

## Troubleshooting

### "Not running on ARM64 architecture"
- **Solution**: Build must run on ARM64 system (Raspberry Pi, Apple Silicon Linux, ARM VM)
- **Alternative**: You can continue anyway, but the build may fail

### "archiso is not installed"
- **Solution**: `sudo pacman -S archiso`

### "mkimage not found" (for Raspberry Pi builds)
- **Solution**: `sudo pacman -S uboot-tools`

### "Must be run as root"
- **Solution**: Use `sudo ./build/build-arm.sh`

### "Insufficient disk space"
- **Solution**: Free up at least 10GB of disk space

### Package not available
- Some x86_64 packages may not be available on ARM64
- Check `build/logs/mkarchiso_arm.log` for specific package errors
- Remove unavailable packages from `packages.aarch64`

---

## Testing the Output

### In UTM (Apple Silicon Mac)
```bash
# Create new ARM64 VM
# Mount the ISO
# Boot and test
```

### On Raspberry Pi
```bash
# Write image to SD card
sudo dd if=build/out/boraos-arm-0.1-aarch64.img of=/dev/sdX bs=4M status=progress
sudo sync

# Insert and boot
```

### In QEMU ARM64
```bash
qemu-system-aarch64 \
    -machine virt \
    -cpu cortex-a57 \
    -m 4096 \
    -cdrom build/out/boraos-arm-0.1-aarch64.iso \
    -boot d
```

---

## Clean Build

To perform a completely clean build:

```bash
# Remove all build artifacts
sudo ./build/scripts/clean_previous_build.sh

# Or manually
sudo rm -rf build/work build/out build/logs/*.log

# Then rebuild
sudo ./build/build-arm.sh
```

---

## Customization

To modify the ARM64 build:

1. **Change packages**: Edit `packages.aarch64`
   - Note: Some x86_64 packages are not available on ARM64
   - Check Arch Linux ARM package database

2. **Modify configuration**: Edit files in `airootfs/`
   - Same structure as x86_64 version

3. **Change bootloader**: Set `BOOTLOADER_TYPE`
   - `grub` (default) - for UEFI ARM64
   - `uboot` - for Raspberry Pi

4. **Update profile**: Edit `profiledef.sh`

After changes, run:
```bash
sudo ./build/build-arm.sh
```

---

## Differences from x86_64 Build

| Aspect | x86_64 | ARM64 |
|--------|--------|-------|
| Architecture | x86_64 | aarch64 |
| Kernel | linux | linux-aarch64 |
| Bootloader | systemd-boot + Syslinux | GRUB or U-Boot |
| Boot modes | UEFI + BIOS | UEFI only (or U-Boot) |
| GPU drivers | Intel, AMD | Mali, Videocore, etc. |
| Repositories | Arch Linux | Arch Linux ARM |

---

## Security

### Checksum Verification
Always verify the output before use:

```bash
cd build/out
sha256sum -c SHA256SUMS
```

Expected output:
```
boraos-arm-0.1-aarch64.iso: OK
# or
boraos-arm-0.1-aarch64.img: OK
```

---

## Support

For ARM64-specific build issues:
1. Check `build/logs/` for detailed error messages
2. Verify running on ARM64 system
3. Ensure all prerequisites are installed
4. Check available disk space and RAM
5. Verify package availability on Arch Linux ARM

---

**Version**: 0.1  
**Architecture**: aarch64 (ARM64)  
**Sprint**: 5  
**Status**: Experimental
