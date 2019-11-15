#ifndef _lcd_con_
#define _lcd_con_



void LCD_controller(unsigned char control)
{
    delay_ms(1);
    CTRLBUS = 0x00; //RW clear.
    delay_ms(1); //RW & RS Setup time is 40ns min.
    CTRLBUS |= 1<<E; // E set.
    delay_ms(1); //Data Setup time is 80ns min.
    DATABUS = control; // Data input.
    delay_ms(1); // valid data is 130ns min.
    CTRLBUS = (1<<RS)|(1<<RW)|(0<<E); // RS set. RW set. E clear.
}

void LCD_data(unsigned char Data)
{
    delay_ms(1);
    CTRLBUS = 1<<RS; //RS set. RW clear. E clear.
    delay_ms(1); //RW & RS Setup time is 40ns min.
    CTRLBUS |= 1<<E; // E set.
    delay_ms(1); //Data Setup time is 80ns min.
    DATABUS = Data; // Data input.
    delay_ms(1); // valid data min is 130ns.
    CTRLBUS = 1<<RW; // RS clear. RW set. E clear.
}

void LCD_string(unsigned char address, char *Str,char x,char y)
{

    int i=1;

    if(y==1)
        i = 17;



    LCD_controller(address); // LCD display start position
    while(*Str!=0)
    {

        if(address+i == 0x21)
            LCD_controller(0xc0); // second line display
        while(x>0)
        {
            x--;
            LCD_data(' ');
        }
        LCD_data(*Str);
        i++;
        Str++;
    }
}


void LCD_clear()
{
    LCD_string(0x10," ",0,0);
    LCD_controller(0x01); // Display Clear.
    delay_us(2);
}

void LCD_initialize()
{
    /* 8bit interface mode */
    delay_ms(50);
    LCD_controller(0x3c); // Function set. Use 2-line, display on.
    delay_ms(40); // wait for more than 39us.
    LCD_controller(0x0c); // Display ON/OFF Control. display on ,cursor off,blink off
    delay_ms(40); // wait for more than 39us.
    LCD_controller(0x01); // Display Clear.
    delay_ms(1); // wait for more than 1.53ms.
    LCD_controller(0x06); // Entry Mode Set. I/D increment mode, entire shift off
}

#endif
