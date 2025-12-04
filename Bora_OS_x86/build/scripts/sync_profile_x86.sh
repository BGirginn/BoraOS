#!/usr/bin/env bash
# BoraOS x86_64 - Sync Profile Files Script

set -euo pipefail

echo "→ Syncing x86_64 profile files..."

# Source reproducibility environment
source build/environment.sh

# Set umask for consistent permissions
umask 0022

# Create work profile directory
WORK_PROFILE="build/work/profile"
mkdir -p "$WORK_PROFILE"

# Copy profile files with deterministic timestamps
echo "  Copying profile files..."

cp -r profiledef.sh "$WORK_PROFILE/"
cp -r pacman.conf "$WORK_PROFILE/"
cp -r packages.x86_64 "$WORK_PROFILE/packages.x86_64"

# Copy airootfs if it exists
if [ -d "airootfs" ]; then
    cp -r airootfs "$WORK_PROFILE/"
    echo "  ✓ Copied airootfs overlay"
fi

# Copy bootloader directories
if [ -d "grub" ]; then
    cp -r grub "$WORK_PROFILE/"
    echo "  ✓ Copied grub configuration"
fi

if [ -d "syslinux" ]; then
    cp -r syslinux "$WORK_PROFILE/"
    echo " ✓ Copied syslinux configuration"
fi

if [ -d "efiboot" ]; then
    cp -r efiboot "$WORK_PROFILE/"
    echo "  ✓ Copied efiboot configuration"
fi

# Set deterministic timestamps on all files
echo "  Setting deterministic timestamps..."
find "$WORK_PROFILE" -exec touch -d "@${SOURCE_DATE_EPOCH}" {} +

echo "  ✓ Profile files synced to build/work/profile"
echo ""
echo "✓ x86_64 profile sync completed"
echo ""
