#!/usr/bin/env bash
# BoraOS ARM64 - Build Image/ISO Script

set -euo pipefail

echo "→ Building ARM64 image/ISO..."

# Source reproducibility environment
source build/environment.sh

# Set deterministic build environment
export SOURCE_DATE_EPOCH
export LANG=C
export LC_ALL=C
export TZ=UTC

# Log file
LOG_FILE="build/logs/mkarchiso_arm.log"

echo "  Running mkarchiso for ARM64..."
echo "  Log: $LOG_FILE"

# Determine output type based on BOOTLOADER_TYPE
OUTPUT_TYPE="${BOOTLOADER_TYPE:-grub}"

if [ "$OUTPUT_TYPE" == "uboot" ]; then
    echo "  Building raw disk image for Raspberry Pi..."
    # For Raspberry Pi, we need to create a raw disk image
    # This requires custom partitioning and filesystem creation
    
    IMG_SIZE=4096  # 4GB image
    IMG_FILE="build/work/boraos-arm.img"
    
    echo "  Creating ${IMG_SIZE}MB disk image..."
    dd if=/dev/zero of="$IMG_FILE" bs=1M count=$IMG_SIZE status=progress
    
    # Create partition table
    echo "  Creating partition table..."
    parted -s "$IMG_FILE" mklabel msdos
    parted -s "$IMG_FILE" mkpart primary fat32 1MiB 256MiB
    parted -s "$IMG_FILE" mkpart primary ext4 256MiB 100%
    parted -s "$IMG_FILE" set 1 boot on
    
    echo "  ✓ Disk image structure created"
    echo "  ⚠️  Note: Full Raspberry Pi image build requires additional steps"
    echo "  This is a placeholder for the full implementation"
    
else
    # Build ISO using mkarchiso (for UEFI ARM64)
    echo "  Building ISO for UEFI ARM64..."
    
    # Run mkarchiso with automatic confirmation and retry logic
    # Use 'yes' to automatically answer prompts (e.g., "Proceed with installation? [Y/n]")
    MAX_RETRIES=3
    RETRY_COUNT=0
    BUILD_SUCCESS=false
    
    while [ $RETRY_COUNT -lt $MAX_RETRIES ] && [ "$BUILD_SUCCESS" = false ]; do
        if [ $RETRY_COUNT -gt 0 ]; then
            echo ""
            echo "  Retry attempt $RETRY_COUNT/$MAX_RETRIES..."
            echo "  Waiting 10 seconds before retry..."
            sleep 10
        fi
        
        if yes | mkarchiso -v -w build/work -o build/out build/work/profile > "$LOG_FILE" 2>&1; then
            BUILD_SUCCESS=true
            echo "  ✓ ISO build completed"
        else
            RETRY_COUNT=$((RETRY_COUNT + 1))
            if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
                echo "  ⚠️  Build failed, retrying..."
            fi
        fi
    done
    
    if [ "$BUILD_SUCCESS" = false ]; then
        echo ""
        echo "ERROR: mkarchiso failed after $MAX_RETRIES attempts!"
        echo "Check log: $LOG_FILE"
        tail -20 "$LOG_FILE"
        exit 1
    fi
fi

echo ""
echo "✓ ARM64 image/ISO build completed"
echo ""
