# BoraOS 0.1 x86_64

**A modern Arch Linux-based distribution featuring Hyprland Wayland compositor for x86_64 systems**

## Overview

BoraOS x86_64 is a sleek, modern Linux distribution built on Arch Linux, featuring the Hyprland tiling Wayland compositor. Designed for performance and aesthetics on Intel/AMD 64-bit systems.

## Supported Platforms

- **Desktop PCs** (Intel/AMD 64-bit processors)
- **Laptops** (Intel/AMD processors)
- **Virtual Machines** (QEMU, VirtualBox, VMware, UTM with emulation)
- **UEFI and Legacy BIOS** systems

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
- **Base**: Arch Linux
- **Architecture**: x86_64 (Intel/AMD 64-bit)
- **Kernel**: linux
- **Bootloader**: systemd-boot (UEFI), Syslinux (BIOS), GRUB (both)
- **Audio**: PipeWire + WirePlumber
- **Networking**: NetworkManager with nm-applet
- **Bluetooth**: Bluez (enabled)
- **Time Sync**: systemd-timesyncd (enabled)

## Building the x86_64 ISO

### Requirements
- x86_64 system running Arch Linux
- `archiso` package installed
- Root privileges
- Minimum 4GB RAM
- Minimum 10GB free disk space

### Build Instructions

1. On an x86_64 Arch Linux system:
```bash
cd /path/to/BoraOS/Bora_OS_x86
sudo ./build/build-x86.sh
```

2. The resulting ISO will be in `build/out/boraos-0.1-x86_64.iso`

## Installation

### Physical Hardware

1. Write ISO to USB:
```bash
sudo dd if=boraos-0.1-x86_64.iso of=/dev/sdX bs=4M status=progress
sudo sync
```

2. Boot from USB and install using `archinstall` or manually

### Virtual Machine (Recommended for Testing)

**UTM (Mac)**:
- Create new x86_64 VM with **emulation mode** (on Apple Silicon)
- Mount the ISO
- Boot and test

**VirtualBox/QEMU/VMware**:
- Create new VM with x86_64 architecture
- Allocate 4GB+ RAM and 20GB+ disk
- Mount ISO and boot

## Boot Modes

| Mode | Description | Requirements |
|------|-------------|--------------|
| UEFI + systemd-boot | Modern UEFI systems | UEFI firmware |
| UEFI + GRUB | Alternative UEFI boot | UEFI firmware |
| BIOS + Syslinux | Legacy BIOS systems | Legacy BIOS |

## Default Credentials

- **Live User**: `liveuser` (passwordless sudo)
- **Root**: No password (live environment)

## Default Keybindings

| Key Combination | Action |
|-----------------|--------|
| `Super + Return` | Open terminal (Alacritty) |
| `Super + D` | Application launcher (Rofi) |
| `Super + Q` | Close window |
| `Super + [1-9]` | Switch workspace |

See `/etc/hyprland/hyprland.conf` for full keybindings.

## Architecture Comparison

| Feature | x86_64 | ARM64 |
|---------|--------|-------|
| Bootloader | systemd-boot/Syslinux/GRUB | GRUB/U-Boot |
| Kernel | linux | linux-aarch64 |
| Target Devices | PCs, Laptops, VMs | RPi, Apple Silicon, ARM servers |

## Support

For issues specific to x86_64 builds, please check:
- Build logs: `build/logs/`
- Main project README: `../README.md`

---

**Version**: 0.1  
**Architecture**: x86_64 (Intel/AMD 64-bit)  
**Status**: Stable

**Built with ❤️ using Arch Linux**
