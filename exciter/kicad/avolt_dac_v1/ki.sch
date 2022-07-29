EESchema Schematic File Version 4
LIBS:ki-cache
EELAYER 26 0
EELAYER END
$Descr B 17000 11000
encoding utf-8
Sheet 1 1
Title "avolt_dac_v1/  Voltage DAC"
Date "2022-07-28"
Rev "v1.1"
Comp "William A. Hudson"
Comment1 "v1.1 - Tighten up RPi connections, VDD"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L _Local:MCP4822 U1
U 1 1 622985EB
P 8800 6450
F 0 "U1" H 8300 6950 50  0000 C CNN
F 1 "MCP4822" H 8400 6850 50  0000 C CNN
F 2 "" H 9600 6150 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/20002249B.pdf" H 9600 6150 50  0001 C CNN
	1    8800 6450
	1    0    0    -1  
$EndComp
$Comp
L _Local:VPP #PWR?
U 1 1 622986A6
P 12500 5900
F 0 "#PWR?" H 12500 6150 50  0001 C CNN
F 1 "VPP" H 12450 6050 50  0000 C CNN
F 2 "" H 12500 5900 50  0001 C CNN
F 3 "" H 12500 5900 50  0001 C CNN
	1    12500 5900
	1    0    0    -1  
$EndComp
$Comp
L _Local:VNN #PWR?
U 1 1 622986D2
P 12500 6500
F 0 "#PWR?" H 12500 6250 50  0001 C CNN
F 1 "VNN" H 12450 6350 50  0000 C CNN
F 2 "" H 12500 6500 50  0001 C CNN
F 3 "" H 12500 6500 50  0001 C CNN
	1    12500 6500
	1    0    0    -1  
$EndComp
$Comp
L Amplifier_Operational:TL072 U2
U 2 1 622987DE
P 10600 5800
F 0 "U2" H 10800 5950 50  0000 C CNN
F 1 "TL052" H 10850 6050 50  0000 C CNN
F 2 "" H 10600 5800 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/tl071.pdf" H 10600 5800 50  0001 C CNN
	2    10600 5800
	1    0    0    1   
$EndComp
$Comp
L Amplifier_Operational:TL072 U2
U 1 1 622988D1
P 12600 6200
F 0 "U2" H 12900 6300 50  0000 C CNN
F 1 "TL052" H 12950 6400 50  0000 C CNN
F 2 "" H 12600 6200 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/tl071.pdf" H 12600 6200 50  0001 C CNN
	1    12600 6200
	1    0    0    1   
$EndComp
$Comp
L Amplifier_Operational:TL072 U2
U 3 1 62298921
P 12600 6200
F 0 "U2" H 12558 6246 50  0001 L CNN
F 1 "TL052" H 12558 6155 50  0001 L CNN
F 2 "" H 12600 6200 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/tl071.pdf" H 12600 6200 50  0001 C CNN
	3    12600 6200
	1    0    0    -1  
$EndComp
$Comp
L Device:R_US Rfa
U 1 1 62299043
P 10550 5400
F 0 "Rfa" V 10345 5400 50  0000 C CNN
F 1 "10k" V 10436 5400 50  0000 C CNN
F 2 "" V 10590 5390 50  0001 C CNN
F 3 "~" H 10550 5400 50  0001 C CNN
	1    10550 5400
	0    1    1    0   
$EndComp
$Comp
L Device:C_Small Cfa
U 1 1 6229913B
P 10500 5100
F 0 "Cfa" V 10271 5100 50  0000 C CNN
F 1 "12nF COG" V 10362 5100 50  0000 C CNN
F 2 "" H 10500 5100 50  0001 C CNN
F 3 "~" H 10500 5100 50  0001 C CNN
	1    10500 5100
	0    1    1    0   
$EndComp
Wire Wire Line
	9300 6300 9600 6300
Wire Wire Line
	9600 6300 9600 5700
Wire Wire Line
	9600 5700 9800 5700
$Comp
L Device:R_US R1a
U 1 1 62299243
P 9950 5700
F 0 "R1a" V 9745 5700 50  0000 C CNN
F 1 "10k" V 9836 5700 50  0000 C CNN
F 2 "" V 9990 5690 50  0001 C CNN
F 3 "~" H 9950 5700 50  0001 C CNN
	1    9950 5700
	0    1    1    0   
$EndComp
Wire Wire Line
	10100 5700 10200 5700
Wire Wire Line
	10200 5700 10200 5400
Wire Wire Line
	10200 5100 10400 5100
Connection ~ 10200 5700
Wire Wire Line
	10200 5700 10300 5700
Wire Wire Line
	10400 5400 10200 5400
Connection ~ 10200 5400
Wire Wire Line
	10200 5400 10200 5100
Wire Wire Line
	10700 5400 11100 5400
Wire Wire Line
	11100 5400 11100 5800
Wire Wire Line
	11100 5800 10900 5800
Wire Wire Line
	11100 5800 11600 5800
Connection ~ 11100 5800
Wire Wire Line
	10600 5100 11100 5100
Wire Wire Line
	11100 5100 11100 5400
Connection ~ 11100 5400
Text GLabel 13550 6200 2    50   Input ~ 0
Voa
$Comp
L _Local:GND #PWR?
U 1 1 62299916
P 8800 7100
F 0 "#PWR?" H 8800 6850 50  0001 C CNN
F 1 "GND" H 8800 6927 50  0000 C CNN
F 2 "" H 8700 6750 50  0001 C CNN
F 3 "" H 8800 6850 50  0001 C CNN
	1    8800 7100
	1    0    0    -1  
$EndComp
$Comp
L Device:R_US R2a
U 1 1 62393258
P 11600 6050
F 0 "R2a" H 11668 6096 50  0000 L CNN
F 1 "30 kohm" H 11668 6005 50  0000 L CNN
F 2 "" V 11640 6040 50  0001 C CNN
F 3 "~" H 11600 6050 50  0001 C CNN
	1    11600 6050
	1    0    0    -1  
$EndComp
$Comp
L Device:R_US R3a
U 1 1 62393332
P 11600 6550
F 0 "R3a" H 11668 6596 50  0000 L CNN
F 1 "10 kohm" H 11668 6505 50  0000 L CNN
F 2 "" V 11640 6540 50  0001 C CNN
F 3 "~" H 11600 6550 50  0001 C CNN
	1    11600 6550
	1    0    0    -1  
$EndComp
$Comp
L _Local:GND #PWR?
U 1 1 62393411
P 11600 6800
F 0 "#PWR?" H 11600 6550 50  0001 C CNN
F 1 "GND" H 11600 6627 50  0000 C CNN
F 2 "" H 11500 6450 50  0001 C CNN
F 3 "" H 11600 6550 50  0001 C CNN
	1    11600 6800
	1    0    0    -1  
$EndComp
Wire Wire Line
	11600 5800 11600 5900
Wire Wire Line
	11600 6200 11600 6300
Wire Wire Line
	11600 6700 11600 6800
Wire Wire Line
	12200 6100 12200 5600
Wire Wire Line
	12200 5600 13000 5600
Wire Wire Line
	13000 5600 13000 6200
Wire Wire Line
	13000 6200 12900 6200
Wire Wire Line
	12200 6100 12300 6100
Wire Wire Line
	11600 6300 12300 6300
Connection ~ 11600 6300
Wire Wire Line
	11600 6300 11600 6400
Wire Wire Line
	13000 6200 13550 6200
Connection ~ 13000 6200
Text GLabel 7400 6300 0    50   Input ~ 0
SCK
Text GLabel 7400 6400 0    50   Input ~ 0
MOSI
Text GLabel 7400 6500 0    50   Input ~ 0
CS0n
Wire Wire Line
	7400 6300 7700 6300
Wire Wire Line
	7400 6400 7800 6400
Wire Wire Line
	7400 6500 7950 6500
Wire Wire Line
	8300 6600 8100 6600
Text Label 9600 5700 0    50   ~ 0
Vda
Text Label 11600 5800 0    50   ~ 0
Vfa
$Comp
L _Local:74x74 U10
U 1 1 6239541E
P 8550 4000
F 0 "U10" H 8550 4467 50  0000 C CNN
F 1 "74AHC74" H 8550 4376 50  0000 C CNN
F 2 "" H 8550 3900 50  0001 C CNN
F 3 "74xx/74hc_hct74.pdf" H 8550 3900 50  0001 C CNN
	1    8550 4000
	1    0    0    -1  
$EndComp
$Comp
L _Local:74x74 U10
U 2 1 62395533
P 9750 4000
F 0 "U10" H 9750 4467 50  0000 C CNN
F 1 "74AHC74" H 9750 4376 50  0000 C CNN
F 2 "" H 9750 3900 50  0001 C CNN
F 3 "74xx/74hc_hct74.pdf" H 9750 3900 50  0001 C CNN
	2    9750 4000
	1    0    0    -1  
$EndComp
$Comp
L _Local:74x74 U10
U 3 1 623955AF
P 12500 3900
F 0 "U10" H 12730 3946 50  0000 L CNN
F 1 "74AHC74" H 12730 3855 50  0000 L CNN
F 2 "" H 12500 3800 50  0001 C CNN
F 3 "74xx/74hc_hct74.pdf" H 12500 3800 50  0001 C CNN
	3    12500 3900
	1    0    0    -1  
$EndComp
Wire Wire Line
	7950 6500 7950 4700
Wire Wire Line
	7950 4700 9300 4700
Wire Wire Line
	9300 4700 9300 4100
Wire Wire Line
	9300 4100 9400 4100
Connection ~ 7950 6500
Wire Wire Line
	8200 4200 7800 4200
Wire Wire Line
	7800 4200 7800 6400
Connection ~ 7800 6400
Wire Wire Line
	7800 6400 8300 6400
Wire Wire Line
	8200 4100 7700 4100
Wire Wire Line
	7700 4100 7700 6300
Connection ~ 7700 6300
Wire Wire Line
	7700 6300 8300 6300
Wire Wire Line
	8900 4200 9400 4200
Text GLabel 10600 4200 2    50   Input ~ 0
GATE
Wire Wire Line
	10100 4200 10600 4200
$Comp
L Device:C_Small C2
U 1 1 6239C259
P 12600 5900
F 0 "C2" V 12800 5850 50  0000 C CNN
F 1 "0.1uF" V 12700 5750 50  0000 C CNN
F 2 "" H 12600 5900 50  0001 C CNN
F 3 "~" H 12600 5900 50  0001 C CNN
	1    12600 5900
	0    -1   -1   0   
$EndComp
Connection ~ 12500 5900
$Comp
L Device:C_Small C3
U 1 1 6239D0FE
P 12600 6500
F 0 "C3" V 12450 6450 50  0000 C CNN
F 1 "0.1uF" V 12350 6350 50  0000 C CNN
F 2 "" H 12600 6500 50  0001 C CNN
F 3 "~" H 12600 6500 50  0001 C CNN
	1    12600 6500
	0    -1   -1   0   
$EndComp
Connection ~ 12500 6500
$Comp
L _Local:GND #PWR?
U 1 1 6239D208
P 12800 6500
F 0 "#PWR?" H 12800 6250 50  0001 C CNN
F 1 "GND" H 12900 6400 50  0000 C CNN
F 2 "" H 12700 6150 50  0001 C CNN
F 3 "" H 12800 6250 50  0001 C CNN
	1    12800 6500
	1    0    0    -1  
$EndComp
$Comp
L _Local:GND #PWR?
U 1 1 6239D249
P 12800 5900
F 0 "#PWR?" H 12800 5650 50  0001 C CNN
F 1 "GND" H 12900 5800 50  0000 C CNN
F 2 "" H 12700 5550 50  0001 C CNN
F 3 "" H 12800 5650 50  0001 C CNN
	1    12800 5900
	1    0    0    -1  
$EndComp
Wire Wire Line
	12700 5900 12800 5900
Wire Wire Line
	12700 6500 12800 6500
Text Label 11650 6300 0    50   ~ 0
Vra
$Comp
L power:VDD #PWR?
U 1 1 6239EF62
P 8800 6050
F 0 "#PWR?" H 8800 5900 50  0001 C CNN
F 1 "VDD" H 8817 6223 50  0000 C CNN
F 2 "" H 8800 6050 50  0001 C CNN
F 3 "" H 8800 6050 50  0001 C CNN
	1    8800 6050
	1    0    0    -1  
$EndComp
$Comp
L power:VDD #PWR?
U 1 1 6239EFE0
P 12500 3400
F 0 "#PWR?" H 12500 3250 50  0001 C CNN
F 1 "VDD" H 12517 3573 50  0000 C CNN
F 2 "" H 12500 3400 50  0001 C CNN
F 3 "" H 12500 3400 50  0001 C CNN
	1    12500 3400
	1    0    0    -1  
$EndComp
$Comp
L _Local:GND #PWR?
U 1 1 6239F033
P 12500 4400
F 0 "#PWR?" H 12500 4150 50  0001 C CNN
F 1 "GND" H 12500 4227 50  0000 C CNN
F 2 "" H 12400 4050 50  0001 C CNN
F 3 "" H 12500 4150 50  0001 C CNN
	1    12500 4400
	1    0    0    -1  
$EndComp
$Comp
L Device:C C5
U 1 1 6239F0BC
P 13150 3900
F 0 "C5" H 13265 3946 50  0000 L CNN
F 1 "0.1uF" H 13265 3855 50  0000 L CNN
F 2 "" H 13188 3750 50  0001 C CNN
F 3 "~" H 13150 3900 50  0001 C CNN
	1    13150 3900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C1
U 1 1 6239F22A
P 9400 6950
F 0 "C1" H 9515 6996 50  0000 L CNN
F 1 "0.1uF" H 9515 6905 50  0000 L CNN
F 2 "" H 9438 6800 50  0001 C CNN
F 3 "~" H 9400 6950 50  0001 C CNN
	1    9400 6950
	1    0    0    -1  
$EndComp
Wire Wire Line
	8800 6000 9400 6000
Wire Wire Line
	9400 6000 9400 6800
Wire Wire Line
	8800 6850 8800 7100
Wire Wire Line
	9400 7100 8800 7100
Connection ~ 8800 7100
Wire Wire Line
	12500 3400 13150 3400
Wire Wire Line
	13150 3400 13150 3750
Wire Wire Line
	12500 4400 13150 4400
Wire Wire Line
	13150 4400 13150 4050
Connection ~ 12500 4400
Connection ~ 12500 3400
Text Notes 11300 7200 0    50   ~ 0
Voltage Divider:  1/4\nVra = (1/(1 + R2a/R3a)) * Vfa
Text Notes 10850 4850 0    50   ~ 0
Low Pass Filter\nF0 = 1/(2*Pi*Rfa*Cfa) = 1.3 kHz
Text Notes 12250 5500 0    50   ~ 0
Buffer, unity gain
Wire Wire Line
	8200 3600 8200 3800
Wire Wire Line
	8200 3800 8200 3900
Connection ~ 8200 3800
Wire Wire Line
	9400 3600 9400 3800
Wire Wire Line
	9400 3800 9400 3900
Connection ~ 9400 3800
Text Notes 7200 7600 0    50   ~ 0
    Power:\nVDD = +3.3 V   Digital Logic
Text Notes 7200 7850 0    50   ~ 0
VPP = +6 V to +12 V   Analog\nVNN = -6 V to -12 V   Analog
Wire Wire Line
	10300 5900 10200 5900
$Comp
L _Breadboard:74x74 U10
U 1 1 623B53BA
P 3700 4200
F 0 "U10" H 3700 4200 50  0000 C CNN
F 1 "74AHC74" H 3700 4100 50  0000 C CNN
F 2 "" H 3700 3500 50  0001 C CNN
F 3 "" H 3700 3500 50  0001 C CNN
	1    3700 4200
	1    0    0    -1  
$EndComp
Wire Wire Line
	2000 600  2000 3400
$Comp
L _Breadboard:MCP4802 U1
U 1 1 623BA2FE
P 3700 5800
F 0 "U1" H 3700 5800 50  0000 C CNN
F 1 "MCP4822" H 3700 5700 50  0000 C CNN
F 2 "" H 3700 5800 50  0001 C CNN
F 3 "" H 3700 5800 50  0001 C CNN
	1    3700 5800
	1    0    0    -1  
$EndComp
$Comp
L _Breadboard:OpAmp_Dual U2
U 1 1 6239779E
P 3700 7000
F 0 "U2" H 3700 7000 50  0000 C CNN
F 1 "TL052" H 3750 6900 50  0000 C CNN
F 2 "" H 3700 7000 50  0001 C CNN
F 3 "" H 3700 7000 50  0001 C CNN
	1    3700 7000
	1    0    0    -1  
$EndComp
$Comp
L _Breadboard:Pin P?
U 1 1 62397915
P 3000 600
F 0 "P?" H 3053 646 50  0000 L CNN
F 1 "Pin" H 3053 555 50  0000 L CNN
F 2 "" H 3000 600 50  0001 C CNN
F 3 "" H 3000 600 50  0001 C CNN
	1    3000 600 
	1    0    0    -1  
$EndComp
$Comp
L _Breadboard:Pin P?
U 1 1 62397A6B
P 2600 600
F 0 "P?" H 2653 646 50  0000 L CNN
F 1 "Pin" H 2653 555 50  0000 L CNN
F 2 "" H 2600 600 50  0001 C CNN
F 3 "" H 2600 600 50  0001 C CNN
	1    2600 600 
	1    0    0    -1  
$EndComp
$Comp
L _Breadboard:Pin P?
U 1 1 6239A34C
P 4800 600
F 0 "P?" H 4853 646 50  0000 L CNN
F 1 "Pin" H 4853 555 50  0000 L CNN
F 2 "" H 4800 600 50  0001 C CNN
F 3 "" H 4800 600 50  0001 C CNN
	1    4800 600 
	1    0    0    -1  
$EndComp
Wire Wire Line
	2600 5600 2000 5600
Connection ~ 2000 5600
Wire Wire Line
	2000 5600 2000 6800
$Comp
L _Breadboard:R4_4_1 R1a
U 1 1 623ADF14
P 4300 7000
F 0 "R1a" H 4250 7200 50  0000 L CNN
F 1 "10k" H 4250 7100 50  0000 L CNN
F 2 "" H 4300 7000 50  0001 C CNN
F 3 "" H 4300 7000 50  0001 C CNN
	1    4300 7000
	1    0    0    -1  
$EndComp
$Comp
L _Breadboard:R4_4_1 Rfa
U 1 1 623AE238
P 4300 7800
F 0 "Rfa" H 4474 7846 50  0000 L CNN
F 1 "10 kohm" H 4474 7755 50  0000 L CNN
F 2 "" H 4300 7800 50  0001 C CNN
F 3 "" H 4300 7800 50  0001 C CNN
	1    4300 7800
	1    0    0    -1  
$EndComp
Wire Wire Line
	4600 7200 4400 8200
$Comp
L _Breadboard:C1_1_0 Cfa
U 1 1 623B0382
P 4800 7300
F 0 "Cfa" H 4878 7346 50  0000 L CNN
F 1 "12nF COG" H 4878 7255 50  0000 L CNN
F 2 "" H 4800 7300 50  0001 C CNN
F 3 "" H 4800 7300 50  0001 C CNN
	1    4800 7300
	1    0    0    -1  
$EndComp
$Comp
L _Breadboard:R4_4_1 R2a
U 1 1 623B40E9
P 3600 8100
F 0 "R2a" V 3550 7850 50  0000 L CNN
F 1 "30 kohm" V 3600 8050 50  0000 L CNN
F 2 "" H 3600 8100 50  0001 C CNN
F 3 "" H 3600 8100 50  0001 C CNN
	1    3600 8100
	0    1    1    0   
$EndComp
Wire Wire Line
	4800 5800 4600 6600
Text GLabel 2600 6200 0    50   Input ~ 0
SCK
Text GLabel 2600 6400 0    50   Input ~ 0
MOSI
Text GLabel 2600 6000 0    50   Input ~ 0
CS0n
Text GLabel 2600 7600 0    50   Input ~ 0
VNN
Wire Wire Line
	2800 6200 2600 4600
Wire Wire Line
	3000 6400 2800 4400
Wire Wire Line
	3200 5000 4200 4600
Wire Wire Line
	3000 6000 4400 4800
Wire Wire Line
	3200 4800 3000 4200
Wire Wire Line
	2600 4200 1700 4200
Connection ~ 1700 4200
Text GLabel 3400 9800 2    50   Input ~ 0
Colow
Text GLabel 3400 9600 2    50   Input ~ 0
Cohi
Text GLabel 3400 9200 2    50   Input ~ 0
Cip
Text GLabel 3400 9000 2    50   Input ~ 0
Cignd
Wire Wire Line
	2600 8600 2000 8600
Connection ~ 2000 8600
Wire Wire Line
	2000 8600 2000 9000
Wire Wire Line
	3400 6800 4000 6800
Wire Wire Line
	2600 6800 2000 6800
Connection ~ 2000 6800
Wire Wire Line
	2000 6800 2000 8600
$Comp
L Device:C_Small C4
U 1 1 623F5195
P 10200 7850
F 0 "C4" H 10300 7900 50  0000 L CNN
F 1 "0.1uF" H 10292 7805 50  0000 L CNN
F 2 "" H 10200 7850 50  0001 C CNN
F 3 "~" H 10200 7850 50  0001 C CNN
	1    10200 7850
	-1   0    0    -1  
$EndComp
Wire Wire Line
	10400 7750 10400 8100
Wire Wire Line
	10400 8100 10300 8100
Wire Wire Line
	10200 7950 10200 8100
$Comp
L _Local:GND #PWR?
U 1 1 62407D28
P 10300 8100
F 0 "#PWR?" H 10300 7850 50  0001 C CNN
F 1 "GND" H 10300 7927 50  0000 C CNN
F 2 "" H 10200 7750 50  0001 C CNN
F 3 "" H 10300 7850 50  0001 C CNN
	1    10300 8100
	1    0    0    -1  
$EndComp
Connection ~ 10300 8100
Wire Wire Line
	10300 8100 10200 8100
Text Label 10400 7100 2    50   ~ 0
VDD
Wire Wire Line
	10400 7450 10400 7100
Text Notes 10700 7100 2    50   ~ 0
(3.3 V)
$Comp
L _Breadboard:RtrimPot RV4
U 1 1 624154A2
P 3400 8500
F 0 "RV4" V 3350 8900 50  0000 R CNN
F 1 "5 kohm" V 3450 8950 50  0000 R CNN
F 2 "" H 3400 8550 50  0001 C CNN
F 3 "" H 3400 8550 50  0001 C CNN
	1    3400 8500
	0    1    1    0   
$EndComp
Wire Wire Line
	3200 8400 3300 8200
Wire Wire Line
	3300 8200 4200 7600
Wire Wire Line
	2600 9000 2000 9000
Connection ~ 2000 9000
Wire Wire Line
	2000 9000 2000 10300
Text Label 2000 600  0    50   ~ 0
GND
Text Label 5400 600  0    50   ~ 0
GND
Text Label 5700 600  0    50   ~ 0
VDD
Text Label 1700 600  0    50   ~ 0
VDD
Text Label 8200 3600 0    50   ~ 0
VDD
Text Label 9400 3600 0    50   ~ 0
VDD
Text Notes 8150 4700 0    50   ~ 0
CSn rising latches Gate
Text Notes 8150 4400 0    50   ~ 0
FF holds last MOSI bit
Text Notes 10950 4250 0    50   ~ 0
To LED gate
Text Notes 10250 6300 0    50   ~ 0
Offset by 1/2 Full Scale
Text Notes 8150 5800 0    50   ~ 0
12-bit DAC:  0.0 V to 2.048 V
Text Label 10200 6600 0    50   ~ 0
Vref
Text Notes 11450 5700 0    50   ~ 0
Vfa= +-1.024 V
Text Notes 13350 6100 0    50   ~ 0
Voa= +-256.0 mV
$Comp
L _Breadboard:C1_1_0 C2
U 1 1 62495B95
P 4600 6900
F 0 "C2" H 4678 6946 50  0000 L CNN
F 1 "0.1uF" H 4678 6855 50  0000 L CNN
F 2 "" H 4600 6900 50  0001 C CNN
F 3 "" H 4600 6900 50  0001 C CNN
	1    4600 6900
	1    0    0    -1  
$EndComp
Wire Wire Line
	3200 7600 3000 6600
$Comp
L _Breadboard:C1_1_0 C3
U 1 1 62498B84
P 3200 6700
F 0 "C3" H 3278 6746 50  0000 L CNN
F 1 "0.1uF" H 3278 6655 50  0000 L CNN
F 2 "" H 3200 6700 50  0001 C CNN
F 3 "" H 3200 6700 50  0001 C CNN
	1    3200 6700
	1    0    0    -1  
$EndComp
Text Notes 10400 6600 0    50   ~ 0
0.512 V
$Comp
L Device:R_POT_US RV4
U 1 1 6249F1DC
P 10400 7600
F 0 "RV4" H 10332 7646 50  0000 R CNN
F 1 "5 kohm" H 10332 7555 50  0000 R CNN
F 2 "" H 10400 7600 50  0001 C CNN
F 3 "~" H 10400 7600 50  0001 C CNN
	1    10400 7600
	-1   0    0    -1  
$EndComp
Wire Wire Line
	10200 5900 10200 7600
Wire Wire Line
	10250 7600 10200 7600
Connection ~ 10200 7600
Wire Wire Line
	10200 7600 10200 7750
Wire Wire Line
	4400 6800 4200 7800
$Comp
L _Breadboard:C1_1_0 C4
U 1 1 624B70EB
P 4800 7700
F 0 "C4" H 4878 7746 50  0000 L CNN
F 1 "0.1uF" H 4878 7655 50  0000 L CNN
F 2 "" H 4800 7700 50  0001 C CNN
F 3 "" H 4800 7700 50  0001 C CNN
	1    4800 7700
	1    0    0    -1  
$EndComp
Text Notes 10850 5050 0    50   ~ 0
DC:  Vfa = 2*Vref - Vda\n     Vfa = (1 + (Rfa/R1a))*Vref - (Rfa/R1a)*Vda
Text Notes 10550 7900 0    50   ~ 0
Vref - Offset Adjust
$Comp
L _Breadboard:R4_4_0 R3a
U 1 1 624C02E3
P 2400 8000
F 0 "R3a" V 2400 8200 50  0000 C CNN
F 1 "10 kohm" V 2400 7900 50  0000 C CNN
F 2 "" H 2400 8000 50  0001 C CNN
F 3 "" H 2400 8000 50  0001 C CNN
	1    2400 8000
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2800 9200 2600 7000
Wire Wire Line
	3200 7000 3200 7200
Wire Wire Line
	3400 5600 4000 5600
Wire Wire Line
	4400 6000 4400 5600
$Comp
L _Breadboard:C1_1_0 C1
U 1 1 624DFE3A
P 3000 5700
F 0 "C1" H 3078 5746 50  0000 L CNN
F 1 "0.1uF" H 3078 5655 50  0000 L CNN
F 2 "" H 3000 5700 50  0001 C CNN
F 3 "" H 3000 5700 50  0001 C CNN
	1    3000 5700
	1    0    0    -1  
$EndComp
Wire Wire Line
	2600 5400 2000 5400
Connection ~ 2000 5400
Wire Wire Line
	2000 5400 2000 5600
$Comp
L _Breadboard:C3_3_0 C5
U 1 1 624E6C27
P 3700 3900
F 0 "C5" V 3915 3900 50  0000 C CNN
F 1 "C3_3_0" V 3824 3900 50  0000 C CNN
F 2 "" H 3700 3900 50  0001 C CNN
F 3 "" H 3700 3900 50  0001 C CNN
	1    3700 3900
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4000 3900 4200 4200
Wire Wire Line
	4400 8600 4300 8800
Wire Wire Line
	4300 8800 3400 8800
Wire Wire Line
	3000 8000 2800 7400
Wire Wire Line
	5400 600  5400 3400
Wire Wire Line
	2000 3400 5400 3400
Connection ~ 2000 3400
Wire Wire Line
	2000 3400 2000 5200
Connection ~ 5400 3400
Wire Wire Line
	5400 3400 5400 10300
Text GLabel 1700 5600 0    50   Input ~ 0
VDD
Text Notes 700  6350 0    50   ~ 0
Gpio20  spi1_MOSI  p38  violet
Text Notes 700  6150 0    50   ~ 0
Gpio21  spi1_SCLK  p40  white
Text Notes 700  5950 0    50   ~ 0
Gpio16  spi1_CE2_n  p36  green
Text Notes 700  5650 0    50   ~ 0
+3.3 V  p17  yellow
Text Notes 5850 7050 0    50   ~ 0
VPP  +12 V
Text Notes 1100 7650 0    50   ~ 0
VNN  -12 V
Text Notes 850  9250 0    50   ~ 0
Analog GND thru \ncurrent buffer Cignd
Text Notes 12300 9200 0    70   ~ 0
12-bit DAC, 1 Digital out, 1.3 kHz LP Filter, Full Scale +-256 mV
Text GLabel 4850 5200 2    50   Input ~ 0
GATE
Text Notes 850  5800 0    50   ~ 0
GND  p34  brown
Text GLabel 2000 5800 0    50   Input ~ 0
GND
Wire Wire Line
	4600 6400 4800 4800
Wire Wire Line
	7950 6500 8300 6500
$Comp
L _Local:GND #PWR?
U 1 1 625484C7
P 8100 6700
F 0 "#PWR?" H 8100 6450 50  0001 C CNN
F 1 "GND" H 8100 6527 50  0000 C CNN
F 2 "" H 8000 6350 50  0001 C CNN
F 3 "" H 8100 6450 50  0001 C CNN
	1    8100 6700
	1    0    0    -1  
$EndComp
Wire Wire Line
	8100 6600 8100 6700
Text Notes 7600 7000 0    50   ~ 0
DAC update on CSn rising
Wire Wire Line
	4200 6000 4400 6400
Text Notes 3800 9150 0    50   ~ 0
Current Buffer - input
Text Notes 3800 9750 0    50   ~ 0
Current Buffer - output
Wire Notes Line
	3400 8900 3400 9900
Wire Notes Line
	3400 9900 5000 9900
Wire Notes Line
	5000 9900 5000 8900
Wire Notes Line
	5000 8900 3400 8900
Wire Wire Line
	3200 5400 2900 4000
Wire Wire Line
	2900 4000 3400 3900
Wire Wire Line
	4600 5000 4800 4200
Wire Wire Line
	4600 4400 4600 4200
Wire Wire Line
	4400 4200 4300 4000
Wire Wire Line
	4300 4000 3200 4000
Wire Wire Line
	3200 4000 2800 4200
Wire Wire Line
	2600 8800 1700 8800
Connection ~ 1700 8800
Wire Wire Line
	1700 8800 1700 10300
Text GLabel 2000 6200 0    50   Input ~ 0
GND
Text Notes 850  6250 0    50   ~ 0
GND  p39  black
Text GLabel 4800 7000 2    50   Input ~ 0
VPP
Text GLabel 2000 6400 0    50   Input ~ 0
GND
Text Notes 850  6450 0    50   ~ 0
GND  p34  blue
Wire Wire Line
	1700 4200 1700 5200
Wire Wire Line
	2600 5800 1700 6000
Connection ~ 1700 6000
Wire Wire Line
	1700 6000 1700 8800
Text Notes 500  5450 0    50   ~ 0
RPi Connections:
Wire Wire Line
	1700 600  1700 4200
Wire Wire Line
	5700 600  5700 10300
$Comp
L _Breadboard:C1_1_0 C6
U 1 1 62E754B5
P 1900 5200
F 0 "C6" V 1685 5200 50  0000 C CNN
F 1 "0.1uF" V 1776 5200 50  0000 C CNN
F 2 "" H 1900 5200 50  0001 C CNN
F 3 "" H 1900 5200 50  0001 C CNN
	1    1900 5200
	0    1    1    0   
$EndComp
Connection ~ 2000 5200
Wire Wire Line
	2000 5200 2000 5400
Wire Wire Line
	1800 5200 1700 5200
Connection ~ 1700 5200
Wire Wire Line
	1700 5200 1700 6000
$EndSCHEMATC
