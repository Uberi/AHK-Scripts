P1ButtonsIn: ;;;;; Navigation Page, most buttons have not been assigned a command
;;;;;;;;;;;;;;;;;; Add new G-Labels to the bottom of "Inc Commands.ahk script 

;;;;;;;;;;;;;;;;;;;;;;;    Circle frame
ButtonClass_M(90,"","ffcc66","90","350","370","35",GuiName,"0x20001",100,"LCARS","Center",22,"Black",0,10) ;;;;;;;; Circle Frame
ButtonClass_Y(91,"","ffcc66","490","350",GuiName,"0x20004",125,"LCARS","Center",22,"Black",0,10)
ButtonClass_W(93,"","ffcc66","490","480",GuiName,"0x20004",125,"LCARS","Center",22,"Black",0,10)
ButtonClass_M(92,"","ffcc66","90","545","370","35",GuiName,"0x20002",100,"LCARS","Left",22,"Black",5,5)

;;;;;;;;;;;;;;;;;;;;;;;    Top Buttons
ButtonClass_A(21,"Reload","fe9d00",111,99,150,50,GuiName,"0x16",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_A(22,"Help","cd9bd0","276","99",150,50,GuiName,"0x16",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_A(23,"9d9dff","9d9dff","441","99",150,50,GuiName,"0x16",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_A(24,"FireFox","cd9bd0","111","159",150,50,GuiName,"0x16",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_A(25,"AHK Forum","9d9dff","276","159",150,50,GuiName,"0x16",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_A(26,"Area6","ffcc66","441","159",150,50,GuiName,"0x16",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_A(27,"Area7","fe9d00","111","219",150,50,GuiName,"0x16",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_A(28,"Area8","ffcc66","276","219",150,50,GuiName,"0x16",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_A(29,"Area9","c45b58","441","219",150,50,GuiName,"0x16",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_A(30,"Area10","ffcc66","111","279",150,50,GuiName,"0x16",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_A(31,"Area11","9d9dff","276","279",150,50,GuiName,"0x16",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_A(32,"Area12","fe9d00","441","279",150,50,GuiName,"0x16",100,"LCARS","Center",22,"Black",0,10)

;;;;;;;;;;;;;;      Buttons as part of cirle frame
ButtonClass_M(57,"","fe9d00","465","350","20","35",GuiName,"0x20004",100,"LCARS","Center",22,"Black",0,10) 
ButtonClass_M(58,"","fe9d00","555","455","35","20",GuiName,"0x20002",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_M(59,"","fe9d00","465","545","20","35",GuiName,"0x20008",100,"LCARS","Center",22,"Black",0,10) ;;;;;;

;;;;;;;;;;;;;;;     The Circle
ButtonClass_P(61,"","9d9dff","400","390",GuiName,"0x2000a",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_R(63,"","9d9dff","490","390",GuiName,"0x20009",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_O(68,"","9d9dff","490","480",GuiName,"0x20005",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_U(66,"","9d9dff","400","480",GuiName,"0x20006",100,"LCARS","Center",22,"Black",0,10)

ButtonClass_Q(62,"","cd9bd0","465","390",GuiName,"0x20004",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_T(65,"","cd9bd0","500","455",GuiName,"0x20002",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_V(67,"","cd9bd0","465","490",GuiName,"0x20008",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_S(64,"","cd9bd0","400","455",GuiName,"0x20009",100,"LCARS","Center",22,"Black",0,10)
; Center Button
ButtonClass_N(60,"0","fe9d00","451","440",GuiName,"0x16",100,"LCARS","Left",22,"Black",19,10) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 
;;;;;;;;;;;;;;;;    In the circle frame
ButtonClass_A(95,"0110 00111011 0110 001001 00001 1101110 0010 1101","cd9bd0","200","395","90","90",GuiName,"0x16",100,"LCARS","Center",14,"Black",0,5)
ButtonClass_A(94,"111101 101011 1100 11100 000100 11001 11111 10010","9d9dff","100","395","90","90",GuiName,"0x20002",100,"LCARS","Center",14,"Black",0,5)
ButtonClass_A(96,"1000100 110 001101 10110 1111 0111 0011 1001 1l1100","9d9dff","300","395","90","90",GuiName,"0x20001",100,"LCARS","Center",14,"Black",0,5)

ButtonClass_A(97,"","c45b58","100","495","40","40",GuiName,"0x20001",50,"LCARS","Center",22,"Black",0,10)
ButtonClass_M(99,"","c45b58","120","495","250","39",GuiName,"0x20001",100,"LCARS","Center",22,"Black",0,10)
ButtonClass_A(98,"","c45b58","350","495","40","40",GuiName,"0x20001",50,"LCARS","Center",22,"Black",0,10) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GoSub P1ButtonDocks
Return

P1ButtonsOut:
ButtonClass_M(79,"","Black",110,95,485,245,GuiName,"0x40004",500,"Lcars","Left")
WinGet, IDG79, ID, Area79
DockA(IDG1, IDG79, "x(.185) y(.158) w() h()")
ButtonClass_M(80,"","Black",90,340,505,250,GuiName,"0x40004",500,"Lcars","Left")
WinGet, IDG80, ID, Area80
DockA(IDG1, IDG80, "x(.151) y(.565) w() h()")
Loop, 12
	{
	WinNum := A_Index+20
	Gui, %WinNum%:Destroy
	}
Loop, 12
	{
	WinNum := A_Index+56
	Gui, %WinNum%:Destroy
	}
Loop, 10
	{
	WinNum := A_Index+89
	Gui, %WinNum%:Destroy
	}
Return

HideOutWindows:
Loop, 250
	{
	SetReg := 250-A_Index
	WinSet, Region, 0-0 w505 h%SetReg%, Area80
	}
Loop, 245
	{
	SetReg := 245-A_Index
	WinSet, Region, 0-0 w485 h%SetReg%, Area79
	}
Gui, 79:Destroy
Gui, 80:Destroy
Return

P1ButtonDocks:
WinGet, IDG1, ID, Non Image - Image Gui

WinGet, IDG21, ID, Area21
WinGet, IDG22, ID, Area22
WinGet, IDG23, ID, Area23
WinGet, IDG24, ID, Area24
WinGet, IDG25, ID, Area25
WinGet, IDG26, ID, Area26
WinGet, IDG27, ID, Area27
WinGet, IDG28, ID, Area28
WinGet, IDG29, ID, Area29
WinGet, IDG30, ID, Area30
WinGet, IDG31, ID, Area31
WinGet, IDG32, ID, Area32

WinGet, IDG57, ID, Area57
WinGet, IDG58, ID, Area58
WinGet, IDG59, ID, Area59

WinGet, IDG60, ID, Area60
WinGet, IDG61, ID, Area61
WinGet, IDG62, ID, Area62
WinGet, IDG63, ID, Area63
WinGet, IDG64, ID, Area64
WinGet, IDG65, ID, Area65
WinGet, IDG66, ID, Area66
WinGet, IDG67, ID, Area67
WinGet, IDG68, ID, Area68

WinGet, IDG90, ID, Area90
WinGet, IDG91, ID, Area91
WinGet, IDG92, ID, Area92
WinGet, IDG93, ID, Area93

WinGet, IDG94, ID, Area94
WinGet, IDG95, ID, Area95
WinGet, IDG96, ID, Area96
WinGet, IDG97, ID, Area97
WinGet, IDG98, ID, Area98
WinGet, IDG99, ID, Area99

DockA(IDG1, IDG21, "x(.185) y(.165) w() h()")
DockA(IDG1, IDG22, "x(.46) y(.165) w() h()")
DockA(IDG1, IDG23, "x(.735) y(.165) w() h()")
DockA(IDG1, IDG24, "x(.185) y(.265) w() h()")
DockA(IDG1, IDG25, "x(.46) y(.265) w() h()")
DockA(IDG1, IDG26, "x(.735) y(.265) w() h()")
DockA(IDG1, IDG27, "x(.185) y(.365) w() h()")
DockA(IDG1, IDG28, "x(.46) y(.365) w() h()")
DockA(IDG1, IDG29, "x(.735) y(.365) w() h()")
DockA(IDG1, IDG30, "x(.185) y(.465) w() h()")
DockA(IDG1, IDG31, "x(.46) y(.465) w() h()")
DockA(IDG1, IDG32, "x(.735) y(.465) w() h()")

DockA(IDG1, IDG57, "x(.775) y(.584) w() h()")
DockA(IDG1, IDG58, "x(.925) y(.759) w() h()")
DockA(IDG1, IDG59, "x(.775) y(.909) w() h()")

DockA(IDG1, IDG60, "x(.753) y(.734) w() h()")
DockA(IDG1, IDG61, "x(.667) y(.651) w() h()")
DockA(IDG1, IDG62, "x(.775) y(.651) w() h()") 
DockA(IDG1, IDG63, "x(.817) y(.651) w() h()")
DockA(IDG1, IDG64, "x(.667) y(.759) w() h()") 
DockA(IDG1, IDG65, "x(.834) y(.759) w() h()")
DockA(IDG1, IDG66, "x(.667) y(.8) w() h()")
DockA(IDG1, IDG67, "x(.775) y(.818) w() h()") 
DockA(IDG1, IDG68, "x(.817) y(.8) w() h()")

DockA(IDG1, IDG90, "x(.15) y(.584) w() h()")
DockA(IDG1, IDG91, "x(.817) y(.584) w() h()")
DockA(IDG1, IDG92, "x(.15) y(.909) w() h()")
DockA(IDG1, IDG93, "x(.817) y(.8) w() h()")

DockA(IDG1, IDG94, "x(.167) y(.659) w() h()")
DockA(IDG1, IDG95, "x(.334) y(.659) w() h()")
DockA(IDG1, IDG96, "x(.5) y(.659) w() h()")
DockA(IDG1, IDG97, "x(.167) y(.825) w() h()")
DockA(IDG1, IDG98, "x(.584) y(.825) w() h()")
DockA(IDG1, IDG99, "x(.2) y(.825) w() h()")
Return

