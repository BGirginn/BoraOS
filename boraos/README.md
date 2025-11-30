# BoraOS 0.1

**A modern ArchISO-based Linux distribution featuring Hyprland Wayland compositor**

## Overview

BoraOS is a minimal, modern Linux distribution built on Arch Linux using the ArchISO build system. It features the Hyprland Wayland compositor with a curated selection of modern applications and tools.

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
- **Build System**: ArchISO
- **Filesystem**: squashfs with zstd compression (level 15)
- **Kernel**: Linux
- **Audio**: PipeWire + WirePlumber
- **Networking**: NetworkManager with nm-applet
- **Bluetooth**: Bluez (enabled)
- **Time Sync**: systemd-timesyncd (enabled)

### Security
- Sudo requires user password (no NOPASSWD)
- Secure default permissions on shadow/gshadow files
- No SSH server in live mode
- No Avahi service

### Localization
- Default locale: en_US.UTF-8
- Additional locale: tr_TR.UTF-8
- Default keyboard: Turkish (tr)
- Keyboard layout selectable during installation

## Building the ISO

### Requirements
- Arch Linux or Arch-based system
- `archiso` package installed
- Root privileges

### Build Instructions

1. Install required packages:
```bash
sudo pacman -S archiso
```

2. Build the ISO:
```bash
sudo mkarchiso -v -w /tmp/archiso-tmp boraos/
```

3. The resulting ISO will be in `out/` directory:
```bash
ls out/
```

### Customization

- **Packages**: Edit `packages.x86_64` to add/remove packages
- **Hyprland Config**: Modify `airootfs/root/.config/hypr/hyprland.conf`
- **Waybar Config**: Modify `airootfs/root/.config/waybar/config` and `style.css`
- **System Settings**: Edit files in `airootfs/etc/`

## Live Boot Behavior

- Auto-login to Hyprland desktop
- User: `root` (no password in live mode)
- All system services configured and running
- Bluetooth enabled
- NetworkManager ready for WiFi configuration

## Post-Installation

After installing to disk:
- Manual login required (no auto-login)
- Create user accounts with appropriate privileges
- Configure timezone and locale preferences
- Set up user-specific configurations
- Install additional packages as needed

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
- `SUPER + CTRL + arrows`: Resize windows

### Media Keys
- Volume up/down/mute
- Brightness up/down
- Print screen (screenshot)

## File Structure

```
boraos/
├── profiledef.sh          # ArchISO profile definition
├── pacman.conf            # Pacman configuration
├── packages.x86_64        # Package list
├── airootfs/              # Root filesystem overlay
│   ├── etc/               # System configurations
│   ├── usr/               # User programs and data
│   └── root/              # Root user home with configs
└── README.md              # This file
```

## Additional Information

- **Version**: 0.1
- **Architecture**: x86_64
- **Boot Modes**: BIOS (Syslinux) and UEFI (systemd-boot)
- **Multilib**: Disabled
- **Compression**: zstd level 15

## Support

For issues, questions, or contributions, please visit the BoraOS project repository.

## License

BoraOS inherits licenses from its components. The base Arch Linux system is distributed under various open-source licenses. Please refer to individual package licenses for details.

---

**Built with ❤️ using ArchISO**
