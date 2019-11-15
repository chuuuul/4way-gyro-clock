#ifndef _gyro_func_
#define _gyro_func_


void dgree_to_mode(void){

    if(deg_y >= 315 || deg_y <= 45 )        // -45 ~ 45도 실행함수
    {
        printf("mode : 1 \n\r");
        mode = 1;
    }
    if(deg_y >= 45 && deg_y <= 135 )        //45 ~ 135도 실행함수
    {
        printf("mode : 2 \n\r");
        mode = 2;
    }
    if(deg_y >= 135 && deg_y <= 225 )       // 135 ~ 255도 실행함수
    {
        mode = 3;
        printf("mode : 3 \n\r");
    }
    if(deg_y >= 225 && deg_y <= 315 )       // 225 ~ 315도 실행함수
    {
        mode = 4;
        printf("mode : 4 \n\r");
    }
}

void input_gyro_data(void)
{
    ////////////////////자이로////////////////////
    gx_high=read(0x43);  //자이로 x high값 읽어오기
    gy_high=read(0x45);  //자이로 y high값 읽어오기
    gz_high=read(0x47);  //자이로 z high값 읽어오기

    gx_low=read(0x44);   //자이로 x low값 읽어오기
    gy_low=read(0x46);   //자이로 y low값 읽어오기
    gz_low=read(0x48);   //자이로 z low값 읽어오기

    temp_high = read(0x41);
    temp_low = read(0x42);

    gx = (gx_high<<8) | (gx_low);
    gy = (gy_high<<8) | (gy_low);
    gz = (gz_high<<8) | (gz_low);

    temp = (temp_high <<8) | temp_low ;
    temp = temp/340 + 36.53;
    int_temp = temp*10;     //소수점 1자리까지만 나타내기위해 *10 해서 인트형으로 변환

    //////////////////////////////////////////
    /////////////////가속도////////////////////

    ax_high=read(0x3b);  //가속도 x high값 읽어오기
    ay_high=read(0x3d);  //가속도 y high값 읽어오기
    az_high=read(0x3f);  //가속도 z high값 읽어오기


    ax_low=read(0x3c);   //자이로 x low값 읽어오기
    ay_low=read(0x3e);   //자이로 y low값 읽어오기
    az_low=read(0x40);   //자이로 z low값 읽어오기

    ax = (ax_high<<8) | (ax_low);
    ay = (ay_high<<8) | (ay_low);
    az = (az_high<<8) | (az_low);

    delay_ms(300);

    //상보필터부분

    deg_x = atan2(ax, az) * 180 / PI  ;  //rad to deg
    dgy_x = gy / 131.0f  ;  //16-bit data to 250 deg/sec
    angle_x = (0.95 * (angle_x + (dgy_x * 0.001))) + (0.05 * deg_x) ; //complementary filter


    deg_y = atan2(ay, ax)*180 / PI ;
    dgy_y = gz / 131.f ;
    angle_y = (0.95 * (angle_y + (dgy_y * 0.001))) + (0.05 * deg_y); ; //complementary filter

    deg_x = deg_x+180;
    deg_y = deg_y+180;

}



#endif
