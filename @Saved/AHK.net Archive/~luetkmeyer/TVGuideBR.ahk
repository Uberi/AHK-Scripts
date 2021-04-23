#NoEnv
#SingleInstance,Force
#NoTrayIcon
; SetBatchLines, 500ms
SetBatchLines, -1
SendMode Input
FileEncoding, UTF-8
Sleep, 200
FileReadLine, WorkingDir, %A_Temp%\TVGuideBR.txt, 1
If ErrorLevel = 1
	SetWorkingDir, %A_ScriptDir%	; %A_Temp%	%A_ScriptDir%  ; Choose directory.
else
	SetWorkingDir, %WorkingDir%

CurrentVersion := 20120415
SetTimer, AutoCheckUpdate, -15000
;Filedelete, PingCheckSky.txt
;Run, %comspec% /c ping -a -n 1 -w 5000 www.sky.com.br > PingCheckSky.txt,, Hide UseErrorLevel

SysGet, Mon, MonitorWorkArea
If ( MonRight < 1700 )
	Column = 6
If ( MonRight < 1400 )
	Column = 5
If ( MonRight < 1100 )
	Column = 4
wIMDBbrowser := MonRight - 510
hIMDBbrowser := MonBottom - 45

AgendaCount = 0
IniRead, FontSize, TVGuideBR.ini, Configs, FontSize, 10
IniRead, FontStyle, TVGuideBR.ini, Configs, FontStyle, bold
IniRead, FontColor1, TVGuideBR.ini, Configs, FontColor1, Lime
IniRead, FontColor2, TVGuideBR.ini, Configs, FontColor2, White
IniRead, Synopsis, TVGuideBR.ini, Configs, Synopsis, No
IniRead, GMT, TVGuideBR.ini, Configs, GMT, -4
IniRead, GradeDate, TVGuideBR.ini, Data, GradeDate, %A_dd%/%A_MM%
IniRead, ni, TVGuideBR.ini, Data, ni, 73
IniRead, AgendaCount, TVGuideBR.ini, Data, AgendaCount, 0
Gosub, Date

Gui, Font, , Tahoma
FontSize := FontSize . " " . FontStyle
GoGuiSize = Maximize

FileGetSize, Exist, Channels.txt
If ErrorLevel = 1
{
	Gosub, CreateFiles
	SetTimer, First, -1000
}
FileGetSize, Exist, Grade.txt
If ErrorLevel = 1
{
	Gosub, ButtonBaixardados
}
ni := ni * 4       ; ni has 4x weight
ni += 122    ; ni (defined when download) += 128 (total channels)     138  
ni += AgendaCount
Progress, R0-%ni% h15 w500 ZH15 ZX0 ZY0 CBLime CWBlack, , , Carregando grade...
;ni -= 2
Sleep, 100
FileDelete, TVGuideBRUpdater.exe
Progress, 1

Gui, font, norm s9
Gui, 5: font, norm white s9
Gui, Add, Button, x10 y5 h22 w30 gGrade_3, %GradeS_3%
Gui, 5: Add, Text, x0 y0 h22 w78, %GradeDateDescG%
Gui, 5: Add, Button, x+10 h22 w30 gGrade_3, %GradeS_3%
g = 2
Loop, 2
{
	Gui, Add, Button, x+0 h22 w30 gGrade_%g%, % GradeS_%g%
	Gui, 5: Add, Button, x+0 h22 w30 gGrade_%g%, % GradeS_%g%
	g--
}
Gui, font, bold
Gui, 5: font, bold
Gui, Add, Button, x+0 y5 h22 Default, Hoje
Gui, 5: Add, Button, x+0 h22 Default, Hoje
Gui, font, norm s9
Gui, 5: font, norm s9
Gui, Add, Button, x+0 y5 h22 w30 gGrade1, %GradeS1%
Gui, 5: Add, Button, x+0 h22 w30 gGrade1, %GradeS1%
g = 2
Loop, 2
{
	Gui, Add, Button, x+0 h22 w30 gGrade%g%, % GradeS%g%
	Gui, 5: Add, Button, x+0 h22 w30 gGrade%g%, % GradeS%g%
	g++
}
Gui, font, bold s10
Gui, 5: font, bold s10
Gui, 5: color, black
Gui, Add, Button, x+5 y5 h22, Baixar dados
Gui, 5: Add, Button, x+5 h22, Baixar dados

Gui, font, Bold cRed s12
StringLeft, GradeDateDescG, GradeDateDesc, 7
Gui, Add, Text, x1004 y5, %GradeDateDescG%    ; 950 to 1024

WinGetPos, X5Gui, Y5Gui, W5Gui, H5Gui, Carregando grade...
Y5Gui := ( Y5Gui + H5Gui )
;~ X5Gui := ( X5Gui + 1 )
Gui, 5: Add, Button, x+5 w75 h22, Sair
Gui, 5: font, cLime bold s14
Gui, 5: Add, Text, x0 y0 h22 w78, %GradeDateDescG%
Gui, 5: -E0x40000 -E0x100 +toolwindow -resize -caption +AlwaysOnTop
Gui, 5: Show, w506 h22 Center x%x5Gui% y%y5Gui%, Cancelar...

Gui, font, norm s9
Gui, Add, Button, x+5 y5 h22, Sky
Gui, Add, Button, x+0 y5 h22, Net
Gui, font, Bold cWhite s9
Gui, Add, Tab2, x336 y10 Buttons -Wrap y5 w650 choose9 center AltSubmit, Filmes|Seriados|Cultura|News|Esportes|Infantis|Abertos|Div|Mais|Agenda|Config
Gosub, Grade
p++
Progress, %p%, , , P R O N T O `,   c a r r e g a m e n t o   c o m p l e t o !
Gui, tab, Config
Gui, font, norm cYellow s10
Gui, Add, Text, x10 y40 gAbout, %A_Space%                        Sobre e mais detalhes (online):`nclique aqui para visitar o tópico oficial no forum da liguagem AHK.`n                                     by luetkmeyer
Gui, Add, Text, x68 y+8 gDonate, Suporte/donativo:
Gui, font, underline
Gui, Add, Text, x+2 gDonate, luetkmeyer@yahoo.com.br
Gui, font, norm bold cSilver s9
Gui, Add, Text, x5 y+17, Definir diretório de trabalho:
Gui, Add, Button, x+37 h22 yp-4, Atual
Gui, Add, Button, x+37 h22, Temporário
Gui, Add, Button, x400 y40 h22, Salvar
Gui, Add, Button, x+10 h22, Atualizar programa
Gui, Add, Button, x+10 h22, Restaurar padrões
Gui, Add, Text, x400 y+9, Fonte:
Gui, Add, Dropdownlist, x+7 yp-5 w40 vFontSize Choose6, 5|6|7|8|9|10|11|12|13|14
Gui, Add, Dropdownlist, x+10 w70 vFontStyle Choose1, Norm|Bold|Italic|Underline
Gui, Add, Dropdownlist, x+10 w70 vFontColor1 Choose2, Lime|White|Red|Silver|Yellow|Aqua|Blue|Fuchsia
Gui, Add, Dropdownlist, x+10 w70 vFontColor2 Choose1, Lime|White|Red|Silver|Yellow|Aqua|Blue|Fuchsia
Gui, Add, Text, x400 y+5, Baixar sinopses de programas antigos:
Gui, Add, Radio, vSynopsis x+0, Sim
Gui, Add, Radio, x+5 Checked, Não
Gui, Add, Text, x400 y+2, %A_Space%  SIM: o download dos dados gastará mais tempo`n               (25 kB para cada sinopse antiga).
Gui, Color, black
Gui, font, cWhite
Gui, Add, Text, x10 y155, Configuração: marque a checkbox para os canais desejados, escolha sua categoria e configure sua link (visitar online)
FileGetTime, DownloadDateM, Grade.txt, M
FormatTime, DownloadDateM, %DownloadDateM%, ddd, dd/MM/yyyy, HH:mm

hGui := WinExist()
OnMessage(0x115, "OnScroll") ; WM_VSCROLL
;OnMessage(0x114, "OnScroll") ; WM_HSCROLL
Gui, +LastFound
GroupAdd, MyGui, % "ahk_id " . WinExist()    ; %
;Gui, +E0x40000 +E0x100 +border +resize +0x200000             ; +0x200000 +0x300000 ; WS_VSCROLL | WS_HSCROLL
Gui, +E0x40000 +E0x100 +border +resize +0x200000     ; Scrool: +0x200000
Sleep, 250
Progress, Off
Gui, Show, Autosize Maximize, TVGuideBR (%A_Hour%:%A_Min%)                    Mostrando programação de: %GradeDateDesc%                    %GradeDateDescG%                    Arquivo baixado: %DownloadDateM%
WinMaximize, A
Progress, Off
Hotkey, IfWinActive, TVGuideBR (
Hotkey, Rbutton, FastScrollUp
Return

; Main ======================================================================================================================================================
Date:
{
	Grade0 = %A_YYYY%%A_MM%%A_DD%
	g = 1
	Loop, 3
	{
		Grade%g% := Grade0
		Grade%g% += %g%, days
		FormatTime, GradeS%g%, % Grade%g%, ddd
		FormatTime, Grade%g%, % Grade%g%, dd/MM
		g++
	}
	g = 1
	Loop, 3
	{
		Grade_%g% := Grade0
		Grade_%g% += -%g%, days
		FormatTime, GradeS_%g%, % Grade_%g%, ddd
		FormatTime, Grade_%g%, % Grade_%g%, dd/MM
		g++
	}
	FormatTime, Grade0, Grade0, dd/MM
	GradeDatedesc := GradeDate
	StringSplit, GradeDatedesc, GradeDatedesc, /
	GradeDateDesc := A_yyyy . GradeDatedesc2 . GradeDatedesc1
	FormatTime, GradeDateDesc, %GradeDateDesc%, ddd, dd/MM/yyyy
}
Return

Grade:
{
	FileRead, GradeData, Grade.txt
	h1 := A_Hour
	h2 := A_Hour
	h1--
	h2++
	StringLen, hL, h1
	If hL = 1
		h1 := "0" . h1
	StringLen, hL, h2
	If hL = 1
		h2 := "0" . h2
	ymais = 30
	p++
	Progress, %p%
	Loop, Parse, GradeData, |
	{
		j = 1
		Loop, Parse, A_LoopField, `n
		{
			LoopField := Decode( A_LoopField )
			StringSplit, List, LoopField, @
			If j = 1
			{
				Gosub, Categorie
				Gui, font, c%FontColor1% s%FontSize% bold
				CategoryTemp = %List2%
				Gui, Tab, % CategoryTemp  ;%
				Gui, Add, Button, x%x% y%y% h15 w15 gGoIDChannel -wrap Left, % "> " . List3
				Gui, Add, Text, x+0, % List1  ; %
				If ( ymais <= ynobre )
					ymais := ynobre
				ymais += 5
				Gui, Tab, Mais  ;%
				Gui, Add, Button, x0 y%ymais% h15 w15 gGoIDChannel -wrap Left, % "> " . List3
				Gui, Add, Text, x+0, % List1 . "_______________________________________________________________________________________________________________________________________________________________" ; %
				ycat := y
				ymais += 20
				ynobre := ymais
				j++
				p += 4
				Progress, %p%, , , Carregando grade (%GradeDateDescG%) do canal: %List1% 
				tempChannel = %list1%
			}
			else
			{
				MaisCount = 0
				Gui, font, c%FontColor2% s%FontSize%
				StringLeft, DateList, List1, 5
				If ( GradeDate = DateList )
				{
					ycat += 17
					MaisCount = 0
					NobreCount = 0
					AdPlus1 = Yes
					StringTrimLeft, List1, List1, 6
					StringLeft, List1, List1, 38
					StringLen, List3Count, List3
					List3Count--
					StringLeft, List3, List3, %List3Count%
					Gui, Tab, % CategoryTemp
					Gui, Add, Button, x%x% y%ycat% h15 w15 gGoID -wrap Left, % "> " . List3
					StringReplace, List1, List1, %A_Space%-%A_Space%, <->,
					if List1 contains %A_Hour%:
					{
						StringReplace, List1, List1, <->, %A_Space%=%A_Space%,
						MaisCount = 1
					}
					if List1 contains %h1%:,%h2%:
					{
						StringReplace, List1, List1, <->, %A_Space%%A_Space%-%A_Space%,
						MaisCount = 1
					}
					if List1 contains 19:,20:,21:,22:
					{
						StringReplace, List1, List1, <->, %A_Space%+%A_Space%,
						NobreCount = 1
					}
					StringReplace, List1, List1, <->, %A_Space%%A_Space%%A_Space%%A_Space%,
					Gui, Add, Text, x+0, % List1
					If ( MaisCount = 1 )
					{
						Gui, font, cLime s%FontSize%
						Gui, Tab, Mais
						Gui, Add, Button, x15 y%ymais% h15 w15 gGoID -wrap Left, % "> " . List3
						Gui, Add, Text, x+0, % List1
						ymais += 17
					}
					If ( NobreCount = 1 )
					{
						Gui, font, cYellow s%FontSize%
						Gui, Tab, Mais
						Gui, Add, Button, x365 y%ynobre% h15 w15 gGoID -wrap Left, % "> " . List3
						Gui, Add, Text, x+0, % List1
						ynobre += 17
					}
					v%List3%v := tempChannel "`n`n" . List1 . "`n`n" . List2
					a%List3%a := GradeDate . " " List1 . " |"tempChannel . "     " . List2
				}
				If (GradeDate < DateList AND AdPlus1 = "Yes")
				{
					ycat += 17
					MaisCount = 0
					StringTrimLeft, List1, List1, 6
					StringLeft, List1, List1, 38
					StringLen, List3Count, List3
					List3Count--
					StringLeft, List3, List3, %List3Count%
					Gui, Tab, % CategoryTemp
					Gui, Add, Button, x%x% y%ycat% h15 w15 gGoID -wrap Left, % "> " . List3
					StringReplace, List1, List1, %A_Space%-%A_Space%, <->,
					if List1 contains %A_Hour%:
					{
						StringReplace, List1, List1, <->, %A_Space%=%A_Space%,
						MaisCount = 1
					}
					if List1 contains %h1%:,%h2%:
					{
						StringReplace, List1, List1, <->, %A_Space%%A_Space%-%A_Space%,
						MaisCount = 1
					}
					if List1 contains 19:,20:,21:,22:
					{
						StringReplace, List1, List1, <->, %A_Space%+%A_Space%,
						NobreCount = 1
					}
					StringReplace, List1, List1, <->, %A_Space%%A_Space%%A_Space%%A_Space%,
					Gui, Add, Text, x+0, % List1
					If ( MaisCount = 1 )
					{
						Gui, font, cLime s%FontSize%
						Gui, Tab, Mais
						Gui, Add, Button, x15 y%ymais% h15 w15 gGoID -wrap Left, % "> " . List3
						Gui, Add, Text, x+0, % List1
						ymais += 17
					}
					If ( NobreCount = 1 )
					{
						Gui, font, cYellow s%FontSize%
						Gui, Tab, Mais
						Gui, Add, Button, x365 y%ynobre% h15 w15 gGoID -wrap Left, % "> " . List3
						Gui, Add, Text, x+0, % List1
						ynobre += 17
					}
					v%List3%v := tempChannel "`n`n" . List1 . "`n`n" . List2
					a%List3%a := GradeDate . " " List1 . " |"tempChannel . "     " . List2
					AdPlus1 = No
				}
			}
		}
		j = 1
	}
	
    /*
	Loop, read, PingCheckSky.txt
    {
        If A_LoopReadLine contains dia
        {
            Loop, parse, A_LoopReadLine, `,
            {
                If A_LoopField contains dia
                {
                    msT := A_LoopField
                    StringRight, msTT, msT, 6
                    StringLeft, ms, msTT, 3
                }
            }
        }
        If A_LoopReadLine contains esgotado
        {
            mse = *
        } 
    }
    if ms contains %A_SPACE%
    {
        StringReplace, ms, ms, %A_SPACE%,, All
    }
    if ms contains *
    {
        StringReplace, ms, ms, *,, All
    }
    if ms contains =
    {
        StringReplace, ms, ms, =,, All
    }
	if ( ms < 100 )
		pingdesc = rápido
	if ( ms < 300 )
		pingdesc = normal
	if ( ms < 500 )
		pingdesc = lento
	if ( ms < 1000 )
		pingdesc = muito lento
	if ( ms < 1000 )
		pingdesc = congestionado
	if ( ms < 1000 )
		pingdesc = muito congestionado
	if ( ms < 5000 )
		pingdesc = respondeu em 5 s.
	if ( ms < 10000 )
		pingdesc = NÃO respondeu em 5 s.
	if ( mse = "*" )
		pingdesc = NÃO respondeu em 5 s.
	*/
	
	Progress, %p%, , , Carregando configurações... ; Servidor: %ms% ms (%pingdesc%)
	i = 1 ; Mount channels on config tab
	j = 1
	c = 13
	xC = 10
	xCd = 250
	yC = 172
	FileRead, GradeData, Channels.txt
	Loop, Parse, GradeData, `n, `r 
	{
		Loop, parse, A_LoopField, `,
		{
			ListC_%i%_%j% = %A_LoopField%
			j++
		}
		Gui, font, bold cRed s10
		Gui, Tab, Config		
		Checked := ListC_%i%_2 
		Gui, Add, CheckBox, x%xC% y%yC% h30 w250 vOnOffC%i% Checked%Checked% -wrap, % ListC_%i%_1 . "  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -"
		if ( ListC_%i%_3 = "Filmes" )
			Cat = 1
		if ( ListC_%i%_3 = "Seriados" )
			Cat = 2
		if ( ListC_%i%_3 = "Cultura" )
			Cat = 3
		if ( ListC_%i%_3 = "News" )
			Cat = 4
		if ( ListC_%i%_3 = "Esportes" )
			Cat = 5
		if ( ListC_%i%_3 = "Infantis" )
			Cat = 6
		if ( ListC_%i%_3 = "Abertos" )
			Cat = 7
		if ( ListC_%i%_3 = "Div" )
			Cat = 8
		Gui, Add, Dropdownlist, x%xCd% y%yC% w100 vCatC%i% Choose%Cat%, Filmes|Seriados|Cultura|News|Esportes|Infantis|Abertos|Div
		Gui, Add, Edit, x+1 w650 h30 vUrlC%i% -wrap, % ListC_%i%_5
		ChannelDescC%i% := ListC_%i%_1
		ChannelDescCStatus := ListC_%i%_1
		yC += 31
		i++
		j = 1
		c++
		;if c > 36  ; without scroll
		;{
		;	yC = 40
		;	xC += 325
		;	xCd += 325
		;	c = 0
		;}
		p++
		;Progress, %p%, , , Servidor: %ms% ms (%pingdesc%) / Carregando configuração do canal: %ChannelDescCStatus% 
		Progress, %p%, , , Carregando configuração do canal: %ChannelDescCStatus% 
	}
	
	/*
	Loop, read, PingCheckSky.txt
    {
        If A_LoopReadLine contains dia
        {
            Loop, parse, A_LoopReadLine, `,
            {
                If A_LoopField contains dia
                {
                    msT := A_LoopField
                    StringRight, msTT, msT, 6
                    StringLeft, ms, msTT, 3
                }
            }
        }
        If A_LoopReadLine contains esgotado
        {
            mse = *
        } 
    }
    if ms contains %A_SPACE%
    {
        StringReplace, ms, ms, %A_SPACE%,, All
    }
    if ms contains *
    {
        StringReplace, ms, ms, *,, All
    }
    if ms contains =
    {
        StringReplace, ms, ms, =,, All
    }
	if ( ms < 100 )
		pingdesc = rápido
	if ( ms < 300 )
		pingdesc = normal
	if ( ms < 500 )
		pingdesc = lento
	if ( ms < 1000 )
		pingdesc = muito lento
	if ( ms < 1000 )
		pingdesc = congestionado
	if ( ms < 1000 )
		pingdesc = muito congestionado
	if ( ms < 5000 )
		pingdesc = respondeu em 5 s.
	if ( ms < 10000 )
		pingdesc = NÃO respondeu em 5 s.
	if ( mse = "*" )
		pingdesc = NÃO respondeu em 5 s.
	*/
	
	Gui, 5: Destroy
	Sleep, 100
	p++
	;Progress, %p%, , , Servidor: %ms% ms (%pingdesc%) / Carregando programas agendados... 
	Progress, %p%, , , Carregando programas agendados... 
	Gui, font, bold cWhite s12
	Gui, Tab, Agenda
	Gui, Add, Button, x10 y+10 h25, Organizar
	Gui, Add, Button, x+64 h25, Abrir agendamentos
	Gui, Add, Button, x+63 h25, Apagar agendamentos
	FileRead, Agenda, Agenda.txt
	FileDelete, Agenda.txt
	Sort, Agenda, U
	AgendaCount = 0
	Loop, Parse, Agenda, `n`n, `r 
	{
		AgendaLine = %A_LoopField%
		StringLeft, Agenda_temp,AgendaLine, 5
		StringLeft, Agenda_ddtemp,Agenda_temp, 2
		StringRight, Agenda_mmtemp,Agenda_temp, 2
		Agenda_md = %Agenda_mmtemp%%Agenda_ddtemp%
		AgendaDateNow = %A_MM%%A_dd%
		If ( Agenda_md >= AgendaDateNow )		
		{
			StringSplit,AgendaLine,AgendaLine,|,
			StringReplace,AgendaLine1,AgendaLine1,-,%A_Space%
			StringReplace,AgendaLine1,AgendaLine1,+,%A_Space%%A_Space%
			StringReplace,AgendaLine1,AgendaLine1,=,%A_Space%%A_Space%
			Gui, Tab, Agenda
			Gui, font, cWhite s12
			Gui, Add, Checkbox, x10 y+5 w550, %AgendaLine1% 
			Gui, Add, Text, xp+405 w580, %AgendaLine2%
			Gui, font, cLime s6
			Gui, Add, Text, x10 y+0, _____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
			AgendaSave .= AgendaLine1 . "|" . AgendaLine2 . "`n`n"
			StringSplit,AgendaLine2,AgendaLine2,%A_Space%%A_Space%,
			if AgendaLine1 contains %h1%:,%h2%:
				StringReplace, AgendaLine1, AgendaLine1, %A_Space%%A_Space%%A_Space%, %A_Space%-%A_Space%,
			if AgendaLine1 contains %A_Hour%:
				StringReplace, AgendaLine1, AgendaLine1, %A_Space%%A_Space%%A_Space%, %A_Space%=%A_Space%,
			AgendaSaveMais .= A_Space . A_Space . A_Space . AgendaLine1 . A_Space . A_Space . A_Space . AgendaLine21 . " " . AgendaLine22 . "`n"
			AgendaCount++
		}
		p++
		Progress, %p%
	}
	IniWrite, %AgendaCount%, TVGuideBR.ini, Data, AgendaCount
	Fileappend, %AgendaSave%, Agenda.txt
	Gui, Tab, Mais
	Gui, font, cWhite s%FontSize%
		;Gui, Add, Text, x730 y35 w1000, %AgendaSaveMais% 
	Gui, Add, Text, x730 y35 w1000, Agenda Compacta
	Loop, Parse, AgendaSaveMais, `n
		Gui, Add, Checkbox, y+0 w1000, %A_LoopField%

	}
Return

Categorie:
{
	if List2 = Filmes
	{
		if ( Filmes < Column )
		{
			Filmes++
			x := 250 * Filmes - 240
			y := 30
		}
		Else
		{
			if ( Filmes < Column * 2  )
			{
				Filmes++
				x := 250 * ( Filmes - Column ) - 240
				y := 480
			}
			Else
			{
				if (Filmes < Column * 3 )
				{
					Filmes++
					x := 250 * ( Filmes - ( Column * 2 ) ) - 240
					y := 930
				}
				Else
				{
					if (Filmes < Column * 4  )
					{
						Filmes++
						x := 250 * ( Filmes - ( Column * 3 ) ) - 240
						y := 1380
					}
					else
					{
						if (Filmes < Column * 5  )
						{
							Filmes++
							x := 250 * ( Filmes - ( Column * 4 ) ) - 240
							y := 1830
						}
						else
						{
							if (Filmes < Column * 6  )
							{
								Filmes++
								x := 250 * ( Filmes - ( Column * 5 ) ) - 240
								y := 2280
							}
							else
							{
								if (Filmes < Column * 7  )
								{
									Filmes++
									x := 250 * ( Filmes - ( Column * 6 ) ) - 240
									y := 2730
								}
							}
						}
					}
				}
			}
		}
	}
	if List2 = Seriados
	{
		if ( Seriados < Column )
		{
			Seriados++
			x := 250 * Seriados - 240
			y := 30
		}
		Else
		{
			if ( Seriados < Column * 2  )
			{
				Seriados++
				x := 250 * ( Seriados - Column ) - 240
				y := 750
			}
			Else
			{
				if (Seriados < Column * 3 )
				{
					Seriados++
					x := 250 * ( Seriados - ( Column * 2 ) ) - 240
					y := 1470
				}
				Else
				{
					if (Seriados < Column * 4  )
					{
						Seriados++
						x := 250 * ( Seriados - ( Column * 3 ) ) - 240
						y := 2190
					}
				}
			}
		}
	}
	if List2 = Abertos
	{
		if ( Abertos < Column )
		{
			Abertos++
			x := 250 * Abertos - 240
			y := 30
		}
		Else
		{
			if ( Abertos < Column * 2  )
			{
				Abertos++
				x := 250 * ( Abertos - Column ) - 240
				y := 800
			}
			Else
			{
				if (Abertos < Column * 3 )
				{
					Abertos++
					x := 250 * ( Abertos - ( Column * 2 ) ) - 240
					y := 1570
				}
				Else
				{
					if (Abertos < Column * 4  )
					{
						Abertos++
						x := 250 * ( Abertos - ( Column * 3 ) ) - 240
						y := 2340
					}
				}
			}
		}
	}
	if List2 = Cultura
	{
		if ( Cultura < Column )
		{
			Cultura++
			x := 250 * Cultura - 240
			y := 30
		}
		Else
		{
			if ( Cultura < Column * 2  )
			{
				Cultura++
				x := 250 * ( Cultura - Column ) - 240
				y := 800
			}
			Else
			{
				if (Cultura < Column * 3 )
				{
					Cultura++
					x := 250 * ( Cultura - ( Column * 2 ) ) - 240
					y := 1570
				}
				Else
				{
					if (Cultura < Column * 4  )
					{
						Cultura++
						x := 250 * ( Cultura - ( Column * 3 ) ) - 240
						y := 2340
					}
				}
			}
		}
	}
	if List2 = News
	{
		if ( News < Column )
		{
			News++
			x := 250 * News - 240
			y := 30
		}
		Else
		{
			if ( News < Column * 2  )
			{
				News++
				x := 250 * ( News - Column ) - 240
				y := 800
			}
			Else
			{
				if (News < Column * 3 )
				{
					News++
					x := 250 * ( News - ( Column * 2 ) ) - 240
					y := 1570
				}
				Else
				{
					if (News < Column * 4  )
					{
						News++
						x := 250 * ( News - ( Column * 3 ) ) - 240
						y := 2340
					}
				}
			}
		}
	}
	if List2 = Div
	{
		if ( Div < Column )
		{
			Div++
			x := 250 * Div - 240
			y := 30
		}
		Else
		{
			if ( Div < Column * 2  )
			{
				Div++
				x := 250 * ( Div - Column ) - 240
				y := 800
			}
			Else
			{
				if (Div < Column * 3 )
				{
					Div++
					x := 250 * ( Div - ( Column * 2 ) ) - 240
					y := 1570
				}
				Else
				{
					if (Div < Column * 4  )
					{
						Div++
						x := 250 * ( Div - ( Column * 3 ) ) - 240
						y := 2340
					}
				}
			}
		}
	}
	if List2 = Esportes
	{
		if ( Esportes < Column )
		{
			Esportes++
			x := 250 * Esportes - 240
			y := 30
		}
		Else
		{
			if ( Esportes < Column * 2  )
			{
				Esportes++
				x := 250 * ( Esportes - Column ) - 240
				y := 800
			}
			Else
			{
				if (Esportes < Column * 3 )
				{
					Esportes++
					x := 250 * ( Esportes - ( Column * 2 ) ) - 240
					y := 1570
				}
				Else
				{
					if (Esportes < Column * 4  )
					{
						Esportes++
						x := 250 * ( Esportes - ( Column * 3 ) ) - 240
						y := 2340
					}
				}
			}
		}
	}
	if List2 = Infantis
	{
		if ( Infantis < Column )
		{
			Infantis++
			x := 250 * Infantis - 240
			y := 30
		}
		Else
		{
			if ( Infantis < Column * 2  )
			{
				Infantis++
				x := 250 * ( Infantis - Column ) - 240
				y := 800
			}
			Else
			{
				if (Infantis < Column * 3 )
				{
					Infantis++
					x := 250 * ( Infantis - ( Column * 2 ) ) - 240
					y := 1570
				}
				Else
				{
					if (Infantis < Column * 4  )
					{
						Infantis++
						x := 250 * ( Infantis - ( Column * 3 ) ) - 240
						y := 2340
					}
				}
			}
		}
	}
}			
Return





; About data ======================================================================================================================================================

5ButtonHoje:
Gui, 5: Destroy
ButtonHoje:
{
	GradeDate = %Grade0%
	IniWrite, %GradeDate%, TVGuideBR.ini, Data, GradeDate
	IniWrite, %AgendaCount%, TVGuideBR.ini, Data, AgendaCount
	reload
}
return

Grade_3:
{
	GradeDate = %Grade_3%
	IniWrite, %GradeDate%, TVGuideBR.ini, Data, GradeDate
	IniWrite, %AgendaCount%, TVGuideBR.ini, Data, AgendaCount
	reload
}
return

Grade_2:
{
	
	GradeDate = %Grade_2%
	IniWrite, %GradeDate%, TVGuideBR.ini, Data, GradeDate
	IniWrite, %AgendaCount%, TVGuideBR.ini, Data, AgendaCount
	reload
}
return

Grade_1:
{
	
	GradeDate = %Grade_1%
	IniWrite, %GradeDate%, TVGuideBR.ini, Data, GradeDate
	IniWrite, %AgendaCount%, TVGuideBR.ini, Data, AgendaCount
	reload
}
return

Grade3:
{
	GradeDate = %Grade3%
	IniWrite, %GradeDate%, TVGuideBR.ini, Data, GradeDate
	IniWrite, %AgendaCount%, TVGuideBR.ini, Data, AgendaCount
	reload
}
return

Grade2:
{
	GradeDate = %Grade2%
	IniWrite, %GradeDate%, TVGuideBR.ini, Data, GradeDate
	IniWrite, %AgendaCount%, TVGuideBR.ini, Data, AgendaCount
	reload
}
return

Grade1:
{
	GradeDate = %Grade1%
	IniWrite, %GradeDate%, TVGuideBR.ini, Data, GradeDate
	IniWrite, %AgendaCount%, TVGuideBR.ini, Data, AgendaCount
	reload
}
return

5ButtonBaixarDados:
ButtonBaixarDados:
{
	Gui, 5: Destroy
	;Filedelete, PingCheckSky.txt
	;Msgbox, , Checando condições do servidor..., Iniciando a checagem das condições de download do servidor..., 2
	;Runwait, %comspec% /c ping -a -n 1 -w 10000 www.sky.com.br > PingCheckSky.txt,, Hide UseErrorLevel
	;Sleep, 500
	/*
	Loop, read, PingCheckSky.txt
    {
        If A_LoopReadLine contains dia
        {
            Loop, parse, A_LoopReadLine, `,
            {
                If A_LoopField contains dia
                {
                    msT := A_LoopField
                    StringRight, msTT, msT, 6
                    StringLeft, ms, msTT, 3
                }
            }
        }
        If A_LoopReadLine contains esgotado
        {
            mse = *
        } 
    }
    if ms contains %A_SPACE%
    {
        StringReplace, ms, ms, %A_SPACE%,, All
    }
    if ms contains *
    {
        StringReplace, ms, ms, *,, All
    }
    if ms contains =
    {
        StringReplace, ms, ms, =,, All
    }
	if ( ms < 100 )
		pingdesc = rápido
	if ( ms < 300 )
		pingdesc = normal
	if ( ms < 500 )
		pingdesc = lento
	if ( ms < 1000 )
		pingdesc = muito lento
	if ( ms < 1000 )
		pingdesc = congestionado
	if ( ms < 1000 )
		pingdesc = muito congestionado
	if ( ms < 10000 )
		pingdesc = respondeu em 10 s.
	if ( mse = "*" )
		pingdesc = NÃO respondeu em 10 s.
	Msgbox, ,Estado do servidor, Velocidade do servidor: %pingdesc% (%ms%), 2
	*/
	IniRead, nc, TVGuideBR.ini, Data, nc, 50
	p = 0
	ni = 0
	nc1 := nc + 1
	XP := MonRight - 245
	YP := MonBottom - 75
	Progress, R0-%nc1% x%XP% y%YP% h20 w240 ZH20 ZX0 ZY0 CBLime CWBlack, , , Progress, %p%, , , Baixando canal %p% de %nc%.
	Progress, %p%, , , Baixando canal %p% de %nc%.
	Sleep, 500
	FileDelete, Grade.txt  
	WinGetPos, X3Gui, Y3Gui, W3Gui, H3Gui, Baixando canal
	Y3Gui := ( Y3Gui + H3Gui )
	X3Gui := ( X3Gui + 3 )            ; W3Gui )
	Gui, 3: -E0x40000 -E0x100 +toolwindow -resize -caption +AlwaysOnTop
	Gui, 3: color, black
	Gui, 3: font, bold s8
	Gui, 3: Add, Button, x0 y0 w80 h20 default, Ocultar
	Gui, 3: Add, Button, x+0 y0 w80 h20, Recarregar
	Gui, 3: Add, Button, x+0 y0 w80 h20, Sair
	Gui, 3: show, w240 h20 Center x%x3Gui% y%y3Gui%, Cancelar...
	;Gui, 3: show, w60 h30 Center x%X3Gui%, Cancelar.
	Sleep, 500
	FormatTime, DateDDMM, %DateInfo%, LongDate
	IniWrite, %DateDDMM%, TVGuideBR.ini, Data, DateData
	i = 1
	j = 1
	FileRead, GradeData, Channels.txt
	Loop, Parse, GradeData, `n, `r 
	{
		Loop, parse, A_LoopField, `,
		{
			List_%i%_%j% = %A_LoopField%
			j++
		}
		
		/*
		if List_%i%_1 = SBT
		{
			ni++
			p++
			DataSBT1 = %A_DD%/%A_MM%--
			Progress, %p%, , , % "Baixando " . p . "/" . nc . " (| " . List_%i%_1 . ")."
			FileAppend, % List_%i%_1 . "@" . List_%i%_3 . "@" . List_%i%_5 . "`n" , Grade.txt
			href1 := "http://www.sbt.com.br/programacao"
			UrlDownloadToFile, %href1%, href1.txt
			Progress, %p%, , , % "Baixando " . p . "/" . nc . " (/ " . List_%i%_1 . ")."			
			FileRead, href1, href1.txt
			Loop, Parse, href1, `n, `r
			{
				If A_Index > 150
				{
					If A_LoopField contains </strong>&nbsp
					{
						StringReplace, DataSBT, A_LoopField, </li>,</li>`n%A_DD%/%A_MM%--,All
						HTM = %DataSBT%
						DataSBT := UnHTM( HTM )
						DataSBT1 .= DataSBT
					}
				}
			}
			Progress, %p%, , , % "Baixando " . p . "/" . nc . " (- " . List_%i%_1 . ")."	
			DataSBTAll =
			Loop, Parse, DataSBT1, `n, `r
			{
				If A_LoopField contains `:
				{
					StringReplace, DataSBT, A_LoopField, %A_Space%,%A_Space%-%A_Space%,
					DataSBTAll .= DataSBT . "@SBT: nÃ£o hÃ¡ sinopses e opÃ§Ãµes para este canal. Visite SBT online (botÃ£o SBT) para mais detalhes. Escolha NÃ£o nesta caixa!@000000`n"
				}
			}
			Progress, %p%, , , % "Baixando " . p . "/" . nc . " (\ " . List_%i%_1 . ")."	
			StringReplace, DataSBTAll, DataSBTAll, --,%A_Space%,All
			FileAppend, %DataSBTAll%, Grade.txt
			Sleep, 100
			break
		} 
		*/
		if List_%i%_2 = 1
		{
			FileDelete, TVGuideBR_DLtemp.txt
			ni++
			p++
			Progress, %p%, , , % "Baixando " . p . "/" . nc . " (| " . List_%i%_1 . ")."
			FileAppend, % List_%i%_1 . "@" . List_%i%_3 . "@" . List_%i%_5 . "`n" , Grade.txt
			ChCode := List_%i%_4
			;href1 := "http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=" . ChCode
			;href1 := "http://www.sky.com.br/guiadatv/canais/canal.aspx?__qsCanal=" . ChCode
			href1 := "http://www.sky.com.br/servicos/Guiadatv/rssGradeProgramacao.ashx?qChave=" . ChCode
			;href2 := "http://www.sky.com.br/guiadatv/canais/canal.aspx?__qsCanal=" . ChCode . "&__qsModo=Rss"
			;FileAppend, %href2%, TVGuideBR_DLtemp.txt
			;IfNotExist, TVGuideBR_Downloader.exe
				;URLDownloadToFile, http://www.autohotkey.net/~luetkmeyer/TVGuideBR_Downloader.exe, TVGuideBR_Downloader.exe
			;Sleep, 250
			;Run, TVGuideBR_Downloader.exe
			Progress, %p%, , , % "Baixando " . p . "/" . nc . " (/ " . List_%i%_1 . ")."
			UrlDownloadToFile, %href1%, href1.txt
			Progress, %p%, , , % "Baixando " . p . "/" . nc . " (- " . List_%i%_1 . ")."	
			;Sleep, 250
			;UrlDownloadToFile, %href2%, href2.txt
			FileRead, href1, href1.txt
			StringReplace, href1, href1, <item>, ¢, All
			StringReplace, href1, href1, ><, ¤, All			
			Loop, Parse, href1, ¢,  ;`n, `r
			{				
				Programas:
				Loop, Parse, A_LoopField, ¤,  ;  `n, `r
				{
					If A_LoopField contains SKY
						break programas
					If A_LoopField contains title>
					{
						StringReplace, Title, A_LoopField, title>Data%A_Space%,,All
						StringReplace, Title, Title, </title,,All
						;StringReplace, Title, Title, %A_Tab%%A_Tab%%A_Tab%%A_Tab%,,All
						StringReplace, Title, Title, @, A,All
						StringReplace, Title, Title, |, ,All
						StringReplace, Title, Title, <, ,All
						StringReplace, Title, Title, /12,/%A_MM%,All
						StringLeft, TimeHHref, Title, 8
						StringTrimLeft, TimeHHref, TimeHHref, 6
						TimeHH := TimeHHref + 3
						TimeHH := TimeHH + GMT
						TimeHH := SubStr("00" . TimeHH, -1)
						StringReplace, Title, Title, %A_Space%%TimeHHref%, %A_Space%%TimeHH%
						StringReplace, Title, Title, %A_Space%-1, %A_Space%23
					}
					If A_LoopField contains description>
					{
						StringReplace, Desc, A_LoopField, description>,,All
						StringReplace, Desc, Desc, </description,,All
						;StringReplace, Desc, Desc, %A_Tab%%A_Tab%%A_Tab%%A_Tab%,,All
						;StringReplace, Desc, Desc, <br/><br/>,%A_Space%,All
						StringReplace, Desc, Desc, @, A,All
						StringReplace, Desc, Desc, `n,,All
						StringReplace, Desc, Desc, |, ,All
						StringReplace, Desc, Desc, Assista mais desta programação em HD. ,,All
						StringReplace, Desc, Desc, |, ,All
					}
					If A_LoopField contains link>
					{
						StringReplace, Link, A_LoopField, link>Ficha.aspx?_qsFicha=,,All
						StringReplace, Link, Link, </link,,All
						;StringReplace, Link, Link, %A_Tab%%A_Tab%%A_Tab%%A_Tab%,,All
						FileAppend, %Title%@%Desc%@%link%`n, Grade.txt
					}
				}
				;exitapp
				
			;Progress, %p%, , , % "Baixando " . p . "/" . nc . " (| " . List_%i%_1 . ")."
				
				/*
				If A_LoopField contains ../Ficha/Default.aspx?__qsFicha=
				{
					StringReplace, Date, A_LoopField, <td width="10"></td><td>,,
					StringReplace, Date, Date, </td><td width="10"></td><td>,%A_Space%,
					StringReplace, Date, Date, </td>,%A_Space%-%A_Space%@,
					StringReplace, Date, Date, %A_Tab%%A_Tab%,,All
					StringSplit, Date, Date, @,
					StringReplace, Date2, Date2, <td width="10"></td><td><a href='../Ficha/Default.aspx?__qsFicha=,,
					StringReplace, Date2, Date2, '>,@,
					StringSplit, Link, Date2, @,
					StringReplace, Title, Link2, </a></td><td width="10"></td>,,
					StringTrimLeft, Time1, Date1, 6
					StringLeft, Time1, Time1, 5
					StringLeft, Time2, Time1, 2
					Time3 = %A_Hour%
					If ( Time2 <= Time3 )
					{
						If ( Synopsis = "Yes" )
						{
							Progress, %p%, , , % "Baixando " . p . "/" . nc . " (SYN: " . List_%i%_1 . ")."
							href3 := "http://www.sky.com.br/guiadatv/Ficha/Default.aspx?__qsFicha=" . Link1
							UrlDownloadToFile, %href3%, href3.txt
							FileRead, href3, href3.txt
							Loop, Parse, href3, `n, `r
							{
								If A_LoopField contains <div id="ctl00_ContentPlaceHolder_FreeBox_canBoxRed_Descricao_dProgramDescription">
								{
									StringReplace, Desc, A_LoopField, <div id="ctl00_ContentPlaceHolder_FreeBox_canBoxRed_Descricao_dProgramDescription">,,
									StringReplace, Desc, Desc, </div>,,
									StringTrimLeft, Desc, Desc, 14
									StringReplace, Desc, Desc, <br/><br/>,%A_Space%,All
									StringReplace, Desc, Desc, <br>,,All
									StringReplace, Desc, Desc, @,%A_Space%at%A_Space%,All
									StringReplace, Desc, Desc, `n,,All
								}
							}
							StringReplace, Date1, Date1, @, A,
							StringReplace, Desc, Desc, |, ,All
							StringReplace, Desc, Desc, Assista mais desta programação em HD. ,,All
							StringReplace, Title, Title, |, ,All
							StringLeft, TimeHHref, Date1, 8
							StringTrimLeft, TimeHHref, TimeHHref, 6
							TimeHH := TimeHHref + 3
							TimeHH := TimeHH + GMT
							TimeHH := SubStr("00" . TimeHH, -1)
							StringReplace, Date1, Date1, %A_Space%%TimeHHref%, %A_Space%%TimeHH%
							StringReplace, Date1, Date1, %A_Space%-1, %A_Space%23
							FileAppend, %Date1%%Title%@%Desc%@%Link1%`n, Grade.txt
						}
						else
						{
							StringReplace, Date1, Date1, @, A,
							StringReplace, Desc, Desc, |, ,All
							StringReplace, Title, Title, |, ,All
							StringLeft, TimeHHref, Date1, 8
							StringTrimLeft, TimeHHref, TimeHHref, 6
							TimeHH := TimeHHref + 3
							TimeHH := TimeHH + GMT
							TimeHH := SubStr("00" . TimeHH, -1)
							StringReplace, Date1, Date1, %A_Space%%TimeHHref%, %A_Space%%TimeHH%
							StringReplace, Date1, Date1, %A_Space%-1, %A_Space%23
							FileAppend, %Date1%%Title%@A opção para sincronizar sinopses antigas está desabilitada.@%Link1%`n, Grade.txt
						}
					}
					else
					{
						break
					}
				}
				*/
			}
			/*
			Progress, %p%, , , % "Baixando " . p . "/" . nc . " (- " . List_%i%_1 . ")."
			Sleep, 250
			loop,
			{
				Sleep, 250
				Process, Exist, TVGuideBR_Downloader.exe
				If ErrorLevel = 0
					Break
			}
			Progress, %p%, , , % "Baixando " . p . "/" . nc . " (\ " . List_%i%_1 . ")."
			FileRead, href2, href4.txt
			Sleep, 250
			Filedelete, href4.txt
			Loop, Parse, href2, <item>, ;  `n, `r
			{
				If A_LoopField contains <title><![CDATA[Data
				{
					StringReplace, Title, A_LoopField, <title><![CDATA[Data%A_Space%,,All
					StringReplace, Title, Title, ]]></title>,,All
					StringReplace, Title, Title, %A_Tab%%A_Tab%%A_Tab%%A_Tab%,,All
					StringReplace, Title, Title, @, A,All
					StringReplace, Title, Title, |, ,All
				}
				If A_LoopField contains /Ficha/Default.aspx?__qsFicha=
				{
					StringReplace, Link, A_LoopField, <link>http://www.sky.com.br/GuiaDaTV/Ficha/Default.aspx?__qsFicha=,,All
					StringReplace, Link, Link, </link>,,All
					StringReplace, Link, Link, %A_Tab%%A_Tab%%A_Tab%%A_Tab%,,All
				}
				If A_LoopField contains <description><![CDATA[
				{
					StringReplace, Desc, A_LoopField, <description><![CDATA[,,All
					StringReplace, Desc, Desc, ]]></description>,,All
					StringReplace, Desc, Desc, %A_Tab%%A_Tab%%A_Tab%%A_Tab%,,All
					StringReplace, Desc, Desc, <br/><br/>,%A_Space%,All
					StringReplace, Desc, Desc, @, A,All
					StringReplace, Desc, Desc, `n,,All
					StringReplace, Desc, Desc, |, ,All
					StringReplace, Desc, Desc, Assista mais desta programação em HD. ,,All
					StringReplace, Title, Title, |, ,All
					StringLeft, TimeHHref, Title, 8
					StringTrimLeft, TimeHHref, TimeHHref, 6
					TimeHH := TimeHHref + 3
					TimeHH := TimeHH + GMT
					TimeHH := SubStr("00" . TimeHH, -1)
					StringReplace, Title, Title, %A_Space%%TimeHHref%, %A_Space%%TimeHH%
					StringReplace, Title, Title, %A_Space%-1, %A_Space%23
					FileAppend, %Title%@%Desc%@%link%`n, Grade.txt
				}
			}
			*/
			
			Sleep, 250
			Progress, %p%, , , % "Baixando " . p . "/" . nc . " (\ " . List_%i%_1 . ")."
			FileAppend, |, Grade.txt
			Sleep, 100
		}
		i++
		j = 1
	}
	Filedelete, href*.txt 
	FileDelete, TVGuideBR_DLtemp.txt
	IniWrite, %A_dd%/%A_MM%, TVGuideBR.ini, Data, GradeDate
	IniWrite, %ni%, TVGuideBR.ini, Data, nc
	Progress, %nc1%, , , Sincronização completa!
	Gui, 3: Destroy
	Sleep, 1000
	Progress, Off
	IniWrite, %AgendaCount%, TVGuideBR.ini, Data, AgendaCount
	Reload
}
Return

/*
ButtonBaixarSBT:
{
	Msgbox, 4096, Iniciando..., Os dados serão baixados agora., 2
	DataSBT1 = %A_DD%/%A_MM%--
	href1 := "http://www.sbt.com.br/programacao"
	UrlDownloadToFile, %href1%, href1.txt
	FileRead, href1, href1.txt
	Loop, Parse, href1, `n, `r
	{
		If A_Index > 150
		{
			If A_LoopField contains </strong>&nbsp
			{
				StringReplace, DataSBT, A_LoopField, </li>,</li>`n%A_DD%/%A_MM%--,All
				HTM = %DataSBT%
				DataSBT := UnHTM( HTM )
				DataSBT1 .= DataSBT
			}
		}
	}
	DataSBTAll =
	Loop, Parse, DataSBT1, `n, `r
	{
		If A_LoopField contains `:
		{
			StringReplace, DataSBT, A_LoopField, %A_Space%,%A_Space%-%A_Space%,
			DataSBTAll .= DataSBT . "@SBT: nÃ£o hÃ¡ sinopses e opÃ§Ãµes para este canal. Visite SBT online (botÃ£o SBT) para mais detalhes. Escolha NÃ£o nesta caixa!@000000`n"
		}
	}
	StringReplace, DataSBTAll, DataSBTAll, --,%A_Space%,All
	FileAppend, %DataSBTAll%, Grade.txt
	Sleep, 100
	Reload
}
Return
*/





; Others buttons ======================================================================================================================================================

ButtonSalvar:
{
	FileDelete, Channels.txt
	nc = 0
	i = 1
	SaveC =
	Gui, Submit, nohide
	Loop,
	{
		if ChannelDescC%i% <> 
		{
			SaveC := SaveC . ChannelDescC%i% . "," . OnOffC%i% . "," . CatC%i% . "," . ListC_%i%_4 . "," . UrlC%i% . "`n"
			If ( OnOffC%i% = 1 )
				nc++
			i++
		}
		else
		{
			break
		}
	}
	If ( GoOnlineMode = 1 )
		IniWrite, DefaultBrowser, TVGuideBR.ini, Configs, GoOnlineMode
	If ( GoOnlineMode = 2 )
		IniWrite, IEControl, TVGuideBR.ini, Configs, GoOnlineMode
	If ( Synopsis = 1 )
		IniWrite, Yes, TVGuideBR.ini, Configs, Synopsis
	If ( Synopsis = 2 )
		IniWrite, No, TVGuideBR.ini, Configs, Synopsis
	FileAppend, %saveC%, Channels.txt
	IniWrite, %FontSize%, TVGuideBR.ini, Configs, FontSize
	IniWrite, %FontStyle%, TVGuideBR.ini, Configs, FontStyle
	IniWrite, %FontColor1%, TVGuideBR.ini, Configs, FontColor1
	IniWrite, %FontColor2%, TVGuideBR.ini, Configs, FontColor2
	IniWrite, %nc%, TVGuideBR.ini, Data, nc
	IniWrite, %nc%, TVGuideBR.ini, Data, ni
	IniWrite, %AgendaCount%, TVGuideBR.ini, Data, AgendaCount
	FileDelete, Grade.txt
	Reload
}
Return

ButtonSky:
	Run, http://www.sky.com.br/guiadatv/canais/
Return

ButtonNet:
	Run, http://netcombo.globo.com/netPortalWEB/index.portal?_nfpb=true&_pageLabel=programacao_gradedecanais_gradedecanais_home_page
Return

ButtonAtualizarPrograma:
{
	URLDownloadToFile, http://www.autohotkey.net/~luetkmeyer/UpdatedVersion.txt, UpdatedVersion.txt
	FileReadLine, UpdatedVersion, UpdatedVersion.txt, 1
	If ErrorLevel = 1
	{
		Msgbox, Falha na procura por uma nova versão do programa!
		FileDelete, UpdatedVersion.txt
		Reload
	}
	else
	{
		FileDelete, UpdatedVersion.txt
		If ( CurrentVersion < UpdatedVersion )
		{
			
			URLDownloadToFile, http://www.autohotkey.net/~luetkmeyer/UpdatedVersionChanges.txt, UpdatedVersionChanges.txt
			FileRead, UpdatedVersionChanges, UpdatedVersionChanges.txt
			FileDelete, UpdatedVersionChanges.txt
			Tooltip, %UpdatedVersionChanges%, 0, 0,
			Msgbox, 4, Nova versão encontrada!, Uma nova versão deste programa está disponível.`n`nVersão atual: %CurrentVersion%`nNova versão: %UpdatedVersion%`n`nDeseja atualizar agora?`n(configurações personalizadas serão perdidas)
			Ifmsgbox no
			{
				reload
			}
			IfMsgbox yes
			{
				Tooltip
				Tooltip, Atualização em progresso (000`%). Por favor aguarde...
				URLDownloadToFile, http://www.autohotkey.net/~luetkmeyer/TVGuideBR.exe, TVGuideBRNew.exe
				Tooltip, Atualização em progresso (050`%). Por favor aguarde...
				URLDownloadToFile, http://www.autohotkey.net/~luetkmeyer/TVGuideBRUpdater.exe, TVGuideBRUpdater.exe
				Tooltip, Atualização completa!	(100`%).
				Sleep, 1000
				Tooltip
				Run, TVGuideBRUpdater.exe
				Exitapp
			}
		}
		else
		{
			Msgbox, , Versão atualizada!, Esta versão do programa é a mais recente.`n`nVersão atual: %CurrentVersion%`nVersão do servidor: %UpdatedVersion%
			Reload
		}
	}
}
Return

About:
{
	Run, http://www.autohotkey.com/forum/topic55240.html
}
Return

Donate:
{
	Run, mailto:luetkmeyer@yahoo.com.br  
}
Return

ButtonRestaurarPadrões:
{
	Filedelete, Channels.txt
	Filedelete, Grade.txt
	Filedelete, TVGuideBR.ini
	reload
}
Return

ButtonAtual:
{
	Gui, hide
	FileDelete, %A_Temp%\TVGuideBR.txt
	Filedelete, %A_ScriptDir%\Channels.txt
	Filedelete, %A_ScriptDir%\Grade.txt
	Filedelete, %A_ScriptDir%\TVGuideBR.ini
	FileDelete, %A_Temp%\TVGuideBR.txt
	Filedelete, %A_Temp%\Channels.txt
	Filedelete, %A_Temp%\Grade.txt
	Filedelete, %A_Temp%\TVGuideBR.ini
	Reload
}
Return

ButtonTemporário:
{
	Gui, hide
	FileDelete, %A_Temp%\TVGuideBR.txt
	Filedelete, %A_ScriptDir%\Channels.txt
	Filedelete, %A_ScriptDir%\Grade.txt
	Filedelete, %A_ScriptDir%\TVGuideBR.ini
	FileDelete, %A_Temp%\TVGuideBR.txt
	Filedelete, %A_Temp%\Channels.txt
	Filedelete, %A_Temp%\Grade.txt
	Filedelete, %A_Temp%\TVGuideBR.ini
	Sleep, 1000
	FileAppend, %A_Temp%, %A_Temp%\TVGuideBR.txt
	Sleep, 1000
	Reload
}
Return

ButtonOrganizar:
{
	Reload
}
Return

ButtonAbrirAgendamentos:
{
	Run, Agenda.txt
}
Return

ButtonApagarAgendamentos:
{
	FileDelete, Agenda.txt
	IniWrite, 0, TVGuideBR.ini, Data, AgendaCount
	Reload
}
Return

/*
2ButtonBaixarInformaçõesAdicionais:
{
	; Winset, Transparent, 200, TVGuideBR (
	Gui, 2: Add, Button, x450 y5 h25, Baixando! Por favor aguarde...
	Gui, 2: Show, Autosize Center, Detalhes do programa
	SetTimer, DownloadAddSyn, -100
}
Return
*/

2ButtonSky+Online:
{
	url := "http://www.sky.com.br/servicos/Guiadatv/Ficha.aspx?qFicha=" . temp
	Run, %url%
	;Gui, 2: Destroy
	;WinSet, Transparent, OFF, TVGuideBR (
}
Return

/*
2ButtonIMDB+Online:
{
	StringGetPos, DescSynIi, DescSynI, `n,
	StringLeft, DescSynIN, DescSynI, %DescSynIi%
	StringReplace, DescSynIN, DescSynIN, %A_Space%, +, All
	url2 := "http://www.imdb.com/find?s=all&q=" . DescSynIN . "&x=0&y=0"
	Run, %url2%
	;Gui, 2: Destroy
	; Winset, Transparent, OFF, TVGuideBR (
}
Return
*/

2ButtonAgendarPrograma:
2ButtonAgendarEstePrograma:
{
	SetTimer, DownloadAddSyn, OFF
	SetTimer, BrowserIMDB, OFF
	FileAppend, % a%temp%a . "`n`n", Agenda.txt
	AgendaCount++
	Process, close, TVGuideBR_Downloader.exe
	COM_AtlAxWinTerm()
	WinActivate, TVGuideBR (
	Msgbox, 4096, Agendado!, Agendado!, 0.5
	SetTimer, 2Guiclose, -250
	SetTimer, 4Guiclose, -250
	Gui, 2: destroy
	Gui, 4: destroy
}
Return

3ButtonRecarregar:
	IniWrite, %AgendaCount%, TVGuideBR.ini, Data, AgendaCount
	Reload

3ButtonSair:
5ButtonSair:
	IniWrite, %AgendaCount%, TVGuideBR.ini, Data, AgendaCount
	Exitapp

3ButtonOcultar:
{
	Gui, 3: destroy
	;Gui, hide
	XProgress := MonRight + 2
	Progress, x%XProgress% R0-0 h0 w0 ZH0 ZX0 ZY0 CBLime CWBlack A B, , , Progress, %p%, , , Baixando canal %p% de %nc%.
}
Return





; Subrotine and timers ======================================================================================================================================================

AutoCheckUpdate:
{
	URLDownloadToFile, http://www.autohotkey.net/~luetkmeyer/UpdatedVersion.txt, UpdatedVersion.txt
	FileReadLine, UpdatedVersion, UpdatedVersion.txt, 1
	FileDelete, UpdatedVersion.txt
	If ( CurrentVersion < UpdatedVersion )
		Msgbox, 4096, Nova versão encontrada!, Uma nova versão deste programa está disponível.`n`nVersão atual: %CurrentVersion%`nNova Versão: %UpdatedVersion%`n`nUse a opção "Atualizar programa" na aba "Config" para instalar a nova versão.`n`nhttp://www.autohotkey.net/~luetkmeyer/TVGuideBR.exe     (Ctrl+C para copiar), 10
}
Return

GoID:
{
	Gui, 2: Destroy
	; Winset, Transparent, 200, TVGuideBR (
	FileDelete, TVGuideBR_DLtemp.txt
	Filedelete, href*.txt
	GuiControlGet, temp, FocusV
	StringTrimLeft, temp, temp, 2
	Gui, 2: Destroy
	Gui, 4: Destroy
	Gui, 2: +toolwindow -resize
	Gui, 2: color, black
	Gui, 2: font, cLime bold s12
	Gui, 2: Add, Text, x0 y5 w500, % v%temp%v
	;~ Gui, 2: Add, Button, x450 y5 h25, Baixar informações adicionais
	Gui, 2: Add, Button, x0 y+5 h25 w250, Agendar programa
	Gui, 2: Add, Button, x+0 h25 w250, Sky+Online
	Gui, 2: show, x0 y20 w500 h%hIMDBbrowser%, Detalhes do programa
	;~ Gui, 2: show, autosize Center, Detalhes do programa
	;~ SetTimer, 2ButtonBaixarInformaçõesAdicionais, -1000
	NextExibs = 0
	DescSynNE =
	href4 := "http://www.sky.com.br/servicos/Guiadatv/Ficha.aspx?qFicha=" . temp
	FileAppend, %href4%, TVGuideBR_DLtemp.txt
	IfNotExist, TVGuideBR_Downloader.exe
		URLDownloadToFile, http://www.autohotkey.net/~luetkmeyer/TVGuideBR_Downloader.exe, TVGuideBR_Downloader.exe
	Sleep, 500
	Run, TVGuideBR_Downloader.exe
	;exitapp
	SetTimer, DownloadAddSyn, -200
}
Return

GoIDChannel:
{
	GuiControlGet, temp, FocusV
	StringTrimLeft, temp, temp, 2
	Run, %temp%
}
Return

FastScrollUp:
{
	Loop, 10
		Gosub, WheelUp
}
Return

DownloadAddSyn:
{
	DescSynN =
	DescNomePrograma =
	DescAno =
	DescEtaria =
	DescGenero =
	DescPais =
	DescDiretor =
	DescElenco =
	DescPrograma =
	DescSynI =
	DescSynD =
	DescSynNE =
	DescNomeProgramai =
	Sleep, 500
	loop,
	{
		Process, Exist, TVGuideBR_Downloader.exe
		If ErrorLevel = 0
			Break
		Sleep, 500
	}
	FileRead, href4, href4.txt
	Loop, Parse, href4, `n, `r 
	{
		
		If A_LoopField contains </table>
		{
			table++
			if ( table = 3 )
			{
				table = 0
				break
			}
		}
			
		If A_LoopField contains DataGrid_Programa_Exibicoes
			NextExibs = 1
		
		If NextExibs = 1
		{
			If A_LoopField contains <td style
			{
				StringReplace, DescSynN, A_LoopField, <td style="width: 100px">,,
				StringReplace, DescSynN, DescSynN, </td>`n,%A_Space%,			
				StringReplace, DescSynN, DescSynN, %A_Space%%A_Space%,, All
				ex = 0
				loop, 30
				{
					
					StringReplace, DescSynN, DescSynN, <td style="width: 140px"><span id="ContentPlaceHolder1_Exibicoes1_rptExibicoes_lblDataExibicao_%ex%,,
					StringReplace, DescSynN, DescSynN, <td style="width: 140px"><span id="ContentPlaceHolder1_ExibicoesK_rptExibicoes_lblDataExibicao_%ex%,,
					StringReplace, DescSynN, DescSynN, <td style="width: 140px"><span id="ContentPlaceHolder1_ExibicoesK_rptExibicoes_lblDataExibicao_,,
					StringReplace, DescSynN, DescSynN, <td style="width: 140px"><span id="ContentPlaceHolder1_Exibicoes1_rptExibicoes_lblDataExibicao_,,
					ex++
				}
				StringReplace, DescSynN, DescSynN, ",,
				StringReplace, DescSynN, DescSynN, </td>,, All	
				StringReplace, DescSynN, DescSynN, </span>,¢, All
				StringReplace, DescSynN, DescSynN, %A_Tab%,,All
				StringReplace, DescSynN, DescSynN, >,,	
				NEi := 0
				loop, 100
				{
					StringReplace, DescSynN, DescSynN, %NEi%>,,
					NEi++
				}
				DescSynNE .= DescSynN . "`n"
			}
		}
		else
		{
			If A_LoopField contains lblNomePrograma
			{
				StringReplace, DescNomePrograma, A_LoopField, <span id="ContentPlaceHolder1_lblNomePrograma">,,
				StringReplace, DescNomePrograma, DescNomePrograma, </span>,,
				StringReplace, DescNomePrograma, DescNomePrograma, </strong>,,
				StringReplace, DescNomePrograma, DescNomePrograma, <br>,,
				StringReplace, DescNomePrograma, DescNomePrograma, %A_Space%%A_Space%,,All
			}
			If A_LoopField contains lblAnoPrograma
			{
				StringReplace, DescAno, A_LoopField, <span id="ContentPlaceHolder1_lblAnoPrograma">,,
				StringReplace, DescAno, DescAno, </span>,,All
				StringReplace, DescAno, DescAno, <br>,,All
				StringReplace, DescAno, DescAno, %A_Space%%A_Space%,,All
			}
			If A_LoopField contains lblFaixaEtaria
			{
				StringReplace, DescEtaria, A_LoopField, <span id="ContentPlaceHolder1_lblFaixaEtaria">,,
				StringReplace, DescEtaria, DescEtaria, </span>,,All
				StringReplace, DescEtaria, DescEtaria, </br>,,All
				StringReplace, DescEtaria, DescEtaria, %A_Space%%A_Space%,,All
			}
			If A_LoopField contains lblGenero
			{
				StringReplace, DescGenero, A_LoopField, <span id="ContentPlaceHolder1_lblGenero">,,
				StringReplace, DescGenero, DescGenero, </span>,,All
				StringReplace, DescGenero, DescGenero, <span style='color: #C0231E; font-weight: bold;'>Gênero:,,
				StringReplace, DescGenero, DescGenero, </br>,,All
				StringReplace, DescGenero, DescGenero, <br>,,All
				StringReplace, DescGenero, DescGenero, %A_Space%%A_Space%,,All
			}
			If A_LoopField contains lblPais
			{
				StringReplace, DescPais, A_LoopField, <span id="ContentPlaceHolder1_lblPais">,,
				StringReplace, DescPais, DescPais, </span>,,All
				StringReplace, DescPais, DescPais, </br>,,All
				StringReplace, DescPais, DescPais, <br>,,All
				StringReplace, DescPais, DescPais, %A_Space%%A_Space%,,All
			}
			If A_LoopField contains lblDiretor
			{
				StringReplace, DescDiretor, A_LoopField, <span id="ContentPlaceHolder1_lblDiretor">,,
				StringReplace, DescDiretor, DescDiretor, </span>,,All
				StringReplace, DescDiretor, DescDiretor, </br>,,All
				StringReplace, DescDiretor, DescDiretor, <br>,,All
				StringReplace, DescDiretor, DescDiretor, %A_Space%%A_Space%,,All
			}
			If A_LoopField contains lblElenco
			{
				StringReplace, DescElenco, A_LoopField, <span id="ContentPlaceHolder1_lblElenco">,,
				StringReplace, DescElenco, DescElenco, </span>,,All
				StringReplace, DescElenco, DescElenco, </br>,,All
				StringReplace, DescElenco, DescElenco, <br>,,All
				StringReplace, DescElenco, DescElenco, %A_Space%%A_Space%,,All
			}
			If A_LoopField contains lblDescricaoPrograma
			{
				StringReplace, DescPrograma, A_LoopField, <span id="ContentPlaceHolder1_lblDescricaoPrograma">,,
				StringReplace, DescPrograma, DescPrograma, </span>,,All
				StringReplace, DescPrograma, DescPrograma, </br>,,All
				StringReplace, DescPrograma, DescPrograma, <br>,,All
				StringReplace, DescPrograma, DescPrograma, %A_Space%%A_Space%,,All
				StringReplace, DescPrograma, DescPrograma, Assista mais desta programação em HD.,,All
			}
		}
	}
	Filedelete, href*.txt
	FileDelete, TVGuideBR_DLtemp.txt
	DescSynI := Decode( DescSynI )
	DescSynD := Decode( DescSynD )
	DescSynNE := Decode( DescSynNE )
	Gui, 2: Destroy
	Gui, 4: Destroy
	Gui, 2: +toolwindow -resize
	Gui, 2: Color, black
	Gui, 2: Font, cGray s10
	Gui, 2: Add, Text, x0 y0 w500 Center, Detalhes adicionais baixados agora:
	Gui, 2: Font, cYellow Bold s12
	Gui, 2: Add, Text, y+5 w500, %DescNomePrograma% (%DescAno%)
	Gui, 2: Font, norm cWhite s12
	Gui, 2: Add, Text, y+0 w500, Gênero: %DescGenero% %A_Tab%País: %DescPais%`nDiretor: %DescDiretor%`nElenco: %DescElenco%`nClassificação: %DescEtatia%`n`n%DescPrograma%
	Gui, 2: Font, cLime bold s12
	Gui, 2: Add, Button, x0 y+0 h20 w250, Agendar este programa
	Gui, 2: Add, Button, x+5 h20 w250, Sky+Online
	Gui, 2: Add, Text, x0 y+5 w500 Center, Todas exibições (clique no botão para agendar):
	Loop, Parse, DescSynNE, ¢
	{
		If A_LoopField contains /
		{
			DescSynNEtemp = %A_LoopField%
			StringReplace, DescSynNEtemp, DescSynNEtemp, `n,, All
			StringRight, NEHHMMref, DescSynNEtemp, 8
			StringRight, NEDDMMref, DescSynNEtemp, 19
			StringLeft, NEDDMMref, NEDDMMref, 5
			StringTrimRight, DescSynNEtemp, DescSynNEtemp, 19
			StringLeft, NEHHMMref, NEHHMMref, 5
			StringLeft, NEHHref, NEHHMMref, 2
			StringRight, NEMMref, NEHHMMref, 2
			NEHH := NEHHref + 3
			NEHH := NEHH + GMT
			NEHH := SubStr("00" . NEHH, -1)
			StringReplace, NEHH, NEHH, -1, 23
			DescSynNEtemp := NEDDMMref . "   " . NEHH . ":" . NEMMref . "   " . DescSynNEtemp
			Gui, 2: Add, Button, y+0 gAgendar w500 h20 Left, % DescSynNEtemp ; %
		}
	}
	Gui, 2: Show, x0 y20 w500 h%hIMDBbrowser%, Detalhes do programa
	StringGetPos, DescNomeProgramai, DescNomePrograma, -, 1
	If ErrorLevel = 0
	{
		Stringleft, DescNomePrograma1, DescNomePrograma, DescNomeProgramai
		url2 := "http://www.imdb.com/find?s=all&q=" . DescNomePrograma1 . "&x=0&y=0"
	}
	else
		url2 := "http://www.imdb.com/find?s=all&q=" . DescNomePrograma . "&x=0&y=0"
	SetTimer, BrowserIMDB, -100
}
Return

Agendar:
{
	GuiControlGet, temp, FocusV	
	StringLeft, NEHour, temp, 14
	StringTrimLeft, NEHour, NEhour, 8
	StringLeft, NEDate, temp, 5
	StringTrimLeft, NEChannel, temp, 16
	FileAppend, % NEDate . " " NEHour . "    " DescNomePrograma . " |" . NEChannel . "`n`n", Agenda.txt        ;%
	AgendaCount++
	SetTimer, DownloadAddSyn, OFF
	SetTimer, BrowserIMDB, OFF
	Msgbox, 4096, Agendado!, Agendado!, 0.5
}
Return



Decode( str )
{ 
RawLen := StrLen(str) 

BufSize := (RawLen + 1) * 2 
VarSetCapacity(Buf, BufSize, 0) 

DllCall("MultiByteToWideChar", "uint", 65001, "int", 0, "str", str 
						   , "int", -1, "uint", &Buf, "uint", RawLen + 1) 
DllCall("WideCharToMultiByte", "uint", 1252, "int", 0, "uint", &Buf, "int", -1 
						   , "str", str, "uint", RawLen + 1 
						   , "int", 0, "int", 0) 
Return str 
} 



; First use and reset

CreateFiles:
{
	FileAppend,
(
HD_ESPN,0,Esportes,298,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=298
HD_DISCOVERY_TLC,0,Cultura,286,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=286
HD_GLOBOSAT,0,Div,318,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=318
HD_MULTISHOW,0,Div,362,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=362
HD_WARNER,0,Seriados,492,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=492
HD_FOX_NATGEO,0,Cultura,303,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=303
HD_AXN,0,Seriados,238,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=238
HD_SONY,0,Seriados,437,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=437
HD_NAT_GEO_WILD,0,Cultura,365,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=365
HD_DISCOVERY_THEATER,0,Cultura,285,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=285
HD_THE_HISTORY_CHANNEL,0,Cultura,460,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=460
HD_TRUTV,0,Div,467,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=467
HD_SPACE,0,Seriados,440,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=440
HD_TNT,0,Filmes,463,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=463
HD_TELECINE_PREMIUM,0,Filmes,456,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=456
HD_TELECINE_ACTION,0,Filmes,450,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=450
HD_TELECINE_PIPOCA,0,Filmes,454,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=454
HD_MGM,0,Filmes,353,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=353
HD_RUSH,0,Div,404,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=404
HD_HBO,0,Filmes,324,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=324
HD_MAX,0,Filmes,346,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=346
HD_VH1,0,Div,489,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=489
HD_DISNEY_CHANNEL,0,Cultura,289,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=289
HD_NICKELODEON,0,Cultura,371,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=371
HD_BANDNEWS,0,News,242,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=242
HD_ESPN,0,Esportes,420,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=420
TELECINE_PREMIUM,1,Filmes,455,http://telecine.globo.com/programacao/
TELECINE_PIPOCA,1,Filmes,453,http://telecine.globo.com/programacao/
TELECINE_FUN,1,Filmes,452,http://telecine.globo.com/programacao/
TELECINE_ACTION,1,Filmes,449,http://telecine.globo.com/programacao/
TELECINE_TOUCH,1,Filmes,457,http://telecine.globo.com/programacao/
TELECINE_CULT,1,Filmes,451,http://telecine.globo.com/programacao/
HBO,1,Filmes,321,http://www.hbomax.tv/programacion.aspx
HBO2,1,Filmes,327,http://www.hbomax.tv/programacion.aspx
HBO_Family,1,Filmes,322,http://www.hbomax.tv/programacion.aspx
HBO_Family_e,1,Filmes,323,http://www.hbomax.tv/programacion.aspx
HBO_Plus,1,Filmes,325,http://www.hbomax.tv/programacion.aspx
HBO_Plus_e,1,Filmes,326,http://www.hbomax.tv/programacion.aspx
CINEMAX,1,Filmes,274,http://www.hbomax.tv/programacion.aspx
MAX,1,Filmes,345,http://www.hbomax.tv/programacion.aspx
MAX_HD,1,Filmes,347,http://www.hbomax.tv/programacion.aspx
MAXPRIME,1,Filmes,348,http://www.hbomax.tv/programacion.aspx
MAXPRIME_e,1,Filmes,349,http://www.hbomax.tv/programacion.aspx
MEGAPIX,1,Filmes,351,http://megapix.globo.com/programacao
MGM,0,Filmes_OUT,352,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=352
SPACE,1,Filmes,439,http://space.amocinema.com/schedule
STUDIO_UNIVERSAL,1,Filmes,446,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=446
TCM,0,Filmes,448,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=448
TNT,1,Filmes,462,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=462
CANAL_BRASIL,0,Filmes,253,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=253
AXN,1,Seriados,237,http://br.axn.com/shows/schedule
FOX,1,Seriados,301,http://www.canalfox.com.br/br/programacao
FOX_LIFE,1,Seriados,302,http://www.foxlife.com.br/br/programacao
FX,1,Seriados,306,http://www.fxbrasil.com.br/br/programacao/
SONY,1,Seriados,436,http://br.canalsony.com/shows/schedule
SONY_SPIN,1,Seriados,438,http://br.sonyspin.com/schedule
SyFy,1,Seriados,447,http://www.scifibrasil.com/br/programacao
WARNER_CHANNEL,1,Seriados,461,http://www.wbla.com/schedules/daily/
UNIVERSAL_CHANNEL,1,Seriados,486,http://uc.globo.com/programacao/
BOOMERANG,0,Infantis,248,http://www.boomixla.com/boomerang/public/DailySchedule.action
CARTOON_NETWORK,1,Infantis,259,http://www.cartoonnetwork.com.br/
DISCOVERY_KIDS,0,Infantis,284,http://www.discoverykidsbrasil.com/programacao/
DISNEY,0,Infantis,288,http://www.disney.com.br/disneychannel/programacao/
DISNEY_XD,0,Infantis,290,http://disney.com.br/disneyxd/programacao/
NICKELODEON,0,Infantis,370,http://mundonick.uol.com.br/canal/horarios/
RATIMBUM,0,Infantis,379,http://www.tvratimbum.com.br/secoes/programacao/dia.php
ESPN,1,Esportes,296,http://espn.estadao.com.br/programacao/listar.programacao.logic?idChannel=2
ESPN_BRASIL,1,Esportes,297,http://espn.estadao.com.br/programacao
SPORTV,1,Esportes,443,http://sportv.globo.com/
SPORTV_2,1,Esportes,444,http://sportv.globo.com/
BANDSPORTS,0,Esportes,243,http://bandsports.band.com.br/programacao/
SPEED_CHANNEL,1,Esportes,441,http://www.canalspeed.com.br/br/programacao
THE_GOLF_CHANNEL,0,Esportes,459,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=459
PREMIERE_24H,0,Esportes,337,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=337
NATIONAL_GEOGRAFIC,1,Cultura,367,http://www.natgeo.com.br/br/programacao
DISCOVERY_CHANNEL,1,Cultura,282,http://www.discoverybrasil.com/programacao-de-tv/?type=day&country_code=BR
THE_HISTORY_CHANNEL,1,Cultura,329,http://www.seuhistory.com/br/horarios/
DISCOVERY_HOME&HEALTH,0,Cultura,283,Information,http://www.discoverybrasil.com/programacao-de-tv/?type=day&country_code=BR&channel_code=DHBR-PRT
DISCOVERY_TRAVEL&LIVING,0,Cultura,287,http://www.discoverybrasil.com/programacao-de-tv/?type=day&country_code=BR&channel_code=TLBR-PRT
ANIMAL_PLANET,1,Cultura,231,http://www.discoverybrasil.com/programacao-de-tv/?type=day&country_code=BR&channel_code=APBR-PRT
A&E,0,Seriados,230,http://www.aeweb.tv/br/horarios/
LIV,0,Seriados,342,http://www.peopleandarts.com/
TRUTV,0,Cultura,466,http://br.canalsony.com/shows/schedule
E!,0,Cultura,291,http://www.e1tv.com/
GLITZ,0,Cultura,308,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=308
MANAGEMENTV,1,Cultura,344,http://www.managementv.com.br/programacao.asp
FUTURA,1,Cultura,305,http://www.futura.org.br/main.asp
TV_ESCOLA,0,Cultura,472,http://portal.mec.gov.br/tvescola/
TV_CULTURA,1,Cultura,471,http://www.tvcultura.com.br/grade/index.php
GNT,0,Cultura,319,http://gnt.globo.com/Programacao/
TV_BRASIL,0,Cultura,469,http://www.tvbrasil.org.br/programacao/
BANDNEWS,0,News,241,http://bandnewstv.band.com.br/index.asp
BBC_WORLD,0,News,244,http://www.bbc.co.uk/
CNNi,0,News,276,http://www.cnn.com/
GLOBO_NEWS,1,News,314,http://globonews.globo.com/
BLOOMBERG,0,News,245,http://www.bloomberg.com/br
CLIMATEMPO,0,News,275,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=275
NBR,0,News,368,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=368
SESCTV_OUT,0,News,409,http://www.sesctv.com.br/programacao.cfm
TV_CAMARA,0,News,470,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=470
TV_JUSTIA,0,News,475,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=475
TV_SENADO,0,News,478,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=478
DEUTSCHE_WELLE,0,News,280,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=280
MULTISHOW,1,Div,361,http://multishow.globo.com/Programacao/horarios.shtml
PLAY_TV_OUT,0,Div,374,http://www.playtv.com.br/new/site/programacao.php
VH1,1,Div,488,http://vh1brasil.uol.com.br/programas/canal/VH1/
VH1_MEGA_HITS,0,Div,490,http://vh1brasil.uol.com.br/programas/canal/VH1/
VIVA,1,Div,491,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=491
BOA_VONTADE_TV_OUT,0,Div,247,http://www.boavontade.com/tv/grade.php
CANAL_RURAL,0,Div,255,http://www.canalrural.com.br/canalrural/jsp/default.jspx?uf=1&local=1&action=programacao_canal&section=programacao
CANçÃO_NOVA,0,Div,257,http://www.cancaonova.com/portal/canais/tvcn/tv/progs.php
POLISHOP,0,Div,376,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=376
SHOPTIME_OUT,0,Div,414,http://www.shoptime.com.br/TVShoptime
TERRA_VIVA,0,Div,458,http://tvterraviva.band.com.br/grade.asp
TV_NOVO_TEMPO_OUT,0,Div,477,http://www.novotempo.org.br/tv/novo/grade.php
NHK,0,Div,369,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=369
RAI,0,Div,387,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=387
SIC,0,Div,415,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=415
TV5_MONDE,0,Div,485,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=485
GLOBO_RJ,1,Abertos,316,http://redeglobo.globo.com/programacao.html
GLOBO_SP,0,Abertos,317,http://redeglobo.globo.com/programacao.html
GLOBO_BAHIA,0,Abertos,310,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=310
RECORD,1,Abertos,389,http://rederecord.r7.com/programacao.html
BAND,1,Abertos,240,http://www.band.com.br/programacao/
REDE_TV_OUT,1,Abertos,396,http://www.redetv.com.br/grade.aspx
REDE_VIDA_OUT,0,Abertos,395,http://www.redevida.com.br/programacao.php
RBS_RS,0,Abertos,388,http://www.sky.com.br/servicos/Guiadatv/CanalDetalhe.aspx?qChave=388
SBT,1,Abertos,406,http://www.sbt.com.br/programacao
), Channels.txt

	FileGetSize, Exist, TVGuideBR.ini
	If ErrorLevel = 1
	{
		Fileappend,
(
[Configs]
FontSize=10
FontStyle=bold
FontColor1=Red
FontColor2=Lime
Synopsis=No
GMT=-3

[Data]
GradeDate=%A_dd%/%A_MM%
ni=73
nc=73
), TVGuideBR.ini
}
}
Return

First:
{ 
	Gui, 4: + Toolwindow +Alwaysontop
	Gui, 4: Color, Black
	Gui, 4: Font, cLime s12	
	Gui, 4: Add, Text, x10 y10,
(
Obrigado por usar este programa.

Este programa que exibe a grade de programação de vários canais de tv do Brasil. Os dados são baixados da programadora Sky.

Seu uso é simples:
- O primeiro download dos dados iniciará automaticamente agora. Para baixar os dados clique no botão "Baixar dados";
- O download armazenará dados de quatro dias de programação (dia baixado + 3 dias futuros);
- Dias anteriores estarão disponíveis somente quando o download foi em algum dos três dias anteriores;
- A lista de canais é personalizável (aba "Config"); 
- Os canais são categorizados (Filmes, Seriados, Cultura, News, Esportes, Infantis, Abertos e Div (não categorizados); 
- Marcadores: "=" marca a hora atual; "-" marca uma hora a menos e uma hora a mais da hora atual; e "+" marca as horas 20, 21 e 22; 
- Os botões ">" contem opções e detalhes do programa selecionado (abrir online, sinopse, novas exibições, revisão do programa etc); 

- Deixe uma idéia ou comentário no forum deste programa;
- Contribua com donativos se desejar (luetkmeyer@yahoo.com.br). Bom proveito.
)
Gui, 4: Show, Autosize Center, Iniciando...
}
Return


; Others functions ======================================================================================================================================================

GuiClose:
GuiEscape:
	IniWrite, %AgendaCount%, TVGuideBR.ini, Data, AgendaCount
	exitapp
	exitapp
	exitapp
	exitapp
Return
	
; scroll
GuiSize:
	UpdateScrollBars(A_Gui, A_GuiWidth, A_GuiHeight)
return


#IfWinActive ahk_group MyGui
WheelUp::
WheelDown::
+WheelUp::
+WheelDown::
	; SB_LINEDOWN=1, SB_LINEUP=0, WM_HSCROLL=0x114, WM_VSCROLL=0x115
	loop, 10
		OnScroll(InStr(A_ThisHotkey,"Down") ? 1 : 0, 0, GetKeyState("Shift") ? 0x114 : 0x115, WinExist())
return
#IfWinActive

UpdateScrollBars(GuiNum, GuiWidth, GuiHeight)
{
	static SIF_RANGE=0x1, SIF_PAGE=0x2, SIF_DISABLENOSCROLL=0x8, SB_HORZ=0, SB_VERT=1
   
	Gui, %GuiNum%:Default
	Gui, +LastFound

	; Calculate scrolling area.
	Left := Top := 9999
	Right := Bottom := 0
	WinGet, ControlList, ControlList
	Loop, Parse, ControlList, `n
	{
		GuiControlGet, c, Pos, %A_LoopField%
		if (cX < Left)
			Left := cX
		if (cY < Top)
			Top := cY
		if (cX + cW > Right)
			Right := cX + cW
		if (cY + cH > Bottom)
			Bottom := cY + cH
	}
	Left -= 8
	Top -= 8
	Right += 8
	Bottom += 8
	ScrollWidth := Right-Left
	ScrollHeight := Bottom-Top
   
	; Initialize SCROLLINFO.
	VarSetCapacity(si, 28, 0)
	NumPut(28, si) ; cbSize
	NumPut(SIF_RANGE | SIF_PAGE, si, 4) ; fMask

	;Update horizontal scroll bar.
	;NumPut(ScrollWidth, si, 12) ; nMax
	;NumPut(GuiWidth, si, 16) ; nPage
	;DllCall("SetScrollInfo", "uint", WinExist(), "uint", SB_HORZ, "uint", &si, "int", 1)

	;Update vertical scroll bar.
	;NumPut(SIF_RANGE | SIF_PAGE | SIF_DISABLENOSCROLL, si, 4) ; fMask
	NumPut(ScrollHeight, si, 12) ; nMax
	NumPut(GuiHeight, si, 16) ; nPage
	DllCall("SetScrollInfo", "uint", WinExist(), "uint", SB_VERT, "uint", &si, "int", 1)

	if (Left < 0 && Right < GuiWidth)
		x := Abs(Left) > GuiWidth-Right ? GuiWidth-Right : Abs(Left)
	if (Top < 0 && Bottom < GuiHeight)
		y := Abs(Top) > GuiHeight-Bottom ? GuiHeight-Bottom : Abs(Top)
	if (x || y)
		DllCall("ScrollWindow", "uint", WinExist(), "int", x, "int", y, "uint", 0, "uint", 0)
}

OnScroll(wParam, lParam, msg, hwnd)
{
	static SIF_ALL=0x17, SCROLL_STEP=10

	bar := msg=0x115 ; SB_HORZ=0, SB_VERT=1

	VarSetCapacity(si, 28, 0)
	NumPut(28, si) ; cbSize
	NumPut(SIF_ALL, si, 4) ; fMask
	if !DllCall("GetScrollInfo", "uint", hwnd, "int", bar, "uint", &si)
		return

	VarSetCapacity(rect, 16)
	DllCall("GetClientRect", "uint", hwnd, "uint", &rect)

	new_pos := NumGet(si, 20) ; nPos

	action := wParam & 0xFFFF
	if action = 0 ; SB_LINEUP
		new_pos -= SCROLL_STEP
	else if action = 1 ; SB_LINEDOWN
		new_pos += SCROLL_STEP
	else if action = 2 ; SB_PAGEUP
		new_pos -= NumGet(rect, 12, "int") - SCROLL_STEP
	else if action = 3 ; SB_PAGEDOWN
		new_pos += NumGet(rect, 12, "int") - SCROLL_STEP
	else if (action = 5 || action = 4) ; SB_THUMBTRACK || SB_THUMBPOSITION
		new_pos := wParam>>16
	else if action = 6 ; SB_TOP
		new_pos := NumGet(si, 8, "int") ; nMin
	else if action = 7 ; SB_BOTTOM
		new_pos := NumGet(si, 12, "int") ; nMax
	else
		return

	min := NumGet(si, 8, "int") ; nMin
	max := NumGet(si, 12, "int") - NumGet(si, 16) ; nMax-nPage
	new_pos := new_pos > max ? max : new_pos
	new_pos := new_pos < min ? min : new_pos

	old_pos := NumGet(si, 20, "int") ; nPos

	x := y := 0
	if bar = 0 ; SB_HORZ
		x := old_pos-new_pos
	else
		y := old_pos-new_pos
	; Scroll contents of window and invalidate uncovered area.
	DllCall("ScrollWindow", "uint", hwnd, "int", x, "int", y, "uint", 0, "uint", 0)

	; Update scroll bar.
	NumPut(new_pos, si, 20, "int") ; nPos
	DllCall("SetScrollInfo", "uint", hwnd, "int", bar, "uint", &si, "int", 1)
}


BrowserIMDB:
	;OnExit,GuiClose
	;OnExit,2GuiClose
	;OnExit,4GuiClose
	Gosub,Initialize
	Gui, 4: +toolwindow -resize 
	Gui, 4: Add, Button, x6 y7 w20 h20  g_back, <=
	Gui, 4: Add, Button, x26 y7 w20 h20 g_forward, =>
	Gui, 4: Add, Button, x46 y7 w20 h20 g_stop, []
	Gui, 4: Add, Edit, x66 y7 w350 h20 v_addres_bar, http://
	Gui, 4: Add, Button, x416 y7 w20 h20 g_refresh v_refresh, <>
	Gui, 4: Add, Button, x436 y7 w20 h20 g_go v_go, >>
	Gui, 4: Show, x505 y20 w%wIMDBbrowser% h%hIMDBbrowser%, IMDB para: %DescSynIN%
Return


2Guiclose:
2GuiEscape:
4GuiClose:
4GuiEscape:
	SetTimer, DownloadAddSyn, Off
	Process, close, TVGuideBR_Downloader.exe
	Gui, 2: destroy
	Gui, 4: destroy
	COM_AtlAxWinTerm()
	WinActivate, TVGuideBR (
Return

4GuiSize:
{
	if ErrorLevel = 1  ; The window has been minimized.  No action needed.	
		return
	Gui, 4: +LastFound
	If	minWidth:=A_GuiWidth < 290 
		WinMove,,,,,290
	If	minHeight:=A_GuiHeight < 200
		WinMove,,,,,,200
	if (minHeight || minWidth)
		Return	
	GuiControl, 4: MoveDraw,_addres_bar,% "w" A_GuiWidth-150
	GuiControl, 4: MoveDraw,_refresh,% "x" A_GuiWidth-60
	GuiControl, 4: MoveDraw,_go,% "x" A_GuiWidth-80
	WinMove, % "ahk_id " . COM_AtlAxGetContainer(pwb), ,6,30,% A_GuiWidth-12,% A_GuiHeight-32
	Return
}

Initialize:
{
	COM_AtlAxWinInit()
	Gui, 4: +LastFound +Resize 
	;pwb := COM_AtlAxGetControl(COM_AtlAxCreateContainer(WinExist(),left,top,width,height, "Shell.Explorer") )  ;left these here just for reference of the parameters 
	pwb := COM_AtlAxGetControl(COM_AtlAxCreateContainer(WinExist(),6,30,450,450, "Shell.Explorer") ) 
	IOleInPlaceActiveObject_Interface:="{00000117-0000-0000-C000-000000000046}" 
	pipa := COM_QueryInterface(pwb, IOleInPlaceActiveObject_Interface)
	OnMessage(WM_KEYDOWN:=0x0100, "WM_KEYDOWN") 
	OnMessage(WM_KEYUP:=0x0101, "WM_KEYDOWN") 
	psink := COM_ConnectObject(pwb, "Web_") 
	COM_Invoke(pwb,"Navigate", url2)
	com_error(0)	
	Return
}

_back:
{
	COM_Invoke(pwb,"goback")
	Return
}

_forward:
{
	COM_Invoke(pwb,"goforward")
	Return
}

_stop:
{
	COM_Invoke(pwb,"stop")
	Return
}

_refresh:
{
	COM_Invoke(pwb,"refresh")
	Return
}
_go:
{
	Gui, 4: Submit,NoHide
	GuiNavigate()
	Return
}

GuiNavigate()
{
	global pwb,_addres_bar
	COM_Invoke(pwb,"navigate",_addres_bar)
	Return
}


WM_KEYDOWN(wParam, lParam, nMsg, hWnd) 
{ 
;  Critical 20 
;tooltip % wparam 
  If  (wParam = 0x09 || wParam = 0x0D || wParam = 0x2E || wParam = 0x26 || wParam = 0x28) ; tab enter delete up down 
  ;If  (wParam = 9 || wParam = 13 || wParam = 46 || wParam = 38 || wParam = 40) ; tab enter delete up down 
  { 
      WinGetClass, Class, ahk_id %hWnd% 
      ;tooltip % class 
      If  (Class = "Internet Explorer_Server") 
          { 
            Global pipa 
             VarSetCapacity(Msg, 28) 
             NumPut(hWnd,Msg), NumPut(nMsg,Msg,4), NumPut(wParam,Msg,8), NumPut(lParam,Msg,12) 
             NumPut(A_EventInfo,Msg,16), NumPut(A_GuiX,Msg,20), NumPut(A_GuiY,Msg,24) 
             DllCall(NumGet(NumGet(1*pipa)+20), "Uint", pipa, "Uint", &Msg) 
             Return 0 
          } 
  } 
} 

Web_NavigateComplete2()
{
	global pwb,_addres_bar
	GuiControl, 4:,_addres_bar,% COM_Invoke(pwb,"locationurl")
}



;------------------------------------------------------------------------------
; COM.ahk Standard Library
; by Sean
; http://www.autohotkey.com/forum/topic22923.html
;------------------------------------------------------------------------------

COM_Init(bUn = "")
{
	Static	h
	Return	(bUn&&!h:="")||h==""&&1==(h:=DllCall("ole32\OleInitialize","Uint",0))?DllCall("ole32\OleUninitialize"):0
}

COM_Term()
{
	COM_Init(1)
}

COM_VTable(ppv, idx)
{
	Return	NumGet(NumGet(1*ppv)+4*idx)
}

COM_QueryInterface(ppv, IID = "")
{
	If	DllCall(NumGet(NumGet(1*ppv:=COM_Unwrap(ppv))), "Uint", ppv+0, "Uint", COM_GUID4String(IID,IID ? IID:IID=0 ? "{00000000-0000-0000-C000-000000000046}":"{00020400-0000-0000-C000-000000000046}"), "UintP", ppv:=0)=0
	Return	ppv
}

COM_AddRef(ppv)
{
	Return	DllCall(NumGet(NumGet(1*ppv:=COM_Unwrap(ppv))+4), "Uint", ppv)
}

COM_Release(ppv)
{
	If Not	IsObject(ppv)
	Return	DllCall(NumGet(NumGet(1*ppv)+8), "Uint", ppv)
	Else
	{
	nRef:=	DllCall(NumGet(NumGet(COM_Unwrap(ppv))+8), "Uint", COM_Unwrap(ppv)), nRef==0 ? (ppv.prm_:=0):""
	Return	nRef
	}
}

COM_QueryService(ppv, SID, IID = "")
{
	If	DllCall(NumGet(NumGet(1*ppv:=COM_Unwrap(ppv))), "Uint", ppv, "Uint", COM_GUID4String(IID_IServiceProvider,"{6D5140C1-7436-11CE-8034-00AA006009FA}"), "UintP", psp)=0
	&&	DllCall(NumGet(NumGet(1*psp)+12), "Uint", psp, "Uint", COM_GUID4String(SID,SID), "Uint", IID ? COM_GUID4String(IID,IID):&SID, "UintP", ppv:=0)+DllCall(NumGet(NumGet(1*psp)+8), "Uint", psp)*0=0
	Return	COM_Enwrap(ppv)
}

COM_FindConnectionPoint(pdp, DIID)
{
	DllCall(NumGet(NumGet(1*pdp)+ 0), "Uint", pdp, "Uint", COM_GUID4String(IID_IConnectionPointContainer, "{B196B284-BAB4-101A-B69C-00AA00341D07}"), "UintP", pcc)
	DllCall(NumGet(NumGet(1*pcc)+16), "Uint", pcc, "Uint", COM_GUID4String(DIID,DIID), "UintP", pcp)
	DllCall(NumGet(NumGet(1*pcc)+ 8), "Uint", pcc)
	Return	pcp
}

COM_GetConnectionInterface(pcp)
{
	VarSetCapacity(DIID,16,0)
	DllCall(NumGet(NumGet(1*pcp)+12), "Uint", pcp, "Uint", &DIID)
	Return	COM_String4GUID(&DIID)
}

COM_Advise(pcp, psink)
{
	DllCall(NumGet(NumGet(1*pcp)+20), "Uint", pcp, "Uint", psink, "UintP", nCookie)
	Return	nCookie
}

COM_Unadvise(pcp, nCookie)
{
	Return	DllCall(NumGet(NumGet(1*pcp)+24), "Uint", pcp, "Uint", nCookie)
}

COM_Enumerate(penum, ByRef Result, ByRef vt = "")
{
	VarSetCapacity(varResult,16,0)
	If (0 =	hr:=DllCall(NumGet(NumGet(1*penum:=COM_Unwrap(penum))+12), "Uint", penum, "Uint", 1, "Uint", &varResult, "UintP", 0))
	Result:=(vt:=NumGet(varResult,0,"Ushort"))=9||vt=13?COM_Enwrap(NumGet(varResult,8),vt):vt=8||vt<0x1000&&COM_VariantChangeType(&varResult,&varResult)=0?StrGet(NumGet(varResult,8)) . COM_VariantClear(&varResult):NumGet(varResult,8)
	Return	hr
}

COM_Invoke(pdsp,name="",prm0="vT_NoNe",prm1="vT_NoNe",prm2="vT_NoNe",prm3="vT_NoNe",prm4="vT_NoNe",prm5="vT_NoNe",prm6="vT_NoNe",prm7="vT_NoNe",prm8="vT_NoNe",prm9="vT_NoNe")
{
	pdsp :=	COM_Unwrap(pdsp)
	If	name=
	Return	DllCall(NumGet(NumGet(1*pdsp)+8),"Uint",pdsp)
	If	name contains .
	{
		SubStr(name,1,1)!="." ? name.=".":name:=SubStr(name,2) . "."
	Loop,	Parse,	name, .
	{
	If	A_Index=1
	{
		name :=	A_LoopField
		Continue
	}
	Else If	name not contains [,(
		prmn :=	""
	Else If	InStr("])",SubStr(name,0))
	Loop,	Parse,	name, [(,'")]
	If	A_Index=1
		name :=	A_LoopField
	Else	prmn :=	A_LoopField
	Else
	{
		name .=	"." . A_LoopField
		Continue
	}
	If	A_LoopField!=
		pdsp:=	COM_Invoke(pdsp,name,prmn!="" ? prmn:"vT_NoNe"),name:=A_LoopField
	Else	Return	prmn!=""?COM_Invoke(pdsp,name,prmn,prm0,prm1,prm2,prm3,prm4,prm5,prm6,prm7,prm8):COM_Invoke(pdsp,name,prm0,prm1,prm2,prm3,prm4,prm5,prm6,prm7,prm8,prm9)
	}
	}
	Static	varg,namg,iidn,varResult,sParams
	VarSetCapacity(varResult,64,0),sParams?"":(sParams:="0123456789",VarSetCapacity(varg,160,0),VarSetCapacity(namg,88,0),VarSetCapacity(iidn,16,0)),mParams:=0,nParams:=10,nvk:=3
	Loop, 	Parse,	sParams
	If	(prm%A_LoopField%=="vT_NoNe")
	{
	 	nParams:=A_Index-1
		Break
	}
	Else If	prm%A_LoopField% is integer
		NumPut(SubStr(prm%A_LoopField%,1,1)="+"?9:prm%A_LoopField%=="-0"?(prm%A_LoopField%:=0x80020004)*0+10:3,NumPut(prm%A_LoopField%,varg,168-16*A_Index),-12)
	Else If	IsObject(prm%A_LoopField%)
		typ:=prm%A_LoopField%["typ_"],prm:=prm%A_LoopField%["prm_"],typ+0==""?(NumPut(&_nam_%A_LoopField%:=typ,namg,84-4*mParams++),typ:=prm%A_LoopField%["nam_"]+0==""?prm+0==""||InStr(prm,".")?8:3:prm%A_LoopField%["nam_"]):"",NumPut(typ==8?COM_SysString(prm%A_LoopField%,prm):prm,NumPut(typ,varg,160-16*A_Index),4)
	Else	NumPut(COM_SysString(prm%A_LoopField%,prm%A_LoopField%),NumPut(8,varg,160-16*A_Index),4)
	If	nParams
		SubStr(name,0)="="?(name:=SubStr(name,1,-1),nvk:=12,NumPut(-3,namg,4)):"",NumPut(nvk==12?1:mParams,NumPut(nParams,NumPut(&namg+4,NumPut(&varg+160-16*nParams,varResult,16))))
	Global	COM_HR, COM_LR:=""
	If	(COM_HR:=DllCall(NumGet(NumGet(1*pdsp)+20),"Uint",pdsp,"Uint",&iidn,"Uint",NumPut(&name,namg,84-4*mParams)-4,"Uint",1+mParams,"Uint",1024,"Uint",&namg,"Uint"))=0&&(COM_HR:=DllCall(NumGet(NumGet(1*pdsp)+24),"Uint",pdsp,"int",NumGet(namg),"Uint",&iidn,"Uint",1024,"Ushort",nvk,"Uint",&varResult+16,"Uint",&varResult,"Uint",&varResult+32,"Uint",0,"Uint"))!=0&&nParams&&nvk<4&&NumPut(-3,namg,4)&&(COM_LR:=DllCall(NumGet(NumGet(1*pdsp)+24),"Uint",pdsp,"int",NumGet(namg),"Uint",&iidn,"Uint",1024,"Ushort",12,"Uint",NumPut(1,varResult,28)-16,"Uint",0,"Uint",0,"Uint",0,"Uint"))=0
		COM_HR:=0
	Global	COM_VT:=NumGet(varResult,0,"Ushort")
	Return	COM_HR=0?COM_VT>1?COM_VT=9||COM_VT=13?COM_Enwrap(NumGet(varResult,8),COM_VT):COM_VT=8||COM_VT<0x1000&&COM_VariantChangeType(&varResult,&varResult)=0?StrGet(NumGet(varResult,8)) . COM_VariantClear(&varResult):NumGet(varResult,8):"":COM_Error(COM_HR,COM_LR,&varResult+32,name)
}

COM_InvokeSet(pdsp,name,prm0,prm1="vT_NoNe",prm2="vT_NoNe",prm3="vT_NoNe",prm4="vT_NoNe",prm5="vT_NoNe",prm6="vT_NoNe",prm7="vT_NoNe",prm8="vT_NoNe",prm9="vT_NoNe")
{
	Return	COM_Invoke(pdsp,name "=",prm0,prm1,prm2,prm3,prm4,prm5,prm6,prm7,prm8,prm9)
}

COM_DispInterface(this, prm1="", prm2="", prm3="", prm4="", prm5="", prm6="", prm7="", prm8="")
{
	Critical
	If	A_EventInfo = 6
		hr:=DllCall(NumGet(NumGet(0+p:=NumGet(this+8))+28),"Uint",p,"Uint",prm1,"UintP",pname,"Uint",1,"UintP",0),hr==0?(sfn:=StrGet(this+40) . StrGet(pname),COM_SysFreeString(pname),%sfn%(prm5,this,prm6)):""
	Else If	A_EventInfo = 5
		hr:=DllCall(NumGet(NumGet(0+p:=NumGet(this+8))+40),"Uint",p,"Uint",prm2,"Uint",prm3,"Uint",prm5)
	Else If	A_EventInfo = 4
		NumPut(0*hr:=0x80004001,prm3+0)
	Else If	A_EventInfo = 3
		NumPut(0,prm1+0)
	Else If	A_EventInfo = 2
		NumPut(hr:=NumGet(this+4)-1,this+4)
	Else If	A_EventInfo = 1
		NumPut(hr:=NumGet(this+4)+1,this+4)
	Else If	A_EventInfo = 0
		COM_IsEqualGUID(this+24,prm1)||InStr("{00020400-0000-0000-C000-000000000046}{00000000-0000-0000-C000-000000000046}",COM_String4GUID(prm1)) ? NumPut(NumPut(NumGet(this+4)+1,this+4)-8,prm2+0):NumPut(0*hr:=0x80004002,prm2+0)
	Return	hr
}

COM_DispGetParam(pDispParams, Position = 0, vt = 8)
{
	VarSetCapacity(varResult,16,0)
	DllCall("oleaut32\DispGetParam", "Uint", pDispParams, "Uint", Position, "Ushort", vt, "Uint", &varResult, "UintP", nArgErr)
	Return	(vt:=NumGet(varResult,0,"Ushort"))=8?StrGet(NumGet(varResult,8)) . COM_VariantClear(&varResult):vt=9||vt=13?COM_Enwrap(NumGet(varResult,8),vt):NumGet(varResult,8)
}

COM_DispSetParam(val, pDispParams, Position = 0, vt = 8)
{
	Return	NumPut(vt=8?COM_SysAllocString(val):vt=9||vt=13?COM_Unwrap(val):val,NumGet(NumGet(pDispParams+0)+(NumGet(pDispParams+8)-Position)*16-8),0,vt=11||vt=2 ? "short":"int")
}

COM_Error(hr = "", lr = "", pei = "", name = "")
{
	Static	bDebug:=1
	If Not	pei
	{
	bDebug:=hr
	Global	COM_HR, COM_LR
	Return	COM_HR&&COM_LR ? COM_LR<<32|COM_HR:COM_HR
	}
	Else If	!bDebug
	Return
	hr ? (VarSetCapacity(sError,1022),VarSetCapacity(nError,62),DllCall("kernel32\FormatMessage","Uint",0x1200,"Uint",0,"Uint",hr<>0x80020009?hr:(bExcep:=1)*(hr:=NumGet(pei+28))?hr:hr:=NumGet(pei+0,0,"Ushort")+0x80040200,"Uint",0,"str",sError,"Uint",512,"Uint",0),DllCall("kernel32\FormatMessage","Uint",0x2400,"str","0x%1!p!","Uint",0,"Uint",0,"str",nError,"Uint",32,"UintP",hr)):sError:="No COM Dispatch Object!`n",lr?(VarSetCapacity(sError2,1022),VarSetCapacity(nError2,62),DllCall("kernel32\FormatMessage","Uint",0x1200,"Uint",0,"Uint",lr,"Uint",0,"str",sError2,"Uint",512,"Uint",0),DllCall("kernel32\FormatMessage","Uint",0x2400,"str","0x%1!p!","Uint",0,"Uint",0,"str",nError2,"Uint",32,"UintP",lr)):""
	MsgBox, 260, COM Error Notification, % "Function Name:`t""" . name . """`nERROR:`t" . sError . "`t(" . nError . ")" . (bExcep ? SubStr(NumGet(pei+24) ? DllCall(NumGet(pei+24),"Uint",pei) : "",1,0) . "`nPROG:`t" . StrGet(NumGet(pei+4)) . COM_SysFreeString(NumGet(pei+4)) . "`nDESC:`t" . StrGet(NumGet(pei+8)) . COM_SysFreeString(NumGet(pei+8)) . "`nHELP:`t" . StrGet(NumGet(pei+12)) . COM_SysFreeString(NumGet(pei+12)) . "," . NumGet(pei+16) : "") . (lr ? "`n`nERROR2:`t" . sError2 . "`t(" . nError2 . ")" : "") . "`n`nWill Continue?"
	IfMsgBox, No, Exit
}

COM_CreateIDispatch()
{
	Static	IDispatch
	If Not	VarSetCapacity(IDispatch)
	{
		VarSetCapacity(IDispatch,28,0),   nParams=3112469
		Loop,   Parse,   nParams
		NumPut(RegisterCallback("COM_DispInterface","",A_LoopField,A_Index-1),IDispatch,4*(A_Index-1))
	}
	Return &IDispatch
}

COM_GetDefaultInterface(pdisp)
{
	DllCall(NumGet(NumGet(1*pdisp) +12), "Uint", pdisp , "UintP", ctinf)
	If	ctinf
	{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint" , 0, "Uint", 1024, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
	DllCall(NumGet(NumGet(1*pdisp)+ 0), "Uint", pdisp, "Uint" , pattr, "UintP", ppv)
	DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
	If	ppv
	DllCall(NumGet(NumGet(1*pdisp)+ 8), "Uint", pdisp),	pdisp := ppv
	}
	Return	pdisp
}

COM_GetDefaultEvents(pdisp)
{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint" , 0, "Uint", 1024, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
	VarSetCapacity(IID,16),DllCall("kernel32\RtlMoveMemory","Uint",&IID,"Uint",pattr,"Uint",16)
	DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
	DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
	Loop, %	DllCall(NumGet(NumGet(1*ptlib)+12), "Uint", ptlib)
	{
		DllCall(NumGet(NumGet(1*ptlib)+20), "Uint", ptlib, "Uint", A_Index-1, "UintP", TKind)
		If	TKind <> 5
			Continue
		DllCall(NumGet(NumGet(1*ptlib)+16), "Uint", ptlib, "Uint", A_Index-1, "UintP", ptinf)
		DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
		nCount:=NumGet(pattr+48,0,"Ushort")
		DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
		Loop, %	nCount
		{
			DllCall(NumGet(NumGet(1*ptinf)+36), "Uint", ptinf, "Uint", A_Index-1, "UintP", nFlags)
			If	!(nFlags & 1)
				Continue
			DllCall(NumGet(NumGet(1*ptinf)+32), "Uint", ptinf, "Uint", A_Index-1, "UintP", hRefType)
			DllCall(NumGet(NumGet(1*ptinf)+56), "Uint", ptinf, "Uint", hRefType , "UintP", prinf)
			DllCall(NumGet(NumGet(1*prinf)+12), "Uint", prinf, "UintP", pattr)
			nFlags & 2 ? DIID:=COM_String4GUID(pattr) : bFind:=COM_IsEqualGUID(pattr,&IID)
			DllCall(NumGet(NumGet(1*prinf)+76), "Uint", prinf, "Uint" , pattr)
			DllCall(NumGet(NumGet(1*prinf)+ 8), "Uint", prinf)
		}
		DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
		If	bFind
			Break
	}
	DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)
	Return	bFind ? DIID : "{00000000-0000-0000-0000-000000000000}"
}

COM_GetGuidOfName(pdisp, Name)
{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint", 0, "Uint", 1024, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf), ptinf:=0
	DllCall(NumGet(NumGet(1*ptlib)+44), "Uint", ptlib, "Uint", &Name, "Uint", 0, "UintP", ptinf, "UintP", memID, "UshortP", 1)
	DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)
	DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
	GUID := COM_String4GUID(pattr)
	DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
	Return	GUID
}

COM_GetTypeInfoOfGuid(pdisp, GUID)
{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint", 0, "Uint", 1024, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf), ptinf := 0
	DllCall(NumGet(NumGet(1*ptlib)+24), "Uint", ptlib, "Uint", COM_GUID4String(GUID,GUID), "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)
	Return	ptinf
}

COM_ConnectObject(pdisp, prefix = "", DIID = "")
{
	pdisp:=	COM_Unwrap(pdisp)
	If Not	DIID
		0+(pconn:=COM_FindConnectionPoint(pdisp,"{00020400-0000-0000-C000-000000000046}")) ? (DIID:=COM_GetConnectionInterface(pconn))="{00020400-0000-0000-C000-000000000046}" ? DIID:=COM_GetDefaultEvents(pdisp):"":pconn:=COM_FindConnectionPoint(pdisp,DIID:=COM_GetDefaultEvents(pdisp))
	Else	pconn:=COM_FindConnectionPoint(pdisp,SubStr(DIID,1,1)="{" ? DIID:DIID:=COM_GetGuidOfName(pdisp,DIID))
	If	!pconn||!ptinf:=COM_GetTypeInfoOfGuid(pdisp,DIID)
	{
		MsgBox, No Event Interface Exists!
		Return
	}
	NumPut(pdisp,NumPut(ptinf,NumPut(1,NumPut(COM_CreateIDispatch(),0+psink:=COM_CoTaskMemAlloc(40+nSize:=StrLen(prefix)*2+2)))))
	DllCall("kernel32\RtlMoveMemory","Uint",psink+24,"Uint",COM_GUID4String(DIID,DIID),"Uint",16)
	DllCall("kernel32\RtlMoveMemory","Uint",psink+40,"Uint",&prefix,"Uint",nSize)
	NumPut(COM_Advise(pconn,psink),NumPut(pconn,psink+16))
	Return	psink
}

COM_DisconnectObject(psink)
{
	Return	COM_Unadvise(NumGet(psink+16),NumGet(psink+20))=0 ? (0,COM_Release(NumGet(psink+16)),COM_Release(NumGet(psink+8)),COM_CoTaskMemFree(psink)):1
}

COM_CreateObject(CLSID, IID = "", CLSCTX = 21)
{
	ppv :=	COM_CreateInstance(CLSID,IID,CLSCTX)
	Return	IID=="" ? COM_Enwrap(ppv):ppv
}

COM_GetObject(Name)
{
	COM_Init()
	If	DllCall("ole32\CoGetObject", "Uint", &Name, "Uint", 0, "Uint", COM_GUID4String(IID_IDispatch,"{00020400-0000-0000-C000-000000000046}"), "UintP", pdisp)=0
	Return	COM_Enwrap(pdisp)
}

COM_GetActiveObject(CLSID)
{
	COM_Init()
	If	DllCall("oleaut32\GetActiveObject", "Uint", COM_GUID4String(CLSID,CLSID), "Uint", 0, "UintP", punk)=0
	&&	DllCall(NumGet(NumGet(1*punk)), "Uint", punk, "Uint", COM_GUID4String(IID_IDispatch,"{00020400-0000-0000-C000-000000000046}"), "UintP", pdisp)+DllCall(NumGet(NumGet(1*punk)+8), "Uint", punk)*0=0
	Return	COM_Enwrap(pdisp)
}

COM_CreateInstance(CLSID, IID = "", CLSCTX = 21)
{
	COM_Init()
	If	DllCall("ole32\CoCreateInstance", "Uint", COM_GUID4String(CLSID,CLSID), "Uint", 0, "Uint", CLSCTX, "Uint", COM_GUID4String(IID,IID ? IID:IID=0 ? "{00000000-0000-0000-C000-000000000046}":"{00020400-0000-0000-C000-000000000046}"), "UintP", ppv)=0
	Return	ppv
}

COM_CLSID4ProgID(ByRef CLSID, ProgID)
{
	VarSetCapacity(CLSID,16,0)
	DllCall("ole32\CLSIDFromProgID", "Uint", &ProgID, "Uint", &CLSID)
	Return	&CLSID
}

COM_ProgID4CLSID(pCLSID)
{
	DllCall("ole32\ProgIDFromCLSID", "Uint", pCLSID, "UintP", pProgID)
	Return	StrGet(pProgID) . COM_CoTaskMemFree(pProgID)
}

COM_GUID4String(ByRef CLSID, String)
{
	VarSetCapacity(CLSID,16,0)
	DllCall("ole32\CLSIDFromString", "Uint", &String, "Uint", &CLSID)
	Return	&CLSID
}

COM_String4GUID(pGUID)
{
	VarSetCapacity(String,38*2)
	DllCall("ole32\StringFromGUID2", "Uint", pGUID, "str", String, "int", 39)
	Return	String
}

COM_IsEqualGUID(pGUID1, pGUID2)
{
	Return	DllCall("ole32\IsEqualGUID", "Uint", pGUID1, "Uint", pGUID2)
}

COM_CoCreateGuid()
{
	VarSetCapacity(GUID,16,0)
	DllCall("ole32\CoCreateGuid", "Uint", &GUID)
	Return	COM_String4GUID(&GUID)
}

COM_CoInitialize()
{
	Return	DllCall("ole32\CoInitialize", "Uint", 0)
}

COM_CoUninitialize()
{
		DllCall("ole32\CoUninitialize")
}

COM_CoTaskMemAlloc(cb)
{
	Return	DllCall("ole32\CoTaskMemAlloc", "Uint", cb)
}

COM_CoTaskMemFree(pv)
{
		DllCall("ole32\CoTaskMemFree", "Uint", pv)
}

COM_SysAllocString(str)
{
	Return	DllCall("oleaut32\SysAllocString", "Uint", &str)
}

COM_SysFreeString(pstr)
{
		DllCall("oleaut32\SysFreeString", "Uint", pstr)
}

COM_SafeArrayDestroy(psar)
{
	Return	DllCall("oleaut32\SafeArrayDestroy", "Uint", psar)
}

COM_VariantClear(pvar)
{
		DllCall("oleaut32\VariantClear", "Uint", pvar)
}

COM_VariantChangeType(pvarDst, pvarSrc, vt = 8)
{
	Return	DllCall("oleaut32\VariantChangeTypeEx", "Uint", pvarDst, "Uint", pvarSrc, "Uint", 1024, "Ushort", 0, "Ushort", vt)
}

COM_SysString(ByRef wString, sString)
{
	VarSetCapacity(wString,4+nLen:=2*StrLen(sString))
	Return	DllCall("kernel32\lstrcpyW","Uint",NumPut(nLen,wString),"Uint",&sString)
}

COM_AccInit()
{
	Static	h
	If Not	h
	COM_Init(), h:=DllCall("kernel32\LoadLibrary","str","oleacc")
}

COM_AccTerm()
{
	COM_Term()
}

COM_AccessibleChildren(pacc, cChildren, ByRef varChildren)
{
	VarSetCapacity(varChildren,cChildren*16,0)
	If	DllCall("oleacc\AccessibleChildren", "Uint", COM_Unwrap(pacc), "Uint", 0, "Uint", cChildren+0, "Uint", &varChildren, "UintP", cChildren:=0)=0
	Return	cChildren
}

COM_AccessibleObjectFromEvent(hWnd, idObject, idChild, ByRef _idChild_="")
{
	COM_AccInit(), VarSetCapacity(varChild,16,0)
	If	DllCall("oleacc\AccessibleObjectFromEvent", "Uint", hWnd, "Uint", idObject, "Uint", idChild, "UintP", pacc, "Uint", &varChild)=0
	Return	COM_Enwrap(pacc), _idChild_:=NumGet(varChild,8)
}

COM_AccessibleObjectFromPoint(x, y, ByRef _idChild_="")
{
	COM_AccInit(), VarSetCapacity(varChild,16,0)
	If	DllCall("oleacc\AccessibleObjectFromPoint", "int", x, "int", y, "UintP", pacc, "Uint", &varChild)=0
	Return	COM_Enwrap(pacc), _idChild_:=NumGet(varChild,8)
}

COM_AccessibleObjectFromWindow(hWnd, idObject=-4, IID = "")
{
	COM_AccInit()
	If	DllCall("oleacc\AccessibleObjectFromWindow", "Uint", hWnd, "Uint", idObject, "Uint", COM_GUID4String(IID, IID ? IID : idObject&0xFFFFFFFF==0xFFFFFFF0 ? "{00020400-0000-0000-C000-000000000046}":"{618736E0-3C3D-11CF-810C-00AA00389B71}"), "UintP", pacc)=0
	Return	COM_Enwrap(pacc)
}

COM_WindowFromAccessibleObject(pacc)
{
	If	DllCall("oleacc\WindowFromAccessibleObject", "Uint", COM_Unwrap(pacc), "UintP", hWnd)=0
	Return	hWnd
}

COM_GetRoleText(nRole)
{
	nLen:=	DllCall("oleacc\GetRoleTextW", "Uint", nRole, "Uint", 0, "Uint", 0)
	VarSetCapacity(sRole,nLen*2)
	If	DllCall("oleacc\GetRoleTextW", "Uint", nRole, "str", sRole, "Uint", nLen+1)
	Return	sRole
}

COM_GetStateText(nState)
{
	nLen:=	DllCall("oleacc\GetStateTextW", "Uint", nState, "Uint", 0, "Uint", 0)
	VarSetCapacity(sState,nLen*2)
	If	DllCall("oleacc\GetStateTextW", "Uint", nState, "str", sState, "Uint", nLen+1)
	Return	sState
}

COM_AtlAxWinInit(Version = "")
{
	Static	h
	If Not	h
	COM_Init(), h:=DllCall("kernel32\LoadLibrary","str","atl" . Version), DllCall("atl" . Version . "\AtlAxWinInit")
}

COM_AtlAxWinTerm(Version = "")
{
	COM_Term()
}

COM_AtlAxGetHost(hWnd, Version = "")
{
	If	DllCall("atl" . Version . "\AtlAxGetHost", "Uint", hWnd, "UintP", punk)=0
	Return	COM_Enwrap(COM_QueryInterface(punk)+COM_Release(punk)*0)
}

COM_AtlAxGetControl(hWnd, Version = "")
{
	If	DllCall("atl" . Version . "\AtlAxGetControl", "Uint", hWnd, "UintP", punk)=0
	Return	COM_Enwrap(COM_QueryInterface(punk)+COM_Release(punk)*0)
}

COM_AtlAxAttachControl(pdsp, hWnd, Version = "")
{
	If	DllCall("atl" . Version . "\AtlAxAttachControl", "Uint", punk:=COM_QueryInterface(pdsp,0), "Uint", hWnd, "Uint", COM_AtlAxWinInit(Version))+COM_Release(punk)*0=0
	Return	COM_Enwrap(pdsp)
}

COM_AtlAxCreateControl(hWnd, Name, Version = "")
{
	If	DllCall("atl" . Version . "\AtlAxCreateControl", "Uint", &Name, "Uint", hWnd, "Uint", 0, "Uint", COM_AtlAxWinInit(Version))=0
	Return	COM_AtlAxGetControl(hWnd,Version)
}

COM_AtlAxCreateContainer(hWnd, l, t, w, h, Name = "", Version = "")
{
	Return	DllCall("user32\CreateWindowEx", "Uint",0x200, "str", "AtlAxWin" . Version, "Uint", Name?&Name:0, "Uint", 0x54000000, "int", l, "int", t, "int", w, "int", h, "Uint", hWnd, "Uint", 0, "Uint", 0, "Uint", COM_AtlAxWinInit(Version))
}

COM_AtlAxGetContainer(pdsp, bCtrl = "")
{
	DllCall(NumGet(NumGet(1*pdsp:=COM_Unwrap(pdsp))), "Uint", pdsp, "Uint", COM_GUID4String(IID_IOleWindow,"{00000114-0000-0000-C000-000000000046}"), "UintP", pwin)
	DllCall(NumGet(NumGet(1*pwin)+12), "Uint", pwin, "UintP", hCtrl)
	DllCall(NumGet(NumGet(1*pwin)+ 8), "Uint", pwin)
	Return	bCtrl?hCtrl:DllCall("user32\GetParent", "Uint", hCtrl)
}

COM_ScriptControl(sCode, sEval = "", sName = "", Obj = "", bGlobal = "")
{
	oSC:=COM_CreateObject("ScriptControl"), oSC.Language(sEval+0==""?"VBScript":"JScript"), sName&&Obj?oSC.AddObject(sName,Obj,bGlobal):""
	Return	sEval?oSC.Eval(sEval+0?sCode:sEval oSC.AddCode(sCode)):oSC.ExecuteStatement(sCode)
}

COM_Parameter(typ, prm = "", nam = "")
{
	Return	IsObject(prm)?prm:Object("typ_",typ,"prm_",prm,"nam_",nam)
}

COM_Enwrap(obj, vt = 9)
{
	Static	base
	Return	IsObject(obj)?obj:Object("prm_",obj,"typ_",vt,"base",base?base:base:=Object("__Delete","COM_Invoke","__Call","COM_Invoke","__Get","COM_Invoke","__Set","COM_InvokeSet","base",Object("__Delete","COM_Term")))
}

COM_Unwrap(obj)
{
	Return	IsObject(obj)?obj.prm_:obj
}



/*
; html

UnHTM( HTM ) { ; Remove HTML formatting / Convert to ordinary text     by SKAN 19-Nov-2009
 Static HT     ; Forum Topic: www.autohotkey.com/forum/topic51342.html
 IfEqual,HT,,   SetEnv,HT, % "&aacuteá&acircâ&acute´&aeligæ&agraveà&amp&aringå&atildeã&au"
 . "mlä&bdquo„&brvbar¦&bull•&ccedilç&cedil¸&cent¢&circˆ&copy©&curren¤&dagger†&dagger‡&deg"
 . "°&divide÷&eacuteé&ecircê&egraveè&ethð&eumlë&euro€&fnofƒ&frac12½&frac14¼&frac34¾&gt>&h"
 . "ellip…&iacuteí&icircî&iexcl¡&igraveì&iquest¿&iumlï&laquo«&ldquo“&lsaquo‹&lsquo‘&lt<&m"
 . "acr¯&mdash—&microµ&middot·&nbsp &ndash–&not¬&ntildeñ&oacuteó&ocircô&oeligœ&ograveò&or"
 . "dfª&ordmº&oslashø&otildeõ&oumlö&para¶&permil‰&plusmn±&pound£&quot""&raquo»&rdquo”&reg"
 . "®&rsaquo›&rsquo’&sbquo‚&scaronš&sect§&shy­&sup1¹&sup2²&sup3³&szligß&thornþ&tilde˜&tim"
 . "es×&trade™&uacuteú&ucircû&ugraveù&uml¨&uumlü&yacuteý&yen¥&yumlÿ"
 TXT := RegExReplace( HTM,"<[^>]+>" )               ; Remove all tags between  "<" and ">"
 Loop, Parse, TXT, &`;                              ; Create a list of special characters
    L := "&" A_LoopField ";", R .= (!(A_Index&1)) ? ( (!InStr(R,L,1)) ? L:"" ) : ""
 StringTrimRight, R, R, 1
 Loop, Parse, R , `;                                ; Parse Special Characters
	If F := InStr( HT, A_LoopField )                  ; Lookup HT Data
		StringReplace, TXT,TXT, %A_LoopField%`;, % SubStr( HT,F+StrLen(A_LoopField), 1 ), All
	Else If ( SubStr( A_LoopField,2,1)="#" )
		StringReplace, TXT, TXT, %A_LoopField%`;, % Chr(SubStr(A_LoopField,3)), All
Return RegExReplace( TXT, "(^\s*|\s*$)")            ; Remove leading/trailing white spaces
}

*/

