#!/usr/bin/env bash
# BoraOS 0.1 - ArchISO profile definition

iso_name="boraos"
iso_label="BORAOS_0_1"
iso_publisher="BoraOS Project <https://boraos.org>"
iso_application="BoraOS Live/Install ISO"
iso_version="0.1"

install_dir="arch"
buildmodes=("iso")
bootmodes=("uefi-x64.systemd-boot.esp" "uefi-x64.systemd-boot.eltorito" "bios.syslinux.mbr" "bios.syslinux.eltorito")

arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=("-comp" "zstd" "-Xcompression-level" "15" "-b" "1M")

file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/usr/local/bin/boraos-installer"]="0:0:755"
)