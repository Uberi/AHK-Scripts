testFunction:
LowLevel_init()

if (2 = 3)
{
newline :=  DllCall("AutoHotkey.dll\addFile", "str", "addfile.ahk"
, "uchar", 0, "uchar", 0, "Cdecl int")
dynamicFunction = second
}
else
{
newline :=  DllCall("AutoHotkey.dll\addFile", "str", "addfile2.ahk"
, "uchar", 0, "uchar", 0, "Cdecl int")
dynamicFunction = fourth
}

a = first
gosub f1
gosub f1
return

first(b)
{
global dynamicFunction
msgbox % b
dynamicFunction = second
}

F1::
%dynamicFunction%(a)
return

#Include %A_ScriptDir%
#Include code.ahk
#Include LowLevel.ahk




