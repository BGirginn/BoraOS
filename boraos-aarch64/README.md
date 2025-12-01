# BoraOS 0.1 ARM64

**A modern Arch Linux ARM-based distribution featuring Hyprland Wayland compositor for ARM64 devices**

## Overview

BoraOS ARM64 is the ARM64 port of BoraOS, designed to run on ARM64 devices including Raspberry Pi 4/5, Apple Silicon Macs (with Asahi Linux), and other UEFI-capable ARM64 systems.

## Supported Platforms

- **Raspberry Pi 4/5** (with U-Boot)
- **Apple Silicon Macs** (M1/M2/M3 with Asahi Linux)
- **ARM64 UEFI systems** (servers, some SBCs)
- **UTM ARM64 VMs** (on Apple Silicon)

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

### Apple Silicon Mac (Asahi Linux)

1. Follow Asahi Linux installation guide first
2. Boot from BoraOS ARM64 ISO in UEFI mode
3. Install using standard archinstall or manual installation

### UTM ARM VM (Apple Silicon)

1. Create new ARM64 VM in UTM
2. Mount the ISO
3. Boot and install

## Differences from x86_64 Version

| Feature | x86_64 | ARM64 |
|---------|--------|-------|
| Bootloader | systemd-boot | GRUB (UEFI) or U-Boot (RPi) |
| Kernel | linux | linux-aarch64 |
| GPU Drivers | Intel/AMD | Mali/Videocore (device-specific) |
| Virtualization | KVM | Limited (no KVM on most ARM) |

## Known Limitations

- Some x86_64 packages may not be available on ARM64
- Performance characteristics differ from x86_64
- Raspberry Pi requires additional firmware packages
- Some hardware may require device-specific drivers

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
