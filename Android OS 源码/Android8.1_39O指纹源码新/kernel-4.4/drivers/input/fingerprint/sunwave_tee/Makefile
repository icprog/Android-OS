#just for mtk platform head file, kernel version less than kernle 4.0
ccflags-y += -I$(srctree)/drivers/spi/mediatek/$(MTK_PLATFORM)

#just for mtk platform head file, kernel version larger than kernle 4.0
MTK_PLATFORM := $(subst ",,$(CONFIG_MTK_PLATFORM))
ccflags-y += -I$(srctree)/drivers/spi/mediatek/$(MTK_PLATFORM)
ccflags-y += -I$(srctree)/drivers/misc/mediatek/include
ccflags-y += -I$(srctree)/drivers/misc/mediatek/include/mt-plat/$(MTK_PLATFORM)/include
ccflags-y += -I$(srctree)/drivers/misc/mediatek/include/mt-plat
ifeq ($(CONFIG_MICROTRUST_TEE_SUPPORT),y)
ccflags-y += -I$(srctree)/drivers/misc/mediatek/teei/V1.0/tz_vfs
endif

ifeq ($(CONFIG_TRUSTONIC_TEE_SUPPORT),y)
subdir-ccflags-y += -I$(srctree)/drivers/spi/trustzone/spi/Tlspi/inc
	include $(srctree)/drivers/misc/mediatek/gud/Makefile.include
endif
subdir-ccflags-y += -I$(srctree)/drivers/misc/mediatek/tkcore/core

#sunwave driver file
obj-y          := sf_ctl.o sf_hw.o

