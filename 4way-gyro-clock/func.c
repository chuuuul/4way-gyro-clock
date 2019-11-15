#ifndef _func_
#define _func_



void lcd_out()
{
    switch(mode)
    {
        case 1 :
            if( clock_config_flag == 0 )       // config_flag 0 이면 시계 표시
                clock_display();
            else if( clock_config_flag == 1 )  // config_flag 1 이면 설정 모드
                {
                    clock_config();
                }
            break;
        case 2 :
            alarm_display();

            break;
        case 3 :
            timer_display();

            break;
        case 4 :
            printf("temp = %d C \r\n",int_temp);
            temp_display();
            break;
    }
}


void ring_the_bell (void)
{
        if (bellbell_flag == 1)
        {
            bellbell_flag = 2 ;
            PORTE.2 = 1;
        }
        else if (bellbell_flag == 2)
        {
            PORTE.2 = 0;
            bellbell_flag = 1;
        }
}


void clock_position_carry(void)   // 시계 자리수 올림
{
    if( time.sec >= 60)
    {
        time.min++;
        time.sec = 0;
    }
    if( time.min >= 60)
    {
        time.hour++;
        time.min=0;
    }
    if( time.hour > 23)
    {
        time.hour = 0;
    }
    if( time.sec < 0) time.sec  = 59;
    if( time.min < 0) time.min  = 59;
    if( time.hour < 0) time.sec = 23;
}




void alarm_position_carry(void)   // 알람 자리수 올림
{
    if( alarm.sec >= 60) alarm.sec = 0;
    if( alarm.min >= 60) alarm.min=0;
    if( alarm.hour >= 24) alarm.hour = 0;
    if( alarm.sec < 0) alarm.sec  = 59;
    if( alarm.min < 0) alarm.min  = 59;
    if( alarm.hour < 0) alarm.sec = 23;
}
void timer_position_carry(void)   // 타이머 자리수 올림
{
    if( timer.sec >= 60) timer.sec = 0;
    if( timer.min >= 60) timer.min=0;
    if( timer.hour >= 24) timer.hour = 0;
    if( timer.sec < 0)
    {
        timer.min--;
        timer.sec  = 59;
    }
    if( timer.min < 0)
    {
        timer.min  = 59;
        timer.hour--;
    }
    if( timer.hour < 0)
    {
        timer.hour=23;
    }
}


void clock_config(void)
{


    LCD_string(0x10, "Time Setting",2,0);

    LCD_string(0x10," ",5,1);
    LCD_data((time.hour/10) + 0x30);
    LCD_data((time.hour%10) + 0x30);
    LCD_data(':');
    LCD_data((time.min/10) + 0x30);
    LCD_data((time.min%10) + 0x30);
    LCD_data(':');
    LCD_data((time.sec/10) + 0x30);
    LCD_data((time.sec%10) + 0x30);
    LCD_data(' ');
}

void clock_display(void)
{

    printf("clock \n\r");


    LCD_string(0x10, "Clock",2,0);

    LCD_string(0x10," ",5,1);
    LCD_data((time.hour/10) + 0x30);
    LCD_data((time.hour%10) + 0x30);
    LCD_data(':');
    LCD_data((time.min/10) + 0x30);
    LCD_data((time.min%10) + 0x30);
    LCD_data(':');
    LCD_data((time.sec/10) + 0x30);
    LCD_data((time.sec%10) + 0x30);
    LCD_data(' ');

    printf("시간 : %d시 %d분 %d초\n\r", time.hour, time.min, time.sec);

}

void alarm_display(void)
{
    printf("alarm \n\r");

    if(alarm_flag == 1)
    {
        LCD_string(0x10, "Alarm ON    ",2,0);
    }
    else
    {
        LCD_string(0x10, "Alarm OFF",2,0);
    }

    LCD_string(0x10," ",5,1);
    LCD_data((alarm.hour/10) + 0x30);
    LCD_data((alarm.hour%10) + 0x30);
    LCD_data(':');
    LCD_data((alarm.min/10) + 0x30);
    LCD_data((alarm.min%10) + 0x30);
    LCD_data(':');
    LCD_data((alarm.sec/10) + 0x30);
    LCD_data((alarm.sec%10) + 0x30);
    LCD_data(' ');
}

void timer_display(void)
{
    printf("timer \n\r");

    if(timer_flag == 0 )
        LCD_string(0x10, "Timer OFF",2,0);
    if(timer_flag == 1 )
        LCD_string(0x10, "Timer ON    ",2,0);


    LCD_string(0x10," ",5,1);
    LCD_data((timer.hour/10) + 0x30);
    LCD_data((timer.hour%10) + 0x30);
    LCD_data(':');
    LCD_data((timer.min/10) + 0x30);
    LCD_data((timer.min%10) + 0x30);
    LCD_data(':');
    LCD_data((timer.sec/10) + 0x30);
    LCD_data((timer.sec%10) + 0x30);
    LCD_data(' ');
}

void temp_display(void)
{
    printf("Temp \n\r");

    LCD_string(0x10, "Temperature",2,0);

    LCD_string(0x10," ",5,1);
    LCD_data((int_temp/100) + 0x30);
    LCD_data((int_temp%100/10) + 0x30);
    LCD_data('.');
    LCD_data((int_temp%10) + 0x30);
    LCD_data(' ');
    LCD_data('C');
    LCD_data(' ');
    LCD_data(' ');
    LCD_data(' ');

}

#endif