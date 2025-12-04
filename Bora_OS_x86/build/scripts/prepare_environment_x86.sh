#!/usr/bin/env bash
# BoraOS x86_64 - Prepare Build Environment Script

set -euo pipefail

echo "→ Preparing x86_64 build environment..."

# Source reproducibility environment
source build/environment.sh

# Check architecture
ARCH=$(uname -m)
echo "  Current architecture: $ARCH"

if [ "$ARCH" != "x86_64" ]; then
    echo "  ⚠️  Warning: Not running on x86_64"
    echo "  Build is optimized for x86_64 architecture"
fi

# Check for required tools
echo "→ Checking required tools..."

REQUIRED_TOOLS=(
    "pacman"
    "mkarchiso"
    "mkinitcpio"
    "mksquashfs"
)

MISSING_TOOLS=()

for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        MISSING_TOOLS+=("$tool")
    else
        echo "  ✓ $tool"
    fi
done

# Check for bootloaders
if ! command -v grub-mkimage &> /dev/null; then
    echo "  ⚠️  grub-mkimage not found (needed for UEFI)"
else
    echo "  ✓ grub-mkimage"
fi

if ! command -v syslinux &> /dev/null; then
    echo "  ⚠️  syslinux not found (needed for BIOS boot)"
else
    echo "  ✓ syslinux"
fi

if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
    echo ""
    echo "ERROR: Missing required tools:"
    for tool in "${MISSING_TOOLS[@]}"; do
        echo "  - $tool"
    done
    echo ""
    echo "Install missing tools:"
    echo "  sudo pacman -S archiso squashfs-tools"
    exit 1
fi

# Check disk space
echo "→ Checking disk space..."
AVAILABLE_SPACE=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
REQUIRED_SPACE=10

if [ "$AVAILABLE_SPACE" -lt "$REQUIRED_SPACE" ]; then
    echo "ERROR: Insufficient disk space"
    echo "  Required: ${REQUIRED_SPACE}GB"
    echo "  Available: ${AVAILABLE_SPACE}GB"
    exit 1
fi

echo "  ✓ ${AVAILABLE_SPACE}GB available (${REQUIRED_SPACE}GB required)"

# Check RAM
echo "→ Checking system memory..."
TOTAL_RAM=$(free -g | awk '/^Mem:/ {print $2}')
REQUIRED_RAM=4

if [ "$TOTAL_RAM" -lt "$REQUIRED_RAM" ]; then
    echo "  ⚠️  Warning: Low system memory"
    echo "  Available: ${TOTAL_RAM}GB (recommended: ${REQUIRED_RAM}GB+)"
else
    echo "  ✓ ${TOTAL_RAM}GB RAM available"
fi

# Create necessary directories
echo "→ Creating build directories..."
mkdir -p build/work
mkdir -p build/out
mkdir -p build/logs

echo "  ✓ Build directories ready"

# Verify profile files
echo "→ Verifying profile files..."
REQUIRED_FILES=(
    "profiledef.sh"
    "pacman.conf"
    "packages.x86_64"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "ERROR: Missing required file: $file"
        exit 1
    fi
    echo "  ✓ $file"
done

echo ""
echo "✓ x86_64 build environment prepared successfully"
echo ""
