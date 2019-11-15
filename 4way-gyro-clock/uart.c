

#ifndef _uart_
#define _uart_


void uart0_init(void)
{
  UCSR0A = 0x00;  // flag  clr, 멀티프로세싱 모드
  UCSR0B = 0x98; //rx,tx en, rx int on
  UCSR0C = 0x06; //n-p,1-stop
  UBRR0H = 0x00;
  UBRR0L = 103; //8mhz, 9600, 103 - 16mhz, 47 = 7.2738mhz
}


#endif
