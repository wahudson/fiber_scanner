EESchema Schematic File Version 4
LIBS:ki-cache
EELAYER 26 0
EELAYER END
$Descr A 11000 8500
encoding utf-8
Sheet 1 1
Title "Current Buffer"
Date "2023-04-22"
Rev "v2.1.0"
Comp "William A. Hudson"
Comment1 "v2.1  output back EMF protection D2,D3"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L _Local:OPA548 U1
U 1 1 5EB38EE7
P 6800 3000
F 0 "U1" H 6850 3300 50  0000 L CNN
F 1 "OPA548" H 6850 3200 50  0000 L CNN
F 2 "TO-220-7" H 7150 2700 50  0001 C CNN
F 3 "http://www.analog.com/media/en/technical-documentation/data-sheets/AD8603_8607_8609.pdf" H 6800 3200 50  0001 C CNN
	1    6800 3000
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C11
U 1 1 5EB4CA54
P 6600 2400
F 0 "C11" V 6600 1900 50  0000 C CNN
F 1 "0.1uF" V 6600 2150 50  0000 C CNN
F 2 "" H 6600 2400 50  0001 C CNN
F 3 "~" H 6600 2400 50  0001 C CNN
	1    6600 2400
	0    1    1    0   
$EndComp
$Comp
L Device:C_Small C14
U 1 1 5EB4CC2F
P 6600 3500
F 0 "C14" V 6600 3000 50  0000 C CNN
F 1 "0.1uF" V 6600 3250 50  0000 C CNN
F 2 "" H 6600 3500 50  0001 C CNN
F 3 "~" H 6600 3500 50  0001 C CNN
	1    6600 3500
	0    1    1    0   
$EndComp
$Comp
L Device:CP1_Small C13
U 1 1 5EB4CD7E
P 6600 2000
F 0 "C13" V 6600 1500 50  0000 C CNN
F 1 "180uF" V 6600 1750 50  0000 C CNN
F 2 "" H 6600 2000 50  0001 C CNN
F 3 "~" H 6600 2000 50  0001 C CNN
	1    6600 2000
	0    1    1    0   
$EndComp
$Comp
L Device:CP1_Small C16
U 1 1 5EB4CEE1
P 6600 3900
F 0 "C16" V 6600 4400 50  0000 C CNN
F 1 "180uF" V 6600 4150 50  0000 C CNN
F 2 "" H 6600 3900 50  0001 C CNN
F 3 "~" H 6600 3900 50  0001 C CNN
	1    6600 3900
	0    -1   1    0   
$EndComp
$Comp
L Device:C_Small C10
U 1 1 5EB4D004
P 6400 2750
F 0 "C10" H 6150 2800 50  0000 L CNN
F 1 "0.01uF" H 6050 2700 50  0000 L CNN
F 2 "" H 6400 2750 50  0001 C CNN
F 3 "~" H 6400 2750 50  0001 C CNN
	1    6400 2750
	1    0    0    -1  
$EndComp
$Comp
L Device:R_US Rf4
U 1 1 5EB4DA1B
P 6250 4600
F 0 "Rf4" V 6045 4600 50  0000 C CNN
F 1 "402" V 6136 4600 50  0000 C CNN
F 2 "" V 6290 4590 50  0001 C CNN
F 3 "~" H 6250 4600 50  0001 C CNN
	1    6250 4600
	0    1    1    0   
$EndComp
$Comp
L Device:R_US Rs
U 1 1 5EB4E054
P 7400 5250
F 0 "Rs" H 7332 5204 50  0000 R CNN
F 1 "1.0R  5W, 5%, Wirewound" H 7332 5295 50  0000 R CNN
F 2 "" V 7440 5240 50  0001 C CNN
F 3 "~" H 7400 5250 50  0001 C CNN
	1    7400 5250
	-1   0    0    1   
$EndComp
$Comp
L _Local:GND #PWR0101
U 1 1 5EB4E65B
P 6500 4000
F 0 "#PWR0101" H 6500 3750 50  0001 C CNN
F 1 "GND" H 6500 3827 50  0000 C CNN
F 2 "" H 6400 3650 50  0001 C CNN
F 3 "" H 6500 3750 50  0001 C CNN
	1    6500 4000
	1    0    0    -1  
$EndComp
$Comp
L _Local:VNN #PWR0102
U 1 1 5EB4E9E4
P 6700 4000
F 0 "#PWR0102" H 6700 3750 50  0001 C CNN
F 1 "VNN" H 6717 3827 50  0000 C CNN
F 2 "" H 6700 4000 50  0001 C CNN
F 3 "" H 6700 4000 50  0001 C CNN
	1    6700 4000
	1    0    0    -1  
$EndComp
$Comp
L Device:R_US Rf5
U 1 1 5EB4EB99
P 6250 5000
F 0 "Rf5" V 6050 5050 50  0000 R CNN
F 1 "100" V 6150 5050 50  0000 R CNN
F 2 "" V 6290 4990 50  0001 C CNN
F 3 "~" H 6250 5000 50  0001 C CNN
	1    6250 5000
	0    1    1    0   
$EndComp
$Comp
L Device:C_Small Cf4
U 1 1 5EB4ECCF
P 6750 4600
F 0 "Cf4" V 6521 4600 50  0000 C CNN
F 1 "47nF" V 6612 4600 50  0000 C CNN
F 2 "" H 6750 4600 50  0001 C CNN
F 3 "~" H 6750 4600 50  0001 C CNN
	1    6750 4600
	0    1    1    0   
$EndComp
Wire Wire Line
	7200 4600 6850 4600
Wire Wire Line
	6650 4600 6400 4600
Wire Wire Line
	6500 3100 5900 3100
Wire Wire Line
	6100 4600 5900 4600
Wire Wire Line
	7200 3000 7400 3000
Connection ~ 6700 3500
Wire Wire Line
	6700 3500 6700 3700
Connection ~ 6700 3700
Wire Wire Line
	6500 4000 6500 3900
Connection ~ 6500 3700
Wire Wire Line
	6500 3700 6500 3500
Wire Wire Line
	6400 3350 6700 3350
Connection ~ 6700 3350
Wire Wire Line
	6700 3350 6700 3500
Wire Wire Line
	6400 2650 6700 2650
Connection ~ 6700 2650
Wire Wire Line
	7400 3000 7400 4500
$Comp
L _Local:GND #PWR0104
U 1 1 5EB51758
P 6500 2500
F 0 "#PWR0104" H 6500 2250 50  0001 C CNN
F 1 "GND" H 6350 2450 50  0000 C CNN
F 2 "" H 6400 2150 50  0001 C CNN
F 3 "" H 6500 2250 50  0001 C CNN
	1    6500 2500
	1    0    0    -1  
$EndComp
Connection ~ 6700 2400
Wire Wire Line
	6700 2400 6700 2650
Wire Wire Line
	6500 2000 6500 2200
Connection ~ 6500 2400
Wire Wire Line
	6500 2400 6500 2500
$Comp
L _Local:VPP #PWR0105
U 1 1 5EB52F7C
P 6700 1900
F 0 "#PWR0105" H 6700 2150 50  0001 C CNN
F 1 "VPP" H 6717 2073 50  0000 C CNN
F 2 "" H 6700 1900 50  0001 C CNN
F 3 "" H 6700 1900 50  0001 C CNN
	1    6700 1900
	1    0    0    -1  
$EndComp
Wire Wire Line
	6700 1900 6700 2000
$Comp
L _Local:GND #PWR0106
U 1 1 5EB53793
P 7400 5600
F 0 "#PWR0106" H 7400 5350 50  0001 C CNN
F 1 "GND" H 7400 5427 50  0000 C CNN
F 2 "" H 7300 5250 50  0001 C CNN
F 3 "" H 7400 5350 50  0001 C CNN
	1    7400 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:L L1
U 1 1 5EB547FD
P 9400 4900
F 0 "L1" H 9453 4946 50  0000 L CNN
F 1 "L" H 9453 4855 50  0000 L CNN
F 2 "" H 9400 4900 50  0001 C CNN
F 3 "~" H 9400 4900 50  0001 C CNN
	1    9400 4900
	1    0    0    -1  
$EndComp
Wire Wire Line
	6400 2850 6400 3350
Text Label 7350 3000 0    50   ~ 0
Vo
Text Label 7400 5000 0    50   ~ 0
Vs
$Comp
L Device:R_US Rlim
U 1 1 5EB59D02
P 9500 4050
F 0 "Rlim" H 9432 4004 50  0000 R CNN
F 1 "57.6k" H 9432 4095 50  0000 R CNN
F 2 "" V 9540 4040 50  0001 C CNN
F 3 "~" H 9500 4050 50  0001 C CNN
	1    9500 4050
	-1   0    0    1   
$EndComp
$Comp
L Switch:SW_SPST SW1
U 1 1 5EB5B637
P 9550 3400
F 0 "SW1" H 9500 3500 50  0000 C CNN
F 1 "SW_SPST" H 9550 3544 50  0001 C CNN
F 2 "" H 9550 3400 50  0001 C CNN
F 3 "" H 9550 3400 50  0001 C CNN
	1    9550 3400
	1    0    0    -1  
$EndComp
Text Notes 9800 3300 0    50   ~ 0
N.O.= Enabled
$Comp
L _Local:Socket1 J?
U 1 1 5ED4D395
P 6600 4600
F 0 "J?" H 6658 4646 50  0001 L CNN
F 1 "Socket1" H 6658 4555 50  0001 L CNN
F 2 "" H 6600 4600 50  0001 C CNN
F 3 "" H 6600 4600 50  0001 C CNN
	1    6600 4600
	1    0    0    -1  
$EndComp
$Comp
L _Local:Socket1 J?
U 1 1 5ED4D420
P 6900 4600
F 0 "J?" H 6958 4646 50  0001 L CNN
F 1 "Socket1" H 6958 4555 50  0001 L CNN
F 2 "" H 6900 4600 50  0001 C CNN
F 3 "" H 6900 4600 50  0001 C CNN
	1    6900 4600
	1    0    0    -1  
$EndComp
Connection ~ 6700 2000
Wire Wire Line
	6700 2000 6700 2200
$Comp
L Device:C_Small C12
U 1 1 5ED55534
P 6600 2200
F 0 "C12" V 6600 1700 50  0000 C CNN
F 1 "1.0uF" V 6600 1950 50  0000 C CNN
F 2 "" H 6600 2200 50  0001 C CNN
F 3 "~" H 6600 2200 50  0001 C CNN
	1    6600 2200
	0    1    1    0   
$EndComp
Connection ~ 6700 2200
Wire Wire Line
	6700 2200 6700 2400
Connection ~ 6500 2200
Wire Wire Line
	6500 2200 6500 2400
Connection ~ 6500 3900
Wire Wire Line
	6500 3900 6500 3700
$Comp
L Device:C_Small C15
U 1 1 5ED579CE
P 6600 3700
F 0 "C15" V 6600 3200 50  0000 C CNN
F 1 "1.0uF" V 6600 3450 50  0000 C CNN
F 2 "" H 6600 3700 50  0001 C CNN
F 3 "~" H 6600 3700 50  0001 C CNN
	1    6600 3700
	0    1    1    0   
$EndComp
Wire Wire Line
	6700 4000 6700 3900
Connection ~ 6700 3900
Wire Wire Line
	9750 3400 9750 3500
Wire Wire Line
	9750 3500 9250 3500
Wire Wire Line
	6400 5000 7400 5000
Wire Wire Line
	7400 5000 7400 5100
Wire Wire Line
	9300 4800 9300 4750
Wire Wire Line
	9300 4750 9400 4750
Wire Wire Line
	8950 4800 9300 4800
Wire Wire Line
	9300 5000 9300 5050
Wire Wire Line
	9300 5050 9400 5050
Text Notes 2450 4400 0    50   ~ 0
Power:
Text Notes 8850 3200 0    50   ~ 0
Output Disable:
Text Notes 8850 4650 0    50   ~ 0
Output:  Iout, Floating Load\n
Text Notes 9000 4800 0    50   ~ 0
Out
Text Notes 9000 5000 0    50   ~ 0
Low
Text Notes 2450 4700 0    50   ~ 0
+V
Text Notes 2450 5100 0    50   ~ 0
-V
Text Notes 2450 4500 0    50   ~ 0
V = 9.0 V dc nom (5.0 V to 12 V)
$Comp
L Device:C_Small C1
U 1 1 5EE3CC5B
P 8100 3600
F 0 "C1" H 8200 3650 50  0000 L CNN
F 1 "0.0 uF" H 8200 3550 50  0000 L CNN
F 2 "" H 8100 3600 50  0001 C CNN
F 3 "~" H 8100 3600 50  0001 C CNN
	1    8100 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	7400 5400 7400 5600
Wire Wire Line
	6700 3700 6700 3900
Wire Wire Line
	6850 3350 6850 4000
Wire Wire Line
	6850 4000 8700 4000
Wire Wire Line
	9250 4000 9400 4000
Wire Wire Line
	9400 4000 9400 3900
Wire Wire Line
	9400 3900 9500 3900
Wire Wire Line
	9250 4100 9400 4100
Wire Wire Line
	9400 4100 9400 4200
Wire Wire Line
	9400 4200 9500 4200
Text Notes 6850 2600 0    50   ~ 0
Power op-amp\non heatsink
Text Notes 8850 3850 0    50   ~ 0
Current Limit
Text Notes 5300 6350 0    50   ~ 0
Future:\n    TVS Diode on output\n    RC snubber on output\n    Offset trim
Connection ~ 7200 3000
Connection ~ 7400 5000
$Comp
L Device:Q_NMOS_SGD Q1
U 1 1 639D8B60
P 8200 2600
F 0 "Q1" H 8100 2850 50  0000 L CNN
F 1 "VN0106" H 7950 2750 50  0000 L CNN
F 2 "" H 8400 2700 50  0001 C CNN
F 3 "~" H 8200 2600 50  0001 C CNN
	1    8200 2600
	1    0    0    -1  
$EndComp
$Comp
L Device:LED_ALT D1
U 1 1 639D95CC
P 9600 2750
F 0 "D1" V 9638 2632 50  0000 R CNN
F 1 "Red LED" V 9547 2632 50  0000 R CNN
F 2 "" H 9600 2750 50  0001 C CNN
F 3 "~" H 9600 2750 50  0001 C CNN
	1    9600 2750
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_US R6
U 1 1 639DE1C9
P 8600 2250
F 0 "R6" H 8532 2204 50  0000 R CNN
F 1 "470R 0.5W, 10% Carbon" H 8532 2295 50  0000 R CNN
F 2 "" V 8640 2240 50  0001 C CNN
F 3 "~" H 8600 2250 50  0001 C CNN
	1    8600 2250
	-1   0    0    1   
$EndComp
Wire Wire Line
	8300 2400 8600 2400
Wire Wire Line
	8600 2800 8700 2800
Wire Wire Line
	8600 2400 8600 2700
Wire Wire Line
	8600 2700 8700 2700
Connection ~ 8600 2400
Wire Wire Line
	8300 2800 8600 2800
Connection ~ 8600 2800
$Comp
L _Local:VNN #PWR?
U 1 1 639FC9D3
P 8600 4300
F 0 "#PWR?" H 8600 4050 50  0001 C CNN
F 1 "VNN" H 8617 4127 50  0000 C CNN
F 2 "" H 8600 4300 50  0001 C CNN
F 3 "" H 8600 4300 50  0001 C CNN
	1    8600 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	8000 2600 8000 3400
Connection ~ 8000 3400
Wire Wire Line
	8000 3400 8100 3400
Wire Wire Line
	6950 3350 6950 3400
Wire Wire Line
	8600 2000 8600 2100
Wire Wire Line
	9250 2700 9450 2700
Wire Wire Line
	9450 2700 9450 2600
Wire Wire Line
	9450 2600 9600 2600
Wire Wire Line
	9250 2800 9450 2800
Wire Wire Line
	9450 2800 9450 2900
Wire Wire Line
	9450 2900 9600 2900
Wire Wire Line
	5900 3100 5900 4600
Wire Wire Line
	7200 3000 7200 4600
Wire Wire Line
	6100 5000 5900 5000
Wire Wire Line
	5900 5000 5900 4600
Connection ~ 5900 4600
$Comp
L Switch:SW_SPST SW2
U 1 1 63A6854A
P 9500 5500
F 0 "SW2" H 9400 5600 50  0000 C CNN
F 1 "SW_SPST" H 9500 5644 50  0001 C CNN
F 2 "" H 9500 5500 50  0001 C CNN
F 3 "" H 9500 5500 50  0001 C CNN
	1    9500 5500
	1    0    0    -1  
$EndComp
Text Notes 9800 5550 0    50   ~ 0
N.O.= Enabled
Wire Wire Line
	9700 5500 9700 5700
Text Notes 9800 5450 0    50   ~ 0
Output Shunt:
Text Notes 7500 5550 0    50   ~ 0
Current Sense\nResistor
Text Notes 8700 2100 0    50   ~ 0
Iled = (VNN - 1.7 V) / R6
Text Notes 2600 7100 0    50   ~ 0
Ilim = 15000 * (4.75 V) / (13750 ohm + Rlim)\n\n
Text Notes 9550 5050 0    50   ~ 0
4 ohm, 40 uH  Speaker
$Comp
L Amplifier_Operational:LM358 U2
U 1 1 63AA4F68
P 4300 2900
F 0 "U2" H 4500 3100 50  0000 C CNN
F 1 "TL052" H 4550 3200 50  0000 C CNN
F 2 "" H 4300 2900 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/lm2904-n.pdf" H 4300 2900 50  0001 C CNN
	1    4300 2900
	1    0    0    1   
$EndComp
$Comp
L Amplifier_Operational:LM358 U2
U 2 1 63AA50DF
P 4300 1400
F 0 "U2" H 4450 1600 50  0000 C CNN
F 1 "TL052" H 4500 1700 50  0000 C CNN
F 2 "" H 4300 1400 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/lm2904-n.pdf" H 4300 1400 50  0001 C CNN
	2    4300 1400
	1    0    0    1   
$EndComp
$Comp
L Amplifier_Operational:LM358 U?
U 3 1 63AA5216
P 4300 2900
F 0 "U?" H 4258 2946 50  0001 L CNN
F 1 "LM358" H 4258 2855 50  0001 L CNN
F 2 "" H 4300 2900 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/lm2904-n.pdf" H 4300 2900 50  0001 C CNN
	3    4300 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 2800 3900 2800
Wire Wire Line
	3900 2800 3900 2550
Wire Wire Line
	3900 2550 4700 2550
Wire Wire Line
	4700 2550 4700 2900
Wire Wire Line
	4700 2900 4600 2900
$Comp
L Device:R_US R2
U 1 1 63AABED9
P 3650 3000
F 0 "R2" V 3445 3000 50  0000 C CNN
F 1 "20k" V 3536 3000 50  0000 C CNN
F 2 "" V 3690 2990 50  0001 C CNN
F 3 "~" H 3650 3000 50  0001 C CNN
	1    3650 3000
	0    1    1    0   
$EndComp
$Comp
L Device:R_US R1
U 1 1 63AAC02D
P 3400 3250
F 0 "R1" H 3332 3204 50  0000 R CNN
F 1 "10k" H 3332 3295 50  0000 R CNN
F 2 "" V 3440 3240 50  0001 C CNN
F 3 "~" H 3400 3250 50  0001 C CNN
	1    3400 3250
	-1   0    0    1   
$EndComp
$Comp
L Device:R_US Rp3
U 1 1 63AAC13C
P 4950 2900
F 0 "Rp3" V 4745 2900 50  0000 C CNN
F 1 "10k 1%" V 4836 2900 50  0000 C CNN
F 2 "" V 4990 2890 50  0001 C CNN
F 3 "~" H 4950 2900 50  0001 C CNN
	1    4950 2900
	0    1    1    0   
$EndComp
$Comp
L Device:C_Small Cp3
U 1 1 63AAC386
P 5200 3200
F 0 "Cp3" H 5300 3250 50  0000 L CNN
F 1 "12nF COG" H 5300 3150 50  0000 L CNN
F 2 "" H 5200 3200 50  0001 C CNN
F 3 "~" H 5200 3200 50  0001 C CNN
	1    5200 3200
	1    0    0    -1  
$EndComp
$Comp
L _Local:GND #PWR?
U 1 1 63AAC48B
P 3400 3500
F 0 "#PWR?" H 3400 3250 50  0001 C CNN
F 1 "GND" H 3400 3327 50  0000 C CNN
F 2 "" H 3300 3150 50  0001 C CNN
F 3 "" H 3400 3250 50  0001 C CNN
	1    3400 3500
	1    0    0    -1  
$EndComp
$Comp
L _Local:GND #PWR?
U 1 1 63AAC552
P 5200 3500
F 0 "#PWR?" H 5200 3250 50  0001 C CNN
F 1 "GND" H 5200 3327 50  0000 C CNN
F 2 "" H 5100 3150 50  0001 C CNN
F 3 "" H 5200 3250 50  0001 C CNN
	1    5200 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	2900 3000 3400 3000
Wire Wire Line
	3400 3000 3400 3100
Connection ~ 3400 3000
Wire Wire Line
	3400 3000 3500 3000
Wire Wire Line
	3800 3000 4000 3000
Wire Wire Line
	4700 2900 4800 2900
Connection ~ 4700 2900
Wire Wire Line
	5100 2900 5200 2900
Wire Wire Line
	5200 2900 5200 3100
Connection ~ 5200 2900
$Comp
L _Local:Socket1 J?
U 1 1 63AC17B4
P 5200 3350
F 0 "J?" H 5258 3396 50  0001 L CNN
F 1 "Socket1" H 5258 3305 50  0001 L CNN
F 2 "" H 5200 3350 50  0001 C CNN
F 3 "" H 5200 3350 50  0001 C CNN
	1    5200 3350
	1    0    0    -1  
$EndComp
$Comp
L _Local:Socket1 J?
U 1 1 63AC77A2
P 5200 3050
F 0 "J?" H 5258 3096 50  0001 L CNN
F 1 "Socket1" H 5258 3005 50  0001 L CNN
F 2 "" H 5200 3050 50  0001 C CNN
F 3 "" H 5200 3050 50  0001 C CNN
	1    5200 3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	4600 1400 4700 1400
Wire Wire Line
	4700 1400 4700 1050
Wire Wire Line
	4700 1050 3900 1050
Wire Wire Line
	3900 1050 3900 1300
Wire Wire Line
	3900 1300 4000 1300
Wire Wire Line
	4000 1500 3900 1500
$Comp
L Device:C_Small C21
U 1 1 63AE6DFF
P 4100 2300
F 0 "C21" V 4000 2050 50  0000 C CNN
F 1 "0.1uF" V 4100 2050 50  0000 C CNN
F 2 "" H 4100 2300 50  0001 C CNN
F 3 "~" H 4100 2300 50  0001 C CNN
	1    4100 2300
	0    1    1    0   
$EndComp
$Comp
L Device:C_Small C22
U 1 1 63AE6F26
P 4100 3400
F 0 "C22" V 4000 3150 50  0000 C CNN
F 1 "0.1uF" V 4100 3150 50  0000 C CNN
F 2 "" H 4100 3400 50  0001 C CNN
F 3 "~" H 4100 3400 50  0001 C CNN
	1    4100 3400
	0    1    1    0   
$EndComp
Wire Wire Line
	4200 2600 4200 2300
Connection ~ 4200 2300
Wire Wire Line
	4200 2300 4200 2100
Wire Wire Line
	4200 3600 4200 3400
Connection ~ 4200 3400
Wire Wire Line
	4200 3400 4200 3200
$Comp
L _Local:VPP #PWR?
U 1 1 63AEE6B3
P 4200 2100
F 0 "#PWR?" H 4200 2350 50  0001 C CNN
F 1 "VPP" H 4217 2273 50  0000 C CNN
F 2 "" H 4200 2100 50  0001 C CNN
F 3 "" H 4200 2100 50  0001 C CNN
	1    4200 2100
	1    0    0    -1  
$EndComp
$Comp
L _Local:VNN #PWR?
U 1 1 63AEE74E
P 4200 3600
F 0 "#PWR?" H 4200 3350 50  0001 C CNN
F 1 "VNN" H 4217 3427 50  0000 C CNN
F 2 "" H 4200 3600 50  0001 C CNN
F 3 "" H 4200 3600 50  0001 C CNN
	1    4200 3600
	1    0    0    -1  
$EndComp
$Comp
L _Local:GND #PWR?
U 1 1 63AEE7E9
P 4000 3400
F 0 "#PWR?" H 4000 3150 50  0001 C CNN
F 1 "GND" H 4000 3227 50  0000 C CNN
F 2 "" H 3900 3050 50  0001 C CNN
F 3 "" H 4000 3150 50  0001 C CNN
	1    4000 3400
	1    0    0    -1  
$EndComp
$Comp
L _Local:GND #PWR?
U 1 1 63AEE914
P 4000 2300
F 0 "#PWR?" H 4000 2050 50  0001 C CNN
F 1 "GND" H 4000 2127 50  0000 C CNN
F 2 "" H 3900 1950 50  0001 C CNN
F 3 "" H 4000 2050 50  0001 C CNN
	1    4000 2300
	1    0    0    -1  
$EndComp
Wire Wire Line
	3400 3400 3400 3500
Wire Wire Line
	5200 3300 5200 3500
$Comp
L _Local:Header_M1x02 J4
U 1 1 63B2F73E
P 8900 4000
F 0 "J4" H 8850 3800 50  0000 L CNN
F 1 "Header_M1x02" H 8850 3700 50  0001 L CNN
F 2 "" H 8900 4000 50  0001 C CNN
F 3 "" H 8900 4000 50  0001 C CNN
	1    8900 4000
	1    0    0    -1  
$EndComp
$Comp
L _Local:Header_F1x02 J4
U 1 1 63B60E33
P 9050 4000
F 0 "J4" H 9050 3800 50  0000 C CNN
F 1 "Header_F1x02" H 8970 4126 50  0001 C CNN
F 2 "" H 9050 4000 50  0001 C CNN
F 3 "" H 9050 4000 50  0001 C CNN
	1    9050 4000
	-1   0    0    -1  
$EndComp
$Comp
L _Local:Header_M1x02 J5
U 1 1 63B81B5D
P 8900 3400
F 0 "J5" H 8850 3200 50  0000 L CNN
F 1 "Header_M1x02" H 8850 3100 50  0001 L CNN
F 2 "" H 8900 3400 50  0001 C CNN
F 3 "" H 8900 3400 50  0001 C CNN
	1    8900 3400
	1    0    0    -1  
$EndComp
Wire Wire Line
	8600 2800 8600 3500
$Comp
L _Local:Header_F1x02 J5
U 1 1 63B899E6
P 9050 3400
F 0 "J5" H 9050 3200 50  0000 C CNN
F 1 "Header_F1x02" H 8970 3526 50  0001 C CNN
F 2 "" H 9050 3400 50  0001 C CNN
F 3 "" H 9050 3400 50  0001 C CNN
	1    9050 3400
	-1   0    0    -1  
$EndComp
Wire Wire Line
	9250 3400 9350 3400
Wire Wire Line
	8600 3500 8700 3500
Connection ~ 8600 3500
Wire Wire Line
	8600 3500 8600 3800
Wire Wire Line
	8600 4100 8700 4100
Connection ~ 8600 4100
Wire Wire Line
	8600 4100 8600 4300
$Comp
L _Local:Header_M1x02 J6
U 1 1 63BB1B9A
P 8900 2700
F 0 "J6" H 8850 2500 50  0000 L CNN
F 1 "Header_M1x02" H 8850 2400 50  0001 L CNN
F 2 "" H 8900 2700 50  0001 C CNN
F 3 "" H 8900 2700 50  0001 C CNN
	1    8900 2700
	1    0    0    -1  
$EndComp
$Comp
L _Local:Header_F1x02 J6
U 1 1 63BBDF5B
P 9050 2700
F 0 "J6" H 9050 2500 50  0000 C CNN
F 1 "Header_F1x02" H 8970 2826 50  0001 C CNN
F 2 "" H 9050 2700 50  0001 C CNN
F 3 "" H 9050 2700 50  0001 C CNN
	1    9050 2700
	-1   0    0    -1  
$EndComp
Wire Wire Line
	8950 4800 9200 4900
Wire Wire Line
	9200 4900 9200 5500
Wire Wire Line
	7400 5000 8700 5000
Wire Wire Line
	9000 5700 9700 5700
Wire Wire Line
	9200 5500 9300 5500
$Comp
L _Local:Screw_TermB_01x03 J2
U 1 1 63C6313B
P 2700 4700
F 0 "J2" H 2650 4100 50  0000 L CNN
F 1 "Screw_TermB_01x03" H 2779 4451 50  0001 L CNN
F 2 "" H 2700 4500 50  0001 C CNN
F 3 "" H 2700 4500 50  0001 C CNN
	1    2700 4700
	-1   0    0    -1  
$EndComp
$Comp
L _Local:Screw_TermB_01x02 J3
U 1 1 63C6329C
P 8900 4800
F 0 "J3" H 8850 4450 50  0000 L CNN
F 1 "Screw_TermB_01x02" H 8979 4701 50  0001 L CNN
F 2 "" H 8900 4800 50  0001 C CNN
F 3 "" H 8900 4800 50  0001 C CNN
	1    8900 4800
	1    0    0    -1  
$EndComp
Text Label 2900 4700 0    50   ~ 0
VPP
Text Label 2900 5100 0    50   ~ 0
VNN
Wire Wire Line
	2900 4900 3300 4900
Wire Wire Line
	3300 4900 3300 5100
Text Label 2900 4900 0    50   ~ 0
GND
$Comp
L _Local:GND #PWR?
U 1 1 63C6BF8A
P 3300 5100
F 0 "#PWR?" H 3300 4850 50  0001 C CNN
F 1 "GND" H 3300 4927 50  0000 C CNN
F 2 "" H 3200 4750 50  0001 C CNN
F 3 "" H 3300 4850 50  0001 C CNN
	1    3300 5100
	1    0    0    -1  
$EndComp
Wire Wire Line
	8950 5000 9300 5000
Wire Wire Line
	8950 5000 9000 5050
Wire Wire Line
	9000 5050 9000 5700
Text Notes 2350 4900 0    50   ~ 0
Comm
Text Notes 2650 2850 0    50   ~ 0
Input:
Wire Wire Line
	5200 2900 6500 2900
$Comp
L _Local:Header_M1x02 J1
U 1 1 63CA61E0
P 2700 3000
F 0 "J1" H 2650 2800 50  0000 L CNN
F 1 "Header_M1x02" H 2650 2700 50  0001 L CNN
F 2 "" H 2700 3000 50  0001 C CNN
F 3 "" H 2700 3000 50  0001 C CNN
	1    2700 3000
	-1   0    0    -1  
$EndComp
Wire Wire Line
	2900 3100 3000 3100
Wire Wire Line
	3000 3100 3000 3500
$Comp
L _Local:GND #PWR?
U 1 1 63CB24DC
P 3000 3500
F 0 "#PWR?" H 3000 3250 50  0001 C CNN
F 1 "GND" H 3000 3327 50  0000 C CNN
F 2 "" H 2900 3150 50  0001 C CNN
F 3 "" H 3000 3250 50  0001 C CNN
	1    3000 3500
	1    0    0    -1  
$EndComp
$Comp
L _Local:GND #PWR?
U 1 1 63CE9A3A
P 3900 1500
F 0 "#PWR?" H 3900 1250 50  0001 C CNN
F 1 "GND" H 3900 1327 50  0000 C CNN
F 2 "" H 3800 1150 50  0001 C CNN
F 3 "" H 3900 1250 50  0001 C CNN
	1    3900 1500
	1    0    0    -1  
$EndComp
Text Notes 8850 2550 0    50   ~ 0
Shutdown Indicator
Text Notes 4100 950  0    50   ~ 0
Unused op-amp
Text Notes 3050 2600 0    50   ~ 0
Input Protection
Text Notes 4900 2550 0    50   ~ 0
Lowpass Filter
Text Notes 9850 4200 0    50   ~ 0
Rlim    Ilim\n129k    0.5 A\n57.6k   1.0 A\n20.0k   2.1 A\n14.7k   2.5 A
Text Notes 5500 5150 0    50   ~ 0
Stability Compensation:  Cf4, Rf4, Rf5
Text Notes 2600 6900 0    50   ~ 0
Rlim = (15000 * (4.75 V) / Ilim) - (13750 ohm)
Text Notes 2400 6800 0    50   ~ 0
Current Limit:
Text Notes 2400 7300 0    50   ~ 0
Lowpass Filter:  
Text Notes 2600 7400 0    50   ~ 0
F0 = 1/(2*Pi * Rp3 * Cp3)
Text Notes 5100 2650 0    50   ~ 0
F0 = 1.3 kHz
Text Notes 2400 5800 0    50   ~ 0
Input:  Vin
Text Notes 2600 6000 0    50   ~ 0
Vi = 0 to +-1.0 V,  1 kHz max\nAbsolute max 5 V
Text Notes 2400 6300 0    50   ~ 0
Output:  Iout
Text Notes 2600 6500 0    50   ~ 0
Floating Load, 5.0 V compliance\nIout = 1.0 mA/mV * Vin
Text Notes 2450 3050 0    50   ~ 0
Vin
Text Label 3000 3000 0    50   ~ 0
Vin
Wire Wire Line
	6950 3400 8000 3400
Wire Wire Line
	8100 3500 8100 3400
Connection ~ 8100 3400
Wire Wire Line
	8100 3400 8700 3400
Wire Wire Line
	8100 3800 8600 3800
Wire Wire Line
	8100 3700 8100 3800
Connection ~ 8600 3800
Wire Wire Line
	8600 3800 8600 4100
Text Notes 8200 3750 0    50   ~ 0
no load
$Comp
L _Local:GND #PWR?
U 1 1 63CDC7E0
P 8300 2000
F 0 "#PWR?" H 8300 1750 50  0001 C CNN
F 1 "GND" H 8300 1827 50  0000 C CNN
F 2 "" H 8200 1650 50  0001 C CNN
F 3 "" H 8300 1750 50  0001 C CNN
	1    8300 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	8600 2000 8300 2000
Text Notes 9800 2900 0    50   ~ 0
5 mm, 20 mA
Text Notes 6300 6700 0    70   ~ 0
Current Buffer:  1 mA/mV, 1.0 A Full Scale, 1.3 kHz lowpass filter
Text Notes 2400 7600 0    50   ~ 0
Resistors:  1/4 W, 5% Carbon
Text Notes 8650 2700 0    50   ~ 0
A
Text Notes 8650 2800 0    50   ~ 0
C
$Comp
L Device:D_Schottky_Small_ALT D2
U 1 1 64440762
P 7600 4400
F 0 "D2" V 7554 4468 50  0000 L CNN
F 1 "SB240" V 7645 4468 50  0000 L CNN
F 2 "" V 7600 4400 50  0001 C CNN
F 3 "~" V 7600 4400 50  0001 C CNN
	1    7600 4400
	0    1    1    0   
$EndComp
$Comp
L Device:D_Schottky_Small_ALT D3
U 1 1 6444404A
P 7600 4600
F 0 "D3" V 7554 4668 50  0000 L CNN
F 1 "SB240" V 7645 4668 50  0000 L CNN
F 2 "" V 7600 4600 50  0001 C CNN
F 3 "~" V 7600 4600 50  0001 C CNN
	1    7600 4600
	0    1    1    0   
$EndComp
Wire Wire Line
	7600 4500 8200 4500
Wire Wire Line
	8200 4500 8200 4800
Wire Wire Line
	8200 4800 8700 4800
Connection ~ 7600 4500
$Comp
L _Local:VNN #PWR?
U 1 1 6445544B
P 7600 4700
F 0 "#PWR?" H 7600 4450 50  0001 C CNN
F 1 "VNN" H 7617 4527 50  0000 C CNN
F 2 "" H 7600 4700 50  0001 C CNN
F 3 "" H 7600 4700 50  0001 C CNN
	1    7600 4700
	1    0    0    -1  
$EndComp
$Comp
L _Local:VPP #PWR?
U 1 1 644554D4
P 7600 4300
F 0 "#PWR?" H 7600 4550 50  0001 C CNN
F 1 "VPP" H 7617 4473 50  0000 C CNN
F 2 "" H 7600 4300 50  0001 C CNN
F 3 "" H 7600 4300 50  0001 C CNN
	1    7600 4300
	1    0    0    -1  
$EndComp
Text Notes 7800 4300 0    50   ~ 0
Output back EMF\nprotection
Wire Wire Line
	7400 4500 7600 4500
Text Notes 8600 4800 0    50   ~ 0
Ho
Text Notes 8600 5000 0    50   ~ 0
Lo
$EndSCHEMATC
