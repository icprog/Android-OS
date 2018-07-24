ifneq ($(filter $(BIRD_SUPPORT_FP_SENSOR), SW331T),)
$(info BIRD_SUPPORT_FP_SENSOR contain $(BIRD_SUPPORT_FP_SENSOR))

BOARD_SEPOLICY_DIRS += bird/prebuilts/external/birdfp/sunwave/SW331T//AndroidO_sepolicy_hidl/

endif 
