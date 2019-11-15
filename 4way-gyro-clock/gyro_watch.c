
/////////////////  메뉴얼  /////////////////////
//  mode = 1 : 시계
//  mode = 2 : 알람
//  mode = 3 : 타이머
//  mode = 4 : 온도
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

//####################### 내부풀업 ##################################
    DDRD = 0x3F;     //외부인터럽트 입력선언 상위4비트 출력, 하위4비트 입력
    PORTD = 0xF0;
    PORTB = 0xFF;
    SFIOR = 0xFB & SFIOR;   // Atmega 내부풀업 사용 : ddrx = 0 / portx = 1 / pud = 0
    uart0_init();
//#################################################################
    DDRA = 0xFF;
    DDRB = 0xFF;

    // 타이머0 오버플로우 인터럽트
    TCCR0= 0x05;     // Prescale : 128
    TIMSK=0x01;
    TCNT0 = 131;       //256-125 = 131
    //1/ 16000000 *  128  * 125 = 1ms,  (256-125)=131

    DDRE = 0x04;        // 부저전용 PORTE.2


    EIMSK = 0x80;   //int0~7 다쓸거니까
    //EICRA = 0xff;   //int0~3 전부 상승엣지로 눌렸을때 작동하게
    EICRB = 0x80;   //int4~7 전부 상승엣지로

    //★★★★★★★★★★★★★★★★★ Proteus : 주석처리 / 빵판 : 주석해제 ★★★★★★★★★★★★★
    I2C_init();
    //★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
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
            input_gyro_data();                // 자이로 값 -> 각도 계산, 보정
            dgree_to_mode();                   // 각도 값 -> 모드 변환


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
