;===================================================
;== AHK Live-Manual - Lucid_Method =================
;===================================================

	AHKCommand = FormatTime
	Command_Version = 1.0
	Manual_Credit = Lucid_Method
	Manual_Updated = 01-04-2011
	Manual_Tags = Time|

;===============================================================
; Startup Actions
;===============================================================	
	LiveManual_Startup_Actions:
{
	OutPutVarName = OutputVar
	InputTime = 
	GoSub LiveManual_Setup

	DateColor=Blue
	GoSub Format_CurrentTime_Startup
	Gui, Font, s10 ;cBlue underline, 
}	

;===============================================================
; Build GUI
;===============================================================

	Build_GUI:
{

#NoEnv
#Persistent
#SingleInstance force


;Gui, Add, Tab, x10 y5 h600 w660 vTimeTabs gSubmit_TimeFormat , BuildTime ;|TimeFormats

	
	Gui, Add, Button, x15 y10 w600 h35 hwnd_Manual gLiveManual_AHK_Manual, FormatTime, OutputVar [, YYYYMMDDHH24MISS, Format]
		ILButton(_Manual, Manual_Ico , 16, 16, "Left")

	
	XStart = 20
Gui, Add, GroupBox, x%XStart% y47 w590 h350 , Time Formats
	Gui, Add, Radio, xp+20 yp+25 w500 h20 gSubmit_TimeFormat vFormatTimeBlank Checked, (Blank) Leave Format blank to produce the time followed by the long date.
	Gui, Add, Radio, xp yp+60 w200 h20 gSubmit_TimeFormat vFormatTimeTime, (Time) Time representation
	Gui, Add, Radio, xp yp+30 w240 h20 gSubmit_TimeFormat vFormatTimeShortDate, (ShortDate) Short date representation
	Gui, Add, Radio, xp yp+30 w240 h20 gSubmit_TimeFormat vFormatTimeLongDate, (LongDate) Long date representation
	Gui, Add, Radio, xp yp+30 w240 h20 gSubmit_TimeFormat vFormatTimeYearMonth, (YearMonth) Year and month format
	Gui, Add, Radio, xp yp+30 w340 h20 gSubmit_TimeFormat vFormatTimeYDay, (YDay) Day of the year without leading zeros (1 – 366)
	Gui, Add, Radio, xp yp+30 w340 h20 gSubmit_TimeFormat vFormatTimeYDay0, (YDay0) Day of the year with leading zeros (001 – 366)
	Gui, Add, Radio, xp yp+30 w280 h20 gSubmit_TimeFormat vFormatTimeWDay, (WDay) Day of the week (1 – 7). Sunday is 1.
	Gui, Add, Radio, xp yp+30 w310 h20 gSubmit_TimeFormat vFormatTimeYWeek, (YWeek) The ISO 8601 full year and week number
	
	XStart += 280
	Gui, Add, Text, x%XStart% y92 w280 h20 c%DateColor%, [ %FormatTime% ]
	Gui, Add, Text, xp-40 yp+40 w160 h20 c%DateColor%, [ %Time% ]
	Gui, Add, Text, xp+50 yp+30 w280 h20 c%DateColor%, [ %ShortDate% ]
	Gui, Add, Text, xp yp+30 w280 h20 c%DateColor%, [ %LongDate% ]
	Gui, Add, Text, xp yp+30 w280 h20 c%DateColor%, [ %YearMonth% ]
	Gui, Add, Text, xp+90 yp+30 w190 h20 c%DateColor%, [ %YDay% ]
	Gui, Add, Text, xp yp+30 w190 h20 c%DateColor%, [ %YDay0% ]
	Gui, Add, Text, xp yp+30 w190 h20 c%DateColor%, [ %WDay% ]
	Gui, Add, Text, xp yp+30 w190 h20 c%DateColor%, [ %YWeek% ]
	
	Gui, Add, Edit, x120 yp+60 w390 h25 vCodeDisplay,
	;Gui, Add, Text, xp+400 yp w300 hp vTimeDisplay,

	Gui, Add, Button, x150 yp+50 w110 h30 hwnd_Clipboard gLiveManual_CopyCode, Copy	
		ILButton(_Clipboard, Clipboard_Ico , 22, 22, "Left")
	Gui, Add, Button, xp+110 yp wp hp hwnd_Reload gLiveManual_Reload, Reload
		ILButton(_Reload, Refresh_Ico , 22, 22, "Left")
	Gui, Add, Button, xp+110 yp wp hp hwnd_Exit gLiveManual_Exit, Close
		ILButton(_Exit, Exit_Ico , 22, 22, "Left")
	
Gui, +Resize
GoSub LiveManual_Build_MenuBar
Gui, Show, xCenter yCenter h520, %AHKCommand% (AHK Live-Manual)


Return
}

;===============================================================

	Submit_TimeFormat:
{
	Gui, Submit, Nohide
	CodeLine = FormatTime, %OutPutVarName%

	TimeTabs	= BuildTime 
	
	If TimeTabs	= TimeFormats
{
	CustomTime = 

	If Days_d = 1 ; (d) Day of the month without leading zero (1 - 31)
		CustomTime = %CustomTime%d
	
	If Days_dd = 1 ; (dd) Day of the month with leading zero (01 – 31)
		CustomTime = %CustomTime%dd
		
	If Days_ddd = 1 ; (ddd) Abbreviated name for the day of the week
		CustomTime = %CustomTime%ddd
		
	If Days_dddd = 1 ; (dddd) Full name for the day of the week
		CustomTime = %CustomTime%dddd

	GuiControl,,CustomTime, %CustomTime%
}	

	
	If TimeTabs	= BuildTime
{
	
	If FormatTimeBlank = 1 ;Checked, (Blank) Leave Format blank to produce the time followed by the long date.
		{
		CodeLine = %CodeLine%
		FormatTime, FormatTimeExample
		}
	If FormatTimeTime = 1 ; (Time) Time representation
		{
		CodeLine = %CodeLine%, %InputTime%, Time
		FormatTime, FormatTimeExample, %InputTime%, Time
		}
	If FormatTimeShortDate = 1 ; (ShortDate) Short date representation
		{
		CodeLine = %CodeLine%, %InputTime%, ShortDate
		FormatTime, FormatTimeExample, %InputTime%, ShortDate
		}
	If FormatTimeLongDate = 1 ; (LongDate) Long date representation
		{
		CodeLine = %CodeLine%, %InputTime%, LongDate
		FormatTime, FormatTimeExample, %InputTime%, LongDate
		}
	If FormatTimeYearMonth = 1 ; (YearMonth) Year and month format
		{
		CodeLine = %CodeLine%, %InputTime%, YearMonth
		FormatTime, FormatTimeExample, %InputTime%, YearMonth
		}
	If FormatTimeYDay = 1 ; (YDay) Day of the year without leading zeros (1 – 366)
		{
		CodeLine = %CodeLine%, %InputTime%, YDay
		FormatTime, FormatTimeExample, %InputTime%, YDay
		}
	If FormatTimeYDay0 = 1 ; (YDay0) Day of the year with leading zeros (001 – 366)
		{
		CodeLine = %CodeLine%, %InputTime%, YDay0
		FormatTime, FormatTimeExample, %InputTime%, YDay0
		}
	If FormatTimeWDay = 1 ; (WDay) Day of the week (1 – 7). Sunday is 1.
		{
		CodeLine = %CodeLine%, %InputTime%, WDay
		FormatTime, FormatTimeExample, %InputTime%, WDay
		}
	If FormatTimeYWeek = 1 ; (YWeek) The ISO 8601 full year and week number
		{
		CodeLine = %CodeLine%, %InputTime%, YWeek
		FormatTime, FormatTimeExample, %InputTime%, YWeek
		}
}
		
	GuiControl,,CodeDisplay, %CodeLine%
	GuiControl,,TimeDisplay, %FormatTimeExample%

Return
}

	Format_CurrentTime_Startup:
{
	FormatTime, d,,d
	FormatTime, dd,,dd
	FormatTime, ddd,,ddd
	FormatTime, dddd,,dddd
	FormatTime, M,,M
	FormatTime, MM,,MM
	FormatTime, MMM,,MMM
	FormatTime, MMMM,,MMMM
	FormatTime, y,,y
	FormatTime, yy,,yy
	FormatTime, yyyy,,yyyy
	FormatTime, gg,,gg
	FormatTime, h,,h
	FormatTime, hh,,hh
	FormatTime, H,,H
	FormatTime, HH,,HH
	FormatTime, m,,m
	FormatTime, mm,,mm
	FormatTime, s,,s
	FormatTime, ss,,ss
	FormatTime, t,,t
	FormatTime, tt,,tt
	FormatTime, FormatTime
	FormatTime, Time,,Time
	FormatTime, ShortDate,,ShortDate
	FormatTime, LongDate,,LongDate
	FormatTime, YearMonth,,YearMonth
	FormatTime, YDay,,YDay
	FormatTime, YDay0,,YDay0
	FormatTime, WDay,,WDay
	FormatTime, YWeek,,YWeek
Return
}

	USE_LATER: ; GUI Code to use later
{


/*
Gui, Tab, TimeFormats

Gui, Add, Text, x26 y27 w420 h20 cRed, FormatTime`, OutputVar [`, YYYYMMDDHH24MISS`, Format]
FormatTime, FormatTime
Gui, Add, Text, x26 y47 w420 h20 c%DateColor%, %FormatTime%

Gui, Add, GroupBox, x6 y67 w430 h160 , Days
	Gui, Add, Radio, x16 y87 w300 h20 vDays_0 gSubmit_TimeFormat Checked, (0) No Days
	Gui, Add, Radio, xp yp+30 wp hp vDays_d gSubmit_TimeFormat, (d) Day of the month without leading zero (1 - 31)
	Gui, Add, Radio, xp yp+30 wp hp vDays_dd gSubmit_TimeFormat, (dd) Day of the month with leading zero (01 – 31)
	Gui, Add, Radio, xp yp+30 wp hp vDays_ddd gSubmit_TimeFormat, (ddd) Abbreviated name for the day of the week
	Gui, Add, Radio, xp yp+30 wp hp vDays_dddd gSubmit_TimeFormat, (dddd) Full name for the day of the week
	
	Gui, Add, Text, x326 y117 w60 h20 c%DateColor%, [ %d% ]
	Gui, Add, Text, xp yp+30 w60 h20 c%DateColor%, [ %dd% ]
	Gui, Add, Text, xp yp+30 w70 h20 c%DateColor%, [ %ddd% ]
	Gui, Add, Text, xp yp+30 w100 h20 c%DateColor%, [ %dddd% ]

Gui, Add, GroupBox, x6 y237 w420 h150 , Months
	Gui, Add, Radio, x16 y267 w240 h20 , (M) Month without leading zero (1 – 12)
	Gui, Add, Radio, x16 y297 w230 h20 , (MM) Month with leading zero (01 – 12)
	Gui, Add, Radio, x16 y327 w210 h20 , (MMM) Abbreviated month name
	Gui, Add, Radio, x16 y357 w190 h20 , (MMMM) Full month name
	
	Gui, Add, Radio, x16 y447 w320 h20 , (yy) Year without century`, without leading zero (0 – 99)
	Gui, Add, Radio, x16 y417 w310 h20 , (y) Year without century`, with leading zero (00 - 99)
	Gui, Add, Radio, x16 y477 w180 h20 , (yyyy) Year with century
	Gui, Add, Radio, x16 y507 w310 h20 , (gg) Period/era string for the current user's locale
	
	Gui, Add, Text, x276 y267 w60 h20 c%DateColor%, [ %M% ]
	Gui, Add, Text, x276 y297 w60 h20 c%DateColor%, [ %MM% ]
	Gui, Add, Text, x276 y327 w90 h20 c%DateColor%, [ %MMM% ]
	Gui, Add, Text, x276 y357 w110 h20 c%DateColor%, [ %MMMM% ]
	Gui, Add, Text, x346 y417 w60 h20 c%DateColor%, [ %y% ]
	Gui, Add, Text, x346 y447 w60 h20 c%DateColor%, [ %yy% ]
	Gui, Add, Text, x346 y477 w60 h20 c%DateColor%, [ %yyyy% ]
	Gui, Add, Text, x346 y507 w60 h20 c%DateColor%, [ %gg% ]	


Gui, Add, GroupBox, x6 y387 w420 h150 , Years
Gui, Add, GroupBox, x466 y7 w350 h170 , Hours
	Gui, Add, Text, x476 y37 w250 h20 , (h) Hours without leading zero (1 - 12)
	Gui, Add, Text, x476 y67 w250 h20 , (hh) Hours with leading zero (01 – 12)
	Gui, Add, Text, x476 y97 w250 h20 , (H) Hours without leading zero (0 - 23)
	Gui, Add, Text, x476 y127 w250 h20 , (HH) Hours with leading zero (00– 23)
	Gui, Add, Text, x736 y37 w60 h20 c%DateColor%, [ %h% ]
	Gui, Add, Text, x736 y67 w60 h20 c%DateColor%, [ %hh% ]
	Gui, Add, Text, x736 y97 w60 h20 c%DateColor%, [ %H% ]
	Gui, Add, Text, x736 y127 w60 h20 c%DateColor%, [ %HH% ]	

Gui, Add, GroupBox, x466 y187 w350 h90 , Minutes	
	Gui, Add, Text, x476 y207 w250 h20 , (m) Minutes without leading zero (0 – 59)
	Gui, Add, Text, x476 y237 w250 h20 , (mm) Minutes with leading zero (00 – 59)
	Gui, Add, Text, x736 y207 w60 h20 c%DateColor%, [ %m% ]
	Gui, Add, Text, x736 y237 w60 h20 c%DateColor%, [ %mm% ]	
	
	Gui, Add, Edit, x580 y300 w200 h20 vCustomTime

Gui, Add, GroupBox, x826 y7 w180 h170 , Seconds
	Gui, Add, Text, x836 y37 w160 h40 , (s) Seconds No Leading Zero (0 – 59)
	Gui, Add, Text, x836 y107 w160 h40 , (ss) Seconds with leading zero (00 – 59)
	Gui, Add, Text, x836 y77 w60 h20 c%DateColor%, [ %s% ]
	Gui, Add, Text, x836 y147 w60 h20 c%DateColor%, [ %ss% ]	

Gui, Add, GroupBox, x436 y637 w550 h80 , AM PM
	Gui, Add, Text, x456 y657 w300 h20 , (t) Single character time marker (A or P)
	Gui, Add, Text, x456 y687 w300 h20 , (tt) Multi-character time marker  (AM-PM)
	Gui, Add, Text, x766 y657 w60 h20 c%DateColor%, [ %t% ]
	Gui, Add, Text, x766 y687 w60 h20 c%DateColor%, [ %tt% ]	

*/	

}	
	
	SubmitCode: ;Gosub Required for Live_Manual
{
	Return	
}	

;===============================================================
; INCLUDE CODE
;===============================================================
	#Include Lib\LiveManual_Include.ahk
;===============================================================
