#ifndef _key_func_
#define _key_func_


char key_in(void)            // 키입력 감지 함수
{
  char buf = 0;
  
  if( (PINC & 0x7F) != 0x00)
   {         
     buf = (PINC & 0x7F) ;
     key_flag = 1;            // 키를 입력받았는지 확인
     
     while( (PINC & 0x7F)  != 0x00)     // 누르는 동안에도 display 표시
      {
        //lcd_out();                    // 캐터링
      }
   }
  return buf;
}


void key_chk(void)
{

    key_flag = 0;
    switch(key)
    {
     case 0x01:             // hour setting
        if (up_down_flag == 0)
        {
            if(mode == 1)
                time.hour++;
            if(mode == 2)
                alarm.hour++;
            if(mode == 3)
                timer.hour++;
        }        
        if (up_down_flag == 1)
        {
            if(mode == 1)
                time.hour--;
            if(mode == 2)
                alarm.hour--;
            if(mode == 3)
                timer.hour--; 
        }
        break;   
                    
     case 0x02:             // min setting
        if (up_down_flag == 0)
        {
            if(mode == 1)
                time.min++;
            if(mode == 2)
                alarm.min++;
            if(mode == 3)
                timer.min++;
        }                  
        
        if (up_down_flag == 1)
        {
            if(mode == 1)
                time.min--;
            if(mode == 2)
                alarm.min--;
            if(mode == 3)
                timer.min--; 
        }
        break;   
                    
     case 0x04:             // sec setting
        if (up_down_flag == 0)
        {
            if(mode == 1)
                time.sec++;
            if(mode == 2)
                alarm.sec++;
            if(mode == 3)
                timer.sec++;
        }        
        if (up_down_flag == 1)
        {
            if(mode == 1)
                time.sec--;
            if(mode == 2)
                alarm.sec--; 
            if(mode == 3)
                timer.sec--;
        }
        break;   
                    
     case 0x08:             // Up, Down Toggle
        up_down_flag = ~up_down_flag;
        break;            
    } 
    
    if(mode==2)  alarm_position_carry();
    if(mode==3)  timer_position_carry(); 
  
}
#endif
