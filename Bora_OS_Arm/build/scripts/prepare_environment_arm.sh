#!/usr/bin/env bash
# BoraOS ARM - Prepare Build Environment
# Installs required packages for ARM64 ISO build

set -euo pipefail

echo "Preparing ARM64 build environment..."

# Check for archiso
if ! pacman -Qi archiso &>/dev/null; then
    echo "Installing archiso..."
    pacman -Sy --noconfirm archiso
else
    echo "archiso is already installed"
fi

# Check for other required packages
REQUIRED_PKGS=(
    "squashfs-tools"
    "dosfstools"
    "mtools"
    "libisoburn"
    "grub"
)

for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
        echo "Installing $pkg..."
        pacman -S --noconfirm "$pkg"
    fi
done

# Initialize pacman keyring for Arch Linux ARM
echo "Initializing pacman keyring..."
pacman-key --init
pacman-key --populate archlinuxarm || echo "archlinuxarm keyring may not be available, continuing..."

echo "ARM64 build environment ready!"
