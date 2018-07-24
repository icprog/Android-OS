#include <linux/init.h>
#include <linux/module.h>
#include <linux/device.h>
#include <linux/spi/spi.h>
#include <linux/workqueue.h>
#include <linux/interrupt.h>
#include <linux/irqreturn.h>
#include <linux/types.h>
#include <linux/io.h>
#include <linux/sched.h>
#include <linux/kthread.h>
#include <linux/cdev.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include <linux/spi/spidev.h>
#include <linux/semaphore.h>
#include <linux/list.h>
#include <linux/mutex.h>
#include <linux/slab.h>
#include <linux/ioctl.h>
#include <linux/version.h>
#include <linux/wait.h>
#include <linux/input.h>
#include <linux/miscdevice.h>


#include <linux/signal.h>
#include <linux/ctype.h>
#include <linux/wakelock.h>
#include <linux/kobject.h>
#include <linux/poll.h>

#ifdef CONFIG_COMPAT
#include <linux/compat.h>
#endif

#ifdef CONFIG_OF
#include <linux/of.h>
#include <linux/of_irq.h>
#include <linux/of_platform.h>
#endif

#if defined(CONFIG_FB)
#include <linux/notifier.h>
#include <linux/fb.h>
#endif

#ifdef CONFIG_HAS_EARLYSUSPEND
#include <linux/earlysuspend.h>
#else
#include <linux/notifier.h>
#endif

#include <net/sock.h>
#include <linux/spi/spi.h>
#include <linux/spi/spidev.h>
#include <linux/delay.h>
#include <linux/notifier.h>


#include <linux/fb.h>

#include <linux/of_gpio.h>

#include <linux/platform_data/spi-mt65xx.h>

/* MTK header */
//#include <mach/irqs.h>
#include <mach/emi_mpu.h>
//#include <mach/mt_clkmgr.h>
//#include <mt_chip.h>

#include "bf_tee_spi.h"

#define BF_IOCTL_MAGIC_NO			0xFC

#define BF_IOCTL_INIT                   	_IO(BF_IOCTL_MAGIC_NO,   0)
#define BF_IOCTL_CAPTURE_MODE               _IOW(BF_IOCTL_MAGIC_NO,  1, uint32_t)
#define BF_IOCTL_RESET                      _IO(BF_IOCTL_MAGIC_NO,  2)
#define BF_IOCTL_INTERRUPT_MODE         	_IOW(BF_IOCTL_MAGIC_NO,  3, uint32_t)
#define BF_IOCTL_DISABLE_INTERRUPT          _IOW(BF_IOCTL_MAGIC_NO,  4, uint32_t)
#define BF_IOCTL_ENABLE_POWER               _IO(BF_IOCTL_MAGIC_NO, 5)
#define BF_IOCTL_DISABLE_POWER              _IO(BF_IOCTL_MAGIC_NO, 6)
#define BF_IOCTL_INIT_ARGS                  _IOWR(BF_IOCTL_MAGIC_NO, 7,uint32_t)
#define BF_IOCTL_GAIN_ADJUST                _IOWR(BF_IOCTL_MAGIC_NO, 8,uint32_t)
#define BF_IOCTL_GET_ID                     _IOWR(BF_IOCTL_MAGIC_NO, 9, uint32_t)
#define BF_IOCTL_ENABLE_SPI_CLOCK           _IOW(BF_IOCTL_MAGIC_NO,  10,uint32_t)
#define BF_IOCTL_DISABLE_SPI_CLOCK          _IOW(BF_IOCTL_MAGIC_NO,  11,uint32_t)
#define BF_IOCTL_INPUT_KEY                  _IOW(BF_IOCTL_MAGIC_NO,  12,uint32_t)
#define BF_IOCTL_ENBACKLIGHT               	_IOW(BF_IOCTL_MAGIC_NO,  13,uint32_t)
#define BF_IOCTL_ISBACKLIGHT               	_IOWR(BF_IOCTL_MAGIC_NO, 14,uint32_t)
#define BF_IOCTL_NAV_MODE                   _IOW(BF_IOCTL_MAGIC_NO,  15,uint32_t)
#define BF_IOCTL_REMOVE_DEVICE              _IOW(BF_IOCTL_MAGIC_NO,  16,uint32_t)
#define BF_IOCTL_INPUT_KEY_DOWN             _IOW(BF_IOCTL_MAGIC_NO,  17,uint32_t)
#define BF_IOCTL_INPUT_KEY_UP               _IOW(BF_IOCTL_MAGIC_NO,  18,uint32_t)
#define BF_IOCTL_DISPALY_STATUS             _IOW(BF_IOCTL_MAGIC_NO,  19,uint32_t)
#define BF_IOCTL_SET_PID                    _IOW(BF_IOCTL_MAGIC_NO,  20,uint32_t)
#define BF_IOCTL_GET_IMAGE                  _IOW(BF_IOCTL_MAGIC_NO,  21, uint32_t)
#define BF_IOCTL_REGISTER_READ	        	_IOWR(BF_IOCTL_MAGIC_NO, 22, uint32_t)
#define BF_IOCTL_REGISTER_WRITE	        	_IOWR(BF_IOCTL_MAGIC_NO, 23, uint32_t)

typedef enum bf_key {
    BF_KEY_NONE = 0,
    BF_KEY_POWER,
    BF_KEY_CAMERA,
    BF_KEY_UP,
    BF_KEY_DOWN,
    BF_KEY_RIGHT,
    BF_KEY_LEFT,
    BF_KEY_HOME,
    BF_KEY_F10,
	BF_KEY_F11
} bf_key_t;

#if defined(CONFIG_FB)
static struct notifier_block fb_notif;
static volatile int display_status = 0;
#endif
#ifdef FAST_VERSION
extern void lcm_on(void);
extern void lcm_off(void);
#endif
static LIST_HEAD (device_list);
static DEFINE_MUTEX (device_list_lock);

/* for netlink use */
static int g_pid;
struct bf_device *g_bf_dev=NULL;
static struct input_dev *bf_inputdev = NULL;
static uint32_t bf_key_need_report = 0;
#ifdef BF_REE
btl_ta_chip_parmas btl_chip_parmas_t;
btl_reg_value *btl_init_params = NULL;
int IM_HEIGHT = 0;
int IM_WIDTH = 0;
u32 g_chip_type = 0x5383;
#endif
/*#if 1//def CONFIG_MTK_CLKMGR

static struct mt_chip_conf spi_init_conf = {

	.setuptime = 10,
	.holdtime = 10,
	.high_time = 8, //\B4˴\A6\BE\F6\B6\A8slk\B5\C4Ƶ\C2\CA
	.low_time =  8,
	.cs_idletime = 20, //10,
	//.ulthgh_thrsh = 0,

	.cpol = 0,
	.cpha = 0,

	.rx_mlsb = 1,  //\CF\810\A89\AB\B8\DF\A6\CB
	.tx_mlsb = 1,

	.tx_endian = 0, //tx_endian \B1\ED\810\B65\B4\F3\B6\CB\810\8F0\810\B64
	.rx_endian = 0,

	.com_mod = FIFO_TRANSFER,
	.pause = 1,
	.finish_intr = 1,
	.deassert = 0,
	.ulthigh = 0,
	.tckdly = 0,


};
#endif
*/
static struct mtk_chip_config spi_init_conf = {
	.cs_pol = 0,
	.rx_mlsb = 1,
	.tx_mlsb = 1,
	.sample_sel = 0,
};
//#ifdef BF_REE
#if 0
int mtspi_set_dma_en(int mode)
{
	struct mt_chip_config* spi_par;
	spi_par = &spi_init_conf;
	if (!spi_par) {
		return -1;
	}
	if (1 == mode) {
		if (spi_par->com_mod == DMA_TRANSFER) {
			return 0;
		}
		spi_par->com_mod = DMA_TRANSFER;
	} else {
		if (spi_par->com_mod == FIFO_TRANSFER) {
			return 0;
		}
		spi_par->com_mod = FIFO_TRANSFER;
	}

	spi_setup(g_bf_dev->spi);
	return 0;
}
#endif
#if 1
/*----------------------------------------------------------------------------*/
int spi_send_cmd(struct bf_device *bl229x,u8 *tx,u8 *rx,u16 spilen)
{
	int ret=0;
	struct spi_message m;
	struct spi_transfer t = {
		.tx_buf = tx,
		.rx_buf = rx,
		.len = spilen,
//#if USE_SPI1_4GB_TEST
//		.tx_dma = SpiDmaBufTx_pa,
//		.rx_dma = SpiDmaBufRx_pa,
//#endif
        	.tx_dma = 0,
        	.rx_dma = 0,
	};

	spi_message_init(&m);
	spi_message_add_tail(&t, &m);
	ret= spi_sync(bl229x->spi,&m);

	return ret;
}
#endif

#if defined(CONFIG_FB)
/*----------------------------------------------------------------------------*/
static int fb_notifier_callback(struct notifier_block *self,
                                unsigned long event, void *data)
{
    struct fb_event *evdata = data;
    int *blank =  evdata->data;
    BF_LOG("%s fb notifier callback event = %lu, evdata->data = %d\n",__func__, event, *blank);
    if (evdata && evdata->data){
	    if (event == FB_EVENT_BLANK ){		  
            if (*blank == FB_BLANK_UNBLANK){
                g_bf_dev->need_report = 0;
			    display_status = 1;
		    }
            else if (*blank == FB_BLANK_POWERDOWN){
                g_bf_dev->need_report = 1;
			    display_status = 0;
		    }
		}
    }	
    return 0;
}
#endif

static int bf_hw_power (struct bf_device *bf_dev, bool enable)
{
#ifdef NEED_OPT_POWER_ON
#if 1
    if (enable) {
        pinctrl_select_state (bf_dev->pinctrl_gpios, bf_dev->pins_power_high);
//        pinctrl_select_state (bf_dev->pinctrl_gpios, bf_dev->pins_power_1v8_high);
    } else {
        pinctrl_select_state (bf_dev->pinctrl_gpios, bf_dev->pins_power_low);
//        pinctrl_select_state (bf_dev->pinctrl_gpios, bf_dev->pins_power_1v8_low);
    }
#else
    if (enable) {
        gpio_direction_output (bf_dev->power_en_gpio, 1);
    } else {
        gpio_direction_output (bf_dev->power_en_gpio, 0);
    }
#endif
#endif
    return 0;
}

static int bf_hw_reset(struct bf_device *bf_dev)
{
#if 1
	pinctrl_select_state (bf_dev->pinctrl_gpios, bf_dev->pins_reset_low);
	mdelay(10);
	pinctrl_select_state (bf_dev->pinctrl_gpios, bf_dev->pins_reset_high);
#else
    gpio_direction_output (bf_dev->reset_gpio, 0);

    mdelay(5);

    gpio_direction_output (bf_dev->reset_gpio, 1);
#endif
    return 0;
}

/*static void bf_enable_irq(struct bf_device *bf_dev)
{
    if (1 == bf_dev->irq_count) {
        BF_LOG("irq already enabled\n");
    } else {
		enable_irq(bf_dev->irq_num);
        bf_dev->irq_count = 1;
        BF_LOG(" enable interrupt!\n");
    }
}

static void bf_disable_irq(struct bf_device *bf_dev)
{
    if (0 == bf_dev->irq_count) {
        BF_LOG(" irq already disabled\n");
    } else {
        disable_irq(bf_dev->irq_num);
        bf_dev->irq_count = 0;
        BF_LOG(" disable interrupt!\n");
    }
}*/

//#ifndef BF_REE
#ifdef BF_REE
static void bf_spi_clk_enable(struct bf_device *bf_dev, u8 bonoff)
{
#ifdef CONFIG_MTK_CLKMGR
	if (bonoff)
		enable_clock(MT_CG_PERI_SPI0, "spi");
	else
		disable_clock(MT_CG_PERI_SPI0, "spi");

#else
	static int count;
	if (bonoff && (count == 0)) {

		mt_spi_enable_master_clk(bf_dev->spi);
		count = 1;
	} else if ((count > 0) && (bonoff == 0)) {
		mt_spi_disable_master_clk(bf_dev->spi);
		count = 0;
	}
#endif
}
#endif

/* -------------------------------------------------------------------- */
/* fingerprint chip hardware configuration								           */
/* -------------------------------------------------------------------- */

static int bf_get_gpio_info_from_dts (struct bf_device *bf_dev)
{
#ifdef CONFIG_OF
	int ret;

        bf_dev->pinctrl_gpios = devm_pinctrl_get (&bf_dev->spi->dev);
    if (IS_ERR (bf_dev->pinctrl_gpios)) {
        ret = PTR_ERR (bf_dev->pinctrl_gpios);
        BF_LOG( "can't find fingerprint pinctrl");
        return ret;
    }

	bf_dev->pins_default = pinctrl_lookup_state (bf_dev->pinctrl_gpios, "spi0_default");
	if (IS_ERR (bf_dev->pins_default)) {
		ret = PTR_ERR (bf_dev->pins_default);
		BF_LOG( "can't find fingerprint pinctrl default");
        return ret;
    }
	bf_dev->pins_reset_high = pinctrl_lookup_state (bf_dev->pinctrl_gpios, "rst_output1");
	if (IS_ERR (bf_dev->pins_reset_high)) {
		ret = PTR_ERR (bf_dev->pins_reset_high);
		BF_LOG( "can't find fingerprint pinctrl pins_reset_high");
		return ret;
}


	bf_dev->pins_reset_low = pinctrl_lookup_state (bf_dev->pinctrl_gpios, "rst_output0");
	if (IS_ERR (bf_dev->pins_reset_low)) {
    //struct device *dev = &bf_dev->platform_device->dev;
		ret = PTR_ERR (bf_dev->pins_reset_low);

		BF_LOG( "can't find fingerprint pinctrl reset_low");
        return ret;
    }
	bf_dev->pins_fp_interrupt = pinctrl_lookup_state (bf_dev->pinctrl_gpios, "int_default");
	if (IS_ERR (bf_dev->pins_fp_interrupt)) {
		ret = PTR_ERR (bf_dev->pins_fp_interrupt);
		BF_LOG( "can't find fingerprint pinctrl fp_interrupt");
		return ret;
	}

#ifdef NEED_OPT_POWER_ON
	bf_dev->pins_power_high = pinctrl_lookup_state (bf_dev->pinctrl_gpios, "power_en_output1");
	if (IS_ERR (bf_dev->pins_power_high)) {
		ret = PTR_ERR (bf_dev->pins_power_high);
		BF_LOG ("can't find fingerprint pinctrl power_high");
        return ret;
    }
	bf_dev->pins_power_low = pinctrl_lookup_state (bf_dev->pinctrl_gpios, "power_en_output0");
	if (IS_ERR (bf_dev->pins_power_low)) {
		ret = PTR_ERR (bf_dev->pins_power_low);
		BF_LOG ("can't find fingerprint pinctrl power_low");
    return ret;
}

/*	bf_dev->pins_power_1v8_high = pinctrl_lookup_state (bf_dev->pinctrl_gpios, "power_en1_output1");*/


#endif
	BF_LOG( "get pinctrl success!");
    bf_dev->reset_gpio = of_get_named_gpio_flags(bf_dev->spi->dev.of_node, "fingerprint,rst-gpio", 0, NULL);
    if (!gpio_is_valid(bf_dev->reset_gpio)) {
        BF_LOG("reset_gpio invalid!");
        return -EINVAL;
    }
    bf_dev->irq_gpio =  of_get_named_gpio_flags(bf_dev->spi->dev.of_node, "fingerprint,touch-int-gpio", 0, NULL);
    if (!gpio_is_valid(bf_dev->irq_gpio)) {
        BF_LOG("irq_gpio invalid!");
    // get gpio_reset resourece
        return -EINVAL;
    }
    bf_dev->irq_num = gpio_to_irq(bf_dev->irq_gpio);
    BF_LOG("bf_dev_irq_num = %d", bf_dev->irq_num);
#ifdef NEED_OPT_POWER_ON


	bf_dev->power_en_gpio =  of_get_named_gpio(bf_dev->spi->dev.of_node, "power-gpio", 0);


#endif

    //bf_dev->reset_gpio = 131;
    //bf_dev->irq_gpio = 13;
    //bf_dev->power_gpio = 79;

    // set power direction output
	pinctrl_select_state(bf_dev->pinctrl_gpios, bf_dev->pins_default);
	pinctrl_select_state(bf_dev->pinctrl_gpios, bf_dev->pins_reset_high);
#ifdef NEED_OPT_POWER_ON
    // set reset direction output
	pinctrl_select_state(bf_dev->pinctrl_gpios, bf_dev->pins_power_high);
#endif
	pinctrl_select_state(bf_dev->pinctrl_gpios, bf_dev->pins_fp_interrupt);
    //register int
#endif
	return 0;
}

/* -------------------------------------------------------------------- */
/* netlink functions                 */
/* -------------------------------------------------------------------- */
void bf_send_netlink_msg(struct bf_device *bf_dev, const int command)
{
    struct nlmsghdr *nlh = NULL;
    struct sk_buff *skb = NULL;
    int ret;
    char data_buffer[2];

    BF_LOG("enter, send command %d",command);
    memset(data_buffer,0,2);
    data_buffer[0] = (char)command;
    if (NULL == bf_dev->netlink_socket) {
        BF_LOG("invalid socket");
        return;
    }

    if (0 == g_pid) {
        BF_LOG("invalid native process pid");
        return;
    }

    /*alloc data buffer for sending to native*/
    skb = alloc_skb(MAX_NL_MSG_LEN, GFP_ATOMIC);
    if (skb == NULL) {
        return;
    }

    nlh = nlmsg_put(skb, 0, 0, 0, MAX_NL_MSG_LEN, 0);
    if (!nlh) {
        BF_LOG("nlmsg_put failed");
        kfree_skb(skb);
        return;
    }

    NETLINK_CB(skb).portid = 0;
    NETLINK_CB(skb).dst_group = 0;

    *(char *)NLMSG_DATA(nlh) = command;
    *((char *)NLMSG_DATA(nlh)+1) = 0;
    ret = netlink_unicast(bf_dev->netlink_socket, skb, g_pid, MSG_DONTWAIT);
    if (ret < 0) {
        BF_LOG("send failed");
        return;
    }

    BF_LOG("send done, data length is %d",ret);
    return ;
}

static void bf_recv_netlink_msg(struct sk_buff *__skb)
{
    struct sk_buff *skb = NULL;
    struct nlmsghdr *nlh = NULL;
    char str[128];


    skb = skb_get(__skb);
    if (skb == NULL) {
        BF_LOG("skb_get return NULL");
        return;
    }

    if (skb->len >= NLMSG_SPACE(0)) {
        nlh = nlmsg_hdr(skb);
//add by wangdongbo       
		//memcpy(str, NLMSG_DATA(nlh), sizeof(str));
        g_pid = nlh->nlmsg_pid;
        BF_LOG("pid: %d, msg: %s",g_pid, str);

    } else {
        BF_LOG("not enough data length");
    }

    kfree_skb(__skb);

}


static int bf_close_netlink(struct bf_device *bf_dev)
{
    if (bf_dev->netlink_socket != NULL) {
        netlink_kernel_release(bf_dev->netlink_socket);
        bf_dev->netlink_socket = NULL;
        return 0;
    }

    BF_LOG("no netlink socket yet");
    return -1;
}


static int bf_init_netlink(struct bf_device *bf_dev)
{
    struct netlink_kernel_cfg cfg;

    memset(&cfg, 0, sizeof(struct netlink_kernel_cfg));
    cfg.input = bf_recv_netlink_msg;

    bf_dev->netlink_socket = netlink_kernel_create(&init_net, NETLINK_BF, &cfg);
    if (bf_dev->netlink_socket == NULL) {
        BF_LOG("netlink create failed");
        return -1;
    }
    BF_LOG("netlink create success");
    return 0;
}


static irqreturn_t bf_eint_handler (int irq, void *data)
{
    struct bf_device *bf_dev = (struct bf_device *)data;
    BF_LOG("++++irq_handler netlink send+++++");
    bf_send_netlink_msg(bf_dev, BF_NETLINK_CMD_IRQ);
    bf_dev->sig_count++;
#ifdef	FAST_VERSION
	if (g_bf_dev->report_key!=0 && g_bf_dev->need_report!=0){
		input_report_key(bf_inputdev,g_bf_dev->report_key ,1);
    	input_sync(bf_inputdev);
		input_report_key(bf_inputdev,g_bf_dev->report_key ,0);
    	input_sync(bf_inputdev);
		BF_LOG("report power key %d\n",g_bf_dev->report_key );
   	}
#endif	
    BF_LOG("-----irq_handler netlink bf_dev->sig_count=%d-----",bf_dev->sig_count);
    return IRQ_HANDLED;
}

#ifdef FAST_VERISON
int g_bl229x_enbacklight = 1;
#endif

/* -------------------------------------------------------------------- */
/* file operation function                                                                                */
/* -------------------------------------------------------------------- */
static long bf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
    int error = 0;
#ifdef FAST_VERISON
	u32 bl229x_enbacklight = 0;
#endif 
#ifdef BF_REE
    	int ret_value = 0;
    	int i = 0;
	bl_ree_mode_command_t mode;
	u8 reg_value = 0;
	u8 write_value = 0;
	u32 info[2];
#endif
    struct bf_device *bf_dev = NULL;
	unsigned int key_event = 0;


    bf_dev = (struct bf_device *)filp->private_data;
    if (_IOC_TYPE(cmd) != BF_IOCTL_MAGIC_NO) {
        BF_LOG("Not blestech fingerprint cmd.");
        return -EINVAL;
    }

    switch (cmd) {
    case BF_IOCTL_RESET:
        BF_LOG("BF_IOCTL_RESET: chip reset command\n");
        bf_hw_reset(bf_dev);
        break;
	
	case BF_IOCTL_ENABLE_POWER:
		BF_LOG("BF_IOCTL_ENABLE_POWER:  command\n");
		bf_hw_power(bf_dev,1);
		break;
	case BF_IOCTL_DISABLE_POWER:
		BF_LOG("BF_IOCTL_DISABLE_POWER:  command\n");
		bf_hw_power(bf_dev,0);
		break;
	
	case BF_IOCTL_INPUT_KEY:
        key_event = (unsigned int)arg;
        BF_LOG("key:%d\n",key_event);
 
		input_report_key(bf_inputdev, key_event, 1);
		input_sync(bf_inputdev);
		input_report_key(bf_inputdev, key_event, 0);
		input_sync(bf_inputdev);
        break;
#ifdef FAST_VERISON			
	case BF_IOCTL_ENBACKLIGHT:
		BF_LOG("BF_IOCTL_ENBACKLIGHT arg:%d\n", (int)arg);
		g_bl229x_enbacklight = (int)arg;
		break;
	case BF_IOCTL_ISBACKLIGHT:
		BF_LOG("BF_IOCTL_ISBACKLIGHT\n");
		bl229x_enbacklight = g_bl229x_enbacklight;
		if (copy_to_user((void __user*)arg,&bl229x_enbacklight,sizeof(u32)*1) != 0 ){
		   error = -EFAULT;
		}
		break;
#endif
#ifdef BF_REE
    	case BF_IOCTL_INIT:
		BF_LOG("BF_IOCTL_RESET: chip reset command\n");
		bf_fp_dev_init();
        	break;
	case BF_IOCTL_CAPTURE_MODE:
		BF_LOG("BTL:Capture FP:%d\n", (u8)arg);
	    	memset(g_bf_dev->image_buf, 0xff, IM_WIDTH * IM_HEIGHT);
	    	bf_set_capture_mode((u8)arg);
		break;
	case BF_IOCTL_INTERRUPT_MODE:
        	BF_LOG("BF_IOCTL_INTERRUPT_MODE:  command\n");
		if(copy_from_user(&mode, (bl_ree_mode_command_t *)arg, sizeof(bl_ree_mode_command_t))){
			error = -EFAULT;
			break;
		}
        	BF_LOG("irq_direction %02x\n", mode.irq_direction);
        	BF_LOG("mode.dacp %02x\n", mode.dacp);
        	if(g_chip_type != BF3290) {
            		if(mode.irq_direction == IRQ_UP) {
                		bf_spi_write_reg(0x10, btl_chip_parmas_t.reg_IntUp_value);
            		} else {
                		bf_spi_write_reg(0x10, btl_chip_parmas_t.reg_IntDown_value);
            		}
            		ret_value = bf_spi_read_reg(0x10);
            		BF_LOG("the 0x10 register = %d\n", ret_value);
        	}
			BF_LOG(" 1 BF_IOCTL_INTERRUPT_MODE:  command\n");
			BF_LOG(" 2 BF_IOCTL_INTERRUPT_MODE:  command\n");
			BF_LOG(" 3 BF_IOCTL_INTERRUPT_MODE:  command\n");
        	bf_set_interrupt_mode(mode.dacp);
			BF_LOG(" 4 BF_IOCTL_INTERRUPT_MODE:  command\n");
			BF_LOG(" 5 BF_IOCTL_INTERRUPT_MODE:  command\n");
			BF_LOG(" 6 BF_IOCTL_INTERRUPT_MODE:  command\n");
		break;
	case BF_IOCTL_INIT_ARGS:	
		BF_LOG("BF_IOCTL_INIT_ARGS: command\n");	
		if(copy_from_user(&btl_chip_parmas_t, (btl_ta_chip_parmas *)arg, sizeof(btl_chip_parmas_t))){
			error = -EFAULT;
			BF_LOG("BF_IOCTL_INIT_ARGS faile!");
			break;
		}
	
        	btl_init_params = btl_chip_parmas_t.chip_init_params;
		for(i = 0; i < btl_chip_parmas_t.init_params_counts; i++) {
            		BF_LOG("the reg is %02x\n", (btl_init_params + i)->addr);
            		BF_LOG("the value is %02x\n", (btl_init_params + i)->value);
	    	}
	    	BF_LOG("the vaue is %d\n", btl_chip_parmas_t.init_params_counts);
	    	BF_LOG("the vaue is %02x\n", btl_chip_parmas_t.reg_intdacp_value);
	    	BF_LOG("the vaue is %02x\n", btl_chip_parmas_t.reg_capdacp_value);
	    	BF_LOG("the vaue is %02x\n", btl_chip_parmas_t.reg_0x31_value);
	    	BF_LOG("the vaue is %02x\n", btl_chip_parmas_t.reg_0x32_value);
	    	BF_LOG("the vaue is %02x\n", btl_chip_parmas_t.reg_IntUp_value);
	    	BF_LOG("the vaue is %02x\n", btl_chip_parmas_t.reg_IntDown_value);
	    	BF_LOG("the vaue is %02x\n", btl_chip_parmas_t.fd_frame_num);
	    	BF_LOG("the vaue is %02x\n", btl_chip_parmas_t.cap_frame_num);
	    	BF_LOG("the vaue is %d\n", btl_chip_parmas_t.AlgorithmType);
	    	BF_LOG("the vaue is %d\n", btl_chip_parmas_t.duplicate_finger);

		if(g_chip_type == BF3290) {
	        	if(btl_chip_parmas_t.fd_frame_num > 4 || btl_chip_parmas_t.fd_frame_num == 0) {
	            		btl_chip_parmas_t.fd_frame_num = 0x3;
	        	} else if(btl_chip_parmas_t.fd_frame_num > 0) {
	            		btl_chip_parmas_t.fd_frame_num--;
	        	}

	        	if(btl_chip_parmas_t.cap_frame_num > 4 || btl_chip_parmas_t.cap_frame_num == 0) {
	            		btl_chip_parmas_t.cap_frame_num = 0x3;
	        	} else if(btl_chip_parmas_t.cap_frame_num > 0) {
	            		btl_chip_parmas_t.cap_frame_num--;
	        	}

	        	g_bf_dev->m_fd_frame_val = 0x3 | (btl_chip_parmas_t.fd_frame_num << 3);
	        	g_bf_dev->m_cap_frame_val = 0x3 | (btl_chip_parmas_t.cap_frame_num << 3);
	    	} else {
	        	if(btl_chip_parmas_t.fd_frame_num > 8 || btl_chip_parmas_t.fd_frame_num == 0) {
                		btl_chip_parmas_t.fd_frame_num = 0x7;
            		} else if(btl_chip_parmas_t.fd_frame_num > 0) {
                		btl_chip_parmas_t.fd_frame_num--;
            		}

            		if(btl_chip_parmas_t.cap_frame_num > 8 || btl_chip_parmas_t.cap_frame_num == 0) {
                		btl_chip_parmas_t.cap_frame_num = 0x7;
            		} else if(btl_chip_parmas_t.cap_frame_num > 0) {
                		btl_chip_parmas_t.cap_frame_num--;
            		}

            		g_bf_dev->m_fd_frame_val = btl_chip_parmas_t.fd_frame_num<<3;
            		g_bf_dev->m_cap_frame_val = btl_chip_parmas_t.cap_frame_num<<3;
			if(g_chip_type < 0x5483){		
				g_bf_dev->m_fd_frame_val |= 0x3;
				g_bf_dev->m_cap_frame_val |= 0x3;
				if(g_chip_type == 0x5383){
					g_bf_dev->m_fd_frame_val |= 0x40;
					g_bf_dev->m_cap_frame_val |= 0x40;
				}
			}
	    	}
		bf_fp_dev_init();
		break;
	case BF_IOCTL_GET_ID:
		BF_LOG("BF_IOCTL_GET_ID\n");
		if (copy_to_user((void __user*)arg,&g_chip_type,sizeof(u32)*1) != 0 ){
		   error = -EFAULT;
		}
		break;
	case BF_IOCTL_GET_IMAGE:
        BF_LOG("BL_TA_CAPTURE_IMG_CMD\n");
        bf_read_fp_image(g_bf_dev->image_buf, IM_WIDTH, IM_HEIGHT);
		break;
	case BF_IOCTL_REGISTER_READ:
        BF_LOG("BF_IOCTL_REGISTER_READ\n");
		//reg_value = *((u8*)arg);
		if(copy_from_user(info, (void __user*)arg, sizeof(u32)*1) != 0)
		{	
		    BF_LOG("ERROR: BF_IOCTL_REGISTER_READ\n");
            error = -EFAULT;
            break;
        }
		reg_value = info[0];
		BF_LOG("BF_IOCTL_REGISTER_READ reg_value = %x\n", reg_value);
		ret_value = bf_spi_read_reg(reg_value);
		if (copy_to_user((void __user*)arg,&ret_value,sizeof(u32)*1) != 0 ) {
			BF_LOG("ERROR: BF_LOG_REGISTER_READ\n");
            error = -EFAULT;
        }
		break;
	case BF_IOCTL_REGISTER_WRITE:
        BF_LOG("BF_IOCTL_REGISTER_WRITE\n");
        if (copy_from_user(info,(void __user*)arg,sizeof(u32)*2) != 0 ) {
            BF_LOG("ERROR: BF_LOG_REGISTER_WIGHT\n");
            error = -EFAULT;
            break;
        }
		reg_value = (u8)info[0];
		write_value = (u8)info[1];
		BF_LOG("BF_IOCTL_REGISTER_READ reg_value = %x,write_value = %x\n", reg_value, write_value);
		bf_spi_write_reg(reg_value, write_value);
		break;
#endif
	case BF_IOCTL_ENABLE_SPI_CLOCK:
		BF_LOG("BF_IOCTL_ENABLE_SPI_CLK:  command\n");
//#ifndef BF_REE
#ifdef BF_REE
        bf_spi_clk_enable(bf_dev, 1);
#endif
        break;
	case BF_IOCTL_DISABLE_SPI_CLOCK:
		BF_LOG("BF_IOCTL_DISABLE_SPI_CLK:  command\n");
//#ifndef BF_REE
#ifdef BF_REE
        bf_spi_clk_enable(bf_dev, 0);
#endif
        break;
	case BF_IOCTL_INPUT_KEY_DOWN:
#ifdef FAST_VERSION
		if(g_bl229x_enbacklight && g_bf_dev->need_report==0){
#else
		if(g_bf_dev->need_report==0){
#endif
			bf_key_need_report = 1;
			key_event = (int)arg;
			input_report_key(bf_inputdev, key_event, 1);
			input_sync(bf_inputdev);			
		}			
		break;
	case BF_IOCTL_INPUT_KEY_UP:
		if(bf_key_need_report == 1){
			bf_key_need_report = 0;
			key_event = (int)arg;
			input_report_key(bf_inputdev, key_event, 0);
			input_sync(bf_inputdev);
		}			
		break;
    default:
        BF_LOG("Supportn't this command(%x)\n",cmd);
        break;
    }

    return error;

}
#ifdef CONFIG_COMPAT
static long bf_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
    int retval = 0;

    retval = bf_ioctl(filp, cmd, arg);

    return retval;
}
#endif

/*----------------------------------------------------------------------------*/
static int bf_open (struct inode *inode, struct file *filp)
{
    struct bf_device *bf_dev = g_bf_dev;
    int status = 0;

    filp->private_data = bf_dev;
    BF_LOG( " Success to open device.");

    return status;
}


/* -------------------------------------------------------------------- */
static ssize_t bf_write (struct file *file, const char *buff, size_t count, loff_t *ppos)
{
    return -ENOMEM;
}

/* -------------------------------------------------------------------- */
static ssize_t bf_read (struct file *filp, char  *buff, size_t count, loff_t *ppos)
{
	int ret=0;
	ssize_t status = 0;

//	spi_read_frame(struct  bf_device *bf_dev);

	ret = copy_to_user(buff, g_bf_dev->image_buf , count); //skip
	if (ret) {
		status = -EFAULT;
	}
	BF_LOG("status: %d \n", (int)status);
	BF_LOG("  --\n");
	return status;

}

/* -------------------------------------------------------------------- */
static int bf_release (struct inode *inode, struct file *file)
{
    int status = 0 ;
    return status;
}
static int bf_suspend (struct device *dev)
{
    BF_LOG("  ++\n");
	g_bf_dev->need_report = 1;
	BF_LOG("\n");
    return 0;
}
static int bf_resume (struct device *dev)
{
    BF_LOG("  ++\n");
	BF_LOG("\n");
    return 0;
}

/*----------------------------------------------------------------------------*/
static const struct file_operations bf_fops = {
    .owner = THIS_MODULE,
    .open  = bf_open,
    .write = bf_write,
    .read  = bf_read,
    .release = bf_release,
    .unlocked_ioctl = bf_ioctl,
#ifdef CONFIG_COMPAT
    .compat_ioctl = bf_compat_ioctl,
#endif
};

static struct miscdevice bf_misc_device = {
    .minor = MISC_DYNAMIC_MINOR,
    .name = BF_DEV_NAME,
    .fops = &bf_fops,
};

static int bf_remove(struct spi_device *spi)
{
	struct bf_device *bf_dev = g_bf_dev;

	/* make sure ops on existing fds can abort cleanly */
	if (bf_dev->irq_num) {
		free_irq(bf_dev->irq_num, bf_dev);
		bf_dev->irq_count = 0;
		bf_dev->irq_num= 0;
	}

	bf_close_netlink(bf_dev);
	
	bf_hw_power(bf_dev,0);
//#ifndef BF_REE
#ifdef BF_REE
	bf_spi_clk_enable(bf_dev, 0);
#endif
	spi_set_drvdata(spi, NULL);
	bf_dev->spi = NULL;

	kfree(bf_dev);

	return 0;
}

static int bf_create_inputdev(void)
{
	bf_inputdev = input_allocate_device();
	if (!bf_inputdev) {
		BF_LOG("bf_inputdev create faile!\n");
		return -ENOMEM;
	}
	__set_bit(EV_KEY,bf_inputdev->evbit);
	__set_bit(KEY_F10,bf_inputdev->keybit);		//68
	__set_bit(KEY_F11,bf_inputdev->keybit);		//88
	__set_bit(KEY_F12,bf_inputdev->keybit);		//88
	__set_bit(KEY_CAMERA,bf_inputdev->keybit);	//212
	__set_bit(KEY_POWER,bf_inputdev->keybit);	//116
	__set_bit(KEY_PHONE,bf_inputdev->keybit);  //call 169
	__set_bit(KEY_BACK,bf_inputdev->keybit);  //call 158
	__set_bit(KEY_HOMEPAGE,bf_inputdev->keybit);  //call 172
	__set_bit(KEY_MENU,bf_inputdev->keybit);  //call 158

	__set_bit(KEY_F1,bf_inputdev->keybit);	//69
	__set_bit(KEY_F2,bf_inputdev->keybit);	//60
	__set_bit(KEY_F3,bf_inputdev->keybit);	//61
	__set_bit(KEY_F4,bf_inputdev->keybit);	//62
	__set_bit(KEY_F5,bf_inputdev->keybit);	//63
	__set_bit(KEY_F6,bf_inputdev->keybit);	//64
	__set_bit(KEY_F7,bf_inputdev->keybit);	//65
	__set_bit(KEY_F8,bf_inputdev->keybit);	//66
	__set_bit(KEY_F9,bf_inputdev->keybit);	//67

	__set_bit(KEY_UP,bf_inputdev->keybit);	//103
	__set_bit(KEY_DOWN,bf_inputdev->keybit);	//108
	__set_bit(KEY_LEFT,bf_inputdev->keybit);	//105
	__set_bit(KEY_RIGHT,bf_inputdev->keybit);	//106

	bf_inputdev->id.bustype = BUS_HOST;
	bf_inputdev->name = "bl229x_inputdev";
	if (input_register_device(bf_inputdev)) {
		BF_LOG("%s, register inputdev failed\n", __func__);
		input_free_device(bf_inputdev);
		return -ENOMEM;
	}
	return 0;
}


static int  bf_probe (struct spi_device *spi)
{
    struct bf_device *bf_dev = NULL;
	int status = -EINVAL;
    bf_dev = kzalloc(sizeof (struct bf_device), GFP_KERNEL);
    if (NULL == bf_dev) {
        BF_LOG( "kzalloc bf_dev failed.");
        status = -ENOMEM;
        goto err;
    }

    g_bf_dev=bf_dev;
    spi_set_drvdata (spi, bf_dev);

	BF_LOG( "bf config spi ");
	bf_dev->spi = spi;
	bf_dev->spi->mode = SPI_MODE_0;
	bf_dev->spi->bits_per_word = 8;
	bf_dev->spi->max_speed_hz = 7 * 1000 * 1000;
//#ifdef CONFIG_MTK_CLKMGR
#if 1
	memcpy (&bf_dev->mtk_spi_config, &spi_init_conf, sizeof (struct mtk_chip_config));
	bf_dev->spi->controller_data = (void*)&bf_dev->mtk_spi_config;

#endif
	spi_setup (bf_dev->spi);   
        bf_dev->spi->dev.of_node=of_find_compatible_node(NULL, NULL, "blestech,BL229X"); 

//#ifndef BF_REE
#ifdef BF_REE
	bf_spi_clk_enable(bf_dev,1);
	
#endif
    bf_get_gpio_info_from_dts(bf_dev);

    status = request_threaded_irq (bf_dev->irq_num, NULL, bf_eint_handler,  IRQ_TYPE_EDGE_RISING /*IRQF_TRIGGER_RISING*/ | IRQF_ONESHOT, BF_DEV_NAME, bf_dev);
    if (!status){
        	BF_LOG("irq thread request success!\n");
	}
    else{
        	BF_LOG("irq thread request failed, retval=%d\n", status);
		goto err;
	}

    /* netlink interface init */
    BF_LOG ("bf netlink config");
    if (bf_init_netlink(bf_dev) <0) {
        BF_LOG ("bf_netlink create failed");
            status = -1;
	goto err;
    }

    status = misc_register(&bf_misc_device);
    if(status) {
        BF_LOG("bl229x_misc_device register failed\n");
        goto err;
    }

	BF_LOG("blestech_fp add secussed.");
	bf_dev->irq_count=0;
	bf_dev->sig_count=0;
	bf_dev->report_key = KEY_F10;
	bf_hw_power(bf_dev,1);
	bf_hw_reset(bf_dev);
#ifdef BF_REE
	//mtspi_set_dma_en(0);
#endif
	enable_irq_wake(bf_dev->irq_num);
	bf_create_inputdev();
#ifdef BF_REE
	bf_chip_info();
	if(g_chip_type !=0x5183||g_chip_type!=0x5283||g_chip_type!=0x5383||g_chip_type!=0x5483||g_chip_type!=0x5783){

		   	BF_LOG("ChipID error and exit");	
	}
#endif

    bf_dev->image_buf = (u8*)__get_free_pages(GFP_KERNEL,get_order(IM_WIDTH * IM_HEIGHT));

    BF_LOG("%s----\n",__func__);


#if defined(CONFIG_FB)
	fb_notif.notifier_call = fb_notifier_callback;
	fb_register_client(&fb_notif);
#endif	
	
    BF_LOG ("bf_probe success!");
	return 0;

err:
    return status;
}

#ifdef CONFIG_OF
static struct of_device_id bf_of_table[] = {
	{.compatible = "blestech,BL229X",},
	{},
};
MODULE_DEVICE_TABLE(of, bf_of_table);
#endif

static const struct dev_pm_ops bf_pm = {
    .suspend = bf_suspend,
    .resume =  bf_resume
};
static struct spi_driver bf_driver = {
    .driver = {
        .name = BF_DEV_NAME,
		.bus	= &spi_bus_type,
        .owner = THIS_MODULE,
#ifdef CONFIG_OF
		.of_match_table = bf_of_table,
#endif
		.pm = &bf_pm,
    },
    .probe = bf_probe,
    .remove = bf_remove,
};

static int bf_spi_init(void)
{
	int status = 0;

    BF_LOG("bf_spi_init\n");

	status = spi_register_driver(&bf_driver);
	if (status < 0)
		BF_LOG( "Failed to register SPI driver.\n");
    BF_LOG ("register driver success!");
    return status;
}

static void bf_spi_exit(void)
{
	spi_unregister_driver (&bf_driver);
}
module_init (bf_spi_init);
module_exit (bf_spi_exit);


MODULE_LICENSE("GPL");
MODULE_AUTHOR ("betterlife@blestech.com");
MODULE_DESCRIPTION ("Blestech fingerprint sensor TEE driver.");
