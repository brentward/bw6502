EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 2
Title "65C02 Hobby Computer"
Date "2020-02-17"
Rev "v001"
Comp ""
Comment1 ""
Comment2 ""
Comment3 "Based on Ben Eater's design"
Comment4 "Author: Dawid Buchwald"
$EndDescr
Text GLabel 1200 1000 1    50   Input ~ 0
~IRQ
Wire Wire Line
	1200 1000 1200 1400
Text GLabel 2550 1000 1    50   Input ~ 0
CLK
Wire Wire Line
	2550 1400 2300 1400
Text GLabel 2400 3150 3    50   Input ~ 0
GND
Text Label 1100 1900 0    50   ~ 0
a0
Text Label 1100 2000 0    50   ~ 0
a1
Text Label 1100 2100 0    50   ~ 0
a2
Text Label 1100 2200 0    50   ~ 0
a3
Text Label 1100 2300 0    50   ~ 0
a4
Text Label 1100 2400 0    50   ~ 0
a5
Text Label 1100 2500 0    50   ~ 0
a6
Text Label 1100 2600 0    50   ~ 0
a7
Text Label 1100 2700 0    50   ~ 0
a8
Text Label 1100 2800 0    50   ~ 0
a9
Text Label 1100 2900 0    50   ~ 0
a10
Text Label 1100 3000 0    50   ~ 0
a11
Text Label 2500 2900 2    50   ~ 0
a12
Text Label 2500 2800 2    50   ~ 0
a13
Text Label 2500 2700 2    50   ~ 0
a14
Text Label 2500 2600 2    50   ~ 0
a15
Text Label 2500 2500 2    50   ~ 0
d7
Text Label 2500 2400 2    50   ~ 0
d6
Text Label 2500 2300 2    50   ~ 0
d5
Text Label 2500 2200 2    50   ~ 0
d4
Text Label 2500 2100 2    50   ~ 0
d3
Text Label 2500 2000 2    50   ~ 0
d2
Text Label 2500 1900 2    50   ~ 0
d1
Text Label 2500 1800 2    50   ~ 0
d0
Wire Wire Line
	1300 1900 1100 1900
Wire Wire Line
	1300 2000 1100 2000
Wire Wire Line
	1300 2100 1100 2100
Wire Wire Line
	1300 2200 1100 2200
Wire Wire Line
	1300 2300 1100 2300
Wire Wire Line
	1300 2400 1100 2400
Wire Wire Line
	1300 2500 1100 2500
Wire Wire Line
	1300 2600 1100 2600
Wire Wire Line
	1300 2700 1100 2700
Wire Wire Line
	1300 2800 1100 2800
Wire Wire Line
	1300 2900 1100 2900
Wire Wire Line
	1300 3000 1100 3000
Wire Wire Line
	2300 2900 2500 2900
Wire Wire Line
	2300 2800 2500 2800
Wire Wire Line
	2300 2700 2500 2700
Wire Wire Line
	2300 2600 2500 2600
Wire Wire Line
	2300 2500 2500 2500
Wire Wire Line
	2300 2400 2500 2400
Wire Wire Line
	2300 2300 2500 2300
Wire Wire Line
	2300 2200 2500 2200
Wire Wire Line
	2300 2100 2500 2100
Wire Wire Line
	2300 2000 2500 2000
Wire Wire Line
	2300 1900 2500 1900
Wire Wire Line
	2300 1800 2500 1800
Text GLabel 2700 1000 1    50   Input ~ 0
R~W
Wire Wire Line
	2700 1700 2300 1700
NoConn ~ 2300 1200
NoConn ~ 1300 1700
NoConn ~ 1300 1500
NoConn ~ 1300 1300
Wire Wire Line
	1300 1600 1150 1600
Wire Wire Line
	1300 1200 1150 1200
Wire Wire Line
	850  1600 750  1600
Wire Wire Line
	750  1600 750  1200
Wire Wire Line
	750  1200 850  1200
Wire Wire Line
	750  1000 750  1200
Connection ~ 750  1200
Text GLabel 750  1000 1    50   Input ~ 0
+5V
Text GLabel 2400 1000 1    50   Input ~ 0
~RES
Wire Wire Line
	2400 1100 2300 1100
Wire Wire Line
	2300 3000 2400 3000
Wire Wire Line
	2400 3000 2400 3150
Entry Wire Line
	1000 2000 1100 1900
Entry Wire Line
	1000 2100 1100 2000
Entry Wire Line
	1000 2200 1100 2100
Entry Wire Line
	1000 2300 1100 2200
Entry Wire Line
	1000 2400 1100 2300
Entry Wire Line
	1000 2500 1100 2400
Entry Wire Line
	1000 2600 1100 2500
Entry Wire Line
	1000 2700 1100 2600
Entry Wire Line
	1000 2800 1100 2700
Entry Wire Line
	1000 2900 1100 2800
Entry Wire Line
	1000 3000 1100 2900
Entry Wire Line
	1000 3100 1100 3000
Entry Wire Line
	2500 2900 2600 3000
Entry Wire Line
	2500 2800 2600 2900
Entry Wire Line
	2500 2700 2600 2800
Entry Wire Line
	2500 2600 2600 2700
Entry Wire Line
	2500 1800 2600 1900
Entry Wire Line
	2500 1900 2600 2000
Entry Wire Line
	2500 2000 2600 2100
Entry Wire Line
	2500 2100 2600 2200
Entry Wire Line
	2500 2200 2600 2300
Entry Wire Line
	2500 2300 2600 2400
Entry Wire Line
	2500 2400 2600 2500
Entry Wire Line
	2500 2500 2600 2600
NoConn ~ 1300 1100
Wire Wire Line
	10150 3500 10150 3550
Text GLabel 10250 3150 2    50   Output ~ 0
+5V
Text GLabel 10250 3550 2    50   Output ~ 0
GND
Wire Wire Line
	10150 3550 10250 3550
Connection ~ 10150 3550
Wire Wire Line
	10150 3150 10250 3150
Connection ~ 10150 3150
Wire Wire Line
	10150 3150 10150 3200
Wire Wire Line
	750  1800 750  1600
Wire Wire Line
	750  1800 1300 1800
Connection ~ 750  1600
Wire Wire Line
	1200 1400 1300 1400
Wire Wire Line
	2400 1100 2400 1000
Text GLabel 3400 3700 3    50   Input ~ 0
GND
Text GLabel 3400 2900 1    50   Input ~ 0
+5V
Wire Wire Line
	3400 3600 3400 3700
Wire Wire Line
	3400 3000 3400 2900
Text GLabel 3800 3300 2    50   Output ~ 0
CLKOUT
Wire Wire Line
	3700 3300 3800 3300
Text Label 3400 1300 0    50   ~ 0
a15
Wire Wire Line
	3700 1400 3600 1400
Wire Wire Line
	3600 1400 3600 1300
Wire Wire Line
	3600 1200 3700 1200
Wire Wire Line
	3400 1300 3600 1300
Connection ~ 3600 1300
Wire Wire Line
	3600 1300 3600 1200
Text Label 3400 1900 0    50   ~ 0
a14
Wire Wire Line
	3700 1900 3400 1900
Text GLabel 4650 1100 0    50   Input ~ 0
CLK
Entry Wire Line
	3300 2000 3400 1900
Entry Wire Line
	3300 1400 3400 1300
$Comp
L 74xx:74HC00 U4
U 2 1 5E16FD0A
P 4000 2000
F 0 "U4" H 4000 2325 50  0000 C CNN
F 1 "74HC00" H 4000 2234 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 4000 2000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 4000 2000 50  0001 C CNN
	2    4000 2000
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U4
U 1 1 5E16D50B
P 3600 6300
F 0 "U4" H 3600 6625 50  0000 C CNN
F 1 "74HC00" H 3600 6534 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 3600 6300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 3600 6300 50  0001 C CNN
	1    3600 6300
	1    0    0    -1  
$EndComp
$Comp
L Oscillator:ACO-xxxMHz X1
U 1 1 5E1CCFB4
P 3400 3300
F 0 "X1" H 3150 3350 50  0000 R CNN
F 1 "1MHz" H 3150 3250 50  0000 R CNN
F 2 "Oscillator:Oscillator_DIP-14" H 3850 2950 50  0001 C CNN
F 3 "http://www.conwin.com/datasheets/cx/cx030.pdf" H 3300 3300 50  0001 C CNN
	1    3400 3300
	1    0    0    -1  
$EndComp
$Comp
L Device:C C12
U 1 1 5E15B54A
P 10150 3350
F 0 "C12" H 10265 3396 50  0000 L CNN
F 1 "0.1uF" H 10265 3305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.4mm_W2.1mm_P2.50mm" H 10188 3200 50  0001 C CNN
F 3 "~" H 10150 3350 50  0001 C CNN
	1    10150 3350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR02
U 1 1 5E15AF3A
P 6100 3600
F 0 "#PWR02" H 6100 3350 50  0001 C CNN
F 1 "GND" H 6105 3427 50  0000 C CNN
F 2 "" H 6100 3600 50  0001 C CNN
F 3 "" H 6100 3600 50  0001 C CNN
	1    6100 3600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR01
U 1 1 5E15AAC6
P 6100 3100
F 0 "#PWR01" H 6100 2950 50  0001 C CNN
F 1 "+5V" H 6115 3273 50  0000 C CNN
F 2 "" H 6100 3100 50  0001 C CNN
F 3 "" H 6100 3100 50  0001 C CNN
	1    6100 3100
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5E14ABB7
P 1000 1600
F 0 "R2" V 900 1600 50  0000 C CNN
F 1 "3K3" V 1000 1600 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 930 1600 50  0001 C CNN
F 3 "~" H 1000 1600 50  0001 C CNN
	1    1000 1600
	0    1    1    0   
$EndComp
$Comp
L Device:R R1
U 1 1 5E14A45B
P 1000 1200
F 0 "R1" V 900 1200 50  0000 C CNN
F 1 "3K3" V 1000 1200 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 930 1200 50  0001 C CNN
F 3 "~" H 1000 1200 50  0001 C CNN
	1    1000 1200
	0    1    1    0   
$EndComp
$Comp
L 6502:65C02S U3
U 1 1 5E135500
P 1800 2000
F 0 "U3" H 1800 3150 50  0000 C CNN
F 1 "65C02S" H 1800 3050 50  0000 C CNN
F 2 "Package_DIP:DIP-40_W15.24mm_Socket" H 1650 2950 50  0001 C CNN
F 3 "https://www.westerndesigncenter.com/wdc/documentation/w65c02s.pdf" H 1650 2950 50  0001 C CNN
	1    1800 2000
	1    0    0    -1  
$EndComp
$Comp
L 6502:28C256 U2
U 1 1 5E3D4005
P 1550 5000
F 0 "U2" H 1550 5915 50  0000 C CNN
F 1 "28C256" H 1550 5824 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm_Socket" H 1500 5800 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc0006.pdf" H 1550 5000 50  0001 C CNN
	1    1550 5000
	1    0    0    -1  
$EndComp
Text GLabel 2150 4250 1    50   Input ~ 0
+5V
Text GLabel 2300 4250 1    50   Input ~ 0
~ROM_OE
Text GLabel 2450 4250 1    50   Input ~ 0
~ROM_CS
Wire Wire Line
	2150 4250 2150 4350
Wire Wire Line
	2150 4350 2050 4350
Wire Wire Line
	2050 4450 2150 4450
Wire Wire Line
	2150 4450 2150 4350
Connection ~ 2150 4350
Wire Wire Line
	2300 4250 2300 4950
Wire Wire Line
	2300 4950 2050 4950
Wire Wire Line
	2450 4250 2450 5150
Wire Wire Line
	2450 5150 2050 5150
Text Label 2200 5250 2    50   ~ 0
d7
Text Label 2200 5350 2    50   ~ 0
d6
Text Label 2200 5450 2    50   ~ 0
d5
Text Label 2200 5550 2    50   ~ 0
d4
Text Label 2200 5650 2    50   ~ 0
d3
Wire Wire Line
	2050 5650 2200 5650
Wire Wire Line
	2050 5550 2200 5550
Wire Wire Line
	2050 5450 2200 5450
Wire Wire Line
	2050 5350 2200 5350
Wire Wire Line
	2050 5250 2200 5250
Text GLabel 950  5750 3    50   Input ~ 0
GND
Wire Wire Line
	950  5750 950  5650
Wire Wire Line
	950  5650 1050 5650
Text Label 900  5550 0    50   ~ 0
d2
Text Label 900  5450 0    50   ~ 0
d1
Text Label 900  5350 0    50   ~ 0
d0
Wire Wire Line
	900  5350 1050 5350
Wire Wire Line
	900  5450 1050 5450
Wire Wire Line
	900  5550 1050 5550
Entry Wire Line
	2200 5250 2300 5350
Entry Wire Line
	2200 5350 2300 5450
Entry Wire Line
	2200 5450 2300 5550
Entry Wire Line
	2200 5550 2300 5650
Entry Wire Line
	2200 5650 2300 5750
Entry Wire Line
	800  5650 900  5550
Entry Wire Line
	800  5550 900  5450
Entry Wire Line
	800  5450 900  5350
Text Label 900  4350 0    50   ~ 0
a14
Text Label 900  4450 0    50   ~ 0
a12
Text Label 900  4550 0    50   ~ 0
a7
Text Label 900  4650 0    50   ~ 0
a6
Text Label 900  4750 0    50   ~ 0
a5
Text Label 900  4850 0    50   ~ 0
a4
Text Label 900  4950 0    50   ~ 0
a3
Text Label 900  5050 0    50   ~ 0
a2
Text Label 900  5150 0    50   ~ 0
a1
Text Label 900  5250 0    50   ~ 0
a0
Text Label 2600 4550 2    50   ~ 0
a13
Text Label 2600 4650 2    50   ~ 0
a8
Text Label 2600 4750 2    50   ~ 0
a9
Text Label 2600 4850 2    50   ~ 0
a11
Text Label 2600 5050 2    50   ~ 0
a10
Wire Wire Line
	2050 4550 2600 4550
Wire Wire Line
	2050 4650 2600 4650
Wire Wire Line
	2050 4750 2600 4750
Wire Wire Line
	2050 4850 2600 4850
Wire Wire Line
	2050 5050 2600 5050
Wire Wire Line
	1050 4350 900  4350
Wire Wire Line
	1050 4450 900  4450
Wire Wire Line
	1050 4550 900  4550
Wire Wire Line
	1050 4650 900  4650
Wire Wire Line
	1050 4750 900  4750
Wire Wire Line
	1050 4850 900  4850
Wire Wire Line
	1050 4950 900  4950
Wire Wire Line
	1050 5050 900  5050
Wire Wire Line
	1050 5150 900  5150
Wire Wire Line
	1050 5250 900  5250
Entry Wire Line
	800  4250 900  4350
Entry Wire Line
	800  4350 900  4450
Entry Wire Line
	800  4450 900  4550
Entry Wire Line
	800  4550 900  4650
Entry Wire Line
	800  4650 900  4750
Entry Wire Line
	800  4750 900  4850
Entry Wire Line
	800  4850 900  4950
Entry Wire Line
	800  4950 900  5050
Entry Wire Line
	800  5050 900  5150
Entry Wire Line
	800  5150 900  5250
Entry Wire Line
	2600 4550 2700 4650
Entry Wire Line
	2600 4650 2700 4750
Entry Wire Line
	2600 4750 2700 4850
Entry Wire Line
	2600 4850 2700 4950
Entry Wire Line
	2600 5050 2700 5150
$Comp
L 6502:62256 U5
U 1 1 5E37B16A
P 3850 5000
F 0 "U5" H 3850 5915 50  0000 C CNN
F 1 "62256" H 3850 5824 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm_Socket" H 3800 5800 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc0006.pdf" H 3850 5000 50  0001 C CNN
	1    3850 5000
	1    0    0    -1  
$EndComp
Text GLabel 4450 4250 1    50   Input ~ 0
+5V
Wire Wire Line
	4450 4250 4450 4350
Wire Wire Line
	4450 4350 4350 4350
Wire Wire Line
	4750 4250 4750 4950
Wire Wire Line
	4750 4950 4350 4950
Text Label 4500 5250 2    50   ~ 0
d7
Text Label 4500 5350 2    50   ~ 0
d6
Text Label 4500 5450 2    50   ~ 0
d5
Text Label 4500 5550 2    50   ~ 0
d4
Text Label 4500 5650 2    50   ~ 0
d3
Wire Wire Line
	4350 5650 4500 5650
Wire Wire Line
	4350 5550 4500 5550
Wire Wire Line
	4350 5450 4500 5450
Wire Wire Line
	4350 5350 4500 5350
Wire Wire Line
	4350 5250 4500 5250
Text GLabel 3250 5750 3    50   Input ~ 0
GND
Wire Wire Line
	3250 5750 3250 5650
Wire Wire Line
	3250 5650 3350 5650
Text Label 3200 5550 0    50   ~ 0
d2
Text Label 3200 5450 0    50   ~ 0
d1
Text Label 3200 5350 0    50   ~ 0
d0
Wire Wire Line
	3200 5350 3350 5350
Wire Wire Line
	3200 5450 3350 5450
Wire Wire Line
	3200 5550 3350 5550
Entry Wire Line
	4500 5250 4600 5350
Entry Wire Line
	4500 5350 4600 5450
Entry Wire Line
	4500 5450 4600 5550
Entry Wire Line
	4500 5550 4600 5650
Entry Wire Line
	4500 5650 4600 5750
Entry Wire Line
	3100 5650 3200 5550
Entry Wire Line
	3100 5550 3200 5450
Entry Wire Line
	3100 5450 3200 5350
Text Label 3200 4350 0    50   ~ 0
a14
Text Label 3200 4450 0    50   ~ 0
a12
Text Label 3200 4550 0    50   ~ 0
a7
Text Label 3200 4650 0    50   ~ 0
a6
Text Label 3200 4750 0    50   ~ 0
a5
Text Label 3200 4850 0    50   ~ 0
a4
Text Label 3200 4950 0    50   ~ 0
a3
Text Label 3200 5050 0    50   ~ 0
a2
Text Label 3200 5150 0    50   ~ 0
a1
Text Label 3200 5250 0    50   ~ 0
a0
Wire Wire Line
	3350 4350 3200 4350
Wire Wire Line
	3350 4450 3200 4450
Wire Wire Line
	3350 4550 3200 4550
Wire Wire Line
	3350 4650 3200 4650
Wire Wire Line
	3350 4750 3200 4750
Wire Wire Line
	3350 4850 3200 4850
Wire Wire Line
	3350 4950 3200 4950
Wire Wire Line
	3350 5050 3200 5050
Wire Wire Line
	3350 5150 3200 5150
Wire Wire Line
	3350 5250 3200 5250
Entry Wire Line
	3100 4250 3200 4350
Entry Wire Line
	3100 4350 3200 4450
Entry Wire Line
	3100 4450 3200 4550
Entry Wire Line
	3100 4550 3200 4650
Entry Wire Line
	3100 4650 3200 4750
Entry Wire Line
	3100 4750 3200 4850
Entry Wire Line
	3100 4850 3200 4950
Entry Wire Line
	3100 4950 3200 5050
Entry Wire Line
	3100 5050 3200 5150
Entry Wire Line
	3100 5150 3200 5250
Text GLabel 4750 4250 1    50   Input ~ 0
~RAM_CS
Entry Wire Line
	4900 5050 5000 5150
Entry Wire Line
	4900 4850 5000 4950
Entry Wire Line
	4900 4750 5000 4850
Entry Wire Line
	4900 4650 5000 4750
Entry Wire Line
	4900 4550 5000 4650
Wire Wire Line
	4350 5050 4900 5050
Text Label 4900 5050 2    50   ~ 0
a10
Wire Wire Line
	4350 4850 4900 4850
Text Label 4900 4850 2    50   ~ 0
a11
Wire Wire Line
	4350 4750 4900 4750
Text Label 4900 4750 2    50   ~ 0
a9
Wire Wire Line
	4350 4650 4900 4650
Text Label 4900 4650 2    50   ~ 0
a8
Wire Wire Line
	4350 4550 4900 4550
Text Label 4900 4550 2    50   ~ 0
a13
Wire Wire Line
	4750 4950 4750 5150
Wire Wire Line
	4750 5150 4350 5150
Connection ~ 4750 4950
Text GLabel 4600 4250 1    50   Input ~ 0
R~W
Wire Wire Line
	4600 4450 4600 4250
Wire Wire Line
	4350 4450 4600 4450
$Comp
L Device:R R5
U 1 1 5E1F5B26
P 6700 1950
F 0 "R5" V 6600 1950 50  0000 C CNN
F 1 "20K" V 6700 1950 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 6630 1950 50  0001 C CNN
F 3 "~" H 6700 1950 50  0001 C CNN
	1    6700 1950
	0    1    1    0   
$EndComp
$Comp
L Device:CP C4
U 1 1 5E2337BD
P 7000 1550
F 0 "C4" H 7118 1596 50  0000 L CNN
F 1 "1uF" H 7118 1505 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D5.0mm_P2.50mm" H 7038 1400 50  0001 C CNN
F 3 "~" H 7000 1550 50  0001 C CNN
	1    7000 1550
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push SW1
U 1 1 5E2CBD4E
P 6400 1300
F 0 "SW1" V 6450 1600 50  0000 R CNN
F 1 "RESET" V 6350 1650 50  0000 R CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm_H4.3mm" H 6400 1500 50  0001 C CNN
F 3 "~" H 6400 1500 50  0001 C CNN
	1    6400 1300
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R4
U 1 1 5E3A85D8
P 6400 1650
F 0 "R4" V 6300 1650 50  0000 C CNN
F 1 "20K" V 6400 1650 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 6330 1650 50  0001 C CNN
F 3 "~" H 6400 1650 50  0001 C CNN
	1    6400 1650
	1    0    0    -1  
$EndComp
Text GLabel 8100 1950 2    50   Output ~ 0
~RES
$Comp
L Device:R R6
U 1 1 5E552FBE
P 7350 1950
F 0 "R6" V 7250 1950 50  0000 C CNN
F 1 "51K" V 7350 1950 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 7280 1950 50  0001 C CNN
F 3 "~" H 7350 1950 50  0001 C CNN
	1    7350 1950
	0    1    1    0   
$EndComp
Text GLabel 6400 1000 1    50   Input ~ 0
+5V
Text GLabel 6400 2150 3    50   Input ~ 0
GND
$Comp
L Device:C C11
U 1 1 5E3E0FFB
P 9700 3350
F 0 "C11" H 9815 3396 50  0000 L CNN
F 1 "0.1uF" H 9815 3305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.4mm_W2.1mm_P2.50mm" H 9738 3200 50  0001 C CNN
F 3 "~" H 9700 3350 50  0001 C CNN
	1    9700 3350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C10
U 1 1 5E3E14F5
P 9250 3350
F 0 "C10" H 9365 3396 50  0000 L CNN
F 1 "0.1uF" H 9365 3305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.4mm_W2.1mm_P2.50mm" H 9288 3200 50  0001 C CNN
F 3 "~" H 9250 3350 50  0001 C CNN
	1    9250 3350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C9
U 1 1 5E3E1910
P 8800 3350
F 0 "C9" H 8915 3396 50  0000 L CNN
F 1 "0.1uF" H 8915 3305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.4mm_W2.1mm_P2.50mm" H 8838 3200 50  0001 C CNN
F 3 "~" H 8800 3350 50  0001 C CNN
	1    8800 3350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C8
U 1 1 5E3E1BD5
P 8350 3350
F 0 "C8" H 8465 3396 50  0000 L CNN
F 1 "0.1uF" H 8465 3305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.4mm_W2.1mm_P2.50mm" H 8388 3200 50  0001 C CNN
F 3 "~" H 8350 3350 50  0001 C CNN
	1    8350 3350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C6
U 1 1 5E3E2103
P 7450 3350
F 0 "C6" H 7565 3396 50  0000 L CNN
F 1 "0.1uF" H 7565 3305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.4mm_W2.1mm_P2.50mm" H 7488 3200 50  0001 C CNN
F 3 "~" H 7450 3350 50  0001 C CNN
	1    7450 3350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C5
U 1 1 5E3E2489
P 7000 3350
F 0 "C5" H 7115 3396 50  0000 L CNN
F 1 "0.1uF" H 7115 3305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.4mm_W2.1mm_P2.50mm" H 7038 3200 50  0001 C CNN
F 3 "~" H 7000 3350 50  0001 C CNN
	1    7000 3350
	1    0    0    -1  
$EndComp
Wire Wire Line
	7000 3500 7000 3550
Wire Wire Line
	7000 3550 7450 3550
Wire Wire Line
	7450 3500 7450 3550
Connection ~ 7450 3550
Wire Wire Line
	7450 3550 7900 3550
Wire Wire Line
	7900 3500 7900 3550
Connection ~ 7900 3550
Wire Wire Line
	7900 3550 8350 3550
Wire Wire Line
	8350 3500 8350 3550
Connection ~ 8350 3550
Wire Wire Line
	8350 3550 8800 3550
Wire Wire Line
	8800 3500 8800 3550
Connection ~ 8800 3550
Wire Wire Line
	8800 3550 9250 3550
Wire Wire Line
	9250 3500 9250 3550
Connection ~ 9250 3550
Wire Wire Line
	9250 3550 9700 3550
Wire Wire Line
	9700 3500 9700 3550
Connection ~ 9700 3550
Wire Wire Line
	9700 3550 10150 3550
Wire Wire Line
	7000 3200 7000 3150
Wire Wire Line
	7000 3150 7450 3150
Wire Wire Line
	7450 3200 7450 3150
Connection ~ 7450 3150
Wire Wire Line
	7450 3150 7900 3150
Wire Wire Line
	7900 3200 7900 3150
Connection ~ 7900 3150
Wire Wire Line
	7900 3150 8350 3150
Wire Wire Line
	8350 3200 8350 3150
Connection ~ 8350 3150
Wire Wire Line
	8350 3150 8800 3150
Wire Wire Line
	8800 3200 8800 3150
Connection ~ 8800 3150
Wire Wire Line
	8800 3150 9250 3150
Wire Wire Line
	9250 3200 9250 3150
Connection ~ 9250 3150
Wire Wire Line
	9250 3150 9700 3150
Wire Wire Line
	9700 3200 9700 3150
Connection ~ 9700 3150
Wire Wire Line
	9700 3150 10150 3150
Connection ~ 7000 3550
Connection ~ 7000 3150
$Comp
L Device:C C3
U 1 1 5E6FCC42
P 6550 3350
F 0 "C3" H 6665 3396 50  0000 L CNN
F 1 "0.1uF" H 6665 3305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.4mm_W2.1mm_P2.50mm" H 6588 3200 50  0001 C CNN
F 3 "~" H 6550 3350 50  0001 C CNN
	1    6550 3350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C2
U 1 1 5E6FCFF5
P 6100 3350
F 0 "C2" H 6215 3396 50  0000 L CNN
F 1 "0.1uF" H 6215 3305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.4mm_W2.1mm_P2.50mm" H 6138 3200 50  0001 C CNN
F 3 "~" H 6100 3350 50  0001 C CNN
	1    6100 3350
	1    0    0    -1  
$EndComp
Wire Wire Line
	6100 3500 6100 3550
Wire Wire Line
	6100 3550 6550 3550
Wire Wire Line
	6550 3500 6550 3550
Connection ~ 6550 3550
Wire Wire Line
	6550 3550 7000 3550
Wire Wire Line
	7000 3150 6550 3150
Wire Wire Line
	6100 3150 6100 3200
Wire Wire Line
	6550 3200 6550 3150
Connection ~ 6550 3150
Wire Wire Line
	6550 3150 6100 3150
Wire Wire Line
	6100 3150 6100 3100
Connection ~ 6100 3150
Wire Wire Line
	6100 3550 6100 3600
Connection ~ 6100 3550
Text Notes 7600 3650 0    50   ~ 0
Bypass capacitors, one per IC
$Sheet
S 10150 5250 750  1100
U 5F14295C
F0 "6502 Peripherals" 50
F1 "6502_IO.sch" 50
$EndSheet
$Comp
L Connector_Generic:Conn_02x16_Odd_Even J?
U 1 1 6003736A
P 5850 5050
AR Path="/5F14295C/6003736A" Ref="J?"  Part="1" 
AR Path="/6003736A" Ref="J2"  Part="1" 
F 0 "J2" H 5900 5967 50  0000 C CNN
F 1 "Expansion port" H 5900 5876 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x16_P2.54mm_Vertical" H 5850 5050 50  0001 C CNN
F 3 "~" H 5850 5050 50  0001 C CNN
	1    5850 5050
	1    0    0    -1  
$EndComp
Text Label 5450 4350 0    50   ~ 0
a0
Text Label 5450 4450 0    50   ~ 0
a1
Text Label 5450 4550 0    50   ~ 0
a2
Text Label 5450 4650 0    50   ~ 0
a3
Text Label 5450 4750 0    50   ~ 0
a4
Text Label 5450 4850 0    50   ~ 0
a5
Text Label 5450 4950 0    50   ~ 0
a6
Text Label 5450 5050 0    50   ~ 0
a7
Text Label 5450 5150 0    50   ~ 0
a8
Text Label 5450 5250 0    50   ~ 0
a9
Text Label 5450 5350 0    50   ~ 0
a10
Text Label 5450 5450 0    50   ~ 0
a11
Text Label 5450 5550 0    50   ~ 0
a12
Text Label 5450 5650 0    50   ~ 0
a13
Text Label 5450 5750 0    50   ~ 0
a14
Text Label 5450 5850 0    50   ~ 0
a15
Wire Wire Line
	5450 4350 5650 4350
Wire Wire Line
	5450 4450 5650 4450
Wire Wire Line
	5450 4550 5650 4550
Wire Wire Line
	5450 4650 5650 4650
Wire Wire Line
	5450 4750 5650 4750
Wire Wire Line
	5450 4850 5650 4850
Wire Wire Line
	5450 4950 5650 4950
Wire Wire Line
	5450 5050 5650 5050
Wire Wire Line
	5450 5150 5650 5150
Wire Wire Line
	5450 5250 5650 5250
Wire Wire Line
	5450 5350 5650 5350
Wire Wire Line
	5450 5450 5650 5450
Wire Wire Line
	5450 5550 5650 5550
Wire Wire Line
	5450 5650 5650 5650
Wire Wire Line
	5450 5750 5650 5750
Wire Wire Line
	5450 5850 5650 5850
Entry Wire Line
	5350 4250 5450 4350
Entry Wire Line
	5350 4350 5450 4450
Entry Wire Line
	5350 4450 5450 4550
Entry Wire Line
	5350 4550 5450 4650
Entry Wire Line
	5350 4650 5450 4750
Entry Wire Line
	5350 4750 5450 4850
Entry Wire Line
	5350 4850 5450 4950
Entry Wire Line
	5350 4950 5450 5050
Entry Wire Line
	5350 5050 5450 5150
Entry Wire Line
	5350 5150 5450 5250
Entry Wire Line
	5350 5250 5450 5350
Entry Wire Line
	5350 5350 5450 5450
Entry Wire Line
	5350 5450 5450 5550
Entry Wire Line
	5350 5550 5450 5650
Entry Wire Line
	5350 5650 5450 5750
Entry Wire Line
	5350 5750 5450 5850
Text Label 6350 4350 2    50   ~ 0
d0
Text Label 6350 4450 2    50   ~ 0
d1
Text Label 6350 4550 2    50   ~ 0
d2
Text Label 6350 4650 2    50   ~ 0
d3
Text Label 6350 4750 2    50   ~ 0
d4
Text Label 6350 4850 2    50   ~ 0
d5
Text Label 6350 4950 2    50   ~ 0
d6
Text Label 6350 5050 2    50   ~ 0
d7
Wire Wire Line
	6150 4350 6350 4350
Wire Wire Line
	6150 4450 6350 4450
Wire Wire Line
	6150 4550 6350 4550
Wire Wire Line
	6150 4650 6350 4650
Wire Wire Line
	6150 4750 6350 4750
Wire Wire Line
	6150 4850 6350 4850
Wire Wire Line
	6150 4950 6350 4950
Wire Wire Line
	6150 5050 6350 5050
Entry Wire Line
	6350 4350 6450 4250
Entry Wire Line
	6350 4450 6450 4350
Entry Wire Line
	6350 4550 6450 4450
Entry Wire Line
	6350 4650 6450 4550
Entry Wire Line
	6350 4750 6450 4650
Entry Wire Line
	6350 4850 6450 4750
Entry Wire Line
	6350 4950 6450 4850
Entry Wire Line
	6350 5050 6450 4950
Text GLabel 6550 5050 1    50   Input ~ 0
CLK
Text GLabel 6700 5050 1    50   Input ~ 0
R~W
Text GLabel 6350 5850 2    50   Input ~ 0
+5V
Text GLabel 6350 5750 2    50   Input ~ 0
GND
Wire Wire Line
	6150 5850 6350 5850
Wire Wire Line
	6150 5750 6350 5750
Wire Wire Line
	6550 5050 6550 5150
Wire Wire Line
	6550 5150 6150 5150
Text GLabel 7000 5050 1    50   Input ~ 0
~RES
Text GLabel 6850 5050 1    50   Input ~ 0
~IOCS
Wire Wire Line
	6700 5050 6700 5250
Wire Wire Line
	6700 5250 6150 5250
Wire Wire Line
	6850 5050 6850 5350
Wire Wire Line
	6850 5350 6150 5350
Wire Wire Line
	7000 5050 7000 5450
Wire Wire Line
	7000 5450 6150 5450
Text GLabel 7150 5050 1    50   Output ~ 0
~IRQX
Wire Wire Line
	6150 5550 7150 5550
Wire Wire Line
	7150 5550 7150 5050
$Comp
L Connector:Conn_01x03_Male J1
U 1 1 5E49655D
P 4400 2750
F 0 "J1" H 4372 2632 50  0000 R CNN
F 1 "CLK Jumper" H 4372 2723 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical" H 4400 2750 50  0001 C CNN
F 3 "~" H 4400 2750 50  0001 C CNN
	1    4400 2750
	-1   0    0    1   
$EndComp
Text GLabel 4100 2650 0    50   Input ~ 0
CLKOUT
Text GLabel 4100 2750 0    50   Output ~ 0
CLK
Wire Wire Line
	4100 2650 4200 2650
Wire Wire Line
	4100 2750 4200 2750
NoConn ~ 6150 5650
Wire Bus Line
	1000 3450 2600 3450
Text GLabel 1100 3250 2    50   Input ~ 0
a[0..15]
Wire Bus Line
	1100 3250 1000 3250
Connection ~ 1000 3250
Wire Bus Line
	1000 3250 1000 3450
Text GLabel 2700 2600 2    50   Input ~ 0
d[0..7]
Wire Bus Line
	2700 2600 2600 2600
$Comp
L 74xx:74HC00 U4
U 5 1 5E5C6EF1
P 2050 6850
F 0 "U4" H 2280 6896 50  0000 L CNN
F 1 "74HC00" H 2280 6805 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 2050 6850 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 2050 6850 50  0001 C CNN
	5    2050 6850
	1    0    0    -1  
$EndComp
Text GLabel 2050 6250 1    50   Input ~ 0
+5V
Text GLabel 2050 7450 3    50   Input ~ 0
GND
Wire Wire Line
	2050 6250 2050 6350
Wire Wire Line
	2050 7350 2050 7450
Text GLabel 4100 2850 0    50   Input ~ 0
GND
Wire Wire Line
	4100 2850 4200 2850
$Comp
L Device:CP C1
U 1 1 5E543526
P 5550 3350
F 0 "C1" H 5668 3396 50  0000 L CNN
F 1 "1000uF" H 5668 3305 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D10.0mm_P5.00mm" H 5588 3200 50  0001 C CNN
F 3 "~" H 5550 3350 50  0001 C CNN
	1    5550 3350
	1    0    0    -1  
$EndComp
Wire Wire Line
	5550 3200 5550 3150
Wire Wire Line
	5550 3150 6100 3150
Wire Wire Line
	5550 3500 5550 3550
Wire Wire Line
	5550 3550 6100 3550
Text GLabel 1250 6350 1    50   Input ~ 0
+5V
Text GLabel 1250 7350 3    50   Input ~ 0
GND
$Comp
L 65C02_Computer-cache:74HC00 U4
U 4 1 608DC6D0
P 4000 1300
F 0 "U4" H 4000 1625 50  0000 C CNN
F 1 "74HC00" H 4000 1534 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 4000 1300 50  0001 C CNN
F 3 "" H 4000 1300 50  0001 C CNN
	4    4000 1300
	1    0    0    -1  
$EndComp
Text GLabel 4600 2000 2    50   Output ~ 0
~IOCS
Wire Wire Line
	4300 2000 4600 2000
Text GLabel 3300 6400 0    50   Input ~ 0
+5V
Text GLabel 3300 6200 0    50   Input ~ 0
+5V
NoConn ~ 3900 6300
Wire Wire Line
	4300 1300 4400 1300
Wire Wire Line
	4400 1000 4400 1300
Wire Wire Line
	5350 1000 4400 1000
Text GLabel 5350 1000 2    50   Output ~ 0
~ROM_CS
Connection ~ 4400 1300
$Comp
L 74xx:74HC00 U4
U 3 1 5E171DC1
P 4950 1200
F 0 "U4" H 4950 1525 50  0000 C CNN
F 1 "74HC00" H 4950 1434 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 4950 1200 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 4950 1200 50  0001 C CNN
	3    4950 1200
	1    0    0    -1  
$EndComp
Wire Wire Line
	5250 1200 5350 1200
Text GLabel 5350 1200 2    50   Output ~ 0
~RAM_CS
Wire Wire Line
	4400 1300 4550 1300
Wire Wire Line
	4550 1300 4550 1700
Wire Wire Line
	4550 1700 5000 1700
Wire Wire Line
	5000 1700 5000 2200
Wire Wire Line
	5000 2200 3700 2200
Wire Wire Line
	3700 2200 3700 2100
Connection ~ 4550 1300
Wire Wire Line
	4550 1300 4650 1300
$Comp
L 74xx:74HC14 U1
U 1 1 60D4BB74
P 7800 1950
F 0 "U1" H 7800 2267 50  0000 C CNN
F 1 "74HC14" H 7800 2176 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 7800 1950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 7800 1950 50  0001 C CNN
	1    7800 1950
	1    0    0    -1  
$EndComp
Text GLabel 7000 1000 1    50   Input ~ 0
+5V
Wire Wire Line
	6550 1950 6400 1950
Wire Wire Line
	6400 1750 6400 1800
Connection ~ 6400 1950
Wire Wire Line
	6850 1950 7000 1950
Connection ~ 7000 1950
Wire Wire Line
	7000 1950 7200 1950
$Comp
L 74xx:74HC14 U1
U 7 1 60A1900C
P 1250 6850
F 0 "U1" H 1480 6896 50  0000 L CNN
F 1 "74HC14" H 1480 6805 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 1250 6850 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 1250 6850 50  0001 C CNN
	7    1250 6850
	1    0    0    -1  
$EndComp
Text GLabel 3300 6900 0    50   Input ~ 0
+5V
Text GLabel 3300 7450 0    50   Input ~ 0
+5V
$Comp
L 74xx:74HC14 U1
U 3 1 611EBCEE
P 3600 7450
F 0 "U1" H 3600 7767 50  0000 C CNN
F 1 "74HC14" H 3600 7676 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 3600 7450 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 3600 7450 50  0001 C CNN
	3    3600 7450
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC14 U1
U 2 1 611FE587
P 3600 6900
F 0 "U1" H 3600 7217 50  0000 C CNN
F 1 "74HC14" H 3600 7126 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 3600 6900 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 3600 6900 50  0001 C CNN
	2    3600 6900
	1    0    0    -1  
$EndComp
NoConn ~ 3900 6900
NoConn ~ 3900 7450
NoConn ~ 7450 3550
Wire Wire Line
	6400 1950 6400 2150
Wire Wire Line
	6400 1100 6400 1000
Wire Wire Line
	7000 1700 7000 1950
Wire Wire Line
	7000 1400 7000 1000
Connection ~ 6400 1800
Wire Wire Line
	6400 1800 6400 1950
Wire Wire Line
	2550 1400 2550 1000
Wire Wire Line
	3100 1300 3100 1000
Connection ~ 3100 1300
Text GLabel 3100 1000 1    50   Input ~ 0
+5V
Wire Wire Line
	3100 1500 3100 1300
Wire Wire Line
	2700 1700 2700 1000
Wire Wire Line
	2300 1300 3100 1300
$Comp
L Device:R R3
U 1 1 61577EEE
P 2900 1500
F 0 "R3" V 2800 1500 50  0000 C CNN
F 1 "3K3" V 2900 1500 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 2830 1500 50  0001 C CNN
F 3 "~" H 2900 1500 50  0001 C CNN
	1    2900 1500
	0    1    1    0   
$EndComp
Wire Wire Line
	3050 1500 3100 1500
Wire Wire Line
	2750 1500 2300 1500
Wire Bus Line
	3100 5450 3100 5650
Wire Bus Line
	800  5450 800  5650
Wire Bus Line
	3300 1400 3300 2300
Wire Bus Line
	5000 4650 5000 5150
Wire Bus Line
	4600 5350 4600 5750
Wire Bus Line
	2700 4650 2700 5150
Wire Bus Line
	2300 5350 2300 5750
Wire Bus Line
	2600 2700 2600 3450
Wire Bus Line
	2600 1900 2600 2600
Wire Bus Line
	6450 4250 6450 4950
Wire Bus Line
	3100 4250 3100 5150
Wire Bus Line
	800  4250 800  5150
Wire Bus Line
	1000 2000 1000 3250
Wire Bus Line
	5350 4250 5350 5750
$Comp
L Device:C C7
U 1 1 5E3E1DA8
P 7900 3350
F 0 "C7" H 8015 3396 50  0000 L CNN
F 1 "0.1uF" H 8015 3305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.4mm_W2.1mm_P2.50mm" H 7938 3200 50  0001 C CNN
F 3 "~" H 7900 3350 50  0001 C CNN
	1    7900 3350
	1    0    0    -1  
$EndComp
$EndSCHEMATC
