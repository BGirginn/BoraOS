#!/usr/bin/env bash
# shellcheck disable=SC2034

# BoraOS 0.1 - ArchISO Profile Definition
# Sprint 1 - Core Build Configuration

# ISO Metadata
iso_name="boraos"
iso_label="BORAOS_01"
iso_publisher="BoraOS Project"
iso_application="BoraOS Live/Installation Media"
iso_version="0.1"

# Build Configuration
install_dir="arch"
buildmodes=('iso')
arch="x86_64"
pacman_conf="pacman.conf"

# Bootloader Configuration
# Hybrid boot: systemd-boot (UEFI) + syslinux (BIOS)
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')

# Filesystem Configuration
# Using squashfs with zstd compression as specified
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15' '-b' '1M')

# File Permissions
# Security-focused permissions for sensitive system files
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:750"
)
