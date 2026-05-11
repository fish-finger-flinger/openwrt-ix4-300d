# Quick Start - OpenWrt IX4-300d

## 30-Second Setup

```bash
# Clone and build
git clone https://github.com/fish-finger-flinger/openwrt-ix4-300d.git
cd openwrt-ix4-300d
bash build.sh
```

Build artifacts appear in `bin/targets/mvebu/`

## Flash to Device

```bash
# Interactive flashing script
bash flash.sh
```

## Key Files

| File | Purpose |
|------|---------|
| `README.md` | Full documentation |
| `build.sh` | Automated build |
| `flash.sh` | Flashing instructions |
| `.config` | Build configuration |
| `target/linux/mvebu/patches-5.15/100-add-ix4-300d.patch` | Kernel device tree |

## Hardware Info at a Glance

- **CPU:** Marvell Armada XP (Dual-core ARM)
- **RAM:** 1GB (2x 512MB)
- **Flash:** 1GB NAND
- **Ethernet:** 2x Gigabit (88E1318)
- **SATA:** 4-port (88SX7042)
- **USB:** 3.0 xHCI (Renesas D720200AF1)

## Prerequisites

```bash
sudo apt-get install -y build-essential git device-tree-compiler \
  libncurses5-dev zlib1g-dev gawk gettext libssl-dev xsltproc rsync wget
```

## Serial Console

```bash
# 115200 baud, 8N1
screen /dev/ttyUSB0 115200
```
