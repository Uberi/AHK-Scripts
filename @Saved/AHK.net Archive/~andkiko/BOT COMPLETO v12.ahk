;~ RefreshTrayTip:
;TrayTip, Autobot v1.0,  + = Pega Itens e bot? direito Fixo `nF5 = Pega Itens e bot? direito `nF6 = Pause `nF8 = Buff Elfa e Party 5 char `nF9 = Combo `nF10 = Sair (Fecha o BOT) `n `nConfigurado para 1024x768 `n `nBy Andkiko - Tempestade, 0
;~ return

;~ SetTimer, RefreshTrayTip, 1000
;~ Gosub, RefreshTrayTip  ; Call it once to get it started right away.
;~ return
#Persistent
CoordMode, Mouse, Screen
CoordMode, Tooltip, Screen
CoordMode, Pixel, Screen

;~ ;Ativa janela do Mu com Windows Mode
;~ WinWait, ????? http://cesdn.net ????, 
;~ IfWinNotActive, ????? http://cesdn.net ????, , WinActivate, ????? http://cesdn.net ????, 
;~ WinWaitActive, ????? http://cesdn.net ????, 

;==========================================================================
;Grava Arquivo INI
;==========================================================================
StringGetPos, OutputVar, A_ScriptName, .
  StringMid, title, A_ScriptName, 1 , OutputVar ; remove the AHK or EXE
  inifile:=title ".ini"
;-----------------------------------------------------------------------------------------
IniRead, Pxq			, %inifile%, Cordenada			, Pxq 			, 289 ;Default 289  Cordenada X Bola Vermelha
IniRead, Pyq			, %inifile%, Cordenada			, Pyq 			, 738 ;Default 738  Cordenada Y Bola Vermelha
IniRead, Corq			, %inifile%, Cordenada			, Corq 			, 0xABADF3 ;Default 0xABADF3 Cor Bola Vermelha
;-----------------------------------------------------------------------------------------
IniRead, Pxw			, %inifile%, Cordenada			, Pxw 			, 738 ;Default 738  Cordenada X Bola Mana
IniRead, Pyw			, %inifile%, Cordenada			, Pyw 			, 742 ;Default 742  Cordenada Y Bola Mana
IniRead, Corw			, %inifile%, Cordenada			, Corw 			, 0x610100 ;Default 0x610100 Cor Bola Mana
;-----------------------------------------------------------------------------------------
IniRead, Skil_Combo1	, %inifile%, Combo				, Skil_Combo1 	, 1 ;Default 1 
IniRead, Skil_Combo2	, %inifile%, Combo				, Skil_Combo2 	, 2 ;Default 2
IniRead, Skil_Combo3	, %inifile%, Combo				, Skil_Combo3 	, 3 ;Default 3
IniRead, Check24		, %inifile%, Combo				, Q_Combo		, 0 ;Default 0
IniRead, Delay_Combo	, %inifile%, Combo				, Delay_Combo 	, 200 ;Default 200
;-----------------------------------------------------------------------------------------
IniRead, Check18		, %inifile%, Menu				, Menu_1 		, 0 ;Default 0 2 Char SM (Evil) Elf Agilidade
IniRead, Check19		, %inifile%, Menu				, Menu_2 		, 0 ;Default 0 2 Char SM (Evil) Elf Energia 
IniRead, Check20		, %inifile%, Menu				, Menu_3 		, 0 ;Default 0 PT Buff Elf
IniRead, Check21		, %inifile%, Menu				, Menu_4		, 0 ;Default 0 PT Buff SM
IniRead, Check22		, %inifile%, Menu				, Menu_5	 	, 0 ;Default 0 Pega Itens e bot? direito Fixo (Circular)
IniRead, Check23		, %inifile%, Menu				, Menu_6 	 	, 1 ;Default 1 Pega Itens e bot? direito Livre
;-----------------------------------------------------------------------------------------
IniRead, SK1			, %inifile%, SK					, SK1	 		, 1 ;Default 1 Defesa
IniRead, SK2			, %inifile%, SK					, SK2	 		, 2 ;Default 2 For?
IniRead, SK3			, %inifile%, SK					, SK3	 		, 3 ;Default 3 Vida
IniRead, SK4			, %inifile%, SK					, SK4	 		, 6 ;Default 6 SD
IniRead, SK5			, %inifile%, SK					, SK5	 		, 4 ;Default 4 Skill
IniRead, SK6			, %inifile%, SK					, SK6	 		, 5 ;Default 5 Inf Arrow
IniRead, SK7			, %inifile%, SK					, SK7	 		, 2 ;Default 2 ManaShild
IniRead, SK8			, %inifile%, SK					, SK8	 		, 3 ;Default 3 Magic Circle
;-----------------------------------------------------------------------------------------
IniRead, Check1			, %inifile%, Opcoes				, Q 		 	, 0 ;Default 0 Vida
IniRead, Check2			, %inifile%, Opcoes				, W 		 	, 0 ;Default 0 Mana
IniRead, Check3			, %inifile%, Opcoes				, E 		 	, 0 ;Default 0 Livre
IniRead, Check4			, %inifile%, Opcoes				, R 		 	, 0 ;Default 0 Livre
IniRead, Check5			, %inifile%, Opcoes				, Espaco	 	, 0 ;Default 0 Pegar Itens
IniRead, Check6			, %inifile%, Opcoes				, Party 	 	, 0 ;Default 0 AutoParty
;-----------------------------------------------------------------------------------------
IniRead, Check7			, %inifile%, Buff_Elfa			, ELF1 	 		, 1 ;Default 1 Sozinho
IniRead, Check8			, %inifile%, Buff_Elfa			, ELF2	 		, 0 ;Default 0 Membro 2
IniRead, Check9			, %inifile%, Buff_Elfa			, ELF3	 		, 0 ;Default 0 Membro 3
IniRead, Check10		, %inifile%, Buff_Elfa			, ELF4	 		, 0 ;Default 0 Membro 4
IniRead, Check11		, %inifile%, Buff_Elfa			, ELF5	 		, 0 ;Default 0 Membro 5
;-----------------------------------------------------------------------------------------
IniRead, Membro1x		, %inifile%, Membro_X			, Membro1x	 	, 970 ;Default 970 Cordenada MembroX 1
IniRead, Membro2x		, %inifile%, Membro_X			, Membro2x	 	, 970 ;Default 970 Cordenada MembroX 2
IniRead, Membro3x		, %inifile%, Membro_X			, Membro3x	 	, 970 ;Default 970 Cordenada MembroX 3
IniRead, Membro4x		, %inifile%, Membro_X			, Membro4x	 	, 970 ;Default 970 Cordenada MembroX 4
IniRead, Membro5x		, %inifile%, Membro_X			, Membro5x	 	, 970 ;Default 970 Cordenada MembroX 5
;-----------------------------------------------------------------------------------------
IniRead, Membro1y		, %inifile%, Membro_Y			, Membro1y	 	, 60  ;Default 60  Cordenada MembroY 1
IniRead, Membro2y		, %inifile%, Membro_Y			, Membro2y	 	, 100 ;Default 100 Cordenada MembroY 2
IniRead, Membro3y		, %inifile%, Membro_Y			, Membro3y	 	, 140 ;Default 140 Cordenada MembroY 3
IniRead, Membro4y		, %inifile%, Membro_Y			, Membro4y	 	, 180 ;Default 180 Cordenada MembroY 4
IniRead, Membro5y		, %inifile%, Membro_Y			, Membro5y	 	, 220 ;Default 220 Cordenada MembroY 5
;-----------------------------------------------------------------------------------------
IniRead, Dist			, %inifile%, Dist_Membro	, Dist	 			, 40 ;Default 40 Distancia Entre Membro
;-----------------------------------------------------------------------------------------
IniRead, Check12		, %inifile%, Buff_SM			, SM1 	 		, 1 ;Default 1 Sozinho
IniRead, Check13		, %inifile%, Buff_SM			, SM2	 		, 0 ;Default 0 Membro 2
IniRead, Check14		, %inifile%, Buff_SM			, SM3	 		, 0 ;Default 0 Membro 3
IniRead, Check15		, %inifile%, Buff_SM			, SM4	 		, 0 ;Default 0 Membro 4
IniRead, Check16		, %inifile%, Buff_SM			, SM5	 		, 0 ;Default 0 Membro 5
IniRead, Check17		, %inifile%, Buff_SM			, Hybrida 		, 0 ;Default 0 Hybrida
;-----------------------------------------------------------------------------------------
IniRead, Time_Conserta	, %inifile%, Conserta			, Time_Conserta , 0 ;Default 0 Tempo para Consertar
IniRead, Cord_Ix		, %inifile%, Conserta			, Cord_Ix 		, 0 ;Default 0 
IniRead, Cord_Iy		, %inifile%, Conserta			, Cord_Iy 		, 0 ;Default 0 
IniRead, Cord_Rx		, %inifile%, Conserta			, Cord_Rx 		, 0 ;Default 0 
IniRead, Cord_Ry		, %inifile%, Conserta			, Cord_Ry 		, 0 ;Default 0 
IniRead, Helmx			, %inifile%, Conserta			, Helmx 		, 873 ;Default 0 
IniRead, Helmy			, %inifile%, Conserta			, Helmy 		, 104 ;Default 0 
IniRead, Asax			, %inifile%, Conserta			, Asax 			, 949 ;Default 0 
IniRead, Asay			, %inifile%, Conserta			, Asay 			, 104 ;Default 0 
IniRead, ArmaEx			, %inifile%, Conserta			, ArmaEx 		, 779 ;Default 0 
IniRead, ArmaEy			, %inifile%, Conserta			, ArmaEy 		, 157 ;Default 0 
IniRead, Pendantx		, %inifile%, Conserta			, Pendantx 		, 821 ;Default 0 
IniRead, Pendanty		, %inifile%, Conserta			, Pendanty 		, 157 ;Default 0 
IniRead, Armorx			, %inifile%, Conserta			, Armorx 		, 870 ;Default 0 
IniRead, Armory			, %inifile%, Conserta			, Armory 		, 157 ;Default 0 
IniRead, ArmaDx			, %inifile%, Conserta			, ArmaDx 		, 962 ;Default 0 
IniRead, ArmaDy			, %inifile%, Conserta			, ArmaDy 		, 157 ;Default 0 
IniRead, Luvax			, %inifile%, Conserta			, Luvax 		, 771 ;Default 0 
IniRead, Luvay			, %inifile%, Conserta			, Luvay 		, 257 ;Default 0 
IniRead, AnelEx			, %inifile%, Conserta			, AnelEx 		, 823 ;Default 0 
IniRead, AnelEy			, %inifile%, Conserta			, AnelEy 		, 257 ;Default 0 
IniRead, Pantsx			, %inifile%, Conserta			, Pantsx 		, 869 ;Default 0 
IniRead, Pantsy			, %inifile%, Conserta			, Pantsy 		, 257 ;Default 0 
IniRead, AnelDx			, %inifile%, Conserta			, AnelDx 		, 918 ;Default 0 
IniRead, AnelDy			, %inifile%, Conserta			, AnelDy 		, 257 ;Default 0 
IniRead, Botax			, %inifile%, Conserta			, Botax 		, 967 ;Default 0 
IniRead, Botay			, %inifile%, Conserta			, Botay 		, 257 ;Default 0 
;-----------------------------------------------------------------------------------------
Loop 24
   {
    If (Check%A_Index% = 1)
       Check%A_Index% = Checked
    Else
       Check%A_Index% = 0
}

;==========================================================================
;Fim da grava?o
;==========================================================================
Gui, Color, FFFFF0, -Caption ToolWindow -0x400000
Gui, Show, x150 y30 h600 w770, Auto Bot MuWolrd by andkiko@ig.com.br V.12
;Gui, Add, Picture, x26 y200 w330 h200 							, Logo.bmp
;Gui, Add, Picture, x510 y14 w125 h218 							, byandkiko.JPG
;---------------------------------------------------------------------------------------------------------------------------------
Gui, font, s8, Verdana
Gui, add, GroupBox, x26 y10 w480 h42 							, Instru?es (Configurado para 1024x768)
Gui, Add, Text, x36 y30 w430 h20 cRed						, F5 = Ativa | F3 = Salva | F6 = Pause | F9 = Combo | F10 = Sair (Fecha)
Gui, font, s10, Verdana
Gui, add, GroupBox, x26 y55 w480 h170 							, Menu
Gui, Add, Radio, x36 y75 w460 h20  cBlue vCheck18	%Check18% 	, 2 Char SM (Evil) Elf Agilidade Defesa|For?|Vida|SD|Skill|I.Arrow
Gui, Add, Radio, x36 y100 w460 h20 cBlue vCheck19 	%Check19% 	, 2 Char SM (Evil) Elf Energia Defesa|For?|Vida|SD
Gui, Add, Radio, x36 y125 w460 h20 cBlue vCheck20 	%Check20%  	, PT Buff Elf Defesa|For?|Vida|SD|Skill|I.Arrow
Gui, Add, Radio, x36 y150 w460 h20 cBlue vCheck21 	%Check21% 	, PT Buff SM Magic Circle|ManaShild|Skill
Gui, Add, Radio, x36 y175 w460 h20  vCheck22 		%Check22% 	, Bot? direito Fixo (Circular)
Gui, Add, Radio, x36 y200 w460 h20  vCheck23 		%Check23%	, Bot? direito Livre
;---------------------------------------------------------------------------------------------------------------------------------
Gui, add, GroupBox, x515 y10 w115 h215 							, Skill?
Gui, Add, Edit,		x525 y25 w20 vSK1							, %SK1% ;Defesa
Gui, Add, Text, 	x549 y30 w50 h20 cBlue						, Defesa
Gui, Add, Edit,		x525 y50 w20 vSK2							, %SK2% ;For?
Gui, Add, Text, 	x549 y55 w50 h20 cBlue						, For?
Gui, Add, Edit,		x525 y75 w20 vSK3							, %SK3% ;Vida
Gui, Add, Text, 	x549 y80 w50 h20 cBlue						, Vida
Gui, Add, Edit,		x525 y100 w20 vSK4							, %SK4% ;SD
Gui, Add, Text, 	x549 y104 w50 h20 cBlue						, SD
Gui, Add, Edit,		x525 y125 w20 vSK5							, %SK5% ;Skill
Gui, Add, Text, 	x549 y130 w50 h20 cBlue						, Skill
Gui, Add, Edit,		x525 y150 w20 vSK6							, %SK6% ;I.Arrow
Gui, Add, Text, 	x549 y155 w50 h20 cBlue						, I.Arrow
Gui, Add, Edit,		x525 y175 w20 vSK7							, %SK7% ;ManaShild
Gui, Add, Text, 	x549 y180 w80 h20 cBlue						, ManaShild
Gui, Add, Edit,		x525 y200 w20 vSK8							, %SK8% ;Magic Circle
Gui, Add, Text, 	x549 y203 w80 h20 cBlue						, MagicCircle
;---------------------------------------------------------------------------------------------------------------------------------
Gui, font, s9, Verdana
Gui, add, GroupBox, x636 y230 w115 h180							, Combo
Gui, Add, Edit,		x646 y250 w20 vSkil_Combo1					, %Skil_Combo1%
Gui, Add, Text, 	x670 y252 w50 h20							, Skill 1
Gui, Add, Edit,		x646 y275 w20 vSkil_Combo2					, %Skil_Combo2%
Gui, Add, Text, 	x670 y277 w50 h20							, Skill 2
Gui, Add, Edit,		x646 y300 w20 vSkil_Combo3					, %Skil_Combo3%
Gui, Add, Text, 	x670 y302 w50 h20							, Skill 3
Gui, Add, Checkbox, x646 y325 w30 h20 vCheck24 %Check24%		, Q
Gui, Add, Edit, 	x646 y350 w45 vDelay_Combo					, %Delay_Combo%
Gui, Add, Text, 	x695 y353 w50 h20							, Tempo
;---------------------------------------------------------------------------------------------------------------------------------
Gui, font, s10, Verdana
Gui, add, GroupBox, x270 y230 w115 h180 						, Op?es
Gui, Add, Checkbox, x280 y255 w100 h20 vCheck1 %Check1%			, Q (Vida)
Gui, Add, Checkbox, x280 y280 w100 h20 vCheck2 %Check2%			, W (Mana)
Gui, Add, Checkbox, x280 y304 w100 h20 vCheck3 %Check3%			, E (Livre)
Gui, Add, Checkbox, x280 y330 w100 h20 vCheck4 %Check4%			, R (Livre)
Gui, Add, Checkbox, x280 y355 w100 h20 vCheck5 %Check5%			, Pegar Itens
Gui, Add, Checkbox, x280 y380 w100 h20 vCheck6 %Check6%			, Auto Party
;---------------------------------------------------------------------------------------------------------------------------------
Gui, add, GroupBox, x392 y230 w115 h180 						, Bola Vida
Gui, Add, Text, 	x400 y260 w90 h20							, Cordenada X Y
Gui, Add, Edit, 	x400 y290 w45 vPxq							, %Pxq%
Gui, Add, Edit,		x455 y290 w45 vPyq							, %Pyq%
Gui, Add, Text, 	x440 y320 w30 h20							, Cor 
Gui, Add, Edit, 	x400 y340 w100 vCorq						, %Corq%
Gui, Add, Text, 	x423 y370 w80 h20							, Captura
Gui, Add, Text, 	x420 y388 w80 h20							, SHIFT+Q
;---------------------------------------------------------------------------------------------------------------------------------
Gui, add, GroupBox, x515 y230 w115 h180 						, Bola Mana
Gui, Add, Text, 	x523 y260 w90 h20							, Cordenada X Y
Gui, Add, Edit, 	x523 y290 w45 vPxw							, %Pxw%
Gui, Add, Edit,		x575 y290 w45 vPyw							, %Pyw%
Gui, Add, Text, 	x565 y320 w30 h20							, Cor 
Gui, Add, Edit, 	x523 y340 w100 vCorw						, %Corw%
Gui, Add, Text, 	x546 y370 w80 h20							, Captura
Gui, Add, Text, 	x542 y388 w80 h20							, SHIFT+W
;---------------------------------------------------------------------------------------------------------------------------------
Gui, add, GroupBox, x20 y230 w123 h180 							, Elf Party
Gui, Add, Radio, 	x30 y255 w100 h20 vCheck7  	%Check7%   		, Sozinha
Gui, Add, Radio, 	x30 y280 w100 h20 vCheck8  	%Check8%    	, Membro 2
Gui, Add, Radio, 	x30 y304 w100 h20 vCheck9  	%Check9%  		, Membro 3
Gui, Add, Radio, 	x30 y330 w100 h20 vCheck10 	%Check10% 		, Membro 4 
Gui, Add, Radio, 	x30 y355 w100 h20 vCheck11 	%Check11% 		, Membro 5
Gui, Add, Checkbox, x30 y380 w100 h20 vCheck17 	%Check17%		, Hybrida
;---------------------------------------------------------------------------------------------------------------------------------
Gui, Add, GroupBox, x148 y230 w115 h180 						, SM Party
Gui, Add, Radio, 	x155 y255 w100 h20 vCheck12 %Check12%  		, Sozinho
Gui, Add, Radio, 	x155 y280 w100 h20 vCheck13 %Check13%  		, Membro 2
Gui, Add, Radio,	x155 y304 w100 h20 vCheck14 %Check14% 		, Membro 3
Gui, Add, Radio, 	x155 y330 w100 h20 vCheck15 %Check15%    	, Membro 4
Gui, Add, Radio, 	x155 y355 w100 h20 vCheck16 %Check16%    	, Membro 5
;---------------------------------------------------------------------------------------------------------------------------------
Gui, add, GroupBox, x637 y10 w115 h215 							, Cord. Membro
Gui, Add, Edit, 	x648 y30 w38 vMembro1x						, %Membro1x%
Gui, Add, Edit, 	x648 y55 w38 vMembro2x						, %Membro2x%
Gui, Add, Edit, 	x648 y80 w38 vMembro3x						, %Membro3x%
Gui, Add, Edit, 	x648 y105 w38 vMembro4x						, %Membro4x%
Gui, Add, Edit, 	x648 y130 w38 vMembro5x						, %Membro5x%

Gui, Add, Edit, 	x705 y30 w38 vMembro1y						, %Membro1y%
Gui, Add, Edit, 	x705 y55 w38 vMembro2y						, %Membro2y%
Gui, Add, Edit, 	x705 y80 w38 vMembro3y						, %Membro3y%
Gui, Add, Edit, 	x705 y105 w38 vMembro4y						, %Membro4y%
Gui, Add, Edit, 	x705 y130 w38 vMembro5y						, %Membro5y%

Gui, Add, Edit, 	x648 y160 w30 vDist							, %Dist%
Gui, Add, Text, 	x682 y163 w60 h20							, Dist?cia
Gui, Add, Text, 	x667 y185 w70 h20							, Captura
Gui, Add, Text, 	x666 y203 w70 h20							, SHIFT+1
;---------------------------------------------------------------------------------------------------------------------------------
Gui, font, s8, Verdana
Gui, add, GroupBox, x20 y415 w730 h180 							, Conserta
Gui, Add, Edit, 	x25 y440 w45 vTime_Conserta					, %Time_Conserta%
Gui, Add, Text, 	x73 y443 w90 h20							, Segundos
Gui, Add, Edit, 	x25 y470 w38 vCord_Ix						, %Cord_Ix%
Gui, Add, Edit, 	x70 y470 w38 vCord_Iy						, %Cord_Iy%
Gui, Add, Text, 	x115 y473 w220 h20							, Invent?io | Captura SHIFT+I
Gui, Add, Edit, 	x25 y500 w38 vCord_Rx						, %Cord_Rx%
Gui, Add, Edit, 	x70 y500 w38 vCord_Ry						, %Cord_Ry%
Gui, Add, Text, 	x115 y503 w220 h20							, Reparar | Captura SHIFT+R
Gui, Add, Edit, 	x25 y530 w38 vHelmx							, %Helmx%
Gui, Add, Edit, 	x70 y530 w38 vHelmy							, %Helmy%
Gui, Add, Text, 	x115 y533 w100 h20							, Capacete 
Gui, Add, Edit, 	x25 y560 w38 vAsax							, %Asax%
Gui, Add, Edit, 	x70 y560 w38 vAsay							, %Asay%
Gui, Add, Text, 	x115 y563 w100 h20							, Asa 
Gui, Add, Edit, 	x310 y440 w38 vArmaEx						, %ArmaEx%
Gui, Add, Edit, 	x355 y440 w38 vArmaEy						, %ArmaEy%
Gui, Add, Text, 	x400 y443 w100 h20							, Arma Esquerda
Gui, Add, Edit, 	x310 y470 w38 vPendantx						, %Pendantx%
Gui, Add, Edit, 	x355 y470 w38 vPendanty						, %Pendanty%
Gui, Add, Text, 	x400 y473 w100 h20							, Pendante
Gui, Add, Edit, 	x310 y500 w38 vArmorx						, %Armorx%
Gui, Add, Edit, 	x355 y500 w38 vArmory						, %Armory%
Gui, Add, Text, 	x400 y503 w100 h20							, Peitoral
Gui, Add, Edit, 	x310 y530 w38 vArmaDx						, %ArmaDx%
Gui, Add, Edit, 	x355 y530 w38 vArmaDy						, %ArmaDy%
Gui, Add, Text, 	x400 y533 w100 h20							, Arma Direita
Gui, Add, Edit, 	x310 y560 w38 vLuvax						, %Luvax%
Gui, Add, Edit, 	x355 y560 w38 vLuvay						, %Luvay%
Gui, Add, Text, 	x400 y563 w100 h20							, Luva
Gui, Add, Edit, 	x520 y440 w38 vAnelEx						, %AnelEx%
Gui, Add, Edit, 	x565 y440 w38 vAnelEy						, %AnelEy%
Gui, Add, Text, 	x610 y443 w100 h20							, Anel Esquerdo
Gui, Add, Edit, 	x520 y470 w38 vPantsx						, %Pantsx%
Gui, Add, Edit, 	x565 y470 w38 vPantsy						, %Pantsy%
Gui, Add, Text, 	x610 y473 w100 h20							, Cal?
Gui, Add, Edit, 	x520 y500 w38 vAnelDx						, %AnelDx%
Gui, Add, Edit, 	x565 y500 w38 vAnelDy						, %AnelDy%
Gui, Add, Text, 	x610 y503 w100 h20							, Anel Direito
Gui, Add, Edit, 	x520 y530 w38 vBotax						, %Botax%
Gui, Add, Edit, 	x565 y530 w38 vBotay						, %Botay%
Gui, Add, Text, 	x610 y533 w100 h20							, Bota

Gui, Add, Text, 	x520 y552 w200 h40	cRed					, Para saber a cordenada de cada item Pressione = SHIFT+Z em cima de cada item no jogo.


;---------------------------------------------------------------------------------------------------------------------------------
; Fim Check24
;---------------------------------------------------------------------------------------------------------------------------------

;=================================================================================
;SHIFT + 1 = Pega Cordenada Membro
;=================================================================================
+1::
CoordMode, Pixel, Screen
MouseGetPos, xpos, ypos
Membro1x := (xpos)
Membro2x := (xpos)
Membro3x := (xpos)
Membro4x := (xpos)
Membro5x := (xpos)
Membro1y := (ypos)
Membro2y := (Membro1y+Dist)
Membro3y := (Membro2y+Dist)
Membro4y := (Membro3y+Dist)
Membro5y := (Membro4y+Dist)

tooltip, Cordenada: %xpos%  %ypos% ,0,0,3
IniWrite, %xpos%		, %inifile%, Membro_X			, Membro1x
IniWrite, %Membro2x%	, %inifile%, Membro_X			, Membro2x
IniWrite, %Membro3x%	, %inifile%, Membro_X			, Membro3x
IniWrite, %Membro4x%	, %inifile%, Membro_X			, Membro4x
IniWrite, %Membro5x%	, %inifile%, Membro_X			, Membro5x

IniWrite, %ypos%		, %inifile%, Membro_Y			, Membro1y
IniWrite, %Membro2y%	, %inifile%, Membro_Y			, Membro2y
IniWrite, %Membro3y%	, %inifile%, Membro_Y			, Membro3y
IniWrite, %Membro4y%	, %inifile%, Membro_Y			, Membro4y
IniWrite, %Membro5y%	, %inifile%, Membro_Y			, Membro5y
IniWrite, %Dist%		, %inifile%, Dist_Membro		, Dist

Reload
Return

F3::
;GuiClose:      ;the placement of this label chooses the default behavior
Gui, Submit, NoHide
;-------------------------------------------------------------------------------------------------------------------------------
IniWrite, %Check18%		, %inifile%	, Menu				, Menu_1
IniWrite, %Check19%		, %inifile%	, Menu				, Menu_2
IniWrite, %Check20%		, %inifile%	, Menu				, Menu_3
IniWrite, %Check21%		, %inifile%	, Menu				, Menu_4
IniWrite, %Check22%		, %inifile%	, Menu				, Menu_5
IniWrite, %Check23%		, %inifile%	, Menu				, Menu_6
;-------------------------------------------------------------------------------------------------------------------------------
IniWrite, %SK1%			, %inifile%	, SK				, SK1
IniWrite, %SK2%			, %inifile%	, SK				, SK2
IniWrite, %SK3%			, %inifile%	, SK				, SK3
IniWrite, %SK4%			, %inifile%	, SK				, SK4
IniWrite, %SK5%			, %inifile%	, SK				, SK5
IniWrite, %SK6%			, %inifile%	, SK				, SK6
IniWrite, %SK7%			, %inifile%	, SK				, SK7
IniWrite, %SK8%			, %inifile%	, SK				, SK8
;-------------------------------------------------------------------------------------------------------------------------------
IniWrite, %Check1%		, %inifile%	, Opcoes			, Q
IniWrite, %Check2%		, %inifile%	, Opcoes			, W
IniWrite, %Check3%		, %inifile%	, Opcoes			, E
IniWrite, %Check4%		, %inifile%	, Opcoes			, R
IniWrite, %Check5%		, %inifile%	, Opcoes			, Espaco
IniWrite, %Check6%		, %inifile%	, Opcoes			, Party
;-------------------------------------------------------------------------------------------------------------------------------
IniWrite, %Check7%		, %inifile%	, Buff_Elfa			, ELF1
IniWrite, %Check8%		, %inifile%	, Buff_Elfa			, ELF2
IniWrite, %Check9%		, %inifile%	, Buff_Elfa			, ELF3
IniWrite, %Check10%		, %inifile%	, Buff_Elfa			, ELF4
IniWrite, %Check11%		, %inifile%	, Buff_Elfa			, ELF5
;-------------------------------------------------------------------------------------------------------------------------------
IniWrite, %Check12%		, %inifile%	, Buff_SM			, SM1
IniWrite, %Check13%		, %inifile%	, Buff_SM			, SM2
IniWrite, %Check14%		, %inifile%	, Buff_SM			, SM3
IniWrite, %Check15%		, %inifile%	, Buff_SM			, SM4
IniWrite, %Check16%		, %inifile%	, Buff_SM			, SM5
IniWrite, %Check17%		, %inifile%	, Buff_SM			, Hybrida
;-------------------------------------------------------------------------------------------------------------------------------
IniWrite, %Membro1x%	, %inifile%	, Membro_X			, Membro1x
IniWrite, %Membro2x%	, %inifile%	, Membro_X			, Membro2x
IniWrite, %Membro3x%	, %inifile%	, Membro_X			, Membro3x
IniWrite, %Membro4x%	, %inifile%	, Membro_X			, Membro4x
IniWrite, %Membro5x%	, %inifile%	, Membro_X			, Membro5x
IniWrite, %Membro1y%	, %inifile%	, Membro_Y			, Membro1y
IniWrite, %Membro2y%	, %inifile%	, Membro_Y			, Membro2y
IniWrite, %Membro3y%	, %inifile%	, Membro_Y			, Membro3y
IniWrite, %Membro4y%	, %inifile%	, Membro_Y			, Membro4y
IniWrite, %Membro5y%	, %inifile%	, Membro_Y			, Membro5y
IniWrite, %Dist%		, %inifile%	, Dist_Membro		, Dist
;-------------------------------------------------------------------------------------------------------------------------------
IniWrite, %Pxq%			, %inifile%	, Cordenada			, Pxq
IniWrite, %Pyq%			, %inifile%	, Cordenada			, Pyq
IniWrite, %Corq%		, %inifile%	, Cordenada			, Corq
;-------------------------------------------------------------------------------------------------------------------------------
IniWrite, %pxw%			, %inifile%	, Cordenada			, Pxw
IniWrite, %pyw%			, %inifile%	, Cordenada			, Pyw
IniWrite, %Corw%		, %inifile%	, Cordenada			, Corw
;-------------------------------------------------------------------------------------------------------------------------------
IniWrite, %Skil_Combo1%	, %inifile%	, Combo				, Skil_Combo1
IniWrite, %Skil_Combo2%	, %inifile%	, Combo				, Skil_Combo2
IniWrite, %Skil_Combo3%	, %inifile%	, Combo				, Skil_Combo3
IniWrite, %Check24%		, %inifile%	, Combo				, Q_Combo
IniWrite, %Delay_Combo%	, %inifile%	, Combo				, Delay_Combo
;-------------------------------------------------------------------------------------------------------------------------------
IniWrite, %Time_Conserta%, %inifile%, Conserta			, Time_Conserta 
IniWrite, %Cord_Ix%		, %inifile%, Conserta			, Cord_Ix 		
IniWrite, %Cord_Iy%		, %inifile%, Conserta			, Cord_Iy 		
IniWrite, %Cord_Rx%		, %inifile%, Conserta			, Cord_Rx 		
IniWrite, %Cord_Ry%		, %inifile%, Conserta			, Cord_Ry 		
IniWrite, %Helmx%		, %inifile%, Conserta			, Helmx 		
IniWrite, %Helmy%		, %inifile%, Conserta			, Helmy 		
IniWrite, %Asax%		, %inifile%, Conserta			, Asax 			
IniWrite, %Asay%		, %inifile%, Conserta			, Asay 			
IniWrite, %ArmaEx%		, %inifile%, Conserta			, ArmaEx 		
IniWrite, %ArmaEy%		, %inifile%, Conserta			, ArmaEy 		
IniWrite, %Pendantx%	, %inifile%, Conserta			, Pendantx 		
IniWrite, %Pendanty%	, %inifile%, Conserta			, Pendanty 		
IniWrite, %Armorx%		, %inifile%, Conserta			, Armorx 		
IniWrite, %Armory%		, %inifile%, Conserta			, Armory 		
IniWrite, %ArmaDx%		, %inifile%, Conserta			, ArmaDx 		
IniWrite, %ArmaDy%		, %inifile%, Conserta			, ArmaDy 		
IniWrite, %Luvax%		, %inifile%, Conserta			, Luvax 		
IniWrite, %Luvay%		, %inifile%, Conserta			, Luvay 		
IniWrite, %AnelEx%		, %inifile%, Conserta			, AnelEx 		
IniWrite, %AnelEy%		, %inifile%, Conserta			, AnelEy 		
IniWrite, %Pantsx%		, %inifile%, Conserta			, Pantsx 		
IniWrite, %Pantsy%		, %inifile%, Conserta			, Pantsy 		
IniWrite, %AnelDx%		, %inifile%, Conserta			, AnelDx 		
IniWrite, %AnelDy%		, %inifile%, Conserta			, AnelDy 		
IniWrite, %Botax%		, %inifile%, Conserta			, Botax 		
IniWrite, %Botay%		, %inifile%, Conserta			, Botay 		
;-------------------------------------------------------------------------------------------------------------------------------

Reload
Return
;=================================================================================
;F5 = Ativa
;=================================================================================
F5::
Gui, Submit, NoHide
If (Check18 = 1)
{
  Gosub, Check18
}
If (Check19 = 1)
{
  Gosub, Check19
}
If (Check20 = 1)
{
  Gosub, Check20
}
If (Check21 = 1)
{
  Gosub, Check21
}
If (Check22 = 1)
{
  Gosub, Check22
}
If (Check23 = 1)
{
  Gosub, Check23
}
Return

Conserta:
Gui, Submit, NoHide
Calc := 1000*Time_Conserta
Loop
{
StartTime := A_TickCount
Sleep, %Calc%
ElapsedTime := A_TickCount - StartTime
Gosub ~+a
;MsgBox, 0, teste,%ElapsedTime% milliseconds have elapsed., 5
}
Return


;=================================================================================
; 2 Char 1=SM (Evil) 2=Elf Agilidade (1 Skill 2 Flecha)
;=================================================================================
Check18: 	
Gui, Submit, NoHide
loop
{
	MouseGetPos, xpos, ypos
	MouseMove, xpos, ypos, 5 RButton
Click Up, right,
Click down, right,
	Gosub Opcoes
	Sleep, 1000
	Gosub Opcoes 
Click Up, right,

Click down, right,
	Gosub Opcoes
	Sleep, 1000
	Send, {F11}
	Sleep, 1000

Click Up, right,

	If (Check8 = 1) ;Membro 2
loop
{
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Sleep, 250
Click down, right,
	Gosub Check8
	Gosub Opcoes     
Click Up, right,
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Sleep, 250
Click down, right,
	Gosub Check8
	Gosub Opcoes
Click Up, right,  
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Sleep, 250
Click down, right,
	Gosub Check8
	Gosub Opcoes
Click Up, right,  
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD      
	Sleep, 250
Click down, right,
	Gosub Check8
	Gosub Opcoes
Click Up, right,  
}

If (Check9 = 1) ;Membro 3
loop
{
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Sleep, 250
Click down, right,
	Gosub Check9
	Gosub Opcoes     
Click Up, right,
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Sleep, 250
Click down, right,
	Gosub Check9
	Gosub Opcoes
Click Up, right,  
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Sleep, 250
Click down, right,
	Gosub Check9
	Gosub Opcoes
Click Up, right,  
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD      
	Sleep, 250
Click down, right,
	Gosub Check9
	Gosub Opcoes
Click Up, right,  
}

If (Check10 = 1) ;Membro 4
loop
{
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Sleep, 250
Click down, right,
	Gosub Check10
	Gosub Opcoes     
Click Up, right,
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Sleep, 250
Click down, right,
	Gosub Check10
	Gosub Opcoes
Click Up, right,  
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Sleep, 250
Click down, right,
	Gosub Check10
	Gosub Opcoes
Click Up, right,  
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD      
	Sleep, 250
Click down, right,
	Gosub Check10
	Gosub Opcoes
Click Up, right, 
}

If (Check11 = 1) ;Membro 5
loop 2
{
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Sleep, 250
Click down, right,
	Gosub Check11
	Gosub Opcoes     
Click Up, right,
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Sleep, 250
Click down, right,
	Gosub Check11
	Gosub Opcoes
Click Up, right,  
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Sleep, 250
Click down, right,
	Gosub Check11
	Gosub Opcoes
Click Up, right,  
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD      
	Sleep, 250
Click down, right,
	Gosub Check11
	Gosub Opcoes
Click Up, right, 
}
	Gosub Opcoes
	Sleep, 1000
	Gosub Opcoes
	MouseMove, xpos, ypos, 5 RButton
Click down, right,
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Sleep, 500
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Sleep, 500
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Sleep, 500
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Sleep, 500
	Send, {%SK6% Down}{%SK6% Up} ;I.Arrow
	Send, {%SK6% Down}{%SK6% Up} ;I.Arrow
	Send, {%SK6% Down}{%SK6% Up} ;I.Arrow
	Sleep, 500
	
	If (Check17 = 1) ;Hybrida
	{
	Gosub Hybrida
	}
	MouseMove, xpos, ypos, 5 RButton
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Sleep, 500
Click Up, right,

Loop, 5
{
Click down, right,
	MouseMove, 430,220, 5
	Gosub Opcoes  
	MouseMove, 430,380, 5
	Gosub Opcoes  
	MouseMove, 600,380, 5
	Gosub Opcoes  
	MouseMove, 600,220, 5
Click Up, right,
	Gosub Opcoes  
Click down, right,
	MouseMove, 340,220, 5
	Gosub Opcoes  
	MouseMove, 340,380, 5
	Gosub Opcoes  
	MouseMove, 680,380, 5
	Gosub Opcoes  
	MouseMove, 680,220, 5
Click Up, right,
}
Click Up, right,
	Gosub Opcoes
	
	If (Check17 = 1) ;Hybrida
	{
	Gosub Hybrida
	}
	MouseMove, xpos, ypos, 5 RButton
Click down, right,
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Sleep, 500
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Sleep, 500
	Send, {%SK3% Down}{%SK3% Up} ; Vida
	Send, {%SK3% Down}{%SK3% Up} ; Vida
	Send, {%SK3% Down}{%SK3% Up} ; Vida
	Sleep, 500
	Send, {%SK6% Down}{%SK6% Up} ;I.Arrow
	Send, {%SK6% Down}{%SK6% Up} ;I.Arrow
	Send, {%SK6% Down}{%SK6% Up} ;I.Arrow  
	Sleep, 500
	Send, {%SK5% Down}{%SK5% Up} ;Skill 
	Send, {%SK5% Down}{%SK5% Up} ;Skill 
	Send, {%SK5% Down}{%SK5% Up} ;Skill 
	Sleep, 500
	
	If (Check17 = 1) ;Hybrida
	{
	Gosub Hybrida
	}
	MouseMove, xpos, ypos, 5 RButton
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Sleep, 500
Click Up, right,
	MouseMove, xpos, ypos, 5 RButton
	Send, {F11}
Click Up, right,
}
Return

;=================================================================================
; 2 Char 1=SM (Evil) 2=Elf Energia (1 Def, 2 For, 3 Vit)
;=================================================================================
Check19: 	
Gui, Submit, NoHide
If (Check7 = 1) ;Sozinho
loop
{
	MouseGetPos, xpos, ypos
	MouseMove, xpos, ypos, 5 RButton
Click Up, right,
Click down, right,
	Gosub Opcoes
	Sleep, 1000
Click Up, right,

Click down, right,
	Gosub Opcoes
	Sleep, 1000
	Send, {F11}
	Sleep, 1000

Click down, right,
Click Up, right,
loop, 4
{  
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Sleep, 250
Click down, right,
	Gosub Check8
	Gosub Opcoes  
Click Up, right,
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?     
	Sleep, 250
Click down, right,
	Gosub Check8
	Gosub Opcoes
Click Up, right,  
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Sleep, 250
Click down, right,
	Gosub Check8
	Gosub Opcoes     
Click Up, right,
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Sleep, 250
Click down, right,
	Gosub Check8
	Gosub Opcoes     
Click Up, right,
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Sleep, 250
Click down, right,
	Gosub Check8
	Gosub Opcoes     
Click Up, right,

Click down, right,
	MouseMove, xpos, ypos, 5 RButton
	Gosub Opcoes    
Click Up, right,	
}
Click Up, right,
MouseMove, xpos, ypos, 5 RButton
	Send, {F11}
Click Up, right,

}

If (Check8 = 1) ;Membro 2
loop
{
	MouseGetPos, xpos, ypos
	MouseMove, xpos, ypos, 5 RButton
Click Up, right,
Click down, right,
	Gosub Opcoes
	Sleep, 1000
Click Up, right,

Click down, right,
	Gosub Opcoes
	Sleep, 1000
	Send, {F11}
	Sleep, 1000

Click down, right,
Click Up, right,
loop, 4
{  
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Sleep, 250
Click down, right,
	Gosub Check8
	Gosub Opcoes  
Click Up, right,
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?     
	Sleep, 250
Click down, right,
	Gosub Check8
	Gosub Opcoes
Click Up, right,  
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Sleep, 250
Click down, right,
	Gosub Check8
	Gosub Opcoes     
Click Up, right,
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Sleep, 250
Click down, right,
	Gosub Check8
	Gosub Opcoes     
Click Up, right,
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Sleep, 250
Click down, right,
	Gosub Check8
	Gosub Opcoes     
Click Up, right,

Click down, right,
	MouseMove, xpos, ypos, 5 RButton
	Gosub Opcoes    
Click Up, right,	
}
Click Up, right,
MouseMove, xpos, ypos, 5 RButton
	Send, {F11}
Click Up, right,

}

If (Check9 = 1) ;Membro 3
loop
{
 MouseGetPos, xpos, ypos

	MouseMove, xpos, ypos, 5 RButton
Click Up, right,
Click down, right,
	Gosub Opcoes
	Sleep, 1000
	Gosub Opcoes 
Click Up, right,

Click down, right,
	Gosub Opcoes
	Sleep, 1000
	Send, {F11}
	Sleep, 1000

Click down, right,
Click Up, right,
loop, 4
{  
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Sleep, 250
Click down, right,
	Gosub Check9
	Gosub Opcoes     
Click Up, right,
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?  
	Sleep, 250
Click down, right,
	Gosub Check9
	Gosub Opcoes
Click Up, right,  
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida  
	Sleep, 250
Click down, right,
	Gosub Check9
	Gosub Opcoes     
Click Up, right,
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Sleep, 250
Click down, right,
	Gosub Check9
	Gosub Opcoes     
Click Up, right,
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Sleep, 250
Click down, right,
	Gosub Check9
	Gosub Opcoes
Click Up, right,

Click down, right,
	MouseMove, xpos, ypos, 5 RButton
	Gosub Opcoes    
Click Up, right,	
}
Click Up, right,
MouseMove, xpos, ypos, 5 RButton
	Send, {F11}
Click Up, right,

}

If (Check10 = 1) ;Membro 4
loop
{
 MouseGetPos, xpos, ypos

	MouseMove, xpos, ypos, 5 RButton
Click Up, right,
Click down, right,
	Gosub Opcoes
	Sleep, 1000
	Gosub Opcoes 
Click Up, right,

Click down, right,
	Gosub Opcoes
	Sleep, 1000
	Send, {F11}
	Sleep, 1000

Click down, right,
Click Up, right,
loop, 4
{  
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Sleep, 250
Click down, right,
	Gosub Check10
	Gosub Opcoes     
Click Up, right,
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?  
	Sleep, 250
Click down, right,
	Gosub Check10
	Gosub Opcoes
Click Up, right,  
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Sleep, 250
Click down, right,
	Gosub Check10
	Gosub Opcoes     
Click Up, right,
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Sleep, 250
Click down, right,
	Gosub Check10
	Gosub Opcoes     
Click Up, right,
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Sleep, 250
Click down, right,
	Gosub Check10
	Gosub Opcoes     
Click Up, right,

Click down, right,
	MouseMove, xpos, ypos, 5 RButton
	Gosub Opcoes    
Click Up, right,	
}
Click Up, right,
MouseMove, xpos, ypos, 5 RButton
	Send, {F11}
Click Up, right,

}

If (Check11 = 1) ;Membro 5
loop
{
 MouseGetPos, xpos, ypos

	MouseMove, xpos, ypos, 5 RButton
Click Up, right,
Click down, right,
	Gosub Opcoes
	Sleep, 1000
	Gosub Opcoes 
Click Up, right,

Click down, right,
	Gosub Opcoes
	Sleep, 1000
	Send, {F11}
	Sleep, 1000

Click down, right,
Click Up, right,
loop, 4
{  
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Sleep, 250
Click down, right,
	Gosub Check11
	Gosub Opcoes     
Click Up, right,
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Sleep, 250
Click down, right,
	Gosub Check11
	Gosub Opcoes
Click Up, right,  
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Send, {%SK3% Down}{%SK3% Up} ;Vida
	Sleep, 250
Click down, right,
	Gosub Check11
	Gosub Opcoes     
Click Up, right,
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Sleep, 250
Click down, right,
	Gosub Check11
	Gosub Opcoes     
Click Up, right,
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Sleep, 250
Click down, right,
	Gosub Check11
	Gosub Opcoes     
Click Up, right,

Click down, right,
	MouseMove, xpos, ypos, 5 RButton
	Gosub Opcoes    
Click Up, right,	
}
Click Up, right,
MouseMove, xpos, ypos, 5 RButton
	Send, {F11}
Click Up, right,

}
Return

;=================================================================================
; PT Buff Elf (1 Defesa, 2 For?, 3 Vida, 6 SD, 4 Skill)
;=================================================================================
Check20:  	
Gui, Submit, NoHide
MouseGetPos, xpos, ypos
;----------------------------
If (Check7 = 1) ;Membro 1
;----------------------------
loop
{
Gosub Hybrida
}
;----------------------------
If (Check8 = 1) ;Membro 2
;----------------------------
loop
{
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
Click down, right,
	Gosub Check8
	Gosub Opcoes
Click Up, right,
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
Click down, right,
	Gosub Check8
	Gosub Opcoes
Click Up, right,
	Send, {%SK3% Down}{%SK3% Up} ;For?
	Send, {%SK3% Down}{%SK3% Up} ;For?
	Send, {%SK3% Down}{%SK3% Up} ;For?
Click down, right,
	Gosub Check8
	Gosub Opcoes
Click Up, right,
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
Click down, right,
	Gosub Check8
	Gosub Opcoes
Click Up, right,
	If (Check17 = 1) ;Hybirda
	{
	Gosub Hybrida
	}
Click Up, right,
}
;----------------------------
If (Check9 = 1) ;Membro 3
;----------------------------
loop
{
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
Click down, right,
	Gosub Check9
	Gosub Opcoes
Click Up, right,
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
Click down, right,
	Gosub Check9
	Gosub Opcoes
Click Up, right,
	Send, {%SK3% Down}{%SK3% Up} ;For?
	Send, {%SK3% Down}{%SK3% Up} ;For?
	Send, {%SK3% Down}{%SK3% Up} ;For?
Click down, right,
	Gosub Check9
	Gosub Opcoes
Click Up, right,
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
Click down, right,
	Gosub Check9
	Gosub Opcoes
Click Up, right,
	If (Check17 = 1) ;Hybrida
	{
	Gosub Hybrida
	}
Click Up, right,
}
;----------------------------
If (Check10 = 1) ;Membro 4
;----------------------------
loop
{
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
Click down, right,
	Gosub Check10
	Gosub Opcoes
Click Up, right,
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
Click down, right,
	Gosub Check10
	Gosub Opcoes
Click Up, right,
	Send, {%SK3% Down}{%SK3% Up} ;For?
	Send, {%SK3% Down}{%SK3% Up} ;For?
	Send, {%SK3% Down}{%SK3% Up} ;For?
Click down, right,
	Gosub Check10
	Gosub Opcoes
Click Up, right,
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
Click down, right,
	Gosub Check10
	Gosub Opcoes
Click Up, right,
	If (Check17 = 1) ;Hybrida
	{
	Gosub Hybrida
	}
Click Up, right,
}
;----------------------------
If (Check11 = 1) ;Membro 5
;----------------------------
loop
{
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
Click down, right,
	Gosub Check11
	Gosub Opcoes
Click Up, right,
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
	Send, {%SK2% Down}{%SK2% Up} ;For?
Click down, right,
	Gosub Check11
	Gosub Opcoes
Click Up, right,
	Send, {%SK3% Down}{%SK3% Up} ;For?
	Send, {%SK3% Down}{%SK3% Up} ;For?
	Send, {%SK3% Down}{%SK3% Up} ;For?
Click down, right,
	Gosub Check11
	Gosub Opcoes
Click Up, right,
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
	Send, {%SK4% Down}{%SK4% Up} ;SD
Click down, right,
	Gosub Check11
	Gosub Opcoes
Click Up, right,
	If (Check17 = 1) ;Hybrida
	{
	Gosub Hybrida
	}
Click Up, right,
}

MouseMove, xpos, ypos, 10 RButton
Click Up, right,
Return

;=================================================================================
; PT Buff SM (1 Skill, 2 ManaShild. 4 Magic Circle)
;=================================================================================
Check21: 	
;----------------------------
Gui, Submit, NoHide
	MouseGetPos, xpos, ypos
;----------------------------
If (Check12 = 1) ;SM1
;----------------------------
loop
{
	MouseMove, xpos, ypos, 10 RButton

	Send, {%SK8% Down}{%SK8% Up} ;Magic Circle
	Send, {%SK8% Down}{%SK8% Up} ;Magic Circle
	Send, {%SK8% Down}{%SK8% Up} ;Magic Circle
	Sleep, 500
Click down, right,
	Gosub Opcoes
Click Up, right,
	Send, {%SK7% Down}{%SK7% Up} ;ManaShild
	Send, {%SK7% Down}{%SK7% Up} ;ManaShild
	Send, {%SK7% Down}{%SK7% Up} ;ManaShild
Click down, right,
	Gosub Opcoes
Click Up, right,
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Send, {%SK5% Down}{%SK5% Up} ;Skill
Click down, right,
	Gosub Opcoes
Click Up, right,

	loop 350
	{

	Click down, right,
		Gosub Opcoes
	Click Up, right,
	}

}

;----------------------------
If (Check13 = 1) ;SM2
;----------------------------
loop 
{
	MouseMove, xpos, ypos
Click down, right,
	Send, {%SK8% Down}{%SK8% Up} ;Magic Circle
	Sleep 1000
	Send, {%SK8% Down}{%SK8% Up} ;Magic Circle
		Sleep 1000
	Send, {%SK8% Down}{%SK8% Up} ;Magic Circle
		Sleep 1000
Click Up, right,
	Gosub Opcoes
Click Up, right,
	Send, {%SK7% Down}{%SK7% Up} ;ManaShild
		Sleep 1000
	Send, {%SK7% Down}{%SK7% Up} ;ManaShild
		Sleep 1000
	Send, {%SK7% Down}{%SK7% Up} ;ManaShild
		Sleep 1000
Click down, right,
	Gosub Check8
	Gosub Opcoes
Click Up, right,

Send, {%SK5% Down}{%SK5% Up} ;Skill
Send, {%SK5% Down}{%SK5% Up} ;Skill
Send, {%SK5% Down}{%SK5% Up} ;Skill
Send, {%SK5% Down}{%SK5% Up} ;Skill
Send, {%SK5% Down}{%SK5% Up} ;Skill
Send, {%SK5% Down}{%SK5% Up} ;Skill
Send, {%SK5% Down}{%SK5% Up} ;Skill

loop 1500
{
	MouseMove, xpos, ypos,
Click down, right,
	Gosub Opcoes
Click Up, right,

}
	MouseMove, xpos, ypos,
Click Up, right,
}

;----------------------------
If (Check14 = 1) ;SM3
;----------------------------
loop 
{
	MouseMove, xpos, ypos, 10 RButton
	Send, {%SK8% Down}{%SK8% Up} ;Magic Circle
	Send, {%SK8% Down}{%SK8% Up} ;Magic Circle
	Send, {%SK8% Down}{%SK8% Up} ;Magic Circle
Click down, right,
Sleep, 500
	Gosub Opcoes
Click Up, right,
	Send, {%SK7% Down}{%SK7% Up} ;ManaShild
	Send, {%SK7% Down}{%SK7% Up} ;ManaShild
	Send, {%SK7% Down}{%SK7% Up} ;ManaShild
Click down, right,
	Gosub Check9
	Gosub Opcoes
Click Up, right,
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Send, {%SK5% Down}{%SK5% Up} ;Skill
Click down, right,
	Gosub Check9
	Gosub Opcoes
Click Up, right,

loop 350
{
	MouseMove, xpos, ypos, 10 RButton
Click down, right,
	Gosub Opcoes
Click Up, right,
}
	MouseMove, xpos, ypos, 10 RButton
Click Up, right,
}

;----------------------------
If (Check15 = 1) ;SM4
;----------------------------
loop 
{
	MouseMove, xpos, ypos, 10 RButton
	Send, {%SK8% Down}{%SK8% Up} ;Magic Circle
	Send, {%SK8% Down}{%SK8% Up} ;Magic Circle
	Send, {%SK8% Down}{%SK8% Up} ;Magic Circle
Click down, right,
Sleep, 500
	Gosub Opcoes
Click Up, right,
	Send, {%SK7% Down}{%SK7% Up} ;ManaShild
	Send, {%SK7% Down}{%SK7% Up} ;ManaShild
	Send, {%SK7% Down}{%SK7% Up} ;ManaShild
Click down, right,
	Gosub Check10
	Gosub Opcoes
Click Up, right,
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Send, {%SK5% Down}{%SK5% Up} ;Skill
Click down, right,
	Gosub Check10
	Gosub Opcoes
Click Up, right,

loop 350
{
	MouseMove, xpos, ypos, 10 RButton
Click down, right,
	Gosub Opcoes
Click Up, right,
}
	MouseMove, xpos, ypos, 10 RButton
Click Up, right,
}

;----------------------------
If (Check16 = 1) ;SM5
;----------------------------
loop
{
	MouseMove, xpos, ypos, 10 RButton
	Send, {%SK8% Down}{%SK8% Up} ;Magic Circle
	Send, {%SK8% Down}{%SK8% Up} ;Magic Circle
	Send, {%SK8% Down}{%SK8% Up} ;Magic Circle
Click down, right,
Sleep, 500
	Gosub Opcoes
Click Up, right,
	Send, {%SK7% Down}{%SK7% Up} ;ManaShild
	Send, {%SK7% Down}{%SK7% Up} ;ManaShild
	Send, {%SK7% Down}{%SK7% Up} ;ManaShild
Click down, right,
	Gosub Check11
	Gosub Opcoes
Click Up, right,
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Send, {%SK5% Down}{%SK5% Up} ;Skill
Click down, right,
	Gosub Check11
	Gosub Opcoes
Click Up, right,

loop 350
{
	MouseMove, xpos, ypos, 10 RButton
	Send, {%SK5% Down}{%SK5% Up} ;Skill
Click down, right,
	Gosub Opcoes
Click Up, right,
}
MouseMove, xpos, ypos, 10 RButton
Click Up, right,
}

	MouseMove, xpos, ypos, 10 RButton
Click Up, right,
Return

;=================================================================================
; Pega Itens e bot? direito Fixo (Circular)
;=================================================================================
Check22: 	
Gui, Submit, NoHide
Loop
{
Click down, right,
	MouseMove, 430,220, 5
	Gosub Opcoes
	MouseMove, 430,380, 5
	Gosub Opcoes  
	MouseMove, 600,380, 5
	Gosub Opcoes  
	MouseMove, 600,220, 5
Click Up, right,
	Gosub Opcoes  
Click down, right,
	MouseMove, 340,220, 5
	Gosub Opcoes
	MouseMove, 340,380, 5
	Gosub Opcoes  
	MouseMove, 680,380, 5
	Gosub Opcoes  
	MouseMove, 680,220, 5
	Gosub Opcoes
Click Up, right,
}
Return

;=================================================================================
; Pega Itens e bot? direito Livre
;=================================================================================
Check23:
;Gui, Submit, NoHide
loop
{
Click down, right,
	Gosub Opcoes
Click Up, right,
}

Return

;=================================================================================
; F9 = Combo
;=================================================================================
F9::
Gui, Submit, NoHide
Loop
{
If (Check24 = 1) ;Q
	Send, {q Down}{q Up}
		Sleep, %Delay_Combo%
	Send, {%Skil_Combo1% Down}{%Skil_Combo1% Up}
		Sleep, %Delay_Combo%
	Send, {%Skil_Combo2% Down}{%Skil_Combo2% Up}
		Sleep, %Delay_Combo%
	Send, {%Skil_Combo3% Down}{%Skil_Combo3% Up} 
		Sleep, %Delay_Combo%
}
Return


GuiClose:
ExitApp

F6::Pause

F10::ExitApp

;=================================================================================
;SHIFT + s = Captura Nome Titulo Janela
;=================================================================================
+s::
; Example #1: Maximize the active window and report its unique ID:
WinGetActiveTitle, Title
MsgBox, The active window is "%Title%".
Clipboard = %Title%
Return

;=================================================================================
;SHIFT + a = Conserta itens
;=================================================================================
~+a::
Gui, Submit, NoHide
MouseGetPos, xpos, ypos
Sleep, 1000

;Abre Inventario Via Comando
SendInput, {i Down}{i Up}
MouseMove, xpos, ypos

;Abre Inventario Via Cordenada
;~ MouseMove, 903,724
;~ Sleep, 500
;~ MouseClick, left, 900,714
;~ Sleep, 500

;Ferramenta de Consertar Via Comando
;~ SendInput, {r Down}{r Up}

;Ferramenta de Consertar Via Cordenada
Mousemove,826,650
	Sleep, 500
MouseClick, left, 826,650
	Sleep, 500

;Helm
MouseClick, left, %Helmx%,%Helmy%,10
;Asa
MouseClick, left, %Asax%,%Asay%,10
;Arma Esquerda
MouseClick, left, %ArmaEx%,%ArmaEy%,10
;Pendant
MouseClick, left, %Pendantx%,%Pendanty%,10
;Armor
MouseClick, left, %Armorx%,%Armory%,10
;Arma Direita
MouseClick, left, %ArmaDx%,%ArmaDy%,10
;Gloves
MouseClick, left, %Luvax%,%Luvay%,10
;Anel Esquerdo
MouseClick, left, %AnelEx%,%AnelEy%,10
;Pants
MouseClick, left, %Pantsx%,%Pantsy%,10
;Anel Direito
MouseClick, left, %AnelDx%,%AnelDy%,10
;Boots
MouseClick, left, %Botax%,%Botay%,10

;Posisiona o mouse no centro
;~ Mousemove, 903,724
;~ Sleep, 100

Send, {D Down}{D Up}
Send, {D Down}{D Up}

;MouseUp( "Right")
;Mousemove,900,714,1)
;MouseDown("left")
;Sleep(50)
;MouseUp( "left")

MouseMove, xpos, ypos     

;Send("{I}")

Return

;=================================================================================
;SHIFT + Q = Pega Cordenada e Cor
;=================================================================================
+i::
CoordMode, Pixel, Screen
MouseGetPos, xpos, ypos
;PixelGetColor,Color, xpos, ypos
;MsgBox, Cordenada: %xpos%  %ypos% Cor: %Color%
;tooltip, Cordenada: %xpos%  %ypos% Cor: %Color%,0,0,3
IniWrite, %xpos%		, %inifile%, Conserta			, Cord_Ix 		
IniWrite, %ypos%		, %inifile%, Conserta			, Cord_Iy 	
Reload
Return
;=================================================================================
;SHIFT + Q = Pega Cordenada e Cor
;=================================================================================
+r::
CoordMode, Pixel, Screen
MouseGetPos, xpos, ypos
;PixelGetColor,Color, xpos, ypos
;MsgBox, Cordenada: %xpos%  %ypos% Cor: %Color%
;tooltip, Cordenada: %xpos%  %ypos% Cor: %Color%,0,0,3
IniWrite, %xpos%		, %inifile%, Conserta			, Cord_Rx 		
IniWrite, %ypos%		, %inifile%, Conserta			, Cord_Ry 
Reload
Return
;=================================================================================

;=================================================================================
;SHIFT + Z = Pega Cordenada e Cor
;=================================================================================
+Z::
CoordMode, Pixel, Screen
MouseGetPos, xpos, ypos
PixelGetColor,Color, xpos, ypos
Tooltip, Cordenada: %xpos%  %ypos% Cor: %Color%,0,0
;SetTimer, RemoveToolTip, 15000
return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return
;=================================================================================
;SHIFT + Q = Pega Cordenada e Cor
;=================================================================================
+Q::
CoordMode, Pixel, Screen
MouseGetPos, xpos, ypos
PixelGetColor,Color, xpos, ypos
;MsgBox, Cordenada: %xpos%  %ypos% Cor: %Color%
;tooltip, Cordenada: %xpos%  %ypos% Cor: %Color%,0,0,3
IniWrite, %xpos%		, %inifile%, Cordenada			, Pxq
IniWrite, %ypos%		, %inifile%, Cordenada			, Pyq
IniWrite, %Color%		, %inifile%, Cordenada			, Corq
Reload
Return
;=================================================================================
;SHIFT + W = Pega Cordenada e Cor
;=================================================================================
+W::
CoordMode, Pixel, Screen
MouseGetPos, xpos, ypos
PixelGetColor,Color, xpos, ypos
;MsgBox, Cordenada: %xpos%  %ypos% Cor: %Color%
;tooltip, Cordenada: %xpos%  %ypos% Cor: %Color%,0,0,3
IniWrite, %xpos%		, %inifile%, Cordenada			, Pxw
IniWrite, %ypos%		, %inifile%, Cordenada			, Pyw
IniWrite, %Color%		, %inifile%, Cordenada			, Corw
Reload
Return

;=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
;Loops
;=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
;=================================================================================
;Op?es
;=================================================================================
Opcoes:
Gui, Submit, NoHide
	If (Check1 = 1) ;Q
		Gosub Vida
	If (Check2 = 1) ;W
		Gosub Mana
	If (Check3 = 1) ;E
		Send, {e Down} {e Up}
	If (Check4 = 1) ;R
		Send, {r Down} {r Up}
	If (Check5 = 1) ;Espa?
		Send, {space Down} {space Up} 
	;If (Check6 = 1) ;Party
		;Gosub AutoParty
Return
;=================================================================================
;Vida
;=================================================================================
Vida:
Gui, Submit, NoHide
x1 = %Pxq%
y1 = %Pyq%
x2 := (x1+1)
y2 := (y1+1)
;Msgbox, %x1% %y1% %x2% %y2%
Loop
{
  sleep, 100
  PixelSearch, x,y,x1, y1, x2, y2, %Corq%, 100, Fast
  if errorlevel=0
  {
    ;Mousemove, %x%,%y%  
    tooltip, Vida %x% %y%,x,y,3
    ;MouseClick, left, %x%,%y%    
  }
  else
    ;Mousemove, %x%,%y%
    ;tooltip, N? Vida %x% %y%,x,y,3
    Send, {q Down} {q Up}
	Return
}
;=================================================================================
;Mana
;=================================================================================
Mana:
Gui, Submit, NoHide
x1 = %Pxw%
y1 = %Pyw%
x2 := (x1+1)
y2 := (y1+1)
;Msgbox, %x1% %y1% %x2% %y2%
Loop
{
  sleep, 100
  PixelSearch, x,y,x1, y1, x2, y2, %Corw%, 100, Fast
  if errorlevel=0
  {
    ;Mousemove, %x%,%y%  
    tooltip, Mana %x% %y%,x,y,3
    ;MouseClick, left, %x%,%y%    
  }
  else
    ;Mousemove, %x%,%y%
    ;tooltip, N? Vida %x% %y%,x,y,3
    Send, {w Down} {w Up}
	Return
}
;=================================================================================
; Auto Party
;=================================================================================
AutoParty: ;Cordenada: 121, 695 Cor: 0x0C0F11

Click Up, right,
	Send, {space Up}
	MouseMove, 510, 320
clipboard = /party
	Send, {ENTER Down}{ENTER Up}
		Sleep, 500
	Send, {TAB Down}{TAB Up}{BACKSPACE Down}{BACKSPACE Up}
		Sleep, 500
	Send, {TAB Down}{TAB Up}
		Sleep, 1000
	Send, +{INS}
		Sleep, 1000 
	Send, {ENTER Down}{ENTER Up}
		Sleep, 2000
Return
;=================================================================================
; Membros Buff_Elfa
;=================================================================================
Check8: ;Membro 2
Gui, Submit, NoHide
	MouseMove, %Membro1x%,%Membro1y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
	MouseMove, %Membro2x%,%Membro2y%, 5 RButton
	Sleep, 500
	Gosub Opcoes 
	Return
	
Check9: ;Membro 3
Gui, Submit, NoHide
	MouseMove, %Membro1x%,%Membro1y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
	MouseMove, %Membro2x%,%Membro2y%, 5 RButton
	Sleep, 500
	Gosub Opcoes 
	MouseMove, %Membro3x%,%Membro3y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
	Return
	
Check10: ;Membro 4
Gui, Submit, NoHide
	MouseMove, %Membro1x%,%Membro1y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
	MouseMove, %Membro2x%,%Membro2y%, 5 RButton
	Sleep, 500
	Gosub Opcoes 
	MouseMove, %Membro3x%,%Membro3y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
	MouseMove, %Membro4x%,%Membro4y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
	Return
	
Check11: ;Membro 5
Gui, Submit, NoHide
	MouseMove, %Membro1x%,%Membro1y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
	MouseMove, %Membro2x%,%Membro2y%, 5 RButton
	Sleep, 500
	Gosub Opcoes 
	MouseMove, %Membro3x%,%Membro3y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
	MouseMove, %Membro4x%,%Membro4y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
	MouseMove, %Membro5x%,%Membro5y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
	Return
;=================================================================================
; Membros Buff_SM
;=================================================================================
Check12: ;Sozinho
Gui, Submit, NoHide
MouseGetPos, xpos, ypos
	MouseMove, xpos, ypos, 5 RButton
loop
{
Click down, right,
	Gosub Opcoes
Click Up, right,
}
Return

Check13: ;Membro 2
Gui, Submit, NoHide
	MouseMove, %Membro1x%,%Membro1y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
	MouseMove, %Membro2x%,%Membro2y%, 5 RButton
	Sleep, 500
	Gosub Opcoes 
Return

Check14: ;Membro 3
Gui, Submit, NoHide
	MouseMove, %Membro1x%,%Membro1y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
	MouseMove, %Membro2x%,%Membro2y%, 5 RButton
	Sleep, 500
	Gosub Opcoes 
	MouseMove, %Membro3x%,%Membro3y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
Return

Check15: ;Membro 4
Gui, Submit, NoHide
	MouseMove, %Membro1x%,%Membro1y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
	MouseMove, %Membro2x%,%Membro2y%, 5 RButton
	Sleep, 500
	Gosub Opcoes 
	MouseMove, %Membro3x%,%Membro3y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
	MouseMove, %Membro4x%,%Membro4y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
Return

Check16: ;Membro 5
Gui, Submit, NoHide
	MouseMove, %Membro1x%,%Membro1y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
	MouseMove, %Membro2x%,%Membro2y%, 5 RButton
	Sleep, 500
	Gosub Opcoes 
	MouseMove, %Membro3x%,%Membro3y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
	MouseMove, %Membro4x%,%Membro4y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
	MouseMove, %Membro5x%,%Membro5y%, 5 RButton
	Sleep, 500
	Gosub Opcoes
Return
;=================================================================================
;Hybrida
;=================================================================================
Hybrida:
Gui, Submit, NoHide
MouseMove, xpos, ypos, 10 RButton
Click down, right,
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
		sleep, 500
	Gosub Opcoes
	Send, {%SK2% Down}{%SK2% Up} ;For?   
		sleep, 500 
	Gosub Opcoes
	Send, {%SK3% Down}{%SK3% Up} ;For?
		sleep, 500
	Gosub Opcoes
	Send, {%SK4% Down}{%SK4% Up} ;SD
		sleep, 500
	Gosub Opcoes
	Send, {%SK6% Down}{%SK6% Up} ;I.Arrow
		Sleep 500
	Send, {%SK6% Down}{%SK6% Up} ;I.Arrow
		Sleep 500
	Send, {%SK6% Down}{%SK6% Up} ;I.Arrow
		sleep, 500
	Gosub Opcoes
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Send, {%SK5% Down}{%SK5% Up} ;Skill
		sleep, 500
	Gosub Opcoes
Click Up, right,
	
Loop, 3
{
Click down, right,
	Send, {%SK6% Down}{%SK6% Up} ;I.Arrow
		Sleep 500
	Send, {%SK6% Down}{%SK6% Up} ;I.Arrow
		Sleep 500
	Send, {%SK6% Down}{%SK6% Up} ;I.Arrow
		sleep, 1000
	Gosub Opcoes
	Send, {%SK5% Down}{%SK5% Up} ;Skill
	Send, {%SK5% Down}{%SK5% Up} ;Skill
		sleep, 1000
	Gosub Opcoes
Click Up, right,
Click down, right,
	MouseMove, 430,220, 5
	Gosub Opcoes
	MouseMove, 430,340, 5
	Gosub Opcoes
	MouseMove, 600,340, 5
	Gosub Opcoes
	MouseMove, 600,220, 5
	Gosub Opcoes
Click Up, right,
Gosub Opcoes
Click down, right,
	MouseMove, 340,220, 5
	Gosub Opcoes
	MouseMove, 340,340, 5
	Gosub Opcoes
	MouseMove, 680,340, 5
	Gosub Opcoes
	MouseMove, 680,220, 5
Click Up, right,
Gosub Opcoes
}
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	Send, {%SK1% Down}{%SK1% Up} ;Defesa
	MouseMove, xpos, ypos, 10 RButton
	Click down, right,
	Gosub Opcoes
	Click Up, right,
Return