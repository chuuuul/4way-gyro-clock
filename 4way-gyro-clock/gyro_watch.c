
/////////////////  �޴���  /////////////////////
//  mode = 1 : �ð�
//  mode = 2 : �˶�
//  mode = 3 : Ÿ�̸�
//  mode = 4 : �µ�
/////////////////////////////////////////////
#include <mega128.h>
#include <delay.h>
#include <stdio.h>
#include <math.h>
#include <clock.h>
//#include <alcd.h>

#include "key_func.c"
#include "func.c"
#include "ext_int.c"
#include "uart.c"
#include "i2c.c"
#include "gyro_func.c"
#include "lcd_con.c"

void main(void)
{

//####################### ����Ǯ�� ##################################
    DDRD = 0x3F;     //�ܺ����ͷ�Ʈ �Է¼��� ����4��Ʈ ���, ����4��Ʈ �Է�
    PORTD = 0xF0;
    PORTB = 0xFF;
    SFIOR = 0xFB & SFIOR;   // Atmega ����Ǯ�� ��� : ddrx = 0 / portx = 1 / pud = 0
    uart0_init();
//#################################################################
    DDRA = 0xFF;
    DDRB = 0xFF;

    // Ÿ�̸�0 �����÷ο� ���ͷ�Ʈ
    TCCR0= 0x05;     // Prescale : 128
    TIMSK=0x01;
    TCNT0 = 131;       //256-125 = 131
    //1/ 16000000 *  128  * 125 = 1ms,  (256-125)=131

    DDRE = 0x04;        // �������� PORTE.2


    EIMSK = 0x80;   //int0~7 �پ��Ŵϱ�
    //EICRA = 0xff;   //int0~3 ���� ��¿����� �������� �۵��ϰ�
    EICRB = 0x80;   //int4~7 ���� ��¿�����

    //�ڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡ� Proteus : �ּ�ó�� / ���� : �ּ����� �ڡڡڡڡڡڡڡڡڡڡڡڡ�
    I2C_init();
    //�ڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡ�
    printf("start\r\n");


    LCD_initialize();

    LCD_string(0x10, "Digital Clock",1,0);
    LCD_string(0x10, "with Gyro",1,1);

    delay_ms(1000);
    LCD_clear();

    #asm("sei")

    while(1)
    {
            delay_ms(100);
            input_gyro_data();                // ���̷� �� -> ���� ���, ����
            dgree_to_mode();                   // ���� �� -> ��� ��ȯ


            if (state != mode)
            {
                refresh_flag=1;
                state = mode;
            }

            switch(mode)
            {
            case 1:
                if (pause_flag == 1)
                {
                    key = key_in();
                    if(key_flag == 1) key_chk();
                }
                break;

            case 2:
                key = key_in();
                if(key_flag == 1) key_chk();
                break;

            case 3:
                if(timer_flag == 0)
                {
                    key = key_in();
                    if(key_flag == 1) key_chk();
                }
            }

    }


}
