# 4방향 자이로 시계

이 작품은 시계를 4가지 각도에 따라 다른 기능을 수행하는 시계이다.</br>
기능은 시간, 알람, 타이머, 현재 온도를 지원한다.</br>
(데모영상 참조)

### 구현 방법
1. 크리스탈 클럭에 의한 시간측정을 하고 타이머0의 오버플로우 인터럽트를 활용하여  1초마다 시간을 측정한다.
2. I2C 통신을 사용하여 센서의 값을 접근한다.
3. 3축 자이로센서를 사용하여 각도를 0 ~ 359 도 사이로 계산을 한다.
4. 각도에 따른 모드 변경을 인터럽트로 구현한다.
5. 모드에 따른 정보를 LCD로 표현한다.

### 구성

Atmega 128, 3축지자계센서(HMC5883L), 3축 자이로센서(MPU6050), 고도/압력/기압/온습도센서(BMP180), LCD, 푸쉬버튼, 피에조스피커</br>

![circuit_diagram](https://github.com/chuuuul/4way-gyro-clock/blob/master/gitData/circuit_diagram.jpg)
![hw](https://github.com/chuuuul/4way-gyro-clock/blob/master/gitData/product.png)

### 컴파일러
Codevision AVR

### 환경 / 라이브러리 / 지식
C, 마이크로프로세서, Atmega128, 레지스터, I2C통신, UART통신, 지자계센서, 온습도센서, 자이로센서, LCD, 타이머 인터럽트, 외부인터럽트, 상보필터, 칼만필터, 바이패스를 이용한 센서제어




