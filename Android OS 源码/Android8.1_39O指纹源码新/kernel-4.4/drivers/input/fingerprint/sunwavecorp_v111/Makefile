
#ccflags-y +=-I$(srctree)/drivers/spi/mediatek/mt6797/

ccflags-y += -Wno-error
EXTRA_CFLAGS +=-Wno-date-time

MODFLAGS       =$(MODFLAGS)  -DMODULE -fno-pic  

obj-y += sunwavecorp.o platform.o misce.o mt6797_dts.o mt6797_dts_plat.o
# sunwave-objs := sunwavecorp.o platform.o misce.o mt6797_dts.o mt6797_dts_plat.o

#ifdef CONFIG_SUNWAVECORP_MT6797
#sunwave-objs +=  mt6797_dts.o
#obj-$(CONFIG_SUNWAVE_FINGERPRINT)   = sunwave.o mt6797_dts_plat.o
#endif

