;~ This library is the Product of tank
;~ based on COM.ahk from Sean http://www.autohotkey.com/forum/topic22923.html
;~ standard library is the work of tank and updates may be downloaded from
;~ http://www.autohotkey.net/~tank/iWeb.zip
;~ http://www.autohotkey.com/forum/viewtopic.php?t=51270
;~ complete API
/*
iWeb_Init()
iWeb_Term()
iWeb_NewIe()
iWeb_Model(h=550,w=900)
iWeb_GetWin(Name="")
iWeb_GetIE(Name="A")
iWeb_GetDocument(title="A")
iWeb_BRSRfromOBJ(obj)
iWeb_Release(pdsp)
iWeb_Nav(pwb,url)
iWeb_complete(pwb)
iWeb_DomWin(pdsp,frm="")
iWeb_inpt(i)
iWeb_getDomObj(pwb,obj,frm="")
iWeb_setDomObj(pwb,obj,t,frm="")
iWeb_FindbyText(needle,win="A",property="",offset=0,frm="")
iWeb_Checked(pwb,obj,checked=1,sIndex=0,frm="")
iWeb_SelectOption(pdsp,sName,selected,method="selectedIndex",frm="")
iWeb_TableParse(pdsp,table,row,cell,frm="")
iWeb_GetElementByAll(pdsp,obj,index=0,frm="")
iWeb_GetElementsByTag(pdsp,obj,index=0,frm="")
iWeb_Offset(pdsp,offset=0)
iWeb_FireEvents(ele)
iWeb_Attributes(element)
iWeb_TableLength(pdsp,TableRows="",TableRowsCells="",frm="")
iWeb_clickDomObj(pwb,obj,frm="")
iWeb_clickText(pwb,t,frm="")
iWeb_clickHref(pwb,t,frm="")
iWeb_clickValue(pwb,t,frm="")
iWeb_execScript(pwb,js,frm="")
iWeb_getVar(pwb,var,frm="")
iWeb_escape_text(txt)
iWeb_striphtml(HTML)
iWeb_UrlEncode( String )
iWeb_uriDecode(str)
iWeb_Txt2Doc(t)
iWeb_Activate(sTitle)
*/




;~ Library initialisers

	;inititalize the library
	iWeb_Init()
	{
		Return COM_CoInitialize()
	}
	;~ close the library
	iWeb_Term()
	{
		Return COM_CoUninitialize()
	}

;~ getting/destroying browser handles*

	;~ A new internet explorer window
	iWeb_NewIe()
	{
		Return	pwb := (pwb := COM_CreateObject("InternetExplorer.Application") ) ? (pwb,COM_Invoke(pweb , "Visible=", "True")) : 0
	}
	;~ New internet explorer window always on top with titlebar only
	iWeb_Model(h=550,w=900)
	{
		If	pwb := (pwb := iWeb_newIe()) ? (pwb,	COM_Invoke(pwb,"MenuBar",0),COM_Invoke(pwb,"ToolBar",0),COM_Invoke(pwb,"Resizable",0),	COM_Invoke(pwb,"AddressBar",0),	COM_Invoke(pwb,"StatusBar",0),	COM_Invoke(pwb,"Height",h),	COM_Invoke(pwb,"Width",w)) : 
		WinSet,AlwaysOnTop,On,% "ahk_ID " COM_Invoke(pwb,"hwnd")
		Return	pwb
	}
	;~ reuse an existing tab or window
	iWeb_GetWin(Name="")
	{
	;~ 	COM_GetActiveObject("InternetExplorer.Application")
		IfEqual, Name,, WinGetTitle, Name, ahk_class IEFrame ; Get active window if no parameter 
			Name := RegExReplace(Name," - (Windows|Microsoft) Internet Explorer")
		if name
			If	psh	:=	COM_CreateObject("Shell.Application") {
				If	psw	:=	COM_Invoke(psh,	"Windows") {
					COM_Error(0)
					Loop, %	COM_Invoke(psw,	"Count")
						If	pwb	:=	(InStr(COM_Invoke(psw,"Item[" A_Index-1 "].FullName"), "iexplore.exe") && InStr(COM_Invoke(psw,"Item[" A_Index-1 "].LocationName"),Name)) ? COM_Invoke(psw,"Item",A_Index-1) :
							Break
					COM_Release(psw)
;~ 					COM_Error(1)
				}
				COM_Release(psh)
			}
		Return	pwb	? pwb : iWeb_GetIE(Name)
	}
;~ 	Usefull for particularly stubborn windows but be aware it can fail you if the page navigates and doesnt give you access to browser objects and properties
	iWeb_GetIE(Name="A") 
	{  ;;this function is an addaption made by jethrow  http://www.autohotkey.com/forum/topic318694.html
		If Name 
		{ 
			WinGet, winList, List, ahk_class IEFrame 
			While (winList%A_Index% && !m) 
			{ 
				n := A_Index, ErrorLevel := 0 
				While (!ErrorLevel && !m) 
				{ 
					ControlGetText, tabText, TabWindowClass%A_Index%, % "ahk_id" winList%n% 
					If InStr(tabText, Name) 
						m := A_Index 
				}   
			} 
			ControlGet, hIESvr, hWnd, , Internet Explorer_Server%m%, % "ahk_id" winList%n% 
		} 
		Else ControlGet, hIESvr, hWnd, , Internet Explorer_Server1, ahk_class IEFrame 
		If Not hIESvr 
			Return 
		DllCall("SendMessageTimeout", "Uint", hIESvr, "Uint", DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT"), "Uint", 0, "Uint", 0, "Uint", 2, "Uint", 1000, "UintP", lResult) 
		DllCall("oleacc\ObjectFromLresult", "Uint", lResult, "Uint", COM_GUID4String(IID_IHTMLDocument2,"{332C4425-26CB-11D0-B483-00C04FD90119}"), "int", 0, "UintP", pdoc) 
		pwb := iWeb_BRSRfromOBJ(pdoc), COM_Release(pdoc) 
		Return pwb 
} 

;~ 	Usefull for particularly stubborn windows but be aware it can fail you if the page navigates and doesnt give you access to browser objects and properties
	iWeb_GetDocument(title="A")
	{
		Static
	;~ 	Compliments Sean taken nearly un modified from the IE Spy http://www.autohotkey.com/forum/viewtopic.php?t=48470
		
		ControlGet,hWnd,Hwnd,,Internet Explorer_Server1,%title% ahk_class Internet Explorer_TridentDlgFrame
		If	!Hwnd
			ControlGet,hWnd,Hwnd,,Internet Explorer_Server1,%title% ahk_class ahk_class IEFrame
		If	!Hwnd
			Return
		If Not   pfn
		  pfn := DllCall("GetProcAddress", "Uint", DllCall("LoadLibrary", "str", "oleacc.dll"), "str", "ObjectFromLresult")
		,   msg := DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")
		,   COM_GUID4String(iid, "{00020400-0000-0000-C000-000000000046}")
		If   DllCall("SendMessageTimeout", "Uint", hWnd, "Uint", msg, "Uint", 0, "Uint", 0, "Uint", 2, "Uint", 1000, "UintP", lr:=0) && DllCall(pfn, "Uint", lr, "Uint", &iid, "Uint", 0, "UintP", pdoc:=0)=0
			Return   pdoc
	}
	
	iWeb_BRSRfromOBJ(obj)
	{ ;; accepts any child object and returns an instance of iexplore.exe
		Return COM_QueryService(pdoc,"{0002DF05-0000-0000-C000-000000000046}","{0002DF05-0000-0000-C000-000000000046}") 
	}
	
	;~ this is just a wrapper for COM_Release()
	iWeb_Release(pdsp)
	{
		COM_Release(pdsp)
	}



;~ Navigate to a url
iWeb_Nav(pwb,url)						; returns bool 
{
	If  (!pwb || !url)		;	test to see if we have a valid interface pointer
	{
		MsgBox, 262160, Browser Navigation, The Browser you tried to Navigate to `n%url%`nwith is not valid
		Return						;	ExitApp if we dont
	}
;~ 	
;~ 	http://msdn.microsoft.com/en-us/library/aa752133(VS.85).aspx
	navTrustedForActiveX	=	0x0400
	COM_Invoke(pwb,	"Navigate",	url,	navTrustedForActiveX,	"_self")
	iWeb_complete(pwb)
	Return							;	return the result(bool) of the complete function 
}									;	nav function end
;~ wait for a page to finish loading
iWeb_complete(pwb)						;	returns bool for success or failure
{	
	If  !pwb							;	test to see if we have a valid interface pointer
		sleep, 5000						;	ExitApp if we dont
	Else
	{
		loop 20							;	sets limit if itenerations to 40 seconds 80*500=40000=40 secs
			If not (rdy:=COM_Invoke(pwb,"readyState") = 4)
				Break				;	return success
			Else	Sleep,100					;	sleep .1 second between cycles
		loop 80							;	sets limit if itenerations to 40 seconds 80*500=40000=40 secs
			If (rdy:=COM_Invoke(pwb,"readyState") = 4)
				Break
			Else	Sleep,500					;	sleep half second between cycles
		Loop	80				
			If	((rdy:=COM_Invoke(pwb,"document.readystate"))="complete")
				Return 	1				;	return success
			Else	Sleep,100
	}
	Return 0						;	lets face it if it got this far it failed
}								;	end complete
;~ get the window onject from an object
iWeb_DomWin(pdsp,frm="")
{
	If	pWin	:=	COM_QueryService(pdsp,	"{332C4427-26CB-11D0-B483-00C04FD90119}",	"{332C4427-26CB-11D0-B483-00C04FD90119}") 
	{
		Loop, Parse, frm, `, 
		{
			frame:=COM_Invoke(pWin,"document.all.item['" A_LoopField "'].contentwindow")
			COM_Release(pWin)
			pWin:=COM_QueryService(frame,	"{332C4427-26CB-11D0-B483-00C04FD90119}",	"{332C4427-26CB-11D0-B483-00C04FD90119}")
			COM_Release(frame)
			If	!pWin
				Return	False
		}
		Return	pWin
	}	
	Return False
}
;~ Determin if an element is a form input 
iWeb_inpt(i)
{
;~ 			http://msdn.microsoft.com/en-us/library/ms534657(VS.85).aspx tagname property
	typ		:=	COM_Invoke(i,	"tagName")
	inpt	:=	"BUTTON,INPUT,OPTION,SELECT,TEXTAREA" ; these things all have value attribute and is likely what i need instead of innerHTML
	Loop,Parse,inpt,`,
		if (typ	=	A_LoopField	?	1	:	"")
			Return 1
	Return
}
;~ Functions that manipulate DOM

	iWeb_getDomObj(pwb,obj,frm="")
	{
	/*********************************************************************
	pwb	-	browser object
	obj	-	object reference; optionally, a comma delimited list of references (name, id or index) of all value can be used
	frm -	frame reference; optionally, a comma delimited list of frames (name, id or index ) of all value can be used
	example of usage
	The below will try to get an object called 'username'
	iWeb_getDomObj(pwb,"username")
	*/
		If	itm		:=	iWeb_GetElementByAll(pwb,obj,0,frm)	;if this fails there really isnt any need to do below
		{
			rslt	.=	iWeb_uriDecode(COM_Invoke(itm,T:=iWeb_inpt(itm) ? "value" : "innerHTML")) ","
			iWeb_FireEvents(itm)
			COM_Release(itm)
		}
		Return	rslt
	}

	iWeb_setDomObj(pwb,obj,t,frm="")
	{
	/*********************************************************************
	pwb	-	browser object
	obj	-	object reference; optionally 
	t	-	text to place in object; 
	frm -	frame reference; optionally, 
	Example Usage
	The below will take a browser object, try to get an object called 'username' and set its value/innerHTML to 'john'
	iWeb_setDomObj(pwb,"username","john")
	*/
			If	itm		:=	iWeb_GetElementByAll(pwb,obj,0,frm)	;if this fails there really isnt any need to do below
			{
				;~ 	making invoke take integers as Strings  ",	VT_BSTR:=8"
				;~ 	http://www.autohotkey.com/forum/viewtopic.php?p=221631#221631 iWeb_uriDecode(str)
				COM_Invoke_(itm,v:=iWeb_inpt(itm) ? "Value=" : "innerHTML=",8,iWeb_UrlEncode(t))
				iWeb_FireEvents(itm)
				COM_Release(itm)
				d=1
			}
		Return d
	}

	iWeb_FindbyText(needle,win="A",property="",offset=0,frm="")
	{
		If	pWin	:=	iWeb_DomWin(pwb,frm) 
		{
			If	oRange:=COM_Invoke(pWin,"document.body.createTextRange")
			{
				COM_Invoke(oRange,"findText",needle)
				_res:=property ? COM_Invoke(pWin,"Document.all.item[" COM_Invoke(oRange,"parentElement.sourceIndex")+offset "]." property) :  COM_Invoke(pWin,"Document.all.item", COM_Invoke(oRange,"parentElement.sourceIndex")+offset)
				COM_Release(oRange)
			}	
		}
		Return	_res
	}

	iWeb_Checked(pwb,obj,checked=1,sIndex=0,frm="")
	{
		If	pWin	:=	iWeb_DomWin(pwb,frm) 
		{
			COM_Invoke(pWin,(string:=sIndex ? "document.all[" obj "].item[" sIndex "]" : "document.all[" obj "]") ".checked",checked)
			Checkmark	:= COM_Invoke(pWin,string ".checked") ? True	: False
			iWeb_FireEvents(ele:=COM_Invoke(pWin,string))
			COM_Release(ele)
			COM_Release(pWin)
		}
		Return	Checkmark
	}

	iWeb_SelectOption(pdsp,sName,selected,method="selectedIndex",frm="")
	{
		If	pWin	:=	iWeb_DomWin(pdsp,frm) 
		{
			COM_Invoke(pWin,"document.all[" sName "].selectedIndex" ,selected)
			iWeb_FireEvents(ele:=COM_Invoke(pWin,"document.all[" sName "]."))
			COM_Release(ele)
			COM_Release(pWin)
		}
		Return	
	}

	iWeb_TableParse(pdsp,table,row,cell,frm="")
	{
	;~ 	http://www.w3schools.com/jsref/dom_obj_table.asp
		ErrorLevel:=
		If	ErrorLevel:=!(pWin	:=	iWeb_DomWin(pdsp,frm)) ? "failed to get a window handle" : false
			Return ErrorLevel
;~ 		COM_Error(0)
		cell:=pWin ? COM_Invoke(pWin,"document.all.tags[table].item[" table "].rows[" row "].cells[" cell "]") : false
;~ 		COM_Error(1)
		COM_Release(pWin)
		If	!cell
			Return ErrorLevel:="**** failed to get the cell reference ****"
		result:=cell ? COM_Invoke(cell,"innerHTML")  : 
		iWeb_FireEvents(cell)
		COM_Release(cell)
		Return result
	}




iWeb_GetElementByAll(pdsp,obj,sindex=0,frm=""){ ;; returns object
;~ 	COM_Error(0)
	Return element := (pWin	:=	iWeb_DomWin(pdsp,frm) ) ? ((sindex > 0 ?  COM_Invoke(pWin,"document.all.['" obj "'].item",sindex) : COM_Invoke(pWin,"document.all.item", obj )),COM_Release(pWin)) : 
}

iWeb_GetElementsByTag(pdsp,tag,obj=0,frm=""){  ;; returns object
	Return element := (pWin	:=	iWeb_DomWin(pdsp,frm) ) ? (COM_Invoke(pWin,"document.all.tags['" tag "'].item",obj),COM_Release(pWin)) : 
}

iWeb_Offset(pdsp,offset=0){
	Return element := (pWin	:=	iWeb_DomWin(pdsp,frm) ) ? (COM_Invoke(pWin,"document.all",COM_Invoke(pdsp,"sourceIndex") + offset),COM_Release(pWin)) : 
}

iWeb_FireEvents(ele)
{
	attributes:=iWeb_Attributes(ele)
	Loop,Parse,attributes, `n
		If	InStr(A_LoopField,"on")
			COM_Invoke(ele,A_LoopField)
}

iWeb_Attributes(element)
{  ;;http://msdn.microsoft.com/en-us/library/ms537438.aspx
    n=0
	appliesTo=A,ABBR,ACRONYM,ADDRESS,APPLET,AREA,attribute,B,BASE,BASEFONT,BDO,BGSOUND, ,BIG,BLOCKQUOTE,BODY,BR,BUTTON,CAPTION,CENTER,CITE,CODE,COL,COLGROUP,COMMENT,DD,DEL, ,DFN,DIR,DIV,DL,DT,EM,EMBED,FIELDSET,FONT,FORM,FRAME,FRAMESET,HEAD,hn,HR,HTML,I,IFRAME, ,IMG,INS,INPUT,KBD,LABEL,LEGEND,LI,LINK,LISTING,MAP,MARQUEE,MENU,nextID,OBJECT,OL, ,OPTION,P,PLAINTEXT,PRE,Q,S,SAMP,SCRIPT,SELECT,SMALL,SPAN,STRIKE,STRONG,SUB,SUP, ,TABLE,TBODY,TD,TEXTAREA,TFOOT,TH,THEAD,TITLE,TR,TT,U,UL,VAR,XMP
	applies:=
	If !tagname:=COM_Invoke(element,"tagname")
		Return
	Loop,Parse,appliesTo,`,
		If	(A_LoopField = tagname)
		{
			applies:=1
			Break
		}
	If !applies || !cAttr:= COM_Invoke(element,"attributes")
		Return ;; error getting the attributes
	Loop,% COM_Invoke(cAttr,"length")
		If	oAttr:=COM_Invoke(cAttr,"item", n++ )
		{
			If	COM_Invoke(oAttr,"specified") ;; true if the attribute is defined in the attribute
				the_attributes.=COM_Invoke(oAttr,"nodeName") "`n"
;~ 				the_attributes.=COM_Invoke(oAttr,"nodeName") "=""" COM_Invoke(oAttr,"nodeValue")  """`n"
			COM_Release(oAttr),oAttr:=
		}
		Else	Break
	StringTrimRight,the_attributes,the_attributes,1
	Return	the_attributes
}

iWeb_TableLength(pdsp,TableRows="",TableRowsCells="",frm="") 
{
	/*
	TableRows - table index id or name for the table whos rows you wish to count
	TableRowsCells - row index id or name for the table whos rows you wish to count TableRows is required for this
	*/
	ErrorLevel:=
	If	ErrorLevel:=!(pWin	:=	iWeb_DomWin(pdsp,frm)) ? "failed to get a window handle" : false
		Return ErrorLevel
	string:="document.all.tags[table]" (t:=(StrLen(TableRows) ? (".item[" TableRows "].rows" (r:=StrLen(TableRowsCells) ? ("[" TableRowsCells "].cells") : "")) : ""))
;~ 	COM_Error(0)
	ref:=pWin ? COM_Invoke(pWin,string) : false
;~ 	COM_Error(1)
	COM_Release(pWin)
	If	!ref
		Return ErrorLevel:="**** failed to get the iWeb_TableLength reference ****"
	result:=ref ? COM_Invoke(ref,"length")  : 
	COM_Release(ref)
	Return result
}



;~ functions that click 

	iWeb_clickDomObj(pwb,obj,frm="")
	{
	/*********************************************************************
	pwb	-	browser object
	obj	-	object reference; optionally, a comma delimited list of references (name, id or index) of all value can be used
	frm -	frame reference; optionally, a comma delimited list of frames (name, id or index ) of all value can be used
	Example of Usage
	The below will take a browser object and try to click an object called username
	iWeb_getDomObj(pwb,"username")
	This will cycle thru and attempt to click 3 separate objects (username, pass and 3) 
	iWeb_clickDomObj(pwb,"username,pass,3")
	This will recurse into the 'left' frame and try to click an object called 'results'
	iWeb_clickDomObj(pwb,"results","left")
	*/ 
		If	pWin	:=	iWeb_DomWin(pwb,frm) 
		{
			COM_Invoke(pWin,"Document.all.item['" obj "'].click")
			d=1
			COM_Release(pWin)
		}
		Return	d
	}
	iWeb_clickText(pwb,t,frm="")
	{
	/*********************************************************************
	pwb	-	browser object
	t 	-	text with in the link to check against
	frm -	frame reference; optionally, a comma delimited list of frames (name, id or index ) of all value can be used
	Example Usage
	The below will take a browser object and try to click an object with the text 'Click Here'
	iWeb_clickText(pwb,"Click Here")
	This will recurse into the 'left' frame and try to click an object with the text 'Contact Us'
	iWeb_clickText(pwb,"Contact Us","left")
	*/
		If	pWin	:=	iWeb_DomWin(pwb,frm) 
		{
			Loop,%	COM_Invoke(pWin,"document.links.length")
				If	InStr(COM_Invoke(pWin,"document.links.item[" A_Index-1 "].innertext"),t)
				{
					COM_Invoke(pWin,"document.links.item[" A_Index-1 "].click")
					d=1
					Break
				}	
			COM_Release(pWin)
		} ;;If	pWin
		Return	d
	}
	iWeb_clickHref(pwb,t,frm="")
	{
	/*********************************************************************
	pwb	-	browser object
	t 	-	text with in the href to check against
	frm -	frame reference; optionally, a comma delimited list of frames (name, id or index ) of all value can be used
	Example Usage
	This will click a link with the text below in the href attribute even if there were more following that entry in the href
	iWeb_clickHref(pwb,"javascript:alert('this was in a link')")
	This will recurse into the 'left' frame and try to click an object with the url for AutoHotkey's forum in an href
	iWeb_clickHref(pwb,"http://www.autohotkey.com/forum/","left")
	*/
		If	pWin	:=	iWeb_DomWin(pwb,frm) 
		{
			Loop,%	COM_Invoke(pWin,"document.links.length")
				If	InStr(COM_Invoke(pWin,"document.links.item[" A_Index-1 "].href"),t)
				{
					COM_Invoke(pWin,"document.links.item[" A_Index-1 "].click")
					d=1
					Break
				}	
			COM_Release(pWin)
		} ;;If	pWin
		Return	d
	}
	iWeb_clickValue(pwb,t,frm="")
	{
	/*********************************************************************
	pwb	-	browser object
	t	-	text to match from visible button or other inputs
	frm -	frame reference; optionally, a comma delimited list of frames (name, id or index ) of all value can be used
	Example Usage
	The below will click an element that has a value attribute equal to 'Submit'
	iWeb_clickValue(pwb,"Submit")
	This will recurse into the 'left' frame and try to click an object with the value 'Enter'
	iWeb_clickValue(pwb,"Enter","left")
	*/
		If	pWin	:=	iWeb_DomWin(pwb,frm) 
		{
			Loop,%	COM_Invoke(pWin,"document.all.length")
				If	iWeb_inpt(itm:=COM_Invoke(pWin,"document.all.item", A_Index-1)) ? InStr(COM_Invoke(pWin,"document.all.item[" A_Index-1 "].value"),t) : 0
				{
					COM_Invoke(itm,"click")
					COM_Release(itm)
					d=1
					Break
				}	
				Else	COM_Release(itm)
			COM_Release(pWin)
		} ;;If	pWin
		Return	d
	}



;~ Functions used to interact with scripts embeded in a web page

;~ 	insert and execute a javascript statement into an exisiting document window
	iWeb_execScript(pwb,js,frm="")
	{
		If	(js && (pWin:=	iWeb_DomWin(pwb,frm)))
		{
			COM_Invoke(pWin,	"execScript",	js)
			COM_Release(pWin)
		}
		Return
	}
;~ 	retreive a global variable value from a page
	iWeb_getVar(pwb,var,frm="")
	{
		If	(var && (pWin:=	iWeb_DomWin(pwb,frm)))
		{
			rslt:=	COM_Invoke(pWin,	var)
			COM_Release(pWin)
		}
		Return rslt
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
	iWeb_UrlEncode( String )
	{
		OldFormat := A_FormatInteger
		SetFormat, Integer, H

		Loop, Parse, String
		{
			if A_LoopField is alnum
			{
				Out .= A_LoopField
				continue
			}
			Hex := SubStr( Asc( A_LoopField ), 3 )
			Out .= "%" . ( StrLen( Hex ) = 1 ? "0" . Hex : Hex )
		}

		SetFormat, Integer, %OldFormat%

		return Out
	}

	iWeb_uriDecode(str) { 
	   Loop 
		  If RegExMatch(str, "i)(?<=%)[\da-f]{1,2}", hex) 
			 StringReplace, str, str, `%%hex%, % Chr("0x" . hex), All 
		  Else Break 
	   Return, str 
	} 


;~ takes an html fragment and creates a DOM document from a string
iWeb_Txt2Doc(t)
{
	If	doc := COM_CreateObject("{25336920-03F9-11CF-8FD0-00AA00686F13}") 
		COM_Invoke(doc, "write", t),COM_Invoke(doc, "close") 
	Return doc
}
;~ Sets a window and tab as active by the page title
iWeb_Activate(sTitle) 
{ 
; thanks Sean 
; http://www.autohotkey.com/forum/viewtopic.php?p=231093#231093 
	DllCall("LoadLibrary", "str", "oleacc.dll") 
	HWND:=COM_Invoke(pwb:=iWeb_getwin(sTitle),"HWND")
	DetectHiddenWindows, On 
	WinActivate,% "ahk_id " HWND
	WinWaitActive,% "ahk_id " HWND,,5
	ControlGet, hTabBand, hWnd,, TabBandClass1, ahk_class IEFrame
	ControlGet, hTabUI  , hWnd,, DirectUIHWND1, ahk_id %hTabBand% 
	If   hTabUI && DllCall("oleacc\AccessibleObjectFromWindow", "Uint", hTabUI, "Uint",-4, "Uint", COM_GUID4String(IID_IAccessible,"{618736E0-3C3D-11CF-810C-00AA00389B71}"), "UintP", pacc)=0 
	{ 
		Loop, %   COM_Invoke(pacc, "accChildCount") 
			If   paccChild:=COM_Invoke(pacc, "accChild", A_Index) 
				If   COM_Invoke(paccChild, "accRole", 0) = 0x3C 
				{ 
					paccTab:=paccChild 
					Break 
				} 
				Else   COM_Release(paccChild) 
		COM_Release(pacc) 
	} 
	If   pacc:=paccTab 
	{ 
		Loop, %   COM_Invoke(pacc, "accChildCount") 
			If   paccChild:=COM_Invoke(pacc, "accChild", A_Index) 
				If   COM_Invoke(paccChild, "accName", 0) = sTitle   
				{ 
					COM_Release(pwb),VarSetCapacity(pwb,0),VarSetCapacity(HWND,0)
					COM_Invoke(paccChild, "accDoDefaultAction", 0)
					COM_Release(paccChild) 
					Break 
				} 
				Else   COM_Release(paccChild) 
		COM_Release(pacc) 
	}  
	WinActivate,% sTitle
} 
