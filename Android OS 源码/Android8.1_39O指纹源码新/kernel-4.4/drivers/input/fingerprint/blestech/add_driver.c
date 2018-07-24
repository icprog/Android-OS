#include "bf_tee_spi.h"

extern btl_ta_chip_parmas btl_chip_parmas_t;
extern btl_reg_value *btl_init_params;
extern int IM_HEIGHT;
extern int IM_WIDTH;
extern u32 g_chip_type;
extern struct bf_device *g_bf_dev;

/*----------------------------------------------------------------------------*/
u8 bf_spi_write_reg(u8 reg, u8 value)
{
	u8 nAddr;
	u8 data_tx[2];
	u8 data_rx[2];

	memset(data_tx, 0, 2);
	memset(data_rx, 0, 2);

	nAddr = reg << 1;
	nAddr |= 0x80;

	data_tx[0] = nAddr;
	data_tx[1] = value;

	spi_send_cmd(g_bf_dev,data_tx,data_rx,2);
	return data_rx[1];
}


//-------------------------------------------------------------------------------------------------
u8 bf_spi_read_reg(u8 reg)
{
	u8 nAddr;
	u8 data_tx[2];
	u8 data_rx[2];

	memset(data_tx, 0, 2);
	memset(data_rx, 0, 2);

	nAddr = reg << 1;
	nAddr &= 0x7F;

	data_tx[0] = nAddr;
	data_tx[1] = 0xff;

	spi_send_cmd(g_bf_dev,data_tx,data_rx,2);

	if(reg == 0x28){
		if(g_chip_type == BF3290){
			bf_spi_write_reg(0x13, 0x00);
			bf_spi_write_reg(0x13, 0x40);
			bf_spi_write_reg(0x13, 0);		
		}else{
        	if(g_chip_type >= 0x5483){
				if(data_rx[1] == 0x1){
					bf_spi_write_reg(0x34, 0x00);
			        bf_spi_write_reg(0x13, 0x40);
			        bf_spi_write_reg(0x13, 0x00);
				}				
			}else
			bf_spi_write_reg(0x34, 0x1);		
		}	
	}
	return data_rx[1];
}


/*----------------------------------------------------------------------------*/
u8 bf_spi_write_reg_bit(u8 nRegID, u8 bit, u8 value)
  {
  u8 tempvalue = 0;

  tempvalue = bf_spi_read_reg(nRegID);
  tempvalue &= ~(1 << bit);
  tempvalue |= (value << bit);
  bf_spi_write_reg(nRegID,tempvalue);

  return 0;
  }


void exchange_odd_even_cols(u8 *src, int nWidth, int nHeight)
{
    u8 tempBuffer[16];
    u8 *pLine;
    int i = 0;
    int j = 0;
    u8 *pImgData = src;

    for (i = 0; i < nHeight; i++) {
        pLine = pImgData + i * nWidth;
        for (j = 0; j < nWidth; j += 16) {
            tempBuffer[0] = pLine[j];
            tempBuffer[1] = pLine[j + 8];
            tempBuffer[2] = pLine[j + 1];
            tempBuffer[3] = pLine[j + 9];
            tempBuffer[4] = pLine[j + 2];
            tempBuffer[5] = pLine[j + 10];
            tempBuffer[6] = pLine[j + 3];
            tempBuffer[7] = pLine[j + 11];
            tempBuffer[8] = pLine[j + 4];
            tempBuffer[9] = pLine[j + 12];
            tempBuffer[10] = pLine[j + 5];
            tempBuffer[11] = pLine[j + 13];
            tempBuffer[12] = pLine[j + 6];
            tempBuffer[13] = pLine[j + 14];
            tempBuffer[14] = pLine[j + 7];
            tempBuffer[15] = pLine[j + 15];
            memcpy(pLine + j, tempBuffer, 16);
        }
    }
}


int bf_read_chipid(void)
{
    u8 val_low = 0, val_high = 0, version = 0;
    int chip_id = 0;
    u8	reg_value = 0;

    if(g_chip_type == BF3290) {
        bf_spi_write_reg (0x13, 0x00);
        reg_value = bf_spi_read_reg (0x3a);
        bf_spi_write_reg (0x3a, reg_value | 0x80);

        val_low = bf_spi_read_reg (0x10); //id reg low
        BF_LOG ("val_low=0x%x \n", val_low);

        val_high = bf_spi_read_reg (0x11); //id reg high
        BF_LOG ("val_high=0x%x \n", val_high);

        version = bf_spi_read_reg (0x12); //ic type
        BF_LOG ("version=0x%x \n", version);
        chip_id = (val_high << 8) | (val_low & 0xff);
        BF_LOG ("chip_id=%x \n", chip_id);
        bf_spi_write_reg (0x3a, reg_value);
    } else if(g_chip_type == BF3182 || g_chip_type == BF3390) {
        //enable 0x10 bit5
        reg_value = bf_spi_read_reg(0x10);
        reg_value &= ~(1 << 5);
        bf_spi_write_reg(0x10, reg_value);

        val_high = bf_spi_read_reg(0x37);
        val_low = bf_spi_read_reg(0x36);
        chip_id = (val_high << 8) | val_low;
        version = bf_spi_read_reg(0x38);

        //disabl 0x10 bit5
        reg_value |= (1 << 5);
        bf_spi_write_reg(0x10, reg_value);
    } else {
        val_high = bf_spi_read_reg(0x37);
        val_low = bf_spi_read_reg(0x36);
        chip_id = (val_high << 8) | val_low;
        version = bf_spi_read_reg(0x38);

        if(chip_id != BF3582P && chip_id != BF3582S) {
            //enable 0x10 bit5
            reg_value = bf_spi_read_reg(0x10);
            reg_value &= ~(1 << 5);
            bf_spi_write_reg(0x10, reg_value);

            val_high = bf_spi_read_reg(0x37);
            val_low = bf_spi_read_reg(0x36);
            chip_id = (val_high << 8) | val_low;
            version = bf_spi_read_reg(0x38);

            //disabl 0x10 bit5
            reg_value |= (1 << 5);
            bf_spi_write_reg(0x10, reg_value);
            if(chip_id != BF3182 && chip_id != BF3390) {
                bf_spi_write_reg (0x13, 0x00);
                reg_value = bf_spi_read_reg (0x3a);
                bf_spi_write_reg (0x3a, reg_value | 0x80);

                val_low = bf_spi_read_reg (0x10); //id reg low
                BF_LOG ("val_low=0x%x \n", val_low);

                val_high = bf_spi_read_reg (0x11); //id reg high
                BF_LOG ("val_high=0x%x \n", val_high);

                version = bf_spi_read_reg (0x12); //ic type
                BF_LOG ("version=0x%x \n", version);
                chip_id = (val_high << 8) | (val_low & 0xff);
                BF_LOG ("chip_id=%x \n", chip_id);
                bf_spi_write_reg (0x3a, reg_value);
            }
        }
    }


    BF_LOG(" chip_id=0x%x,version=0x%x\n", chip_id, version);
    return chip_id;
}

void bf_chip_info(void)
{
    BF_LOG("data:2017-12-18\n");
    g_chip_type = bf_read_chipid();
    if(g_chip_type == BF3390) {
        IM_WIDTH = 80;
        IM_HEIGHT = 80;
        g_bf_dev->m_dacp_reg = 0x1e;
    } else if(g_chip_type == BF3182) {
        IM_WIDTH = 72;
        IM_HEIGHT = 128; 
        g_bf_dev->m_dacp_reg = 0x1c;
    } else if(g_chip_type == BF3290) {
        IM_WIDTH = 112;
        IM_HEIGHT = 96;
        g_bf_dev->m_dacp_reg = 0x1b;
    } else if(g_chip_type == BF3582P) {
        IM_WIDTH = 60;
        IM_HEIGHT = 80;
        g_bf_dev->m_dacp_reg = 0x1c;
    } else if(g_chip_type == BF3582S) {
        IM_WIDTH = 64;
        IM_HEIGHT = 80;
        g_bf_dev->m_dacp_reg = 0x1c;
    }

    BF_LOG("BTL: chipid:%x\r\n", g_chip_type);
    BF_LOG("TA version:v3.2\n");
}

u8 bf_fp_dev_init(void)
{
	uint32_t i = 0;
    for(i = 0; i < btl_chip_parmas_t.init_params_counts; i++) {
        bf_spi_write_reg((btl_chip_parmas_t.chip_init_params + i)->addr, (btl_chip_parmas_t.chip_init_params + i)->value);
        BF_LOG("the reg is %02x\n", (btl_chip_parmas_t.chip_init_params + i)->addr);
        BF_LOG("the value is %02x\n", (btl_chip_parmas_t.chip_init_params + i)->value);

	}
    return 0;
}

u8 bf_read_fp_image(u8 *p_image_buffer, u8 im_width, u8 im_height)
{
    u8 reg_address = 0;
    int i, j;
    u8 temp_width = 64;
    int dma_size = 0;

    u8 data_rx[2];
    u8 data_tx[2];
    static u8 *rx_buffer = 0;
    static u8 *tx_buffer = 0;
    int status = 0;

    if(g_chip_type == BF3582P) {
        dma_size  = ((temp_width * im_height / 1024)+1)*1024;
        BF_LOG("the chip is BF3582P. capture width is %d \n ", temp_width);
    } else {
        dma_size  = ((im_width * im_height / 1024)+1)*1024;
    }

    memset(data_rx, 0, 2);
    memset(data_tx, 0, 2);

    if(g_chip_type == BF3290) {
        reg_address = 0x13 << 1;
    } else {
        reg_address = 0x34 << 1;
    }
    reg_address |= 0x80;
    data_tx[0] = reg_address;
    data_tx[1] = MODE_FG_PRINT;

    if(tx_buffer == 0) {
        tx_buffer = (u8*)__get_free_pages(GFP_KERNEL,get_order(dma_size));
    } else {
        memset(tx_buffer, 0, get_order(dma_size));
    }

    if(rx_buffer == 0) {
        rx_buffer = (u8*)__get_free_pages(GFP_KERNEL,get_order(dma_size));
    } else {
        memset(rx_buffer, 0, get_order(dma_size));
    }

    if(rx_buffer == 0 || tx_buffer == 0) {
        BF_LOG("bf_read_fp_image mallogc failed\n ");
        return -ENOMEM;
    }
    spi_send_cmd(g_bf_dev,data_tx,data_rx,2);

    reg_address = REGA_FINGER_CAP << 1;
    reg_address &= 0x7F;
    tx_buffer[0] = reg_address;

//    mtspi_set_dma_en(1);

    status = spi_send_cmd (g_bf_dev, tx_buffer,rx_buffer, dma_size);
    if(g_chip_type == BF3582P) {
        for(i = 0; i < im_height; i++)
            for (j = 0; j < im_width; j++)
                p_image_buffer[i * im_width + j] = rx_buffer[2 + i * temp_width + j];
    } else {
        memcpy(p_image_buffer, rx_buffer + 2, im_width * im_height);
    }

    if(g_chip_type == BF3582S)
	{
        exchange_odd_even_cols(p_image_buffer, im_width, im_height);
	}
	if(g_chip_type == BF3290) {
		for (i = 0; i < im_width*im_height; i++)
			p_image_buffer[i] = 255 - p_image_buffer[i];
        bf_spi_write_reg(0x13, 0x00);
        bf_spi_write_reg(0x13, 0x40);
        bf_spi_write_reg(0x13, 0);
    } else {
    	bf_spi_write_reg(0x34, 0x00);
        bf_spi_write_reg(0x13, 0x40);
        bf_spi_write_reg(0x13, 0x00);
    }
//    mtspi_set_dma_en(0);
    BF_LOG("bf_read_fp_image status :%d ...........................\n", status);
    return status;
}

u8  bf_set_interrupt_mode(u8 dacp)//,u8 gain1,u8 gain2)
{
    u8 val = 0;

    if(g_chip_type == BF3290) {
        if(bf_spi_read_reg(0x13) == MODE_FG_DT) {
            BF_LOG("bf_set_interrupt_mode------------");
            return 0;
        }

        BF_LOG("dacp:%d\n", dacp);
        bf_spi_write_reg(0x13, MODE_IDLE);
        bf_spi_write_reg(0x13, 0x40);
        bf_spi_write_reg(0x13, 0);
        bf_spi_write_reg(0x1b, dacp);
        val = bf_spi_read_reg(0x1b);
        if(val != dacp) {
            bf_spi_write_reg(0x1b, dacp);
            BF_LOG("write REGA_RX_DACP_LOW error\n");
        }

        bf_spi_write_reg(0x17, 0x2c);
        bf_spi_write_reg(0xd, g_bf_dev->m_fd_frame_val);	//frames 1
        bf_spi_write_reg(0x17, 0xac);

        bf_spi_write_reg(0x13, MODE_FG_DT);
    } else {
		BF_LOG(" 1 bf_set_interrupt_mode------------");
        if(bf_spi_read_reg(0x34) == MODE_FG_DT) {
            BF_LOG("bf_set_interrupt_mode------------");
            return 0;
        }
		BF_LOG(" 2 bf_set_interrupt_mode------------");
        bf_spi_write_reg(0x34, 0x00);
        bf_spi_write_reg(0x13, 0x40);
        bf_spi_write_reg(0x13, 0x00);
		BF_LOG(" 3 bf_set_interrupt_mode------------");
        //bf_spi_write_reg(0x14,0x11);
        //bf_spi_write_reg(0x15,0x28);
        //bf_spi_write_reg(0x16,0x75);

        bf_spi_write_reg(0x2B, g_bf_dev->m_fd_frame_val);	//FD 1 frame

        /*bf_spi_write_reg(0x1b, dacp);
        val = bf_spi_read_reg(0x1b);
        if (val != dacp) {
            BF_LOG(BTL_TAG"write REGA_RX_DACP_LOW error");
            bf_spi_write_reg (0x1b, dacp);
        }*/

        //bf_spi_write_reg(0x1b,dacp);
        bf_spi_write_reg(g_bf_dev->m_dacp_reg, dacp);
        val = bf_spi_read_reg(g_bf_dev->m_dacp_reg);
        if (val != dacp) {
            BF_LOG("write REGA_RX_DACP_LOW error%d\n", val);
            bf_spi_write_reg (g_bf_dev->m_dacp_reg, dacp);
        }

        bf_spi_write_reg (0x34, 0x02);
		BF_LOG(" 4 bf_set_interrupt_mode------------");
    }

    return 0;
}

u8 bf_set_capture_mode(u8 dacp)
{
    if(g_chip_type == BF3290) {
        bf_spi_write_reg(0x13, 0x0);
        bf_spi_write_reg(0x13, 0x40);
        bf_spi_write_reg(0x13, 0);
        bf_spi_write_reg(0x17, 0x2c);
        bf_spi_write_reg(0xd, g_bf_dev->m_cap_frame_val); //frames 4
        bf_spi_write_reg(0x17, 0xac);
        bf_spi_write_reg(0x1b, dacp);
        bf_spi_write_reg(0x13, MODE_FG_CAP);
    } else {
        bf_spi_write_reg(0x34, 0x00);
        bf_spi_write_reg(0x13, 0x40);
        bf_spi_write_reg(0x13, 0x00);

        //bf_spi_write_reg(0x14,0x1);
        //bf_spi_write_reg(0x15,0x80);
        //bf_spi_write_reg(0x16,0x91);

        bf_spi_write_reg(0x2B, g_bf_dev->m_cap_frame_val);		//CAP 8 frames
        //bf_spi_write_reg(0x31,0x7f);
        //bf_spi_write_reg(0x31,0x6e);
        //bf_spi_write_reg(0x32,0x48);
        //bf_spi_write_reg (0x1c, dacp);
        bf_spi_write_reg (g_bf_dev->m_dacp_reg, dacp);
        bf_spi_write_reg (0x34, 0x04);
    }

    return 0;
}



