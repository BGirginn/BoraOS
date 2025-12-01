# BoraOS Sprint 5: ARM64 Architecture Support - Implementation Plan

## Overview

This sprint adds ARM64 (aarch64) architecture support to BoraOS, enabling it to run natively on Apple Silicon Macs, Raspberry Pi 4/5, and other ARM64 devices, while maintaining existing x86_64 support.

---

## User Review Required

> [!WARNING]
> **Breaking Changes & Scope Expansion**
> 
> Adding ARM64 support significantly expands the project:
> - **Build complexity**: Separate build systems for each architecture
> - **Maintenance burden**: 2x testing, 2x bug fixing, 2x updates
> - **Time investment**: Estimated 2-3 weeks for initial implementation
> - **ArchISO limitation**: x86_64 ArchISO cannot be used for ARM; requires Arch Linux ARM custom build system
> 
> **Key Decisions Needed:**
> 1. Should we maintain two separate BoraOS distributions (x86_64 and ARM64)?
> 2. Are you willing to commit to long-term maintenance of both architectures?
> 3. Do you want ARM support immediately or can it be a future release (BoraOS 0.2)?

> [!IMPORTANT]
> **Technical Limitations on ARM64**
> 
> Not all x86_64 features will work on ARM64:
> - systemd-boot → Requires U-Boot or GRUB
> - Some packages may not be available
> - Virtualization differs (KVM unavailable on most ARM)
> - Performance characteristics differ significantly

---

## Proposed Changes

### Architecture Strategy

We'll create a **dual-architecture** build system:

```
BoraOS/
├── boraos-x86_64/          # Existing x86_64 build
│   ├── profiledef.sh
│   ├── packages.x86_64
│   └── build/
└── boraos-aarch64/         # New ARM64 build
    ├── profiledef-arm.sh
    ├── packages.aarch64
    └── build-arm/
```

---

### Core System Changes

#### [NEW] packages.aarch64

ARM64 package list with architecture-specific differences:

**Key Differences from x86_64:**
- Replace `linux` with `linux-aarch64` or `linux-rpi`
- Replace `grub` with `uboot-tools`
- Some packages unavailable: check compatibility
- ARM-specific firmware packages

**Base Packages:**
```
# Base
base
linux-aarch64
linux-firmware
firmware-raspberrypi  # For RPi

# Boot
uboot-tools
uboot-raspberrypi     # For RPi
grub                  # For UEFI ARM systems

# Same as x86_64
networkmanager
hyprland
waybar
...
```

---

#### [NEW] profiledef-arm.sh

ARM64 profile definition:

**Changes from x86_64:**
- `iso_name="boraos-arm"`
- `arch="aarch64"`
- `bootloader="uboot"` or `bootloader="grub-efi-arm64"`
- Different kernel parameters

---

#### [MODIFY] build/build.sh

Add architecture detection and selection:

```bash
# Detect or select architecture
ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
    PROFILE_DIR="boraos-x86_64"
elif [ "$ARCH" = "aarch64" ]; then
    PROFILE_DIR="boraos-aarch64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Run build for selected architecture
cd "$PROFILE_DIR"
./build/build.sh
```

---

### Bootloader Configuration

#### x86_64 (Current)
- systemd-boot (UEFI)
- Syslinux (BIOS)

#### ARM64 (New)

**Option 1: U-Boot** (Raspberry Pi, most ARM boards)
- Create `boot.txt` and compile to `boot.scr`
- Install to `/boot` partition
- Example:
```
setenv bootargs root=/dev/mmcblk0p2 rw rootwait console=ttyAMA0,115200
load mmc 0:1 ${kernel_addr_r} /Image
load mmc 0:1 ${fdt_addr_r} /dtbs/broadcom/bcm2711-rpi-4-b.dtb
booti ${kernel_addr_r} - ${fdt_addr_r}
```

**Option 2: GRUB (UEFI ARM)** (Some ARM servers, Apple Silicon with UEFI)
- Standard GRUB configuration
- Install `grub-efi-arm64`

---

### Build System Architecture

#### [NEW] boraos-aarch64/build/scripts/

Create ARM-specific build scripts:

1. **prepare_environment_arm.sh**
   - Check for `aarch64` architecture
   - Verify ARM-specific tools

2. **build_bootloader_arm.sh**
   - Compile U-Boot boot script
   - OR configure GRUB for ARM UEFI

3. **build_image_arm.sh**
   - Use `dd` to create raw disk image (for RPi)
   - OR use archiso-like process for UEFI ARM

---

### Package Compatibility Matrix

| Package | x86_64 | ARM64 | Notes |
|---------|--------|-------|-------|
| base | ✅ | ✅ | Identical |
| linux | ✅ | ⚠️ | Use linux-aarch64 or linux-rpi |
| systemd | ✅ | ✅ | Identical |
| hyprland | ✅ | ✅ | Available for ARM |
| sddm | ✅ | ✅ | Available for ARM |
| grub | ✅ | ⚠️ | grub-efi-arm64 on ARM |
| systemd-boot | ✅ | ❌ | Not available on ARM |
| vulkan-intel | ✅ | ❌ | x86_64 only |
| vulkan-radeon | ✅ | ❌ | x86_64 only |

---

### Directory Structure (Updated)

```
BoraOS/
├── .gitignore
├── README.md
├─�� boraos-x86_64/                 # x86_64 build (existing)
│   ├── profiledef.sh
│   ├── pacman.conf
│   ├── packages.x86_64
│   ├── airootfs/
│   └── build/
│       ├── build.sh
│       └── scripts/
└── boraos-aarch64/                # ARM64 build (new)
    ├── profiledef-arm.sh
    ├── pacman-arm.conf
    ├── packages.aarch64
    ├── airootfs-arm/
    └── build-arm/
        ├── build-arm.sh
        └── scripts-arm/
```

---

## Verification Plan

### ARM64 Build Testing

**On ARM64 host** (Raspberry Pi, Apple Silicon Linux, etc.):
```bash
cd boraos-aarch64
sudo ./build-arm/build-arm.sh
```

**Expected output:**
- `boraos-aarch64-0.1-aarch64.img` (raw image for RPi)
- OR `boraos-aarch64-0.1-aarch64.iso` (for UEFI ARM)

### Testing Platforms

1. **Raspberry Pi 4/5**:
   - Write image to SD card
   - Boot and verify Hyprland

2. **UTM ARM VM** (on Apple Silicon Mac):
   - Create aarch64 VM
   - Mount ISO or image
   - Test boot and installation

3. **Apple Silicon Mac** (with Asahi Linux):
   - Test UEFI boot
   - Verify Apple Silicon specific drivers

---

## Implementation Phases

### Phase 1: Research & Setup (Week 1)
- Research Arch Linux ARM build tools
- Set up ARM64 development environment
- Create package compatibility list

### Phase 2: Core ARM Build (Week 2)
- Create packages.aarch64
- Create profiledef-arm.sh
- Configure bootloader (U-Boot or GRUB)
- Create ARM build scripts

### Phase 3: Testing & Refinement (Week 3)
- Test on Raspberry Pi
- Test on UTM ARM VM
- Fix ARM-specific issues
- Document ARM build process

---

## Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Package unavailability | High | Maintain compatibility matrix, offer alternatives |
| Bootloader complexity | High | Support both U-Boot and GRUB, provide clear docs |
| Maintenance burden | High | Automate testing, use CI/CD for both architectures |
| Performance issues | Medium | Profile and optimize ARM-specific code |
| Limited testing hardware | Medium | Use QEMU ARM emulation for development |

---

## Open Questions

1. **Primary ARM target**: Raspberry Pi or general ARM64?
2. **Bootloader preference**: U-Boot (RPi) or GRUB (UEFI ARM)?
3. **Image format**: Raw disk image (.img) or ISO for UEFI?
4. **Apple Silicon**: Support Asahi Linux bootloader?

---

**Document Version**: 0.1  
**Sprint**: 5  
**Status**: Awaiting User Approval
