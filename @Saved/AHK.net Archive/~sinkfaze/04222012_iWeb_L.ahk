#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;~ This library is the Product of tank
;~ based on COM.ahk from Sean http://www.autohotkey.com/forum/topic22923.html
;~ standard library is the work of tank and updates may be downloaded from
;~ http://www.autohotkey.net/~tank/iWeb.zip
;~ http://www.autohotkey.com/forum/viewtopic.php?t=51270

;~ complete API
/*
iWeb_newIe()
iWeb_Model(h=550,w=900)
iWeb_getwin(Name="")
iWeb_nav(pwb,url)
iWeb_complete(pwb)
iWeb_DomWin(pDisp,frm="")
iWeb_inpt(i)
iWeb_getDomObj(pwb,obj,frm="")
iWeb_setDomObj(pwb,obj,t,frm="")
iWeb_Checked(pwb,obj,checked=1,sIndex=0,frm="")
iWeb_SelectOption(pDisp,sName,selected,method="selectedIndex",frm="")
iWeb_TableParse(pDisp,table,row,cell,frm="")
iWeb_FireEvents(ele)
iWeb_TableLength(pDisp,TableRows="",TableRowsCells="",frm="")
iWeb_clickDomObj(pwb,obj,frm="")
iWeb_clickText(pwb,t,frm="")
iWeb_clickHref(pwb,t,frm="")
iWeb_clickValue(pwb,t,frm="")
iWeb_execScript(pwb,js,frm="")
iWeb_getVar(pwb,var,frm="")
iWeb_escape_text(txt)
iWeb_striphtml(HTML)
iWeb_Txt2Doc(t)
iWeb_Activate(sTitle)
*/
;~~~~~ Library initialisers ~~~~~
;~~~~~ getting/destroying browser handles ~~~~~

	;~ A new internet explorer window
	iWeb_newIe()
	{
		Return	pwb :=	(pwb :=	ComObjCreate("InternetExplorer.Application")) ? (pwb, pwb.visible :=	True) : 0
	}
	;~ New internet explorer window always on top with titlebar only
	iWeb_Model(h=550,w=900)
	{
		If	pwb :=	(pwb :=	ComObjCreate("InternetExplorer.Application"))
		{
			For attr, value in {menuBar:0,addressBar:0,statusBar:0,height:h,width:w}
				pwb[attr] :=	value
		}
		WinSet, AlwaysOnTop, On, %	"ahk_class " pwb.hwnd
		Return	pwb
	}
	;~ reuse an existing tab or window
	iWeb_getWin(Name="")
	{
		If	!Name
			WinGetTitle, Name, ahk_class IEFrame	; Get active window if no parameter 
		Name := RegExReplace(Name," - (?:Windows|Microsoft) Internet Explorer"), ComObjError(0)
		For pwb in ComObjCreate("Shell.Application").Windows
			If	(InStr(pwb.LocationName,Name) && InStr(pwb.FullName,"iexplore.exe")
			{
				ComObjError(1)
				return	pwb
			}
		ComObjError(1)
		Return	0	
	}

	;~ Navigate to a url
	iWeb_nav(pwb,url)	; returns bool 
	{
		If	!pwb {		; test to see if we have a valid interface pointer
			MsgBox, 262160, Browser Navigation, The Browser you tried to Navigate to `n%url%`nwith is not valid
			Return		;	ExitApp if we dont
		}
		;~ 	http://msdn.microsoft.com/en-us/library/aa752133
		pwb.Navigate(url), iWeb_complete(pwb)
		Return			;	return the result(bool) of the complete function 
	}

	;~ wait for a page to finish loading
	iWeb_complete(pwb)		;	returns bool for success or failure
	{	
		If	!pwb		;	test to see if we have a valid interface pointer
			return	False	;	ExitApp if we dont
		ComObjError(0)
		While	(pwb.readyState <> 4 && pwb.document.readystate <> "complete" && pwb.busy)
			Sleep, 50
		ComObjError(1)
	}								;	end complete

	;~ get the window onject from an object
	iWeb_DomWin(pwb,frm="")
	{

		static	IID :=	"{332C4427-26CB-11D0-B483-00C04FD90119}"

		If	!pWin :=	ComObjQuery(pwb,IID,IID)
			return	False
		if	frm {
			Loop, Parse, frm, `, 
			{
				frame :=	pWin.document.all.item[A_LoopField].contentWindow
				If	!pWin :=	ComObjQuery(frame,IID,IID)
					Return	False
			}
		}
		Return	pWin
	}

	;~ Determine if an element is a form input 
	iWeb_inpt(itm)
	{
		;~ 	http://msdn.microsoft.com/en-us/library/ms534657 tagname property
		return	RegExMatch("BUTTON,INPUT,OPTION,SELECT,TEXTAREA","\b" itm.tagName "\b") ? 1 : 0
	}


;~~~~~ Functions that manipulate DOM ~~~~~

	iWeb_getDomObj(pdsp,obj,frm="")
	{

		If	!pWin :=	frm ? iWeb_DomWin(pdsp,frm) : iWeb_domWin(pdsp)
			return	False
		all :=	pWin.document.all
		Loop,Parse,obj,`,
		{
			If	itm :=	all.item[A_LoopField]	; if this fails there really isnt any need to do below
			{
				tx := iWeb_inpt(itm) ? itm.value : itm.innerHTML
				StringReplace,tx,tx,`,,&#44;,all	; escape all commas in text extracted always
				rslt .=	tx ","
				iWeb_FireEvents(itm)
			}
		}
		Return	Trim(rslt)
	}

	iWeb_setDomObj(pdsp,obj,t,frm="")
	{

		If	!pWin :=	frm ? iWeb_DomWin(pdsp,frm) : iWeb_domWin(pdsp)
			return	False
		all :=	pWin.document.all
		StringSplit,tt,t,`,
		Loop,Parse,obj,`,
		{
			If	itm :=	all.item[A_LoopField]	; if this fails there really isnt any need to do below
			{
				StringReplace,tt%A_Index%,tt%A_Index%,&#44;,`,,all	;	unescape all commas in text extracted always
				if	iWeb_inpt(itm)
					itm.value :=	ComObjParameter(8,tt%A_Index%)
				else	itm.innerHTML :=	ComObjParameter(8,tt%A_Index%)
			}
			iWeb_FireEvents(itm)
		}
		Return	1
	}

	iWeb_Checked(pdsp,obj,chkd=1,sIndex=-1,frm="")
	{
		If !pWin := frm ? iWeb_DomWin(pdsp,frm) : iWeb_domWin(pdsp)
			return False
		rObj:=pWin.document.all[obj]
		sIndex > -1 ? (rObj.item[sIndex].checked:=chkd) : (rObj.checked:=chkd)
		c :=(sIndex > -1 ? (rObj.item[sIndex].checked) : (rObj.checked)) ? True : False
		iWeb_FireEvents(rObj)
		Return	c
	}

	iWeb_selectOption(pdsp,sName,selected,method="selectedIndex",frm="")
	{
		If	!pWin :=	frm ? iWeb_DomWin(pdsp,frm) : iWeb_domWin(pdsp)
			return	False
		dObj :=	pWin.document.all[sName], dObj[method] :=	selected, iWeb_FireEvents(dObj)
		Return	True	
	}

	iWeb_getTagLen(pdsp,tag,frm="")
	{ 

		If	!pWin :=	frm ? iWeb_domWin(pdsp,frm) : iWeb_domWin(pdsp) 
			return	False 
		return	pWin.document.all.tags[tag].length

	}

	iWeb_getTagObj(pdsp,tag,itm,type="innerText",frm="")
	{ 

		If	!pWin :=	frm ? iWeb_domWin(pdsp,frm) : iWeb_domWin(pdsp) 
			return	False 
		return	pWin.document.all.tags[tag].item[itm][type] 

	}

	iWeb_getTblLen(pdsp,t,r=-1,frm="")
	{ 

		If	!pWin :=	frm ? iWeb_domWin(pdsp,frm) : iWeb_domWin(pdsp) 
			return	False 
		tObj :=	pWin.document.all.tags["table"].item[t] 
		return	r<0 ? tObj.rows.length : tObj.rows[r].cells.length 

	}

	iWeb_getTblObj(pdsp,t,r=-1,c=-1,type="innerText",frm="")
	{ 

		If	!pWin :=	frm ? iWeb_domWin(pdsp,frm) : iWeb_domWin(pdsp) 
			return	False 
		tObj :=	pWin.document.all.tags["table"].item[t] 
		return	(r>-1 && c<0) ? tObj.rows[r][type] 
		 : (r>-1 && c>-1) ? tObj.rows[r].cells[c][type] 
		 : tObj[type] 

	}

	iWeb_FireEvents(ele)
	{
		ComObjError(0)
		For each, event in ["onfocus","onblur","onchange","onclick","onkeyup"]
			ele.fireEvent(event)
		ComObjError(1)
	}

;~~~~~ functions that click ~~~~~

	iWeb_clickDomObj(pdsp,obj,frm="")
	{

		if	!pWin :=	frm ? iWeb_domWin(pdsp,frm) : iWeb_domWin(pdsp) 
			return	False 
		itm :=	pWin.document.all[obj].click(), iWeb_FireEvents(itm)
		Return	True
	}
	iWeb_clickText(pdsp,t,frm="")
	{
		if	!pWin :=	frm ? iWeb_domWin(pdsp,frm) : iWeb_domWin(pdsp) 
			return	False
		ComObjError(0), links :=	pWin.document.links
		Loop %	links.length {
			If	InStr(links.item[A_Index-1].innertext,t) {
				links.item[A_Index-1].click(), iWeb_FireEvents(links.item[A_Index-1]), ComObjError(1)
				return	1
			}
		}
		ComObjError(1)	
		Return	0
	}

	iWeb_clickHref(pdsp,t,frm="")
	{
		if	!pWin :=	frm ? iWeb_domWin(pdsp,frm) : iWeb_domWin(pdsp) 
			return	False
		ComObjError(0), links :=	pWin.document.links
		Loop %	links.length {
			If	InStr(links.item[A_Index-1].href,t) {
				links.item[A_Index-1].click, iWeb_FireEvents(links.item[A_Index-1]), ComObjError(1)
				return	1
			}
		}
		ComObjError(1)	
		Return	0
	}

	iWeb_clickValue(pdsp,t,frm="")
	{
		if	!pWin :=	frm ? iWeb_domWin(pdsp,frm) : iWeb_domWin(pdsp) 
			return	False
		ComObjError(0), all :=	pWin.document.all
		Loop % all.length {
			If	iWeb_inpt(all.item[A_Index-1]) ? InStr(all.item[A_Index-1].value,t) : 0
			{
					all.item[A_Index-1].click(), iWeb_FireEvents(all.item[A_Index-1]), ComObjError(1)
					return	1
			}	
		}
		ComObjError(1)
		Return	0
	}

;~~~~~ Functions used to interact with scripts embeded in a web page ~~~~~

;~ 	insert and execute a javascript statement into an exisiting document window
	iWeb_execScript(pwb,js,frm="")
	{
		If	!pWin :=	frm ? iWeb_DomWin(pwb,frm) : iWeb_DomWin(pwb)
			return	False
		return	pWin.execScript :=	js
	}

;~ 	retreive a global variable value from a page
	iWeb_getVar(pwb,var,frm="")
	{
		If	!pWin :=	frm ? iWeb_DomWin(pwb,frm) : iWeb_DomWin(pwb)
			return	False
		return	pWin.var
	}
	
	;~ 	this helper function is really designed to return only 
	;~ 	useable un formated text that can be used within javascript
	iWeb_escape_text(txt)
	{
		
		StringReplace,txt,txt,',\',ALL
		StringReplace,txt,txt,"",\"",ALL
		;~ StringReplace,txt,txt,`.`.,`.,ALL
		StringReplace,txt,txt,`r,%a_space%,ALL
		StringReplace,txt,txt,`n,%a_space%,ALL
		StringReplace,txt,txt,`n`r,%a_space%,ALL
		StringReplace,txt,txt,%a_space%%a_space%,%a_space%,ALL
		return txt	
	}
;~ 	simply stripts html tags from a string
	iWeb_striphtml(HTML)
	{
;~ 		thanks lazlo http://www.autohotkey.com/forum/viewtopic.php?p=71935#71935
		Loop Parse, HTML, <>
			If (A_Index & 1) 
				noHTML .= A_LoopField
		Return noHTML
	}

	;~ takes an html fragment and creates a DOM document from a string

	iWeb_Txt2Doc(t)
	{
		If	doc :=	ComObjCreate("{25336920-03F9-11CF-8FD0-00AA00686F13}") 
			doc.write :=	t, doc.close() 
		Return	doc
	}

;~ Sets a window and tab as active by the page title

	iWeb_Activate(sTitle) 
	{ 
		; thanks Sean 
		; http://www.autohotkey.com/forum/viewtopic.php?p=231093#231093 
		DllCall("LoadLibrary", "str", "oleacc.dll") 
		DetectHiddenWindows, On 
		WinActivate, %	"ahk_id " HWND
		WinWaitActive, %	"ahk_id " HWND,,5
		ControlGet, hTabBand, hWnd,, TabBandClass1, ahk_class IEFrame
		ControlGet, hTabUI  , hWnd,, DirectUIHWND1, ahk_id %hTabBand% 
		If	hTabUI && DllCall("oleacc\AccessibleObjectFromWindow", "Uint", hTabUI, "Uint",-4, "Uint", COM_GUID4String(IID_IAccessible,"{618736E0-3C3D-11CF-810C-00AA00389B71}"), "UintP", pacc)=0 
		{ 
			Loop, %   pacc.accChildCount 
				If   paccChild:=pacc.accChild[A_Index] 
					If   paccChild.accRole[0] = 0x3C 
					{ 
						paccTab:=paccChild 
						Break 
					} 
		} 
		If   pacc:=paccTab 
		{ 
			Loop, %   pacc.accChildCount 
				If   paccChild:=pacc.accChild[A_Index] 
					If   paccChild.accName[0] = sTitle   
					{ 
						paccChild.accDoDefaultAction[0]
						Break 
					} 
		}  
		WinActivate,% sTitle
	} 