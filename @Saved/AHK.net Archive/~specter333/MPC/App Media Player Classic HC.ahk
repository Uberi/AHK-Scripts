; Media Player Classic HC V2.0
; Requires both MediaPlayerClassicHC and MPCHTTP function libraries.


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SplitPath, A_ScriptDir, , OutDir,
;SetWorkingDir %OutDir%
SetWorkingDir %A_ScriptDir%
#NoTrayIcon
#SingleInstance Force

;WinGetPos, posx, posy, , , EasyAutoEdit AHK,
;showx := posx+402
;showy := posy+290
Gui, Font, s14 , Verdana Bold Italic
Gui, Add, Text, x5 y5, Media Player Classic HC
Gui, Font, s8 , Arial
Gui, Add, Button, x330 y5 w20 h20 Disabled ghelp, ?
Gui, Add, Button, x355 y5 w20 h20 gExit, X

MediaPlayerClassicHC(000)
MPCHTTP("","",000)

Gui, Add, Tab2, x1 y35 w378 h245 vmpctabs, Send|HTTP|Single Commands|Command List

Gui, Tab, 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Gui, Font, cBlack
Gui, Add, DDL, xm y65 w225 vT1mpccontrol gT1mpccontrol, 
(Join
|PlayPause|Play|Stop|Pause|FullScreen|VolumeUp|VolumeDown|Mute|JumpForward|JumpBackward|
PlayFaster|PlaySlower|PlayNormal|RootMenu|Exit
)
Gui, Add, Button, x+5 w50 h22 Disabled vT1mpcfilesave gT1mpcfilesave, <--Use
Gui, Font, cWhite
Gui, Add, Edit, xm y100 w225 r1 ReadOnly vT1mpccmd,
Gui, Font, cBlack
Gui, Add, Button, x+5 w50 h22 gT1mpctest, Test

Gui, Add,  Text, x10 y130 w360, ; Home page, http://mpc-hc.sourceforge.net/
(Join
Use Send functions to control Media Player Classic Home Cinema`nwith out it being active.
  It reacts quicker than the HTTP function and no extra setup is require.`n`n
Choose a function from the drop down list.  Click "Test" to try it out or "Use" to
 send it to the main EasyAutoEdit window.
)

Gui, Tab, 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Gui, Font, cBlack
Gui, Add, ComboBox, xm y75 w100 vmpcip gmpccontrol, LocalHost||%A_IPAddress1%|%A_IPAddress2%|%A_IPAddress3%|%A_IPAddress4%
Gui, Add, Edit, x+5 w50 r1 vmpcport gmpccontrol, 13579
Gui, Add, DDL, x+5 w125 vmpccontrol gmpccontrol, 
(Join
|PlayPause|Play|Stop|Pause|FullScreen|VolumeUp|VolumeDown|Mute|JumpForward|JumpBackward|
PlayFaster|PlaySlower|PlayNormal|RootMenu|Exit
)
Gui, Add, GroupBox, x10 y60 w300 h40, IP  ---------------------  Port  ------  Cmd
Gui, Add, Button, x+5 y75 w55 h22 Disabled vmpcfilesave gmpcfilesave, <--Use
Gui, Font, cWhite
Gui, Add, Edit, x10 y105 w300 r1 ReadOnly vmpccmd,
Gui, Font, cBlack
Gui, Add, Button, x+5 w55 h22 gmpctest, Test

Gui, Add,  Text, x10 y130 w360, ; Home page, http://mpc-hc.sourceforge.net/
(Join
Use HTTP functions to control Media Player Classic Home Cinema`nover a network connection with
 the MPCHTTP function library.
`n`n
Enter the IP address and Port number of the host computer and choose a function from the drop down list.
 Click "Test" to try the command or "Use" to send it to the main EasyAutoEdit window.
`n`n
To enable the HTTP interface, click View/Options, then in the Player`nmenu chose Web Interface.
Check "Listen on port:", port number is 13579.
)

Gui, Tab, 3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Gui, Add,  Radio, x10 y65 Checked vusesend gTab3Box, Send
Gui, Add,  Radio, x10 y80 vusehttp gTab3Box, HTTP

Gui, Add, ComboBox, x75 y75 w100 Disabled vt3mpcip gTab3Box, LocalHost||%A_IPAddress1%|%A_IPAddress2%|%A_IPAddress3%|%A_IPAddress4%
Gui, Add, Edit, x+10 w50 r1 Disabled vt3mpcport gTab3Box, 13579
Gui, Add, Edit, x+10 w55 r1 vcmdnum gTab3Box,
Gui, Add, GroupBox, x65 y60 w245 h40, IP  -----------------------  Port  -------  Cmd #
Gui, Add, Button, x+5 y75 Disabled w55 gT3Send, <--Use
Gui, Font, cWhite
Gui, Add, Edit, x10 y105 w300 r1 ReadOnly vt3cmd,
Gui, Font, cBlack
Gui, Add, Button, x+5 w55 gT3Test, Test
Gui, Font, cWhite
Gui, Add, Edit, x10 y132 w300 r1 ReadOnly vt3type,
Gui, Font, cBlack

Gui, Add, Text, x10 y155 h50 w360, 
(Join
The next tab contains a complete list of Media Player Classic's commands
 that may be used with either the Send or HTTP functions.
 )
Gui, Font, s10 
Gui, Add, Text, x10 y187 w360, Double click any command to transfer it to this page.  
Gui, Font, s8
Gui, Add,  Text, x10 y210 w360, 
(Join
Choose "Send" or "HTTP".`n
%A_Tab%If Send, enter the command number.`n 
%A_Tab%If HTTP, enter the IP, Port and command number.

)
Gui, Add, Text, x10 y260 w360, Some commands require extra parameters and will not work here.

Gui, Tab, 4 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Gui, Font, cWhite
Gui, Font, cBlack
;Gui, Add, Edit, x10 y65 w360 r14 ReadOnly, %cmdlist%
Gui, Add, ListView, x10 y65 w360 r12 Grid Count138 gT4LV, |Cmd #|Function

;Gui, -Caption +ToolWindow 
Gui, Show, h280 w380, App Media Player Classic HC
GoSub getcmdlist
Gui, Submit, NoHide
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   Tab 1   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
T1mpctest:
MediaPlayerClassicHC_%T1mpccontrol%()
Return

T1mpccontrol:
Gui, Submit, NoHide
GuiControl, , T1mpccmd, MediaPlayerClassicHC_%T1mpccontrol%()
Return

T1mpcfilesave:
Gui, Submit, NoHide
If T1mpccontrol =
	Return
T1mpcmsg = MediaPlayerClassicHC_%T1mpccontrol%() 
SendMessage, 0xC, 0, "CMD", Edit2, EasyAutoEdit AHK 
SendMessage, 0xC, 0, &T1mpcmsg, Edit3, EasyAutoEdit AHK 
SendMessage, 0xC, 0, "Yes", Edit5, EasyAutoEdit AHK 
Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   Tab 2   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mpctest:
Gui, Submit, NoHide
Host = %mpcip%
Port = %mpcport%
MPCHTTP_%mpccontrol%(Host,Port)
Return

mpccontrol:
Gui, Submit, NoHide
Host = %mpcip%
Port = %mpcport%
GuiControl, , mpccmd, MPCHTTP_%mpccontrol%("%Host%",%Port%)
Return

mpcfilesave:
Gui, Submit, NoHide
If mpccontrol =
	Return
mpcmsg = MPCHTTP_%mpccontrol%("%Host%",%Port%) 
SendMessage, 0xC, 0, "CMD", Edit2, EasyAutoEdit AHK 
SendMessage, 0xC, 0, &mpcmsg, Edit3, EasyAutoEdit AHK 
SendMessage, 0xC, 0, "Yes", Edit5, EasyAutoEdit AHK 
Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   Tab 3   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Tab3Box:
Gui, Submit, NoHide
If usesend = 1
	{
	GuiControl, Disable, t3mpcip,
	GuiControl, Disable, t3mpcport,
	precmd = MediaPlayerClassicHC(
	}
If usehttp = 1
	{
	GuiControl, Enable, t3mpcip,
	GuiControl, Enable, t3mpcport,
	precmd = MPCHTTP("%t3mpcip%",%t3mpcport%,
	}
GuiControl, , t3cmd, %precmd%%cmdnum%)
Return

T3Test:
If cmdnum = 
	Return
If usesend = 1
	MediaPlayerClassicHC(cmdnum)
If usehttp = 1
	{
	Host = %mpcip%
	Port = %mpcport%
	MPCHTTP(Host,Port,cmdnum)
	}
Return

T3Send:
Gui, Submit, NoHide
If t3cmd =
	Return
mpcmsg = %t3cmd%
SendMessage, 0xC, 0, "CMD", Edit2, EasyAutoEdit AHK 
SendMessage, 0xC, 0, &mpcmsg, Edit3, EasyAutoEdit AHK 
SendMessage, 0xC, 0, "Yes", Edit5, EasyAutoEdit AHK 
Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   Tab 4   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

T4LV:
if A_GuiEvent = DoubleClick  ; There are many other possible values the script can check.
{
    LV_GetText(mpccmdnun, A_EventInfo, 2) 
    LV_GetText(mpccmdtype, A_EventInfo, 3)  
    GuiControl, , cmdnum, %mpccmdnun%
	GuiControl, , t3type, %mpccmdtype%
	GuiControl, Choose, mpctabs, 3
}
return


getcmdlist:
cmdlist = 
(Join
800 ^ Open File@
801 ^ Open DVD@
802 ^ Open Device@
805 ^ Save As@
806 ^ Save Image@
807 ^ Save Image (auto)@
809 ^ Load Subtitle@
810 ^ Save Subtitle@
804 ^ Close@
814 ^ Properties@
816 ^ Exit@
889 ^ Play/Pause@
887 ^ Play@
888 ^ Pause@
890 ^ Stop@
891 ^ Framestep@
892 ^ Framestep back@
893 ^ Go To@
895 ^ Increase Rate@
894 ^ Decrease Rate@
896 ^ Reset Rate@
905 ^ Audio Delay +10ms@
906 ^ Audio Delay -10ms@
900 ^ Jump Forward (small)@
899 ^ Jump Backward (small)@
902 ^ Jump Forward (medium)@
901 ^ Jump Backward (medium)@
904 ^ Jump Forward (large)@
903 ^ Jump Backward (large)@
898 ^ Jump Forward (keyframe)@
897 ^ Jump Backward (keyframe)@
921 ^ Next@
920 ^ Previous@
919 ^ Next Playlist Item@
918 ^ Previous Playlist Item@
817 ^ Toggle Caption&Menu@
818 ^ Toggle Seeker@
819 ^ Toggle Controls@
820 ^ Toggle Information@
821 ^ Toggle Statistics@
822 ^ Toggle Status@
823 ^ Toggle Subresync Bar@
824 ^ Toggle Playlist Bar@
825 ^ Toggle Capture Bar@
826 ^ Toggle Shader Editor Bar@
827 ^ View Minimal@
828 ^ View Compact@
829 ^ View Normal@
830 ^ Fullscreen@
831 ^ Fullscreen (w/o res.change)@
832 ^ Zoom 50`%@
833 ^ Zoom 100`%@
834 ^ Zoom 200`%@
967 ^ Zoom Auto Fit@
860 ^ Next AR Preset@
835 ^ VidFrm Half@
836 ^ VidFrm Normal@
837 ^ VidFrm Double@
838 ^ VidFrm Stretch@
839 ^ VidFrm Inside@
840 ^ VidFrm Outside@
884 ^ Always On Top@
861 ^ PnS Reset@
862 ^ PnS Inc Size@
864 ^ PnS Inc Width@
866 ^ PnS Inc Height@
863 ^ PnS Dec Size@
865 ^ PnS Dec Width@
867 ^ PnS Dec Height@
876 ^ PnS Center@
868 ^ PnS Left@
869 ^ PnS Right@
870 ^ PnS Up@
871 ^ PnS Down@
872 ^ PnS Up/Left@
873 ^ PnS Up/Right@
874 ^ PnS Down/Left@
875 ^ PnS Down/Right@
877 ^ PnS Rotate X+@
878 ^ PnS Rotate X-@
879 ^ PnS Rotate Y+@
880 ^ PnS Rotate Y-@
881 ^ PnS Rotate Z+@
882 ^ PnS Rotate Z-@
907 ^ Volume Up@
908 ^ Volume Down@
909 ^ Volume Mute@
969 ^ Volume boost increase@
970 ^ Volume boost decrease@
971 ^ Volume boost Min@
972 ^ Volume boost Max@
922 ^ DVD Title Menu@
923 ^ DVD Root Menu@
924 ^ DVD Subtitle Menu@
925 ^ DVD Audio Menu@
926 ^ DVD Angle Menu@
927 ^ DVD Chapter Menu@
928 ^ DVD Menu Left@
929 ^ DVD Menu Right@
930 ^ DVD Menu Up@
931 ^ DVD Menu Down@
932 ^ DVD Menu Activate@
933 ^ DVD Menu Back@
934 ^ DVD Menu Leave@
943 ^ Boss key@
948 ^ Player Menu (short)@
949 ^ Player Menu (long)@
950 ^ Filters Menu@
886 ^ Options@
951 ^ Next Audio@
952 ^ Prev Audio@
953 ^ Next Subtitle@
954 ^ Prev Subtitle@
955 ^ On/Off Subtitle@
2302 ^ Reload Subtitles@
956 ^ Next Audio (OGM)@
957 ^ Prev Audio (OGM)@
958 ^ Next Subtitle (OGM)@
959 ^ Prev Subtitle (OGM)@
960 ^ Next Angle (DVD)@
961 ^ Prev Angle (DVD)@
962 ^ Next Audio (DVD)@
963 ^ Prev Audio (DVD)@
964 ^ Next Subtitle (DVD)@
965 ^ Prev Subtitle (DVD)@
966 ^ On/Off Subtitle (DVD)@
32769 ^ Tearing Test@
32778 ^ Remaining Time@
32770 ^ Toggle Pixel Shader@
32779 ^ Toggle Direct3D fullscreen@
32780 ^ Goto Prev Subtitle@
32781 ^ Goto Next Subtitle@
32782 ^ Shift Subtitle Left@
32783 ^ Shift Subtitle Right@
32784 ^ Display Stats@
24000 ^ Subtitle Delay -@
24001 ^ Subtitle Delay +@
808 ^ Save thumbnails
)

Loop, Parse, cmdlist, @
	{
	StringSplit, Col_, A_LoopField, ^
	LV_Add(Col1 , A_Index, Col_1,Col_2)
	}
LV_ModifyCol(1, "Integer")
LV_ModifyCol(2, "Integer")
LV_ModifyCol(1, 30)
Return

help:
Run, AutoHotkey.exe "Help\Easy Automation AHK Help.ahk" "" "" "%A_ScriptName%"
Return

Exit:
GuiClose:
Gui, Destroy
ExitApp