;Windows Messages taken from http://wiki.winehq.org/List_Of_Windows_Messages + @
;Thanks to WINE team

;Autocomplete function for ComboBox taken from
;http://www.autohotkey.com/forum/viewtopic.php?t=20837#133231
;Thanks to Titan

#NoEnv
#SingleInstance, Force

Gui, +AlwaysOnTop +ToolWindow +LastFound
UIDSelf:=WinExist()
Gui, Add, GroupBox, x6 y10 w450 h100, Set Target Window (MButton on Target Window/Control or type manually)
Gui, Add, Text, x16 y33 w110 h20 +Right, TitleMatchMode :
Gui, Add, Text, x16 y63 w110 h20 +Right, Window Title :
Gui, Add, Text, x16 y93 w110 h20 +Right, Control :
Gui, Add, DropDownList, x136 y30 w180 h20 r30 vTitleMatchMode, Exact Match(3)||Partial Match(2)|Start With(1)|Regular Expression
Gui, Add, Edit, x136 y60 w180 h20 vWindowTitle
Gui, Add, Edit, x136 y90 w180 h20 vControl
Gui, Add, CheckBox, x336 y25 w150 h30 vDetectHidden,Detect Hidden
Gui, Add, Button, x326 y70 w123 h30 gBang, Bang !
;--------------------------------------------------------------
Gui, Add, GroupBox, x6 y120 w450 h70, Specify Message (Choose or Type manually)
Gui, Add, Text, x16 y140 w100 h20 +Center, Method
Gui, Add, DropDownList, x16 y160 w110 h20 r10 vMethod, PostMessage||SendMessage
Gui, Add, Text, x166 y140 w100 h20 +Center, Message
Gui, Add, ComboBox, x136 y160 w170 h20 r20 vMessage gAutoComplete, WM_NULL|WM_CREATE|WM_DESTROY|WM_MOVE|WM_SIZE|WM_ACTIVATE|WM_SETFOCUS|WM_KILLFOCUS|WM_ENABLE|WM_SETREDRAW|WM_SETTEXT|WM_GETTEXT|WM_GETTEXTLENGTH|WM_PAINT|WM_CLOSE|WM_QUERYENDSESSION|WM_QUERYOPEN|WM_ENDSESSION|WM_QUIT|WM_ERASEBKGND|WM_SYSCOLORCHANGE|WM_SHOWWINDOW|WM_WININICHANGE|WM_SETTINGCHANGE|WM_DEVMODECHANGE|WM_ACTIVATEAPP|WM_FONTCHANGE|WM_TIMECHANGE|WM_CANCELMODE|WM_SETCURSOR|WM_MOUSEACTIVATE|WM_CHILDACTIVATE|WM_QUEUESYNC|WM_GETMINMAXINFO|WM_PAINTICON|WM_ICONERASEBKGND|WM_NEXTDLGCTL|WM_SPOOLERSTATUS|WM_DRAWITEM|WM_MEASUREITEM|WM_DELETEITEM|WM_VKEYTOITEM|WM_CHARTOITEM|WM_SETFONT|WM_GETFONT|WM_SETHOTKEY|WM_GETHOTKEY|WM_QUERYDRAGICON|WM_COMPAREITEM|WM_GETOBJECT|WM_COMPACTING|WM_COMMNOTIFY|WM_WINDOWPOSCHANGING|WM_WINDOWPOSCHANGED|WM_POWER|WM_COPYDATA|WM_CANCELJOURNAL|WM_NOTIFY|WM_INPUTLANGCHANGEREQUEST|WM_INPUTLANGCHANGE|WM_TCARD|WM_HELP|WM_USERCHANGED|WM_NOTIFYFORMAT|WM_CONTEXTMENU|WM_STYLECHANGING|WM_STYLECHANGED|WM_DISPLAYCHANGE|WM_GETICON|WM_SETICON|WM_NCCREATE|WM_NCDESTROY|WM_NCCALCSIZE|WM_NCHITTEST|WM_NCPAINT|WM_NCACTIVATE|WM_GETDLGCODE|WM_SYNCPAINT|WM_NCMOUSEMOVE|WM_NCLBUTTONDOWN|WM_NCLBUTTONUP|WM_NCLBUTTONDBLCLK|WM_NCRBUTTONDOWN|WM_NCRBUTTONUP|WM_NCRBUTTONDBLCLK|WM_NCMBUTTONDOWN|WM_NCMBUTTONUP|WM_NCMBUTTONDBLCLK|WM_NCXBUTTONDOWN|WM_NCXBUTTONUP|WM_NCXBUTTONDBLCLK|WM_INPUT|WM_KEYFIRST|WM_KEYDOWN|WM_KEYUP|WM_CHAR|WM_DEADCHAR|WM_SYSKEYDOWN|WM_SYSKEYUP|WM_SYSCHAR|WM_SYSDEADCHAR|WM_UNICHAR|WM_KEYLAST_NT501|UNICODE_NOCHAR|WM_KEYLAST_PRE501|WM_IME_STARTCOMPOSITION|WM_IME_ENDCOMPOSITION|WM_IME_COMPOSITION|WM_IME_KEYLAST|WM_INITDIALOG|WM_COMMAND||WM_SYSCOMMAND|WM_TIMER|WM_HSCROLL|WM_VSCROLL|WM_INITMENU|WM_INITMENUPOPUP|WM_MENUSELECT|WM_MENUCHAR|WM_ENTERIDLE|WM_MENURBUTTONUP|WM_MENUDRAG|WM_MENUGETOBJECT|WM_UNINITMENUPOPUP|WM_MENUCOMMAND|WM_CHANGEUISTATE|WM_UPDATEUISTATE|WM_QUERYUISTATE|WM_CTLCOLORMSGBOX|WM_CTLCOLOREDIT|WM_CTLCOLORLISTBOX|WM_CTLCOLORBTN|WM_CTLCOLORDLG|WM_CTLCOLORSCROLLBAR|WM_CTLCOLORSTATIC|WM_MOUSEFIRST|WM_MOUSEMOVE|WM_LBUTTONDOWN|WM_LBUTTONUP|WM_LBUTTONDBLCLK|WM_RBUTTONDOWN|WM_RBUTTONUP|WM_RBUTTONDBLCLK|WM_MBUTTONDOWN|WM_MBUTTONUP|WM_MBUTTONDBLCLK|WM_MOUSEWHEEL|WM_XBUTTONDOWN|WM_XBUTTONUP|WM_XBUTTONDBLCLK|WM_MOUSELAST_5|WM_MOUSELAST_4|WM_MOUSELAST_PRE_4|WM_PARENTNOTIFY|WM_ENTERMENULOOP|WM_EXITMENULOOP|WM_NEXTMENU|WM_SIZING|WM_CAPTURECHANGED|WM_MOVING|WM_POWERBROADCAST|WM_DEVICECHANGE|WM_MDICREATE|WM_MDIDESTROY|WM_MDIACTIVATE|WM_MDIRESTORE|WM_MDINEXT|WM_MDIMAXIMIZE|WM_MDITILE|WM_MDICASCADE|WM_MDIICONARRANGE|WM_MDIGETACTIVE|WM_MDISETMENU|WM_ENTERSIZEMOVE|WM_EXITSIZEMOVE|WM_DROPFILES|WM_MDIREFRESHMENU|WM_IME_SETCONTEXT|WM_IME_NOTIFY|WM_IME_CONTROL|WM_IME_COMPOSITIONFULL|WM_IME_SELECT|WM_IME_CHAR|WM_IME_REQUEST|WM_IME_KEYDOWN|WM_IME_KEYUP|WM_MOUSEHOVER|WM_MOUSELEAVE|WM_NCMOUSEHOVER|WM_NCMOUSELEAVE|WM_WTSSESSION_CHANGE|WM_TABLET_FIRST|WM_TABLET_LAST|WM_CUT|WM_COPY|WM_PASTE|WM_CLEAR|WM_UNDO|WM_RENDERFORMAT|WM_RENDERALLFORMATS|WM_DESTROYCLIPBOARD|WM_DRAWCLIPBOARD|WM_PAINTCLIPBOARD|WM_VSCROLLCLIPBOARD|WM_SIZECLIPBOARD|WM_ASKCBFORMATNAME|WM_CHANGECBCHAIN|WM_HSCROLLCLIPBOARD|WM_QUERYNEWPALETTE|WM_PALETTEISCHANGING|WM_PALETTECHANGED|WM_HOTKEY|WM_PRINT|WM_PRINTCLIENT|WM_APPCOMMAND|WM_THEMECHANGED|WM_HANDHELDFIRST|WM_HANDHELDLAST|WM_AFXFIRST|WM_AFXLAST|WM_PENWINFIRST|WM_PENWINLAST|WM_APP|WM_USER|EM_GETSEL|EM_SETSEL|EM_GETRECT|EM_SETRECT|EM_SETRECTNP|EM_SCROLL|EM_LINESCROLL|EM_SCROLLCARET|EM_GETMODIFY|EM_SETMODIFY|EM_GETLINECOUNT|EM_LINEINDEX|EM_SETHANDLE|EM_GETHANDLE|EM_GETTHUMB|EM_LINELENGTH|EM_REPLACESEL|EM_GETLINE|EM_LIMITTEXT|EM_CANUNDO|EM_UNDO|EM_FMTLINES|EM_LINEFROMCHAR|EM_SETTABSTOPS|EM_SETPASSWORDCHAR|EM_EMPTYUNDOBUFFER|EM_GETFIRSTVISIBLELINE|EM_SETREADONLY|EM_SETWORDBREAKPROC|EM_GETWORDBREAKPROC|EM_GETPASSWORDCHAR|EM_SETMARGINS|EM_GETMARGINS|EM_SETLIMITTEXT|EM_GETLIMITTEXT|EM_POSFROMCHAR|EM_CHARFROMPOS|EM_SETIMESTATUS|EM_GETIMESTATUS|BM_GETCHECK|BM_SETCHECK|BM_GETSTATE|BM_SETSTATE|BM_SETSTYLE|BM_CLICK|BM_GETIMAGE|BM_SETIMAGE|STM_SETICON|STM_GETICON|STM_SETIMAGE|STM_GETIMAGE|STM_MSGMAX|DM_GETDEFID|DM_SETDEFID|DM_REPOSITION|LB_ADDSTRING|LB_INSERTSTRING|LB_DELETESTRING|LB_SELITEMRANGEEX|LB_RESETCONTENT|LB_SETSEL|LB_SETCURSEL|LB_GETSEL|LB_GETCURSEL|LB_GETTEXT|LB_GETTEXTLEN|LB_GETCOUNT|LB_SELECTSTRING|LB_DIR|LB_GETTOPINDEX|LB_FINDSTRING|LB_GETSELCOUNT|LB_GETSELITEMS|LB_SETTABSTOPS|LB_GETHORIZONTALEXTENT|LB_SETHORIZONTALEXTENT|LB_SETCOLUMNWIDTH|LB_ADDFILE|LB_SETTOPINDEX|LB_GETITEMRECT|LB_GETITEMDATA|LB_SETITEMDATA|LB_SELITEMRANGE|LB_SETANCHORINDEX|LB_GETANCHORINDEX|LB_SETCARETINDEX|LB_GETCARETINDEX|LB_SETITEMHEIGHT|LB_GETITEMHEIGHT|LB_FINDSTRINGEXACT|LB_SETLOCALE|LB_GETLOCALE|LB_SETCOUNT|LB_INITSTORAGE|LB_ITEMFROMPOINT|LB_MULTIPLEADDSTRING|LB_GETLISTBOXINFO|LB_MSGMAX_501|LB_MSGMAX_WCE4|LB_MSGMAX_4|LB_MSGMAX_PRE4|CB_GETEDITSEL|CB_LIMITTEXT|CB_SETEDITSEL|CB_ADDSTRING|CB_DELETESTRING|CB_DIR|CB_GETCOUNT|CB_GETCURSEL|CB_GETLBTEXT|CB_GETLBTEXTLEN|CB_INSERTSTRING|CB_RESETCONTENT|CB_FINDSTRING|CB_SELECTSTRING|CB_SETCURSEL|CB_SHOWDROPDOWN|CB_GETITEMDATA|CB_SETITEMDATA|CB_GETDROPPEDCONTROLRECT|CB_SETITEMHEIGHT|CB_GETITEMHEIGHT|CB_SETEXTENDEDUI|CB_GETEXTENDEDUI|CB_GETDROPPEDSTATE|CB_FINDSTRINGEXACT|CB_SETLOCALE|CB_GETLOCALE|CB_GETTOPINDEX|CB_SETTOPINDEX|CB_GETHORIZONTALEXTENT|CB_SETHORIZONTALEXTENT|CB_GETDROPPEDWIDTH|CB_SETDROPPEDWIDTH|CB_INITSTORAGE|CB_MULTIPLEADDSTRING|CB_GETCOMBOBOXINFO|CB_MSGMAX_501|CB_MSGMAX_WCE400|CB_MSGMAX_400|CB_MSGMAX_PRE400|SBM_SETPOS|SBM_GETPOS|SBM_SETRANGE|SBM_SETRANGEREDRAW|SBM_GETRANGE|SBM_ENABLE_ARROWS|SBM_SETSCROLLINFO|SBM_GETSCROLLINFO|SBM_GETSCROLLBARINFO|LVM_FIRST|TV_FIRST|HDM_FIRST|TCM_FIRST|PGM_FIRST|ECM_FIRST|BCM_FIRST|CBM_FIRST|CCM_FIRST|CCM_LAST|CCM_SETBKCOLOR|CCM_SETCOLORSCHEME|CCM_GETCOLORSCHEME|CCM_GETDROPTARGET|CCM_SETUNICODEFORMAT|CCM_GETUNICODEFORMAT|CCM_SETVERSION|CCM_GETVERSION|CCM_SETNOTIFYWINDOW|CCM_SETWINDOWTHEME|CCM_DPISCALE|HDM_GETITEMCOUNT|HDM_INSERTITEMA|HDM_INSERTITEMW|HDM_DELETEITEM|HDM_GETITEMA|HDM_GETITEMW|HDM_SETITEMA|HDM_SETITEMW|HDM_LAYOUT|HDM_HITTEST|HDM_GETITEMRECT|HDM_SETIMAGELIST|HDM_GETIMAGELIST|HDM_ORDERTOINDEX|HDM_CREATEDRAGIMAGE|HDM_GETORDERARRAY|HDM_SETORDERARRAY|HDM_SETHOTDIVIDER|HDM_SETBITMAPMARGIN|HDM_GETBITMAPMARGIN|HDM_SETUNICODEFORMAT|HDM_GETUNICODEFORMAT|HDM_SETFILTERCHANGETIMEOUT|HDM_EDITFILTER|HDM_CLEARFILTER|TB_ENABLEBUTTON|TB_CHECKBUTTON|TB_PRESSBUTTON|TB_HIDEBUTTON|TB_INDETERMINATE|TB_MARKBUTTON|TB_ISBUTTONENABLED|TB_ISBUTTONCHECKED|TB_ISBUTTONPRESSED|TB_ISBUTTONHIDDEN|TB_ISBUTTONINDETERMINATE|TB_ISBUTTONHIGHLIGHTED|TB_SETSTATE|TB_GETSTATE|TB_ADDBITMAP|TB_ADDBUTTONSA|TB_INSERTBUTTONA|TB_ADDBUTTONS|TB_INSERTBUTTON|TB_DELETEBUTTON|TB_GETBUTTON|TB_BUTTONCOUNT|TB_COMMANDTOINDEX|TB_SAVERESTOREA|TB_SAVERESTOREW|TB_CUSTOMIZE|TB_ADDSTRINGA|TB_ADDSTRINGW|TB_GETITEMRECT|TB_BUTTONSTRUCTSIZE|TB_SETBUTTONSIZE|TB_SETBITMAPSIZE|TB_AUTOSIZE|TB_GETTOOLTIPS|TB_SETTOOLTIPS|TB_SETPARENT|TB_SETROWS|TB_GETROWS|TB_SETCMDID|TB_CHANGEBITMAP|TB_GETBITMAP|TB_GETBUTTONTEXTA|TB_GETBUTTONTEXTW|TB_REPLACEBITMAP|TB_SETINDENT|TB_SETIMAGELIST|TB_GETIMAGELIST|TB_LOADIMAGES|TB_GETRECT|TB_SETHOTIMAGELIST|TB_GETHOTIMAGELIST|TB_SETDISABLEDIMAGELIST|TB_GETDISABLEDIMAGELIST|TB_SETSTYLE|TB_GETSTYLE|TB_GETBUTTONSIZE|TB_SETBUTTONWIDTH|TB_SETMAXTEXTROWS|TB_GETTEXTROWS|TB_GETOBJECT|TB_GETHOTITEM|TB_SETHOTITEM|TB_SETANCHORHIGHLIGHT|TB_GETANCHORHIGHLIGHT|TB_MAPACCELERATORA|TB_GETINSERTMARK|TB_SETINSERTMARK|TB_INSERTMARKHITTEST|TB_MOVEBUTTON|TB_GETMAXSIZE|TB_SETEXTENDEDSTYLE|TB_GETEXTENDEDSTYLE|TB_GETPADDING|TB_SETPADDING|TB_SETINSERTMARKCOLOR|TB_GETINSERTMARKCOLOR|TB_SETCOLORSCHEME|TB_GETCOLORSCHEME|TB_SETUNICODEFORMAT|TB_GETUNICODEFORMAT|TB_MAPACCELERATORW|TB_GETBITMAPFLAGS|TB_GETBUTTONINFOW|TB_SETBUTTONINFOW|TB_GETBUTTONINFOA|TB_SETBUTTONINFOA|TB_INSERTBUTTONW|TB_ADDBUTTONSW|TB_HITTEST|TB_SETDRAWTEXTFLAGS|TB_GETSTRINGW|TB_GETSTRINGA|TB_GETMETRICS|TB_SETMETRICS|TB_SETWINDOWTHEME|RB_INSERTBANDA|RB_DELETEBAND|RB_GETBARINFO|RB_SETBARINFO|RB_GETBANDINFO|RB_SETBANDINFOA|RB_SETPARENT|RB_HITTEST|RB_GETRECT|RB_INSERTBANDW|RB_SETBANDINFOW|RB_GETBANDCOUNT|RB_GETROWCOUNT|RB_GETROWHEIGHT|RB_IDTOINDEX|RB_GETTOOLTIPS|RB_SETTOOLTIPS|RB_SETBKCOLOR|RB_GETBKCOLOR|RB_SETTEXTCOLOR|RB_GETTEXTCOLOR|RB_SIZETORECT|RB_SETCOLORSCHEME|RB_GETCOLORSCHEME|RB_BEGINDRAG|RB_ENDDRAG|RB_DRAGMOVE|RB_GETBARHEIGHT|RB_GETBANDINFOW|RB_GETBANDINFOA|RB_MINIMIZEBAND|RB_MAXIMIZEBAND|RB_GETDROPTARGET|RB_GETBANDBORDERS|RB_SHOWBAND|RB_SETPALETTE|RB_GETPALETTE|RB_MOVEBAND|RB_SETUNICODEFORMAT|RB_GETUNICODEFORMAT|RB_GETBANDMARGINS|RB_SETWINDOWTHEME|RB_PUSHCHEVRON|TTM_ACTIVATE|TTM_SETDELAYTIME|TTM_ADDTOOLA|TTM_ADDTOOLW|TTM_DELTOOLA|TTM_DELTOOLW|TTM_NEWTOOLRECTA|TTM_NEWTOOLRECTW|TTM_RELAYEVENT|TTM_GETTOOLINFOA|TTM_GETTOOLINFOW|TTM_SETTOOLINFOA|TTM_SETTOOLINFOW|TTM_HITTESTA|TTM_HITTESTW|TTM_GETTEXTA|TTM_GETTEXTW|TTM_UPDATETIPTEXTA|TTM_UPDATETIPTEXTW|TTM_GETTOOLCOUNT|TTM_ENUMTOOLSA|TTM_ENUMTOOLSW|TTM_GETCURRENTTOOLA|TTM_GETCURRENTTOOLW|TTM_WINDOWFROMPOINT|TTM_TRACKACTIVATE|TTM_TRACKPOSITION|TTM_SETTIPBKCOLOR|TTM_SETTIPTEXTCOLOR|TTM_GETDELAYTIME|TTM_GETTIPBKCOLOR|TTM_GETTIPTEXTCOLOR|TTM_SETMAXTIPWIDTH|TTM_GETMAXTIPWIDTH|TTM_SETMARGIN|TTM_GETMARGIN|TTM_POP|TTM_UPDATE|TTM_GETBUBBLESIZE|TTM_ADJUSTRECT|TTM_SETTITLEA|TTM_SETTITLEW|TTM_POPUP|TTM_GETTITLE|TTM_SETWINDOWTHEME|SB_SETTEXTA|SB_SETTEXTW|SB_GETTEXTA|SB_GETTEXTW|SB_GETTEXTLENGTHA|SB_GETTEXTLENGTHW|SB_SETPARTS|SB_GETPARTS|SB_GETBORDERS|SB_SETMINHEIGHT|SB_SIMPLE|SB_GETRECT|SB_ISSIMPLE|SB_SETICON|SB_SETTIPTEXTA|SB_SETTIPTEXTW|SB_GETTIPTEXTA|SB_GETTIPTEXTW|SB_GETICON|SB_SETUNICODEFORMAT|SB_GETUNICODEFORMAT|SB_SETBKCOLOR|SB_SIMPLEID|TBM_GETPOS|TBM_GETRANGEMIN|TBM_GETRANGEMAX|TBM_GETTIC|TBM_SETTIC|TBM_SETPOS|TBM_SETRANGE|TBM_SETRANGEMIN|TBM_SETRANGEMAX|TBM_CLEARTICS|TBM_SETSEL|TBM_SETSELSTART|TBM_SETSELEND|TBM_GETPTICS|TBM_GETTICPOS|TBM_GETNUMTICS|TBM_GETSELSTART|TBM_GETSELEND|TBM_CLEARSEL|TBM_SETTICFREQ|TBM_SETPAGESIZE|TBM_GETPAGESIZE|TBM_SETLINESIZE|TBM_GETLINESIZE|TBM_GETTHUMBRECT|TBM_GETCHANNELRECT|TBM_SETTHUMBLENGTH|TBM_GETTHUMBLENGTH|TBM_SETTOOLTIPS|TBM_GETTOOLTIPS|TBM_SETTIPSIDE|TBM_SETBUDDY|TBM_GETBUDDY|TBM_SETUNICODEFORMAT|TBM_GETUNICODEFORMAT|DL_BEGINDRAG|DL_DRAGGING|DL_DROPPED|DL_CANCELDRAG|UDM_SETRANGE|UDM_GETRANGE|UDM_SETPOS|UDM_GETPOS|UDM_SETBUDDY|UDM_GETBUDDY|UDM_SETACCEL|UDM_GETACCEL|UDM_SETBASE|UDM_GETBASE|UDM_SETRANGE32|UDM_GETRANGE32|UDM_SETUNICODEFORMAT|UDM_GETUNICODEFORMAT|UDM_SETPOS32|UDM_GETPOS32|PBM_SETRANGE|PBM_SETPOS|PBM_DELTAPOS|PBM_SETSTEP|PBM_STEPIT|PBM_SETRANGE32|PBM_GETRANGE|PBM_GETPOS|PBM_SETBARCOLOR|PBM_SETBKCOLOR|HKM_SETHOTKEY|HKM_GETHOTKEY|HKM_SETRULES|LVM_SETUNICODEFORMAT|LVM_GETUNICODEFORMAT|LVM_GETBKCOLOR|LVM_SETBKCOLOR|LVM_GETIMAGELIST|LVM_SETIMAGELIST|LVM_GETITEMCOUNT|LVM_GETITEMA|LVM_GETITEMW|LVM_SETITEMA|LVM_SETITEMW|LVM_INSERTITEMA|LVM_INSERTITEMW|LVM_DELETEITEM|LVM_DELETEALLITEMS|LVM_GETCALLBACKMASK|LVM_SETCALLBACKMASK|LVM_FINDITEMA|LVM_FINDITEMW|LVM_GETITEMRECT|LVM_SETITEMPOSITION|LVM_GETITEMPOSITION|LVM_GETSTRINGWIDTHA|LVM_GETSTRINGWIDTHW|LVM_HITTEST|LVM_ENSUREVISIBLE|LVM_SCROLL|LVM_REDRAWITEMS|LVM_ARRANGE|LVM_EDITLABELA|LVM_EDITLABELW|LVM_GETEDITCONTROL|LVM_GETCOLUMNA|LVM_GETCOLUMNW|LVM_SETCOLUMNA|LVM_SETCOLUMNW|LVM_INSERTCOLUMNA|LVM_INSERTCOLUMNW|LVM_DELETECOLUMN|LVM_GETCOLUMNWIDTH|LVM_SETCOLUMNWIDTH|LVM_CREATEDRAGIMAGE|LVM_GETVIEWRECT|LVM_GETTEXTCOLOR|LVM_SETTEXTCOLOR|LVM_GETTEXTBKCOLOR|LVM_SETTEXTBKCOLOR|LVM_GETTOPINDEX|LVM_GETCOUNTPERPAGE|LVM_GETORIGIN|LVM_UPDATE|LVM_SETITEMSTATE|LVM_GETITEMSTATE|LVM_GETITEMTEXTA|LVM_GETITEMTEXTW|LVM_SETITEMTEXTA|LVM_SETITEMTEXTW|LVM_SETITEMCOUNT|LVM_SORTITEMS|LVM_SETITEMPOSITION32|LVM_GETSELECTEDCOUNT|LVM_GETITEMSPACING|LVM_GETISEARCHSTRINGA|LVM_GETISEARCHSTRINGW|LVM_SETICONSPACING|LVM_SETEXTENDEDLISTVIEWSTYLE|LVM_GETEXTENDEDLISTVIEWSTYLE|LVM_GETSUBITEMRECT|LVM_SUBITEMHITTEST|LVM_SETCOLUMNORDERARRAY|LVM_GETCOLUMNORDERARRAY|LVM_SETHOTITEM|LVM_GETHOTITEM|LVM_SETHOTCURSOR|LVM_GETHOTCURSOR|LVM_APPROXIMATEVIEWRECT|LVM_SETWORKAREAS|LVM_GETWORKAREAS|LVM_GETNUMBEROFWORKAREAS|LVM_GETSELECTIONMARK|LVM_SETSELECTIONMARK|LVM_SETHOVERTIME|LVM_GETHOVERTIME|LVM_SETTOOLTIPS|LVM_GETTOOLTIPS|LVM_SORTITEMSEX|LVM_SETBKIMAGEA|LVM_SETBKIMAGEW|LVM_GETBKIMAGEA
Gui, Add, Text, x315 y140 w60 h20 +Center, wParam
Gui, Add, Edit, x315 y160 w60 h20 vwParam
Gui, Add, Text, x385 y140 w60 h20 +Center, lParam
Gui, Add, Edit, x385 y160 w60 h20 vlParam
Gui, Show, Center w460 h199, AHK Messenger
SetTimer, Notify, 500
Return

Notify:
MouseGetPos,,,CurrWin,CurrCon
If (CurrWin=UIDSelf && CurrCon="Edit4" || CurrCon="Edit5")
  ToolTip, Put just '&' to get return value
Else
  ToolTip
Return

GuiClose:
ExitApp

AutoComplete:
AutoComplete(A_GuiControl)
Return

Bang:
Gui, Submit, NoHide
;--------------------------------TitleMatchMode
  If TitleMatchMode=Exact Match(3)
    SetTitleMatchMode, 3
  Else If TitleMatchMode=Partial Match(2)
    SetTitleMatchMode, 2
  Else If TitleMatchMode=Start With(1)
    SetTitleMatchMode, 1
  Else If TitleMatchMode=Regular Expression
    SetTitleMatchMode, RegEx
;--------------------------------DetectHidden
DetectHiddenWindows, % (DetectHidden=1 ? "On" : "Off")
;--------------------------------Method
ControlGet, MsgList,List,,ComboBox3,AHK Messenger
;--------------------------------Send
If Method=PostMessage
{
  IfInString, MsgList, %Message%
    PostMessage, Msg(Message), %wParam%, %lParam%, %Control%, %WindowTitle%
  Else
    PostMessage, %Message%, %wParam%, %lParam%, %Control%, %WindowTitle%
}
Else If Method=SendMessage
{
  If wParam=&
  {
    VarSetCapacity(Output, 55)
    IfInString, MsgList, %Message%
      SendMessage, Msg(Message), &Output, %lParam%, %Control%, %WindowTitle%
    Else
      SendMessage, %Message%, &Output, %lParam%, %Control%, %WindowTitle%
  }
  Else If lParam=&
  {
    VarSetCapacity(Output, 55)
    IfInString, MsgList, %Message%
      SendMessage, Msg(Message), %wParam%, &Output, %Control%, %WindowTitle%
    Else
      SendMessage, %Message%, %wParam%, &Output, %Control%, %WindowTitle%
  }
  Else
  {
  IfInString, MsgList, %Message%
    SendMessage, Msg(Message), %wParam%,%lParam%,%Control%,%WindowTitle%
  Else
    SendMessage, %Message%, %wParam%,%lParam%,%Control%,%WindowTitle%
  }
}
;--------------------------------Display
SetTimer, Notify, Off
If Output
  ToolTip % "Return : " Output "`nErrorlevel : " Errorlevel
Else
  ToolTip % "Errorlevel : " Errorlevel
SetTimer, ToolTipOff, 1500
Sleep, 1000
SetTimer, Notify, On
IfInString,MsgList, %Message%
{
  Msgout:=Msg(Message)
  ClipBoard=%Method%,%MsgOut%,%wParam%,%lParam%,%Control%,%WindowTitle%
}
Else
  ClipBoard=%Method%,%Message%,%wParam%,%lParam%,%Control%,%WindowTitle%
return

~MButton::
MouseGetPos,,,UID,Control
WinGetClass, Win,ahk_id %UID%
IfInString, Win, 32770
{
  WinGetTitle, Win, ahk_id %UID%
  ControlSetText, Edit1,%Win%,AHK Messenger
}
Else
  ControlSetText, Edit1,ahk_class %Win%,AHK Messenger
ControlSetText, Edit2,%Control%,AHK Messenger
Return

ToolTipOff:
ToolTip
SetTimer, ToolTipOff, Off
Return

;autocomplete function for combobox by Titan
AutoComplete(ctrl) {
   static lf = "`n"
   If GetKeyState("Delete") or GetKeyState("Backspace")
      Return
   SetControlDelay, -1
   SetWinDelay, -1
   GuiControlGet, h, Hwnd, %ctrl%
   ControlGet, haystack, List, , , ahk_id %h%
   GuiControlGet, needle, , %ctrl%
   StringMid, text, haystack, pos := InStr(lf . haystack, lf . needle)
      , InStr(haystack . lf, lf, false, pos) - pos
   If text !=
   {
      if pos != 0
      {
        ControlSetText, , %text%, ahk_id %h%
        ControlSend, , % "{Right " . StrLen(needle) . "}+^{End}", ahk_id %h%
      }
   }
}
