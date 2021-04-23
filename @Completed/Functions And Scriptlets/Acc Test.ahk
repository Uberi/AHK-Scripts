#NoEnv

Gui, Add, Button, x10 y10 w280 h80, Test
Gui, -Caption +LastFound
hWindow := WinExist()
Gui, Show, x0 y0 w300 h100, Acc Demo

cAccPoint := Acc_ObjectFromPoint("",150,50)
Assert(cAccPoint.accName,"Test")
Assert(Acc_Role(cAccPoint),"push button")
Assert(Acc_State(cAccPoint),"focusable")
Assert(Acc_Location(cAccPoint).pos,"x10 y10 w280 h80")
Assert(Acc_Parent(Acc_Parent(cAccPoint)).accName,"Acc Demo")

cAccWindow := Acc_ObjectFromWindow(hWindow)
Assert(cAccWindow.accChildCount,1)
Assert(Acc_WindowFromObject(cAccWindow),hWindow)

cAccEventName := "@@@@@"
DllCall("SetWinEventHook","UInt",0x8003 ;EVENT_OBJECT_HIDE
    ,"UInt",0x8003 ;EVENT_OBJECT_HIDE
    ,"UPtr",0
    ,"UPtr",RegisterCallback("EventHook","F")
    ,"UInt",DllCall("GetCurrentProcessId")
    ,"UInt",0
    ,"UInt",0
    ,"UPtr")
Gui, Hide
While, cAccEventName = "@@@@@" && A_Index < 20
    Sleep, 50
Assert(cAccEventName,"Acc Demo")

MsgBox, Tests passed successfully.
ExitApp

GuiClose:
ExitApp

EventHook(Hook,Event,hWnd,idObject,idChild,EventTime)
{
    global cAccEventName
    cAccEvent := Acc_ObjectFromEvent(_idChild_,hwnd,idObject,idChild)
    cAccEventName := cAccEvent.accName
}

Assert(Var,Value)
{
    If (Var != Value)
        throw Exception("Assertion failed.",-1,"Expected value """ . Value . """, received """ . Var . """.")
}

;------------------------------------------------------------------------------
; Acc.ahk Standard Library
; by Sean
; Updated by jethrow:
; 	Modified ComObjEnwrap params from (9,pacc) --> (9,pacc,1)
; 	Changed ComObjUnwrap to ComObjValue in order to avoid AddRef (thanks fincs)
; 	Added Acc_GetRoleText & Acc_GetStateText
; 	Added additional functions - commented below
; 	Removed original Acc_Children function
; last updated 2/19/2012
;------------------------------------------------------------------------------

Acc_Init()
{
	Static	h
	If Not	h
		h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
}
Acc_ObjectFromEvent(ByRef _idChild_, hWnd, idObject, idChild)
{
	Acc_Init()
	If	DllCall("oleacc\AccessibleObjectFromEvent", "Ptr", hWnd, "UInt", idObject, "UInt", idChild, "Ptr*", pacc, "Ptr", VarSetCapacity(varChild,8+2*A_PtrSize,0)*0+&varChild)=0
	Return	ComObjEnwrap(9,pacc,1), _idChild_:=NumGet(varChild,8,"UInt")
}

Acc_ObjectFromPoint(ByRef _idChild_ = "", x = "", y = "")
{
	Acc_Init()
	If	DllCall("oleacc\AccessibleObjectFromPoint", "Int64", x==""||y==""?0*DllCall("GetCursorPos","Int64*",pt)+pt:x&0xFFFFFFFF|y<<32, "Ptr*", pacc, "Ptr", VarSetCapacity(varChild,8+2*A_PtrSize,0)*0+&varChild)=0
	Return	ComObjEnwrap(9,pacc,1), _idChild_:=NumGet(varChild,8,"UInt")
}

Acc_ObjectFromWindow(hWnd, idObject = -4)
{
	Acc_Init()
	If	DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
	Return	ComObjEnwrap(9,pacc,1)
}

Acc_WindowFromObject(pacc)
{
	If	DllCall("oleacc\WindowFromAccessibleObject", "Ptr", IsObject(pacc)?ComObjValue(pacc):pacc, "Ptr*", hWnd)=0
	Return	hWnd
}

Acc_GetRoleText(nRole)
{
	nSize := DllCall("oleacc\GetRoleText", "Uint", nRole, "Ptr", 0, "Uint", 0)
	VarSetCapacity(sRole, (A_IsUnicode?2:1)*nSize)
	DllCall("oleacc\GetRoleText", "Uint", nRole, "str", sRole, "Uint", nSize+1)
	Return	sRole
}

Acc_GetStateText(nState)
{
	nSize := DllCall("oleacc\GetStateText", "Uint", nState, "Ptr", 0, "Uint", 0)
	VarSetCapacity(sState, (A_IsUnicode?2:1)*nSize)
	DllCall("oleacc\GetStateText", "Uint", nState, "str", sState, "Uint", nSize+1)
	Return	sState
}

; Written by jethrow
Acc_Role(Acc, ChildId=0) {
	try return ComObjType(Acc,"Name")="IAccessible"?Acc_GetRoleText(Acc.accRole(ChildId)):"invalid object"
}
Acc_State(Acc, ChildId=0) {
	try return ComObjType(Acc,"Name")="IAccessible"?Acc_GetStateText(Acc.accState(ChildId)):"invalid object"
}
Acc_Children(Acc) {
	Acc_Init()
	cChildren:=Acc.accChildCount, Children:=[]
	if DllCall("oleacc\AccessibleChildren", "Ptr", ComObjValue(Acc), "Int", 0, "Int", cChildren, "Ptr", VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*", cChildren)=0 {
		Loop %cChildren%
			i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.Insert(NumGet(varChildren,i-8)=3?child:Acc_Query(child)), ObjRelease(child)
		return Children
	}
	error:=Exception("",-1)
	MsgBox, 262420, Acc_Children Failed, % "File:  " error.file "`nLine: " error.line "`n`nContinue Script?"
	IfMsgBox, No
		ExitApp
}
Acc_Location(Acc, ChildId=0) { ; adapted from Sean's code
	try Acc.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)
	catch
		return
	return	{x:NumGet(x,0,"int"), y:NumGet(y,0,"int"), w:NumGet(w,0,"int"), h:NumGet(h,0,"int")
		,	pos:"x" NumGet(x,0,"int")" y" NumGet(y,0,"int") " w" NumGet(w,0,"int") " h" NumGet(h,0,"int")}
}
Acc_Parent(Acc) { 
	try parent:=Acc.accParent
	return parent?Acc_Query(parent):
}
Acc_Child(Acc, ChildId=0) {
	try child:=Acc.accChild(ChildId)
	return child?Acc_Query(child):
}
Acc_Query(Acc) { ; thanks Lexikos - www.autohotkey.com/forum/viewtopic.php?t=81731&p=509530#509530
	try return ComObj(9, ComObjQuery(Acc,"{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)
}