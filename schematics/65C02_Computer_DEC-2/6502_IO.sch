EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 2
Title "65C02 Hobby Computer"
Date "2020-02-17"
Rev "v001"
Comp ""
Comment1 ""
Comment2 ""
Comment3 "Based on Ben Eater's design"
Comment4 "Author: Dawid Buchwald"
$EndDescr
Text GLabel 7950 2500 3    50   Input ~ 0
+5V
Text GLabel 6750 1000 1    50   Input ~ 0
GND
NoConn ~ 6850 1700
NoConn ~ 6850 2100
NoConn ~ 6850 1500
Text GLabel 8100 1000 1    50   Input ~ 0
CLK
Text Label 8400 2100 2    50   ~ 0
d0
Text Label 8400 2000 2    50   ~ 0
d1
Text Label 8400 1900 2    50   ~ 0
d2
Text Label 8400 1800 2    50   ~ 0
d3
Text Label 8400 1700 2    50   ~ 0
d4
Text Label 8400 1600 2    50   ~ 0
d5
Text Label 8400 1500 2    50   ~ 0
d6
Text Label 8400 1400 2    50   ~ 0
d7
Entry Wire Line
	8400 1400 8500 1300
Entry Wire Line
	8400 1500 8500 1400
Entry Wire Line
	8400 1600 8500 1500
Entry Wire Line
	8400 1700 8500 1600
Entry Wire Line
	8400 1800 8500 1700
Entry Wire Line
	8400 1900 8500 1800
Entry Wire Line
	8400 2000 8500 1900
Entry Wire Line
	8400 2100 8500 2000
Text GLabel 6450 1000 1    50   Input ~ 0
~ACIA_CS
Text GLabel 6300 1000 1    50   Input ~ 0
~RES
Text GLabel 6750 1600 0    50   Input ~ 0
RS232CLK
Text Label 6700 2300 0    50   ~ 0
a0
Text Label 6700 2400 0    50   ~ 0
a1
Entry Wire Line
	6600 2400 6700 2300
Entry Wire Line
	6600 2500 6700 2400
Text GLabel 6750 2000 0    50   Output ~ 0
TxD
Text GLabel 6750 2150 0    50   Input ~ 0
RxD
Text GLabel 8250 1000 1    50   Output ~ 0
~IRQ_OD
Text GLabel 8100 2500 3    50   Input ~ 0
GND
Text GLabel 6450 2350 3    50   BiDi ~ 0
~CTS
Text GLabel 6300 2350 3    50   BiDi ~ 0
~RTS
Text GLabel 950  5400 3    50   Input ~ 0
+5V
Text GLabel 3200 5400 3    50   Input ~ 0
+5V
Text GLabel 2150 3300 1    50   Input ~ 0
~RES
Text GLabel 4400 3300 1    50   Input ~ 0
~RES
Text GLabel 2300 3300 1    50   Input ~ 0
CLK
Text GLabel 4550 3300 1    50   Input ~ 0
CLK
Text GLabel 3200 3300 1    50   Input ~ 0
GND
Text Label 4850 3600 2    50   ~ 0
a0
Text Label 4850 3700 2    50   ~ 0
a1
Text Label 4850 3800 2    50   ~ 0
a2
Text Label 4850 3900 2    50   ~ 0
a3
Entry Wire Line
	4850 3600 4950 3500
Entry Wire Line
	4850 3700 4950 3600
Entry Wire Line
	4850 3800 4950 3700
Entry Wire Line
	4850 3900 4950 3800
Text Label 4850 4100 2    50   ~ 0
d0
Text Label 4850 4200 2    50   ~ 0
d1
Text Label 4850 4300 2    50   ~ 0
d2
Text Label 4850 4400 2    50   ~ 0
d3
Text Label 4850 4500 2    50   ~ 0
d4
Text Label 4850 4600 2    50   ~ 0
d5
Text Label 4850 4700 2    50   ~ 0
d6
Text Label 4850 4800 2    50   ~ 0
d7
Entry Wire Line
	4850 4100 4950 4000
Entry Wire Line
	4850 4200 4950 4100
Entry Wire Line
	4850 4300 4950 4200
Entry Wire Line
	4850 4400 4950 4300
Entry Wire Line
	4850 4500 4950 4400
Entry Wire Line
	4850 4600 4950 4500
Entry Wire Line
	4850 4700 4950 4600
Entry Wire Line
	4850 4800 4950 4700
Text GLabel 2300 5400 3    50   Input ~ 0
R~W
Text GLabel 4550 5400 3    50   Input ~ 0
R~W
Text GLabel 2450 5400 3    50   Input ~ 0
~VIA1_CS
Text GLabel 4700 5400 3    50   Input ~ 0
~VIA2_CS
Text GLabel 950  3300 1    50   Input ~ 0
GND
Text Label 750  3500 0    50   ~ 0
v1pa0
Text Label 750  3600 0    50   ~ 0
v1pa1
Text Label 750  3700 0    50   ~ 0
v1pa2
Text Label 750  3800 0    50   ~ 0
v1pa3
Text Label 750  3900 0    50   ~ 0
v1pa4
Text Label 750  4000 0    50   ~ 0
v1pa5
Text Label 750  4100 0    50   ~ 0
v1pa6
Text Label 750  4200 0    50   ~ 0
v1pa7
Text Label 750  4300 0    50   ~ 0
v1pb0
Text Label 750  4400 0    50   ~ 0
v1pb1
Text Label 750  4500 0    50   ~ 0
v1pb2
Text Label 750  4600 0    50   ~ 0
v1pb3
Text Label 750  4800 0    50   ~ 0
v1pb5
Text Label 750  4900 0    50   ~ 0
v1pb6
Text Label 750  5000 0    50   ~ 0
v1pb7
Text Label 3000 3500 0    50   ~ 0
v2pa0
Text Label 3000 3600 0    50   ~ 0
v2pa1
Text Label 3000 3700 0    50   ~ 0
v2pa2
Text Label 3000 3800 0    50   ~ 0
v2pa3
Text Label 3000 3900 0    50   ~ 0
v2pa4
Text Label 3000 4000 0    50   ~ 0
v2pa5
Text Label 3000 4100 0    50   ~ 0
v2pa6
Text Label 3000 4200 0    50   ~ 0
v2pa7
Text Label 3000 4300 0    50   ~ 0
v2pb0
Text Label 3000 4400 0    50   ~ 0
v2pb1
Text Label 3000 4500 0    50   ~ 0
v2pb2
Text Label 3000 4600 0    50   ~ 0
v2pb3
Text Label 3000 4700 0    50   ~ 0
v2pb4
Text Label 3000 4800 0    50   ~ 0
v2pb5
Text Label 3000 4900 0    50   ~ 0
v2pb6
Text Label 3000 5000 0    50   ~ 0
v2pb7
Entry Wire Line
	650  3400 750  3500
Entry Wire Line
	650  3500 750  3600
Entry Wire Line
	650  3600 750  3700
Entry Wire Line
	650  3700 750  3800
Entry Wire Line
	650  3800 750  3900
Entry Wire Line
	650  3900 750  4000
Entry Wire Line
	650  4000 750  4100
Entry Wire Line
	650  4100 750  4200
Entry Wire Line
	650  4400 750  4300
Entry Wire Line
	650  4500 750  4400
Entry Wire Line
	650  4600 750  4500
Entry Wire Line
	650  4700 750  4600
Entry Wire Line
	650  4900 750  4800
Entry Wire Line
	650  5000 750  4900
Entry Wire Line
	650  5100 750  5000
Entry Wire Line
	2900 3400 3000 3500
Entry Wire Line
	2900 3500 3000 3600
Entry Wire Line
	2900 3600 3000 3700
Entry Wire Line
	2900 3700 3000 3800
Entry Wire Line
	2900 3800 3000 3900
Entry Wire Line
	2900 3900 3000 4000
Entry Wire Line
	2900 4000 3000 4100
Entry Wire Line
	2900 4100 3000 4200
Entry Wire Line
	2900 4400 3000 4300
Entry Wire Line
	2900 4500 3000 4400
Entry Wire Line
	2900 4600 3000 4500
Entry Wire Line
	2900 4700 3000 4600
Entry Wire Line
	2900 4800 3000 4700
Entry Wire Line
	2900 4900 3000 4800
Entry Wire Line
	2900 5000 3000 4900
Entry Wire Line
	2900 5100 3000 5000
Text GLabel 2150 5400 3    50   Output ~ 0
~V1IRQ
Text GLabel 4400 5400 3    50   Output ~ 0
~V2IRQ
Text GLabel 9400 900  1    50   Input ~ 0
+5V
Text GLabel 9400 1700 3    50   Input ~ 0
GND
Text GLabel 9800 1300 2    50   Output ~ 0
RS232CLK
$Comp
L Connector:Mini-DIN-6 J8
U 1 1 5F701D58
P 9400 2500
F 0 "J8" H 9400 2867 50  0000 C CNN
F 1 "Mini-DIN-6" H 9400 2776 50  0000 C CNN
F 2 "65C02_Computer:mini_din-6" H 9400 2500 50  0001 C CNN
F 3 "http://service.powerdynamics.com/ec/Catalog17/Section%2011.pdf" H 9400 2500 50  0001 C CNN
	1    9400 2500
	1    0    0    -1  
$EndComp
$Comp
L 6502:65C22S U?
U 1 1 5F285E91
P 1550 4300
AR Path="/5F285E91" Ref="U?"  Part="1" 
AR Path="/5F14295C/5F285E91" Ref="U8"  Part="1" 
F 0 "U8" H 1550 5450 50  0000 C CNN
F 1 "65C22S" H 1550 5350 50  0000 C CNN
F 2 "Package_DIP:DIP-40_W15.24mm_Socket" H 1650 4300 50  0001 C CNN
F 3 "https://www.westerndesigncenter.com/wdc/documentation/w65c22.pdf" H 1650 4300 50  0001 C CNN
	1    1550 4300
	1    0    0    -1  
$EndComp
$Comp
L 6502:65C22S U?
U 1 1 5F285E8B
P 3800 4300
AR Path="/5F285E8B" Ref="U?"  Part="1" 
AR Path="/5F14295C/5F285E8B" Ref="U9"  Part="1" 
F 0 "U9" H 3800 5450 50  0000 C CNN
F 1 "65C22S" H 3800 5350 50  0000 C CNN
F 2 "Package_DIP:DIP-40_W15.24mm_Socket" H 3900 4300 50  0001 C CNN
F 3 "https://www.westerndesigncenter.com/wdc/documentation/w65c22.pdf" H 3900 4300 50  0001 C CNN
	1    3800 4300
	1    0    0    -1  
$EndComp
$Comp
L 6502:65C51N U?
U 1 1 5F1AD73D
P 7350 1750
AR Path="/5F1AD73D" Ref="U?"  Part="1" 
AR Path="/5F14295C/5F1AD73D" Ref="U12"  Part="1" 
F 0 "U12" H 7350 2650 50  0000 C CNN
F 1 "65C51N" H 7350 2550 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm_Socket" H 7350 1750 50  0001 C CNN
F 3 "https://www.westerndesigncenter.com/wdc/documentation/w65c51n.pdf" H 7350 1750 50  0001 C CNN
	1    7350 1750
	1    0    0    -1  
$EndComp
NoConn ~ 1050 5100
NoConn ~ 1050 5200
Text Label 2600 3600 2    50   ~ 0
a0
Text Label 2600 3700 2    50   ~ 0
a1
Text Label 2600 3800 2    50   ~ 0
a2
Text Label 2600 3900 2    50   ~ 0
a3
Entry Wire Line
	2600 3600 2700 3500
Entry Wire Line
	2600 3700 2700 3600
Entry Wire Line
	2600 3800 2700 3700
Entry Wire Line
	2600 3900 2700 3800
Text Label 2600 4100 2    50   ~ 0
d0
Text Label 2600 4200 2    50   ~ 0
d1
Text Label 2600 4300 2    50   ~ 0
d2
Text Label 2600 4400 2    50   ~ 0
d3
Text Label 2600 4500 2    50   ~ 0
d4
Text Label 2600 4600 2    50   ~ 0
d5
Text Label 2600 4700 2    50   ~ 0
d6
Text Label 2600 4800 2    50   ~ 0
d7
Entry Wire Line
	2600 4100 2700 4000
Entry Wire Line
	2600 4200 2700 4100
Entry Wire Line
	2600 4300 2700 4200
Entry Wire Line
	2600 4400 2700 4300
Entry Wire Line
	2600 4500 2700 4400
Entry Wire Line
	2600 4600 2700 4500
Entry Wire Line
	2600 4700 2700 4600
Entry Wire Line
	2600 4800 2700 4700
Text Label 2600 3400 2    50   ~ 0
v1pa8
Entry Wire Line
	2600 3400 2700 3300
Text Label 4850 3500 2    50   ~ 0
v2pa9
Text Label 4850 3400 2    50   ~ 0
v2pa8
Entry Wire Line
	4850 3500 4950 3400
Entry Wire Line
	4850 3400 4950 3300
Text Label 3000 5100 0    50   ~ 0
v2pb8
Text Label 3000 5200 0    50   ~ 0
v2pb9
Entry Wire Line
	2900 5200 3000 5100
Entry Wire Line
	2900 5300 3000 5200
$Comp
L Connector:Conn_01x16_Female J5
U 1 1 5FB15958
P 6000 4150
F 0 "J5" V 6050 4100 50  0000 L CNN
F 1 "LCD Connector" V 6050 3350 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x16_P2.54mm_Vertical" H 6000 4150 50  0001 C CNN
F 3 "~" H 6000 4150 50  0001 C CNN
	1    6000 4150
	1    0    0    -1  
$EndComp
Text GLabel 5400 3550 0    50   Input ~ 0
+5V
Text GLabel 5400 3450 0    50   Input ~ 0
GND
Text Label 5400 3750 0    50   ~ 0
v1pb5
Text Label 5400 3850 0    50   ~ 0
v1pb6
Text Label 5400 3950 0    50   ~ 0
v1pb7
Text Label 5400 4450 0    50   ~ 0
v1pb0
Text Label 5400 4550 0    50   ~ 0
v1pb1
Text Label 5400 4650 0    50   ~ 0
v1pb2
Text Label 5400 4750 0    50   ~ 0
v1pb3
Text GLabel 5400 4950 0    50   Input ~ 0
GND
Text GLabel 5400 4850 0    50   Input ~ 0
+5V
Text GLabel 5600 4200 0    50   Input ~ 0
GND
Entry Wire Line
	5300 4350 5400 4450
Entry Wire Line
	5300 4450 5400 4550
Entry Wire Line
	5300 4550 5400 4650
Entry Wire Line
	5300 4650 5400 4750
Entry Wire Line
	5300 3850 5400 3750
Entry Wire Line
	5300 3950 5400 3850
Entry Wire Line
	5300 4050 5400 3950
$Comp
L Device:R_POT RV1
U 1 1 5FD119EF
P 5600 3250
F 0 "RV1" V 5500 3250 50  0000 C CNN
F 1 "10K" V 5600 3250 50  0000 C CNN
F 2 "Potentiometer_THT:Potentiometer_Bourns_3386C_Horizontal" H 5600 3250 50  0001 C CNN
F 3 "~" H 5600 3250 50  0001 C CNN
	1    5600 3250
	0    1    1    0   
$EndComp
Text Label 6500 3000 0    50   ~ 0
v2pa0
Text Label 6500 3100 0    50   ~ 0
v2pa1
Text Label 6500 3200 0    50   ~ 0
v2pa2
Text Label 6500 3300 0    50   ~ 0
v2pa3
Text Label 6500 3400 0    50   ~ 0
v2pa4
Text Label 6500 3500 0    50   ~ 0
v2pa5
Text Label 6500 3600 0    50   ~ 0
v2pa6
Text Label 6500 3700 0    50   ~ 0
v2pa7
Text Label 6500 3800 0    50   ~ 0
v2pa8
Text Label 6500 3900 0    50   ~ 0
v2pa9
$Comp
L Connector:Conn_01x12_Male J6
U 1 1 5FD88768
P 7000 3500
F 0 "J6" H 7050 4150 50  0000 L CNN
F 1 "VIA2PA" V 6950 3250 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x12_P2.54mm_Vertical" H 7000 3500 50  0001 C CNN
F 3 "~" H 7000 3500 50  0001 C CNN
	1    7000 3500
	-1   0    0    -1  
$EndComp
Text GLabel 6500 4100 0    50   Input ~ 0
+5V
Text GLabel 6500 4000 0    50   Input ~ 0
GND
Entry Wire Line
	6400 2900 6500 3000
Entry Wire Line
	6400 2900 6500 3000
Entry Wire Line
	6400 3000 6500 3100
Entry Wire Line
	6400 3100 6500 3200
Entry Wire Line
	6400 3200 6500 3300
Entry Wire Line
	6400 3300 6500 3400
Entry Wire Line
	6400 3400 6500 3500
Entry Wire Line
	6400 3500 6500 3600
Entry Wire Line
	6400 3600 6500 3700
Entry Wire Line
	6400 3700 6500 3800
Entry Wire Line
	6400 3800 6500 3900
$Comp
L Connector:Conn_01x12_Male J7
U 1 1 5FEAF969
P 7000 4900
F 0 "J7" H 7050 5550 50  0000 L CNN
F 1 "VIA2PB" V 6950 4650 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x12_P2.54mm_Vertical" H 7000 4900 50  0001 C CNN
F 3 "~" H 7000 4900 50  0001 C CNN
	1    7000 4900
	-1   0    0    -1  
$EndComp
Text GLabel 6500 5400 0    50   Input ~ 0
GND
Text GLabel 6500 5500 0    50   Input ~ 0
+5V
Text Label 6500 4400 0    50   ~ 0
v2pb0
Text Label 6500 4500 0    50   ~ 0
v2pb1
Text Label 6500 4600 0    50   ~ 0
v2pb2
Text Label 6500 4700 0    50   ~ 0
v2pb3
Text Label 6500 4800 0    50   ~ 0
v2pb4
Text Label 6500 4900 0    50   ~ 0
v2pb5
Text Label 6500 5000 0    50   ~ 0
v2pb6
Text Label 6500 5100 0    50   ~ 0
v2pb7
Text Label 6500 5200 0    50   ~ 0
v2pb8
Text Label 6500 5300 0    50   ~ 0
v2pb9
Entry Wire Line
	6400 4300 6500 4400
Entry Wire Line
	6400 4400 6500 4500
Entry Wire Line
	6400 4500 6500 4600
Entry Wire Line
	6400 4600 6500 4700
Entry Wire Line
	6400 4700 6500 4800
Entry Wire Line
	6400 4800 6500 4900
Entry Wire Line
	6400 4900 6500 5000
Entry Wire Line
	6400 5000 6500 5100
Entry Wire Line
	6400 5100 6500 5200
Entry Wire Line
	6400 5200 6500 5300
Text GLabel 9800 2400 2    50   Output ~ 0
KBCLK
Text GLabel 9800 2600 2    50   Output ~ 0
KBDAT
Text GLabel 9800 2500 2    50   Input ~ 0
GND
Text GLabel 9000 2500 0    50   Input ~ 0
+5V
NoConn ~ 9100 2400
NoConn ~ 9100 2600
Text GLabel 800  7600 2    50   Input ~ 0
a[0..15]
Text Label 800  5950 0    50   ~ 0
a0
Text Label 800  6050 0    50   ~ 0
a1
Text Label 800  6150 0    50   ~ 0
a2
Text Label 800  6250 0    50   ~ 0
a3
Text Label 800  6350 0    50   ~ 0
a4
Text Label 800  6450 0    50   ~ 0
a5
Text Label 800  6550 0    50   ~ 0
a6
Text Label 800  6650 0    50   ~ 0
a7
Text Label 800  6750 0    50   ~ 0
a8
Text Label 800  6850 0    50   ~ 0
a9
Text Label 800  6950 0    50   ~ 0
a10
Text Label 800  7050 0    50   ~ 0
a11
Entry Wire Line
	700  6050 800  5950
Entry Wire Line
	700  6150 800  6050
Entry Wire Line
	700  6250 800  6150
Entry Wire Line
	700  6350 800  6250
Entry Wire Line
	700  6450 800  6350
Entry Wire Line
	700  6550 800  6450
Entry Wire Line
	700  6650 800  6550
Entry Wire Line
	700  6750 800  6650
Entry Wire Line
	700  6850 800  6750
Entry Wire Line
	700  6950 800  6850
Entry Wire Line
	700  7050 800  6950
Entry Wire Line
	700  7150 800  7050
Text Label 800  7150 0    50   ~ 0
a12
Text Label 800  7250 0    50   ~ 0
a13
Text Label 800  7350 0    50   ~ 0
a14
Text Label 800  7450 0    50   ~ 0
a15
Entry Wire Line
	700  7250 800  7150
Entry Wire Line
	700  7350 800  7250
Entry Wire Line
	700  7450 800  7350
Entry Wire Line
	700  7550 800  7450
Text Label 1350 7450 0    50   ~ 0
d7
Text Label 1350 7350 0    50   ~ 0
d6
Text Label 1350 7250 0    50   ~ 0
d5
Text Label 1350 7150 0    50   ~ 0
d4
Text Label 1350 7050 0    50   ~ 0
d3
Text Label 1350 6950 0    50   ~ 0
d2
Text Label 1350 6850 0    50   ~ 0
d1
Text Label 1350 6750 0    50   ~ 0
d0
Entry Wire Line
	1350 6750 1250 6850
Entry Wire Line
	1350 6850 1250 6950
Entry Wire Line
	1350 6950 1250 7050
Entry Wire Line
	1350 7050 1250 7150
Entry Wire Line
	1350 7150 1250 7250
Entry Wire Line
	1350 7250 1250 7350
Entry Wire Line
	1350 7350 1250 7450
Entry Wire Line
	1350 7450 1250 7550
Text GLabel 1350 7600 2    50   Input ~ 0
d[0..7]
$Comp
L Connector:Conn_01x06_Female J3
U 1 1 5E4D0B3D
P 2050 6100
F 0 "J3" H 2078 6076 50  0000 L CNN
F 1 "Optional UART Port" H 2078 5985 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x06_P2.54mm_Vertical" H 2050 6100 50  0001 C CNN
F 3 "~" H 2050 6100 50  0001 C CNN
	1    2050 6100
	1    0    0    -1  
$EndComp
Text GLabel 1750 6000 0    50   Output ~ 0
RxD
Text GLabel 1750 5900 0    50   Input ~ 0
TxD
Text GLabel 1550 6100 0    50   BiDi ~ 0
~RTS
Text GLabel 1750 6200 0    50   BiDi ~ 0
~CTS
Text GLabel 1750 6400 0    50   Input ~ 0
+5V
Text GLabel 1550 6300 0    50   Input ~ 0
GND
$Comp
L 65C02_Computer-rescue:Barrel_Jack-Connector J4
U 1 1 5E59BEED
P 2050 7100
F 0 "J4" H 2107 7425 50  0000 C CNN
F 1 "Power Connector" H 2107 7334 50  0000 C CNN
F 2 "Connector_BarrelJack:BarrelJack_Horizontal" H 2100 7060 50  0001 C CNN
F 3 "~" H 2100 7060 50  0001 C CNN
	1    2050 7100
	1    0    0    -1  
$EndComp
Text GLabel 2450 7000 2    50   Input ~ 0
+5V
Text GLabel 2450 7200 2    50   Input ~ 0
GND
NoConn ~ 5450 3250
$Comp
L 74xx:74HC14 U1
U 6 1 6117F788
P 1550 1550
F 0 "U1" H 1550 1867 50  0000 C CNN
F 1 "74HC14" H 1550 1776 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 1550 1550 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 1550 1550 50  0001 C CNN
	6    1550 1550
	1    0    0    -1  
$EndComp
Text GLabel 1000 1550 0    50   Input ~ 0
KBCLK
$Comp
L 74xx:74HC14 U1
U 5 1 612F8A73
P 2450 1200
F 0 "U1" H 2450 1517 50  0000 C CNN
F 1 "74HC14" H 2450 1426 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2450 1200 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 2450 1200 50  0001 C CNN
	5    2450 1200
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC14 U1
U 4 1 612FA70E
P 2450 2000
F 0 "U1" H 2450 2317 50  0000 C CNN
F 1 "74HC14" H 2450 2226 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2450 2000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 2450 2000 50  0001 C CNN
	4    2450 2000
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 613FD53D
P 2000 1200
AR Path="/613FD53D" Ref="R?"  Part="1" 
AR Path="/5F14295C/613FD53D" Ref="R9"  Part="1" 
F 0 "R9" V 1900 1200 50  0000 C CNN
F 1 "10K" V 2000 1200 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 1930 1200 50  0001 C CNN
F 3 "~" H 2000 1200 50  0001 C CNN
	1    2000 1200
	0    1    1    0   
$EndComp
$Comp
L Device:R R?
U 1 1 6140F962
P 3150 1000
AR Path="/6140F962" Ref="R?"  Part="1" 
AR Path="/5F14295C/6140F962" Ref="R10"  Part="1" 
F 0 "R10" V 3050 1000 50  0000 C CNN
F 1 "10K" V 3150 1000 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 3080 1000 50  0001 C CNN
F 3 "~" H 3150 1000 50  0001 C CNN
	1    3150 1000
	0    1    1    0   
$EndComp
$Comp
L Device:R R?
U 1 1 613EB533
P 1100 1250
AR Path="/613EB533" Ref="R?"  Part="1" 
AR Path="/5F14295C/613EB533" Ref="R8"  Part="1" 
F 0 "R8" V 1000 1250 50  0000 C CNN
F 1 "10K" V 1100 1250 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 1030 1250 50  0001 C CNN
F 3 "~" H 1100 1250 50  0001 C CNN
	1    1100 1250
	-1   0    0    1   
$EndComp
Text GLabel 1100 950  1    50   Input ~ 0
+5V
$Comp
L Diode:1N4148 D1
U 1 1 6173C079
P 2000 1550
F 0 "D1" H 2000 1767 50  0000 C CNN
F 1 "1N4148" H 2000 1676 50  0000 C CNN
F 2 "Diode_THT:D_DO-35_SOD27_P7.62mm_Horizontal" H 2000 1375 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/1N4148_1N4448.pdf" H 2000 1550 50  0001 C CNN
	1    2000 1550
	-1   0    0    -1  
$EndComp
Wire Wire Line
	7850 2400 7950 2400
Wire Wire Line
	7950 2400 7950 2500
Wire Wire Line
	6750 1000 6750 1100
Wire Wire Line
	6750 1100 6850 1100
Wire Wire Line
	7950 1000 7950 1100
Wire Wire Line
	7950 1100 7850 1100
Wire Wire Line
	8100 1000 8100 1200
Wire Wire Line
	8100 1200 7850 1200
Wire Wire Line
	7850 1400 8400 1400
Wire Wire Line
	7850 1500 8400 1500
Wire Wire Line
	7850 1600 8400 1600
Wire Wire Line
	7850 1700 8400 1700
Wire Wire Line
	7850 1800 8400 1800
Wire Wire Line
	7850 1900 8400 1900
Wire Wire Line
	7850 2000 8400 2000
Wire Wire Line
	7850 2100 8400 2100
Wire Wire Line
	6450 1000 6450 1300
Wire Wire Line
	6450 1300 6850 1300
Wire Wire Line
	6300 1000 6300 1400
Wire Wire Line
	6300 1400 6850 1400
Wire Wire Line
	6750 1600 6850 1600
Wire Wire Line
	6700 2400 6850 2400
Wire Wire Line
	6700 2300 6850 2300
Wire Bus Line
	6600 2400 6600 2500
Wire Wire Line
	6850 2000 6750 2000
Wire Wire Line
	6750 2150 6800 2150
Wire Wire Line
	6800 2150 6800 2200
Wire Wire Line
	6800 2200 6850 2200
Wire Wire Line
	7850 1300 8250 1300
Wire Wire Line
	8250 1300 8250 1000
Wire Wire Line
	7850 2300 8100 2300
Wire Wire Line
	8100 2300 8100 2500
Wire Wire Line
	7850 2200 8100 2200
Wire Wire Line
	8100 2200 8100 2300
Connection ~ 8100 2300
Wire Wire Line
	6450 2350 6450 1900
Wire Wire Line
	6450 1900 6850 1900
Wire Wire Line
	6300 2350 6300 1800
Wire Wire Line
	6300 1800 6850 1800
Wire Wire Line
	3200 5300 3300 5300
Wire Wire Line
	2050 4000 2150 4000
Wire Wire Line
	4300 4000 4400 4000
Wire Wire Line
	4300 3600 4850 3600
Wire Wire Line
	4300 3700 4850 3700
Wire Wire Line
	4300 3800 4850 3800
Wire Wire Line
	4300 3900 4850 3900
Wire Wire Line
	4300 4800 4850 4800
Wire Wire Line
	4300 4700 4850 4700
Wire Wire Line
	4300 4600 4850 4600
Wire Wire Line
	4300 4500 4850 4500
Wire Wire Line
	4300 4400 4850 4400
Wire Wire Line
	4300 4300 4850 4300
Wire Wire Line
	4300 4200 4850 4200
Wire Wire Line
	4300 4100 4850 4100
Wire Wire Line
	950  5300 1050 5300
Wire Wire Line
	3000 3500 3300 3500
Wire Wire Line
	3000 3600 3300 3600
Wire Wire Line
	3000 3700 3300 3700
Wire Wire Line
	3000 3800 3300 3800
Wire Wire Line
	3000 3900 3300 3900
Wire Wire Line
	3000 4000 3300 4000
Wire Wire Line
	3000 4100 3300 4100
Wire Wire Line
	3000 4200 3300 4200
Wire Wire Line
	3000 4300 3300 4300
Wire Wire Line
	3000 4400 3300 4400
Wire Wire Line
	3000 4500 3300 4500
Wire Wire Line
	3000 4600 3300 4600
Wire Wire Line
	3000 4700 3300 4700
Wire Wire Line
	3000 4800 3300 4800
Wire Wire Line
	3000 4900 3300 4900
Wire Wire Line
	3000 5000 3300 5000
Wire Wire Line
	750  3500 1050 3500
Wire Wire Line
	750  3600 1050 3600
Wire Wire Line
	750  3700 1050 3700
Wire Wire Line
	750  3800 1050 3800
Wire Wire Line
	750  3900 1050 3900
Wire Wire Line
	750  4000 1050 4000
Wire Wire Line
	750  4100 1050 4100
Wire Wire Line
	750  4200 1050 4200
Wire Wire Line
	750  4300 1050 4300
Wire Wire Line
	750  4400 1050 4400
Wire Wire Line
	750  4500 1050 4500
Wire Wire Line
	750  4600 1050 4600
Wire Wire Line
	750  4800 1050 4800
Wire Wire Line
	750  4900 1050 4900
Wire Wire Line
	750  5000 1050 5000
Wire Wire Line
	950  3300 950  3400
Wire Wire Line
	950  3400 1050 3400
Wire Wire Line
	3200 3300 3200 3400
Wire Wire Line
	3200 3400 3300 3400
Wire Wire Line
	2050 5300 2150 5300
Wire Wire Line
	2150 5300 2150 5400
Wire Wire Line
	2050 5200 2300 5200
Wire Wire Line
	2300 5200 2300 5400
Wire Wire Line
	2050 5100 2450 5100
Wire Wire Line
	2450 5100 2450 5400
Wire Wire Line
	4300 5300 4400 5300
Wire Wire Line
	4400 5300 4400 5400
Wire Wire Line
	4300 5200 4550 5200
Wire Wire Line
	4550 5200 4550 5400
Wire Wire Line
	4300 5100 4700 5100
Wire Wire Line
	4700 5100 4700 5400
Wire Wire Line
	4400 3300 4400 4000
Wire Wire Line
	4550 4900 4550 3300
Wire Wire Line
	4300 4900 4550 4900
Wire Wire Line
	2150 3300 2150 4000
Wire Wire Line
	2050 4900 2300 4900
Wire Wire Line
	950  5300 950  5400
Wire Wire Line
	3200 5400 3200 5300
Wire Wire Line
	9400 1700 9400 1600
Wire Wire Line
	9400 900  9400 1000
Wire Wire Line
	9700 1300 9800 1300
Wire Wire Line
	2300 4900 2300 3300
Wire Wire Line
	2050 3900 2600 3900
Wire Wire Line
	2050 3800 2600 3800
Wire Wire Line
	2050 3700 2600 3700
Wire Wire Line
	2050 3600 2600 3600
Wire Wire Line
	2050 4100 2600 4100
Wire Wire Line
	2050 4200 2600 4200
Wire Wire Line
	2050 4300 2600 4300
Wire Wire Line
	2050 4400 2600 4400
Wire Wire Line
	2050 4500 2600 4500
Wire Wire Line
	2050 4600 2600 4600
Wire Wire Line
	2050 4700 2600 4700
Wire Wire Line
	2050 4800 2600 4800
Wire Wire Line
	4300 3400 4850 3400
Wire Wire Line
	4300 3500 4850 3500
Wire Wire Line
	3000 5100 3300 5100
Wire Wire Line
	3000 5200 3300 5200
Wire Bus Line
	2900 3000 4950 3000
Wire Bus Line
	650  3000 2700 3000
Wire Wire Line
	5800 4350 5700 4350
Wire Wire Line
	5700 4350 5700 4250
Wire Wire Line
	5700 4050 5800 4050
Wire Wire Line
	5800 4150 5700 4150
Connection ~ 5700 4150
Wire Wire Line
	5700 4150 5700 4050
Wire Wire Line
	5800 4250 5700 4250
Connection ~ 5700 4250
Wire Wire Line
	5700 4250 5700 4200
Wire Wire Line
	5600 4200 5700 4200
Connection ~ 5700 4200
Wire Wire Line
	5700 4200 5700 4150
Wire Wire Line
	5800 3750 5400 3750
Wire Wire Line
	5800 3850 5400 3850
Wire Wire Line
	5800 3950 5400 3950
Wire Wire Line
	5400 4450 5800 4450
Wire Wire Line
	5400 4550 5800 4550
Wire Wire Line
	5400 4650 5800 4650
Wire Wire Line
	5400 4750 5800 4750
Wire Wire Line
	5400 4850 5800 4850
Wire Wire Line
	5400 4950 5800 4950
Wire Wire Line
	5750 3250 5750 3450
Wire Wire Line
	5600 3400 5600 3650
Wire Wire Line
	5600 3650 5800 3650
Wire Wire Line
	6500 3900 6800 3900
Wire Wire Line
	6500 3800 6800 3800
Wire Wire Line
	6500 3700 6800 3700
Wire Wire Line
	6500 3600 6800 3600
Wire Wire Line
	6500 3500 6800 3500
Wire Wire Line
	6500 3400 6800 3400
Wire Wire Line
	6500 3300 6800 3300
Wire Wire Line
	6500 3200 6800 3200
Wire Wire Line
	6500 3100 6800 3100
Wire Wire Line
	6500 3000 6800 3000
Wire Wire Line
	6500 4000 6800 4000
Wire Wire Line
	6500 4100 6800 4100
Wire Wire Line
	6500 5500 6800 5500
Wire Wire Line
	6500 5400 6800 5400
Wire Wire Line
	6500 4400 6800 4400
Wire Wire Line
	6500 4500 6800 4500
Wire Wire Line
	6500 4600 6800 4600
Wire Wire Line
	6500 4700 6800 4700
Wire Wire Line
	6500 4800 6800 4800
Wire Wire Line
	6500 4900 6800 4900
Wire Wire Line
	6500 5000 6800 5000
Wire Wire Line
	6500 5100 6800 5100
Wire Wire Line
	6500 5200 6800 5200
Wire Wire Line
	6500 5300 6800 5300
Wire Wire Line
	9000 2500 9100 2500
Wire Wire Line
	9700 2500 9800 2500
Wire Wire Line
	9700 2400 9800 2400
Wire Wire Line
	9700 2600 9800 2600
Wire Bus Line
	700  7600 800  7600
Wire Bus Line
	1250 7600 1350 7600
Wire Wire Line
	1750 5900 1850 5900
Wire Wire Line
	1750 6000 1850 6000
Wire Wire Line
	1550 6100 1850 6100
Wire Wire Line
	1750 6200 1850 6200
Wire Wire Line
	1550 6300 1850 6300
Wire Wire Line
	1750 6400 1850 6400
Wire Wire Line
	2450 7200 2350 7200
Wire Wire Line
	2450 7000 2350 7000
Wire Wire Line
	5400 3550 5800 3550
Connection ~ 5750 3450
Wire Wire Line
	5750 3450 5800 3450
Wire Wire Line
	5400 3450 5750 3450
Wire Wire Line
	1000 1550 1100 1550
Wire Wire Line
	1100 1400 1100 1550
Connection ~ 1100 1550
Wire Wire Line
	1100 1550 1250 1550
Wire Wire Line
	1100 1100 1100 950 
Wire Wire Line
	1850 1200 1850 1550
Connection ~ 1850 1550
Wire Wire Line
	2150 1550 2150 1200
Connection ~ 2150 1200
Wire Wire Line
	1100 1550 1100 2000
Wire Wire Line
	1100 2000 2150 2000
$Comp
L 74xx:74HC595 U10
U 1 1 618C8340
P 3850 1750
F 0 "U10" H 3850 2531 50  0000 C CNN
F 1 "74HC595" H 3850 2440 50  0000 C CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 3850 1750 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/sn74hc595.pdf" H 3850 1750 50  0001 C CNN
	1    3850 1750
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC595 U11
U 1 1 618C9505
P 5500 1750
F 0 "U11" H 5500 2531 50  0000 C CNN
F 1 "74HC595" H 5500 2440 50  0000 C CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 5500 1750 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/sn74hc595.pdf" H 5500 1750 50  0001 C CNN
	1    5500 1750
	1    0    0    -1  
$EndComp
Text GLabel 3850 2450 3    50   Input ~ 0
GND
Text GLabel 5500 2450 3    50   Input ~ 0
GND
Text GLabel 3850 850  1    50   Input ~ 0
+5V
Text GLabel 5500 850  1    50   Input ~ 0
+5V
Wire Wire Line
	3850 850  3850 1150
Wire Wire Line
	5500 850  5500 1150
Wire Wire Line
	5100 1650 5050 1650
Wire Wire Line
	5050 1650 5050 1150
Wire Wire Line
	5050 1150 5500 1150
Connection ~ 5500 1150
Wire Wire Line
	3450 1650 3300 1650
Wire Wire Line
	3300 1650 3300 1150
Wire Wire Line
	3300 1150 3850 1150
Connection ~ 3850 1150
Wire Wire Line
	3450 1950 3300 1950
Wire Wire Line
	3300 1950 3300 2450
Wire Wire Line
	3300 2450 3850 2450
Wire Wire Line
	5100 1950 5100 2450
Wire Wire Line
	5100 2450 5500 2450
Text GLabel 3400 850  1    50   Input ~ 0
KBDAT
Wire Wire Line
	3400 850  3400 1000
Wire Wire Line
	3400 1350 3450 1350
Wire Wire Line
	2050 3400 2600 3400
Wire Wire Line
	2750 1200 3150 1200
Wire Wire Line
	3150 1200 3150 1850
Wire Wire Line
	3150 1850 3450 1850
Wire Wire Line
	3150 1850 3150 2450
Wire Wire Line
	3150 2750 4900 2750
Connection ~ 3150 1850
Wire Wire Line
	2750 2000 2750 1550
Wire Wire Line
	2750 1550 3450 1550
Wire Wire Line
	4900 1550 5100 1550
Connection ~ 2750 2000
Text GLabel 2900 850  1    50   Input ~ 0
+5V
Wire Wire Line
	2900 850  2900 1000
Wire Wire Line
	2900 1000 3000 1000
Wire Wire Line
	3300 1000 3400 1000
Connection ~ 3400 1000
Wire Wire Line
	3400 1000 3400 1350
Wire Wire Line
	4800 1350 5100 1350
Wire Wire Line
	4900 2750 4900 1550
Wire Wire Line
	5000 2850 5000 1850
Wire Wire Line
	5000 1850 5100 1850
Text Label 6150 1350 2    50   ~ 0
v1pa6
Text Label 6150 1450 2    50   ~ 0
v1pa7
Entry Wire Line
	6250 1250 6150 1350
Entry Wire Line
	6250 1350 6150 1450
Wire Wire Line
	6150 1450 5900 1450
Wire Wire Line
	6150 1350 5900 1350
Text Label 4550 1550 2    50   ~ 0
v1pa0
Text Label 4550 1650 2    50   ~ 0
v1pa1
Text Label 4550 1750 2    50   ~ 0
v1pa2
Text Label 4550 1850 2    50   ~ 0
v1pa3
Text Label 4550 1950 2    50   ~ 0
v1pa4
Text Label 4550 2050 2    50   ~ 0
v1pa5
Entry Wire Line
	4650 1450 4550 1550
Entry Wire Line
	4650 1450 4550 1550
Entry Wire Line
	4650 1550 4550 1650
Entry Wire Line
	4650 1650 4550 1750
Entry Wire Line
	4650 1750 4550 1850
Entry Wire Line
	4650 1850 4550 1950
Entry Wire Line
	4650 1950 4550 2050
Wire Wire Line
	4550 2050 4250 2050
Wire Wire Line
	4550 1950 4250 1950
Wire Wire Line
	4550 1850 4250 1850
Wire Wire Line
	4550 1750 4250 1750
Wire Wire Line
	4550 1650 4250 1650
Wire Wire Line
	4550 1550 4250 1550
Wire Wire Line
	4800 1350 4800 2250
Wire Wire Line
	4250 2250 4800 2250
Wire Wire Line
	2750 2850 5000 2850
NoConn ~ 4250 1350
NoConn ~ 4250 1450
NoConn ~ 5900 1550
NoConn ~ 5900 1650
NoConn ~ 5900 1750
NoConn ~ 5900 1850
NoConn ~ 5900 1950
NoConn ~ 5900 2050
NoConn ~ 5900 2250
Connection ~ 5900 1350
Wire Wire Line
	5900 1350 5850 1350
Connection ~ 5900 1450
Wire Wire Line
	5900 1450 5850 1450
Wire Wire Line
	2750 2000 2750 2850
Text Label 2900 2450 0    50   ~ 0
v1pa8
Entry Wire Line
	2800 2350 2900 2450
Wire Wire Line
	2900 2450 3150 2450
Wire Bus Line
	2800 2200 2800 2350
Connection ~ 3150 2450
Wire Wire Line
	3150 2450 3150 2750
Text GLabel 2500 5000 2    50   Input ~ 0
+5V
Text GLabel 4750 5000 2    50   Input ~ 0
+5V
Wire Wire Line
	4300 5000 4750 5000
Wire Wire Line
	2050 5000 2500 5000
Text GLabel 6600 1000 1    50   Input ~ 0
+5V
Wire Wire Line
	6850 1200 6600 1200
Wire Wire Line
	6600 1200 6600 1000
Text GLabel 7950 1000 1    50   Input ~ 0
R~W
NoConn ~ 1050 4700
NoConn ~ 2050 3500
Wire Bus Line
	2700 3000 2700 3300
$Comp
L Oscillator:TFT660 X2
U 1 1 60C9DB43
P 9400 1300
F 0 "X2" H 9744 1346 50  0000 L CNN
F 1 "TFT660" H 9744 1255 50  0000 L CNN
F 2 "Oscillator:Oscillator_DIP-8" H 9850 950 50  0001 C CNN
F 3 "http://cdn-reichelt.de/documents/datenblatt/B400/OSZI.pdf" H 9300 1300 50  0001 C CNN
	1    9400 1300
	1    0    0    -1  
$EndComp
NoConn ~ 9100 1300
Wire Bus Line
	6250 1200 6250 1350
Wire Bus Line
	4950 3000 4950 3400
Wire Bus Line
	4950 3500 4950 3800
Wire Bus Line
	2700 3500 2700 3800
Wire Bus Line
	8500 1300 8500 2000
Wire Bus Line
	4950 4000 4950 4700
Wire Bus Line
	650  4400 650  5100
Wire Bus Line
	2700 4000 2700 4700
Wire Bus Line
	5300 3850 5300 4650
Wire Bus Line
	4650 1050 4650 1950
Wire Bus Line
	1250 6850 1250 7600
Wire Bus Line
	6400 4300 6400 5200
Wire Bus Line
	6400 2900 6400 3800
Wire Bus Line
	2900 4400 2900 5300
Wire Bus Line
	2900 3000 2900 4100
Wire Bus Line
	650  3000 650  4100
Wire Bus Line
	700  6050 700  7600
$EndSCHEMATC
