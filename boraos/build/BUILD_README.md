# BoraOS 0.1 - Reproducible ISO Build System

## Overview

This directory contains the complete reproducible build pipeline for creating the BoraOS ISO. All scripts use deterministic settings to ensure identical builds.

---

## Build Scripts

### Master Build Script
- **build.sh** - Main build orchestrator (run this)

### Individual Build Scripts (in build/scripts/)
1. **prepare_environment.sh** - Verify system and set up environment
2. **clean_previous_build.sh** - Remove previous build artifacts
3. **sync_profile.sh** - Copy profile files with deterministic timestamps
4. **build_squashfs.sh** - Create reproducible squashfs filesystem
5. **mkarchiso_build.sh** - Run the main ArchISO build
6. **finalize_iso.sh** - Rename and timestamp the ISO
7. **generate_checksums.sh** - Create SHA256 checksums

---

## Quick Start

### Prerequisites
- Arch Linux system (VM or bare metal)
- Root access
- Minimum 4GB RAM
- Minimum 10GB free disk space

### Install Required Tools
```bash
sudo pacman -S --needed archiso git base-devel squashfs-tools fakeroot
```

### Build the ISO
```bash
# Clone or navigate to BoraOS directory
cd /path/to/BoraOS/boraos

# Run the master build script
sudo ./build/build.sh
```

The script will:
1. Verify environment
2. Clean previous builds
3. Sync profile files
4. Build squashfs
5. Run mkarchiso
6. Finalize ISO
7. Generate checksums

### Output
- **ISO**: `build/out/boraos-0.1-x86_64.iso`
- **Checksum**: `build/out/SHA256SUMS`
- **Logs**: `build/logs/`

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
- ✅ Consistent compression settings (zstd level 6)
- ✅ Fixed umask (0022)
- ✅ Locale set to C
- ✅ Timezone set to UTC

### Verification
To verify reproducibility, build twice and compare:

```bash
# First build
sudo ./build/build.sh
cp build/out/boraos-0.1-x86_64.iso boraos-build1.iso

# Clean and rebuild
sudo ./build/scripts/clean_previous_build.sh
sudo ./build/build.sh
cp build/out/boraos-0.1-x86_64.iso boraos-build2.iso

# Compare
sha256sum boraos-build1.iso boraos-build2.iso
# Should produce identical checksums
```

---

## Directory Structure

```
boraos/
├── build/
│   ├── build.sh                 # Master build script
│   ├── environment.sh           # Reproducibility variables (generated)
│   ├── scripts/
│   │   ├── prepare_environment.sh
│   │   ├── clean_previous_build.sh
│   │   ├── sync_profile.sh
│   │   ├── build_squashfs.sh
│   │   ├── mkarchiso_build.sh
│   │   ├── finalize_iso.sh
│   │   └── generate_checksums.sh
│   ├── work/                    # Working directory (created during build)
│   ├── out/                     # Output directory (ISO location)
│   └── logs/                    # Build logs
├── profiledef.sh                # ArchISO profile
├── pacman.conf                  # Package manager config
├── packages.x86_64              # Package list
├── airootfs/                    # Root filesystem overlay
└── [other files]
```

---

## Individual Script Usage

While the master `build.sh` script is recommended, you can run individual scripts:

```bash
# 1. Prepare environment
sudo ./build/scripts/prepare_environment.sh

# 2. Clean previous build
sudo ./build/scripts/clean_previous_build.sh

# 3. Sync profile
sudo ./build/scripts/sync_profile.sh

# 4. Build squashfs
sudo ./build/scripts/build_squashfs.sh

# 5. Run mkarchiso
sudo ./build/scripts/mkarchiso_build.sh

# 6. Finalize ISO
sudo ./build/scripts/finalize_iso.sh

# 7. Generate checksums
sudo ./build/scripts/generate_checksums.sh
```

---

## Environment Variables

The build system uses these environment variables (set automatically):

| Variable | Value | Purpose |
|----------|-------|---------|
| SOURCE_DATE_EPOCH | 1704067200 | Fixed timestamp (Jan 1, 2024) |
| LANG | C | Deterministic locale |
| LC_ALL | C | Deterministic locale (all categories) |
| TZ | UTC | Fixed timezone |
| UMASK | 0022 | Consistent file permissions |

---

## Build Logs

All build operations are logged to `build/logs/`:

- `squashfs.log` - SquashFS build output
- `mkarchiso.log` - Main ArchISO build output

Check these logs if builds fail.

---

## Troubleshooting

### "Not running on Arch Linux"
- Solution: Build must run on Arch Linux (VM or bare metal)

### "archiso is not installed"
- Solution: `sudo pacman -S archiso`

### "Must be run as root"
- Solution: Use `sudo ./build/build.sh`

### "Insufficient disk space"
- Solution: Free up at least 10GB of disk space

### "Insufficient RAM"
- Solution: System needs at least 4GB RAM

### Build fails during mkarchiso
- Check `build/logs/mkarchiso.log` for detailed errors
- Verify all profile files are present
- Ensure network connectivity (for downloading packages)

---

## Testing the ISO

### In a VM (Recommended for testing)
```bash
# Using QEMU
qemu-system-x86_64 \
    -enable-kvm \
    -m 4096 \
    -cdrom build/out/boraos-0.1-x86_64.iso \
    -boot d
```

### Write to USB Drive
```bash
# Find USB device (be careful!)
lsblk

# Write ISO (replace /dev/sdX with your USB device)
sudo dd if=build/out/boraos-0.1-x86_64.iso of=/dev/sdX bs=4M status=progress
sudo sync
```

---

## Clean Build

To perform a completely clean build:

```bash
# Remove all build artifacts
sudo ./build/scripts/clean_previous_build.sh

# Or manually
sudo rm -rf build/work build/out build/logs/*

# Then rebuild
sudo ./build/build.sh
```

---

## Customization

To modify the build:

1. **Change packages**: Edit `packages.x86_64`
2. **Modify configuration**: Edit files in `airootfs/`
3. **Change compression**: Edit `build_squashfs.sh` (zstd level)
4. **Update profile**: Edit `profiledef.sh`

After changes, run:
```bash
sudo ./build/build.sh
```

---

## Security

### Checksum Verification
Always verify the ISO before use:

```bash
cd build/out
sha256sum -c SHA256SUMS
```

Expected output:
```
boraos-0.1-x86_64.iso: OK
```

---

## Support

For build issues:
1. Check `build/logs/` for detailed error messages
2. Verify all prerequisites are installed
3. Ensure running on Arch Linux with root access
4. Check available disk space and RAM

---

**Version**: 0.1  
**Sprint**: 4  
**Status**: Production-Ready
