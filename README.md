# BoraOS 0.1 - x86_64

**A modern Arch Linux distribution featuring Hyprland Wayland compositor**

## Overview

BoraOS is a minimal, modern Linux distribution built on Arch Linux using the ArchISO build system. It features the Hyprland Wayland compositor with a curated selection of modern applications and tools for **x86_64 systems**.

---

## Features

### Desktop Environment
- **Compositor**: Hyprland (modern tiling Wayland compositor)
- **Display Manager**: SDDM with auto-login for live mode
- **Panel**: Waybar with system information
- **Wallpaper Manager**: hyprpaper with modern wallpapers
- **Application Launcher**: rofi-wayland

### Core Applications
- **Browser**: Firefox
- **Terminal**: Alacritty (GPU-accelerated)
- **File Manager**: Yazi (modern TUI)
- **System Monitor**: btop, htop
- **Utilities**: fastfetch, git, curl, wget

### System Configuration
- **Base**: Arch Linux (x86_64)
- **Kernel**: Linux
- **Build System**: ArchISO with automated scripts
- **Filesystem**: squashfs (zstd compression)
- **Audio**: PipeWire + WirePlumber
- **Network**: NetworkManager
- **Bluetooth**: Bluez
- **Packages**: 129 packages (all from official repositories)

### Bootloaders
- **UEFI**: systemd-boot or GRUB
- **BIOS**: Syslinux
- Multi-boot support out of the box

---

## Quick Start

```bash
# 1. Clone repository
git clone https://github.com/BGirginn/BoraOS.git
cd BoraOS/Bora_OS_x86

# 2. Build ISO (requires Arch Linux x86_64)
sudo ./build/build-x86.sh

# 3. Find your ISO
ls -lh build/out/boraos-0.1-x86_64.iso
```

**Output**: `Bora_OS_x86/build/out/boraos-0.1-x86_64.iso` (~1.2 GB)

---

## Requirements

### Build System
- Operating System: Arch Linux x86_64
- Package: `archiso`
- CPU: 2+ cores (4+ recommended)
- RAM: 4GB minimum (8GB recommended)
- Disk: 10GB free minimum
- Network: Active internet connection

### Target System
- Architecture: x86_64 (Intel/AMD)
- RAM: 2GB minimum (4GB+ recommended)
- Disk: 20GB+ for installation
- Boot: UEFI or Legacy BIOS

---

## Building

### Install Dependencies

```bash
sudo pacman -Syu
sudo pacman -S archiso
```

### Build Process

```bash
cd Bora_OS_x86
sudo ./build/build-x86.sh
```

The build takes approximately 10-20 minutes and produces:
- `build/out/boraos-0.1-x86_64.iso` - Bootable ISO
- `build/out/boraos-0.1-x86_64.iso.sha256` - Checksum
- `build/logs/` - Build logs

---

## Testing

### QEMU (Recommended)

```bash
# UEFI boot
qemu-system-x86_64 -enable-kvm -m 4096 \
  -cdrom Bora_OS_x86/build/out/boraos-0.1-x86_64.iso -boot d

# BIOS boot
qemu-system-x86_64 -enable-kvm -m 4096 -bios /usr/share/qemu/bios.bin \
  -cdrom Bora_OS_x86/build/out/boraos-0.1-x86_64.iso -boot d
```

### USB Drive

⚠️ **WARNING**: This will erase the USB drive!

```bash
# Write ISO to USB
sudo dd if=Bora_OS_x86/build/out/boraos-0.1-x86_64.iso \
        of=/dev/sdX bs=4M status=progress conv=fsync
sudo sync
```

---

## Installation

### Guided Installation

Boot the ISO and run:
```bash
sudo archinstall
```

Follow the prompts for automated installation.

### Manual Installation

See full manual installation guide in [Bora_OS_x86/build/X86_BUILD_GUIDE.md](Bora_OS_x86/build/X86_BUILD_GUIDE.md)

### ⚠️ Post-Installation Security

**CRITICAL**: Run security hardening after installation:

```bash
sudo /usr/local/bin/boraos-post-install-security.sh
```

This removes passwordless sudo and hardens the system.
See [Bora_OS_x86/SECURITY.md](Bora_OS_x86/SECURITY.md) for details.

---

## Customization

### Package List

Edit `Bora_OS_x86/packages.x86_64`:
```bash
nano Bora_OS_x86/packages.x86_64
# Add packages (must be in official repos - core/extra)
# Rebuild ISO to apply changes
```

### Desktop Configuration

- **Hyprland**: `Bora_OS_x86/airootfs/root/.config/hypr/hyprland.conf`
- **Waybar**: `Bora_OS_x86/airootfs/root/.config/waybar/`
- **Alacritty**: `Bora_OS_x86/airootfs/root/.config/alacritty/alacritty.toml`

### System Files

Add custom files to `Bora_OS_x86/airootfs/`:
```bash
# Example: Add custom script
mkdir -p Bora_OS_x86/airootfs/usr/local/bin
echo '#!/bin/bash' > Bora_OS_x86/airootfs/usr/local/bin/myscript.sh
chmod +x Bora_OS_x86/airootfs/usr/local/bin/myscript.sh
```

---

## Default Keybindings

| Key Combination | Action |
|-----------------|--------|
| `SUPER + RETURN` | Open terminal (Alacritty) |
| `SUPER + D` | Application launcher (Rofi) |
| `SUPER + E` | File manager (Yazi) |
| `SUPER + Q` | Close window |
| `SUPER + SHIFT + Q` | Exit Hyprland |
| `SUPER + F` | Fullscreen |
| `SUPER + V` | Toggle floating |
| `SUPER + [1-9]` | Switch workspace |
| `SUPER + SHIFT + [1-9]` | Move window to workspace |
| `SUPER + h/j/k/l` | Move focus (vim keys) |

---

## Documentation

- **Build Guide**: [Bora_OS_x86/build/X86_BUILD_GUIDE.md](Bora_OS_x86/build/X86_BUILD_GUIDE.md)
- **Technical**: [Bora_OS_x86/build/BUILD_README.md](Bora_OS_x86/build/BUILD_README.md)
- **Security**: [Bora_OS_x86/SECURITY.md](Bora_OS_x86/SECURITY.md)
- **User Guide**: [Bora_OS_x86/README.md](Bora_OS_x86/README.md)

---

## Troubleshooting

### Build Errors

**"mkarchiso: command not found"**
```bash
sudo pacman -S archiso
```

**"Package not found"**
- Verify package exists in official repos
- No AUR packages allowed in standard builds
- Edit `packages.x86_64` to remove or replace

**"No space left"**
```bash
sudo pacman -Sc  # Clean cache
sudo rm -rf Bora_OS_x86/build/work  # Clean build artifacts
```

### Boot Issues

**ISO won't boot**
- Check BIOS/UEFI settings
- Disable Secure Boot
- Try different boot mode (UEFI/BIOS)

**Black screen**
- Use "Safe Mode" boot option
- Try `nomodeset` kernel parameter

More troubleshooting: [Bora_OS_x86/build/X86_BUILD_GUIDE.md](Bora_OS_x86/build/X86_BUILD_GUIDE.md#troubleshooting)

---

## Project Structure

```
BoraOS/
├── README.md               # This file
├── Bora_OS_x86/           # Complete x86_64 build system
│   ├── README.md          # User guide
│   ├── SECURITY.md        # Security documentation
│   ├── packages.x86_64    # Package list (129 packages)
│   ├── pacman.conf        # Repository configuration
│   ├── profiledef.sh      # ArchISO profile
│   ├── build/
│   │   ├── build-x86.sh          # Main build script
│   │   ├── BUILD_README.md       # Technical docs
│   │   ├── X86_BUILD_GUIDE.md    # User build guide
│   │   └── scripts/ (7 scripts)  # Build pipeline
│   ├── airootfs/          # Root filesystem overlay
│   ├── efiboot/           # systemd-boot config
│   ├── syslinux/          # BIOS boot config
│   └── grub/              # GRUB config
└── issues.md              # Known issues
```

---

## FAQ

**Q: Can I build on non-Arch Linux?**  
A: No. Requires x86_64 Arch Linux with `archiso` package.

**Q: Can I add AUR packages?**  
A: Not in standard build. Install AUR helper after system installation.

**Q: How do I update the live ISO?**  
A: Rebuild with updated packages. Once installed, use `pacman -Syu`.

**Q: Is this production-ready?**  
A: Yes for x86_64. Fully tested on Intel/AMD systems.

**Q: What about ARM support?**  
A: x86_64 only. No ARM support in this version.

---

## License

BoraOS inherits licenses from its components. Base Arch Linux packages are distributed under various open-source licenses. See individual package licenses for details.

---

## Contributing

Contributions welcome! Areas:
- Package suggestions
- Bug reports and fixes
- Documentation improvements
- Custom themes

---

**Version**: 0.1  
**Architecture**: x86_64 only  
**Status**: Production-ready  
**Last Updated**: 2025-12-04

**Built with ❤️ using Arch Linux and ArchISO**
