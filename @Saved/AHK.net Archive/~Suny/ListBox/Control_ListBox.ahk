c1=Add string
c2=|Delete string N
c3=|Choose N
c4=|ChooseString
c5=|Inverse selection
c6=|Choose all with string
c7=|Choose all except string
c8=|Select all
c9=|Deselect all
cb=%c1%%c2%%c3%%c4%%c5%%c6%%c7%%c8%%c9%
Gui, Add, ComboBox, vChoice r20, %cb%
Gui, Add, Text,, Enter string or number to work.
Gui, Add, Edit, vStringN w290

Gui, Add, Text,, Name
Gui, Add, Edit, vName w290

Gui, Add, Text,, Handle
Gui, Add, Edit, vHandle w290

Gui, Add, Text,, Choose ListBox in some window and press Alt+Z to action
Gui, Add, Text,, Press Alt+X to use Name and Handle
Gui, Show
Control, Choose, 1, ComboBox1, A
return

!z::
ActiveWindow:= WinExist("A")
ControlGetFocus, FocusedControl, ahk_id %ActiveWindow%
if not FocusedControl
	return
Gui, Submit, NoHide
if Choice=Add string
   Control, Add,%StringN%,%FocusedControl%,A
if Choice=Delete string N
   Control, Delete,%StringN%,%FocusedControl%,A
if Choice=Choose N
   Control, Choose,%StringN%,%FocusedControl%,A
if Choice=ChooseString
   Control, ChooseString,%StringN%,%FocusedControl%,A
if Choice=Choose all with string
   {
    ;------------Number of items----------------------------------------------
    SendMessage, 0x18b, 0, 0, %FocusedControl%, A
    n_of_it=%ErrorLevel%
    ;------------DeSelect all-------------------------------------------------
    SendMessage, 0x185, 0, -1, %FocusedControl%, A
    ;------------Select_all_with_string---------------------------------------
    ret=retrieval string
    VAR_address:= DllCall("CharNext", str, ret, UInt)-1
    Loop, %n_of_it%
    {
    SendMessage, 0x189, a_index-1, VAR_address, %FocusedControl%, A
    StringGetPos, pos, ret, %StringN%
    if pos >= 0
    Control, Choose,%a_index%-1,%FocusedControl%,A
    ;Below was showed analog of Control-Choose as you see it have difference
    ;SendMessage, 0x185, 1, a_index-1, %FocusedControl%, A
    }
   }
if Choice=Inverse selection
   {
    ;------------Number of items----------------------------------------------
    SendMessage, 0x18b, 0, 0, %FocusedControl%, A
    n_of_it=%ErrorLevel%
    Loop, %n_of_it%
    {
    SendMessage, 0x187, a_index-1, 0, %FocusedControl%, A
    if ErrorLevel=1 
       SendMessage, 0x185, 0, a_index-1, %FocusedControl%, A
       else
       SendMessage, 0x185, 1, a_index-1, %FocusedControl%, A
    }
   }
if Choice=Choose all except string
   {
    ;------------Number of items----------------------------------------------
    SendMessage, 0x18b, 0, 0, %FocusedControl%, A
    n_of_it=%ErrorLevel%
    ;------------DeSelect all-------------------------------------------------
    SendMessage, 0x185, 0, -1, %FocusedControl%, A
    ;------------Select_all_with_string---------------------------------------
    ret=retrieval string
    VAR_address:= DllCall("CharNext", str, ret, UInt)-1
    Loop, %n_of_it%
    {
    SendMessage, 0x189, a_index-1, VAR_address, %FocusedControl%, A
    StringGetPos, pos, ret, %StringN%
    if pos >= 0
    Control, Choose,%a_index%-1,%FocusedControl%,A
    ;Below was showed analog of Control-Choose as you see it have difference
    ;SendMessage, 0x185, 1, a_index-1, %FocusedControl%, A
    }
    ;------------Inverse selection--------------------------------------------
    ;------------Number of items----------------------------------------------
    SendMessage, 0x18b, 0, 0, %FocusedControl%, A
    n_of_it=%ErrorLevel%
    Loop, %n_of_it%
    {
    SendMessage, 0x187, a_index-1, 0, %FocusedControl%, A
    if ErrorLevel=1 
       SendMessage, 0x185, 0, a_index-1, %FocusedControl%, A
       else
       SendMessage, 0x185, 1, a_index-1, %FocusedControl%, A
    }
   }
if Choice=Select all
   SendMessage, 0x185, 1, -1, %FocusedControl%, A
if Choice=Deselect all
   SendMessage, 0x185, 0, -1, %FocusedControl%, A
return

!x::
ActiveWindow:= WinExist("A")
ControlGetFocus, FocusedControl, ahk_id %ActiveWindow%
if not FocusedControl
	return
Gui, Submit, NoHide
if Choice=Add string
   Control, Add,%StringN%,%Name%,%Handle%
if Choice=Delete string N
   Control, Delete,%StringN%,%Name%,%Handle%
if Choice=Choose N
   Control, Choose,%StringN%,%Name%,%Handle%
if Choice=ChooseString
   Control, ChooseString,%StringN%,%Name%,%Handle%
if Choice=Choose all with string
   {
    ;------------Number of items----------------------------------------------
    SendMessage, 0x18b, 0, 0, %Name%,%Handle%
    n_of_it=%ErrorLevel%
    ;------------DeSelect all-------------------------------------------------
    SendMessage, 0x185, 0, -1, %Name%,%Handle%
    ;------------Select_all_with_string---------------------------------------
    ret=retrieval string
    VAR_address:= DllCall("CharNext", str, ret, UInt)-1
    Loop, %n_of_it%
    {
    SendMessage, 0x189, a_index-1, VAR_address, %Name%,%Handle%
    StringGetPos, pos, ret, %StringN%
    if pos >= 0
    Control, Choose,%a_index%-1,%Name%,%Handle%
    ;Below was showed analog of Control-Choose as you see it have difference
    ;SendMessage, 0x185, 1, a_index-1, %Name%,%Handle%
    }
   }
if Choice=Inverse selection
   {
    ;------------Number of items----------------------------------------------
    SendMessage, 0x18b, 0, 0, %Name%,%Handle%
    n_of_it=%ErrorLevel%
    Loop, %n_of_it%
    {
    SendMessage, 0x187, a_index-1, 0, %Name%,%Handle%
    if ErrorLevel=1 
       SendMessage, 0x185, 0, a_index-1, %Name%,%Handle%
       else
       SendMessage, 0x185, 1, a_index-1, %Name%,%Handle%
    }
   }
if Choice=Choose all except string
   {
    ;------------Number of items----------------------------------------------
    SendMessage, 0x18b, 0, 0, %Name%,%Handle%
    n_of_it=%ErrorLevel%
    ;------------DeSelect all-------------------------------------------------
    SendMessage, 0x185, 0, -1, %Name%,%Handle%
    ;------------Select_all_with_string---------------------------------------
    ret=retrieval string
    VAR_address:= DllCall("CharNext", str, ret, UInt)-1
    Loop, %n_of_it%
    {
    SendMessage, 0x189, a_index-1, VAR_address, %Name%,%Handle%
    StringGetPos, pos, ret, %StringN%
    if pos >= 0
    Control, Choose,%a_index%-1,%Name%,%Handle%
    ;Below was showed analog of Control-Choose as you see it have difference
    ;SendMessage, 0x185, 1, a_index-1, %Name%,%Handle%
    }
    ;------------Inverse selection--------------------------------------------
    ;------------Number of items----------------------------------------------
    SendMessage, 0x18b, 0, 0, %Name%,%Handle%
    n_of_it=%ErrorLevel%
    Loop, %n_of_it%
    {
    SendMessage, 0x187, a_index-1, 0, %Name%,%Handle%
    if ErrorLevel=1 
       SendMessage, 0x185, 0, a_index-1, %Name%,%Handle%
       else
       SendMessage, 0x185, 1, a_index-1, %Name%,%Handle%
    }
   }
if Choice=Select all
   SendMessage, 0x185, 1, -1, %Name%,%Handle%
if Choice=Deselect all
   SendMessage, 0x185, 0, -1, %Name%,%Handle%
return

