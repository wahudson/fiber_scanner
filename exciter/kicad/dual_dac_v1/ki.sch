EESchema Schematic File Version 4
LIBS:ki-cache
EELAYER 26 0
EELAYER END
$Descr B 17000 11000
encoding utf-8
Sheet 1 1
Title "dual_dac_v1/   2-Channel Voltage DAC"
Date "2023-01-02"
Rev "v1.0"
Comp "William A. Hudson"
Comment1 ""
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
L Amplifier_Operational:TL072 U2
U 1 1 622987DE
P 11400 5800
F 0 "U2" H 11600 5950 50  0000 C CNN
F 1 "TL052" H 11650 6050 50  0000 C CNN
F 2 "" H 11400 5800 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/tl071.pdf" H 11400 5800 50  0001 C CNN
	1    11400 5800
	1    0    0    1   
$EndComp
$Comp
L Device:R_US Rfa
U 1 1 62299043
P 11350 5400
F 0 "Rfa" V 11250 5300 50  0000 C CNN
F 1 "10k" V 11250 5500 50  0000 C CNN
F 2 "" V 11390 5390 50  0001 C CNN
F 3 "~" H 11350 5400 50  0001 C CNN
	1    11350 5400
	0    1    1    0   
$EndComp
$Comp
L Device:C_Small Cfa
U 1 1 6229913B
P 11300 5100
F 0 "Cfa" V 11071 5100 50  0000 C CNN
F 1 "12nF COG" V 11162 5100 50  0000 C CNN
F 2 "" H 11300 5100 50  0001 C CNN
F 3 "~" H 11300 5100 50  0001 C CNN
	1    11300 5100
	0    1    1    0   
$EndComp
Wire Wire Line
	9300 6300 9800 6300
Wire Wire Line
	9800 6300 9800 5700
$Comp
L Device:R_US R1a
U 1 1 62299243
P 10750 5700
F 0 "R1a" V 10545 5700 50  0000 C CNN
F 1 "10k" V 10636 5700 50  0000 C CNN
F 2 "" V 10790 5690 50  0001 C CNN
F 3 "~" H 10750 5700 50  0001 C CNN
	1    10750 5700
	0    1    1    0   
$EndComp
Wire Wire Line
	10900 5700 11000 5700
Wire Wire Line
	11000 5700 11000 5400
Wire Wire Line
	11000 5100 11200 5100
Connection ~ 11000 5700
Wire Wire Line
	11000 5700 11100 5700
Wire Wire Line
	11200 5400 11000 5400
Connection ~ 11000 5400
Wire Wire Line
	11000 5400 11000 5100
Wire Wire Line
	11500 5400 11900 5400
Wire Wire Line
	11900 5400 11900 5800
Wire Wire Line
	11900 5800 11700 5800
Wire Wire Line
	11400 5100 11900 5100
Wire Wire Line
	11900 5100 11900 5400
Connection ~ 11900 5400
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
Text GLabel 7400 6300 0    50   Input ~ 0
SCK
Text GLabel 7400 6400 0    50   Input ~ 0
MOSI
Text GLabel 7400 6500 0    50   Input ~ 0
CSn
Wire Wire Line
	7400 6300 7800 6300
Wire Wire Line
	7400 6400 7700 6400
Wire Wire Line
	7400 6500 7950 6500
Wire Wire Line
	8300 6600 8100 6600
Text Label 9400 6300 0    50   ~ 0
Vda
Wire Wire Line
	7950 6500 7950 3900
Connection ~ 7950 6500
Wire Wire Line
	7700 3300 7700 6400
Connection ~ 7700 6400
Wire Wire Line
	7700 6400 8300 6400
Wire Wire Line
	7800 3500 7800 6300
Connection ~ 7800 6300
Wire Wire Line
	7800 6300 8300 6300
$Comp
L power:VDD #PWR?
U 1 1 6239EF62
P 8800 5550
F 0 "#PWR?" H 8800 5400 50  0001 C CNN
F 1 "VDD" H 8817 5723 50  0000 C CNN
F 2 "" H 8800 5550 50  0001 C CNN
F 3 "" H 8800 5550 50  0001 C CNN
	1    8800 5550
	1    0    0    -1  
$EndComp
Wire Wire Line
	8800 6850 8800 7100
Text Notes 11650 4800 0    50   ~ 0
Low Pass Filter\n    F0 = 1/(2*Pi*Rfa*Cfa) = 1.3 kHz
Text Notes 7200 7600 0    50   ~ 0
VDD = +3.3 V   Digital Logic
Text Notes 7200 7850 0    50   ~ 0
VPP = +6 V to +12 V   Analog\nVNN = -6 V to -12 V   Analog
$Comp
L _Breadboard:MCP4802 U1
U 1 1 623BA2FE
P 3700 6400
F 0 "U1" H 3700 6400 50  0000 C CNN
F 1 "MCP4822" H 3700 6300 50  0000 C CNN
F 2 "" H 3700 6400 50  0001 C CNN
F 3 "" H 3700 6400 50  0001 C CNN
	1    3700 6400
	-1   0    0    1   
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
	2600 5800 2000 5800
Connection ~ 2000 5800
$Comp
L _Breadboard:R4_4_1 R1b
U 1 1 623ADF14
P 4300 7000
F 0 "R1b" H 4200 6950 50  0000 L CNN
F 1 "10k" H 4200 6850 50  0000 L CNN
F 2 "" H 4300 7000 50  0001 C CNN
F 3 "" H 4300 7000 50  0001 C CNN
	1    4300 7000
	1    0    0    -1  
$EndComp
$Comp
L _Breadboard:R4_4_1 Rfb
U 1 1 623AE238
P 4300 7800
F 0 "Rfb" H 4250 7900 50  0000 L CNN
F 1 "10k" H 4250 7800 50  0000 L CNN
F 2 "" H 4300 7800 50  0001 C CNN
F 3 "" H 4300 7800 50  0001 C CNN
	1    4300 7800
	1    0    0    -1  
$EndComp
Wire Wire Line
	4600 7200 4400 8200
$Comp
L _Breadboard:C1_1_0 Cfb
U 1 1 623B0382
P 4800 7300
F 0 "Cfb" H 4878 7346 50  0000 L CNN
F 1 "12nF COG" H 4878 7255 50  0000 L CNN
F 2 "" H 4800 7300 50  0001 C CNN
F 3 "" H 4800 7300 50  0001 C CNN
	1    4800 7300
	1    0    0    -1  
$EndComp
Text GLabel 4800 6000 2    50   Input ~ 0
SCK
Text GLabel 4800 5800 2    50   Input ~ 0
MOSI
Text GLabel 4800 6200 2    50   Input ~ 0
CSn
Text GLabel 2600 7600 0    50   Input ~ 0
VNN
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
L Device:C_Small C5
U 1 1 623F5195
P 9800 8650
F 0 "C5" H 9900 8700 50  0000 L CNN
F 1 "0.1uF" H 9892 8605 50  0000 L CNN
F 2 "" H 9800 8650 50  0001 C CNN
F 3 "~" H 9800 8650 50  0001 C CNN
	1    9800 8650
	1    0    0    -1  
$EndComp
Wire Wire Line
	9600 8550 9600 8900
Wire Wire Line
	9600 8900 9700 8900
Wire Wire Line
	9800 8750 9800 8900
$Comp
L _Local:GND #PWR?
U 1 1 62407D28
P 9700 8900
F 0 "#PWR?" H 9700 8650 50  0001 C CNN
F 1 "GND" H 9700 8727 50  0000 C CNN
F 2 "" H 9600 8550 50  0001 C CNN
F 3 "" H 9700 8650 50  0001 C CNN
	1    9700 8900
	-1   0    0    -1  
$EndComp
Connection ~ 9700 8900
Wire Wire Line
	9700 8900 9800 8900
Wire Wire Line
	9600 8250 9600 7900
Text Notes 9750 7800 0    50   ~ 0
(3.3 V)
$Comp
L _Breadboard:RtrimPot RV5
U 1 1 624154A2
P 3400 8500
F 0 "RV5" V 3350 8900 50  0000 R CNN
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
Text Notes 11500 8550 2    50   ~ 0
Offset by 1/2 Full Scale
Text Notes 8100 5300 0    50   ~ 0
12-bit DAC:  0.0 V to 2.048 V
Text Label 10550 8400 0    50   ~ 0
Vref
$Comp
L _Breadboard:C1_1_0 C3
U 1 1 62495B95
P 4200 6900
F 0 "C3" H 4050 7150 50  0000 L CNN
F 1 "0.1uF" H 4050 7050 50  0000 L CNN
F 2 "" H 4200 6900 50  0001 C CNN
F 3 "" H 4200 6900 50  0001 C CNN
	1    4200 6900
	1    0    0    -1  
$EndComp
Wire Wire Line
	3200 7600 3000 6600
$Comp
L _Breadboard:C1_1_0 C4
U 1 1 62498B84
P 3200 6700
F 0 "C4" H 3278 6746 50  0000 L CNN
F 1 "0.1uF" H 3278 6655 50  0000 L CNN
F 2 "" H 3200 6700 50  0001 C CNN
F 3 "" H 3200 6700 50  0001 C CNN
	1    3200 6700
	1    0    0    -1  
$EndComp
Text Notes 11100 8400 2    50   ~ 0
0.512 V
$Comp
L Device:R_POT_US Rv5
U 1 1 6249F1DC
P 9600 8400
F 0 "Rv5" H 9532 8446 50  0000 R CNN
F 1 "5 kohm" H 9532 8355 50  0000 R CNN
F 2 "" H 9600 8400 50  0001 C CNN
F 3 "~" H 9600 8400 50  0001 C CNN
	1    9600 8400
	1    0    0    -1  
$EndComp
Wire Wire Line
	9750 8400 9800 8400
Wire Wire Line
	9800 8400 9800 8550
Wire Wire Line
	4400 6800 4200 7800
$Comp
L _Breadboard:C1_1_0 C5
U 1 1 624B70EB
P 4600 7700
F 0 "C5" H 4678 7746 50  0000 L CNN
F 1 "0.1uF" H 4678 7655 50  0000 L CNN
F 2 "" H 4600 7700 50  0001 C CNN
F 3 "" H 4600 7700 50  0001 C CNN
	1    4600 7700
	1    0    0    -1  
$EndComp
Text Notes 11650 5000 0    50   ~ 0
DC:  Voa = 2*Vref - Vda\n     Voa = (1 + (Rfa/R1a))*Vref - (Rfa/R1a)*Vda
Text Notes 9450 8700 2    50   ~ 0
Vref - Offset Adjust
Wire Wire Line
	3000 9200 2800 8000
Wire Wire Line
	3400 5400 4000 5400
$Comp
L _Breadboard:C1_1_0 C1
U 1 1 624DFE3A
P 3200 5500
F 0 "C1" H 3278 5546 50  0000 L CNN
F 1 "0.1uF" H 3278 5455 50  0000 L CNN
F 2 "" H 3200 5500 50  0001 C CNN
F 3 "" H 3200 5500 50  0001 C CNN
	1    3200 5500
	1    0    0    -1  
$EndComp
$Comp
L _Breadboard:C3_3_0 C5
U 1 1 624E6C27
P 6200 4100
F 0 "C5" V 6415 4100 50  0000 C CNN
F 1 "C3_3_0" V 6324 4100 50  0000 C CNN
F 2 "" H 6200 4100 50  0001 C CNN
F 3 "" H 6200 4100 50  0001 C CNN
	1    6200 4100
	0    -1   -1   0   
$EndComp
Wire Wire Line
	3000 8400 2800 7400
Text GLabel 5700 5200 2    50   Input ~ 0
VDD
Text Notes 5750 5750 0    50   ~ 0
Gpio20  spi1_MOSI  p38  violet
Text Notes 5750 5950 0    50   ~ 0
Gpio21  spi1_SCLK  p40  white
Text Notes 5750 6200 0    50   ~ 0
Gpio16  spi1_CE2_n  p36  green
Text Notes 6000 5200 0    50   ~ 0
+3.3 V  p17  yellow
Text Notes 5800 7050 0    50   ~ 0
VPP  +12 V
Text Notes 1150 7650 0    50   ~ 0
VNN  -12 V
Text Notes 850  9100 0    50   ~ 0
Analog GND thru \ncurrent buffer Cignd
Text Notes 12300 9200 0    70   ~ 0
Dual 12-bit DAC, 8 Digital out, 1.3 kHz LP Filter, Full Scale +-1.024 V
Text GLabel 4800 4000 2    50   Input ~ 0
GATE
Text Notes 6000 5050 0    50   ~ 0
GND  p20  brown
Text GLabel 5400 6000 2    50   Input ~ 0
GND
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
Text Notes 5850 6050 0    50   ~ 0
GND  p39  black
Text GLabel 4800 7000 2    50   Input ~ 0
VPP
Text Notes 5850 5850 0    50   ~ 0
GND  p34  blue
Text Notes 6350 4700 0    50   ~ 0
RPi Connections:
Wire Wire Line
	5700 600  5700 3800
$Comp
L _Breadboard:C1_1_0 C6
U 1 1 62E754B5
P 3700 3600
F 0 "C6" V 3485 3600 50  0000 C CNN
F 1 "0.1uF" V 3576 3600 50  0000 C CNN
F 2 "" H 3700 3600 50  0001 C CNN
F 3 "" H 3700 3600 50  0001 C CNN
	1    3700 3600
	0    1    1    0   
$EndComp
$Comp
L Amplifier_Operational:TL072 U2
U 2 1 62E6DF73
P 11400 7500
F 0 "U2" H 11600 7650 50  0000 C CNN
F 1 "TL052" H 11850 7650 50  0000 C CNN
F 2 "" H 11400 7500 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/tl071.pdf" H 11400 7500 50  0001 C CNN
	2    11400 7500
	1    0    0    1   
$EndComp
$Comp
L Device:R_US Rfb
U 1 1 62E6DF79
P 11350 6900
F 0 "Rfb" V 11250 6800 50  0000 C CNN
F 1 "10k" V 11250 7000 50  0000 C CNN
F 2 "" V 11390 6890 50  0001 C CNN
F 3 "~" H 11350 6900 50  0001 C CNN
	1    11350 6900
	0    1    1    0   
$EndComp
$Comp
L Device:C_Small Cfb
U 1 1 62E6DF7F
P 11300 6600
F 0 "Cfb" V 11071 6600 50  0000 C CNN
F 1 "12nF COG" V 11162 6600 50  0000 C CNN
F 2 "" H 11300 6600 50  0001 C CNN
F 3 "~" H 11300 6600 50  0001 C CNN
	1    11300 6600
	0    1    1    0   
$EndComp
$Comp
L Device:R_US R1b
U 1 1 62E6DF88
P 10750 7400
F 0 "R1b" V 10545 7400 50  0000 C CNN
F 1 "10k" V 10636 7400 50  0000 C CNN
F 2 "" V 10790 7390 50  0001 C CNN
F 3 "~" H 10750 7400 50  0001 C CNN
	1    10750 7400
	0    1    1    0   
$EndComp
Wire Wire Line
	10900 7400 11000 7400
Wire Wire Line
	11000 7400 11000 6900
Wire Wire Line
	11000 6600 11200 6600
Connection ~ 11000 7400
Wire Wire Line
	11000 7400 11100 7400
Wire Wire Line
	11200 6900 11000 6900
Connection ~ 11000 6900
Wire Wire Line
	11000 6900 11000 6600
Wire Wire Line
	11900 6900 11900 7500
Wire Wire Line
	11900 7500 11700 7500
Wire Wire Line
	11400 6600 11900 6600
Wire Wire Line
	11900 6600 11900 6900
Connection ~ 11900 6900
Text Label 9400 6600 0    50   ~ 0
Vdb
Wire Wire Line
	9300 6600 10100 6600
Wire Wire Line
	9800 5700 10600 5700
Wire Wire Line
	10550 5900 11100 5900
Text GLabel 12400 5800 2    50   Input ~ 0
Voa
Text GLabel 12400 7500 2    50   Input ~ 0
Vob
Wire Wire Line
	11900 5800 12400 5800
Connection ~ 11900 5800
Wire Wire Line
	11900 7500 12400 7500
Connection ~ 11900 7500
Wire Wire Line
	9800 8400 10550 8400
Wire Wire Line
	10550 5900 10550 7600
Connection ~ 9800 8400
Wire Wire Line
	10550 7600 11100 7600
Connection ~ 10550 7600
Wire Wire Line
	10550 7600 10550 8400
$Comp
L _Local:74x594 U3
U 1 1 62ED5748
P 8800 3700
F 0 "U3" H 8300 4550 50  0000 C CNN
F 1 "74HC594" H 8400 4450 50  0000 C CNN
F 2 "" H 8800 3600 50  0001 C CNN
F 3 "" H 8800 3600 50  0001 C CNN
	1    8800 3700
	1    0    0    -1  
$EndComp
Text Label 8150 3600 0    50   ~ 0
VDD
Text Label 8150 4000 0    50   ~ 0
VDD
Wire Wire Line
	8150 3600 8300 3600
Wire Wire Line
	8150 4000 8300 4000
Wire Wire Line
	7700 3300 8300 3300
Wire Wire Line
	7800 3500 8300 3500
Wire Wire Line
	7950 3900 8300 3900
$Comp
L _Local:GND #PWR?
U 1 1 62F13FCD
P 8800 4400
F 0 "#PWR?" H 8800 4150 50  0001 C CNN
F 1 "GND" H 8800 4227 50  0000 C CNN
F 2 "" H 8700 4050 50  0001 C CNN
F 3 "" H 8800 4150 50  0001 C CNN
	1    8800 4400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C6
U 1 1 62F14374
P 9100 2900
F 0 "C6" V 8871 2900 50  0000 C CNN
F 1 "0.1uF" V 8962 2900 50  0000 C CNN
F 2 "" H 9100 2900 50  0001 C CNN
F 3 "~" H 9100 2900 50  0001 C CNN
	1    9100 2900
	0    1    1    0   
$EndComp
$Comp
L _Local:GND #PWR?
U 1 1 62F145E4
P 9400 2900
F 0 "#PWR?" H 9400 2650 50  0001 C CNN
F 1 "GND" H 9400 2727 50  0000 C CNN
F 2 "" H 9300 2550 50  0001 C CNN
F 3 "" H 9400 2650 50  0001 C CNN
	1    9400 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	8800 2700 8800 2900
Wire Wire Line
	8800 2900 9000 2900
Connection ~ 8800 2900
Wire Wire Line
	8800 2900 8800 3000
Wire Wire Line
	9200 2900 9400 2900
Text GLabel 9600 3300 2    50   Input ~ 0
LEDgate
Text GLabel 9600 3400 2    50   Input ~ 0
Xmark
Text GLabel 9600 3500 2    50   Input ~ 0
Ymark
Wire Wire Line
	11500 6900 11900 6900
Wire Wire Line
	10100 7400 10600 7400
Wire Wire Line
	10100 6600 10100 7400
$Comp
L Amplifier_Operational:TL072 U?
U 3 1 63B62C58
P 11400 7500
F 0 "U?" H 11358 7546 50  0001 L CNN
F 1 "TL052" H 11358 7455 50  0001 L CNN
F 2 "" H 11400 7500 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/tl071.pdf" H 11400 7500 50  0001 C CNN
	3    11400 7500
	1    0    0    -1  
$EndComp
$Comp
L _Local:VPP #PWR?
U 1 1 63B62E0C
P 11300 7200
F 0 "#PWR?" H 11300 7450 50  0001 C CNN
F 1 "VPP" H 11250 7350 50  0000 C CNN
F 2 "" H 11300 7200 50  0001 C CNN
F 3 "" H 11300 7200 50  0001 C CNN
	1    11300 7200
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C3
U 1 1 63B62E19
P 11400 7200
F 0 "C3" V 11450 7100 50  0000 C CNN
F 1 "0.1uF" V 11450 6900 50  0000 C CNN
F 2 "" H 11400 7200 50  0001 C CNN
F 3 "~" H 11400 7200 50  0001 C CNN
	1    11400 7200
	0    -1   -1   0   
$EndComp
$Comp
L _Local:GND #PWR?
U 1 1 63B62E20
P 11600 7200
F 0 "#PWR?" H 11600 6950 50  0001 C CNN
F 1 "GND" H 11700 7100 50  0000 C CNN
F 2 "" H 11500 6850 50  0001 C CNN
F 3 "" H 11600 6950 50  0001 C CNN
	1    11600 7200
	1    0    0    -1  
$EndComp
Wire Wire Line
	11500 7200 11600 7200
Connection ~ 11300 7200
$Comp
L _Local:VNN #PWR?
U 1 1 63B77BEB
P 11300 7900
F 0 "#PWR?" H 11300 7650 50  0001 C CNN
F 1 "VNN" H 11250 7750 50  0000 C CNN
F 2 "" H 11300 7900 50  0001 C CNN
F 3 "" H 11300 7900 50  0001 C CNN
	1    11300 7900
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C4
U 1 1 63B77BF7
P 11400 7900
F 0 "C4" V 11450 7800 50  0000 C CNN
F 1 "0.1uF" V 11450 7600 50  0000 C CNN
F 2 "" H 11400 7900 50  0001 C CNN
F 3 "~" H 11400 7900 50  0001 C CNN
	1    11400 7900
	0    -1   -1   0   
$EndComp
$Comp
L _Local:GND #PWR?
U 1 1 63B77BFE
P 11600 7900
F 0 "#PWR?" H 11600 7650 50  0001 C CNN
F 1 "GND" H 11700 7800 50  0000 C CNN
F 2 "" H 11500 7550 50  0001 C CNN
F 3 "" H 11600 7650 50  0001 C CNN
	1    11600 7900
	1    0    0    -1  
$EndComp
Wire Wire Line
	11500 7900 11600 7900
Wire Wire Line
	11300 7800 11300 7900
Connection ~ 11300 7900
$Comp
L Device:C_Small C1
U 1 1 63BB244D
P 8900 5800
F 0 "C1" V 8900 5550 50  0000 C CNN
F 1 "0.1uF" V 8900 5300 50  0000 C CNN
F 2 "" H 8900 5800 50  0001 C CNN
F 3 "~" H 8900 5800 50  0001 C CNN
	1    8900 5800
	0    -1   -1   0   
$EndComp
$Comp
L _Local:GND #PWR?
U 1 1 63BB2453
P 9000 5900
F 0 "#PWR?" H 9000 5650 50  0001 C CNN
F 1 "GND" H 9100 5800 50  0000 C CNN
F 2 "" H 8900 5550 50  0001 C CNN
F 3 "" H 9000 5650 50  0001 C CNN
	1    9000 5900
	1    0    0    -1  
$EndComp
$Comp
L power:VDD #PWR?
U 1 1 63BED57B
P 8800 2700
F 0 "#PWR?" H 8800 2550 50  0001 C CNN
F 1 "VDD" H 8817 2873 50  0000 C CNN
F 2 "" H 8800 2700 50  0001 C CNN
F 3 "" H 8800 2700 50  0001 C CNN
	1    8800 2700
	1    0    0    -1  
$EndComp
Text Notes 6950 2800 0    50   ~ 0
CSn (RLCK) rising latches data
Text Notes 6950 2700 0    50   ~ 0
Shift Register holds last 8 MOSI bits
Wire Wire Line
	9300 3300 9600 3300
Wire Wire Line
	9300 3400 9600 3400
Wire Wire Line
	9300 3500 9600 3500
Text Notes 12400 5650 0    50   ~ 0
Voa= +-1024 mV
Text Notes 12400 7350 0    50   ~ 0
Vob= +-1024 mV
$Comp
L Device:R_US R3a
U 1 1 63C2D06A
P 9800 5450
F 0 "R3a" H 9850 5500 50  0000 L CNN
F 1 "43k" H 9850 5400 50  0000 L CNN
F 2 "" V 9840 5440 50  0001 C CNN
F 3 "~" H 9800 5450 50  0001 C CNN
	1    9800 5450
	1    0    0    -1  
$EndComp
$Comp
L Device:R_US R3b
U 1 1 63C2D26A
P 10100 6350
F 0 "R3b" H 10150 6400 50  0000 L CNN
F 1 "43k" H 10150 6300 50  0000 L CNN
F 2 "" V 10140 6340 50  0001 C CNN
F 3 "~" H 10100 6350 50  0001 C CNN
	1    10100 6350
	1    0    0    -1  
$EndComp
$Comp
L power:VDD #PWR?
U 1 1 63C611A0
P 9800 5300
F 0 "#PWR?" H 9800 5150 50  0001 C CNN
F 1 "VDD" H 9817 5473 50  0000 C CNN
F 2 "" H 9800 5300 50  0001 C CNN
F 3 "" H 9800 5300 50  0001 C CNN
	1    9800 5300
	1    0    0    -1  
$EndComp
$Comp
L power:VDD #PWR?
U 1 1 63C61217
P 10100 6200
F 0 "#PWR?" H 10100 6050 50  0001 C CNN
F 1 "VDD" H 10117 6373 50  0000 C CNN
F 2 "" H 10100 6200 50  0001 C CNN
F 3 "" H 10100 6200 50  0001 C CNN
	1    10100 6200
	1    0    0    -1  
$EndComp
Wire Wire Line
	9800 5600 9800 5700
Connection ~ 9800 5700
Wire Wire Line
	10100 6500 10100 6600
Connection ~ 10100 6600
$Comp
L power:VDD #PWR?
U 1 1 63C6D46C
P 9600 7900
F 0 "#PWR?" H 9600 7750 50  0001 C CNN
F 1 "VDD" H 9617 8073 50  0000 C CNN
F 2 "" H 9600 7900 50  0001 C CNN
F 3 "" H 9600 7900 50  0001 C CNN
	1    9600 7900
	1    0    0    -1  
$EndComp
Text Notes 8950 5000 0    50   ~ 0
DAC Hi-Z:  voltage divider to Vdac=1.024 V\n             to make Vo=0.0 V
$Comp
L Device:CP1_Small C2
U 1 1 63C75467
P 8900 5600
F 0 "C2" V 8900 5350 50  0000 C CNN
F 1 "4.7uF Tant" V 8900 4800 50  0000 L CNN
F 2 "" H 8900 5600 50  0001 C CNN
F 3 "~" H 8900 5600 50  0001 C CNN
	1    8900 5600
	0    -1   1    0   
$EndComp
Wire Wire Line
	8800 5550 8800 5600
Connection ~ 8800 5600
Wire Wire Line
	8800 5600 8800 5800
Connection ~ 8800 5800
Wire Wire Line
	8800 5800 8800 6050
Wire Wire Line
	9000 5800 9000 5600
Wire Wire Line
	9000 5900 9000 5800
Connection ~ 9000 5800
Text Notes 7100 7450 0    50   ~ 0
Power:
$Comp
L _Breadboard:74x594 U3
U 1 1 63C95AF7
P 3700 3800
F 0 "U3" H 3700 3800 50  0000 C CNN
F 1 "74HC594" H 3700 3700 50  0000 C CNN
F 2 "" H 3700 3100 50  0001 C CNN
F 3 "" H 3700 3100 50  0001 C CNN
	1    3700 3800
	1    0    0    -1  
$EndComp
$Comp
L _Breadboard:R4_4_1 R1a
U 1 1 63CBF674
P 3100 6800
F 0 "R1a" H 3000 6750 50  0000 L CNN
F 1 "10k" H 3000 6650 50  0000 L CNN
F 2 "" H 3100 6800 50  0001 C CNN
F 3 "" H 3100 6800 50  0001 C CNN
	1    3100 6800
	-1   0    0    -1  
$EndComp
$Comp
L _Breadboard:R4_4_1 Rfa
U 1 1 63CC5A6C
P 3100 7600
F 0 "Rfa" H 3050 7600 50  0000 L CNN
F 1 "10k" H 3000 7500 50  0000 L CNN
F 2 "" H 3100 7600 50  0001 C CNN
F 3 "" H 3100 7600 50  0001 C CNN
	1    3100 7600
	-1   0    0    -1  
$EndComp
Wire Wire Line
	2800 7000 3000 8000
$Comp
L _Breadboard:C1_1_0 Cfa
U 1 1 63CCF077
P 2600 7100
F 0 "Cfa" H 2678 7146 50  0000 L CNN
F 1 "12nF COG" H 2678 7055 50  0000 L CNN
F 2 "" H 2600 7100 50  0001 C CNN
F 3 "" H 2600 7100 50  0001 C CNN
	1    2600 7100
	-1   0    0    -1  
$EndComp
Wire Wire Line
	4200 5800 4400 4200
Wire Wire Line
	4400 6000 4600 4800
Wire Wire Line
	4600 6200 4800 4600
$Comp
L _Breadboard:C1_1_0 C6
U 1 1 63D10DE0
P 6600 3750
F 0 "C6" H 6678 3796 50  0000 L CNN
F 1 "0.1uF" H 6678 3705 50  0000 L CNN
F 2 "" H 6600 3750 50  0001 C CNN
F 3 "" H 6600 3750 50  0001 C CNN
	1    6600 3750
	1    0    0    -1  
$EndComp
Text GLabel 5400 5800 2    50   Input ~ 0
GND
Wire Wire Line
	4800 6800 5400 6800
Connection ~ 5400 6800
Wire Wire Line
	5400 6800 5400 10300
Wire Wire Line
	1700 600  1700 5600
Wire Wire Line
	4800 8600 5700 8600
Connection ~ 5700 8600
Wire Wire Line
	5700 8600 5700 10300
$Comp
L _Breadboard:R4_4_1 R3a
U 1 1 63D2C463
P 800 6550
F 0 "R3a" H 750 6650 50  0000 L CNN
F 1 "43k" H 750 6550 50  0000 L CNN
F 2 "" H 800 6550 50  0001 C CNN
F 3 "" H 800 6550 50  0001 C CNN
	1    800  6550
	1    0    0    -1  
$EndComp
$Comp
L _Breadboard:R4_4_0 R3b
U 1 1 63D2F900
P 5200 6600
F 0 "R3b" V 5200 6750 50  0000 C CNN
F 1 "43k" V 5200 6500 50  0000 C CNN
F 2 "" H 5200 6600 50  0001 C CNN
F 3 "" H 5200 6600 50  0001 C CNN
	1    5200 6600
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5600 6600 5700 6600
Connection ~ 5700 6600
Wire Wire Line
	5700 6600 5700 8600
Wire Wire Line
	4800 5600 5700 5600
Connection ~ 5700 5600
Wire Wire Line
	3400 5600 4000 5600
Wire Wire Line
	4800 4400 5700 4400
Connection ~ 5700 4400
Wire Wire Line
	4800 3800 5700 3800
Connection ~ 5700 3800
Wire Wire Line
	5700 3800 5700 4400
Text GLabel 5400 5000 2    50   Input ~ 0
GND
Wire Wire Line
	2000 5800 2000 6800
Wire Wire Line
	2600 5600 1700 5600
Connection ~ 1700 5600
Wire Wire Line
	1700 5600 1700 10300
Wire Wire Line
	2000 600  2000 5200
Wire Wire Line
	5400 600  5400 5200
Wire Wire Line
	2600 5400 2000 5200
Connection ~ 2000 5200
Wire Wire Line
	2000 5200 2000 5800
Wire Wire Line
	4800 5400 5400 5200
Connection ~ 5400 5200
Wire Wire Line
	5400 5200 5400 6800
Wire Wire Line
	3000 6200 2800 5400
Wire Wire Line
	4200 6400 4400 5600
$Comp
L _Breadboard:C1_1_0 C2
U 1 1 63DAD044
P 4200 5500
F 0 "C2" H 4278 5546 50  0000 L CNN
F 1 "4.7uF" H 4278 5455 50  0000 L CNN
F 2 "" H 4200 5500 50  0001 C CNN
F 3 "" H 4200 5500 50  0001 C CNN
	1    4200 5500
	1    0    0    -1  
$EndComp
Wire Wire Line
	2900 3700 3100 5100
Wire Wire Line
	3100 5100 3200 5200
Wire Wire Line
	3000 5200 3000 5400
Wire Wire Line
	4400 5000 4600 4400
Wire Wire Line
	5700 4400 5700 5600
Wire Wire Line
	2900 3700 3100 3600
Wire Wire Line
	3100 3600 3600 3600
Wire Wire Line
	3800 3600 4100 3650
Wire Wire Line
	4100 3650 4200 3800
Wire Wire Line
	5700 5600 5700 6600
$Comp
L _Breadboard:R4_4_1 R3a
U 1 1 63DD687F
P 3100 6000
F 0 "R3a" H 3050 6100 50  0000 L CNN
F 1 "43k" H 3000 6000 50  0000 L CNN
F 2 "" H 3100 6000 50  0001 C CNN
F 3 "" H 3100 6000 50  0001 C CNN
	1    3100 6000
	-1   0    0    -1  
$EndComp
Wire Wire Line
	3200 6000 3300 6500
Wire Wire Line
	3300 6500 3500 6600
Wire Wire Line
	3500 6600 4000 6600
Text GLabel 2600 8000 0    50   Input ~ 0
Voa
Text GLabel 4800 8200 2    50   Input ~ 0
Vob
Text Notes 12300 8900 0    50   ~ 0
Inverting output:  Vo = (0.0005 V) * (2048 - Code)\n    Code = {0..4095}
$EndSCHEMATC
