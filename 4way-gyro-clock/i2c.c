#ifndef _i2c_
#define _i2c_

#define SLA             0xd0
#define r_mode          1
#define w_mode          0


void I2C_write(unsigned char add,unsigned char dat); // 쓰기
unsigned char read(char addr); // 읽기


// 최대속도 400kbps 를 지원
// SCL Freq =  cpu clock / (16+2(TWBR)*4^TWPS)  // cpu clock = 160000 twps = 0
// 400k = 160000 / (16+ (2 *TWBR * 1)
// TWBR = 12 -> 0x0C


/*
레지스터 종류는
TWAR (Address Resgister)       // TWAR : 슬레이브 전송기나 슬레이브 수신기로 프로그램 되었을 때
                                         TWI 가 응답할 7 비트의 슬레이브 주소를 라이트 합니다.
TWBR (Bit Rate Register)       // TWBR : 비트 레이트 발생기의 나눗셈 비율을 결정합니다
TWCR (Control Register)        // TWCR : TWI 의 동작을 제어합니다.
TWDR (Address/Data Shift)      // 송신모드 : 다음 전송할 데이터를 갖는다 // 수신모드 : 수신된 이전 데이터를 갖는다.
TWSR (Status Register)         // TWPS(0~1) : 비트레이트 프리스케일러 제어 // TWS(3~7) : TWI로직과 TWI버스상태 나타냄

TWCR 레지스터 ( mega128_bits.h에 정의되어있음)
#define TWIE    0     // (Interrupt Enable)이 비트가 1 이고 SREG 레지스터의 비트가 1 로 셋되어 있으면 TWINT 플래그가 1 이 동안 TWI 인터럽트 요구가 활성화
#define TWEN    2     // (TW Enable)TWEN 비트에 1 을 쓰면 TWI 작동이 가능하게 됩니다. // TWEN 비트에 0 을 쓰면 TWI 작동은 불가능으로 됩니다.
#define TWWC    3     // 설정 x  // TWI 데이터 레지스터(TWDR)에 쓰려고 할 때 TWWC bit가 1이 된다.
                         이 때 TWINT bit가 low인 상태이어야 한다. 이 플래그는 TWINT가 1인 상태에서 TWDR 레지스터에 쓰면 클리어된다.
#define TWSTO   4     // 마스터 모드에서 2 선 시리얼 버스상에서 STOP 신호를 발생시키기 위하여 1 을 씁니다. TWSTO 비트는 자동으로 클리어됩니다.
#define TWSTA   5     // 2선 시리얼 버스상에서 마스터가 되고자 할 때 TWSTA 비트에 1 을 씁니다
#define TWEA    6     // TWEA 비트는 확인 신호(Acknoledge) 펄스를 발생시키는 것을 제어합니다.
#define TWINT   7     // (Interrupt Flag)이 비트는 현재 작업이 끝났을 때 하드웨어에 의해서 '1'로 설정된다.
                         SREG의 I비트와 TWCR의 TWIE가 '1'로 설정되었다면, MCU가 TWI interrupt vector로 점프시킨다.
                         TWINT 플래그는 해당 비트를 '1'로 쓰는 것으로 소프트웨어에 의한 클리어를 해야만 한다.
                         이 비트는 하드웨어에 의해 자동으로 클리어 되지 않는다. 그래서 TWI 연산을 하기 위해 처음에 클리어 되어야만 한다.

*/


void I2C_init(void)
{
    TWSR = 0x00;
    TWBR = 0x0C;            // 400Kbps 로 설정

    TWCR = (1<<TWEN);       // 0x04 TWEN이 1이어야지 작동

    I2C_write(0x1B,0x00);                   //MPU6050 초기화
    I2C_write(0x6B,0x00);                   //MPU6050 초기화
    I2C_write(0x6C,0x00);                   //MPU6050 초기화

}

void I2C_write(unsigned char add,unsigned char dat) //자이로 센서 설정
{

    TWCR = ( 1<<TWEN | 1<<TWSTA | 1<<TWINT ); //0xA4     // TWEN으로 Enable 하고 TWSTA로 마스터 설정하고 TWINT는 1로 시작

    while((TWCR&0x80)==0x00); // 전송 대기  // twint 가 1인지 확인하는것인데 twint가 1이면 0이 될때까지 기다린다
    while((TWSR&0xF8)!=0x08); //신호 대기   // twsr이 0x08이면 start 코드 전송 완료

    TWDR=SLA + w_mode; // AD+W저장
    TWCR=0x84; // 전송

    while((TWCR&0x80)==0x00); //전송대기
    while((TWSR&0xF8)!=0x18); //ACK대기


    TWDR=add; // RA
    TWCR=0x84; // 전송

    while((TWCR&0x80)==0x00);
    while((TWSR&0xF8)!=0x28); // ACK

    TWDR=dat; // DATA
    TWCR=0x84; // 전송


    while((TWCR&0x80)==0x00);
    while((TWSR&0xF8)!=0x28); // ACK

    TWCR|=0x94; // P
    delay_us(50);  // 50us
}



unsigned char read(char addr) //자이로 센서 값 읽어오기
{
    unsigned char data; // data넣을 변수

    TWCR=0xA4; // S

    while((TWCR&0x80)==0x00); //통신대기
    while((TWSR&0xF8)!=0x08); //신호대기


    TWDR=SLA + w_mode; // AD+W
    TWCR=0x84; // 전송

    while((TWCR&0x80)==0x00); //통신대기
    while((TWSR&0xF8)!=0x18); //ACK
    TWDR=addr; // RA
    TWCR=0x84; //전송



    while((TWCR&0x80)==0x00); //통신대기
    while((TWSR&0xF8)!=0x28); //ACK
    TWCR=0xA4; // RS

    while((TWCR&0x80)==0x00); //통신대기
    while((TWSR&0xF8)!=0x10); //ACK
    TWDR=SLA + r_mode; // AD+R
    TWCR=0x84; //전송


    while((TWCR&0x80)==0x00); //통신대기
    while((TWSR&0xF8)!=0x40); // ACK
    TWCR=0x84;//전송

    while((TWCR&0x80)==0x00); //통신대기
    while((TWSR&0xF8)!=0x58); //ACK
    data=TWDR;

    TWCR=0x94; // P
    delay_us(50);  // 50us
    return data;

}






#endif