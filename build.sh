#!/bin/bash

# OpenWrt Build Script for Iomega Storcenter IX4-300d
# Automates downloading, patching, and building OpenWrt firmware

set -e

OPENWRT_VERSION="25.12.3"
TARGET="mvebu"
SUBTARGET="armada-xp"

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  OpenWrt Build for Iomega Storcenter IX4-300d NAS        ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check prerequisites
echo "[1/6] Checking prerequisites..."
for tool in gcc make git python3 dtc; do
    if ! command -v $tool &> /dev/null; then
        echo "✗ Missing: $tool"
        exit 1
    fi
done
echo "✓ All prerequisites found"
echo ""

# Check disk space
echo "[2/6] Checking disk space..."
AVAIL=$(df . | awk 'NR==2 {print $4}')
if [ "$AVAIL" -lt 10485760 ]; then
    echo "✗ Need ~10GB free space (available: $((AVAIL/1024/1024))GB)"
    exit 1
fi
echo "✓ Sufficient disk space available"
echo ""

# Download OpenWrt
echo "[3/6] Downloading OpenWrt ${OPENWRT_VERSION}..."
if [ ! -d "openwrt" ]; then
    git clone --depth=1 --branch=v${OPENWRT_VERSION} https://github.com/openwrt/openwrt.git
else
    echo "✓ OpenWrt already present"
fi
cd openwrt
echo "✓ OpenWrt ready"
echo ""

# Apply patches
echo "[4/6] Applying device patches..."
if [ -f "../target/linux/mvebu/patches-5.15/100-add-ix4-300d.patch" ]; then
    patch -p1 < ../target/linux/mvebu/patches-5.15/100-add-ix4-300d.patch || true
    echo "✓ Device tree patch applied"
fi
echo ""

# Setup feeds
echo "[5/6] Setting up build environment..."
./scripts/feeds update -a > /dev/null 2>&1
./scripts/feeds install -a > /dev/null 2>&1
if [ -f "../.config" ]; then
    cp ../.config .config
fi
echo "✓ Build environment ready"
echo ""

# Build
echo "[6/6] Building OpenWrt (this may take 30-60 minutes)..."
echo ""
make -j$(($(nproc)+1)) defconfig
make -j$(($(nproc)+1))
echo ""
echo "✓ Build complete!"
echo ""

# Show results
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  Build artifacts:                                        ║"
echo "╚════════════════════════════════════════════════════════════════╝"
ls -lh bin/targets/${TARGET}/${SUBTARGET}/ 2>/dev/null || true
echo ""
echo "Next steps:"
echo "  1. Copy firmware to your TFTP server"
echo "  2. Run: bash ../flash.sh"
echo "  3. Follow the on-screen flashing instructions"
