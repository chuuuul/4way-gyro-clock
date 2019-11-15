#ifndef _ext_int_
#define _ext_int_

interrupt [TIM0_OVF] void timer0_ovf_isr(void)      // 0.001초마다 실행
{

    time_loop++;
    TCNT0 = 131;
    if(time_loop==1000)
    {
        if(pause_flag == 0)
            time.sec++;
        time_loop = 0;
        clock_position_carry();

        if((alarm_flag == 1) && (time.hour == alarm.hour) && (time.min == alarm.min) && (time.sec == alarm.sec))
            bellbell_flag = 1; //알람 시작 조건 / 알람 시작


        if(timer_flag == 1)
        {
            timer.sec--;
            timer_position_carry();
            if(timer.sec + timer.min + timer.hour == 0)        // 타이머가 00000되면 알람
            {
                timer_flag = 0;
                bellbell_flag = 1;
            }
        }

        if( bellbell_flag > 0)
            ring_the_bell();


        if(refresh_flag == 1)
        {
            LCD_clear();
            refresh_flag = 0;
        }
        lcd_out();      //LCD 표현의 거의 모든게 여기있음


    }

}



/*
interrupt [EXT_INT6] void ext_int6_isr(void)
{
        mode++;
        if(mode > 3) mode = 1;
        printf("현재모드는 %d입니다 \r\n",mode);
}*/

interrupt [EXT_INT7] void ext_int7_isr(void)            // 수정모드
{
    printf("special key interrupt \r\n");


    while( (PINE & 0x80) != 0x00)     // 누르는 동안에도 display 표시
    {
        delay_ms(10);
    }

    if(bellbell_flag > 0)
    {
        bellbell_flag = 0;
        PORTE.2 = 0;
    }

    else
    {
        switch (mode)
        {
        case 1:    //시계모드일때
            clock_config_flag = ~ clock_config_flag;
            pause_flag = ~pause_flag;
            break;
        case 2:
            alarm_flag = ~ alarm_flag;

            break;

        case 3:
            timer_flag = ~timer_flag ;

            break;

        case 4:

            break;
        }

    }
    refresh_flag = 1;
}
#endif
