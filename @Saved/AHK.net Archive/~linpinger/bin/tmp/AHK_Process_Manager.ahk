; ??: ??AHK????

GuiInit:  ; ??GUI
	Gui, Add, ListView, x6 y10 w690 h160 , PID|?????|????
	LV_ModifyCol(1, 50), LV_ModifyCol(2, 400), LV_ModifyCol(3, 80)

	GUI, add, StatusBar, , F5:??  Alt+E:??
	SB_SetParts(465,100)
	Gui, Show, h194 w555, AHK ??????
	gosub, GetProcessInfo  ; ??AHK????
return

GuiClose:
GuiEscape:
	ExitApp
return

GetProcessInfo: ; ??AHK????
	LV_Delete() ; ????

	COM_Init()  ; ???
	psvc := COM_GetObject("winmgmts:{impersonationLevel=impersonate}!" . "\\.\root\cimv2")

	pset := COM_Invoke(psvc, "ExecQuery",  "SELECT * FROM Win32_Process WHERE Name=""Autohotkey.exe""") ; ??SQL?????
	penm := COM_Invoke(pset, "_NewEnum") ; ???
	Loop, % COM_Invoke(pset, "Count")    ; ?????
		If ( COM_Enumerate(penm,pobj) = 0 )
		{
			PID := COM_Invoke(pobj, "ProcessId")           ; ????PID
			CMDLine := COM_Invoke(pobj, "CommandLine")     ; ???????
			cDate := COM_Invoke(pobj, "CreationDate")      ; ??????(????)
			regexmatch(CMDLine, "Ui) ""([^""]+)""", ff_)   ; ?????????
			regexmatch(cDate, "Ui)^[0-9]{8}([0-9]{2})([0-9]{2})([0-9]{2})\..+$", dd_) ; ??????

			LV_Add("", PID, ff_1, dd_1 . ":" . dd_2 . ":" . dd_3) ; ????
			COM_Release(pobj)
		}
	COM_Release(penm) , COM_Release(pset) ; ????

	COM_Release(psvc) , COM_Term() ; ????
	LV_ModifyCol(2, "Sort")
	SB_SetText(A_Hour . ":" . A_Min . ":" . A_Sec, 2)
return

; -----??:
^esc::reload
+esc::Edit
!esc::ExitApp
#IfWinActive, ahk_class AutoHotkeyGUI
!E::
	Loop { ; ???????
		RowNumber := LV_GetNext(RowNumber)
		if ! RowNumber
			break
		LV_GetText(NowPID, RowNumber, 1)
		Process, close, %NowPID%            ; ??AHK????????
	}
	TrayTip, ??:, ????????
	sleep 2000
	Gosub, GetProcessInfo
return
F5:: gosub, GetProcessInfo ; ??
#IfWinActive

;runwait, wmic process where name="Autohotkey.exe" get CommandLine

