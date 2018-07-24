#ifndef __SF_USER_H__
#define __SF_USER_H__

#include "sf_def.h"

//-----------------------------------------------------------------------------

// platform select
#define SF_PLATFORM_SEL             SF_TEE_BEANPOD
// compatible select
#define SF_COMPATIBLE_SEL           SF_COMPATIBLE_NOF
// power mode select
#define SF_POWER_MODE_SEL           PWR_MODE_NOF
// debug log select
#define SF_LOG_ENABLE               1
//-----------------------------------------------------------------------------

/* Dts node. */
#define COMPATIBLE_SW_FP            "mediatek,sunwave_fp"

// for not mtk
#define COMPATIBLE_RESET_GPIO       "sunwave,gpio_reset"
#define COMPATIBLE_IRQ_GPIO         "sunwave,gpio_irq"
#define COMPATIBLE_PWR_GPIO         "sunwave,gpio_pwr"

//for mtk pinctl system
#define FINGER_POWER_ON             "finger_power_high"
#define FINGER_POWER_OFF            "finger_power_low"
#define FINGER_RESET_LOW            "finger_reset_en0"
#define FINGER_RESET_HIGH           "finger_reset_en1"
#define FINGER_INT_SET              "finger_int_as_int"
// spi dts config enable
#define SF_SPI_DTS_CS               1
#define SF_SPI_DTS_Ck               1
#define SF_SPI_DTS_MI               1
#define SF_SPI_DTS_MO               1
#define SF_SPI_DTS_MI_PU            0
#define SF_SPI_DTS_MI_PD            0
#define SF_SPI_DTS_MO_PU            0
#define SF_SPI_DTS_MO_PD            0
#define FINGER_CS_SET               "finger_spi0_cs_as_spi0_cs"
#define FINGER_CK_SET               "finger_spi0_clk_as_spi0_clk"
#define FINGER_MI_SET               "finger_spi0_mi_as_spi0_mi"
#define FINGER_MO_SET               "finger_spi0_mo_as_spi0_mo"
#define FINGER_MI_PU                "miso_pull_up"
#define FINGER_MI_PD                "miso_pull_down"
#define FINGER_MO_PU                "mosi_pull_up"
#define FINGER_MO_PD                "mosi_pull_down"

/* regulator VDD select */
#define SF_VDD_NAME                 "VDD"
#define SF_VDD_MIN_UV               2800000
#define SF_VDD_MAX_UV               2800000
//-----------------------------------------------------------------------------

#define ANDROID_WAKELOCK            1
#define SF_INT_TRIG_HIGH            0
//-----------------------------------------------------------------------------

//for mtk6739 kernel4.4 spi speed mode
#ifdef CONFIG_MACH_MT6739
#define MTK_6739_SPEED_MODE         1
#else
#define MTK_6739_SPEED_MODE         0
#endif
//-----------------------------------------------------------------------------
#if (SF_PLATFORM_SEL == SF_REE_MTK_L5_X)
//android mtk androidL 5.x none dts config file
#define MTK_L5_X_POWER_ON           1
#define MTK_L5_X_IRQ_SET            0

//power GPIO
#if MTK_L5_X_POWER_ON
#define  GPIO_SW_PWR_PIN            GPIO_FIGERPRINT_PWR_EN_PIN
#define  GPIO_SW_PWR_M_GPIO         GPIO_MODE_00
#endif

//interrupt pin
#define  GPIO_SW_IRQ_NUM            CUST_EINT_FIGERPRINT_INT_NUM
#define  GPIO_SW_INT_PIN            GPIO_FIGERPRINT_INT

//reset pin
#define  GPIO_SW_RST_PIN            GPIO_FIGERPRINT_RST
#define  GPIO_SW_RST_PIN_M_GPIO     GPIO_MODE_00

#define  GPIO_SW_RST_M_DAIPCMOUT    GPIO_MODE_01

//interrupt mode
#if MTK_L5_X_IRQ_SET
#define  GPIO_SW_EINT_PIN_M_GPIO    GPIO_FIGERPRINT_INT_M_GPIO //GPIO_MODE_00
#define  GPIO_SW_EINT_PIN_M_EINT    GPIO_FIGERPRINT_INT_M_EINT //GPIO_MODE_00
#endif

#endif
//-----------------------------------------------------------------------------
#include "sf_auto.h"

#endif
