# Marvell Armada XP Device Image Configuration

define Device/lenovo_ix4-300d
  DEVICE_TITLE := Lenovo Iomega ix4-300d
  DEVICE_DTS := armada-xp-lenovo-ix4-300d
  BOARD_NAME := lenovo,ix4-300d
  KERNEL_SIZE := 4096k
  IMAGE_SIZE := 1024m
  KERNEL := kernel-bin | uImage none
  KERNEL_INITRAMFS := kernel-bin | uImage none
  KERNEL_INSTALL := 1
  SUPPORTED_DEVICES := lenovo,ix4-300d
endef
TARGET_DEVICES += lenovo_ix4-300d
