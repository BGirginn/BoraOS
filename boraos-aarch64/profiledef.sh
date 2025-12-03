#!/usr/bin/env bash
# BoraOS 0.1 ARM64 - ArchISO profile definition

iso_name="boraos-arm"
iso_label="BORAOS_ARM_0_1"
iso_publisher="BoraOS Project <https://boraos.org>"
iso_application="BoraOS ARM64 Live/Install ISO"
iso_version="0.1"

install_dir="arch"
buildmodes=("iso")

# ARM64 specific bootmodes
# Note: systemd-boot is not available on ARM64
# Using GRUB for UEFI ARM64 systems
bootmodes=("uefi.grub")

arch="aarch64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=("-comp" "zstd" "-Xcompression-level" "15" "-b" "1M")

file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:750"
)
