#!/usr/bin/env bash
# Test single progress bar that updates in place

CYAN='\033[0;36m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

show_progress() {
    local current=$1
    local total=$2
    local description="$3"
    local bar_length=50
    
    local percentage=$((current * 100 / total))
    local filled=$((current * bar_length / total))
    local empty=$((bar_length - filled))
    
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="#"; done
    for ((i=0; i<empty; i++)); do bar+=" "; done
    
    printf "\r${CYAN}[${bar}] ${percentage}%%${NC} ${description}    "
}

echo "Testing SINGLE progress bar that updates in place..."
echo ""

# Initial progress
show_progress 0 7 "Starting..."
sleep 1

# Simulate build steps
STEPS=("Prepare" "Clean" "Sync" "Bootloader" "Build ISO" "Finalize" "Checksums")

for i in $(seq 0 6); do
    # Update progress
    show_progress $i 7 "Preparing: ${STEPS[$i]}"
    sleep 0.4
    
    # Clear and show step
    printf "\r\033[K"
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}Step $((i+1))/7: ${STEPS[$i]}${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo ""
    echo "  → Processing ${STEPS[$i]}..."
    sleep 0.3
    echo "  ✓ ${STEPS[$i]} completed"
    echo ""
    
    # Update progress after completion
    show_progress $((i+1)) 7 "Completed: ${STEPS[$i]}"
    sleep 0.4
done

# Final
show_progress 7 7 "Build completed!"
echo ""
echo ""
echo -e "${GREEN}✓ Test successful! Progress bar stays at bottom and updates!${NC}"
