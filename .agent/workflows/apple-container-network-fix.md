---
description: Fix extremely slow pacman downloads inside Apple container (Operation too slow errors)
---

# Apple Container ArchISO Network Fix

This workflow fixes slow pacman downloads and "Operation too slow" timeout errors when building ArchISO inside an Apple container with QEMU emulation.

## Steps

### 1. Install pacman-contrib
Install pacman-contrib so rankmirrors and related tools are available:
```bash
pacman -Syu --noconfirm pacman-contrib
```

### 2. Replace mirrorlist with fast global mirrors
Edit `/etc/pacman.d/mirrorlist` and replace contents with these reliable mirrors:
```
Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch
Server = https://america.mirror.pkgbuild.com/$repo/os/$arch
Server = https://mirror.f4st.host/archlinux/$repo/os/$arch
Server = https://arch.mirrors.lavatech.top/$repo/os/$arch
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://mirror.chaotic.cx/arch/$repo/os/$arch
```

### 3. Configure pacman for better network handling
Edit `/etc/pacman.conf` and add/modify these options:
```ini
DownloadTimeout = 300
XferCommand = /usr/bin/curl -L -C - -f -o %o %u
```

> [!IMPORTANT]
> The `XferCommand=curl` setting is critical because pacman's internal downloader triggers slow-speed timeouts frequently under Apple container networking.

### 4. Clear pacman cache
Remove partial or corrupted downloads:
```bash
pacman -Scc --noconfirm
```

### 5. Update database and test downloads
Force refresh and test package download speed:
```bash
pacman -Syyu --noconfirm
```

### 6. Retry ArchISO build
Once networking is stable, retry the build:
```bash
mkarchiso -v .
```

---

## Notes

- This method minimizes all known causes of slow package download under ARM→x86 QEMU emulation
- Fast global mirrors ensure download throughput is stable even on weak QEMU NAT
- Running `pacman -Scc` prevents reused broken `.part` files from interrupting ArchISO build
