#Persistent
CoordMode, Mouse, Screen
CoordMode, Tooltip, Screen
CoordMode, Pixel, Screen.

;==========================================================================
;Grava Arquivo INI
;==========================================================================
StringGetPos, OutputVar, A_ScriptName, .
  StringMid, title, A_ScriptName, 1 , OutputVar ; remove the AHK or EXE
  inifile:=title ".ini"
;-----------------------------------------------------------------------------------------
IniRead, Check1			, %inifile%, Radio			, Check1 		, 1 ;Default 1 
IniRead, Check2			, %inifile%, Radio			, Check2 		, 0 ;Default 0 
IniRead, Check3			, %inifile%, Radio			, Check3 		, 0 ;Default 0 
IniRead, Check4			, %inifile%, Radio			, Check4 		, 0 ;Default 0 
IniRead, Check5			, %inifile%, Radio			, Check5 		, 0 ;Default 0 
IniRead, Check6			, %inifile%, Radio			, Check6 		, 0 ;Default 0 

IniRead, Velo_Mouse		, %inifile%, Velo_Mouse		, Velo_Mouse 	, 500 ;Default 0 

IniRead, Skill1			, %inifile%, Skill			, Skill1 		, 0 ;Default 0 
IniRead, Skill2			, %inifile%, Skill			, Skill2 		, 0 ;Default 0 
IniRead, Skill3			, %inifile%, Skill			, Skill3 		, 0 ;Default 0 
IniRead, Skill4			, %inifile%, Skill			, Skill4 		, 0 ;Default 0

IniRead, Check10		, %inifile%, Skill			, Check10 		, 0 ;Default 0
IniRead, Check11		, %inifile%, Skill			, Check11 		, 0 ;Default 0
IniRead, Check12		, %inifile%, Skill			, Check12 		, 0 ;Default 0

IniRead, Check13		, %inifile%, Pegar_Itens	, Check13 		, 0 ;Default 0

IniRead, Int_1			, %inifile%, Intervalo		, Int_1 		, 0 ;Default 0 
IniRead, Int_2			, %inifile%, Intervalo		, Int_2			, 0 ;Default 0 
IniRead, Int_3			, %inifile%, Intervalo		, Int_3 		, 0 ;Default 0 



;-----------------------------------------------------------------------------------------
Loop 14
   {
    If (Check%A_Index% = 1)
       Check%A_Index% = Checked
    Else
       Check%A_Index% = 0
}
;-----------------------------------------------------------------------------------------
Gui, Color, FFFFF0, -Caption ToolWindow -0x400000
Gui, Show, w540 h223										, BOT DL | andkiko@ig.com.br | Configurado 1024X768
Gui, Add, Text, x476 y207 w60 h20 							, By Andkiko
Gui, Add, Text, x6 y207 w60 h20 							, Versão 2.0

Gui, Add, GroupBox, x6 y7 w260 h200 						, Movimento do Mouse
Gui, Add, Radio, x16 y57 w60 h30   vCheck1 %Check1%			, Vertical
Gui, Add, Radio, x86 y57 w70 h30   vCheck2 %Check2%			, Horizontal
Gui, Add, Radio, x16 y127 w60 h30  vCheck3 %Check3%			, Circulo
Gui, Add, Radio, x86 y127 w70 h30  vCheck4 %Check4%			, Aleatorio 1
Gui, Add, Radio, x176 y127 w70 h30 vCheck5 %Check5%			, Aleatorio 2
Gui, Add, Radio, x176 y57 w70 h30  vCheck6 %Check6%			, Estrela
Gui, Add, Picture, x16 y97 w50 h30 							, %A_WorkingDir%\data\Cir.jpg
Gui, Add, Picture, x96 y27 w50 h30 							, %A_WorkingDir%\data\Hor.jpg
Gui, Add, Picture, x96 y97 w50 h30 							, %A_WorkingDir%\data\Ran.jpg
Gui, Add, Picture, x16 y27 w50 h30 							, %A_WorkingDir%\data\Ver.jpg
Gui, Add, Picture, x186 y97 w50 h30 						, %A_WorkingDir%\data\ran2.jpg
Gui, Add, Picture, x186 y27 w50 h30 						, %A_WorkingDir%\data\est.jpg
Gui, Add, Edit, x16 y167 w40 h20  vVelo_Mouse 				, %Velo_Mouse%
Gui, Add, Text, x60 y170 w185 h20 							, Velocidade Mouse (1000 = 1 Segundo)

Gui, Add, GroupBox, x276 y7 w125 h200 						, Skills
Gui, Add, Text, x346 y37 w40 h20 							, Hotkey
Gui, Add, Text, x286 y57 w60 h20 							, Main Skill
;~ Gui, Add, DropDownList, x356 y-175 w-60 h212 			, DropDownList
Gui, Add, Edit, x346 y57 w40 h17       vSkill1 				, %Skill1%
Gui, Add, Edit, x346 y77 w40 h17       vSkill2 				, %Skill2%
Gui, Add, Edit, x346 y97 w40 h17       vSkill3 				, %Skill3%
Gui, Add, Edit, x346 y117 w40 h17      vSkill4 				, %Skill4%
Gui, Add, CheckBox, x286 y77 w60 h20   vCheck10 %Check10%	, Skill#2
Gui, Add, CheckBox, x286 y97 w60 h20   vCheck11 %Check11%	, Skill#3
Gui, Add, CheckBox, x286 y117 w60 h20  vCheck12 %Check12%	, Skill#4
Gui, Add, CheckBox, x286 y137 w100 h30 VCheck13 %Check13%	, Pegar Itens
;~ Gui, Add, Text, x306 y37 w50 h20 						, Intervalo
;~ Gui, Add, Text, x306 y57 w40 h20 						, [Sec]:
;~ Gui, Add, Edit, x306 y77 w40 h17  vInt_1 %Int_1%			, %Int_1%
;~ Gui, Add, Edit, x306 y97 w40 h17  vInt_2 %Int_2%			, %Int_2%
;~ Gui, Add, Edit, x306 y117 w40 h17 vInt_3 %Int_3%			, %Int_3%

Gui, Add, GroupBox, x412 y7 w120 h200 						, Instruções
Gui, Add, Text, x416 y37 w90 h20 cGreen +Right				, Iniciar = F5
Gui, Add, Text, x416 y57 w90 h20 cBlue +Right				, Pause = F6
Gui, Add, Text, x416 y97 w90 h20 +Right						, Fechar = F10
Gui, Add, Text, x416 y77 w90 h20 cRed +Right				, Salvar = F3


F3::
;GuiClose:      ;the placement of this label chooses the default behavior
Gui, Submit, NoHide
;-------------------------------------------------------------------------------------------------------------------------------
IniWrite, %Check1%		, %inifile%, Radio			, Check1
IniWrite, %Check2%		, %inifile%, Radio			, Check2
IniWrite, %Check3%		, %inifile%, Radio			, Check3 
IniWrite, %Check4%		, %inifile%, Radio			, Check4 
IniWrite, %Check5%		, %inifile%, Radio			, Check5 
IniWrite, %Check6%		, %inifile%, Radio			, Check6 

IniWrite, %Velo_Mouse%	, %inifile%, Velo_Mouse		, Velo_Mouse 	

IniWrite, %Skill1%		, %inifile%, Skill			, Skill1 
IniWrite, %Skill2%		, %inifile%, Skill			, Skill2
IniWrite, %Skill3%		, %inifile%, Skill			, Skill3 
IniWrite, %Skill4%		, %inifile%, Skill			, Skill4 

IniWrite, %Check10%		, %inifile%, Skill			, Check10 
IniWrite, %Check11%		, %inifile%, Skill			, Check11 
IniWrite, %Check12%		, %inifile%, Skill			, Check12

IniWrite, %Check13%		, %inifile%, Pegar_Itens	, Check13 
	
IniWrite, %Int_1%		, %inifile%, Intervalo		, Int_1 
IniWrite, %Int_2%		, %inifile%, Intervalo		, Int_2	
IniWrite, %Int_3%		, %inifile%, Intervalo		, Int_3 
	
Reload
Return

F5::
Gui, Submit, NoHide
If (Check1 = 1)
{
  Gosub, ver
}
If (Check2 = 1)
{
  Gosub, hor
}
If (Check3 = 1)
{
  Gosub, cir
}
If (Check4 = 1)
{
  Gosub, ran
}
If (Check5 = 1)
{
  Gosub, ran2
}
If (Check6 = 1)
{
  Gosub, est
}
Return

ver:
Gui, Submit, NoHide
If (Check12 = 1)
Send, {%Skill4% Down}{%Skill4% Up} ;Skill 4
If (Check11 = 1)
Send, {%Skill3% Down}{%Skill3% Up} ;Skill 3
If (Check10 = 1)
Send, {%Skill2% Down}{%Skill2% Up} ;Skill 2

Send, {%Skill1% Down}{%Skill1% Up} ;Skill 1
Loop 10
{
Click down, right,
MouseMove,  417,  322
Gosub opções
MouseMove,  417,  231
Gosub opções
MouseMove,  453,  317
Gosub opções
MouseMove,  451,  228
Gosub opções
MouseMove,  492,  320
Gosub opções
MouseMove,  492,  228
Gosub opções
MouseMove,  529,  318
Gosub opções
MouseMove,  529,  227
Gosub opções
MouseMove,  566,  320
Gosub opções
MouseMove,  566,  230
Gosub opções
MouseMove,  603,  318
Gosub opções
MouseMove,  605,  229
Gosub opções
Click up, right,
}
Gosub, ver
Return

hor:
Gui, Submit, NoHide
If (Check12 = 1)
Send, {%Skill4% Down}{%Skill4% Up} ;Skill 4
If (Check11 = 1)
Send, {%Skill3% Down}{%Skill3% Up} ;Skill 3
If (Check10 = 1)
Send, {%Skill2% Down}{%Skill2% Up} ;Skill 2

Send, {%Skill1% Down}{%Skill1% Up} ;Skill 1
Loop 10
{
Click down, right,
MouseMove,  421,  224
Gosub opções
MouseMove,  600,  225
Gosub opções
MouseMove,  420,  257
Gosub opções
MouseMove,  597,  255
Gosub opções
MouseMove,  422,  290
Gosub opções
MouseMove,  596,  288
Gosub opções
MouseMove,  421,  320
Gosub opções
MouseMove,  596,  322
Gosub opções
Click up, right,
}
Gosub, hor
Return

cir:
Gui, Submit, NoHide
If (Check12 = 1)
Send, {%Skill4% Down}{%Skill4% Up} ;Skill 4
If (Check11 = 1)
Send, {%Skill3% Down}{%Skill3% Up} ;Skill 3
If (Check10 = 1)
Send, {%Skill2% Down}{%Skill2% Up} ;Skill 2

Send, {%Skill1% Down}{%Skill1% Up} ;Skill 1
Loop 10
{
Click down, right,
MouseMove,  416,  223
Gosub opções
MouseMove,  601,  225
Gosub opções
MouseMove,  601,  321
Gosub opções
MouseMove,  415,  321
Gosub opções
MouseMove,  415,  255
Gosub opções
MouseMove,  567,  257
Gosub opções
MouseMove,  566,  290
Gosub opções
MouseMove,  456,  288
Gosub opções
Click up, right,
}
Gosub, cir
Return

ran:
Gui, Submit, NoHide
If (Check12 = 1)
Send, {%Skill4% Down}{%Skill4% Up} ;Skill 4
If (Check11 = 1)
Send, {%Skill3% Down}{%Skill3% Up} ;Skill 3
If (Check10 = 1)
Send, {%Skill2% Down}{%Skill2% Up} ;Skill 2

Send, {%Skill1% Down}{%Skill1% Up} ;Skill 1
Loop 10
{
Click down, right,
MouseMove,  416,  216
Gosub opções
MouseMove,  448,  310
Gosub opções
MouseMove,  515,  214
Gosub opções
MouseMove,  503,  340
Gosub opções
MouseMove,  609,  267
Gosub opções
MouseMove,  558,  224
Gosub opções
MouseMove,  591,  333
Gosub opções
MouseMove,  417,  216
Gosub opções
Click up, right,
}
Gosub, ran
Return

ran5:
Gui, Submit, NoHide
If (Check12 = 1)
Send, {%Skill4% Down}{%Skill4% Up} ;Skill 4
If (Check11 = 1)
Send, {%Skill3% Down}{%Skill3% Up} ;Skill 3
If (Check10 = 1)
Send, {%Skill2% Down}{%Skill2% Up} ;Skill 2

Send, {%Skill1% Down}{%Skill1% Up} ;Skill 1
Loop 10
{
Click down, right,
MouseMove,  410,  160
Gosub opções
MouseMove,  627,  421
Gosub opções
MouseMove,  410,  421
Gosub opções
MouseMove,  627,  160
Gosub opções
MouseMove,  410,  160
Gosub opções
MouseMove,  410,  420
Gosub opções
MouseMove,  627,  160
Gosub opções
MouseMove,  627,  417
Gosub opções
MouseMove,  410,  316
Gosub opções
MouseMove,  627,  316
Gosub opções
MouseMove,  410,  420
Gosub opções
MouseMove,  410,  160
Gosub opções
MouseMove,  627,  316
Gosub opções
MouseMove,  410,  316
Gosub opções
MouseMove,  627,  160
Click up, right,
}
Gosub, ran5
Return

ran2:
Gui, Submit, NoHide
If (Check12 = 1)
Send, {%Skill4% Down}{%Skill4% Up} ;Skill 4
If (Check11 = 1)
Send, {%Skill3% Down}{%Skill3% Up} ;Skill 3
If (Check10 = 1)
Send, {%Skill2% Down}{%Skill2% Up} ;Skill 2

Send, {%Skill1% Down}{%Skill1% Up} ;Skill 1
Loop 10
{
  Random, x, 300, 700 
  Random, y, 150, 400 
  MouseMove, %x%, %y%, 0
Click, Right Down
Click, Right up

}
Gosub, ran2
Return

est:
Gui, Submit, NoHide
If (Check12 = 1)
Send, {%Skill4% Down}{%Skill4% Up} ;Skill 4
If (Check11 = 1)
Send, {%Skill3% Down}{%Skill3% Up} ;Skill 3
If (Check10 = 1)
Send, {%Skill2% Down}{%Skill2% Up} ;Skill 2

Send, {%Skill1% Down}{%Skill1% Up} ;Skill 1
Loop 10
{
Click down, right,
MouseMove,  410,  351
Gosub opções
MouseMove,  510,  170
Gosub opções
MouseMove,  620,  350
Gosub opções
MouseMove,  410,  244
Gosub opções
MouseMove,  620,  244
Gosub opções
MouseMove,  410,  351
Click up, right,
}
Gosub, est
Return

opções:
Gui, Submit, NoHide
	If (Check13 = 1) ;Espaço
		Send, {space Down} {space Up}
	Sleep, %Velo_Mouse%
Return

F6::Pause

F10::ExitApp

GuiClose:
ExitApp