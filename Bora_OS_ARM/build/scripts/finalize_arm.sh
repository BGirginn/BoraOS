#!/usr/bin/env bash
# BoraOS ARM64 - Finalize Output Script

set -euo pipefail

echo "→ Finalizing ARM64 output..."

# Find the generated ISO/IMG file
if ls build/out/*.iso 2>/dev/null; then
    # ISO file found (UEFI ARM64)
    ISO_FILE=$(ls build/out/*.iso | head -1)
    FINAL_NAME="boraos-arm-0.1-aarch64.iso"
    
    echo "  Found ISO: $(basename "$ISO_FILE")"
    
    # Rename to standard name if needed
    if [ "$(basename "$ISO_FILE")" != "$FINAL_NAME" ]; then
        mv "$ISO_FILE" "build/out/$FINAL_NAME"
        echo "  ✓ Renamed to $FINAL_NAME"
    fi
    
    OUTPUT_FILE="build/out/$FINAL_NAME"
    
elif ls build/out/*.img 2>/dev/null || [ -f "build/work/boraos-arm.img" ]; then
    # IMG file found (Raspberry Pi)
    if [ -f "build/work/boraos-arm.img" ]; then
        IMG_FILE="build/work/boraos-arm.img"
    else
        IMG_FILE=$(ls build/out/*.img | head -1)
    fi
    
    FINAL_NAME="boraos-arm-0.1-aarch64.img"
    
    echo "  Found IMG: $(basename "$IMG_FILE")"
    
    # Move to output directory
    mv "$IMG_FILE" "build/out/$FINAL_NAME"
    echo "  ✓ Moved to build/out/$FINAL_NAME"
    
    OUTPUT_FILE="build/out/$FINAL_NAME"
    
else
    echo "ERROR: No ISO or IMG file found in build/out/"
    exit 1
fi

# Display file info
SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
echo "  File size: $SIZE"

echo ""
echo "✓ ARM64 output finalized: $OUTPUT_FILE"
echo ""
