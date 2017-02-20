# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864        #    65536 * 1024 mmcblk0p39
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864    #    65536 * 1024 mmcblk0p40
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 4294967296    #  4194304 * 1024 mmcblk0p54
BOARD_USERDATAIMAGE_PARTITION_SIZE := 25631374336 # 25030639 * 1024 mmcblk0p56
BOARD_CACHEIMAGE_PARTITION_SIZE := 318767104      #   311296 * 1024 mmcblk0p53
BOARD_FLASH_BLOCK_SIZE := 131072                  # (BOARD_KERNEL_PAGESIZE * 64)

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

BOARD_HAS_LARGE_FILESYSTEM := true
