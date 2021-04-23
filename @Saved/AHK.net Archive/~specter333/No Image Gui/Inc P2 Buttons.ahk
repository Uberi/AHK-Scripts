

P2ButtonsAdd:
Gui, Font, s18 c9d9dff,LCARS

SysGet, MonNum, MonitorCount
SysGet, MonPri, MonitorPrimary
SysGet, Mon1Name, MonitorName, 1 
SysGet, Mon1Specs, Monitor, 1
MonW := Mon1SpecsLeft+Mon1SpecsRight
MonH := Mon1SpecsTop+Mon1SpecsBottom
StringReplace, MonW, MonW, -, , A
StringReplace, MonH, MonH, -, , A
Gui, Add, Text, x110 y400 Hidden vMonNum, Monitors: %MonNum%
Gui, Add, Text, x325 y400 Hidden vMonPri, Primary Monitor: %MonPri%
Gui, Add, Text, x110 y430 Hidden vMon1Res, Monitor 1 Resolution: %MonW% X %MonH%
Gui, Add, Text, x325 y430 Hidden vMon1Name, Monitor 1 Name: %Mon1Name%
If MonNum >= 2
	{
	SysGet, Mon2Name, MonitorName, 2
	SysGet, Mon2Specs, Monitor, 2
	Mon2W := Mon2SpecsLeft+Mon2SpecsRight
	Mon2H := Mon2SpecsTop+Mon2SpecsBottom
	StringReplace, Mon2W, Mon2W, -, , A
	StringReplace, Mon2H, Mon2H, -, , A
	Gui, Add, Text, x325 y460 Hidden vMon2Name, Monitor 2 Name: %Mon2Name%
	Gui, Add, Text, x110 y460 Hidden vMon2Res, Monitor 2 Resolution: %Mon2W% X %Mon2H%
	}
If MonNum >= 2
	{
	SysGet, Mon3Name, MonitorName, 3
	SysGet, Mon3Specs, Monitor, 3
	Mon3W := Mon3SpecsLeft+Mon3SpecsRight
	Mon3H := Mon3SpecsTop+Mon3SpecsBottom
	StringReplace, Mon3W, Mon3W, -, , A
	StringReplace, Mon3H, Mon3H, -, , A
	Gui, Add, Text, x325 y490 Hidden vMon3Name, Monitor 3 Name: %Mon3Name%
	Gui, Add, Text, x110 y490 Hidden vMon3Res, Monitor 3 Resolution: %Mon3W% X %Mon3H%
	}
If MonNum >= 2
	{
	SysGet, Mon4Name, MonitorName, 4
	SysGet, Mon4Specs, Monitor, 4
	Mon4W := Mon4SpecsLeft+Mon4SpecsRight
	Mon4H := Mon4SpecsTop+Mon4SpecsBottom
	StringReplace, Mon4W, Mon4W, -, , A
	StringReplace, Mon4H, Mon4H, -, , A
	Gui, Add, Text, x325 y520 Hidden vMon4Name, Monitor 4 Name: %Mon4Name%
	Gui, Add, Text, x110 y520 Hidden vMon4Res, Monitor 4 Resolution: %Mon4W% X %Mon4H%
	}
Return


P2ButtonsShow:
GoSub HideOutWindows
OSText = Operating System: %A_OSVersion%
CompName = Computer Name: %A_ComputerName%
UserName = User Name: %A_UserName%

If A_IsAdmin = 1
	IsAd = Yes
Else IsAd = No
AdminYorN = Administrator Rights: %IsAd%
GoSub GetLang
the_language := languageCode_%A_Language% 
SysLang = Language: %the_language%
ButtonClass_B(73,UserName,"fe9d00","150","125",GuiName,"0x20004",100,"LCARS","Center",22,"Black",0,-2)
ButtonClass_B(74,AdminYorN,"fe9d00","150","165",GuiName,"0x20004",100,"LCARS","Center",22,"Black",0,-2)
ButtonClass_B(75,CompName,"9d9dff","150","205",GuiName,"0x20004",100,"LCARS","Center",22,"Black",0,-2)
ButtonClass_B(76,OSText,"9d9dff","150","245",GuiName,"0x20004",100,"LCARS","Center",22,"Black",0,-2)
ButtonClass_B(77,SysLang,"9d9dff","150","285",GuiName,"0x20004",100,"LCARS","Center",22,"Black",0,-2)

;;;;;;;;;;;;;;;;;;;;;;;    Circle frame
Loop, 65
	{
	Amount := 65-A_Index
	WinSet, Region, 0-0 w76 h%Amount%, Area53
	}
Gui, 53:Destroy
Loop, 185
	{
	Amount := 230-A_Index
	WinSet, Region, 0-0 w75 h%Amount%, Area85
	
	}
GuiControl, 85:Move, Text85, y15

ButtonClass_X(78,"","ffcc66",10,"350",GuiName,"0x20008",250,"LCARS","Center",22,"Black",0,10)
ButtonClass_M(80,"","ffcc66",10,"350","20","20",GuiName,"0x20001",10,"LCARS","Center",22,"Black",0,10) ;;;;;;;; Circle Frame

ButtonClass_M(90,"","ffcc66",115,"350","370","35",GuiName,"0x20001",150,"LCARS","Center",22,"Black",0,10) ;;;;;;;; Circle Frame
ButtonClass_Y(91,"","ffcc66",490,"350",GuiName,"0x20004",150,"LCARS","Center",22,"Black",0,10)
ButtonClass_W(93,"","ffcc66",490,490,GuiName,"0x20004",150,"LCARS","Center",22,"Black",0,10)
ButtonClass_M(92,"","ffcc66",115,555,"370","35",GuiName,"0x20002",150,"LCARS","Left",22,"Black",5,5)
ButtonClass_Z(53,"","ffcc66",10,"490",GuiName,"0x20008",150,"LCARS","Left",16,"Black",45,75)

ButtonClass_M(10,"","cd9bd0",10,"455","35","30",GuiName,"0x20001",100,"LCARS","Center",22,"Black",0,10) ;;;;;;;; Circle Frame
ButtonClass_M(11,"","cd9bd0",555,"455","35","30",GuiName,"0x20002",100,"LCARS","Center",22,"Black",0,10) ;;;;;;;; Circle Frame

GoSub P2Docks

GuiControl, 1:Show, MonNum
Sleep, 100
GuiControl, 1:Show, MonPri
Sleep, 100
SysGet, MonCount, MonitorCount
Loop, %MonCount%
	{
	GuiControl, 1:Show, Mon%A_Index%Name
	GuiControl, 1:Show, Mon%A_Index%Res
	Sleep, 100
	}
Return

P2ButtonsOut:
GuiControl, 1:Hide, MonNum
Sleep, 100
GuiControl, 1:Hide, MonPri
Sleep, 100
SysGet, MonCount, MonitorCount
Loop, %MonCount%
	{
	GuiControl, 1:Hide, Mon%A_Index%Name
	GuiControl, 1:Hide, Mon%A_Index%Res
	Sleep, 100
	}

ButtonClass_M(12,"","Black",5,350,590,250,GuiName,"0x20008",1000,"LCARS","Center",22,"Black",0,10) ;;;;;;;; Circle Frame
	
Gui, 78:Destroy
Gui, 90:Destroy
Gui, 91:Destroy
Gui, 93:Destroy
Gui, 92:Destroy
Gui, 53:Destroy
Gui, 80:Destroy

Gui, 10:Destroy
Gui, 11:Destroy
Gui, 12:Destroy
ButtonClass_M(79,"","ffcc66","10","300","75","45",GuiName,"0x20004",10,"LCARS","Center",22,"Black",0,200)

Sleep, 100
Gui, 77:Destroy
Sleep, 100
Gui, 76:Destroy
Sleep, 100
Gui, 75:Destroy
Sleep, 100
Gui, 74:Destroy
Sleep, 100
Gui, 73:Destroy
Gui, 85:Destroy
ButtonClass_M(85,"000","ffcc66","10","300","75","230",GuiName,"0x20004",400,"LCARS","Center",22,"Black",0,200)
ButtonClass_J(53,"","ffcc66","10","535",GuiName,"0x20004",200,"LCARS","Center",16,"Black",0,5)

WinGet, IDG1, ID, Non Image - Image Gui
WinGet, IDG53, ID, Area53
WinGet, IDG85, ID, Area85
DockA(IDG1, IDG53, "x(.018) y(.892) w() h()")
DockA(IDG1, IDG85, "x(.017) y(.499) w() h()")
Gui, 79:Destroy
Return

P2Docks:
WinGet, IDG1, ID, Non Image - Image Gui

WinGet, IDG10, ID, Area10
WinGet, IDG11, ID, Area11

WinGet, IDG53, ID, Area53
WinGet, IDG73, ID, Area73
WinGet, IDG74, ID, Area74
WinGet, IDG75, ID, Area75
WinGet, IDG76, ID, Area76
WinGet, IDG77, ID, Area77
WinGet, IDG78, ID, Area78

WinGet, IDG80, ID, Area80
WinGet, IDG85, ID, Area85

WinGet, IDG90, ID, Area90
WinGet, IDG91, ID, Area91
WinGet, IDG92, ID, Area92
WinGet, IDG93, ID, Area93

DockA(IDG1, IDG10, "x(.017) y(.758) w() h()")
DockA(IDG1, IDG11, "x(.926) y(.758) w() h()")
DockA(IDG1, IDG53, "x(.017) y(.816) w() h()")

DockA(IDG1, IDG73, "x(.25) y(.21) w() h()")
DockA(IDG1, IDG74, "x(.25) y(.275) w() h()")
DockA(IDG1, IDG75, "x(.25) y(.343) w() h()")
DockA(IDG1, IDG76, "x(.25) y(.411) w() h()")
DockA(IDG1, IDG77, "x(.25) y(.478) w() h()")

DockA(IDG1, IDG78, "x(.017) y(.583) w() h()")
DockA(IDG1, IDG80, "x(.017) y(.583) w() h()")

DockA(IDG1, IDG90, "x(.193) y(.583) w() h()")
DockA(IDG1, IDG91, "x(.818) y(.583) w() h()")
DockA(IDG1, IDG92, "x(.193) y(.924) w() h()")
DockA(IDG1, IDG93, "x(.818) y(.816) w() h()")
Return

GetLang:
languageCode_0436 = Afrikaans
languageCode_041c = Albanian
languageCode_0401 = Arabic_Saudi_Arabia
languageCode_0801 = Arabic_Iraq
languageCode_0c01 = Arabic_Egypt
languageCode_0401 = Arabic_Saudi_Arabia
languageCode_0801 = Arabic_Iraq
languageCode_0c01 = Arabic_Egypt
languageCode_1001 = Arabic_Libya
languageCode_1401 = Arabic_Algeria
languageCode_1801 = Arabic_Morocco
languageCode_1c01 = Arabic_Tunisia
languageCode_2001 = Arabic_Oman
languageCode_2401 = Arabic_Yemen
languageCode_2801 = Arabic_Syria
languageCode_2c01 = Arabic_Jordan
languageCode_3001 = Arabic_Lebanon
languageCode_3401 = Arabic_Kuwait
languageCode_3801 = Arabic_UAE
languageCode_3c01 = Arabic_Bahrain
languageCode_4001 = Arabic_Qatar
languageCode_042b = Armenian
languageCode_042c = Azeri_Latin
languageCode_082c = Azeri_Cyrillic
languageCode_042d = Basque
languageCode_0423 = Belarusian
languageCode_0402 = Bulgarian
languageCode_0403 = Catalan
languageCode_0404 = Chinese_Taiwan
languageCode_0804 = Chinese_PRC
languageCode_0c04 = Chinese_Hong_Kong
languageCode_1004 = Chinese_Singapore
languageCode_1404 = Chinese_Macau
languageCode_041a = Croatian
languageCode_0405 = Czech
languageCode_0406 = Danish
languageCode_0413 = Dutch_Standard
languageCode_0813 = Dutch_Belgian
languageCode_0409 = English_United_States
languageCode_0809 = English_United_Kingdom
languageCode_0c09 = English_Australian
languageCode_1009 = English_Canadian
languageCode_1409 = English_New_Zealand
languageCode_1809 = English_Irish
languageCode_1c09 = English_South_Africa
languageCode_2009 = English_Jamaica
languageCode_2409 = English_Caribbean
languageCode_2809 = English_Belize
languageCode_2c09 = English_Trinidad
languageCode_3009 = English_Zimbabwe
languageCode_3409 = English_Philippines
languageCode_0425 = Estonian
languageCode_0438 = Faeroese
languageCode_0429 = Farsi
languageCode_040b = Finnish
languageCode_040c = French_Standard
languageCode_080c = French_Belgian
languageCode_0c0c = French_Canadian
languageCode_100c = French_Swiss
languageCode_140c = French_Luxembourg
languageCode_180c = French_Monaco
languageCode_0437 = Georgian
languageCode_0407 = German_Standard
languageCode_0807 = German_Swiss
languageCode_0c07 = German_Austrian
languageCode_1007 = German_Luxembourg
languageCode_1407 = German_Liechtenstein
languageCode_0408 = Greek
languageCode_040d = Hebrew
languageCode_0439 = Hindi
languageCode_040e = Hungarian
languageCode_040f = Icelandic
languageCode_0421 = Indonesian
languageCode_0410 = Italian_Standard
languageCode_0810 = Italian_Swiss
languageCode_0411 = Japanese
languageCode_043f = Kazakh
languageCode_0457 = Konkani
languageCode_0412 = Korean
languageCode_0426 = Latvian
languageCode_0427 = Lithuanian
languageCode_042f = Macedonian
languageCode_043e = Malay_Malaysia
languageCode_083e = Malay_Brunei_Darussalam
languageCode_044e = Marathi
languageCode_0414 = Norwegian_Bokmal
languageCode_0814 = Norwegian_Nynorsk
languageCode_0415 = Polish
languageCode_0416 = Portuguese_Brazilian
languageCode_0816 = Portuguese_Standard
languageCode_0418 = Romanian
languageCode_0419 = Russian
languageCode_044f = Sanskrit
languageCode_081a = Serbian_Latin
languageCode_0c1a = Serbian_Cyrillic
languageCode_041b = Slovak
languageCode_0424 = Slovenian
languageCode_040a = Spanish_Traditional_Sort
languageCode_080a = Spanish_Mexican
languageCode_0c0a = Spanish_Modern_Sort
languageCode_100a = Spanish_Guatemala
languageCode_140a = Spanish_Costa_Rica
languageCode_180a = Spanish_Panama
languageCode_1c0a = Spanish_Dominican_Republic
languageCode_200a = Spanish_Venezuela
languageCode_240a = Spanish_Colombia
languageCode_280a = Spanish_Peru
languageCode_2c0a = Spanish_Argentina
languageCode_300a = Spanish_Ecuador
languageCode_340a = Spanish_Chile
languageCode_380a = Spanish_Uruguay
languageCode_3c0a = Spanish_Paraguay
languageCode_400a = Spanish_Bolivia
languageCode_440a = Spanish_El_Salvador
languageCode_480a = Spanish_Honduras
languageCode_4c0a = Spanish_Nicaragua
languageCode_500a = Spanish_Puerto_Rico
languageCode_0441 = Swahili
languageCode_041d = Swedish
languageCode_081d = Swedish_Finland
languageCode_0449 = Tamil
languageCode_0444 = Tatar
languageCode_041e = Thai
languageCode_041f = Turkish
languageCode_0422 = Ukrainian
languageCode_0420 = Urdu
languageCode_0443 = Uzbek_Latin
languageCode_0843 = Uzbek_Cyrillic
languageCode_042a = Vietnamese
Return

