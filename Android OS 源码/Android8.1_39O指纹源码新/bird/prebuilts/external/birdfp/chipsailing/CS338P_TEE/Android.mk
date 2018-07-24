ifneq ($(filter $(BIRD_SUPPORT_FP_SENSOR), CS338P_TEE),)
$(info BIRD_SUPPORT_FP_SENSOR contain $(BIRD_SUPPORT_FP_SENSOR))

BOARD_SEPOLICY_DIRS += bird/prebuilts/external/birdfp/chipsailing/CS338P_TEE/sepolicy


endif 
