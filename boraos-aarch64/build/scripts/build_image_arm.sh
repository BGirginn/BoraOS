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
    
    # Colors for progress bars
    CYAN='\033[0;36m'
    YELLOW='\033[1;33m'
    NC='\033[0m'
    
    # Function to show package download progress
    show_package_progress() {
        local current=$1
        local total=$2
        local bar_length=50
        
        if [ $total -eq 0 ]; then return; fi
        
        local percentage=$((current * 100 / total))
        local filled=$((current * bar_length / total))
        local empty=$((bar_length - filled))
        
        # Build bar with - for packages (different from main #)
        local bar=""
        for ((i=0; i<filled; i++)); do bar+="-"; done
        for ((i=0; i<empty; i++)); do bar+=" "; done
        
        printf "\r${YELLOW}Packages: [${bar}] ${percentage}%% (${current}/${total})${NC}    "
    }
    
    # Start mkarchiso in background with log monitoring
    yes | mkarchiso -v -w build/work -o build/out build/work/profile > "$LOG_FILE" 2>&1 &
    MKARCHISO_PID=$!
    
    # Monitor log for package installation progress
    TOTAL_PACKAGES=0
    INSTALLED_PACKAGES=0
    MONITORING=true
    
    echo ""
    
    while [ "$MONITORING" = true ]; do
        sleep 0.5
        
        if [ -f "$LOG_FILE" ]; then
            # Try to extract total packages count
            if [ $TOTAL_PACKAGES -eq 0 ]; then
                TOTAL_PACKAGES=$(grep -o "Packages ([0-9]*)" "$LOG_FILE" 2>/dev/null | grep -o "[0-9]*" | head -1 || echo "0")
            fi
            
            # Count installed packages (look for completed installations)
            if [ $TOTAL_PACKAGES -gt 0 ]; then
                INSTALLED_PACKAGES=$(grep -c "installing\|upgraded\|reinstalled" "$LOG_FILE" 2>/dev/null || echo "0")
                
                # Show package progress if available
                if [ $INSTALLED_PACKAGES -gt 0 ] || [ $TOTAL_PACKAGES -gt 0 ]; then
                    show_package_progress $INSTALLED_PACKAGES $TOTAL_PACKAGES
                fi
            fi
        fi
        
        # Check if mkarchiso is still running
        if ! kill -0 $MKARCHISO_PID 2>/dev/null; then
            MONITORING=false
        fi
    done
    
    # Wait for mkarchiso to complete
    wait $MKARCHISO_PID
    BUILD_EXIT_CODE=$?
    
    # Clear package progress line
    printf "\r\033[K"
    
    if [ $BUILD_EXIT_CODE -eq 0 ]; then
        echo "  ✓ ISO build completed"
    else
        echo ""
        echo "ERROR: mkarchiso failed!"
        echo "Check log: $LOG_FILE"
        tail -20 "$LOG_FILE"
        exit 1
    fi
fi

echo ""
echo "✓ ARM64 image/ISO build completed"
echo ""
