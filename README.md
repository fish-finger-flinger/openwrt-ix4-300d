# OpenWrt Build for Iomega Storcenter IX4-300d NAS

## Overview

This repository contains a complete OpenWrt build system for the **Iomega Storcenter IX4-300d** NAS device (also known as Lenovo Iomega ix4-300d).

## Hardware Specifications

| Component | Details |
|-----------|----------|
| **CPU** | Marvell Armada XP MV78230 (Dual-core ARM, 1.2 GHz) |
| **RAM** | 2x NT5CB128M16FP-DI (2x 512MB = 1GB total) |
| **Flash** | K9K8G08U0E (1GB NAND) |
| **Ethernet** | 2x Marvell 88E1318-NNB2 (Gigabit, RGMII) |
| **SATA** | Marvell 88SX7042-BDU1 (4-port controller) |
| **USB** | Renesas D720200AF1 (USB 3.0 xHCI) |
| **RTC** | NXP pcf8563 (I2C @ 0x51) |
| **Thermal Monitor** | ADT7473 (I2C @ 0x2e) |
| **LED Controller** | NXP 74HC165D (SPI, front panel) |
| **Serial** | 115200 baud, 8N1 |

## NAND Flash Partition Layout

Partition          Start       Size        Purpose
─────────────────────────────────────────────────────────
u-boot             0x00000000  0x0e0000    Bootloader (912KB, RO)
u-boot-env         0x000e0000  0x020000    U-Boot environment (128KB, RO)
u-boot-env2        0x00100000  0x020000    U-Boot env backup (128KB, RO)
zImage             0x00120000  0x400000    Kernel (4MB)
initrd             0x00520000  0x400000    Initial ramdisk (4MB)
boot               0x00e00000  0x3f200000  Root filesystem (~1GB)

**Total Flash:** 1024MB (1GB)

## GPIO Mapping

### Buttons

| Button | GPIO | Signal | Code | Polarity |
|--------|------|--------|------|----------|
| Power | MPP44 (GPIO1.12) | KEY_POWER | 116 | Active High |
| Reset | MPP45 (GPIO1.13) | KEY_RESTART | 408 | Active Low |
| Select | MPP41 (GPIO1.9) | BTN_SELECT | 109 | Active Low |
| Scroll | MPP42 (GPIO1.10) | KEY_SCROLLDOWN | 125 | Active Low |

### Direct GPIO LEDs

| LED | GPIO | Label | Polarity |
|-----|------|-------|----------|
| HDD Activity | MPP26 (GPIO0.26) | `ix4-300d:hdd:blue` | Active High |
| Poweroff | MPP24 (GPIO0.24) | gpio-poweroff | Active High |

### SPI-GPIO LEDs (via 74HC595 shift register)

| LED | Shift Reg Bit | Label | Polarity |
|-----|---------------|-------|----------|
| Power LED | 1 | `ix4-300d:power:white` | Active Low |
| System Fail | 2 | `ix4-300d:sysfail:red` | Active High |
| System LED | 3 | `ix4-300d:sys:blue` | Active High |
| HDD Fail | 4 | `ix4-300d:hddfail:red` | Active High |

## Building OpenWrt

### Prerequisites

Install required build tools on Ubuntu/Debian:

```bash
sudo apt-get update
sudo apt-get install -y \
  build-essential \
  libncurses5-dev \
  zlib1g-dev \
  gawk \
  git \
  gettext \
  libssl-dev \
  xsltproc \
  rsync \
  wget \
  python3-distutils \
  device-tree-compiler
```

### Build Steps

1. **Clone this repository:**
   ```bash
   git clone https://github.com/fish-finger-flinger/openwrt-ix4-300d.git
   cd openwrt-ix4-300d
   ```

2. **Run the build script:**
   ```bash
   bash build.sh
   ```

3. **Find compiled image:**
   ```bash
   ls -lh bin/targets/mvebu/*/
   ```

## Flashing the Device

```bash
bash flash.sh
```

Follow the interactive prompts for your preferred flashing method.

## Serial Console Setup

- **Baud Rate:** 115200
- **Data Bits:** 8
- **Stop Bits:** 1
- **Parity:** None
- **Flow Control:** None

## License

GPL-2.0+ (consistent with OpenWrt and Linux kernel)
