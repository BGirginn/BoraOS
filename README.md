# BoraOS 0.1

**A modern ArchISO-based Linux distribution featuring Hyprland Wayland compositor**

## Overview

BoraOS is a minimal, modern Linux distribution built on Arch Linux using the ArchISO build system. It features the Hyprland Wayland compositor with a curated selection of modern applications and tools.

**Now available for both x86_64 and ARM64 architectures!**

---

## Architectures

### x86_64 (Intel/AMD)
- **Directory**: `boraos/`
- **Bootloader**: systemd-boot (UEFI) + Syslinux (BIOS)
- **Status**: Production-ready
- **Platforms**: Standard PCs, laptops, servers

### ARM64 (aarch64)
- **Directory**: `boraos-aarch64/`
- **Bootloader**: GRUB (UEFI ARM64) or U-Boot (Raspberry Pi)
- **Status**: Experimental
- **Platforms**: Raspberry Pi 4/5, Apple Silicon, ARM servers

---

## Quick Start

### x86_64 Build
```bash
cd boraos
sudo ./build/build.sh
```

**Output**: `boraos/build/out/boraos-0.1-x86_64.iso`

### ARM64 Build
```bash
cd boraos-aarch64
sudo ./build/build-arm.sh
```

**Output**: 
- UEFI: `boraos-aarch64/build/out/boraos-arm-0.1-aarch64.iso`
- Raspberry Pi: `boraos-aarch64/build/out/boraos-arm-0.1-aarch64.img`

---

## Features

### Desktop Environment
- **Compositor**: Hyprland (modern tiling Wayland compositor)
- **Display Manager**: SDDM with auto-login for live mode
- **Panel**: Waybar (medium profile with system information)
- **Wallpaper Manager**: hyprpaper with abstract modern wallpapers
- **Application Launcher**: rofi-wayland

### Core Applications
- **Terminal**: Alacritty (GPU-accelerated terminal emulator)
- **File Manager**: Yazi (modern terminal file manager)
- **System Monitor**: btop
- **Audio Control**: pavucontrol

### System Configuration
- **Base**: Arch Linux / Arch Linux ARM
- **Build System**: ArchISO with custom build scripts
- **Filesystem**: squashfs with zstd compression (level 15)
- **Audio**: PipeWire + WirePlumber
- **Networking**: NetworkManager with nm-applet
- **Bluetooth**: Bluez (enabled)
- **Time Sync**: systemd-timesyncd (enabled)

---

## Directory Structure

```
BoraOS/
├── README.md                      # This file
├── SPRINT5_ARM_IMPLEMENTATION_PLAN.md
├── boraos/                        # x86_64 build (production)
│   ├── README.md
│   ├── build/
│   │   ├── build.sh               # x86_64 build script
│   │   ├── BUILD_README.md
│   │   └── scripts/
│   ├── profiledef.sh
│   ├── pacman.conf
│   ├── packages.x86_64
│   └── airootfs/
└── boraos-aarch64/                # ARM64 build (experimental)
    ├── README.md
    ├── build/
    │   ├── build-arm.sh           # ARM64 build script
    │   ├── BUILD_README.md
    │   └── scripts/
    ├── profiledef.sh
    ├── pacman.conf
    ├── packages.aarch64
    └── airootfs/
```

---

## Prerequisites

### For x86_64 Build
- Arch Linux x86_64 system
- `archiso` package
- Root access
- 4GB RAM minimum
- 10GB free disk space

### For ARM64 Build
- Arch Linux ARM (aarch64) system
- `archiso` and `uboot-tools` packages
- Root access
- 4GB RAM minimum
- 10GB free disk space

---

## Building

### x86_64 ISO

1. Install dependencies:
```bash
sudo pacman -S archiso
```

2. Build:
```bash
cd boraos
sudo ./build/build.sh
```

3. Output: `boraos/build/out/boraos-0.1-x86_64.iso`

### ARM64 ISO/Image

1. Install dependencies:
```bash
sudo pacman -S archiso uboot-tools
```

2. Build (UEFI ARM64):
```bash
cd boraos-aarch64
sudo ./build/build-arm.sh
```

3. Build (Raspberry Pi):
```bash
cd boraos-aarch64
export BOOTLOADER_TYPE=uboot
sudo ./build/build-arm.sh
```

4. Output:
   - UEFI: `boraos-aarch64/build/out/boraos-arm-0.1-aarch64.iso`
   - RPi: `boraos-aarch64/build/out/boraos-arm-0.1-aarch64.img`

---

## Testing

### x86_64
```bash
# In QEMU
qemu-system-x86_64 -enable-kvm -m 4096 -cdrom boraos/build/out/boraos-0.1-x86_64.iso -boot d

# Write to USB
sudo dd if=boraos/build/out/boraos-0.1-x86_64.iso of=/dev/sdX bs=4M status=progress
```

### ARM64 (UEFI)
```bash
# In UTM (Apple Silicon) or QEMU
# Create ARM64 VM and mount ISO

# Write to USB
sudo dd if=boraos-aarch64/build/out/boraos-arm-0.1-aarch64.iso of=/dev/sdX bs=4M status=progress
```

### ARM64 (Raspberry Pi)
```bash
# Write to SD card
sudo dd if=boraos-aarch64/build/out/boraos-arm-0.1-aarch64.img of=/dev/sdX bs=4M status=progress
sudo sync
```

---

## Default Keybindings

### Hyprland
- `SUPER + RETURN`: Launch Alacritty terminal
- `SUPER + D`: Launch rofi application launcher
- `SUPER + E`: Launch Yazi file manager
- `SUPER + Q`: Close active window
- `SUPER + SHIFT + Q`: Exit Hyprland
- `SUPER + V`: Toggle floating mode
- `SUPER + F`: Fullscreen
- `SUPER + [1-9]`: Switch to workspace
- `SUPER + SHIFT + [1-9]`: Move window to workspace
- `SUPER + h/j/k/l`: Move focus (vim keys)
- `SUPER + SHIFT + h/j/k/l`: Move windows

---

## Customization

### x86_64
- **Packages**: Edit `boraos/packages.x86_64`
- **Hyprland**: Edit `boraos/airootfs/root/.config/hypr/hyprland.conf`
- **System**: Edit files in `boraos/airootfs/etc/`

### ARM64
- **Packages**: Edit `boraos-aarch64/packages.aarch64`
  - Note: Some x86_64 packages may not be available
- **Hyprland**: Edit `boraos-aarch64/airootfs/root/.config/hypr/hyprland.conf`
- **System**: Edit files in `boraos-aarch64/airootfs/etc/`

---

## Architecture Comparison

| Feature | x86_64 | ARM64 |
|---------|--------|-------|
| Kernel | linux | linux-aarch64 |
| Bootloader | systemd-boot + Syslinux | GRUB or U-Boot |
| Boot Modes | UEFI + BIOS | UEFI only (or U-Boot) |
| GPU Drivers | Intel, AMD (Vulkan) | Device-specific |
| Status | Production | Experimental |
| Build Time | ~10-15 min | ~15-20 min |

---

## Documentation

- **x86_64 Build**: See `boraos/build/BUILD_README.md`
- **ARM64 Build**: See `boraos-aarch64/build/BUILD_README.md`
- **x86_64 Usage**: See `boraos/README.md`
- **ARM64 Usage**: See `boraos-aarch64/README.md`

---

## Support

### x86_64
- Fully tested and production-ready
- Standard Arch Linux packages
- Community support available

### ARM64
- Experimental status
- Some packages may be unavailable
- Platform-specific issues possible
- Best effort support

---

## License

BoraOS inherits licenses from its components. The base Arch Linux system is distributed under various open-source licenses. Please refer to individual package licenses for details.

---

**Version**: 0.1  
**Sprint**: 5 (ARM64 support added)  
**Status**: 
- x86_64: Production-ready
- ARM64: Experimental

**Built with ❤️ using ArchISO**
