#!/usr/bin/env bash
# BoraOS x86_64 - Configure Bootloader Script

set -euo pipefail

echo "→ Configuring x86_64 bootloader..."

# x86_64 supports multiple boot modes
BOOTLOADER_TYPE="${BOOTLOADER_TYPE:-systemd-boot}"

echo "  Bootloader type: $BOOTLOADER_TYPE"

# Verify bootloader packages
echo "→ Verifying bootloader components..."

# Check for GRUB (UEFI)
if ! pacman -Q grub &> /dev/null; then
    echo "  ⚠️  GRUB not installed on host system"
else
    echo "  ✓ GRUB package found"
fi

# Check for Syslinux (BIOS)
if ! pacman -Q syslinux &> /dev/null; then
    echo "  ⚠️  Syslinux not installed on host system"
else
    echo "  ✓ Syslinux package found"
fi

# Check for systemd-boot components (usually part of systemd)
if ! pacman -Q systemd &> /dev/null; then
    echo "  ⚠️  systemd not installed on host system"
else
    echo "  ✓ systemd package found (systemd-boot available)"
fi

# Verify x86_64 GRUB modules if using GRUB
if [ "$BOOTLOADER_TYPE" == "grub" ] || [ "$BOOTLOADER_TYPE" == "all" ]; then
    GRUB_x86_PATH="/usr/lib/grub/x86_64-efi"
    
    if [ -d "$GRUB_x86_PATH" ]; then
        echo "  ✓ GRUB x86_64-efi modules found"
    else
        echo "  ⚠️  GRUB x86_64-efi modules not found at $GRUB_x86_PATH"
    fi
fi

# Verify Syslinux modules if using Syslinux
if [ "$BOOTLOADER_TYPE" == "syslinux" ] || [ "$BOOTLOADER_TYPE" == "all" ]; then
    SYSLINUX_PATH="/usr/lib/syslinux/bios"
    
    if [ -d "$SYSLINUX_PATH" ]; then
        echo "  ✓ Syslinux BIOS modules found"
    else
        echo "  ⚠️  Syslinux BIOS modules not found at $SYSLINUX_PATH"
    fi
fi

echo "  ✓ Bootloader configuration completed"
echo ""
echo "✓ x86_64 bootloader configuration completed"
echo ""
