EESchema Schematic File Version 4
LIBS:ki-cache
EELAYER 26 0
EELAYER END
$Descr A 11000 8500
encoding utf-8
Sheet 1 1
Title "Opamp Vcm and Output margin - opamp_vcm/"
Date "2023-11-14"
Rev "v1.0.0"
Comp "William A. Hudson"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Device:C_Small C2p
U 1 1 5EB4CA54
P 8600 2000
F 0 "C2p" V 8600 1500 50  0000 C CNN
F 1 "0.1uF" V 8600 1750 50  0000 C CNN
F 2 "" H 8600 2000 50  0001 C CNN
F 3 "~" H 8600 2000 50  0001 C CNN
	1    8600 2000
	0    1    1    0   
$EndComp
$Comp
L Device:C_Small C2n
U 1 1 5EB4CC2F
P 8600 3100
F 0 "C2n" V 8600 2600 50  0000 C CNN
F 1 "0.1uF" V 8600 2850 50  0000 C CNN
F 2 "" H 8600 3100 50  0001 C CNN
F 3 "~" H 8600 3100 50  0001 C CNN
	1    8600 3100
	0    1    1    0   
$EndComp
$Comp
L Device:CP1_Small C4p
U 1 1 5EB4CD7E
P 8600 1600
F 0 "C4p" V 8600 1100 50  0000 C CNN
F 1 "150uF" V 8600 1350 50  0000 C CNN
F 2 "" H 8600 1600 50  0001 C CNN
F 3 "~" H 8600 1600 50  0001 C CNN
	1    8600 1600
	0    1    1    0   
$EndComp
$Comp
L Device:CP1_Small C4n
U 1 1 5EB4CEE1
P 8600 3500
F 0 "C4n" V 8600 4000 50  0000 C CNN
F 1 "150uF" V 8600 3750 50  0000 C CNN
F 2 "" H 8600 3500 50  0001 C CNN
F 3 "~" H 8600 3500 50  0001 C CNN
	1    8600 3500
	0    -1   1    0   
$EndComp
$Comp
L Device:C_Small C1pn
U 1 1 5EB4D004
P 8400 2350
F 0 "C1pn" H 8050 2400 50  0000 L CNN
F 1 "0.01uF" H 8050 2300 50  0000 L CNN
F 2 "" H 8400 2350 50  0001 C CNN
F 3 "~" H 8400 2350 50  0001 C CNN
	1    8400 2350
	1    0    0    -1  
$EndComp
$Comp
L _Local:GND #PWR0101
U 1 1 5EB4E65B
P 8500 3600
F 0 "#PWR0101" H 8500 3350 50  0001 C CNN
F 1 "GND" H 8500 3427 50  0000 C CNN
F 2 "" H 8400 3250 50  0001 C CNN
F 3 "" H 8500 3350 50  0001 C CNN
	1    8500 3600
	1    0    0    -1  
$EndComp
$Comp
L _Local:VNN #PWR0102
U 1 1 5EB4E9E4
P 8700 3600
F 0 "#PWR0102" H 8700 3350 50  0001 C CNN
F 1 "VNN" H 8717 3427 50  0000 C CNN
F 2 "" H 8700 3600 50  0001 C CNN
F 3 "" H 8700 3600 50  0001 C CNN
	1    8700 3600
	1    0    0    -1  
$EndComp
Connection ~ 8700 3100
Wire Wire Line
	8700 3100 8700 3300
Connection ~ 8700 3300
Wire Wire Line
	8500 3600 8500 3500
Connection ~ 8500 3300
Wire Wire Line
	8500 3300 8500 3100
Wire Wire Line
	8400 2950 8700 2950
Connection ~ 8700 2950
Wire Wire Line
	8700 2950 8700 3100
Wire Wire Line
	8400 2250 8700 2250
Connection ~ 8700 2250
$Comp
L _Local:GND #PWR0104
U 1 1 5EB51758
P 8500 2100
F 0 "#PWR0104" H 8500 1850 50  0001 C CNN
F 1 "GND" H 8350 2050 50  0000 C CNN
F 2 "" H 8400 1750 50  0001 C CNN
F 3 "" H 8500 1850 50  0001 C CNN
	1    8500 2100
	1    0    0    -1  
$EndComp
Connection ~ 8700 2000
Wire Wire Line
	8700 2000 8700 2250
Wire Wire Line
	8500 1600 8500 1800
Connection ~ 8500 2000
Wire Wire Line
	8500 2000 8500 2100
$Comp
L _Local:VPP #PWR0105
U 1 1 5EB52F7C
P 8700 1500
F 0 "#PWR0105" H 8700 1750 50  0001 C CNN
F 1 "VPP" H 8717 1673 50  0000 C CNN
F 2 "" H 8700 1500 50  0001 C CNN
F 3 "" H 8700 1500 50  0001 C CNN
	1    8700 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	8700 1500 8700 1600
Wire Wire Line
	8400 2450 8400 2950
Text Label 9550 2600 0    50   ~ 0
Vo
Connection ~ 8700 1600
Wire Wire Line
	8700 1600 8700 1800
$Comp
L Device:C_Small C3p
U 1 1 5ED55534
P 8600 1800
F 0 "C3p" V 8600 1300 50  0000 C CNN
F 1 "1.0uF" V 8600 1550 50  0000 C CNN
F 2 "" H 8600 1800 50  0001 C CNN
F 3 "~" H 8600 1800 50  0001 C CNN
	1    8600 1800
	0    1    1    0   
$EndComp
Connection ~ 8700 1800
Wire Wire Line
	8700 1800 8700 2000
Connection ~ 8500 1800
Wire Wire Line
	8500 1800 8500 2000
Connection ~ 8500 3500
Wire Wire Line
	8500 3500 8500 3300
$Comp
L Device:C_Small C3n
U 1 1 5ED579CE
P 8600 3300
F 0 "C3n" V 8600 2800 50  0000 C CNN
F 1 "1.0uF" V 8600 3050 50  0000 C CNN
F 2 "" H 8600 3300 50  0001 C CNN
F 3 "~" H 8600 3300 50  0001 C CNN
	1    8600 3300
	0    1    1    0   
$EndComp
Wire Wire Line
	8700 3600 8700 3500
Connection ~ 8700 3500
Text Notes 5850 4500 0    50   ~ 0
Power:
Text Notes 5850 4800 0    50   ~ 0
+V
Text Notes 5850 5200 0    50   ~ 0
-V
Text Notes 5850 4600 0    50   ~ 0
V = 1.5 V dc nom (3.0 V max)
Wire Wire Line
	8700 3300 8700 3500
Text Notes 8850 2200 0    50   ~ 0
Power op-amp 8-PDIP\n300 mA, 6 V supply
$Comp
L _Local:Screw_TermB_01x03 J2
U 1 1 63C6313B
P 6100 4800
F 0 "J2" H 6050 4200 50  0000 L CNN
F 1 "Screw_TermB_01x03" H 6179 4551 50  0001 L CNN
F 2 "" H 6100 4600 50  0001 C CNN
F 3 "" H 6100 4600 50  0001 C CNN
	1    6100 4800
	-1   0    0    -1  
$EndComp
Text Label 6300 4800 0    50   ~ 0
VPP
Text Label 6300 5200 0    50   ~ 0
VNN
Wire Wire Line
	6300 5000 6700 5000
Wire Wire Line
	6700 5000 6700 5200
Text Label 6300 5000 0    50   ~ 0
GND
$Comp
L _Local:GND #PWR?
U 1 1 63C6BF8A
P 6700 5200
F 0 "#PWR?" H 6700 4950 50  0001 C CNN
F 1 "GND" H 6700 5027 50  0000 C CNN
F 2 "" H 6600 4850 50  0001 C CNN
F 3 "" H 6700 4950 50  0001 C CNN
	1    6700 5200
	1    0    0    -1  
$EndComp
Text Notes 5750 5000 0    50   ~ 0
Comm
Text Notes 7300 4600 0    50   ~ 0
Input:  Vin   AC signal
Text Notes 7500 4800 0    50   ~ 0
Vin = 0 to +-1.0 V,  1 kHz max\nAbsolute max 10 V
Text Notes 7300 5300 0    50   ~ 0
Output:  Vout
Text Notes 9100 1000 0    50   ~ 0
Resistors:  1/4 W, 5% Carbon
$Comp
L _Local:TLV4110 U1
U 1 1 6525782B
P 8800 2600
F 0 "U1" H 8850 2900 50  0000 L CNN
F 1 "TLV4110" H 8850 2800 50  0000 L CNN
F 2 "PDIP-8" H 9000 3000 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/tlv4110.pdf" H 8800 2800 50  0001 C CNN
	1    8800 2600
	1    0    0    -1  
$EndComp
Text Notes 9100 850  0    50   ~ 0
Capacitors:  25 V
Text Notes 6850 2100 0    50   ~ 0
Input voltage protection
$Comp
L _Local:VPP #PWR?
U 1 1 6526AFFB
P 8950 2950
F 0 "#PWR?" H 8950 3200 50  0001 C CNN
F 1 "VPP" H 8967 3123 50  0000 C CNN
F 2 "" H 8950 2950 50  0001 C CNN
F 3 "" H 8950 2950 50  0001 C CNN
	1    8950 2950
	1    0    0    1   
$EndComp
Wire Wire Line
	1000 7800 1000 1200
Wire Wire Line
	5000 7800 5000 1200
$Comp
L _Breadboard:OpAmp_Shutdown U1
U 1 1 652780CB
P 3000 4300
F 0 "U1" H 3000 4565 50  0000 C CNN
F 1 "TLV4110" H 3000 4474 50  0000 C CNN
F 2 "" H 3000 4300 50  0001 C CNN
F 3 "" H 3000 4300 50  0001 C CNN
	1    3000 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	3000 7600 3000 7900
$Comp
L _Breadboard:R4_4_1 Rp
U 1 1 6527CB15
P 2000 4300
F 0 "Rp" H 2000 4500 50  0000 L CNN
F 1 "10k" H 1950 4400 50  0000 L CNN
F 2 "" H 2000 4300 50  0001 C CNN
F 3 "" H 2000 4300 50  0001 C CNN
	1    2000 4300
	1    0    0    -1  
$EndComp
$Comp
L _Breadboard:R4_4_1 Rf
U 1 1 6527D8DC
P 3600 4300
F 0 "Rf" H 3600 4500 50  0000 L CNN
F 1 "10k" H 3550 4400 50  0000 L CNN
F 2 "" H 3600 4300 50  0001 C CNN
F 3 "" H 3600 4300 50  0001 C CNN
	1    3600 4300
	1    0    0    -1  
$EndComp
$Comp
L _Breadboard:C1_1_0 C2n
U 1 1 6527EEEA
P 2500 5000
F 0 "C2n" H 2500 4850 50  0000 L CNN
F 1 "0.1uf" H 2500 4750 50  0000 L CNN
F 2 "" H 2500 5000 50  0001 C CNN
F 3 "" H 2500 5000 50  0001 C CNN
	1    2500 5000
	1    0    0    -1  
$EndComp
Text GLabel 1900 3700 0    50   Input ~ 0
Vin
Text GLabel 1900 4900 0    50   Input ~ 0
VNN
Text GLabel 4100 4700 2    50   Input ~ 0
Vout
Text GLabel 4100 4500 2    50   Input ~ 0
VPP
$Comp
L _Breadboard:R4_4_1 Rload
U 1 1 6527F411
P 3800 5500
F 0 "Rload" H 3800 5650 50  0000 L CNN
F 1 "10R" H 3750 5550 50  0000 L CNN
F 2 "" H 3800 5500 50  0001 C CNN
F 3 "" H 3800 5500 50  0001 C CNN
	1    3800 5500
	1    0    0    -1  
$EndComp
$Comp
L _Breadboard:C3_3_0 C2p
U 1 1 6527F58E
P 3700 4800
F 0 "C2p" H 3778 4846 50  0000 L CNN
F 1 "0.1uf" H 3778 4755 50  0000 L CNN
F 2 "" H 3700 4800 50  0001 C CNN
F 3 "" H 3700 4800 50  0001 C CNN
	1    3700 4800
	1    0    0    -1  
$EndComp
Wire Wire Line
	2700 5100 3300 5100
Wire Wire Line
	1900 5100 1300 5100
Wire Wire Line
	4100 5100 4700 5100
Text GLabel 4700 5300 2    50   Input ~ 0
GND
Text Label 1300 7700 0    50   ~ 0
GND
Text Label 4700 7700 0    50   ~ 0
GND
Wire Wire Line
	3900 4300 3900 4500
Wire Wire Line
	1300 1200 1300 5100
Connection ~ 1300 5100
Wire Wire Line
	1300 5100 1300 7800
Wire Wire Line
	4700 1200 4700 5100
Connection ~ 4700 5100
Wire Wire Line
	4700 5100 4700 7800
Text Notes 2500 7500 0    50   ~ 0
Solderless Breadboard,\n0.2 inch drawn = 0.1 inch
$Comp
L Device:R_US Ri
U 1 1 6554ABC2
P 7300 4100
F 0 "Ri" V 7095 4100 50  0000 C CNN
F 1 "30k" V 7186 4100 50  0000 C CNN
F 2 "" V 7340 4090 50  0001 C CNN
F 3 "~" H 7300 4100 50  0001 C CNN
	1    7300 4100
	0    1    1    0   
$EndComp
Wire Wire Line
	9200 2600 9400 2600
Wire Wire Line
	9400 2600 9400 4100
Wire Wire Line
	7800 4100 7800 2700
Wire Wire Line
	7800 2700 8500 2700
$Comp
L Device:R_US Rf
U 1 1 6554DFAA
P 8200 4100
F 0 "Rf" V 7995 4100 50  0000 C CNN
F 1 "10k" V 8086 4100 50  0000 C CNN
F 2 "" V 8240 4090 50  0001 C CNN
F 3 "~" H 8200 4100 50  0001 C CNN
	1    8200 4100
	0    1    1    0   
$EndComp
Wire Wire Line
	7800 4100 8050 4100
Wire Wire Line
	8350 4100 9400 4100
Wire Wire Line
	6900 4100 7150 4100
Wire Wire Line
	7450 4100 7800 4100
Connection ~ 7800 4100
Wire Wire Line
	8500 2500 7450 2500
Text Label 7800 2500 0    50   ~ 0
Vp
Text Label 7800 2700 0    50   ~ 0
Vn
Wire Wire Line
	9400 2600 9900 2600
Connection ~ 9400 2600
$Comp
L Device:R_US Rp
U 1 1 65559DA5
P 7300 2500
F 0 "Rp" V 7095 2500 50  0000 C CNN
F 1 "10k" V 7186 2500 50  0000 C CNN
F 2 "" V 7340 2490 50  0001 C CNN
F 3 "~" H 7300 2500 50  0001 C CNN
	1    7300 2500
	0    1    1    0   
$EndComp
Wire Wire Line
	6900 2500 7150 2500
Text GLabel 6900 4100 0    50   Input ~ 0
Vin
Text GLabel 6900 2500 0    50   Input ~ 0
Vref
Text GLabel 10100 2600 2    50   Input ~ 0
Vout
Text GLabel 6900 3300 0    50   Input ~ 0
Gnd
$Comp
L _Local:GND #PWR?
U 1 1 6555C0AD
P 7100 3400
F 0 "#PWR?" H 7100 3150 50  0001 C CNN
F 1 "GND" H 7100 3227 50  0000 C CNN
F 2 "" H 7000 3050 50  0001 C CNN
F 3 "" H 7100 3150 50  0001 C CNN
	1    7100 3400
	1    0    0    -1  
$EndComp
$Comp
L Device:R_POT_US Rdc
U 1 1 6555C288
P 6000 2500
F 0 "Rdc" H 5932 2546 50  0000 R CNN
F 1 "5k" H 5932 2455 50  0000 R CNN
F 2 "" H 6000 2500 50  0001 C CNN
F 3 "~" H 6000 2500 50  0001 C CNN
	1    6000 2500
	1    0    0    -1  
$EndComp
$Comp
L _Local:VNN #PWR?
U 1 1 6555C5D6
P 6000 2800
F 0 "#PWR?" H 6000 2550 50  0001 C CNN
F 1 "VNN" H 6017 2627 50  0000 C CNN
F 2 "" H 6000 2800 50  0001 C CNN
F 3 "" H 6000 2800 50  0001 C CNN
	1    6000 2800
	1    0    0    -1  
$EndComp
$Comp
L _Local:VPP #PWR?
U 1 1 6555C639
P 6000 2200
F 0 "#PWR?" H 6000 2450 50  0001 C CNN
F 1 "VPP" H 6017 2373 50  0000 C CNN
F 2 "" H 6000 2200 50  0001 C CNN
F 3 "" H 6000 2200 50  0001 C CNN
	1    6000 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	6000 2200 6000 2350
Wire Wire Line
	6000 2650 6000 2800
Wire Wire Line
	6150 2500 6700 2500
Text Label 7000 4100 0    50   ~ 0
Vin
Text Label 7000 2500 0    50   ~ 0
Vref
Wire Wire Line
	6900 3300 7100 3300
Wire Wire Line
	7100 3300 7100 3400
$Comp
L Device:R_US Rload
U 1 1 6556CEC7
P 9900 3150
F 0 "Rload" H 9750 3100 50  0000 C CNN
F 1 "10R" H 9750 3200 50  0000 C CNN
F 2 "" V 9940 3140 50  0001 C CNN
F 3 "~" H 9900 3150 50  0001 C CNN
	1    9900 3150
	-1   0    0    1   
$EndComp
Wire Wire Line
	9900 2600 9900 3000
Connection ~ 9900 2600
Wire Wire Line
	9900 2600 10100 2600
Wire Wire Line
	9900 3300 9900 3400
$Comp
L _Local:GND #PWR?
U 1 1 65570C1B
P 9900 3400
F 0 "#PWR?" H 9900 3150 50  0001 C CNN
F 1 "GND" H 9900 3227 50  0000 C CNN
F 2 "" H 9800 3050 50  0001 C CNN
F 3 "" H 9900 3150 50  0001 C CNN
	1    9900 3400
	1    0    0    -1  
$EndComp
Text Notes 6600 2700 0    50   ~ 0
DC reference
Text Notes 6600 4300 0    50   ~ 0
AC input
$Comp
L _Breadboard:R4_4_1 Ri
U 1 1 65571BC6
P 2400 4100
F 0 "Ri" H 2400 4300 50  0000 L CNN
F 1 "30k" H 2350 4200 50  0000 L CNN
F 2 "" H 2400 4100 50  0001 C CNN
F 3 "" H 2400 4100 50  0001 C CNN
	1    2400 4100
	1    0    0    -1  
$EndComp
Wire Wire Line
	3900 4700 3500 5900
Wire Wire Line
	3300 3900 2600 4000
Wire Wire Line
	2600 4000 2500 4500
Text GLabel 1900 3900 0    50   Input ~ 0
Vref
Text Notes 7500 5500 0    50   ~ 0
Vout = (1 + Rf / Ri) * Vref - (Rf / Ri) * Vin\nIout = Vout / Rload
Text Notes 7300 5000 0    50   ~ 0
Input:  Vref   DC reference, is common mode voltage\n
Text Notes 6300 6700 0    50   ~ 0
Opamp input common mode and output range experiments.
Text Notes 7300 6200 0    50   ~ 0
Common mode experiments:\n   Rf < Ri      Vref is the common mode voltage Vcm
Text Notes 7300 6450 0    50   ~ 0
Output range experiments:\n   Rf >= Ri      Vref = 0.0 V  common mode voltage
Text Notes 7300 5950 0    50   ~ 0
Concept:  Gain << 1, so output Vo << Vcm,  common mode is limiter.\n    Vref sets common mode voltage Vcm = Vp, = Vn by op-amp feedback.\n    Sweep Vin amplitude, look for clipping on Vo.
$EndSCHEMATC
