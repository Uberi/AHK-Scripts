;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Written by Tank
;;	Based on Seans most excelent work COM.ahk
;;	http://www.autohotkey.com/forum/viewtopic.php?t=22923
;;	some credit due to Lexikos for ideas arrived at from ScrollMomentum
;;	http://www.autohotkey.com/forum/viewtopic.php?t=24264
;;	1-17-2009
;;	Please use and distribute freely
;;	Please do not claim it as your own
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;~ CONSTANTS/PARAMETERS
{
	GuiWinTitle = iWebBrowser2 Learner Build ID:2.0 ; added by jethrow
}
;~ DIRECTIVES
{
	DetectHiddenWindows,on
	SetTitleMatchMode,slow	
	SetTitleMatchMode,2
	link=linked,traversed
	getRole=selectable,read only
	altinpt=check box,radio button	
	
}

; <COMPILER: v1.0.48.3>
;~ AUTOEXEC
{
	COM_CoInitialize()
	COM_Error(0)

	Gui, Add, Tab, x5 y5 w430 h580, Viewer|Script Writer|Source|Forms|Templates|About
	Gui, Tab, Viewer
	;	~~~GroupBox layout~~~
	Gui, Add, GroupBox, x15 y30 w405 h110 , Browser	
	Gui, Add, GroupBox, xp+10 yp+15 wp-20 hp-70, Page Title	;	x25 y45 w385 h40
	Gui, Add, GroupBox, xp yp+45 wp hp, URL/Address			;	x25	y90 w385 h40
	Gui, Add, GroupBox, xp-10 yp+60 wp+20 hp+50 , Document	;	x15 y150 w405 h70
	Gui, Add, GroupBox, xp+10 yp+15 w190 h65, Client Area	;	x25 y175 w190 h65
	Gui, Add, GroupBox, xp+195 yp wp hp, Mouse Coordinates	;	x220 y175 w190 h65
	Gui, Add, GroupBox, xp-205 yp+85 wp+215 hp+185 , Element Under Mouse	;	x15 y290 w405 h280
	Gui, Add, GroupBox, xp+10 yp+45 wp-20 hp-185 , Frames
	Gui, Add, GroupBox, xp yp+75 wp hp+55 , Element Text
	Gui, Add, GroupBox, xp-10 yp+135 wp+20 hp-55 , iWeb Function Examples (press Ctrl+e when mouse is over desired element)
	;	~~~Title/URL Edit layout~~~
	Gui, Add, Edit, x33 y59 w370 h20 vTitle,
	Gui, Add, Edit, xp yp+46 wp hp vURLL,
	;	~~~Client Area & Mouse Coordinates Text/Edit layout~~~
	Gui, Add, Text, x40 y185 w65 h17 , Width
	Gui, Add, Text, xp yp+20 wp hp , Height				;	x40 y205 w65 h17
	Gui, Add, Edit, xp+70 yp-20 wp-5 hp ReadOnly vclientWidth,	;	x110 y185 w60 h17
	Gui, Add, Edit, xp yp+20 wp hp ReadOnly vclientHeight,		;	x110 y205 w60 h17
	Gui, Add, Text, xp+125 yp-20 wp+5 hp , Mouse X		;	x235 y185 w65 h17
	Gui, Add, Text, xp yp+20 wp hp , Mouse Y			;	x235 y205 w65 h17
	Gui, Add, Edit, xp+75 yp-20 wp-5 hp ReadOnly vMouseX,		;	x310 y185 w60 h17
	Gui, Add, Edit, xp yp+20 wp hp ReadOnly vMouseY,				;	x310 y205 w60 h17
	;	~~~Element Under Mouse layout~~~
	Gui, Add, Text, x25 y277 w65 h17 , Index
	Gui, Add, Text, xp+115 yp wp hp , Name				;	x140 y277 w65 h17
	Gui, Add, Text, xp+150 yp wp hp , ID				;	x290 y277 w65 h17
	Gui, Add, Edit, xp-230 yp-2 wp-10 hp vEleIndex,		;	x60 y275 w55 h17
	Gui, Add, Edit, xp+115 yp wp+45 hp vEleName,		;	x175 y275 w100 h17
	Gui, Add, Edit, xp+135 yp wp hp vEleIDs,			;	x310 y275 w100 h17
	Gui, Add, Edit, xp-275 yp+35 wp+265 h40 vtheFrame,
	Gui, Add, Edit, xp yp+75 wp hp+55 vhtml_text,
;	Gui, Add, Edit, xp-10 yp+135 wp+20 h40 viWeb
	Gui, Add, ListBox, xp-10 yp+135 wp+20 r3 gCopy viWeb
	Gui, Add, Edit, x180 y275 w10 h10 Hidden vHTMLTag
	

	Gui, Tab, Script Writer
	Gui, Add, Button, x16 y77 w90 h30 gInitWindow, As Existing
	Gui, Add, Button, x126 y77 w100 h30 gNewWindow, New Browser
	Gui, Tab, Script Writer
	Gui, Add, CheckBox, x246 y77 w80 h30 vBrowser_hidden +Checked, Visible
	Gui, Add, Text, x16 y237 w60 h20 , Function
	Gui, Add, DropDownList, x76 y237 w200 h21 r8 vFunctionList, iWeb_clickDomObj|iWeb_getDomObj|iWeb_setDomObj
	Gui, Add, Button, x16 y327 w100 h20 gAddScript, Add to script
	Gui, Add, Button, x126 y327 w50 h20 gRunScript, Run
	Gui, Add, Button, x186 y327 w60 h20 gSaveScript, Save
	Gui, Add, Edit, x76 y267 w200 h20 vNewValue,
	Gui, Tab, Script Writer
	Gui, Add, GroupBox, x6 y297 w420 h200 , Your code so far
	Gui, Add, Edit, x16 y357 w400 h130 vCodeWindow,
	Gui, Add, Text, x6 y27 w410 h20 , Hit pause before using options from this screen
	Gui, Add, GroupBox, x6 y57 w420 h140 vWindowTitle,
	Gui, Add, Text, x16 y117 w90 h20 , Some Javascript
	Gui, Add, Button, x116 y117 w90 h20 gTestJscript , Test Code
	Gui, Add, Button, x216 y117 w90 h20 gAddJscript, Add to Script
	Gui, Add, Edit, x16 y147 w400 h40 vJavascript,
	Gui, Add, GroupBox, x6 y217 w420 h80 , Element
	Gui, Add, CheckBox, x286 y237 w130 h40 , Wait for navigation to complete after click
	Gui, Add, Text, x16 y267 w60 h20 , New Value
	Gui, Tab, Source
	Gui, Add, Edit, x6 y37 w420 h450 vSource,
	Gui, Tab, About
	Gui, Add, GroupBox, x6 y37 w400 h110 , Author
	Gui, Add, Text, x16 y57 w50 h60 , Tank`nJethrow`nSinkfaze
;	Gui, +AlwaysOnTop
	Gui, +Delimiter`n
	Gui, Show, Center w440, %GuiWinTitle% ; modified by jethrow
	;WinGet, GuiHWND, ID, % GuiWinTitle "ahk_class AutoHotkeyGUI" ; added by jethrow


    GetWin:
;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	While, GetKeyState("LButton","P") {
		WinGetPos, Wx, Wy, , , ahk_id %WinHWND%
		If(Wx <> Stored_Wx || Wy <> Stored_Wy)
			Outline("Hide")
		Sleep, 10
	}
	WinGetTitle, WinTitle, ahk_id %WinHWND%
	WinGetPos, Wx, Wy, Ww, Wh, ahk_id %WinHWND%
	If(Ww <> Stored_Ww || Wh <> Stored_Wh || WinTitle <> Stored_WinTitle) && (WinHWND = Stored_WinHWND)
		Outline("Hide"), Resized:=True ; Hide outline if the window either changes size or WinTitle (set variable "Resized" as true)
	Else If(Wx <> Stored_Wx || Wy <> Stored_Wy) && !Resized && (WinHWND = Stored_WinHWND) ; move outline if Window moves (not if window has been resized)
		Outline( x1+=Wx-Stored_Wx, y1+=Wy-Stored_Wy, x2+=Wx-Stored_Wx, y2+=Wy-Stored_Wy )
	Stored_Wx := Wx, Stored_Wy := Wy, Stored_Ww := Ww, Stored_Wh := Wh, Stored_WinTitle := WinTitle, Stored_WinHWND := WinHWND
	GoSub, SetOulineLevel	
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^	
	if paused
		GoTo, GetWin
	GetKeyState("LButton","P") ? "" : IE_HtmlElement()
	Goto,GetWin

	#s::
		psv:=COM_CreateObject("SAPI.SpVoice")
		COM_Invoke(psv, "Speak", textOfObj)
		COM_Release(psv)
	Return

	Pause::
	^/::
	paused:= paused ? "" : 1
	WinSetTitle, % GuiWinTitle "ahk_class AutoHotkeyGUI",, % GuiWinTitle (paused ? " PAUSED":"")
	SetTimer,GetWin,-10
	Return

	^e::
	Gui, Submit, NoHide
	if theFrame {
		Pos=1
		While Pos:=RegExMatch(theFrame,"is)sourceIndex]=(.*?) \*\*\[name]= (.*?) \*\*\[id]= (\V*)",f,Pos+StrLen(f))
			fpath.=((f1) ? (f1) : ((f3) ? (f3) : (f2))) . (A_Index=1 ? "" : ",")
	}
	oFrm:=fpath ? ",""" fpath """" : ""
	dObj:=((EleName) ? (EleName) : ((EleIDs) ? (EleIDs) : (EleIndex)))
	pacc := iWebacc_AccessibleObjectFromPoint()
	oState:=((paccChild:=iWebacc_Child(pacc, _idChild_)) ? iWebacc_State(paccChild) : iWebacc_State(pacc,_idChild_))
	oRole:=((paccChild:=iWebacc_Child(pacc, _idChild_)) ? iWebacc_Role(paccChild) : iWebacc_Role(pacc,_idChild_))
	oName:=((paccChild:=iWebacc_Child(pacc, _idChild_)) ? iWebacc_Name(paccChild) : iWebacc_Name(pacc,_idChild_))
	oValue:=((paccChild:=iWebacc_Child(pacc, _idChild_)) ? iWebacc_Value(paccChild) : iWebacc_Value(pacc,_idChild_))
	res.= ((InStr(link,RegExReplace(oState,"\h+.*"))) ? "iWeb_clickDomObj(pwb,""" dObj """" oFrm ")`n"
			. ((oName) ? "iWeb_clickText(pwb,""" oName """" oFrm ")`n" : "")
			. ((oValue) ? "iWeb_clickHref(pwb,""" oValue """" oFrm ")" : "")
		: ((HTMLTag="INPUT" && InStr(altinpt,oRole)) ? "iWeb_clickDomObj(pwb,""" dObj """" oFrm ")`n"
			. ((oName) ? "iWeb_clickText(pwb,""" oName """" oFrm ")`n" : "")
			. ((oValue) ? "iWeb_clickHref(pwb,""" oValue """" oFrm ")" : "")
		: ((InStr(oRole,"editable") && InStr(getRole,RegExReplace(oState,"\h+.*"))) ? "iWeb_getDomObj(pwb,""" dObj """" oFrm ")"
		: ((HTMLTag="INPUT" && !InStr(altinpt,oRole) && (oRole <> "push button")) ? "iWeb_setDomObj(pwb,""" dObj """" oFrm ")"
		: ((HTMLTag="INPUT" && oRole="push button" && !EleName && !EleIDs) ? "iWeb_clickValue(pwb,""" oName """" oFrm ")`n"
			. "iWeb_clickDomObj(pwb,""" EleIndex """" oFrm ")"
		: ((HTMLTag="INPUT" && oRole="push button") ? "iWeb_clickDomObj(pwb,""" dObj """" oFrm ")`n"
			.  "iWeb_clickValue(pwb,""" oName """" oFrm ")`n"
		: ((HTMLTag="SELECT") ? "iWeb_setDomObj(pwb,""" dObj """" oFrm ")"
		: "iWeb_getDomObj(pwb,""" dObj """" oFrm ")")))))))
	GuiControl, , iWeb, `n%res%
	VarSetCapacity(res,0), VarSetCapacity(fpath,0)
	return
}
GuiClose:
COM_CoUninitialize()
ExitApp



IE_HtmlElement()
{
	CoordMode, Mouse
	MouseGetPos, xpos, ypos,, hCtl, 3
	WinGetClass, sClass, ahk_id %hCtl%
	If Not   sClass == "Internet Explorer_Server"
		|| Not   pdoc := IE_GetDocument(hCtl)
			Return


	GuiControl,Text,MouseX,%	xpos
	GuiControl,Text,MouseY,%	ypos
	pwin :=   COM_QueryService(pdoc ,"{332C4427-26CB-11D0-B483-00C04FD90119}")
	IID_IWebBrowserApp := "{0002DF05-0000-0000-C000-000000000046}"
	iWebBrowser2 := COM_QueryService(pwin,IID_IWebBrowserApp,IID_IWebBrowserApp)
	GuiControl,Text,WindowTitle,%	COM_Invoke(iWebBrowser2,"LocationName")
	GuiControl,Text,Title,%	COM_Invoke(iWebBrowser2,"LocationName")
	GuiControl,Text,URLL,% COM_Invoke(iWebBrowser2,"LocationURL")
	GuiControl,Text,browserReadystate,%	 COM_Invoke(iWebBrowser2,"readystate")
	GuiControl,Text,browserHWND,%	 COM_Invoke(iWebBrowser2,"hwnd")
	GuiControl,Text,browserHeight,%	 COM_Invoke(iWebBrowser2,"height")
	GuiControl,Text,browserWidth,%	 COM_Invoke(iWebBrowser2,"width")
	GuiControl,Text,browserLeft,%	 COM_Invoke(iWebBrowser2,"left")
	GuiControl,Text,browserTop,%	 COM_Invoke(iWebBrowser2,"top")
	
	If   pelt := COM_Invoke(pwin , "document.elementFromPoint", xpos-xorg:=COM_Invoke(pwin ,"screenLeft"), ypos-yorg:=COM_Invoke(pwin ,"screenTop"))
	{
		framepath:=
		COM_Release(pwin)
		While   (type:=COM_Invoke(pelt,"tagName"))="IFRAME" || type="FRAME"
		{
			selt .=   "[" type "]." A_Index " **[sourceIndex]=" COM_Invoke(pelt,"sourceindex") " **[name]= " COM_Invoke(pelt,"name") " **[id]= " COM_Invoke(pelt,"id") "`n"
			framepath.=(COM_Invoke(pelt,"id") ? COM_Invoke(pelt,"id") :  COM_Invoke(pelt,"sourceindex")) ","
			pwin :=   COM_QueryService(pbrt:=COM_Invoke(pelt,"contentWindow"), "{332C4427-26CB-11D0-B483-00C04FD90119}"), COM_Release(pbrt), COM_Release(pdoc)
			pdoc :=   COM_Invoke(pwin, "document"), COM_Release(pwin)
			pbrt :=   COM_Invoke(pdoc, "elementFromPoint", xpos-xorg+=COM_Invoke(pelt,"getBoundingClientRect.left"), ypos-yorg+=COM_Invoke(pelt,"getBoundingClientRect.top")), COM_Release(pelt), pelt:=pbrt
		}

		pbrt :=   COM_Invoke(pelt, "getBoundingClientRect")
		l  :=   COM_Invoke(pbrt, "left")
		t  :=   COM_Invoke(pbrt, "top")
		r  :=   COM_Invoke(pbrt, "right")
		b  :=   COM_Invoke(pbrt, "bottom")
;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
		global WinHWND, x1, y1, x2, y2
		WinHWND := COM_Invoke(iWebBrowser2, "HWND"), COM_Release(iWebBrowser2)
		If(x1 <> l+xorg || y1 <> t+yorg || x2 <> r+xorg || y2 <> b+yorg)
			Outline( x1:=l+xorg, y1:=t+yorg, x2:=r+xorg, y2:=b+yorg )
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^	
		StringTrimRight,framepath,framepath,1
		GuiControl,Text,theFrame,%	selt
		GuiControl,Text,EleIndex,%	sI:=COM_Invoke(pelt,"sourceindex")
		GuiControl,Text,EleName,%	sName:=COM_Invoke(pelt,"name")
		GuiControl,Text,EleIDs,%	sID:=COM_Invoke(pelt,"id")
		GuiControl,Text,clientHeight,%	COM_Invoke(pdoc,"body.clientHeight")
		GuiControl,Text,clientWidth,%	COM_Invoke(pdoc,"body.clientWidth")
		GuiControl,Text,Source,%	COM_Invoke(pdoc,"documentelement.outerhtml")
		global textOfObj
		GuiControl,Text,html_text
		,%	(textOfObj:=inpt(pelt)) " `n" COM_Invoke(pelt, "outerhtml")
		GuiControl,Text,HTMLTag,%	COM_Invoke(pelt,"tagName")
		innert:=COM_Invoke(pelt, "innerHTML")
		StringReplace, textOfObj, textOfObj,]=,?
		StringSplit,textOfObjs,textOfObj,?

		StringReplace,textOfObj,textOfObjs2,`,,&#44;,all
		optFrames:=framepath ? ", """ framepath """" : ""
		global element,optFrames
		element:=sID ? sID : sNames ? sName : sI
		optFrames:=framepath ? ", """ framepath """" : ""




		COM_Release(pbrt)
		COM_Release(pelt)

	}
	COM_Release(pdoc)
	Return
}

inpt(i)
{

	typ		:=	COM_Invoke(i,	"tagName")
	inpt	:=	"BUTTON,INPUT,OPTION,SELECT,TEXTAREA"
	Loop,Parse,inpt,`,
		if (typ	=	A_LoopField	?	1	:	"")
			Return "[value]=" COM_Invoke(i,	"value")
	Return "[innertext]=" COM_Invoke(i,	"innertext")
}

IE_GetDocument(hWnd)
{
   Static
   If Not   pfn
      pfn := DllCall("GetProcAddress", "Uint", DllCall("LoadLibrary", "str", "oleacc.dll"), "str", "ObjectFromLresult")
   ,   msg := DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")
   ,   COM_GUID4String(iid, "{00020400-0000-0000-C000-000000000046}")
   If   DllCall("SendMessageTimeout", "Uint", hWnd, "Uint", msg, "Uint", 0, "Uint", 0, "Uint", 2, "Uint", 1000, "UintP", lr:=0) && DllCall(pfn, "Uint", lr, "Uint", &iid, "Uint", 0, "UintP", pdoc:=0)=0
   Return   pdoc
}

;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
Outline(x1,y1="",x2="",y2="") {
	global WinHWND, Resized
	If x1 = Hide
	{
		Loop, 4
			Gui, % A_Index+1 ": Hide"
		Return
	}
	GoSub, SetOutlineTransparent
	Loop, 4 {
		Gui, % A_Index+1 ": Hide"
		Gui, % A_Index+1 ": -Caption +ToolWindow"
		Gui, % A_Index+1 ": Color" , Red
	}
	WinGetPos, Wx, Wy, , , ahk_id %WinHWND%
	ControlGetPos, Cx1, Cy1, Cw, Ch, Internet Explorer_Server1, ahk_id %WinHWND%
	Cx1 += Wx, Cy1 += Wy, Cx2 := Cx1+Cw, Cy2 := Cy1+Ch, Resized := False ; set "Internet Explorer_Server1" dimensions (set variable "Resized" as true)
	If(y1>Cy1)
		Gui, 2:Show, % "NA X" (x1<Cx1 ? Cx1 : x1)-2 " Y" (y1<Cy1 ? Cy1 : y1)-2 " W" (x2>Cx2 ? Cx2 : x2)-(x1<Cx1 ? Cx1 : x1)+4 " H" 2,outline1
	If(x2<Cx2)
		Gui, 3:Show, % "NA X" (x2>Cx2 ? Cx2 : x2) " Y" (y1<Cy1 ? Cy1 : y1) " W" 2 " H" (y2>Cy2 ? Cy2 : y2)-(y1<Cy1 ? Cy1 : y1),outline2
	If(y2<Cy2)
		Gui, 4:Show, % "NA X" (x1<Cx1 ? Cx1 : x1)-2 " Y" (y2>Cy2 ? Cy2 : y2) " W" (x2>Cx2 ? Cx2 : x2)-(x1<Cx1 ? Cx1 : x1)+4 " H" 2,outline3
	If(x1>Cx1)
		Gui, 5:Show, % "NA X" (x1<Cx1 ? Cx1 : x1)-2 " Y" (y1<Cy1 ? Cy1 : y1) " W" 2 " H" (y2>Cy2 ? Cy2 : y2)-(y1<Cy1 ? Cy1 : y1),outline4
	GoSub, SetOulineLevel
	Return
}
SetOutlineTransparent:
	Loop, 4
		WinSet, Transparent, 0, % outline%A_Index%
Return
SetOulineLevel:
	If Not outline1
		Loop, 4
			WinGet, outline%A_Index%, ID, % "outline" A_Index " ahk_class AutoHotkeyGUI"
	; thanks Chris! - http://www.autohotkey.com/forum/topic5672.html&highlight=getnextwindow
	hwnd_above := DllCall("GetWindow", "uint", WinHWND, "uint", 0x3) ; get window directly above "WinHWND"
	While(hwnd_above=outline1 || hwnd_above=outline2 || hwnd_above=outline3 || hwnd_above=outline4 || hwnd_above=GuiHWND) ; don't use 5 AHK GUIs
		hwnd_above := DllCall("GetWindow", "uint", hwnd_above, "uint", 0x3)
	; thanks Lexikos! - http://www.autohotkey.com/forum/topic22763.html&highlight=setwindowpos
	Loop, 4 { ; set 4 "outline" GUI's directly below "hwnd_above"
		DllCall("SetWindowPos", "uint", outline%A_Index%, "uint", hwnd_above
			, "int", 0, "int", 0, "int", 0, "int", 0
			, "uint", 0x13) ; NOSIZE | NOMOVE | NOACTIVATE ( 0x1 | 0x2 | 0x10 )
		WinSet, Transparent, 255, % outline%A_Index%
	}
Return
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^	



NewWindow:
{
	Gui,Submit,NoHide

	initString=
(
iWeb_Init()
pwb:=iWeb_newIe()
iWeb_nav("%URLL%")
)
	writeScript(initString)
	Return
}
InitWindow:
{
	Gui,Submit,NoHide
	initString=
(
iWeb_Init()
pwb:=iWeb_getwin("%Title%")
)
	writeScript(initString)


	Return
}

writeScript(code)
{
	global
	Gui,Submit,NoHide
	GuiControl,text,CodeWindow,% CodeWindow "`n" code
	Return



}

getURL(t)
{
	If	psh	:=	COM_CreateObject("Shell.Application") {
		If	psw	:=	COM_Invoke(psh,	"Windows") {
			Loop, %	COM_Invoke(psw,	"Count")
				If	url	:=	(InStr(COM_Invoke(psw,"Item[" A_Index-1 "].LocationName"),t) && InStr(COM_Invoke(psw,"Item[" A_Index-1 "].FullName"), "iexplore.exe")) ? COM_Invoke(psw,"Item[" A_Index-1 "].LocationURL") :
					Break
			COM_Release(psw)
		}
		COM_Release(psh)
	}
	Return	url
}



AddScript:
{

	Gui,Submit,NoHide
	If	(NewValue && FunctionList = "iWeb_setDomObj")
	{
		writeScript(FunctionList "(pwb,""" element """,""" NewValue """" optFrames ")")
		GuiControl,text,NewValue,
	}
	Else	writeScript(FunctionList "(pwb,""" element """" optFrames ")")
	Return
}

AddJscript:
{

	Gui,Submit,NoHide
	js=
	(
js=`n(`n%Javascript%`n)
iWeb_execScript(pwb,js %optFrames%)
	)
	writeScript(js)
	GuiControl,text,Javascript,
	Return
}

TestJscript:
{

	Gui,Submit,NoHide
	pwb:=iWeb_getwin(Title)
	iWeb_execScript(pwb,Javascript %optFrames%)
	COM_Release(pwb)
	Return
}

RunScript:
{


	Gui,Submit,NoHide
	FileDelete,%A_ScriptDir%\temp.ahk
	FileAppend,%CodeWindow%,%A_ScriptDir%\temp.ahk
	RunWait	%A_ScriptDir%\temp.ahk
	FileDelete,%A_ScriptDir%\temp.ahk
	Return
}


SaveScript:
{


	Gui,Submit,NoHide
	FileSelectFile,script
	FileDelete,%script%
	FileAppend,%CodeWindow%,%script%
	Return
}

Copy:

Gui, Submit, NoHide
if A_GuiEvent = DoubleClick
	GuiControl, Text, CodeWindow, % (!CodeWindow || RegExMatch(CodeWindow,"\v$")) ? CodeWindow iWeb : CodeWindow "`n" iWeb
return

iWebacc_Query(pacc, bunk = "")
{
	If	DllCall(NumGet(NumGet(1*pacc)+0), "Uint", pacc, "Uint", COM_GUID4String(IID_IAccessible,bunk ? "{00020404-0000-0000-C000-000000000046}" : "{618736E0-3C3D-11CF-810C-00AA00389B71}"), "UintP", pobj)=0
		DllCall(NumGet(NumGet(1*pacc)+8), "Uint", pacc), pacc:=pobj
	Return	pacc
}

iWebacc_AccessibleObjectFromPoint(x = "", y = "", ByRef _idChild_ = "")
{
	VarSetCapacity(varChild,16,0)
	x<>""&&y<>"" ? pt:=x&0xFFFFFFFF|y<<32 : DllCall("GetCursorPos", "int64P", pt)
	DllCall("oleacc\AccessibleObjectFromPoint", "int64", pt, "UintP", pacc, "Uint", &varChild)
	_idChild_ := NumGet(varChild,8)
	Return	pacc
}

iWebacc_Child(pacc, idChild)
{
	If	DllCall(NumGet(NumGet(1*pacc)+36), "Uint", pacc, "int64", 3, "int64", idChild, "UintP", paccChild)=0 && paccChild
	Return	iWebacc_Query(paccChild)
}

iWebacc_Name(pacc, idChild = 0)
{
	If	DllCall(NumGet(NumGet(1*pacc)+40), "Uint", pacc, "int64", 3, "int64", idChild, "UintP", pName)=0 && pName
	Return	COM_Ansi4Unicode(pName) . SubStr(COM_SysFreeString(pName),1,0)
}

iWebacc_Value(pacc, idChild = 0)
{
	If	DllCall(NumGet(NumGet(1*pacc)+44), "Uint", pacc, "int64", 3, "int64", idChild, "UintP", pValue)=0 && pValue
	Return	COM_Ansi4Unicode(pValue) . SubStr(COM_SysFreeString(pValue),1,0)
}

iWebacc_Role(pacc, idChild = 0)
{
	VarSetCapacity(var,16,0)
	If	DllCall(NumGet(NumGet(1*pacc)+52), "Uint", pacc, "int64", 3, "int64", idChild, "Uint", &var)=0
	Return	iWebacc_GetRoleText(NumGet(var,8))
}

iWebacc_State(pacc, idChild = 0)
{
	VarSetCapacity(var,16,0)
	If	DllCall(NumGet(NumGet(1*pacc)+56), "Uint", pacc, "int64", 3, "int64", idChild, "Uint", &var)=0
	Return	iWebacc_GetStateText(nState:=NumGet(var,8)) . "`t(" . iWebacc_Hex(nState) . ")"
}

iWebacc_GetRoleText(nRole)
{
	nSize := DllCall("oleacc\GetRoleTextA", "Uint", nRole, "Uint", 0, "Uint", 0)
	VarSetCapacity(sRole, nSize)
	DllCall("oleacc\GetRoleTextA", "Uint", nRole, "str", sRole, "Uint", nSize+1)
	Return	sRole
}

iWebacc_GetStateText(nState)
{
	nSize := DllCall("oleacc\GetStateTextA", "Uint", nState, "Uint", 0, "Uint", 0)
	VarSetCapacity(sState, nSize)
	DllCall("oleacc\GetStateTextA", "Uint", nState, "str", sState, "Uint", nSize+1)
	Return	sState
}

iWebacc_Hex(num)
{
	old := A_FormatInteger
	SetFormat, Integer, H
	num += 0
	SetFormat, Integer, %old%
	Return	num
}
