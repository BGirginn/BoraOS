#!/usr/bin/env bash
# BoraOS ARM64 - Configure Bootloader Script

set -euo pipefail

echo "→ Configuring ARM64 bootloader..."

# Determine bootloader type based on target platform
# Default: GRUB for UEFI ARM64
BOOTLOADER_TYPE="${BOOTLOADER_TYPE:-grub}"

echo "  Bootloader type: $BOOTLOADER_TYPE"

if [ "$BOOTLOADER_TYPE" == "grub" ]; then
    echo "  Configuring GRUB for UEFI ARM64..."
    
    # GRUB configuration will be handled by mkarchiso
    # Additional GRUB customizations can be added here
    
    echo "  ✓ GRUB configuration prepared"
    
elif [ "$BOOTLOADER_TYPE" == "uboot" ]; then
    echo "  Configuring U-Boot for Raspberry Pi..."
    
    # Create U-Boot boot script
    mkdir -p build/work/boot
    
    cat > build/work/boot/boot.txt << 'EOF'
# BoraOS ARM64 U-Boot boot script for Raspberry Pi

setenv bootargs "root=/dev/mmcblk0p2 rw rootwait console=tty1 console=ttyAMA0,115200"

echo "Loading kernel..."
load mmc 0:1 ${kernel_addr_r} /Image

echo "Loading device tree..."
load mmc 0:1 ${fdt_addr_r} /dtbs/broadcom/bcm2711-rpi-4-b.dtb

echo "Booting BoraOS ARM64..."
booti ${kernel_addr_r} - ${fdt_addr_r}
EOF
    
    # Compile boot script (if mkimage is available)
    if command -v mkimage &> /dev/null; then
        mkimage -A arm64 -O linux -T script -C none \
                -d build/work/boot/boot.txt build/work/boot/boot.scr
        echo "  ✓ U-Boot script compiled"
    else
        echo "  ⚠️  mkimage not found, boot.scr not created"
        echo "  Install u-boot-tools to compile boot script"
    fi
    
else
    echo "  ⚠️  Unknown bootloader type: $BOOTLOADER_TYPE"
    echo "  Defaulting to GRUB configuration"
fi

echo ""
echo "✓ ARM64 bootloader configuration completed"
echo ""
