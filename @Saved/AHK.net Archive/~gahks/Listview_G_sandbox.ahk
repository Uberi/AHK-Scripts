#SingleInstance, force
SysGet, screen, MonitorWorkArea
w_lv := screenRight-(screenRight/10), h_lv := screenBottom-(screenBottom/3)
Gui, 98:Add, Listview, Checked h%h_lv% w%w_lv% vl_v_a, File Name|Path
Gui, 98:Add, Button, gFilter w70 h20 xm Default, Apply
Gui, 98:Add, Button, gRestore w70 h20 xp+100, Restore
Gui, 98:Add, Button, gHelp w70 h20 xp+100, Help
Gui, 98:Add, Text, w100 h20 yp+50 xp-100, Parameters
Gui, 98:Add, Edit, vPar1 w70 h20 xp+80 Disabled,98
Gui, 98:Add, Edit, vPar2 w70 h20 xp+80,
Gui, 98:Add, Edit, vPar3 w70 h20 xp+80,
Gui, 98:Add, Edit, vPar4 w70 h20 xp+80,
Gui, 98:Add, Edit, vPar5 w70 h20 xp+80,
Gui, 98:Add, Edit, vPar6 w70 h20 xp+80,
Gui, 98:Add, Radio, vFunc Group yp+50 x10, LVG_Search
Gui, 98:Add, Radio, xp+100, LVG_Get
Gui, 98:Add, Radio, xp+100, LVG_Count_Un
Gui, 98:Add, Radio,  xp+100, LVG_GetNext_Un
Gui, 98:Add, Radio, x10 yp+30, LVG_Check
Gui, 98:Add, Radio, xp+100, LVG_Select
Gui, 98:Add, Radio, xp+100, LVG_Delete
Gui, 98:Show, Hide Autosize, Listview G Supplementary Library Sandbox
Gui, 98:Default
GuiControl, Disable, l_v_a
Icons := IL_Create(10)
c_r:=
LV_SetImageList(Icons)
LV_ModifyCol(2, 0)
LV_ModifyCol(1, w_lv)
Gui, 98:Show
StringSplit, drive_s, A_ScriptFullPath, \
refresh()
return

98GuiClose:
ExitApp
return

Filter:
Gui, 98:Submit, Nohide
st := A_TickCount
if Func = 1
	MsgBox, % LVG_Search(par1, par2, par3, par4, par5, par6)		
else if Func = 2
	MsgBox, % LVG_Get(par1, par2, par3, par4)
else if Func = 3
	MsgBox, % LVG_Count_Un(par1, par2)
else if Func = 4
	MsgBox, % LVG_GetNext_Un(par1, par2, par3)
else if Func = 5
{
	LVG_Check(par1, par2)
	et_s := a_tickcount-st, et_s := et_s/1000
	Gui, 98:Show, Autosize,"Listview G" Supplementary Library Sandbox | Function runtime: (%et_s% seconds) 
}	
else if Func = 6
{
	LVG_Select(par1, par2)
	et_s := a_tickcount-st, et_s := et_s/1000
	Gui, 98:Show, Autosize,"Listview G" Supplementary Library Sandbox | Function runtime: (%et_s% seconds) 
}	

else if Func = 7
{
	LVG_Delete(par1, par2)
	et_s := a_tickcount-st, et_s := et_s/1000
	Gui, 98:Show, Autosize,"Listview G" Supplementary Library Sandbox | Function runtime: (%et_s% seconds) 
}	
return

Restore:
LV_Delete()
refresh()
return

Help:
Run, http://www.autohotkey.com/forum/topic49091.html
return

refresh() {
	global
	c_r=0
	Loop, %drive_s1%\*.*,,1
	{
		if c_r >= 30
			break
		c_r++
		hIcon := DllCall("Shell32\ExtractAssociatedIconA", UInt, 0, Str, A_LoopFileLongPath, UShortP, iIndex)
		DllCall("ImageList_ReplaceIcon", UInt, Icons, Int, -1, UInt, hIcon)
		DllCall("DestroyIcon", Uint, hIcon)	
		LV_Add("Check Icon" . c_r, A_LoopFileName, A_LoopFileLongPath)
	}
	GuiControl, Enable, l_v_a
	LV_ModifyCol()
	Gui, 98:+Lastfound
	Gui, 98:Default
}	

#Include Listview_G.ahk