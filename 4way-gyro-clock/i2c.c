#ifndef _i2c_
#define _i2c_

#define SLA             0xd0
#define r_mode          1
#define w_mode          0


void I2C_write(unsigned char add,unsigned char dat); // ����
unsigned char read(char addr); // �б�


// �ִ�ӵ� 400kbps �� ����
// SCL Freq =  cpu clock / (16+2(TWBR)*4^TWPS)  // cpu clock = 160000 twps = 0
// 400k = 160000 / (16+ (2 *TWBR * 1)
// TWBR = 12 -> 0x0C


/*
�������� ������
TWAR (Address Resgister)       // TWAR : �����̺� ���۱⳪ �����̺� ���ű�� ���α׷� �Ǿ��� ��
                                         TWI �� ������ 7 ��Ʈ�� �����̺� �ּҸ� ����Ʈ �մϴ�.
TWBR (Bit Rate Register)       // TWBR : ��Ʈ ����Ʈ �߻����� ������ ������ �����մϴ�
TWCR (Control Register)        // TWCR : TWI �� ������ �����մϴ�.
TWDR (Address/Data Shift)      // �۽Ÿ�� : ���� ������ �����͸� ���´� // ���Ÿ�� : ���ŵ� ���� �����͸� ���´�.
TWSR (Status Register)         // TWPS(0~1) : ��Ʈ����Ʈ ���������Ϸ� ���� // TWS(3~7) : TWI������ TWI�������� ��Ÿ��

TWCR �������� ( mega128_bits.h�� ���ǵǾ�����)
#define TWIE    0     // (Interrupt Enable)�� ��Ʈ�� 1 �̰� SREG ���������� ��Ʈ�� 1 �� �µǾ� ������ TWINT �÷��װ� 1 �� ���� TWI ���ͷ�Ʈ �䱸�� Ȱ��ȭ
#define TWEN    2     // (TW Enable)TWEN ��Ʈ�� 1 �� ���� TWI �۵��� �����ϰ� �˴ϴ�. // TWEN ��Ʈ�� 0 �� ���� TWI �۵��� �Ұ������� �˴ϴ�.
#define TWWC    3     // ���� x  // TWI ������ ��������(TWDR)�� ������ �� �� TWWC bit�� 1�� �ȴ�.
                         �� �� TWINT bit�� low�� �����̾�� �Ѵ�. �� �÷��״� TWINT�� 1�� ���¿��� TWDR �������Ϳ� ���� Ŭ����ȴ�.
#define TWSTO   4     // ������ ��忡�� 2 �� �ø��� �����󿡼� STOP ��ȣ�� �߻���Ű�� ���Ͽ� 1 �� ���ϴ�. TWSTO ��Ʈ�� �ڵ����� Ŭ����˴ϴ�.
#define TWSTA   5     // 2�� �ø��� �����󿡼� �����Ͱ� �ǰ��� �� �� TWSTA ��Ʈ�� 1 �� ���ϴ�
#define TWEA    6     // TWEA ��Ʈ�� Ȯ�� ��ȣ(Acknoledge) �޽��� �߻���Ű�� ���� �����մϴ�.
#define TWINT   7     // (Interrupt Flag)�� ��Ʈ�� ���� �۾��� ������ �� �ϵ��� ���ؼ� '1'�� �����ȴ�.
                         SREG�� I��Ʈ�� TWCR�� TWIE�� '1'�� �����Ǿ��ٸ�, MCU�� TWI interrupt vector�� ������Ų��.
                         TWINT �÷��״� �ش� ��Ʈ�� '1'�� ���� ������ ����Ʈ��� ���� Ŭ��� �ؾ߸� �Ѵ�.
                         �� ��Ʈ�� �ϵ��� ���� �ڵ����� Ŭ���� ���� �ʴ´�. �׷��� TWI ������ �ϱ� ���� ó���� Ŭ���� �Ǿ�߸� �Ѵ�.

*/


void I2C_init(void)
{
    TWSR = 0x00;
    TWBR = 0x0C;            // 400Kbps �� ����

    TWCR = (1<<TWEN);       // 0x04 TWEN�� 1�̾���� �۵�

    I2C_write(0x1B,0x00);                   //MPU6050 �ʱ�ȭ
    I2C_write(0x6B,0x00);                   //MPU6050 �ʱ�ȭ
    I2C_write(0x6C,0x00);                   //MPU6050 �ʱ�ȭ

}

void I2C_write(unsigned char add,unsigned char dat) //���̷� ���� ����
{

    TWCR = ( 1<<TWEN | 1<<TWSTA | 1<<TWINT ); //0xA4     // TWEN���� Enable �ϰ� TWSTA�� ������ �����ϰ� TWINT�� 1�� ����

    while((TWCR&0x80)==0x00); // ���� ���  // twint �� 1���� Ȯ���ϴ°��ε� twint�� 1�̸� 0�� �ɶ����� ��ٸ���
    while((TWSR&0xF8)!=0x08); //��ȣ ���   // twsr�� 0x08�̸� start �ڵ� ���� �Ϸ�

    TWDR=SLA + w_mode; // AD+W����
    TWCR=0x84; // ����

    while((TWCR&0x80)==0x00); //���۴��
    while((TWSR&0xF8)!=0x18); //ACK���


    TWDR=add; // RA
    TWCR=0x84; // ����

    while((TWCR&0x80)==0x00);
    while((TWSR&0xF8)!=0x28); // ACK

    TWDR=dat; // DATA
    TWCR=0x84; // ����


    while((TWCR&0x80)==0x00);
    while((TWSR&0xF8)!=0x28); // ACK

    TWCR|=0x94; // P
    delay_us(50);  // 50us
}



unsigned char read(char addr) //���̷� ���� �� �о����
{
    unsigned char data; // data���� ����

    TWCR=0xA4; // S

    while((TWCR&0x80)==0x00); //��Ŵ��
    while((TWSR&0xF8)!=0x08); //��ȣ���


    TWDR=SLA + w_mode; // AD+W
    TWCR=0x84; // ����

    while((TWCR&0x80)==0x00); //��Ŵ��
    while((TWSR&0xF8)!=0x18); //ACK
    TWDR=addr; // RA
    TWCR=0x84; //����



    while((TWCR&0x80)==0x00); //��Ŵ��
    while((TWSR&0xF8)!=0x28); //ACK
    TWCR=0xA4; // RS

    while((TWCR&0x80)==0x00); //��Ŵ��
    while((TWSR&0xF8)!=0x10); //ACK
    TWDR=SLA + r_mode; // AD+R
    TWCR=0x84; //����


    while((TWCR&0x80)==0x00); //��Ŵ��
    while((TWSR&0xF8)!=0x40); // ACK
    TWCR=0x84;//����

    while((TWCR&0x80)==0x00); //��Ŵ��
    while((TWSR&0xF8)!=0x58); //ACK
    data=TWDR;

    TWCR=0x94; // P
    delay_us(50);  // 50us
    return data;

}






#endif