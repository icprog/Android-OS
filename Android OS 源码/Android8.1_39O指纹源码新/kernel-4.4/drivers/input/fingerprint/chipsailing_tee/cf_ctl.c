/**
 * ChipSailing Fingerprint sensor device driver
 *
 * This driver will control the platform resources that the ChipSailing fingerprint
 * sensor needs to operate. The major things are probing the sensor to check
 * that it is actually connected and let the Kernel know this and with that also
 * enabling and disabling of regulators, enabling and disabling of platform
 * clocks, controlling GPIOs such as SPI chip select, sensor reset line, sensor
 * IRQ line, MISO and MOSI lines.
 *
 * The driver will expose most of its available functionality in sysfs which
 * enables dynamic control of these features from eg. a user space process.
 *
 
 
 
 * The sensor's IRQ events will be pushed to Kernel's event handling system and
 * are exposed in the drivers event node. This makes it possible for a user
 * space process to poll the input node and receive IRQ events easily. Usually
 * this node is available under /dev/input/eventX where 'X' is a number given by
 * the event system. A user space process will need to traverse all the event
 * nodes and ask for its parent's name (through EVIOCGNAME) which should match
 * the value in device tree named input-device-name.
 *
 * This driver will NOT send any SPI commands to the sensor it only controls the
 * electrical parts.
 *
 *
 * Copyright (C) 2016 chipsailing Corporation. <http://www.chipsailing.com>
 * Copyright (C) 2016 XXX <mailto:xxx@chipsailing.com>
 *
 * This program is free software; you can redistribute it and/or modify it 
 * under the terms of the GNU General Public License as published by the Free 
 * Software Foundation; either version 2 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General 
 * Public License for more details.
 **/

#include <linux/clk.h>
#include <linux/delay.h>
#include <linux/gpio.h>
#include <linux/interrupt.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/mutex.h>
#include <linux/of.h>
#include <linux/of_gpio.h>
#include <linux/regulator/consumer.h>
#include <linux/spi/spi.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/uaccess.h>
#include <linux/fs.h>
#include <linux/of.h>
#include <linux/err.h>
#include <linux/of_platform.h>
#include <linux/pinctrl/consumer.h>
#include <linux/gpio.h>
#include <linux/of_irq.h>
#include <linux/input.h>
//#include <soc/qcom/scm.h>
#if defined(CONFIG_FB) //system-defined Macro!!
#include <linux/notifier.h>
#include <linux/fb.h>
#endif

#if defined(CONFIG_HAS_EARLYSUSPEND)  //system-defined Macro!!
#include <linux/earlysuspend.h>
/* Early-suspend level */
#define FT_SUSPEND_LEVEL 1
#endif

#include "cf_ctl.h"

#if defined(MTK_PLATFORM)
#include "mt_spi.h"
#include "mt_spi_hal.h"
#endif

#define MODULE_NAME "cf_ctl"
#ifndef CONFIG_OF
# error "error: this driver 'MODULE_NAME' only support dts."
#endif

#define ANDROID_WAKELOCK 1
#if ANDROID_WAKELOCK
#include <linux/wakelock.h>
#endif

//add for mdelay
#include <linux/delay.h>

#define CF_RESET_LOW_US      1000
#define CF_RESET_HIGH1_US    100
#define PWR_ON_STEP_SLEEP    100
#define PWR_ON_STEP_RANGE1   100
#define PWR_ON_STEP_RANGE2   900
#define CF_TTW_HOLD_TIME     1000



typedef enum {
	CF_PIN_STATE_RST_HIGH,
	CF_PIN_STATE_RST_LOW,
	CF_PIN_STATE_INT,
	CF_PIN_STATE_CLK,
	CF_PIN_STATE_CS,
	CF_PIN_STATE_MI,
	CF_PIN_STATE_MO,

	/* Array size */
	CF_PIN_STATE_MAX
} cf_pin_state_t;

static const char * const pctl_names[] = {
	"finger_reset_en1",//"cs_finger_reset_en1",
	"finger_reset_en0",//"cs_finger_reset_en0",
	"finger_int_as_int",//"cs_finger_int_as_int",
	"finger_spi0_clk_as_spi0_clk",//"cs_finger_spi0_clk_as_spi0_clk",
	"finger_spi0_cs_as_spi0_cs",//"cs_finger_spi0_cs_as_spi0_cs",
	"finger_spi0_mi_as_spi0_mi",//"cs_finger_spi0_mi_as_spi0_mi",
	"finger_spi0_mo_as_spi0_mo",//"cs_finger_spi0_mo_as_spi0_mo"
};

struct vreg_config {
	char *name;
	unsigned long vmin;
	unsigned long vmax;
	int ua_load;
};

static const struct vreg_config const vreg_conf[] = {
	{ "vdd_io", 1800000UL, 1800000UL, 6000, },
};


/**
 * Define the driver version string.
 * There is NO need to modify 'rXXXX_yyyymmdd', it should be updated automatically
 * by the building script (see the 'Driver-revision' section in 'build.sh').
 */
#define CF_DRV_VERSION "v1.9.1-rXXXX_20160502"

struct cf_device {
	struct device *dev;
	struct spi_device *spi;
	struct cdev     cdev;
	struct class*    class;
	struct device*   device;
	dev_t             devno;
	struct pinctrl *fingerprint_pinctrl;//wdong
	struct pinctrl_state *pinctrl_state[CF_PIN_STATE_MAX];
	struct clk *iface_clk;
	struct clk *core_clk;
	struct regulator *vreg[ARRAY_SIZE(vreg_conf)];
	struct input_dev *input;
	struct fasync_struct *async;
	struct work_struct work_queue;
	struct platform_device* pf_dev;

#if defined(MTK_PLATFORM) 
	struct mt_chip_conf spi_mcc;
	struct mt_spi_t *mt_spi;
#endif

#if defined(CONFIG_FB)
	struct notifier_block fb_notify;
#endif

#if defined(CONFIG_HAS_EARLYSUSPEND)
	struct early_suspend early_suspend;
#endif

	struct wake_lock ttw_wl;
	int irq;
	int irq_gpio;
	int rst_gpio;
	int pwr_gpio;
	int qup_id;
	struct mutex lock;
	spinlock_t spin_lock;
	bool prepared;
	atomic_t wakeup_enabled;
	bool irq_enabled;
	bool clocks_enabled;
	bool clocks_suspended;
    bool isPowerOn;
	u8 *buf;
};

/**************************debug******************************/
#define ERR_LOG  (0)
#define INFO_LOG (1)
#define DEBUG_LOG (2)

/* debug log setting */
u8 cf_debug_level = DEBUG_LOG;

#define cf_debug(level, fmt, args...) do { \
	if (cf_debug_level >= level) {\
		printk("chipsailing:[%s %d] " fmt, __func__, __LINE__, ##args);\
	} \
} while (0)

#define FUNC_ENTRY()  cf_debug(DEBUG_LOG, "entry\n")
#define FUNC_EXIT()  cf_debug(DEBUG_LOG, "exit\n")

/*************************************************************/
extern int cf_sfr_read(struct spi_device *spi, unsigned short addr, unsigned char *recv_buf, unsigned short buflen);


static int select_pinctl(struct cf_device *cf_dev, cf_pin_state_t state)
{
	int rc;
	//struct device *dev = cf_dev->dev;

	rc = pinctrl_select_state(cf_dev->fingerprint_pinctrl, cf_dev->pinctrl_state[state]);
	if (rc)
		cf_debug(INFO_LOG, "pinctrl_select_state(..) '%s' fail\n", pctl_names[state]);
	else
		cf_debug(INFO_LOG, "pinctrl_select_state(..) '%s' pass\n", pctl_names[state]);

	return rc;
}


static int hw_reset(struct cf_device *cf_dev, unsigned int delay_ms)
{
	int irq_gpio;
	int rst_gpio;

	int rc = select_pinctl(cf_dev, CF_PIN_STATE_RST_HIGH);
	if (rc)
		goto exit;
	FUNC_ENTRY();
	usleep_range(CF_RESET_HIGH1_US, CF_RESET_HIGH1_US + 100);
     //   mdelay((delay_ms > 1)?delay_ms:1);
      
	rc = select_pinctl(cf_dev, CF_PIN_STATE_RST_LOW);
	if (rc)
		goto exit;
	usleep_range(CF_RESET_LOW_US, CF_RESET_LOW_US + 100);
      //  mdelay((delay_ms > 1)?delay_ms:1);
    
	rc = select_pinctl(cf_dev, CF_PIN_STATE_RST_HIGH);
	if (rc)
		goto exit;
	usleep_range(CF_RESET_HIGH1_US, CF_RESET_HIGH1_US + 100);

	irq_gpio = gpio_get_value(cf_dev->irq_gpio);
    rst_gpio = gpio_get_value(cf_dev->rst_gpio);
	cf_debug(INFO_LOG, "IRQ after reset %d\n", irq_gpio);
	cf_debug(INFO_LOG, "RST after reset %d\n", rst_gpio);

exit:
	return rc;
}


/**
 * sysf node to check the interrupt status of the sensor, the interrupt
 * handler should perform sysf_notify to allow userland to poll the node.
 */
static ssize_t irq_get(struct device *device,
		struct device_attribute *attribute,
		char *buffer)
{
	struct cf_device *cf_dev = dev_get_drvdata(device);
	
	int irq = gpio_get_value(cf_dev->irq_gpio);
    cf_debug(INFO_LOG, "IRQ_GPIO 1111111111111= %d,irq = %d\n",cf_dev->irq_gpio,irq);
	return scnprintf(buffer, PAGE_SIZE, "%i\n", irq);
}


/**
 * writing to the irq node will just drop a printk message
 * and return success, used for latency measurement.
 */
static ssize_t irq_ack(struct device *device,
		struct device_attribute *attribute,
		const char *buffer, size_t count)
{
	//struct cf_device *cf_dev = dev_get_drvdata(device);
	cf_debug(INFO_LOG, "irq_ack\n");
	return count;
}
static DEVICE_ATTR(irq, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP, irq_get, irq_ack);

static struct attribute *attributes[] = {
	&dev_attr_irq.attr,
	NULL
};

static const struct attribute_group attribute_group = {
	.attrs = attributes,
};

static void cf_disable_irq(struct cf_device *cf_dev)
{
    FUNC_ENTRY();
    if (cf_dev->irq_enabled) 
    {
        disable_irq_nosync(cf_dev->irq);
        cf_dev->irq_enabled = false;
    }
}


static void cf_enable_irq(struct cf_device *cf_dev)
{
    FUNC_ENTRY();
    if (!cf_dev->irq_enabled) 
    {
        enable_irq(cf_dev->irq);
        cf_dev->irq_enabled = true;
    }	
}

static void cf_spi_disable_clk(struct cf_device *cf_dev)
{
#if (defined(MTK_PLATFORM) && defined(BEANPOD))
	//cf_dev->mt_spi = spi_master_get_devdata(cf_dev->spi->master);
	//if (cf_dev->mt_spi)
	     //	mt_spi_disable_clk(cf_dev->mt_spi);
              //  clk_disable(cf_dev->mt_spi->clk_main);
           cf_debug(INFO_LOG, "disable clk!\n");
              mt_spi_disable_master_clk(cf_dev->spi);
#else
	cf_debug(INFO_LOG, "not implemented!\n");
#endif
}

static void cf_spi_enable_clk(struct cf_device *cf_dev)
{
#if (defined(MTK_PLATFORM) && defined(BEANPOD))
	//cf_dev->mt_spi = spi_master_get_devdata(cf_dev->spi->master);
	//if (cf_dev->mt_spi)
		//mt_spi_enable_clk(cf_dev->mt_spi);
                //clk_enable(cf_dev->mt_spi->clk_main);
		cf_debug(INFO_LOG, "enable clk!\n");
                mt_spi_enable_master_clk(cf_dev->spi);			
#else
	cf_debug(INFO_LOG, "not implemented!\n");
#endif
}

static void cf_device_event(struct work_struct *ws)
{
	struct cf_device *cf_dev = container_of(ws, struct cf_device, work_queue);

	sysfs_notify(&cf_dev->pf_dev->dev.kobj, NULL, dev_attr_irq.attr.name);
}

static irqreturn_t cf_irq_handler(int irq, void * dev_id)
{
	struct cf_device *cf_dev =(struct cf_device *)dev_id;
	FUNC_ENTRY();

	/* Make sure 'wakeup_enabled' is updated before using it
	 ** since this is interrupt context (other thread...) */
	smp_rmb();

	if (atomic_read(&cf_dev->wakeup_enabled)) {
		wake_lock_timeout(&cf_dev->ttw_wl, msecs_to_jiffies(CF_TTW_HOLD_TIME));
	}
	
	schedule_work(&cf_dev->work_queue);

	return IRQ_HANDLED;
}

static int cf_request_named_gpio(struct cf_device *cf_dev,
		const char *label, int *gpio)
{
	int rc;
	struct device *dev = cf_dev->dev;
	struct device_node *np = dev->of_node;
	FUNC_ENTRY();

	cf_debug(ERR_LOG, "of_device_is_compatible:%d \n", of_device_is_compatible(np, CS_DRV_DTS_NAME)); //Returns 0 for no match //wdong
	cf_debug(ERR_LOG, "of_device_is_compatible:%d \n", of_device_is_compatible(cf_dev->spi->dev.of_node, SLAVE_SPI_DEV_NODE_DTS_NAME)); //Returns 0 for no match
	cf_debug(ERR_LOG, "of_get_property:%s rc:%d\n", (char *)of_get_property(np, "compatible", &rc) ,rc); 
	rc = of_get_named_gpio(np, label, 0);
	if (rc < 0) 
	{
		cf_debug(ERR_LOG, "failed to get '%s'\n", label);
		return rc;
	}
	*gpio = rc;
	if (gpio_is_valid(*gpio)) 
	{
		rc = gpio_request(*gpio, label);  //gpio_request(gpio, label)?
		if (rc) 
		{
			cf_debug(ERR_LOG, "failed to request gpio %d\n", *gpio);
			return rc;
		}		
	} 
	else
	{
		cf_debug(ERR_LOG, "not valid gpio: %d\n", *gpio);
		rc = -EIO;
		return rc;
	}

	cf_debug(ERR_LOG, "%s %d\n", label, *gpio);
	return 0;
}

static int cf_gpio_init(struct cf_device *cf_dev)
{
	int rc;
	FUNC_ENTRY();

	rc = cf_request_named_gpio(cf_dev, CS_INT_PIN_PROPERTY,
			&cf_dev->irq_gpio);
	if (rc)
		goto exit;
	rc = cf_request_named_gpio(cf_dev, CS_RST_PIN_PROPERTY,
			&cf_dev->rst_gpio);
	if (rc)
		goto exit;
	rc = cf_request_named_gpio(cf_dev, CS_PWR_PIN_PROPERTY,
			&cf_dev->pwr_gpio);
	if (rc)
		goto exit;
exit:
	return rc;		
}

/*power management*/
static int cf_power_on(struct cf_device *cf_dev)
{
/*
    if(gpio_is_valid(cf_dev->pwr_gpio))
	{
	    gpio_direction_output(cf_dev->pwr_gpio, 1);
    }
	
    cf_dev->isPowerOn = true;
    msleep(10);
 */   
	cf_debug(ERR_LOG, "power on\n");
    return 0;
}

static int cf_power_off(struct cf_device *cf_dev)
{
/*
    if(gpio_is_valid(cf_dev->pwr_gpio))
	{
	    gpio_direction_output(cf_dev->pwr_gpio, 0);
    }
    cf_dev->isPowerOn = false;
    msleep(10);
*/
    cf_debug(ERR_LOG, "power off\n");
    return 0;
}

static int cf_gpio_deinit(struct cf_device *cf_dev)
{
	int rc = 0;

  if (gpio_is_valid(cf_dev->irq_gpio))
      gpio_free(cf_dev->irq_gpio);
      
  if (gpio_is_valid(cf_dev->rst_gpio))
      gpio_free(cf_dev->rst_gpio);
            
	return rc;		
}

static int cf_pinctrl_look_up_states(struct cf_device *cf_dev)
{
	int rc = 0;
	size_t i;
	struct device *dev = cf_dev->dev;
	FUNC_ENTRY();

	cf_dev->fingerprint_pinctrl = devm_pinctrl_get(dev);//???//wdong
	if (IS_ERR(cf_dev->fingerprint_pinctrl)) 
	{
		cf_debug(ERR_LOG, "Target does not use pinctrl\n");
		cf_dev->fingerprint_pinctrl = NULL;
		rc = -EINVAL;
		goto exit;
	}

	for (i = 0; i < CF_PIN_STATE_MAX; i++) 
	{
		const char *n = pctl_names[i];
		struct pinctrl_state *state = pinctrl_lookup_state(cf_dev->fingerprint_pinctrl, n);
		if (IS_ERR(state)) 
		{
			cf_debug(ERR_LOG, "cannot find '%s'\n", n);
			rc = -EINVAL;
			goto exit;
		}
		cf_debug(INFO_LOG, "found pin control %s\n", n);

		cf_dev->pinctrl_state[i] = state;
	}

exit:
	return rc;
}


static int cf_irq_init(struct cf_device *cf_dev)
{
	int rc;
	int irqf;
	struct device *dev = cf_dev->dev;
	struct device_node *np = dev->of_node;
	u32 ints[2];

	irqf = IRQF_TRIGGER_RISING | IRQF_ONESHOT;

	select_pinctl(cf_dev, CF_PIN_STATE_INT);
	if (np) 
	{
		rc = of_property_read_u32_array(np, "debounce",ints,ARRAY_SIZE(ints));
		if (rc == 0) {
			  cf_debug(ERR_LOG, "gpio_set_debounce\n");
	           //cf_dev->irq_gpio = ints[0];
		    //gpio_set_debounce(ints[0], ints[1]);
                     gpio_set_debounce(13, ints[0]);
		}
		    
		cf_dev->irq = irq_of_parse_and_map(np, 0);   //dev->of_node
		if (!cf_dev->irq) 
		{
			cf_debug(ERR_LOG, "irq_of_parse_and_map(..) fail\n");
			rc = -EINVAL;
			goto exit;
		}
	} 
	else 
	{
		cf_debug(ERR_LOG, "device node is null\n");
		rc = -ENODEV;
		goto exit;
	}
	cf_debug(ERR_LOG, "irq_gpio= %d, irq_num = %d\n",cf_dev->irq_gpio,cf_dev->irq);
	rc = devm_request_threaded_irq(dev, cf_dev->irq, NULL, cf_irq_handler, irqf, "cf_irq", cf_dev);
	if (rc) 
	{
		cf_debug(ERR_LOG, "could not request irq %d\n", cf_dev->irq);
		goto exit;
	}

	enable_irq_wake(cf_dev->irq);	

exit:
	return rc;
}


static int cf_input_init(struct cf_device *cf_dev)
{
	//struct device *dev = cf_dev->dev;
	int rc;

	FUNC_ENTRY();
	cf_dev->input = input_allocate_device();
	if (!cf_dev->input) 
	{
		cf_debug(ERR_LOG ,"input_allocate_device(..) fail\n");
		return (-ENOMEM);
	}

	cf_dev->input->name = "cf-keys";
	__set_bit(EV_KEY  , cf_dev->input->evbit );
	__set_bit(KEY_HOME, cf_dev->input->keybit);
	__set_bit(KEY_MENU, cf_dev->input->keybit);
	__set_bit(KEY_BACK, cf_dev->input->keybit);
	__set_bit(KEY_F18, cf_dev->input->keybit);
	__set_bit(KEY_F19, cf_dev->input->keybit);
	__set_bit(KEY_F20, cf_dev->input->keybit);
	__set_bit(KEY_F21, cf_dev->input->keybit);
	__set_bit(KEY_ENTER, cf_dev->input->evbit );
	__set_bit(KEY_UP, cf_dev->input->keybit);
	__set_bit(KEY_LEFT, cf_dev->input->keybit);
	__set_bit(KEY_RIGHT, cf_dev->input->keybit);
	__set_bit(KEY_DOWN, cf_dev->input->keybit);
	__set_bit(KEY_WAKEUP, cf_dev->input->keybit);
	__set_bit(KEY_F5, cf_dev->input->keybit);
	__set_bit(KEY_F9, cf_dev->input->keybit);
	__set_bit(KEY_F7, cf_dev->input->keybit);
	__set_bit(KEY_F10, cf_dev->input->keybit);
	__set_bit(KEY_F8, cf_dev->input->keybit);
	__set_bit(KEY_F11, cf_dev->input->keybit);	
	rc = input_register_device(cf_dev->input);
	if (rc) 
	{
		cf_debug(ERR_LOG ,"input_register_device fail\n");
		input_free_device(cf_dev->input);
		cf_dev->input = NULL;
		return (-ENODEV);
	}

	FUNC_EXIT();
	return rc;
}


static int cf_reset_gpio_set_value(struct cf_device *cf_dev, unsigned char th)
{
	int rc;
	FUNC_ENTRY();

	if (cf_dev->rst_gpio == 0) 
	{
		cf_debug(ERR_LOG, "rst_gpio is not get\n");
	}

	if (!!th) 
		rc = select_pinctl(cf_dev, CF_PIN_STATE_RST_HIGH);
	else 
		rc = select_pinctl(cf_dev, CF_PIN_STATE_RST_LOW);
		
	return rc;
}

static int cf_report_key_event(struct input_dev* input, cf_key_event_t* kevent)
{
	int rc = 0;
	unsigned int key_code = KEY_UNKNOWN;
	FUNC_ENTRY();

	switch (kevent->key) {
		case CF_KEY_HOME:	  key_code = KEY_HOME;   break;
		case CF_KEY_MENU:	  key_code = KEY_MENU;   break;
		case CF_KEY_BACK:	  key_code = KEY_BACK;   break;
		case CF_KEY_DOWNUP:	 key_code = KEY_F18;    break;
		case CF_KEY_ONETAP:      key_code = KEY_F11;    break;
		case CF_KEY_DOUBLETAP:    key_code = KEY_F20;    break;
		case CF_KEY_LONGTOUCH:   key_code = KEY_F5;    break;
		case CF_KEY_ENTER:	 key_code = KEY_ENTER;  break;
		case CF_KEY_UP: 	  key_code = KEY_F7;	   break;
		case CF_KEY_LEFT:	  key_code = KEY_F9;   break;
		case CF_KEY_RIGHT:	key_code = KEY_F10;  break;
		case CF_KEY_DOWN:	  key_code = KEY_F8;   break;
		case CF_KEY_WAKEUP:   key_code = KEY_WAKEUP; break;

		default: break;
	}

	if (kevent->value == 2) 
	{
		input_report_key(input, key_code, 1);
		input_sync(input);	
		input_report_key(input, key_code, 0);
		input_sync(input);		
	} 
	else 
	{
		input_report_key(input, key_code, kevent->value);
		input_sync(input);		
	}
	FUNC_EXIT();
	return rc;	
}


static const char* cf_get_version(void)
{
	static char version[CF_DRV_VERSION_LEN] = {'\0', };
	FUNC_ENTRY();
	strncpy(version, CF_DRV_VERSION, CF_DRV_VERSION_LEN);
	version[CF_DRV_VERSION_LEN - 1] = '\0';
	return (const char*)version;
}


static int cf_open(struct inode* inode, struct file* file)
{
	struct cf_device *cf_dev;
	FUNC_ENTRY();
	cf_dev = container_of(inode->i_cdev, struct cf_device, cdev);
	file->private_data = cf_dev;
	return 0;	
}

static int cf_release(struct inode* inode, struct file* file)
{
	FUNC_ENTRY();
	return 0;
}

static ssize_t cf_write(struct file *file, const char __user *buf, size_t count, loff_t *offset)
{
	struct cf_device *cf_dev = file->private_data;
	u8 rxbuf[2] = {0};
	FUNC_ENTRY();
	hw_reset(cf_dev,1);
	cf_sfr_read(cf_dev->spi, 0x3e, rxbuf, 2);
	cf_debug(INFO_LOG, "rxbuf[0] = 0x%x, rxbuf[1] = 0x%x\n",rxbuf[0], rxbuf[1]);
	cf_debug(INFO_LOG, "irq_gpio = %d, goio_to_irq = %d, irq = %d\n",cf_dev->irq_gpio, gpio_to_irq(cf_dev->irq_gpio), cf_dev->irq);
	cf_debug(INFO_LOG, "rst_gpio_value = %d, irq_gpio_value = %d\n", gpio_get_value(cf_dev->rst_gpio), gpio_get_value(cf_dev->irq_gpio));
	FUNC_EXIT();
	return count;
}

static long cf_ioctl(struct file* file, unsigned int cmd, unsigned long arg)
{

	struct cf_device *cf_dev = NULL;
	int err = 0;
	unsigned char th = 0;
	cf_key_event_t kevent;

	cf_dev = file->private_data;
	FUNC_ENTRY();

	if(_IOC_TYPE(cmd)!=CF_IOC_MAGIC)
		return -ENOTTY;

	if(_IOC_DIR(cmd) & _IOC_READ)
		err = !access_ok(VERIFY_WRITE,(void __user*)arg,_IOC_SIZE(cmd));
	if(err==0 && _IOC_DIR(cmd)&_IOC_WRITE)
		err = !access_ok(VERIFY_READ,(void __user*)arg,_IOC_SIZE(cmd));
	if(err)
		return -EFAULT;	

	mutex_lock(&cf_dev->lock);
	switch (cmd) {
		case CF_IOC_INIT_GPIO: {
					       cf_debug(INFO_LOG, "CF_IOC_INIT_GPIO\n");
					       err = cf_gpio_init(cf_dev);
					       break;
				       }

		case CF_IOC_DEINIT_GPIO: {
						 cf_debug(INFO_LOG, "CF_IOC_DEINIT_GPIO\n");
						 err = cf_gpio_deinit(cf_dev);
						 break;
					 }

		case CF_IOC_RESET_DEVICE: {
						  cf_debug(INFO_LOG, "CF_IOC_RESET_DEVICE\n");
						  if (__get_user(th, (u8 __user*)arg)) 
						  {
							  cf_debug(ERR_LOG, "copy_from_user(..) fail\n");
							  err = (-EFAULT);
							  break;
						  }

						  cf_reset_gpio_set_value(cf_dev, th);
						  break;
					  }

		case CF_IOC_ENABLE_IRQ: {
					       cf_debug(INFO_LOG, "CF_IOC_ENABLE_IRQ\n");
					       cf_enable_irq(cf_dev);
					       break;
					}

		case CF_IOC_DISABLE_IRQ: {
					       cf_debug(INFO_LOG, "CF_IOC_DISABLE_IRQ\n");
					       cf_disable_irq(cf_dev);
					       break;
					 }

		case CF_IOC_REQ_IRQ: {
					       cf_debug(INFO_LOG, "CF_IOC_REQ_IRQ\n");
                 err = cf_irq_init(cf_dev);              
					       break;
					 }

		case CF_IOC_ENABLE_SPI_CLK: {
						    cf_spi_enable_clk(cf_dev);
						    cf_debug(INFO_LOG, "CF_IOC_ENABLE_SPI_CLK\n");
						    break;
					    }

		case CF_IOC_DISABLE_SPI_CLK: {
						    cf_spi_disable_clk(cf_dev);
						    cf_debug(INFO_LOG, "CF_IOC_DISABLE_SPI_CLK\n");
						    break;
					     }

		case CF_IOC_ENABLE_POWER: {
						    cf_debug(INFO_LOG, "CF_IOC_ENABLE_POWER\n");
							err= cf_power_on(cf_dev);
						    break;
					  }

		case CF_IOC_DISABLE_POWER: {
						    cf_debug(INFO_LOG, "CF_IOC_DISABLE_POWER\n");
							err= cf_power_off(cf_dev);
						    break;
					   }		

		case CF_IOC_REPORT_KEY_EVENT: {
						      if (copy_from_user(&kevent, (cf_key_event_t*)arg, sizeof(cf_key_event_t))) {
							      cf_debug(ERR_LOG, "copy_from_user(..) failed\n");
							      err = (-EFAULT);
							      break;
						      }

						      err = cf_report_key_event(cf_dev->input, &kevent);
						      break;
					      }

		case CF_IOC_GET_VERSION: {
						 if (copy_to_user((void*)arg, cf_get_version(), CF_DRV_VERSION_LEN)) {
							 cf_debug(ERR_LOG, "copy_to_user(..) failed\n");
							 err = (-EFAULT);
							 break;
						 }

						 break;
					 }
	
		default:
					   err = (-EINVAL);
					   break;		

	}

	mutex_unlock(&cf_dev->lock);
	return err;	
}

static int cf_fasync(int fd, struct file *fp, int mode)
{
	struct cf_device *cf_dev;
	FUNC_ENTRY();
	cf_dev = fp->private_data;
	return fasync_helper(fd, fp, mode, &cf_dev->async);
}

static const struct file_operations cf_fops =
{
	.owner			= THIS_MODULE,
	.open			= cf_open,
	.release		= cf_release,
	.unlocked_ioctl	= cf_ioctl,
	.fasync         = cf_fasync,
	.write          = cf_write,
};

#if defined(MTK_PLATFORM)
static struct mt_chip_conf cf_spi_conf =
{
	.setuptime = 7,//20,
	.holdtime = 7,//20,
	.high_time = 16,//50,
	.low_time = 17,//50,
	.cs_idletime = 3,// 5,
	.rx_mlsb = 1,
	.tx_mlsb = 1,
	.tx_endian = 0,
	.rx_endian = 0,
	.cpol = 0,
	.cpha = 0,
	.com_mod = FIFO_TRANSFER,
	.pause = 0,//1,
	.finish_intr = 1,
	.deassert = 0,
	.ulthigh = 0,
	.tckdly = 0,
};

static struct spi_board_info spi_fp_board_info[] __initdata =
{
	[0] = {
		.modalias = "chipsailing",
		.bus_num = 0,
		.chip_select = 0,
		.mode = SPI_MODE_0,
		.controller_data = &cf_spi_conf, //&spi_conf
	},
};

/* -------------------------------------------------------------------- */
/* cf_spi_setup, configure spi speed and transfer mode in REE mode
 *
 * speed: 1, 4, 6, 8 unit:MHz
 * mode: DMA mode or FIFO mode
 */

void cf_spi_setup(struct spi_device *spi, u32 speed, enum spi_transfer_mode mode)
{
	//struct cf_device *cf_dev = dev_get_drvdata(&spi->dev);
	struct mt_chip_conf *mcc = &cf_spi_conf;
	switch (speed) {
		case 1:
			/* set to 1MHz clock */
			mcc->high_time = 50;
			mcc->low_time = 50;
			break;
		case 4:
			/* set to 4MHz clock */
			mcc->high_time = 15;
			mcc->low_time = 15;
			break;
		case 6:
			/* set to 6MHz clock */
			mcc->high_time = 10;
			mcc->low_time = 10;
			break;
		case 8:
			/* set to 8MHz clock */
			mcc->high_time = 8;
			mcc->low_time = 8;
			break;
		default:
			/* default set to 1MHz clock */
			//mcc->high_time = 50;
			//mcc->low_time = 50;
			break;
	}

	if ((mode == DMA_TRANSFER) || (mode == FIFO_TRANSFER)) {
		mcc->com_mod = mode;
	} else {
		/* default set to FIFO mode */
		mcc->com_mod = FIFO_TRANSFER;
	}

	spi->controller_data = (void*)mcc;
	if (spi_setup(spi))
	    cf_debug(ERR_LOG, "spi_setup(..)fail\n");
}
#endif

#if defined(CONFIG_FB)
static int fb_notifier_callback(struct notifier_block* self, unsigned long event, void* data)
{
	struct fb_event *evdata = data;
	int* blank;
	struct cf_device *cf_dev = container_of(self, struct cf_device, fb_notify);
	if (evdata && evdata->data && cf_dev) 
	{
		if (event == FB_EVENT_BLANK) 
		{
			blank = evdata->data;
			if (*blank == FB_BLANK_UNBLANK) 
			{
				//TODO
				cf_debug(INFO_LOG, "LCD on\n");
			}
			else if (*blank == FB_BLANK_POWERDOWN) 
			{
				//TODO
				cf_debug(INFO_LOG, "LCD off\n");
			}
		}
	}

	return 0;
}
#endif

#if defined(CONFIG_HAS_EARLYSUSPEND)

static void cf_early_suspend(struct early_suspend *handler)
{
	struct cf_device *cf_dev = container_of(handler, struct cf_device, early_suspend);

	//TODO
	cf_debug(INFO_LOG, "LCD off-3");
}

static void cf_late_resume(struct early_suspend *handler)
{
	struct cf_device *cf_dev = container_of(handler, struct cf_device, early_suspend);

	//TODO
	cf_debug(INFO_LOG, "LCD on-3");
}
#endif

extern void fingerprint_set_name(char* name); //xen 20180202
static int cf_probe(struct spi_device *spi)
{
        
	int rc = 0;
	struct device *dev;
	struct device_node *np;
	struct cf_device *cf_dev;
	struct platform_device *pdev;
	//u32 val;
    FUNC_ENTRY();
	#if defined(CONFIG_MTK_ENG_BUILD)
	np = of_find_compatible_node(NULL, NULL, "mediatek,wdong_finger");
	cf_debug(ERR_LOG, "of_get_property:%s rc:%d\n", (char *)of_get_property(np, "compatible", &rc), rc); 
	np = of_find_compatible_node(NULL, NULL, "android,trusty-smc-v1");
	cf_debug(ERR_LOG, "of_get_property:%s rc:%d\n", (char *)of_get_property(np, "compatible", &rc), rc); 
	np = of_find_compatible_node(NULL, NULL, "mediatek,mt_pmic");
	cf_debug(ERR_LOG, "of_get_property:%s rc:%d\n", (char *)of_get_property(np, "compatible", &rc), rc); 
	#endif
	np = of_find_compatible_node(NULL, NULL, CS_DRV_DTS_NAME);
	cf_debug(ERR_LOG, "of_get_property:%s rc:%d\n", (char *)of_get_property(np, "compatible", &rc), rc); 
	if (IS_ERR(np)) 
	{
		cf_debug(ERR_LOG, "device node is null\n");
		rc = (-EINVAL);
		goto exit;
	}
	cf_debug(ERR_LOG, "of_get_property:%s rc:%d\n", (char *)of_get_property(spi->dev.of_node, "compatible", &rc), rc); 
	cf_debug(ERR_LOG, "of_get_property:%s rc:%d\n", (char *)of_get_property(np, "compatible", &rc), rc); 

	pdev = of_find_device_by_node(np);
	if (IS_ERR(pdev)) 
	{
		cf_debug(ERR_LOG, "platform device is null\n");
		rc = PTR_ERR(pdev);
		goto exit;
	}
	dev = &pdev->dev; //===> &spi->dev;
	cf_debug(INFO_LOG, "liuxingyu cf probe 11111 \n");	
	cf_dev = devm_kzalloc(dev, sizeof(*cf_dev), GFP_KERNEL);
	if (!cf_dev)
	{
		cf_debug(ERR_LOG,	"failed to allocate memory for struct cf_device");
		rc = -ENOMEM;
		goto exit;
	}

	cf_dev->dev = dev;
	dev_set_drvdata(dev, cf_dev);
	cf_debug(DEBUG_LOG, "setup SPI, Initialize the driver data\n");
	cf_dev->spi = spi;
	//setup SPI
	cf_dev->spi->mode            = SPI_MODE_0;
	cf_dev->spi->bits_per_word   = 8;
	cf_dev->spi->max_speed_hz    = 1 * 1000 * 1000;
#if defined(MTK_PLATFORM)    
	//memcpy(&cf_dev->spi_mcc, &cf_spi_conf, sizeof(struct mt_chip_conf));
	//cf_dev->spi->controller_data = (void *)&cf_dev->spi_mcc;
	cf_dev->spi->controller_data = (void *)&cf_spi_conf;
#endif	
	spi_setup(cf_dev->spi);

	cf_dev->class = class_create(THIS_MODULE, FP_CLASS_NAME);
	rc = alloc_chrdev_region(&cf_dev->devno, 0, 1, FP_DEV_NAME);
	if (rc) 
	{
		cf_debug(ERR_LOG, "alloc_chrdev_region failed, error = %d\n", rc);
		goto exit;
	}
	cf_dev->device = device_create(cf_dev->class, NULL, cf_dev->devno, NULL, "%s", FP_DEV_NAME);
	cdev_init(&cf_dev->cdev, &cf_fops);
	cf_dev->cdev.owner = THIS_MODULE;

	rc = cdev_add(&cf_dev->cdev, cf_dev->devno, 1);
	if (rc) 
	{
		cf_debug(ERR_LOG, "cdev_add failed, error = %d\n", rc);
		goto exit;
	}	
	cf_debug(INFO_LOG, "liuxingyu cf probe 22222 \n");	
	
	rc = cf_gpio_init(cf_dev);
	if (rc) 
	{
		cf_debug(ERR_LOG, "Failed to get gpio\n");
		//goto exit;
	}

	cf_debug(INFO_LOG, "liuxingyu cf probe 44444 \n");	

	rc = cf_pinctrl_look_up_states(cf_dev);
	if (rc)
		goto exit;
	cf_debug(INFO_LOG, "liuxingyu cf probe 77777 \n");	
#if defined(MTK_PLATFORM)
		rc = select_pinctl(cf_dev, CF_PIN_STATE_CLK);
		if (rc)
		    goto exit;

		rc = select_pinctl(cf_dev, CF_PIN_STATE_CS);
		if (rc)
		    goto exit;

  		rc = select_pinctl(cf_dev, CF_PIN_STATE_MI);
		if (rc)
		    goto exit;
		rc = select_pinctl(cf_dev, CF_PIN_STATE_MO);
		if (rc)
		    goto exit;
#endif
    cf_debug(INFO_LOG, "liuxingyu cf probe 88888 \n");	

	cf_dev->clocks_enabled = false;
	cf_dev->clocks_suspended = false;

	mutex_init(&cf_dev->lock);
	spin_lock_init(&cf_dev->spin_lock);
	wake_lock_init(&cf_dev->ttw_wl, WAKE_LOCK_SUSPEND, "cf_ttw_wl");

	atomic_set(&cf_dev->wakeup_enabled, 1);
	
	INIT_WORK(&cf_dev->work_queue, cf_device_event);
	cf_debug(INFO_LOG, "liuxingyu cf probe 10 10 10 10 10 \n");	
        /*input init*/
	cf_debug(INFO_LOG, "input init \n");
	rc = cf_input_init(cf_dev);
	if (rc) 
	{
		cf_debug(ERR_LOG, "could not register input\n");
		goto exit;
	}
       
       /*irq init*/
	cf_debug(INFO_LOG, "irq init \n");
    rc = cf_irq_init(cf_dev);
	if (rc) 
	{
		cf_debug(ERR_LOG, "could not request irq\n");
		goto exit;
	}
    cf_dev->pf_dev = platform_device_alloc(FP_DEV_NAME, -1);
    if (!cf_dev->pf_dev)
    {
        rc = -ENOMEM;
        cf_debug(ERR_LOG,"platform_device_alloc failed\n");
        goto exit;
    }
    rc = platform_device_add(cf_dev->pf_dev);

    if (rc)
    {
        cf_debug(ERR_LOG,"platform_device_add failed\n");
        platform_device_del(cf_dev->pf_dev);
        goto exit;
    }
    else
    {
        dev_set_drvdata(&cf_dev->pf_dev->dev, cf_dev);

		cf_debug(INFO_LOG, "sysfs create group \n");
        rc = sysfs_create_group(&cf_dev->pf_dev->dev.kobj, &attribute_group);

        if (rc)
        {
            cf_debug(ERR_LOG,"sysfs_create_group failed\n");
            goto exit;
        }
    }

#if defined(CONFIG_FB)
	cf_dev->fb_notify.notifier_call = fb_notifier_callback;
	fb_register_client(&cf_dev->fb_notify);
#endif

#if defined(CONFIG_HAS_EARLYSUSPEND)
	cf_dev->early_suspend.level = EARLY_SUSPEND_LEVEL_BLANK_SCREEN +
		FT_SUSPEND_LEVEL;
	cf_dev->early_suspend.suspend = cf_early_suspend;
	cf_dev->early_suspend.resume = cf_late_resume;
	register_early_suspend(&cf_dev->early_suspend);
#endif	
	//fingerprint_set_name("CS2511_TEE"); //xen 20180202     //wdong
        /*硬件复位芯片*/
		
	cf_debug(INFO_LOG, "Hardware reset chip \n");
    hw_reset(cf_dev,1);
	FUNC_EXIT();
exit:
	return rc;
}

static int cf_remove(struct spi_device *spi)
{
	struct cf_device *cf_dev = dev_get_drvdata(&spi->dev);

#if defined(CONFIG_HAS_EARLYSUSPENDCONFIG_HAS_EARLYSUSPEND)
	unregister_early_suspend(&cf_dev->early_suspend);
#endif

#if defined(CONFIG_FB)
	if (cf_dev->fb_notify.notifier_call) 
	{
		cf_dev->fb_notify.notifier_call = NULL;
		fb_unregister_client(&cf_dev->fb_notify);
	}
#endif

	sysfs_remove_group(&cf_dev->pf_dev->dev.kobj, &attribute_group);
	mutex_destroy(&cf_dev->lock);
	wake_lock_destroy(&cf_dev->ttw_wl);

	//(void)vreg_setup(cf_dev, "vdd_io", false);
	cf_power_off(cf_dev);
	FUNC_EXIT();
	return 0;
}

static int cf_suspend(struct device *dev)
{
#if 0
	struct cf_device *cf_dev = dev_get_drvdata(dev);

	cf_dev->clocks_suspended = cf_dev->clocks_enabled;
	if (!cf_dev->clocks_suspended)
	    //set_clks(cf_dev, false);
	
	if (cf_dev->isPowerOn)
		cf_power_off(cf_dev);

	//TODO
	cf_debug(INFO_LOG, "LCD off-2\n");	
#endif
	return 0;

}

static int cf_resume(struct device *dev)
{
#if 0
	struct cf_device *cf_dev = dev_get_drvdata(dev);

	if (cf_dev->clocks_suspended)
		//set_clks(cf_dev, true);

  if (!cf_dev->isPowerOn)
      cf_power_on(cf_dev);
	
	//TODO
	cf_debug(INFO_LOG, "LCD on-2\n");
#endif
	return 0;
}

static const struct dev_pm_ops cf_pm_ops = {
	.suspend = cf_suspend,
	.resume = cf_resume,
};

struct spi_device_id chipsailing_id_table = {"chipsailing", 0};

static struct of_device_id cf_of_match[] = {
	{ .compatible = SLAVE_SPI_DEV_NODE_DTS_NAME, },
	{ .compatible = "mediatek,cs358_finger", },
	{ .compatible = "mediatek,cs2511_finger", },
	{}
};
MODULE_DEVICE_TABLE(of, cf_of_match);

static struct spi_driver cf_driver = {
	.driver = {
		.name	= "chipsailing",
		.owner	= THIS_MODULE,
		.of_match_table = cf_of_match,
		.pm = &cf_pm_ops,
	},
	.probe		= cf_probe,
	.remove		= cf_remove,
	.id_table = &chipsailing_id_table,
};


static int __init cf_driver_init(void)
{
	int rc;
	FUNC_ENTRY();

#if defined(MTK_PLATFORM)
#pragma message("MTK_PLATFORM is defined!!!\n") 
	spi_register_board_info(spi_fp_board_info, ARRAY_SIZE(spi_fp_board_info));
#endif

	rc = spi_register_driver(&cf_driver);
	if (!rc)
		cf_debug(ERR_LOG, "spi_register_driver(..) pass\n");
	else
		cf_debug(ERR_LOG, "spi_register_driver(..) fail, error = %d\n", rc);

	return rc;
}

static void __exit cf_driver_exit(void)
{
	FUNC_ENTRY();
	spi_unregister_driver(&cf_driver);
}

module_init(cf_driver_init);
module_exit(cf_driver_exit);

MODULE_LICENSE("GPL v2");
MODULE_AUTHOR("zwp@chipsailing.com");
MODULE_DESCRIPTION("ChipSailing Fingerprint sensor device driver.");
