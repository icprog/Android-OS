?先把整个文件放到device/mediatek/common/

1.--------------------------------------------------------------------------------------------
# sunwave sepolicy
# 添加BOARD_SEPOLICY_DIRS下面这一行到 device/mediatek/common/BoardConfig.mk
# 添加位置在 “BOARD_SEPOLICY_DIRS := xxx” 之后

#sunwave add start
BOARD_SEPOLICY_DIRS += device/linaro/hikey/androidO_tee_run_ree_pkg/AndroidO_sepolicy_hidl
#sunwave add end

2.--------------------------------------------------------------------------------------------
# sunwave libs
# 添加在文件 device/mediatek/common/devices.mk 文件末

#sunwave add start
$(call inherit-product-if-exists, device/mediatek/common/sw_ree_O_pkg/swfp.mk)
#sunwave add end

3.vendor为默认用库，vendor_s为兼容用库