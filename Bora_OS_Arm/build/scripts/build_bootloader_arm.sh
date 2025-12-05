#!/usr/bin/env bash
# BoraOS ARM - Build Bootloader Configuration

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$(dirname "$SCRIPT_DIR")"
PROFILE_DIR="$(dirname "$BUILD_DIR")"

echo "Configuring ARM64 bootloader..."

# Verify systemd-boot configuration (PRIMARY)
if [ ! -f "${PROFILE_DIR}/efiboot/loader/loader.conf" ]; then
    echo "ERROR: systemd-boot loader.conf missing!"
    exit 1
fi
echo "  ✓ systemd-boot loader.conf"

# Verify boot entries
ENTRIES_DIR="${PROFILE_DIR}/efiboot/loader/entries"
if [ ! -d "$ENTRIES_DIR" ]; then
    echo "ERROR: Boot entries directory missing!"
    exit 1
fi

ENTRY_COUNT=$(ls -1 "${ENTRIES_DIR}"/*.conf 2>/dev/null | wc -l)
if [ "$ENTRY_COUNT" -eq 0 ]; then
    echo "ERROR: No boot entries found!"
    exit 1
fi
echo "  ✓ Found $ENTRY_COUNT boot entries"

# Verify GRUB configuration (OPTIONAL)
if [ -f "${PROFILE_DIR}/grub/grub.cfg" ]; then
    echo "  ✓ GRUB configuration (optional)"
else
    echo "  ○ GRUB configuration not present (optional)"
fi

echo "Bootloader configuration complete!"
