?�Ȱ������ļ��ŵ�device/mediatek/common/

1.--------------------------------------------------------------------------------------------
# sunwave sepolicy
# ���BOARD_SEPOLICY_DIRS������һ�е� device/mediatek/common/BoardConfig.mk
# ���λ���� ��BOARD_SEPOLICY_DIRS := xxx�� ֮��

#sunwave add start
BOARD_SEPOLICY_DIRS += device/linaro/hikey/androidO_tee_run_ree_pkg/AndroidO_sepolicy_hidl
#sunwave add end

2.--------------------------------------------------------------------------------------------
# sunwave libs
# ������ļ� device/mediatek/common/devices.mk �ļ�ĩ

#sunwave add start
$(call inherit-product-if-exists, device/mediatek/common/sw_ree_O_pkg/swfp.mk)
#sunwave add end

3.vendorΪĬ���ÿ⣬vendor_sΪ�����ÿ�