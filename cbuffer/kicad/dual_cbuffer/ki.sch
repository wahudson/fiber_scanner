EESchema Schematic File Version 4
EELAYER 26 0
EELAYER END
$Descr A 11000 8500
encoding utf-8
Sheet 1 1
Title "Dual Current Buffer - dual_cbuffer/"
Date "2023-05-30"
Rev "v1.0.0"
Comp "William A. Hudson"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L _Local:cbuffer_v2 Y10
U 1 1 64714444
P 6300 2250
F 0 "Y10" H 6300 3350 50  0000 C CNN
F 1 "cbuffer_v2/  v2.1.0" H 6250 3200 50  0000 C CNN
F 2 "" H 6300 2250 50  0001 C CNN
F 3 "" H 6300 2250 50  0001 C CNN
	1    6300 2250
	1    0    0    -1  
$EndComp
$Comp
L _Local:ACDC_Power Y1
U 1 1 64728CFC
P 2350 3000
F 0 "Y1" H 2350 3350 50  0000 C CNN
F 1 "CUI PSK-20D-9-T" H 2350 3200 50  0000 C CNN
F 2 "" H 2350 3000 50  0001 C CNN
F 3 "" H 2350 3000 50  0001 C CNN
	1    2350 3000
	1    0    0    -1  
$EndComp
$Comp
L _Local:Header_F1x02 J14
U 1 1 64728E38
P 5300 1900
F 0 "J14" H 5250 2050 50  0000 L CNN
F 1 "Header_F1x02" H 5200 2000 50  0001 L CNN
F 2 "" H 5300 1900 50  0001 C CNN
F 3 "" H 5300 1900 50  0001 C CNN
	1    5300 1900
	1    0    0    -1  
$EndComp
$Comp
L _Local:Screw_TermB_01x02 J?
U 1 1 6472F77E
P 3200 2900
F 0 "J?" H 3100 3100 50  0001 L CNN
F 1 "Screw_TermB_01x02" H 3279 2755 50  0001 L CNN
F 2 "" H 3200 2900 50  0001 C CNN
F 3 "" H 3200 2900 50  0001 C CNN
	1    3200 2900
	1    0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J?
U 1 1 6472F833
P 7100 2800
F 0 "J?" H 7050 2900 50  0001 L CNN
F 1 "Screw_Terminal_01x02" H 7180 2701 50  0001 L CNN
F 2 "" H 7100 2800 50  0001 C CNN
F 3 "~" H 7100 2800 50  0001 C CNN
	1    7100 2800
	1    0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x03 J?
U 1 1 6472F92C
P 5500 2600
F 0 "J?" H 5420 2825 50  0001 C CNN
F 1 "Screw_Terminal_01x03" H 5420 2826 50  0001 C CNN
F 2 "" H 5500 2600 50  0001 C CNN
F 3 "~" H 5500 2600 50  0001 C CNN
	1    5500 2600
	-1   0    0    -1  
$EndComp
$Comp
L _Local:Header_M1x02 J?
U 1 1 6472FB67
P 7100 1600
F 0 "J?" H 7050 1700 50  0001 L CNN
F 1 "Header_M1x02" H 7179 1501 50  0001 L CNN
F 2 "" H 7100 1600 50  0001 C CNN
F 3 "" H 7100 1600 50  0001 C CNN
	1    7100 1600
	1    0    0    -1  
$EndComp
$Comp
L _Local:Header_M1x02 J?
U 1 1 6472FCCF
P 7100 2000
F 0 "J?" H 7050 2100 50  0001 L CNN
F 1 "Header_M1x02" H 7179 1901 50  0001 L CNN
F 2 "" H 7100 2000 50  0001 C CNN
F 3 "" H 7100 2000 50  0001 C CNN
	1    7100 2000
	1    0    0    -1  
$EndComp
$Comp
L _Local:Header_M1x02 J?
U 1 1 6472FD48
P 7100 2400
F 0 "J?" H 7050 2500 50  0001 L CNN
F 1 "Header_M1x02" H 7179 2301 50  0001 L CNN
F 2 "" H 7100 2400 50  0001 C CNN
F 3 "" H 7100 2400 50  0001 C CNN
	1    7100 2400
	1    0    0    -1  
$EndComp
$Comp
L _Local:Header_M1x02 J?
U 1 1 6472FDA8
P 5500 1900
F 0 "J?" H 5420 2025 50  0001 C CNN
F 1 "Header_M1x02" H 5420 2026 50  0001 C CNN
F 2 "" H 5500 1900 50  0001 C CNN
F 3 "" H 5500 1900 50  0001 C CNN
	1    5500 1900
	-1   0    0    -1  
$EndComp
$Comp
L Device:R_US R11
U 1 1 6473032D
P 4950 1900
F 0 "R11" V 5155 1900 50  0000 C CNN
F 1 "57.6k" V 5064 1900 50  0000 C CNN
F 2 "" V 4990 1890 50  0001 C CNN
F 3 "~" H 4950 1900 50  0001 C CNN
	1    4950 1900
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4800 1900 4800 2000
Wire Wire Line
	4800 2000 5100 2000
$Comp
L _Local:Screw_TermB_01x02 J?
U 1 1 6473049D
P 1500 2900
F 0 "J?" H 1420 3075 50  0001 C CNN
F 1 "Screw_TermB_01x02" H 1579 2755 50  0001 L CNN
F 2 "" H 1500 2900 50  0001 C CNN
F 3 "" H 1500 2900 50  0001 C CNN
	1    1500 2900
	-1   0    0    -1  
$EndComp
Text Notes 2000 3250 0    50   ~ 0
9 V, 2.2 A, 20 W
$Comp
L _Local:ACDC_Power Y2
U 1 1 647309F6
P 2350 4000
F 0 "Y2" H 2350 4350 50  0000 C CNN
F 1 "CUI PSK-20D-9-T" H 2350 4200 50  0000 C CNN
F 2 "" H 2350 4000 50  0001 C CNN
F 3 "" H 2350 4000 50  0001 C CNN
	1    2350 4000
	1    0    0    -1  
$EndComp
$Comp
L _Local:Screw_TermB_01x02 J?
U 1 1 647309FC
P 3200 3900
F 0 "J?" H 3100 4100 50  0001 L CNN
F 1 "Screw_TermB_01x02" H 3279 3755 50  0001 L CNN
F 2 "" H 3200 3900 50  0001 C CNN
F 3 "" H 3200 3900 50  0001 C CNN
	1    3200 3900
	1    0    0    -1  
$EndComp
$Comp
L _Local:Screw_TermB_01x02 J?
U 1 1 64730A02
P 1500 3900
F 0 "J?" H 1420 4075 50  0001 C CNN
F 1 "Screw_TermB_01x02" H 1579 3755 50  0001 L CNN
F 2 "" H 1500 3900 50  0001 C CNN
F 3 "" H 1500 3900 50  0001 C CNN
	1    1500 3900
	-1   0    0    -1  
$EndComp
Text Notes 2000 4250 0    50   ~ 0
9 V, 2.2 A, 20 W
$Comp
L _Local:Header_F1x02 J15
U 1 1 647317C7
P 7300 1600
F 0 "J15" H 7150 1700 50  0000 L CNN
F 1 "Header_F1x02" H 7200 1700 50  0001 L CNN
F 2 "" H 7300 1600 50  0001 C CNN
F 3 "" H 7300 1600 50  0001 C CNN
	1    7300 1600
	-1   0    0    -1  
$EndComp
$Comp
L _Local:Header_F1x02 J16
U 1 1 64731D0E
P 7300 2000
F 0 "J16" H 7150 2100 50  0000 L CNN
F 1 "Header_F1x02" H 7200 2100 50  0001 L CNN
F 2 "" H 7300 2000 50  0001 C CNN
F 3 "" H 7300 2000 50  0001 C CNN
	1    7300 2000
	-1   0    0    -1  
$EndComp
$Comp
L _Local:Header_F1x02 J11
U 1 1 64731D6A
P 7300 2400
F 0 "J11" H 7150 2500 50  0000 L CNN
F 1 "Header_F1x02" H 7200 2500 50  0001 L CNN
F 2 "" H 7300 2400 50  0001 C CNN
F 3 "" H 7300 2400 50  0001 C CNN
	1    7300 2400
	-1   0    0    -1  
$EndComp
$Comp
L Device:LED_ALT D11
U 1 1 64731EFE
P 8650 2000
F 0 "D11" H 8950 1850 50  0000 C CNN
F 1 "Red LED" H 8650 1850 50  0000 C CNN
F 2 "" H 8650 2000 50  0001 C CNN
F 3 "~" H 8650 2000 50  0001 C CNN
	1    8650 2000
	-1   0    0    1   
$EndComp
$Comp
L Switch:SW_DPST SW3
U 1 1 64732324
P 9700 1400
F 0 "SW3" H 9700 1633 50  0000 C CNN
F 1 "SW_DPST" H 9700 1634 50  0001 C CNN
F 2 "" H 9700 1400 50  0001 C CNN
F 3 "" H 9700 1400 50  0001 C CNN
	1    9700 1400
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_SPST SW11
U 1 1 64732599
P 8700 3200
F 0 "SW11" H 8700 3343 50  0000 C CNN
F 1 "SW_SPST" H 8700 3344 50  0001 C CNN
F 2 "" H 8700 3200 50  0001 C CNN
F 3 "" H 8700 3200 50  0001 C CNN
	1    8700 3200
	1    0    0    -1  
$EndComp
$Comp
L _Local:BNC_panel_iso J10
U 1 1 647345CE
P 8750 2400
F 0 "J10" H 9000 2550 50  0000 R CNN
F 1 "Amphenol 031-10-RFXG1" H 8950 2500 50  0001 L CNN
F 2 "" H 8750 2400 50  0001 C CNN
F 3 "" H 8750 2400 50  0001 C CNN
	1    8750 2400
	-1   0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J13
U 1 1 647347BD
P 8700 2800
F 0 "J13" H 8650 2900 50  0000 L CNN
F 1 "Screw_Terminal_01x02" H 8780 2701 50  0001 L CNN
F 2 "" H 8700 2800 50  0001 C CNN
F 3 "~" H 8700 2800 50  0001 C CNN
	1    8700 2800
	1    0    0    -1  
$EndComp
Wire Wire Line
	7500 2400 8500 2400
Wire Wire Line
	7500 2500 8500 2500
Wire Wire Line
	7500 2000 8500 2000
Wire Wire Line
	7500 2100 8800 2100
Wire Wire Line
	8800 2100 8800 2000
Wire Wire Line
	4800 4400 4800 4300
Wire Wire Line
	7500 1600 9200 1600
Wire Wire Line
	9200 1600 9200 1300
Wire Wire Line
	9200 1300 9500 1300
Wire Wire Line
	7500 1700 9300 1700
Wire Wire Line
	9300 1700 9300 1100
Wire Wire Line
	9300 1100 9900 1100
Wire Wire Line
	9900 1100 9900 1300
$Comp
L _Local:Screw_TermB_01x03 J3
U 1 1 64737CA6
P 4000 3300
F 0 "J3" H 3950 3500 50  0000 L CNN
F 1 "Screw_TermB_01x03" H 4079 3055 50  0001 L CNN
F 2 "" H 4000 3100 50  0001 C CNN
F 3 "" H 4000 3100 50  0001 C CNN
	1    4000 3300
	1    0    0    -1  
$EndComp
Wire Wire Line
	3700 2900 3700 3200
Wire Wire Line
	3700 3200 3800 3300
Wire Wire Line
	3250 4100 3700 4100
Wire Wire Line
	3700 4100 3700 3800
Wire Wire Line
	3700 3800 3800 3700
Wire Wire Line
	3250 3100 3600 3100
Wire Wire Line
	3600 3100 3600 3400
Wire Wire Line
	3600 3400 3800 3500
Wire Wire Line
	3250 3900 3600 3900
Wire Wire Line
	3600 3900 3600 3600
Wire Wire Line
	3600 3600 3800 3500
Connection ~ 3800 3500
Wire Wire Line
	4050 3300 4200 3250
Wire Wire Line
	4200 3250 4700 3250
Wire Wire Line
	4700 3250 4700 2500
Wire Wire Line
	4700 2500 5450 2500
Wire Wire Line
	4050 3700 4200 3650
Wire Wire Line
	4200 3650 4900 3650
Wire Wire Line
	4900 2700 5450 2700
Wire Wire Line
	4900 2700 4900 3650
Wire Wire Line
	4050 3500 4200 3450
Wire Wire Line
	4200 3450 4800 3450
Wire Wire Line
	4800 3450 4800 2600
Wire Wire Line
	4800 2600 5450 2600
Wire Wire Line
	4050 3700 4200 3750
Wire Wire Line
	4200 3750 4300 3750
Wire Wire Line
	4300 3750 4300 5100
Wire Wire Line
	4050 3500 4200 3550
Wire Wire Line
	4200 3550 4400 3550
Wire Wire Line
	4400 3550 4400 5000
Wire Wire Line
	4050 3300 4200 3350
Wire Wire Line
	4200 3350 4500 3350
Wire Wire Line
	4500 3350 4500 4900
$Comp
L _Local:Power_Entry Y3
U 1 1 64745AD7
P 2350 5600
F 0 "Y3" H 2550 6000 50  0000 R CNN
F 1 "Schurter 4301.1405" H 2550 5900 50  0000 R CNN
F 2 "" H 2350 5600 50  0001 C CNN
F 3 "" H 2350 5600 50  0001 C CNN
	1    2350 5600
	-1   0    0    -1  
$EndComp
Wire Wire Line
	1700 5800 1000 5800
Wire Wire Line
	1000 3100 1450 3100
Wire Wire Line
	1700 5400 1100 5400
Wire Wire Line
	1100 5400 1100 3900
Wire Wire Line
	1100 2900 1450 2900
Wire Wire Line
	1100 3900 1450 3900
Connection ~ 1100 3900
Wire Wire Line
	1100 3900 1100 2900
Wire Wire Line
	1000 4100 1450 4100
Text Notes 7550 1300 0    100  ~ 0
Channel 1
Text Notes 7550 3000 0    50   ~ 0
Twisted pairs
Text Notes 6250 6700 0    100  ~ 0
Current Buffer  1.0 mA/mV, Dual Channel
Wire Wire Line
	7150 2900 8300 2900
Wire Wire Line
	7150 2800 8400 2800
Wire Wire Line
	8500 3200 8400 3200
Wire Wire Line
	8400 3200 8400 2800
Connection ~ 8400 2800
Wire Wire Line
	8400 2800 8500 2800
Wire Wire Line
	8900 3200 8900 3300
Wire Wire Line
	8900 3300 8300 3300
Wire Wire Line
	8300 3300 8300 2900
Connection ~ 8300 2900
Wire Wire Line
	8300 2900 8500 2900
Text Notes 9000 3150 0    50   ~ 0
Run  (open)
Text Notes 9000 3250 0    50   ~ 0
Shunt (closed)
Text Notes 10000 1200 0    50   ~ 0
Run  (open)
Text Notes 10000 1300 0    50   ~ 0
Off  (closed)
Text Notes 8950 2000 0    50   ~ 0
Shutdown
Text Notes 8950 2300 0    50   ~ 0
Input BNC
Text Notes 9000 2800 0    50   ~ 0
Output
Text Notes 3350 4250 0    50   ~ 0
Twisted pairs
Wire Wire Line
	9800 4000 9800 1600
Wire Wire Line
	9800 1600 9500 1600
Wire Wire Line
	9500 1500 9500 1600
$Comp
L _Local:Binding_Post J2
U 1 1 6477849C
P 4900 6000
F 0 "J2" H 4900 6315 50  0000 C CNN
F 1 "Pomona 3760-0" H 4800 6200 50  0000 L CNN
F 2 "" H 4900 6000 50  0001 C CNN
F 3 "" H 4900 6000 50  0001 C CNN
	1    4900 6000
	1    0    0    -1  
$EndComp
$Comp
L _Local:Binding_Post J1
U 1 1 647785B4
P 4900 6600
F 0 "J1" H 4900 6915 50  0000 C CNN
F 1 "Cinch 111-2223-001" H 4800 6800 50  0000 L CNN
F 2 "" H 4900 6600 50  0001 C CNN
F 3 "" H 4900 6600 50  0001 C CNN
	1    4900 6600
	1    0    0    -1  
$EndComp
Text Notes 5200 6100 0    50   ~ 0
GND - Star Ground\n(black, insulated)
Text Notes 5200 6700 0    50   ~ 0
Chassis Gnd\n(bonded to panel)
Wire Wire Line
	1700 5600 1500 5600
Wire Wire Line
	1500 5600 1500 6600
Wire Wire Line
	1500 6600 4900 6600
Wire Wire Line
	4050 3500 4700 3500
Wire Wire Line
	4700 6000 4900 6000
Connection ~ 4050 3500
Text Notes 1750 6250 0    50   ~ 0
Fuse:  BelFuse 5ST 3.15-R, 3.15 A, 33 A2s
Text Notes 1750 6100 0    50   ~ 0
AC line 120 VAC
$Comp
L _Local:cbuffer_v2 Y20
U 1 1 6478CD55
P 6300 4650
F 0 "Y20" H 6300 5750 50  0000 C CNN
F 1 "cbuffer_v2/  v2.1.0" H 6250 5600 50  0000 C CNN
F 2 "" H 6300 4650 50  0001 C CNN
F 3 "" H 6300 4650 50  0001 C CNN
	1    6300 4650
	1    0    0    -1  
$EndComp
$Comp
L _Local:Header_F1x02 J24
U 1 1 6478CD5B
P 5300 4300
F 0 "J24" H 5250 4450 50  0000 L CNN
F 1 "Header_F1x02" H 5200 4400 50  0001 L CNN
F 2 "" H 5300 4300 50  0001 C CNN
F 3 "" H 5300 4300 50  0001 C CNN
	1    5300 4300
	1    0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J?
U 1 1 6478CD61
P 7100 5200
F 0 "J?" H 7050 5300 50  0001 L CNN
F 1 "Screw_Terminal_01x02" H 7180 5101 50  0001 L CNN
F 2 "" H 7100 5200 50  0001 C CNN
F 3 "~" H 7100 5200 50  0001 C CNN
	1    7100 5200
	1    0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x03 J?
U 1 1 6478CD67
P 5500 5000
F 0 "J?" H 5420 5225 50  0001 C CNN
F 1 "Screw_Terminal_01x03" H 5420 5226 50  0001 C CNN
F 2 "" H 5500 5000 50  0001 C CNN
F 3 "~" H 5500 5000 50  0001 C CNN
	1    5500 5000
	-1   0    0    -1  
$EndComp
$Comp
L _Local:Header_M1x02 J?
U 1 1 6478CD6D
P 7100 4000
F 0 "J?" H 7050 4100 50  0001 L CNN
F 1 "Header_M1x02" H 7179 3901 50  0001 L CNN
F 2 "" H 7100 4000 50  0001 C CNN
F 3 "" H 7100 4000 50  0001 C CNN
	1    7100 4000
	1    0    0    -1  
$EndComp
$Comp
L _Local:Header_M1x02 J?
U 1 1 6478CD73
P 7100 4400
F 0 "J?" H 7050 4500 50  0001 L CNN
F 1 "Header_M1x02" H 7179 4301 50  0001 L CNN
F 2 "" H 7100 4400 50  0001 C CNN
F 3 "" H 7100 4400 50  0001 C CNN
	1    7100 4400
	1    0    0    -1  
$EndComp
$Comp
L _Local:Header_M1x02 J?
U 1 1 6478CD79
P 7100 4800
F 0 "J?" H 7050 4900 50  0001 L CNN
F 1 "Header_M1x02" H 7179 4701 50  0001 L CNN
F 2 "" H 7100 4800 50  0001 C CNN
F 3 "" H 7100 4800 50  0001 C CNN
	1    7100 4800
	1    0    0    -1  
$EndComp
$Comp
L _Local:Header_M1x02 J?
U 1 1 6478CD7F
P 5500 4300
F 0 "J?" H 5420 4425 50  0001 C CNN
F 1 "Header_M1x02" H 5420 4426 50  0001 C CNN
F 2 "" H 5500 4300 50  0001 C CNN
F 3 "" H 5500 4300 50  0001 C CNN
	1    5500 4300
	-1   0    0    -1  
$EndComp
$Comp
L Device:R_US R21
U 1 1 6478CD85
P 4950 4300
F 0 "R21" V 5155 4300 50  0000 C CNN
F 1 "57.6k" V 5064 4300 50  0000 C CNN
F 2 "" V 4990 4290 50  0001 C CNN
F 3 "~" H 4950 4300 50  0001 C CNN
	1    4950 4300
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4800 4400 5100 4400
$Comp
L _Local:Header_F1x02 J25
U 1 1 6478CD8C
P 7300 4000
F 0 "J25" H 7150 4100 50  0000 L CNN
F 1 "Header_F1x02" H 7200 4100 50  0001 L CNN
F 2 "" H 7300 4000 50  0001 C CNN
F 3 "" H 7300 4000 50  0001 C CNN
	1    7300 4000
	-1   0    0    -1  
$EndComp
$Comp
L _Local:Header_F1x02 J26
U 1 1 6478CD92
P 7300 4400
F 0 "J26" H 7150 4500 50  0000 L CNN
F 1 "Header_F1x02" H 7200 4500 50  0001 L CNN
F 2 "" H 7300 4400 50  0001 C CNN
F 3 "" H 7300 4400 50  0001 C CNN
	1    7300 4400
	-1   0    0    -1  
$EndComp
$Comp
L _Local:Header_F1x02 J21
U 1 1 6478CD98
P 7300 4800
F 0 "J21" H 7150 4900 50  0000 L CNN
F 1 "Header_F1x02" H 7200 4900 50  0001 L CNN
F 2 "" H 7300 4800 50  0001 C CNN
F 3 "" H 7300 4800 50  0001 C CNN
	1    7300 4800
	-1   0    0    -1  
$EndComp
$Comp
L Device:LED_ALT D21
U 1 1 6478CD9E
P 8650 4400
F 0 "D21" H 8950 4250 50  0000 C CNN
F 1 "Red LED" H 8650 4250 50  0000 C CNN
F 2 "" H 8650 4400 50  0001 C CNN
F 3 "~" H 8650 4400 50  0001 C CNN
	1    8650 4400
	-1   0    0    1   
$EndComp
$Comp
L Switch:SW_SPST SW21
U 1 1 6478CDA4
P 8700 5600
F 0 "SW21" H 8700 5743 50  0000 C CNN
F 1 "SW_SPST" H 8700 5744 50  0001 C CNN
F 2 "" H 8700 5600 50  0001 C CNN
F 3 "" H 8700 5600 50  0001 C CNN
	1    8700 5600
	1    0    0    -1  
$EndComp
$Comp
L _Local:BNC_panel_iso J20
U 1 1 6478CDAA
P 8750 4800
F 0 "J20" H 9000 4950 50  0000 R CNN
F 1 "Amphenol 031-10-RFXG1" H 8950 4900 50  0001 L CNN
F 2 "" H 8750 4800 50  0001 C CNN
F 3 "" H 8750 4800 50  0001 C CNN
	1    8750 4800
	-1   0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J23
U 1 1 6478CDB0
P 8700 5200
F 0 "J23" H 8650 5300 50  0000 L CNN
F 1 "Screw_Terminal_01x02" H 8780 5101 50  0001 L CNN
F 2 "" H 8700 5200 50  0001 C CNN
F 3 "~" H 8700 5200 50  0001 C CNN
	1    8700 5200
	1    0    0    -1  
$EndComp
Wire Wire Line
	7500 4800 8500 4800
Wire Wire Line
	7500 4900 8500 4900
Wire Wire Line
	7500 4400 8500 4400
Wire Wire Line
	7500 4500 8800 4500
Wire Wire Line
	8800 4500 8800 4400
Wire Wire Line
	7500 4000 9800 4000
Wire Wire Line
	7500 4100 9900 4100
Wire Wire Line
	4300 5100 5450 5100
Wire Wire Line
	4400 5000 5450 5000
Text Notes 7550 3700 0    100  ~ 0
Channel 2
Text Notes 7550 5400 0    50   ~ 0
Twisted pairs
Wire Wire Line
	7150 5300 8300 5300
Wire Wire Line
	7150 5200 8400 5200
Wire Wire Line
	8500 5600 8400 5600
Wire Wire Line
	8400 5600 8400 5200
Connection ~ 8400 5200
Wire Wire Line
	8400 5200 8500 5200
Wire Wire Line
	8900 5600 8900 5700
Wire Wire Line
	8900 5700 8300 5700
Wire Wire Line
	8300 5700 8300 5300
Connection ~ 8300 5300
Wire Wire Line
	8300 5300 8500 5300
Text Notes 9000 5550 0    50   ~ 0
Run  (open)
Text Notes 9000 5650 0    50   ~ 0
Shunt (closed)
Text Notes 8950 4400 0    50   ~ 0
Shutdown
Text Notes 8950 4700 0    50   ~ 0
Input BNC
Text Notes 9000 5200 0    50   ~ 0
Output
Wire Wire Line
	9900 1500 9900 4100
Wire Wire Line
	4700 3500 4700 6000
Wire Wire Line
	4500 4900 5450 4900
$Comp
L Device:LED_ALT D3
U 1 1 647B6900
P 3150 1300
F 0 "D3" H 3150 1050 50  0000 C CNN
F 1 "Red LED" H 3050 1150 50  0000 C CNN
F 2 "" H 3150 1300 50  0001 C CNN
F 3 "~" H 3150 1300 50  0001 C CNN
	1    3150 1300
	-1   0    0    1   
$EndComp
$Comp
L Device:R_US R3
U 1 1 647B69F0
P 2850 1300
F 0 "R3" V 3055 1300 50  0000 C CNN
F 1 "470" V 2964 1300 50  0000 C CNN
F 2 "" V 2890 1290 50  0001 C CNN
F 3 "~" H 2850 1300 50  0001 C CNN
	1    2850 1300
	0    -1   -1   0   
$EndComp
Text Notes 2900 1000 0    50   ~ 0
Power Indicator
Text Label 3550 2900 0    50   ~ 0
VPP
Text Label 3450 4100 0    50   ~ 0
VNN
Text Label 3600 3400 0    50   ~ 0
GND
Wire Wire Line
	3250 2900 3350 2850
Wire Wire Line
	3350 2850 3350 1500
Wire Wire Line
	3250 3100 3450 3050
Wire Wire Line
	3450 3050 3450 2900
Wire Wire Line
	3450 1300 3300 1300
Wire Wire Line
	3450 2900 3450 1300
Wire Wire Line
	3350 1500 2700 1500
Wire Wire Line
	2700 1300 2700 1500
Wire Wire Line
	3250 2900 3700 2900
Text Notes 3900 3000 0    50   ~ 0
Turret Strip -\nStar Ground and\nPower distribution
Text Notes 3500 1900 0    50   ~ 0
Twisted pair
Wire Notes Line
	5450 1250 5450 3050
Wire Notes Line
	5450 3050 7150 3050
Wire Notes Line
	7150 3050 7150 1250
Wire Notes Line
	5450 1250 7150 1250
Wire Notes Line
	5450 3650 5450 5450
Wire Notes Line
	5450 5450 7150 5450
Wire Notes Line
	7150 5450 7100 3650
Wire Notes Line
	5450 3650 7100 3650
Wire Notes Line
	1450 2700 1450 3300
Wire Notes Line
	1450 3300 3250 3300
Wire Notes Line
	3250 3300 3250 2700
Wire Notes Line
	3250 2700 1450 2700
Wire Notes Line
	1450 3700 1450 4300
Wire Notes Line
	1450 4300 3250 4300
Wire Notes Line
	3250 4300 3250 3700
Wire Notes Line
	3250 3700 1450 3700
Text Notes 6600 6100 0    50   ~ 0
Output:  +-1.0 A Full Scale, differential, 5 V compliance, cannot be grounded
Text Notes 6600 6200 0    50   ~ 0
Input:   +-1.0 V Full Scale, single ended
Text Notes 1750 2450 0    50   ~ 0
Switching power supplies, encapsulated
Text Notes 5600 900  0    50   ~ 0
Current Buffer custom circuit - PCB with\npower op-amp on back panel heat sink.
Text Notes 9300 1000 0    50   ~ 0
Enable both channels
Text Notes 4700 1600 0    50   ~ 0
Current Limit
Text Notes 1150 4800 0    50   ~ 0
Twisted pair
Wire Wire Line
	1000 5800 1000 4100
Connection ~ 1000 4100
Wire Wire Line
	1000 4100 1000 3100
Text Notes 6600 6300 0    50   ~ 0
Shutdown:  Illuminated indicates thermal shutdown or disabled (Hi-Z output)
Text Notes 6600 6400 0    50   ~ 0
Run/Shunt:  Should be closed (shunt) when no load is connected.
Text Notes 5000 3350 0    50   ~ 0
Short power leads, <50 mm
Text Notes 6600 6500 0    50   ~ 0
Frequency:  DC to 1 kHz (configurable low-pass filter)
$EndSCHEMATC
