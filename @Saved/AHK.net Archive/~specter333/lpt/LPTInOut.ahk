/*
Parallel Port Monitor and Controller.
LTP port two way communication.
Use buttons or switches for AHK script input and control LEDs or Relays from the outputs.

http://www.autohotkey.com/forum/viewtopic.php?p=525428

The DLL calls were found in the AHK German forumns.
http://de.autohotkey.com/forum/topic5559.html

LPTInOut_Out(num,port) ; num is the value relating to the pins to activate.  port is the port address.
; This function must be called independently for the first eight and last four pins as they will be 
; on two different addresses.

LPTInOut_In(port) ; port is the port address.  Use a timer to constantly check the value present at this port.

LPTInOut_Off(LPTA,LPTB) ; LPTA is the port number of pins 1 thru 8 and LPTB 9 thru 16.
LPTInOut_On(LPTA,LPTB) ; These functions need only be called once to controls all 12 pins.

Detailed information can be found below the functions.
*/

; Out

LPTInOut_Out(num,port)
	{
	DllCall("INPOUT32\Out32",int,port,int,num)
	}


; In

LPTInOut_In(port)
	{
	LTPmon := DllCall("INPOUT32\Inp32",int,Port)
	Return, %LTPmon%
	}


; All Off

LPTInOut_Off(LPTA,LPTB)
	{
	DllCall("INPOUT32\Out32",int,LPTA,int,0)
	DllCall("INPOUT32\Out32",int,LPTB,int,11)
	}

	
; All On

LPTInOut_On(LPTA,LPTB)
	{
	DllCall("INPOUT32\Out32",int,LPTA,int,255)
	DllCall("INPOUT32\Out32",int,LPTB,int,20)
	}


/*
The parallel connector.  
This chart identifies the pin numbers as seen on the computer port. 

S4  S5  S7  S6  D7  D6  D5  D4  D3  D2  D1  D0  C0
  G7  G6  G5  G4  G3  G2  G1  G0  C3  C2  S3  C1
  
S = Status or input pins.
D = Data or output pins 1 thru 8.
C = Combo or output pins 9 thru 12, in some cases these can be used as inputs.
G = Ground pins.

Each LPT port will have three address, the first is for the first eight inputs, D0 thru D7.
The second for the last four inputs, C0 thru C3. The third for the inputs S3 thru S7.  
Note that S0 thru S2 are not included on the connecter.

The typical addresses for LPT1 are,
0x378 for output pins 1 thru 8 or D0 thru D7.
0x37A for output pins 9 thru 12 or C0 thru C3.
0x379 for input pins 1 thru 5 or S3 thru S7.
These may be different on some systems.
*/	
	
/*
LPTInOut_In(port)
Use a timer to constantly monitor the input pins 1 thru 5 (S3 thru S7).  
A value will always be presentz when monitoring, if no pins are activated it will read 120.

-------------------------------------------------------------------------------------------
Here is a short monitoring example script.

^m::
SetTimer, Monitor, 250
Return

Monitor:
lptin := LPTInOut_In("0x379")  ; This is the typical address for LPT1.

If lptin = %LastRead%  ;  Keeps the script from running the associated subroutine everytime the timer runs.
	Return             ;  The subroutine only runs when a new input value is read.

LastRead = %lptin%  ;  Remembers the last input value for above.
	
If IsLabel(lptin)
	GoTo %lptin%
Return


112:
MsgBox, Pin 1(S3) has been activated.
Return

128:
MsgBox, All 5 input pins have been activated.
Return
-------------------------------------------------------------------------------------------


This chart shows the avallable input values and the combination of pins needed to set them.


		
		1		2		3		4		5
		S3		S4		S5		S6		S7
0 = 	x		x		x		x						S3 S4 S5 S6
8 = 			x		x		x						S4 S5 S6
16 = 	x				x		x						S3 S5 S6
24 =					x		x						S5 S6
32 = 	x		x				x						S3 S4 S6
40 = 			x				x						S4 S6
48 = 	x						x						S3 S6
56 = 							x						S6
64 = 	x		x		x								S3 S4 S5
72 = 			x		x								S4 S5
80 = 	x				x								S3 S5
88 = 					x								S5
96 = 	x		x										S3 S4
104 = 			x										S4
112 = 	x												S3
120 = 										All Open
128 = 	x		x		x		x		x	All Active	S3 S4 S5 S6 S7
136 = 			x		x		x		x				S4 S5 S6 S7
144 = 	x				x		x		x				S3 S5 S6 S7
152 = 					x		x		x				S5 S6 S7
160 = 	x		x				x		x				S3 S4 S6 S7
168 = 			x				x		x				S4 S6 S7
176 = 	x						x		x				S3 S6 S7
184 = 							x		x				S6 S7
192 = 	x		x		x				x				S3 S4 S5 S7
200 = 			x		x				x				S4 S5 S7
208 = 	x				x				x				S3 S5 S7
216 = 					x				x				S5 S7
224 = 	x		x						x				S3 S4 S7
232 = 			x						x				S4 S7
240 = 	x								x				S3 S7
248 = 									x				S7
*/


/*
LPTInOut_Out(num,port) Pins 1 thru 8 (D0 thru D7).

Each of the first eight ouput pins are assigned a value shown in this chart.
Pin 1(D0) = 1
Pin 2(D1) = 2
Pin 3(D2) = 4
Pin 4(D3) = 8
Pin 5(D4) = 16
Pin 6(D5) = 32
Pin 7(D6) = 64
Pin 8(D7) = 128

To activate any single pin simply call it's value and the LPT port address.
LPTInOut_Out(1,"0x378") This activates pin 1(D0) on LPT1. 

To activate multiple pins, add their values together.
LPTInOut_Out(3,"0x378")  This activates pins 1(D0) and 2(D1) on LPT1.

To deactivate all eight pins use the value O.
LPTInOut_Out(0,"0x378")
*/


/*
LPTInOut_Out(num,port) Pins 9 thru 12
These pins behave differently as some of them are normally hot meaning they are active until they receive a value
that deactivates them.  For this reason they can not be controled by adding their values.  Instead call a value
from this chart.

		C0		C1		C2		C3
		9		10		11		12
1				x				x		
2		x						x
3								x
5				x		x		x
6		x				x		x
7						x		x	
8 		x		x
9				x
10		x	
11 									All Off
12		x		x		x
13				x		x
14		x				x
15						x
16		x		x				x


20		x		x		x		x	All On


Example
LPTInOut_Out(8,"0x379")  This activates pins 9(C0) and 10(C1) on LPT1.


You should also use the ALL Off call in the autoexecute section of your scripts to have all pins
start in the off state.
LPTInOut_Out(11,"0x379")  Deactivates pins 9(C0) thru 12(C3) on LPT1.
or
LPTInOut_Off("0x378","0x37A")   Deactivates all output pins on LPT1.
*/

