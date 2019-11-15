#define g_int_en #asm("sei")
#define g_int_ds #asm("cli")
#define g_en  SREG = 0x80       //전역 인터럽트 활성화

#define key1 PIND.0
#define key2 PIND.1
#define key3 PIND.2
#define key4 PIND.3

#define key5 PINE.4
#define key6 PINE.5
#define key7 PINE.6
#define key8 PINE.7

#define RS  0 // RRL BOARD
#define RW  1
#define E   2
#define DATABUS PORTA
#define CTRLBUS PORTB

#define F_CPU 16000000UL


#define   LCD_CLR               (_lcd_write_data(0x01))  // lcd clear
#define   TCNT0_RESET            TCNT0=125


interrupt [TIM0_OVF] void timer0_ovf_isr(void) ;
void dgree_to_mode(void);
void input_gyro_data(void);
void clock_position_carry(void);                          // 시계 자리수 올림
void clock_config(void);
void lcd_out(void);
void clock_display(void);
//void set_init(void);

void alarm_display(void);
void alarm_position_carry(void);
void timer_display(void);
void timer_position_carry(void);
void ring_the_bell(void);
void temp_display(void);
void LCD_controller(unsigned char control);
void LCD_data(unsigned char Data);
void LCD_string(unsigned char address, char *Str,char x,char y);
void LCD_clear();
void LCD_initialize();


///////////////////////////////// 자이로 관련/////////////////////////
void input_gyro_data(void);
void dgree_to_mode(void);
volatile unsigned char gx_low, gx_high=0; // x축 low/high값 자이로 변수
volatile unsigned char gy_low, gy_high=0; // y축 low/high값 자이로 변수
volatile unsigned char gz_low, gz_high=0; // z축 low/high값 자이로 변수
volatile unsigned char ax_low, ax_high=0; // x축 low/high값 가속도 변수
volatile unsigned char ay_low, ay_high=0; // y축 low/high값 가속도 변수
volatile unsigned char az_low, az_high=0; // z축 low/high값 가속도 변수
volatile long gx,gy,gz,ax,ay,az;
volatile float angle_x=0,deg_x=0,angle_y=0,deg_y=0;
volatile float dgy_x,dgy_y;                  // double type acc data
volatile unsigned char temp_low=0 , temp_high=0; // 온   도
volatile float temp;

int int_temp;
/////////////////////////////////////////////////////////////////////

///////////////////////////////시계 관련///////////////////////////////

bit key_flag,up_down_flag;


struct clock
{
    signed char sec;
    signed char min;
    signed char hour;
    signed int t_loop;
}time, alarm, timer= { 0, 0, 0, 0 };

bit timer_flag = 0;
bit clock_config_flag = 0;
bit pause_flag = 0;
bit alarm_flag = 0;
bit refresh_flag = 0;
char bellbell_flag = 0;
unsigned long time_loop = 0;
char mode;
unsigned char key;
char state;



/////////////////////////////////////////////////////////////////////