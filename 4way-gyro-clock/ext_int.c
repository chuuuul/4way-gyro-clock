#ifndef _ext_int_
#define _ext_int_

interrupt [TIM0_OVF] void timer0_ovf_isr(void)      // 0.001�ʸ��� ����
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
            bellbell_flag = 1; //�˶� ���� ���� / �˶� ����


        if(timer_flag == 1)
        {
            timer.sec--;
            timer_position_carry();
            if(timer.sec + timer.min + timer.hour == 0)        // Ÿ�̸Ӱ� 00000�Ǹ� �˶�
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
        lcd_out();      //LCD ǥ���� ���� ���� ��������


    }

}



/*
interrupt [EXT_INT6] void ext_int6_isr(void)
{
        mode++;
        if(mode > 3) mode = 1;
        printf("������� %d�Դϴ� \r\n",mode);
}*/

interrupt [EXT_INT7] void ext_int7_isr(void)            // �������
{
    printf("special key interrupt \r\n");


    while( (PINE & 0x80) != 0x00)     // ������ ���ȿ��� display ǥ��
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
        case 1:    //�ð����϶�
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
