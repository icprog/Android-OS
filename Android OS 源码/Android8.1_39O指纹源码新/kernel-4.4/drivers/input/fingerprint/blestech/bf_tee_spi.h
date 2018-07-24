#ifndef BF_TEE_SPI_H
#define BF_TEE_SPI_H
#if defined(CONFIG_FB) //system-defined Macro!!
#include <linux/notifier.h>
#include <linux/fb.h>
#endif
//#include <linux/earlysuspend.h>
#include <linux/types.h>
#include <linux/cdev.h>
#include "mt_spi.h"
#include "bf_config.h"

#define BF_DEV_NAME "blfp"
#define BF_DEV_MAJOR 0	/* assigned */
#define BF_CLASS_NAME "blfp"

/*for power on*/
//#define NEED_OPT_POWER_ON	//power gpio
/* for netlink use */
#define MAX_NL_MSG_LEN 16
#define NETLINK_BF  29
/*for kernel log*/
#define BLESTECH_LOG
#define FAST_VERISON


#ifdef BLESTECH_LOG
#define BF_LOG(fmt,arg...)          do{printk("<blestech_fp>[%s:%d]"fmt"\n",__func__, __LINE__, ##arg);}while(0)
#else
#define BF_LOG(fmt,arg...)   	   do{}while(0)
#endif

#define BF3290				0x5183
#define BF3182				0x5283
#define BF3390				0x5383
#define BF3582P             0x5783
#define BF3582S             0x5483

typedef enum 
{
	BF_NETLINK_CMD_BASE = 100,

	BF_NETLINK_CMD_TEST  = BF_NETLINK_CMD_BASE+1,
	BF_NETLINK_CMD_IRQ = BF_NETLINK_CMD_BASE+2,
	BF_NETLINK_CMD_SCREEN_OFF = BF_NETLINK_CMD_BASE+3,
	BF_NETLINK_CMD_SCREEN_ON = BF_NETLINK_CMD_BASE+4
}fingerprint_socket_cmd_t;

struct bf_device {
	dev_t devno;
	struct cdev cdev;
	struct device *device;
	//struct class *class;
	int device_count;
	struct spi_device *spi;
	struct list_head device_entry;
	u32 reset_gpio;
	u32 irq_gpio;
	u32 irq_num;
	u8 irq_count;
	u8 sig_count;
	s32 report_key;
	u8  need_report;
#ifdef BF_REE
	u8 *image_buf;
	u8  m_fd_frame_val;
    u8  m_cap_frame_val;
    u8  m_dacp_reg;
	u8  m_irq_direction;
#endif
#ifdef NEED_OPT_POWER_ON
	u32 power_en_gpio;
	u32 power1v8_en_gpio;
#endif
	struct pinctrl *pinctrl_gpios;
	struct pinctrl_state *pins_default,*pins_fp_interrupt;	
	struct pinctrl_state *pins_reset_high, *pins_reset_low;
#ifdef NEED_OPT_POWER_ON
	struct pinctrl_state *pins_power_high, *pins_power_low;
	struct pinctrl_state *pins_power_1v8_high, *pins_power_1v8_low;
#endif
#ifdef CONFIG_HAS_EARLYSUSPEND
	struct early_suspend early_suspend;
#else
	struct notifier_block fb_notify;
#endif
	/* for netlink use */
	struct sock *netlink_socket;
#if 1//def CONFIG_MTK_CLKMGR
	struct mt_chip_conf mtk_spi_config;
#endif
};

#ifdef BF_REE
/********** the register addr and value ***********/
typedef struct reg_value {
    uint8_t addr;
    uint8_t value;
} __attribute__((packed)) btl_reg_value;
typedef struct ta_chip_params {
    btl_reg_value 	chip_init_params[50];
    uint8_t		fd_frame_num;
    uint8_t		cap_frame_num;
    uint8_t		reg_intdacp_value;
    uint8_t		reg_capdacp_value;
    uint8_t		reg_0x31_value;
    uint8_t		reg_0x32_value;
    uint8_t		reg_IntUp_value;
    uint8_t		reg_IntDown_value;
    uint32_t	AlgorithmType;
    uint32_t	max_template_size;
    uint32_t	width;
    uint32_t	height;
    uint32_t	init_params_counts;
    uint32_t 	ta_log;
    uint32_t 	chipid;
    uint32_t	enroll_far_value;
    uint32_t	match_far_value;
    uint32_t	update_far_value;
    uint32_t	duplicate_finger;
    uint32_t	duplicate_area;
    uint32_t	autodacp_ta;
    uint32_t	tk_pay;
} __attribute__((packed)) btl_ta_chip_parmas;

typedef struct {
    int32_t dacp;
    int32_t irq_direction;
} bl_ree_mode_command_t;

enum {
    IRQ_UP 	= 0,
    IRQ_DOWN = 1,
};
#endif
typedef enum {
    // work mode
    MODE_IDLE       = 0x00,
    MODE_RC_DT      = 0x01,
    MODE_FG_DT      = 0x02,
    MODE_FG_PRINT   = 0x03,
    MODE_FG_CAP     = 0x04,
    MODE_NAVI       = 0x05,
    MODE_CLK_CALI   = 0x06,
    MODE_PIEXL_TEST = 0x07
} bf_work_mode_t;

typedef enum {
    REGA_ADC_OPTION                 = 0x07,
    REGA_TIME_INTERVAL_LOW          = 0x08,
    REGA_TIME_INTERVAL_HIGH         = 0x09,
    REGA_FINGER_DT_INTERVAL_LOW     = 0x0A,
    REGA_FINGER_DT_INTERVAL_HIGH    = 0x0B,
    REGA_FRAME_NUM                  = 0x0D, // number reset row vdd
    REGA_RC_THRESHOLD_LOW           = 0x0E,
    REGA_RC_THRESHOLD_MID           = 0x0F,
    REGA_RC_THRESHOLD_HIGH          = 0x10,
    REGA_FINGER_TD_THRED_LOW        = 0x11,
    REGA_FINGER_TD_THRED_HIGH       = 0x12,
    REGA_HOST_CMD                   = 0x13,
    REGA_PIXEL_MAX_DELTA            = 0x18,
    REGA_PIXEL_MIN_DELTA            = 0x19,
    REGA_PIXEL_ERR_NUM              = 0x1A,
    REGA_RX_DACP_LOW                = 0x1B, //
    REGA_RX_DACP_HIGH               = 0x1C,
    REGA_FINGER_CAP                 = 0x27,
    REGA_INTR_STATUS                = 0x28,
    REGA_GC_STAGE                   = 0x31, //
    REGA_IC_STAGE                   = 0x32,
    REGA_VERSION_RD_EN              = 0x3A,
    REGA_F32K_CALI_LOW              = 0x3B,
    REGA_F32K_CALI_HIGH             = 0x3C,
    REGA_F32K_CALI_EN               = 0x3F
} bf_register_t;

#ifndef CONFIG_MTK_CLKMGR
extern void mt_spi_enable_master_clk(struct spi_device *spidev);
extern void mt_spi_disable_master_clk(struct spi_device *spidev);
#endif

int mtspi_set_dma_en(int mode);
u8 bf_spi_write_reg(u8 reg, u8 value);
u8 bf_spi_read_reg(u8 reg);
u8 bf_spi_write_reg_bit(u8 nRegID, u8 bit, u8 value);
void exchange_odd_even_cols(u8 *src, int nWidth, int nHeight);
int bf_read_chipid(void);
void bf_chip_info(void);
u8 bf_fp_dev_init(void);
u8 bf_read_fp_image(u8 *p_image_buffer, u8 im_width, u8 im_height);
u8  bf_set_interrupt_mode(u8 dacp);
u8 bf_set_capture_mode(u8 dacp);
int spi_send_cmd(struct bf_device *bl229x,u8 *tx,u8 *rx,u16 spilen);
#endif //__BF_SPI_TEE_H_
