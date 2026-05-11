#!/bin/bash

# Flashing script for Iomega Storcenter IX4-300d OpenWrt
# Provides U-Boot TFTP flashing instructions and helper functions

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  OpenWrt Flashing Guide - IX4-300d NAS                   ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "This script provides instructions for flashing OpenWrt firmware."
echo ""

# Detect serial ports
echo "Available serial ports:"
ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null | nl || echo "  (none found)"
echo ""

echo "Select flashing method:"
echo ""
echo "  1) U-Boot TFTP (recommended - requires network and serial)"
echo "  2) Manual instructions"
echo "  3) SSH flashing (if device already has OpenWrt/Linux)"
echo "  4) View partition layout"
echo "  5) Exit"
echo ""
read -p "Enter choice [1-5]: " choice
echo ""

case $choice in
    1)
        echo "╔════════════════════════════════════════════════════════════════╗"
        echo "║  Method 1: U-Boot TFTP Flashing                           ║"
        echo "╚════════════════════════════════════════════════════════════════╝"
        echo ""
        echo "Prerequisites:"
        echo "  ✓ Serial console connected (115200, 8N1)"
        echo "  ✓ TFTP server running on your computer"
        echo "  ✓ OpenWrt firmware in /srv/tftp/"
        echo ""
        echo "Steps:"
        echo "1. Power on device and interrupt U-Boot"
        echo "2. Configure network:"
        echo "   => setenv serverip 192.168.1.100"
        echo "   => setenv ipaddr 192.168.1.50"
        echo "3. Download and boot:"
        echo "   => tftpboot 0x6400000 openwrt-mvebu-armada-xp-lenovo-ix4-300d-initramfs.tar.gz"
        echo "   => bootm 0x6400000"
        echo "4. SSH and sysupgrade after boot"
        echo ""
        ;;
    2)
        echo "╔════════════════════════════════════════════════════════════════╗"
        echo "║  Manual U-Boot Instructions                               ║"
        echo "╚════════════════════════════════════════════════════════════════╝"
        echo ""
        echo "Partition addresses:"
        printf "%-20s %12s %12s\n" "Partition" "Start" "End"
        printf "%-20s 0x%10x 0x%10x\n" "u-boot" 0x00000000 0x000e0000
        printf "%-20s 0x%10x 0x%10x\n" "u-boot-env" 0x000e0000 0x00100000
        printf "%-20s 0x%10x 0x%10x\n" "zImage" 0x00120000 0x00520000
        printf "%-20s 0x%10x 0x%10x\n" "boot" 0x00e00000 0x40000000
        echo ""
        ;;
    3)
        echo "╔════════════════════════════════════════════════════════════════╗"
        echo "║  Method 3: SSH Flashing                                   ║"
        echo "╚════════════════════════════════════════════════════════════════╝"
        echo ""
        read -p "Device IP address [192.168.1.50]: " device_ip
        device_ip=${device_ip:-192.168.1.50}
        echo "Uploading firmware..."
        scp openwrt/bin/targets/mvebu/armada-xp/*.tar.gz root@$device_ip:/tmp/ 2>/dev/null || echo "Upload failed"
        echo "Install with: sysupgrade -n /tmp/openwrt-*.tar.gz"
        echo ""
        ;;
    4)
        echo "╔════════════════════════════════════════════════════════════════╗"
        echo "║  IX4-300d NAND Partition Layout                           ║"
        echo "╚════════════════════════════════════════════════════════════════╝"
        echo ""
        printf "%-20s %12s %12s %15s\n" "Partition" "Start" "End" "Size"
        printf "%-20s 0x%10x 0x%10x %12s\n" "u-boot" 0x00000000 0x000e0000 "896 KB"
        printf "%-20s 0x%10x 0x%10x %12s\n" "u-boot-env" 0x000e0000 0x00100000 "128 KB"
        printf "%-20s 0x%10x 0x%10x %12s\n" "u-boot-env2" 0x00100000 0x00120000 "128 KB"
        printf "%-20s 0x%10x 0x%10x %12s\n" "zImage" 0x00120000 0x00520000 "4 MB"
        printf "%-20s 0x%10x 0x%10x %12s\n" "initrd" 0x00520000 0x00920000 "4 MB"
        printf "%-20s 0x%10x 0x%10x %12s\n" "boot" 0x00e00000 0x40000000 "~1 GB"
        echo ""
        echo "Total: 1024 MB NAND Flash"
        echo ""
        ;;
    5)
        echo "Exiting."
        exit 0
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "⚠️  IMPORTANT WARNINGS:"
echo ""
echo "  • Do NOT overwrite u-boot (0x00000000-0x000e0000)"
echo "  • Ensure stable power during flashing"
echo "  • Both eth0 and eth1 must be initialized for poweroff"
echo ""
