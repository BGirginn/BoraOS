#!/usr/bin/env bash
# BoraOS x86_64 - Reproducible Build Environment
# Sets deterministic build variables for consistent ISO builds

# Reproducible build timestamp
# This ensures the same source produces identical ISOs
export SOURCE_DATE_EPOCH="1701388800"  # 2023-12-01 00:00:00 UTC

# Build information
export BORAOS_VERSION="0.1"
export BORAOS_ARCH="x86_64"
export ISO_LABEL="BORAOS_01"
export ISO_NAME="boraos"

# Bootloader type (grub, syslinux, or systemd-boot)
export BOOTLOADER_TYPE="${BOOTLOADER_TYPE:-systemd-boot}"

# Language and locale settings
export LANG="C"
export LC_ALL="C"

# Timezone for build consistency
export TZ="UTC"
