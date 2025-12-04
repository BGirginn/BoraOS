#!/usr/bin/env bash
# BoraOS x86_64 - Finalize Output Script

set -euo pipefail

echo "→ Finalizing x86_64 output..."

# Find the generated ISO file
if ls build/out/*.iso 2>/dev/null; then
    ISO_FILE=$(ls build/out/*.iso | head -1)
    FINAL_NAME="boraos-0.1-x86_64.iso"
    
    echo "  Found ISO: $(basename "$ISO_FILE")"
    
    # Rename to standard name if needed
    if [ "$(basename "$ISO_FILE")" != "$FINAL_NAME" ]; then
        mv "$ISO_FILE" "build/out/$FINAL_NAME"
        echo "  ✓ Renamed to $FINAL_NAME"
    fi
    
    OUTPUT_FILE="build/out/$FINAL_NAME"
    
else
    echo "ERROR: No ISO file found in build/out/"
    exit 1
fi

# Display file info
SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
echo "  File size: $SIZE"

echo ""
echo "✓ x86_64 output finalized: $OUTPUT_FILE"
echo ""
