# BoraOS 0.1 ARM64

**A modern Arch Linux ARM-based distribution featuring Hyprland Wayland compositor for ARM64 devices**

## Overview

BoraOS ARM64 is the ARM64 port of BoraOS, designed to run on ARM64 devices including Raspberry Pi 4/5, Apple Silicon Macs (with Asahi Linux), and other UEFI-capable ARM64 systems.

## Supported Platforms

### ✅ Fully Supported (2025)
- **Raspberry Pi 4/5** (with U-Boot)
- **ARM64 UEFI systems** (servers, some SBCs)
- **UTM ARM64 VMs** (on Apple Silicon - M1/M2/M3/M4)

### ⚠️ Limited/Experimental Support
- **Apple Silicon Macs (M1/M2)** - Bare-metal via Asahi Linux community repos
  - Requires additional Asahi packages (not included in standard build)
  - Recommend Fedora Asahi Remix for official support
- **Apple Silicon Macs (M3)** - Rudimentary support as of 2025
- **Apple Silicon Macs (M4)** - ❌ Not supported (no timeline)

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
- **Base**: Arch Linux ARM
- **Architecture**: aarch64 (ARM64)
- **Kernel**: linux-aarch64
- **Bootloader**: GRUB (UEFI ARM64) or U-Boot (Raspberry Pi)
- **Audio**: PipeWire + WirePlumber
- **Networking**: NetworkManager with nm-applet
- **Bluetooth**: Bluez (enabled)
- **Time Sync**: systemd-timesyncd (enabled)

## Building the ARM64 ISO

### Requirements
- ARM64 system running Arch Linux ARM
- `archiso` package installed (or equivalent ARM build tools)
- Root privileges
- Minimum 4GB RAM
- Minimum 10GB free disk space

### Build Instructions

1. On an ARM64 Arch Linux system:
```bash
cd /path/to/BoraOS/boraos-aarch64
sudo ./build/build-arm.sh
```

2. The resulting image will be in `build/out/`:
   - **UEFI systems**: `boraos-arm-0.1-aarch64.iso`
   - **Raspberry Pi**: `boraos-arm-0.1-aarch64.img`

## Installation

### Raspberry Pi 4/5

1. Write the image to SD card:
```bash
sudo dd if=boraos-arm-0.1-aarch64.img of=/dev/sdX bs=4M status=progress
sudo sync
```

2. Insert SD card and boot

### Apple Silicon Mac (Virtualization - Recommended)

**Best for M1/M2/M3/M4 Macs:**

1. Install UTM (free, open-source)
2. Create new ARM64 VM with Virtualize mode
3. Mount BoraOS ARM64 ISO
4. Boot and use (native ARM64 performance)

### Apple Silicon Mac (Bare-metal - Advanced)

**⚠️ Only for M1/M2 Macs with Asahi Linux experience:**

1. Install Asahi Linux first (follow asahilinux.org)
2. Add asahi-alarm community repos to pacman.conf
3. This standard build does **not** include Asahi-specific packages
4. **Not supported**: M3 (rudimentary), M4 (no support)

**Alternative**: Use Fedora Asahi Remix for official bare-metal support

## Differences from x86_64 Version

| Feature | x86_64 | ARM64 |
|---------|--------|-------|
| Bootloader | systemd-boot | GRUB (UEFI) or U-Boot (RPi) |
| Kernel | linux | linux-aarch64 |
| GPU Drivers | Intel/AMD | Mali/Videocore (device-specific) |
| Virtualization | KVM | Limited (no KVM on most ARM) |

## Known Limitations (2025)

### General
- Some x86_64 packages may not be available on ARM64
- Performance characteristics differ from x86_64
- Raspberry Pi requires additional firmware packages
- Some hardware may require device-specific drivers

### Apple Silicon Specific
- **M4 Macs**: Not supported (Asahi Linux has no M4 timeline)
- **M3 Macs**: Rudimentary bare-metal support only
- **M1/M2 Bare-metal**: Requires Asahi community repos (asahi-alarm)
- **Official Asahi**: Now focuses on Fedora, not Arch Linux ARM
- **Recommendation**: Use UTM virtualization for all M-series Macs

## Default Keybindings

Same as BoraOS x86_64 version (see main README.md)

## Support

This is an experimental ARM64 port. For best results:
- Use on officially supported platforms (Raspberry Pi 4/5, Apple Silicon)
- Test thoroughly before production use
- Report ARM-specific issues separately from x86_64 issues

---

**Version**: 0.1  
**Architecture**: aarch64 (ARM64)  
**Status**: Experimental

**Built with ❤️ using Arch Linux ARM**
