#!/usr/bin/env bash
# BoraOS ARM64 - Clean Previous Build Script

set -euo pipefail

echo "→ Cleaning previous build artifacts..."

# Remove work directory
if [ -d "build/work" ]; then
    echo "  Removing build/work..."
    rm -rf build/work
    echo "  ✓ Removed work directory"
fi

# Remove old output files
if [ -d "build/out" ]; then
    if ls build/out/*.iso 2>/dev/null || ls build/out/*.img 2>/dev/null; then
        echo "  Removing old ISO/IMG files..."
        rm -f build/out/*.iso build/out/*.img build/out/SHA256SUMS
        echo "  ✓ Removed old output files"
    fi
fi

# Clear logs (keep directory)
if [ -d "build/logs" ]; then
    rm -f build/logs/*.log
    echo "  ✓ Cleared log files"
fi

echo ""
echo "✓ Previous build artifacts cleaned"
echo ""
