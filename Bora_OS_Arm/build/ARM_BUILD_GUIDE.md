# BoraOS ARM64 (aarch64) Build Guide

Complete guide for building the BoraOS ARM64 Live/Installation ISO.

## Prerequisites

### Required Environment
- **Architecture**: aarch64 (ARM64)
- **Recommended**: UTM on Apple Silicon Mac with Arch Linux ARM
- **Cannot be built on**: x86_64 systems

### Setting Up UTM ARM Arch Linux

1. **Download UTM**: https://mac.getutm.app/
2. **Download Arch Linux ARM Generic UEFI Image**:
   - Visit: https://archlinuxarm.org/platforms/armv8/generic
   - Download the latest generic UEFI image
3. **Create UTM VM**:
   - New VM → Virtualize → Linux
   - RAM: 4GB minimum (8GB recommended)
   - Storage: 20GB minimum
   - Boot: UEFI
4. **Install Arch Linux ARM** following standard installation
5. **Install archiso**:
   ```bash
   sudo pacman -S archiso
   ```

## Quick Start

### Option 1: Unified Build Script (Recommended)
```bash
cd /path/to/BoraOS
sudo ./build.sh --arch=aarch64
```

### Option 2: Direct ARM Build
```bash
cd /path/to/BoraOS/Bora_OS_Arm
sudo ./build/build-arm.sh
```

## Build Process

The build executes these steps in order:

1. **Prepare Environment** - Install archiso and dependencies
2. **Clean Previous Build** - Remove old work files
3. **Sync Profile** - Verify all profile files exist
4. **Build Bootloader** - Configure systemd-boot for ARM
5. **Build Image** - Run mkarchiso
6. **Finalize Output** - Rename and organize output
7. **Generate Checksums** - Create SHA256SUMS

## Output Files

After successful build:
```
build/out/
├── boraos-0.1-aarch64.iso   # ARM64 bootable ISO
└── SHA256SUMS               # Verification checksums
```

## Verification

```bash
cd build/out
sha256sum -c SHA256SUMS
```

## Testing

### UTM (Primary)
1. Create new VM in UTM
2. Select "Virtualize" → "Linux"
3. Boot from ISO: Select `boraos-0.1-aarch64.iso`
4. Choose UEFI boot
5. Verify Hyprland desktop loads

### QEMU (Alternative)
```bash
qemu-system-aarch64 \
  -M virt \
  -cpu cortex-a72 \
  -m 4G \
  -bios /usr/share/edk2-armvirt/aarch64/QEMU_EFI.fd \
  -cdrom build/out/boraos-0.1-aarch64.iso \
  -boot d \
  -device virtio-gpu-pci \
  -display gtk
```

## Troubleshooting

### Package Not Found
If packages fail to install, verify Arch Linux ARM mirrors:
```bash
# Check mirror connectivity
curl -I http://mirror.archlinuxarm.org/aarch64/core/
```

### Keyring Issues
```bash
pacman-key --init
pacman-key --populate archlinuxarm
```

### Build Failures
Check logs in `build/logs/` for detailed error messages.

## Architecture Notes

### Differences from x86_64 Build
- Uses `linux-aarch64` kernel instead of `linux`
- No `syslinux` (BIOS boot) - ARM uses UEFI only
- No `memtest86+` - not available for ARM
- No `vulkan-intel` or `vulkan-radeon` - x86 GPU drivers
- Uses systemd-boot as primary bootloader (GRUB optional)

### Bootloader
Primary: **systemd-boot** (best UTM/QEMU compatibility)
Optional: GRUB for specific ARM UEFI devices

## Links

- Arch Linux ARM: https://archlinuxarm.org/
- UTM: https://mac.getutm.app/
- BoraOS Project: https://github.com/BGirginn/BoraOS
