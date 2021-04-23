;///////////////////////////////////////////////////////
; Script created by GAHKS (2009) http://www.autohotkey.net/~gahks/
; http://www.autohotkey.com/forum/topic41466.html
; Subtitle framerate changer v 1.1
; It can: set the delay / change the framerate of Subrip (.srt) subtitles
;///////////////////////////////////////////////////////
;///////////////////
;COMMAND LINE SWITCHES
v_0 = %0%
v_1 = %1%
v_2 = %2%
v_3 = %3%
v_4 = %4%
v_5 = %5%
v_6 = %6%
v_7 = %7%
;If there are command line parameters, run the converter without the gui and exit
If 0 = 5
{
	If 1 = 0 
		SrtSynch(v_1, v_2, v_3, v_4, v_5, 0, 0)
	Else If 1 = 1
		SrtSynch(v_1, v_2, v_3, 0, 0, v_4, v_5)
	ExitApp
}
Else If 0 = 7
{
	SrtSynch(v_1, v_2, v_3, v_4, v_5, v_6, v_7)
	ExitApp
}
;///////////////////
; INCLUDES VARS AND OPTIONS
script_name = Subtitle framerate changer
SetTitleMatchMode, 3
dragdropmode_active = 0
about_exists = 0
help_exists = 0
;///////////////////
; TRAY MENU
Menu, tray, NoStandard
Menu, TrayFileMenu, add, &Select a single file, InputBrowse
Menu, TrayFileMenu, add, Select &multiple files, Input2Browse
Menu, tray, add, &File, :TrayFileMenu
Menu, tray, add,
Menu, tray, add, &Drag and drop mode, DragDrop
Menu, TrayHelpMenu, add, &Help, Help
Menu, TrayHelpMenu, add, &About, About
Menu, tray, add, &Help, :TrayHelpMenu
Menu, tray, add,
Menu, tray, add, E&xit, Ex
;///////////////////
; GUI
Menu, FileMenu, add, &Select a single file, InputBrowse
Menu, FileMenu, add, Select &multiple files, Input2Browse
Menu, FileMenu, add, 
Menu, FileMenu, add, E&xit, Ex 
Menu, GuiMenuBar, add, &File, :FileMenu
Menu, DragDropMenu, add, A&ctivate, DragDrop
Menu, GuiMenuBar, add, &Drag and Drop, :DragDropMenu
Menu, HelpMenu, add, &Help, Help
Menu, HelpMenu, add, &About, About 
Menu, GuiMenuBar, add, &Help, :HelpMenu 
;TABS, FIRST TAB
Gui, Add, Tab2, w330 h430 vGuiTab, &Single file|&Multiple Files
Gui, Add, Text, x+10 y+10, Select an input file
Gui, Add, Edit, vinput_b_input xp+10 yp+20 w240 h20,
Gui, Add, Button, gInputBrowse vbutton_b_input xp+240 yp+0 w50 h20, &Browse
GuiControl, Focus, button_b_input
Gui, Add, Text, xp-250 y+10, Select an output folder
Gui, Add, Edit, vinput_b_output xp+10 yp+20 w240 h20,
Gui, Add, Button, gOutputBrowse vbutton_b_output xp+240 yp+0 w50 h20, B&rowse 
Gui, Add, Radio, xp-250 yp+40 vRadioFps gOptionsChangeFramerate, Change framerate
Gui, Add, Radio, xp+0 yp+85 vRadioDelay gOptionsSetDelay, Set delay
GuiControl,, RadioFPS, 1
Gui, Add, Text, xp+10 yp-60, Choose Input FPS:
Gui, Add, ComboBox, vinput_fps_input xp+105 yp-5 w60, 30.000|29.970|25.000||24.000|23.990|23.978|23.976|20.000|15.000|12.000
Gui, Add, Text, xp-105 yp+30, Choose Output FPS:
Gui, Add, ComboBox, vinput_fps_output xp+105 yp-5 w60, 30.000|29.970|25.000||24.000|23.990|23.978|23.976|20.000|15.000|12.000
Gui, Add, Text, xp-105 yp+65, Set delay:
Gui, Add, DDL, xp+60 yp-5 w35 vinput_delay_ispos, +||-
Gui, Add, Edit, xp+40 yp+0 w40 vinput_delay_time, 1000
Gui, Add, Text, xp+45 yp+5, ms
Gui, Add, Button, gConvert vbutton_ok xp-145 yp+50 w70 h20, Conver&t
Gui, Add, Button, gEx vbutton_cancel xp+90 yp+0 w70 h20, Cance&l
;TABS, 2ND TAB
Gui, Tab, 2
Gui, Add, Text, x+10 y+10, Select input files (All files must be the same FPS)
Gui, Add, Button, gInput2Browse vbutton2_b_input xp+250 yp+0 w50 h20, Browse
Gui, Add, Edit, vinput2_b_input xp-240 yp+30 w290 h150 -Wrap Multi,
GuiControl, Focus, button2_b_input
Gui, Add, Text, xp-10 yp+170, Select an output folder
Gui, Add, Edit, vinput2_b_output xp+10 yp+20 w240 h20,
Gui, Add, Button, gOutput2Browse vbutton2_b_output xp+240 yp+0 w50 h20, Browse 
Gui, Add, ComboBox, vinput2_fps_input xp-240 y+30 w100, 30.000|29.970|25.000||24.000|23.990|23.978|23.976|20.000|15.000|12.000
Gui, Add, Text, xp+110 yp+0, Choose Input FPS
Gui, Add, ComboBox, vinput2_fps_output xp-110 yp+30 w100, 30.000|29.970|25.000||24.000|23.990|23.978|23.976|20.000|15.000|12.000
Gui, Add, Text, xp+110 yp+0, Choose Output FPS
Gui, Add, Button, gConvert2 vbutton2_ok xp-110 yp+50 w70 h20, Convert
Gui, Add, Button, gEx vbutton2_cancel xp+90 yp+0 w70 h20, Cancel
;SHOW MENU, SHOW GUI
Gui, Menu, GuiMenuBar 
Gui, Show, w350 h450, %script_name%
Gosub, OptionsChangeFramerate ; set changing framerate as default
return

;ON DRAG AND DROP EVENT
GuiDropFiles:
Gui +OwnDialogs 
If dropped_file_list <> 
{
	MsgBox, 35, Warning!, The list isn't blank. Should I add the files to the list?`n`nAdd the files to the list (Press YES)`nReplace the files on the list with the new ones (Press NO)`nNeither one / I don't know (Press CANCEL)
	IfMsgBox, Cancel
	 return
	IfMsgBox, No
	 dropped_file_list = 
}
Loop, parse, A_GuiEvent, `n
{
	dropped_file_list = %dropped_file_list%%A_LoopField%`n
}
GuiControl, Choose, GuiTab, 2
GuiControl,, input2_b_input, %dropped_file_list%
return

;GUI-> ABOUT
About:
If about_exists = 1 
	WinActivate, About %script_name%
Else
{
about_exists = 1
Gui, 1:+Disabled
Gui, 3:Destroy
help_exists = 0
Gui, 2:+owner1
Gui, 2:Add, Text,xp+10 yp+10, (2009) Subtitle framerate changer v1.1
Gui, 2:Add, Text, xp+0 yp+30, Created by GAHKS in AutoHotKey scripting language
Gui, 2:Add, Text, cBlue g2LaunchGahks, http://www.autohotkey.net/~gahks/
Gui, 2:Add, Button, g2CloseAbout vbutton3_cancel x+50 yp+80 w70 h20, Cancel
Gui, 2:Show, w330 h200, About %script_name%
GuiControl, 2:Focus, button3_cancel
}
return

2CloseAbout:
2GuiClose:
Gui, 1:-Disabled
Gui, 2:Destroy
about_exists = 0
return

2LaunchGahks:
Run, http://www.autohotkey.net/~gahks/
return

;GUI-> HELP
Help:
If help_exists = 1 
	WinActivate, %script_name% Help
Else
{
help_exists = 1
Gui, 1:+Disabled
Gui, 2:Destroy
about_exists = 0
Gui, 3:+owner1
Gui, 3:Add, Text,xp+10 yp+10 w300, Single file mode:`nSelect the subtitle file you want to convert.`nThe file format must be .srt!`nSelect a folder: the program will put the converted subtitles here.`nSet the framerate - FPS - of the input sub. and the framerate of the movie to which you want to adjust your subtitle file.`nIf you don't select an output folder, the program will put the converted subtitle files here: [Input_subtitle_files_folder]\converted_subtitles.
Gui, 3:Add, Text,xp+0 yp+140 w300, Multiple files mode:`nSame as above, only here  you can select and convert multiple subtitle files at once. You can Drag'N'Drop srt files to the list.
Gui, 3:Add, Text,xp+0 yp+50 w300, File menu, Drag and drop mode:`nIf you activate this option, the windows will be always on top, until you deactivate it.
Gui, 3:Add, Text,xp+0 yp+50 w300, More about subtitles and framerates:
Gui, 3:Add, Text,yp+15 cBlue g3LaunchSubinfo, http://www.doom9.org/sub.htm
Gui, 3:Add, Button, g3CloseHelp vbutton4_cancel x+50 yp+70 w70 h20, Cancel
Gui, 3:Show, w330 h380, %script_name% Help
GuiControl, 3:Focus, button4_cancel
}
return

3CloseHelp:
3GuiClose:
Gui, 1:-Disabled
Gui, 3:Destroy
help_exists = 0
return

3LaunchSubinfo:
Run, http://www.doom9.org/sub.htm
return

;DRAG AND DROP ACTIVATE/DEACTIVATE
DragDrop:
If dragdropmode_active = 0
{
dragdropmode_active = 1
Menu, DragDropMenu, Check, A&ctivate
Menu, Tray, Check, &Drag and drop mode
WinSet, AlwaysOnTop, On, %script_name%
GuiControl, Choose, GuiTab, 2
}
Else
{
dragdropmode_active = 0
Menu, DragDropMenu, Uncheck, A&ctivate
Menu, Tray, Uncheck, &Drag and drop mode
WinSet, AlwaysOnTop, Off, %script_name%
}
return
;/////////////////////////
; MAINGUI FUNCTIONS	
; SINGLE FILE TAB FUNCTIONS
;/////////////////////////
OptionsSetDelay:
GuiControl, Disable, input_fps_input
GuiControl, Disable, input_fps_output
GuiControl, Enable, input_delay_ispos
GuiControl, Enable, input_delay_time
return

OptionsChangeFramerate:
GuiControl, Disable, input_delay_ispos
GuiControl, Disable, input_delay_time
GuiControl, Enable, input_fps_input
GuiControl, Enable, input_fps_output
return

InputBrowse:
Gui +OwnDialogs 
WinSet, AlwaysOnTop, Off
FileSelectFile, dialog_b_input, 3, %A_Desktop%, Select input subtitle file..., Subtitle files (*.srt)
If dialog_b_input = 
	Return
GuiControl,, input_b_input, %dialog_b_input% 
If dialog_b_input <> 
	GuiControl, Focus, button_b_output
WinActivate, %script_name%
If dragdropmode_active = 1
	WinSet, AlwaysOnTop, On
GuiControl, Choose, GuiTab, 1
return ;END InputBrowse

OutPutBrowse:
Gui +OwnDialogs 
WinSet, AlwaysOnTop, Off
FileSelectFolder, dialog_b_output,, 1, Select output folder...
If dialog_b_output = 
	Return
GuiControl,, input_b_output, %dialog_b_output% 
GuiControlGet, read_input_b_input,, input_b_input 
GuiControlGet, read_input_b_output,, input_b_output 
If read_input_b_input = 
	GuiControl, Focus, button_b_input
Else If read_input_b_output = 
	GuiControl, Focus, button_b_output	
Else
	GuiControl, Focus, input_fps_input
WinActivate, %script_name%
If dragdropmode_active = 1
	WinSet, AlwaysOnTop, On
GuiControl, Choose, GuiTab, 1
return ;END OutPutBrowse

Convert:
Gui +OwnDialogs 
WinSet, AlwaysOnTop, Off, %script_name%
GuiControlGet, convert_file_input,, input_b_input 
GuiControlGet, convert_file_output,, input_b_output 
GuiControlGet, convert_fps_input,, input_fps_input
GuiControlGet, convert_fps_output,, input_fps_output
GuiControlGet, convert_delay_ispos,, input_delay_ispos
GuiControlGet, convert_delay_time,, input_delay_time
GuiControlGet, convert_RadioDelay,, RadioDelay
GuiControlGet, convert_RadioFps,, RadioFPS
StringReplace, convert_fps_input, convert_fps_input, ., 
StringReplace, convert_fps_output, convert_fps_output, ., 
If convert_delay_ispos = +
	convert_delay_ispos = 1
Else
	convert_delay_ispos = 0
If convert_file_input =
{
	MsgBox, 48, Cannot proceed, Select a subtitle file (.srt) to convert and an output folder!
	Return
}
StringSplit, substrings_inputpath, convert_file_input, \
substrings_inputpath_last = %substrings_inputpath0%
output_filename := substrings_inputpath%substrings_inputpath_last%
nr_of_loops := substrings_inputpath_last
convert_file_out = 
Loop
{
	If a_index >= %nr_of_loops%
		break
		convert_file_out := convert_file_out "\" substrings_inputpath%a_index%
}
StringTrimLeft, convert_file_out_trimmed, convert_file_out, 1
If convert_file_output =
{
	convert_file_output = %convert_file_out_trimmed%\converted_subtitles
	FileCreateDir, %convert_file_output%
}
Else If convert_file_output = %convert_file_out_trimmed%
{
	MsgBox, 52, Warning!, The input folder and the output folder is the same. This way the selected subtitle file will be overwritten.`nDo you proceed?
	IfMsgBox, No
	{
		convert_file_output = %convert_file_out_trimmed%\converted_subtitles
		MsgBox, 64, Output folder changed, The subtitle file will be converted to this folder:`n%convert_file_output%
		FileCreateDir, %convert_file_output%
	}
}
convert_filepath_output := convert_file_output "\" output_filename
Gui, 1:+Disabled
Menu, Tray, Disable, &File
Menu, Tray, Disable, &Help
Menu, Tray, Disable, &Drag and drop mode
WinGetPos, X,Y, Width,, %script_name%
Gui, 4:+owner1
Gui, 4:-0xC00000
Gui, 4:+0x800000
Gui, 4:Font, s12,
Gui, 4:Add,Text,x+80 y+50,Conversion in progress...
Gui, 4:Show, x%X% y%Y% w%Width% h130,Conversion in progress... 
WinSet, AlwaysOnTop, Off,,Conversion in progress...
WinMove,,Conversion in progress..., %X%, Y+140, 
WinActivate,, Conversion in progress...
If convert_RadioDelay = 1 
	SrtSynch(0, convert_file_input, convert_filepath_output, convert_delay_time, convert_delay_ispos, 0, 0)
Else If convert_RadioFps = 1
	SrtSynch(1, convert_file_input, convert_filepath_output, 0, 0, convert_fps_input, convert_fps_output)
Gui, 4:Destroy
Gui, 1:-Disabled
Menu, Tray, Enable, &File
Menu, Tray, Enable, &Help
Menu, Tray, Enable, &Drag and drop mode
MsgBox, 68, Done!, Conversion done. Your converted file is in:`n%convert_file_output%`nWould you like to open the folder now?
IfMsgBox, Yes
	Run, explorer.exe %convert_file_output%
WinActivate, %script_name%
If dragdropmode_active = 1
	WinSet, AlwaysOnTop, On, %script_name%
return ;END Convert
;/////////////////////////
; MAINGUI FUNCTIONS	
; MULTIPLE FILES TAB FUNCTIONS
;/////////////////////////
Input2Browse:
Gui +OwnDialogs 
WinSet, AlwaysOnTop, Off
FileSelectFile, dialog2_b_input, M3, %A_Desktop%, Selext two or more subtitle files..., Subtitle files (*.srt)
If dialog2_b_input = 
	Return
GuiControlGet, i2_b_i_blank,, input2_b_input
add_to_list = 
If i2_b_i_blank <> 
{
	MsgBox, 35, Warning!, The list isn't blank. Should I add the files to the list?`n`nAdd the files to the list (Press YES)`nReplace the files on the list with the new ones (Press NO)`nNeither one / I don't know (Press CANCEL)
	IfMsgBox, Cancel
	 return
	IfMsgBox, Yes
	 add_to_list = yes
}
fullpath = 
Loop, parse, dialog2_b_input, `n
{
	If a_index = 0
	{
		dialog2_b_input_substrings_nr = %A_LoopField%
		Continue
	}
	Else If a_index = 1
	{
		dialog2_b_input_folder = %A_LoopField%
		Continue
	}
	fullpath = %fullpath%%dialog2_b_input_folder%\%A_LoopField%`n
}
If add_to_list = yes
	fullpath = %i2_b_i_blank%%fullpath%
GuiControl,, input2_b_input, %fullpath% 
GuiControl, Focus, button2_b_output
WinActivate, %script_name%
If dragdropmode_active = 1
	WinSet, AlwaysOnTop, On
GuiControl, Choose, GuiTab, 2
return ;END Input2Browse

Output2Browse:
Gui +OwnDialogs 
WinSet, AlwaysOnTop, Off
FileSelectFolder, dialog2_b_output,, 1, Select output folder...
If dialog2_b_output = 
	Return
GuiControl,, input2_b_output, %dialog2_b_output% 
GuiControlGet, read_input2_b_input,, input2_b_input
GuiControlGet, read_input2_b_output,, input2_b_output 
If read_input2_b_input = 
	GuiControl, Focus, button2_b_input
Else If read_input2_b_output = 
	GuiControl, Focus, button2_b_output	
Else
	GuiControl, Focus, input2_fps_input
WinActivate, %script_name%
If dragdropmode_active = 1
	WinSet, AlwaysOnTop, On
GuiControl, Choose, GuiTab, 2
return ;END Output2Browse

Convert2:
Gui +OwnDialogs 
WinSet, AlwaysOnTop, Off, %script_name%
GuiControlGet, convert2_file_input,, input2_b_input
GuiControlGet, convert2_file_output,, input2_b_output
GuiControlGet, convert2_fps_input,, input2_fps_input 
GuiControlGet, convert2_fps_output,, input2_fps_output 
If convert2_file_input = 
{
	MsgBox, 48, Cannot proceed, Select a subtitle file (.srt) to convert and an output folder!
	Return
}
StringSplit, splitrows_c2_f_i, convert2_file_input, `n
StringSplit, splitunits_splitrows_c2_f_i, splitrows_c2_f_i1, \
convert2_file_inpath =
Loop {
	If a_index = %splitunits_splitrows_c2_f_i0%
		Break
	convert2_file_inpath := convert2_file_inpath "\" splitunits_splitrows_c2_f_i%a_index%
}
StringTrimLeft, convert2_file_inpath_trimmed, convert2_file_inpath, 1
If convert2_file_output = 
{
	convert2_file_output = %convert2_file_inpath_trimmed%\converted_subtitles ;
	FileCreateDir, %convert2_file_output%
}
Else If convert2_file_output = %convert2_file_inpath_trimmed%
{
	MsgBox, 52, Warning!, The input files are in the output folder. They will be overwritten this way. Do you proceed?
	IfMsgBox, No
	{
		convert2_file_output = %convert2_file_inpath_trimmed%\converted_subtitles ;
		MsgBox, 64, Changed output folder, The output folder is changed to:`n%convert2_file_output%`n
		FileCreateDir, %convert2_file_output%
	}
}
Gui, 1:+Disabled
Menu, Tray, Disable, &File
Menu, Tray, Disable, &Help
Menu, Tray, Disable, &Drag and drop mode
WinGetPos, X,Y, Width,, %script_name%
Gui, 4:+owner1
Gui, 4:-0xC00000
Gui, 4:+0x800000
Gui, 4:Font, s12,
Gui, 4:Add,Text,x+80 y+50,Conversion in progress...
Gui, 4:Show, x%X% y%Y% w%Width% h130,Conversion in progress... 
WinSet, AlwaysOnTop, Off,,Conversion in progress...
WinMove,,Conversion in progress..., %X%, Y+140, 
WinActivate,, Conversion in progress...
Loop
{
	If a_index > %splitrows_c2_f_i0%
		Break
	current_loop_item := splitrows_c2_f_i%a_index%
	StringSplit, splitunits_current_loop_item, current_loop_item, \
	last_loop_unit_nr = %splitunits_current_loop_item0%
	filename_output := splitunits_current_loop_item%last_loop_unit_nr%
	convert2_file_output_with_filename = %convert2_file_output%\%filename_output%
	StringReplace, convert2_fps_input, convert2_fps_input, ., 
	StringReplace, convert2_fps_output, convert2_fps_output, ., 
	SrtSynch(1, current_loop_item, convert2_file_output_with_filename, 0, 0, convert2_fps_input, convert2_fps_output)
}
Gui, 4:Destroy
Gui, 1:-Disabled
Menu, Tray, Enable, &File
Menu, Tray, Enable, &Help
Menu, Tray, Enable, &Drag and drop mode
MsgBox, 68, Done!, Conversion done. Your converted files are in:`n%convert2_file_output%`nWould you like to open the folder now?
IfMsgBox, Yes
	Run, explorer.exe "%convert2_file_output%"
WinActivate, %script_name%
If dragdropmode_active = 1
	WinSet, AlwaysOnTop, On, %script_name%
Return ;END Convert2

;On Exit
Ex:
GuiClose:
ExitApp

;/////////////////////////
; SRTSYNCH
;/////////////////////////
SrtSynch(delay_or_framerate, input_subtitle, output_subtitle, delay, is_delay_positive, input_fps, output_fps)
{
shifting_ratio := input_fps/output_fps
; LOOK FOR TIMER SETTINGS
Loop, Read, %input_subtitle%, %output_subtitle% ;Looping through the subtitles by rows
{
show_and_hide1 =
show_and_hide2 = 
StringReplace, list, A_LoopReadLine, -->, |
StringSplit, show_and_hide, list, |
StringLen, var, show_and_hide1
StringLen, var2, show_and_hide2
If (var <> 13 OR var2 <> 13) ; Is it a timer
{
	FileAppend, %A_LoopReadLine%`n ; If it isn't, copy the line and jump
	Continue
}
Else
{
string = %A_LoopReadLine%
StringReplace, nyil, string, -->, |
StringSplit, show_and_hide, nyil, |
StringSplit, show , show_and_hide1, : ; Split the timer into two parts in the middle
StringSplit, hide, show_and_hide2, :
;///////////////////
; TIMER, FIRST PART
StringReplace, show_ms, show3, `,, 
show_hh_in_ms := show1*3600000
show_mm_in_ms := show2*60000
show_time_in_ms := show_hh_in_ms+show_mm_in_ms+show_ms
If delay_or_framerate = 0
{
	If is_delay_positive = 1
		show_time_in_ms_converted := show_time_in_ms+delay
	Else If is_delay_positive = 0
		show_time_in_ms_converted := show_time_in_ms-delay
		
}
Else If delay_or_framerate = 1
{
	show_time_in_ms_converted := show_time_in_ms*shifting_ratio
}
Transform, st_in_ms_c_rounded, Round, show_time_in_ms_converted
show_firststep := st_in_ms_c_rounded/1000
StringSplit, show_firststep_split, show_firststep, .
StringLeft, show_ms, show_firststep_split2, 3
show_secondstep := show_firststep_split1/60
StringSplit, show_secondstep_split, show_secondstep, .
show_ss_in_mm = 0.%show_secondstep_split2%
show_ss_raw := show_ss_in_mm*60
Transform, show_ss, Round, show_ss_raw
show_mm = %show_secondstep_split1%
show_hh = 00
If show_mm >= 60
{
show_thirdstep := show_mm/60
StringSplit, show_thirdstep_split, show_thirdstep, .
show_mm_in_hh = 0.%show_thirdstep_split2%
show_mm_raw := show_mm_in_hh*60
Transform, show_mm, Round, show_mm_raw
show_hh = %show_thirdstep_split1%
}
StringLen, var, show_hh
If var = 1
	show_hh = 0%show_hh%
StringLen, var, show_mm
If var = 1
	show_mm = 0%show_mm%
StringLen, var, show_ss
If var = 1
	show_ss = 0%show_ss%
StringLen, var, show_ms
If var = 1
	show_ms = 00%show_ms%
Else If var = 2
	show_ms = 0%show_ms%
show_time_full = %show_hh%:%show_mm%:%show_ss%,%show_ms%
;///////////////////
; TIMER, SECOND PART
StringReplace, hide_ms, hide3, `,, 
hide_hh_in_ms := hide1*3600000
hide_mm_in_ms := hide2*60000
hide_time_in_ms := hide_hh_in_ms+hide_mm_in_ms+hide_ms
If delay_or_framerate = 0 
{
	If is_delay_positive = 1
		hide_time_in_ms_converted := hide_time_in_ms+delay
	Else If is_delay_positive = 0
		hide_time_in_ms_converted := hide_time_in_ms-delay
		
}
Else If delay_or_framerate = 1
{
	hide_time_in_ms_converted := hide_time_in_ms*shifting_ratio
}
Transform, st_in_ms_c_rounded, Round, hide_time_in_ms_converted
hide_firststep := st_in_ms_c_rounded/1000
StringSplit, hide_firststep_split, hide_firststep, .
StringLeft, hide_ms, hide_firststep_split2, 3
hide_secondstep := hide_firststep_split1/60
StringSplit, hide_secondstep_split, hide_secondstep, .
hide_ss_in_mm = 0.%hide_secondstep_split2%
hide_ss_raw := hide_ss_in_mm*60
Transform, hide_ss, Round, hide_ss_raw
hide_mm = %hide_secondstep_split1%
hide_hh = 00
If hide_mm >= 60
{
hide_thirdstep := hide_mm/60
StringSplit, hide_thirdstep_split, hide_thirdstep, .
hide_mm_in_hh = 0.%hide_thirdstep_split2%
hide_mm_raw := hide_mm_in_hh*60
Transform, hide_mm, Round, hide_mm_raw
hide_hh = %hide_thirdstep_split1%
}
StringLen, var, hide_hh
If var = 1
	hide_hh = 0%hide_hh%
StringLen, var, hide_mm
If var = 1
	hide_mm = 0%hide_mm%
StringLen, var, hide_ss
If var = 1
	hide_ss = 0%hide_ss%
StringLen, var, hide_ms
If var = 1
	hide_ms = 00%hide_ms%
Else If var = 2
	hide_ms = 0%hide_ms%
hide_time_full = %hide_hh%:%hide_mm%:%hide_ss%,%hide_ms%
; Conversion done, change the timer, jumpt to the next row
timer_full = %show_time_full% --> %hide_time_full%
FileAppend, %timer_full%`n
} ;End of Else
} ;End of Loop
} ;End of SrtSynch Function