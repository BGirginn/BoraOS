#!/usr/bin/env bash
# BoraOS ARM64 Master Build Script
# Executes all build steps in order to create reproducible ARM64 ISO/Image

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Progress bar function
show_progress() {
    local current=$1
    local total=$2
    local description="$3"
    local bar_length=50
    
    local percentage=$((current * 100 / total))
    local filled=$((current * bar_length / total))
    local empty=$((bar_length - filled))
    
    # Build the bar with # for filled and spaces for empty
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="#"; done
    for ((i=0; i<empty; i++)); do bar+=" "; done
    
    # Print progress with brackets (overwrites same line with \r)
    printf "\r${CYAN}[${bar}] ${percentage}%%${NC} ${description}    "
}

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BORAOS_DIR="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}  ${GREEN}BoraOS ARM64 0.1 - Reproducible Build Pipeline${NC}    ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}ERROR: This script must be run as root${NC}"
    echo "Run with: sudo ./build-arm.sh"
    exit 1
fi

# Check if running on ARM64
ARCH=$(uname -m)
if [ "$ARCH" != "aarch64" ] && [ "$ARCH" != "arm64" ]; then
    echo -e "${YELLOW}WARNING: Not running on ARM64 architecture${NC}"
    echo "Current architecture: $ARCH"
    echo "ARM64 build should be performed on aarch64 system"
    echo ""
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Change to BoraOS ARM64 directory
cd "$BORAOS_DIR"

# Build steps
STEPS=(
    "prepare_environment_arm.sh:Prepare ARM64 Build Environment"
    "clean_previous_build.sh:Clean Previous Build"
    "sync_profile_arm.sh:Sync ARM64 Profile Files"
    "build_bootloader_arm.sh:Configure ARM64 Bootloader"
    "build_image_arm.sh:Build ARM64 Image/ISO"
    "finalize_arm.sh:Finalize ARM64 Output"
    "generate_checksums.sh:Generate Checksums"
)

TOTAL_STEPS=${#STEPS[@]}
CURRENT_STEP=0

# Show initial overall progress at bottom
echo ""
show_progress 0 $TOTAL_STEPS "Starting build..."
sleep 0.5

# Execute each step
for step in "${STEPS[@]}"; do
    CURRENT_STEP=$((CURRENT_STEP + 1))
    SCRIPT="${step%%:*}"
    DESCRIPTION="${step##*:}"
    
    # Update progress bar (stays on same line)
    show_progress $((CURRENT_STEP - 1)) $TOTAL_STEPS "Preparing: ${DESCRIPTION}"
    sleep 0.3
    
    # Clear progress line and show step header
    printf "\r\033[K"  # Clear current line
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}Step $CURRENT_STEP/$TOTAL_STEPS: ${DESCRIPTION}${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo ""
    
    if [ ! -f "build/scripts/$SCRIPT" ]; then
        echo -e "${RED}ERROR: Script build/scripts/$SCRIPT not found!${NC}"
        exit 1
    fi
    
    if ! bash "build/scripts/$SCRIPT"; then
        printf "\r\033[K"  # Clear progress line
        echo ""
        echo -e "${RED}╔════════════════════════════════════════╗${NC}"
        echo -e "${RED}║  BUILD FAILED at step $CURRENT_STEP/$TOTAL_STEPS        ║${NC}"
        echo -e "${RED}╚════════════════════════════════════════╝${NC}"
        echo ""
        echo "Check logs in build/logs/ for details"
        exit 1
    fi
    
    # Update progress bar after step completion (overwrites same line)
    show_progress $CURRENT_STEP $TOTAL_STEPS "Completed: ${DESCRIPTION}"
    sleep 0.5
done

# Final progress - complete and move to new line
show_progress $TOTAL_STEPS $TOTAL_STEPS "Build pipeline completed!"
echo ""  # Move to new line after final progress

# Success!
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ARM64 BUILD COMPLETED SUCCESSFULLY!                   ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Output Location:${NC} build/out/"
echo -e "${GREEN}Checksum:${NC} build/out/SHA256SUMS"
echo ""

# Display output info
if [ -f "build/out/boraos-arm-0.1-aarch64.iso" ]; then
    ISO_SIZE=$(du -h build/out/boraos-arm-0.1-aarch64.iso | cut -f1)
    echo "ISO Size: $ISO_SIZE"
    echo ""
elif [ -f "build/out/boraos-arm-0.1-aarch64.img" ]; then
    IMG_SIZE=$(du -h build/out/boraos-arm-0.1-aarch64.img | cut -f1)
    echo "Image Size: $IMG_SIZE"
    echo ""
fi

if [ -f "build/out/SHA256SUMS" ]; then
    echo "SHA256:"
    cat build/out/SHA256SUMS
    echo ""
fi

echo -e "${YELLOW}Next steps:${NC}"
echo "1. Verify output: cd build/out && sha256sum -c SHA256SUMS"
echo "2. For Raspberry Pi: Write image to SD card"
echo "3. For UEFI ARM: Test in UTM or on compatible hardware"
echo ""
echo -e "${GREEN}Happy building! 🚀${NC}"
