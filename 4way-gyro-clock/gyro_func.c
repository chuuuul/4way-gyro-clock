#ifndef _gyro_func_
#define _gyro_func_


void dgree_to_mode(void){

    if(deg_y >= 315 || deg_y <= 45 )        // -45 ~ 45�� �����Լ�
    {
        printf("mode : 1 \n\r");
        mode = 1;
    }
    if(deg_y >= 45 && deg_y <= 135 )        //45 ~ 135�� �����Լ�
    {
        printf("mode : 2 \n\r");
        mode = 2;
    }
    if(deg_y >= 135 && deg_y <= 225 )       // 135 ~ 255�� �����Լ�
    {
        mode = 3;
        printf("mode : 3 \n\r");
    }
    if(deg_y >= 225 && deg_y <= 315 )       // 225 ~ 315�� �����Լ�
    {
        mode = 4;
        printf("mode : 4 \n\r");
    }
}

void input_gyro_data(void)
{
    ////////////////////���̷�////////////////////
    gx_high=read(0x43);  //���̷� x high�� �о����
    gy_high=read(0x45);  //���̷� y high�� �о����
    gz_high=read(0x47);  //���̷� z high�� �о����

    gx_low=read(0x44);   //���̷� x low�� �о����
    gy_low=read(0x46);   //���̷� y low�� �о����
    gz_low=read(0x48);   //���̷� z low�� �о����

    temp_high = read(0x41);
    temp_low = read(0x42);

    gx = (gx_high<<8) | (gx_low);
    gy = (gy_high<<8) | (gy_low);
    gz = (gz_high<<8) | (gz_low);

    temp = (temp_high <<8) | temp_low ;
    temp = temp/340 + 36.53;
    int_temp = temp*10;     //�Ҽ��� 1�ڸ������� ��Ÿ�������� *10 �ؼ� ��Ʈ������ ��ȯ

    //////////////////////////////////////////
    /////////////////���ӵ�////////////////////

    ax_high=read(0x3b);  //���ӵ� x high�� �о����
    ay_high=read(0x3d);  //���ӵ� y high�� �о����
    az_high=read(0x3f);  //���ӵ� z high�� �о����


    ax_low=read(0x3c);   //���̷� x low�� �о����
    ay_low=read(0x3e);   //���̷� y low�� �о����
    az_low=read(0x40);   //���̷� z low�� �о����

    ax = (ax_high<<8) | (ax_low);
    ay = (ay_high<<8) | (ay_low);
    az = (az_high<<8) | (az_low);

    delay_ms(300);

    //�����ͺκ�

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
