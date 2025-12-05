#!/usr/bin/env bash
# shellcheck disable=SC2034

# BoraOS 0.1 ARM (aarch64) - ArchISO Profile Definition
# Generic ARM UEFI ISO for UTM/QEMU and ARM UEFI devices

# ISO Metadata
iso_name="boraos"
iso_label="BORAOS_01_ARM"
iso_publisher="BoraOS Project"
iso_application="BoraOS Live/Installation Media (ARM64)"
iso_version="0.1"

# Build Configuration
install_dir="arch"
buildmodes=('iso')
arch="aarch64"
pacman_conf="pacman.conf"

# Bootloader Configuration
# Generic ARM64 UEFI boot mode (systemd-boot primary)
# Note: GRUB is optional for Generic ARM UEFI ISO
# Using uefi-aa64.systemd-boot for UTM/QEMU compatibility
bootmodes=('uefi-aa64.systemd-boot.esp' 'uefi-aa64.systemd-boot.eltorito')

# Filesystem Configuration
# Using squashfs with zstd compression (same as x86_64)
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15' '-b' '1M')

# File Permissions
# Security-focused permissions for sensitive system files
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/etc/sudoers.d/g_wheel"]="0:0:440"
)
