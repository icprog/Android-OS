#include "finger.h"
#include "config.h"
#include <linux/gpio.h>
#include <linux/interrupt.h>
#include <linux/of_irq.h>
#include <linux/completion.h>
#include <linux/delay.h>

#ifdef CONFIG_OF
#include <linux/of.h>
#include <linux/of_address.h>
#include <linux/of_irq.h>
#endif
#if !__PALTFORM_KERNEL_VER4
#include <mt_spi.h>//bd6737m_65_a_n\release\alps\kernel-3.18\drivers\spi\mediatek\mt6735
#endif
//------------------------------------------------------------------------------
#ifdef _DRV_TAG_
#undef _DRV_TAG_
#endif
#define _DRV_TAG_ "sunwav_dts"

/**
 * this function olny use thread ex.open
 *
 */

typedef enum DTS_STATE {
	STATE_DEFAULT,
    STATE_CS_CLR,
    STATE_CS_SET,
    STATE_MI_CLR,
    STATE_MI_SET,
    STATE_MO_CLR,
    STATE_MO_SET,
    STATE_CLK_CLR,
    STATE_CLK_SET,
    STATE_RST_CLR,
    STATE_RST_SET,
    STATE_EINT,
    STATE_EINT_CLR,
    STATE_EINT_SET,
    STATE_2V8_ON,
    STATE_2V8_OFF,
    STATE_MAX,  /* array size */
} dts_status_t;

static struct pinctrl* this_pctrl = NULL; /* static pinctrl instance */

/* DTS state mapping name */
static const char* dts_state_name[STATE_MAX] = {
	"spi_default",
	"spi_cs_clr",
	"spi_cs_set",
	"spi_mi_clr",
	"spi_mi_set",
	"spi_mo_clr",
	"spi_mo_set",
	"spi_mclk_clr",
	"spi_mclk_set",
	"finger_rst_clr",
	"finger_rst_set",
	"eint",
	"eint_clr",
	"eint_set",
	"fp_state_pwr_on",
	"fp_state_pwr_off"
};

/* pinctrl implementation */
inline static long dts_set_state(const char* name)
{
    long ret = 0;
    struct pinctrl_state* pin_state = NULL;

	sw_info("%s start name=%s\n",__func__,name);

    BUG_ON(!this_pctrl);
    pin_state = pinctrl_lookup_state(this_pctrl, name);

    if (IS_ERR(pin_state)) {
        pr_err("sunwave ----finger set state '%s' failed\n", name);
        ret = PTR_ERR(pin_state);
        return ret;
    }
	else sw_info("sunwave ----finger set state %s success!\n",name);

    //sw_info("sunwave ---- dts_set_state = %s \n", name);
    /* select state! */
    ret = pinctrl_select_state(this_pctrl, pin_state);

    if ( ret < 0) {
        sw_info("sunwave --------pinctrl_select_state %s failed\n", name);
    }
	else sw_info("sunwave ----finger set state %s success!\n", name);
    return ret;
}


inline static long dts_select_state(dts_status_t s)
{
	sw_info("%s start ",__func__);
    BUG_ON(!((unsigned int)(s) < (unsigned int)(STATE_MAX)));
    return dts_set_state(dts_state_name[s]);
}
int mt6797_dts_spi_mod(struct spi_device**  spi)
{
	sw_info("%s start ",__func__);
    dts_select_state(STATE_CS_SET);
    dts_select_state(STATE_MI_SET);
    dts_select_state(STATE_MO_SET);
    dts_select_state(STATE_CLK_SET);
    return 0;
}

int mt6797_dts_reset(struct spi_device**  spi)
{
	sw_info("%s start ",__func__);
    dts_select_state(STATE_RST_SET);
    //dts_select_state(STATE_EINT_SET);
    msleep(10);
    dts_select_state(STATE_RST_CLR);
    //dts_select_state(STATE_EINT_CLR);
    msleep(20);
    dts_select_state(STATE_RST_SET);
    //dts_select_state(STATE_EINT_SET);
    return 0;
}

static int  mt6797_dts_gpio_init(struct spi_device**   spidev)
{
    sunwave_sensor_t*  sunwave = spi_to_sunwave(spidev);
    struct device_node* finger_irq_node = NULL;
    struct spi_device*   spi = *spidev;
    /* set power pin to high */
	sw_info("%s start ",__func__);
#ifdef CONFIG_OF
    spi->dev.of_node = of_find_compatible_node(NULL, NULL, "mediatek,sunwave_finger");
    this_pctrl = devm_pinctrl_get(&spi->dev);

    if (IS_ERR(this_pctrl)) {
        //int ret = PTR_ERR(this_pctrl);
        dev_err(&spi->dev, "fwq Cannot find fp pctrl!\n");
        return -ENODEV;
    }

    //dts_select_state(STATE_DEFAULT);
    dts_select_state(STATE_2V8_ON);
    mt6797_dts_reset(&spi);
    mt6797_dts_spi_mod(&spi);
    dts_select_state(STATE_EINT);
    //finger_irq_node = of_find_compatible_node(NULL, NULL, "mediatek,fingerprint-eint");
    finger_irq_node = of_find_compatible_node(NULL, NULL, "mediatek,sunwave_finger");//clw modify

    if (finger_irq_node) {
        u32 ints[2] = {0};
        of_property_read_u32_array(finger_irq_node, "debounce", ints, ARRAY_SIZE(ints));
        gpio_set_debounce(ints[0], ints[1]);
        sunwave->standby_irq = irq_of_parse_and_map(finger_irq_node, 0);
		sw_info("sunwave->standby_irq=%d \n",sunwave->standby_irq);
    }
    else {
        return -ENOMEM;
    }

#endif
    return 0;
}


static int  mt6797_dts_irq_hander(struct spi_device** spi)
{
    spi_to_sunwave(spi);
    return 0;
}


static int mt6797_dts_speed(struct spi_device**    spi, unsigned int speed)
{
#if (!__PALTFORM_KERNEL_VER4)
#define SPI_MODULE_CLOCK   (100*1000*1000)
    struct mt_chip_conf* config;
    unsigned int    time = SPI_MODULE_CLOCK / speed;
    config = (struct mt_chip_conf*)(*spi)->controller_data;
    config->low_time = time / 2;
    config->high_time = time / 2;

    if (time % 2) {
        config->high_time = config->high_time + 1;
    }

#endif
    return 0;
}

static finger_t  finger_sensor = {
    .ver                    = 0,
#if __SUNWAVE_SPI_DMA_MODE_EN
    .attribute              = DEVICE_ATTRIBUTE_NONE,
#else // SPI FIFO MODE
    .attribute              = DEVICE_ATTRIBUTE_SPI_FIFO,
#endif

    .write_then_read        = 0,
    .irq_hander             = mt6797_dts_irq_hander,
    .irq_request            = 0,
    .irq_free               = 0,
    .init                   = mt6797_dts_gpio_init,
    .reset                  = mt6797_dts_reset,
    .speed          = mt6797_dts_speed,
};


void mt6797_dts_register_finger(sunwave_sensor_t*    sunwave)
{
    sunwave->finger = &finger_sensor;
}
EXPORT_SYMBOL_GPL(mt6797_dts_register_finger);
