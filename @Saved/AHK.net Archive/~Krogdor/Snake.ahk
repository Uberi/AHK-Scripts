;AHK-Snake
;An AHK Port of the classic game "Snake"
;By Krogdor
;Credits to tic for the extensive Gdip library (http://www.autohotkey.com/forum/viewtopic.php?t=32238)
;And to infogulch for the SimpleArray (SA_) functions (http://www.autohotkey.com/forum/viewtopic.php?t=35041)
;And to majkinetor for the Common Dialogs (specifically, the color dialog (http://www.autohotkey.com/forum/viewtopic.php?t=17230)
#NoEnv
#UseHook
#SingleInstance Force
SetBatchLines, -1
SetWinDelay, -1
OnExit, Cleanup
gToken := Gdip_Startup()
LoadSettings()
GlobalsInit()
WindowInit()           ;make the window, the graphic area, etc
Hotkey, IfWinActive, ahk_id %WinID%
Hotkey, %StartGameHotkey%, StartGame, On
Gdip_FillRectangle(G, BackBrush, 0, 0, 300, 280)
Gdip_FillRectangle(G, FooterBrush, 0, 240, 300, 40)
Gdip_TextToGraphics(G, "AHK-Snake", "x0 y245 w300 h40 cFFFFFFFF s18 Bold Center r4")
Gdip_TextToGraphics(G, "Score:", "x10 y250 w55 h40 cFFFFFFFF s15 Bold Center r4")
Gosub, CreateBitmapVars
WriteFile(A_Temp "\1.bmp", cBut)
WriteFile(A_Temp "\2.bmp", sBut)
CloseBitmap := Gdip_CreateBitmapFromFile(A_Temp "\1.bmp")
SettingsBitmap := Gdip_CreateBitmapFromFile(A_Temp "\2.bmp")
Gdip_DrawImage(G, SettingsBitmap, 225, 244, 32, 32)
Gdip_DrawImage(G, CloseBitmap   , 262, 244, 32, 32)
Gdip_DisposeImage(SettingsBitmap)
Gdip_DisposeImage(CloseBitmap)
FileDelete, % A_Temp "\1.bmp"
FileDelete, % A_Temp "\2.bmp"
CreateTextSplashScreen("Press " StartGameHotkey " to begin playing AHK-Snake.")
WinMove, ahk_id %WinID%, , % (A_ScreenWidth-302)//2, % (A_ScreenHeight-282)//2    ;don't know why, but the OnMessage won't respond...
WinMove, ahk_id %WinID%, , % (A_ScreenWidth-300)//2, % (A_ScreenHeight-280)//2    ;to messages unless the window is moved first. Weird.
OnMessage(0x201, "MouseClick")
Return

GuiClose:
Esc::
ExitApp

NewGame:
GameStarted := False
Hotkeys("Off")
SetTimer, MoveSnake, Off
Gdip_FillRectangle(G, BackBrush, 0, 0, 300, 240)
CreateTextSplashScreen("Press " StartGameHotkey " to begin playing AHK-Snake.")
Hotkey, %StartGameHotkey%, StartGame, On
Return

StartGame:
GameStarted := True
GlobalsInit()
Gdip_FillRectangle(G, BackBrush, 0, 0, 300, 240)  ;make a blank slate
UpdateScore(0)
Hotkey, %StartGameHotkey%, Off              ;no more need for the starter hotkeys
HeadX := Round(TotalGridX/2)
HeadY := Round(TotalGridY/2)
DrawSnakeBody(HeadX, HeadY)      ;make the first body part
DrawFood()                       ;make some new food
BodyParts := SA_Set(BodyParts, HeadX "x" HeadY, "1")   ;start adding body parts to the body coord array
Win_Update()                        ;update changes
SetTimer, MoveSnake, % Interval   ;set the timer to move the snake at each interval
Hotkeys("On")                     ;turn on the hotkeys for controlling the snake
Gdip_FillRectangle(G, FooterBrush, 113, 262, 76, 14)
Gdip_FillRectangle(G, WhiteBrush, 123, 265, 3, 10)Gdip_FillRectangle(G, WhiteBrush, 129, 265, 3, 10)
Gdip_TextToGraphics(G, "Pause", "x135 y263 w50 h12 cFFFFFFFF s13 Left r4")
Return

ChangeDir:
NewMove := RegExReplace(A_ThisHotkey,"NumPad")   ;strip to just the direction
If !((NewMove = "Up" && MoveDir = "Down") || (NewMove = "Down" && MoveDir = "Up")           ;make sure the snake doesn't...
   || (NewMove = "Left" && MoveDir = "Right") || (NewMove = "Right" && MoveDir = "Left"))   ;...try to go back on itself
	MoveDir := NewMove
Return

MoveSnake:
If (MoveDir = "Up")                ;
	HeadY--                          ;   direction
Else If (MoveDir = "Down")         ;   control
	HeadY++                          ;
Else If (MoveDir = "Left")         ;
	HeadX--                          ;
Else If (MoveDir = "Right")        ;
	HeadX++                          ;
If (HeadX > TotalGridX)            ;
	HeadX := 1                       ;   check
If (HeadY > TotalGridY)            ;   for
	HeadY := 1                       ;   off
If (HeadX = 0)                     ;   screen
	HeadX := TotalGridX              ;   to
If (HeadY = 0)                     ;   wrap
	HeadY := TotalGridY              ;
HeadCoords := HeadX "x" HeadY       ;get an easy to use single variable with both coordinates
BodyParts := SA_Set(BodyParts, HeadCoords)  ;add current position to body coord array
If RegExMatch(BodyParts, "[^\d]" HeadCoords "[^\d]") ;if head intersects the body (coords of head are in the body coord array)...
	Goto GameOver                                      ;...you lose. lol.
If (FoodPos = HeadCoords) {       ;if the head is in the same place as some food...
	SnakeLen += SnakeAdd            ;...snake gets longer
  UpdateScore(++Score)            ;...score goes up,
	DrawFood()                      ;...new food is made
}
If (SnakeLen < SA_Len(BodyParts)) {    ;if the body is as long as it should be (i.e. not when starting or after eating food)...
	DelSnakeBody( SA_Get(BodyParts, 1) ) ;...delete the last body segment...
	BodyParts := SA_Del(BodyParts, 1)    ;...and remove its location from the body coord array
}
DrawSnakeBody(HeadX, HeadY)         ;make a new body segment (the head)
Win_Update()                  ;update all our changes
Return

GameOver:
GameStarted := False
Hotkeys("Off")
SetTimer, MoveSnake, Off
CreateTextSplashScreen("Game over! Your score was " Score ".`nPress " StartGameHotkey " to play again, or ESC to exit")
Hotkey, %StartGameHotkey%, StartGame, On
Return

Pause:
Paused := !Paused
Gdip_FillRectangle(G, FooterBrush, 113, 262, 76, 14)
Gdip_TextToGraphics(G, Paused ? "Resume" : "Pause", "x135 y263 w56 h12 cFFFFFFFF s13 Left r4")
If Paused
	Gdip_FillPolygon(G, WhiteBrush, "123,265|123,275|130,270")
Else
  Gdip_FillRectangle(G, WhiteBrush, 123, 265, 3, 10)Gdip_FillRectangle(G, WhiteBrush, 129, 265, 3, 10)
Win_Update()
If (Paused)
	SetTimer, MoveSnake, Off
Else
	SetTimer, MoveSnake, On
Return

MouseClick(wParam, lParam, msg, hwnd) {
	Local X, Y, mouseRGB
	Static Control
  X := lParam & 0xFFFF       ;get x-coord (lo word)
  Y := lParam >> 16          ;get y-coord (hi word)
  If (msg = 0x201) {                               ;if mouse click down
		If (hwnd = WinID && X > 222 && X < 255 && Y > 219 && Y < 250)            ;if it's in the area of the settings button
	    OnMessage(0x202, "MouseClick"), Control := "Settings"                  ;check for the mouse up message
		Else If (hwnd = WinID && X > 259 && X < 291 && Y > 219 && Y < 250)       ;if it's in the area of the close button
	    OnMessage(0x202, "MouseClick"), Control := "Close"                     ;check for the mouse up message
	  Else If (hwnd = WinID && X > 119 && X < 183 && Y > 239 && Y < 250)
	    OnMessage(0x202, "MouseClick"), Control := "Pause"
		Else {
			Control := ""
			OnMessage(0x202, "")
		}
		Return
	}
	If (X > 222 && X < 255 && Y > 219 && Y < 250 && Control = "Settings")    ;if the up message is still in the settings button
  	CreateSettingsGUI()                                                     ;make the settings gui
	Else If (X > 259 && X < 291 && Y > 219 && Y < 250 && Control = "Close")  ;if the message is still in the close button
	  ExitApp                                                                ;exit
	Else If (X > 119 && X < 183 && Y > 239 && Y < 25 0)
	  Gosub Pause
	OnMessage(0x202, "")                                                    ;reset everything
	Control := ""
}


UpdateScore(Score) {
	Global
	Gdip_FillRectangle(G, FooterBrush, 65, 250, 20, 20)          ;write over the old score...
	Gdip_TextToGraphics(G, Score, "x65 y250 w55 h20 cFFFFFFFF s15 Bold Left r4", "Arial")  ;and make a new one
}

DrawFood() {
	Local X, Y, SS
	Loop, {
		Random, X, 1, TotalGridX
		Random, Y, 1, TotalGridY
		X := Round(X), Y := Round(Y)
		If !InStr(BodyParts, FoodPos := X "x" Y)      ;find a new place if the randomed coordinate lies inside the snake
		  Break
	}
	Gdip_DrawImage(G, FoodBitmap, (X-1)*GridL+1, (Y-1)*GridL+1, GridL-2, GridL-2, 0, 0, 15, 15)  ;draw the image of food we created earlier
}

DelSnakeBody(GridStruct) {  ;"GridXxGridY"
	Global G, BackBrush, GridL
	StringSplit, Grid, GridStruct, x
	Gdip_FillRectangle(G, BackBrush, (Grid1-1)*GridL, (Grid2-1)*GridL, GridL, GridL)
}

DrawSnakeBody(GridX, GridY) {
	Global
	Gdip_FillRectangle(G, SnakeBrush, (GridX-1)*GridL+1, (GridY-1)*GridL+1, GridL-2, GridL-2)
}

CreateSettingsGUI() {
	Local LoBound, HiBound
	KeyList =
	( LTrim Join|
		|Space|Tab|Enter|Return|Pause|BackSpace|Delete|Insert|Home|End|PgUp|PgDn|Up|Down|Left|Right|ScrollLock|CapsLock
		A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|1|2|3|4|5|6|7|8|9|0
		NumLock|Numpad0|NumpadIns|Numpad1|NumpadEnd|Numpad2|NumpadDown|Numpad3|NumpadPgDn|Numpad4|NumpadLeft|Numpad5|NumpadClear
		Numpad6|NumpadRight|Numpad7|NumpadHome|Numpad8|NumpadUp|Numpad9|NumpadPgUp|NumpadDot|NumpadDel|NumpadDiv|NumpadDiv
		NumpadMult|NumpadAdd|NumpadSub|NumpadEnter|F1|F2|F3|F4|F4|F5|F6|F7|F8|F9|F10|F11|F12|F13|F14|F15|F16|F17|F18|F19|F20|F21|F23|F24
		AppsKey|LWin|RWin|Control|Ctrl|Alt|Shift|LControl|LCtrl|RControl|RCtrl|LShift|RShift|LAlt|RAlt|PrintScreen|CtrlBreak
		Break|Help|Sleep|Ins|BS|Del|Browser_Back|Browser_Forward|Browser_Refresh|Browser_Stop|Browser_Search|Browser_Favorites|Browser_Home
		Volume_Mute|Volume_Down|Volume_Up|Media_Next|Media_Prev|Media_Stop|Media_Play_Pause|Launch_Mail|Launch_Media|Launch_App1|Launch_App2|
	)
	If (GameStarted = True && !Paused)
		GoSub, Pause
	LoBound := (Speed < 5 ? Speed : 5)
	HiBound := (Speed > 15 ? Speed : 15)
	Gui, 2:Add, Text, x12 y3 w170 h17 , Snake Speed - Moves/Sec
	Gui, 2:Add, Slider, x72 y20 w110 h30 AltSubmit gUpdateSlider vSliderVal Range%LoBound%-%HiBound%, % Speed
	Gui, 2:Add, Edit, x12 y20 w60 h30 -VScroll Number vSpeed, % Speed
	Gui, 2:Add, Text, x192 y3 w100 h20 , Block Size`, in pixels
	Gui, 2:Add, DropDownList, x194 y25 w88 h21 R4 vGridLN, % RegExReplace("6|10|12|15", GridLN "\|", GridLN "||")
	Gui, 2:Add, Text, x297 y3 w107 h20 , Length Add Per Food
	Gui, 2:Add, Edit, x297 y25 w103 h20 Number vSnakeAddN , % SnakeAddN
	Gui, 2:Add, GroupBox, x7 y53 w165 h145 , Colors (RRGGBB)
	Gui, 2:Add, Text, x22 y70 w100 h20 , Snake Color
	Gui, 2:Add, Edit, x22 y90 w50 h20 vSnakeColorN, % SnakeColorN
	Gui, 2:Add, Button, x72 y90 w90 h20 gColorPicker vSnakeColorNButton, Color Picker
	Gui, 2:Add, Text, x22 y110 w100 h20 , Background Color
	Gui, 2:Add, Edit, x22 y130 w50 h20 vBackColorN, % BackColorN
	Gui, 2:Add, Button, x72 y130 w90 h20 gColorPicker vBackColorNButton, Color Picker
	Gui, 2:Add, Text, x22 y150 w100 h20 , Food Color
	Gui, 2:Add, Edit, x22 y170 w50 h20 vFoodColorN, % FoodColorN
	Gui, 2:Add, Button, x72 y170  w90 h20 gColorPicker vFoodColorNButton, ColorPicker
	Gui, 2:Add, Button, x202 y150 w90 h25 gSettingsSubmit, Okay
	Gui, 2:Add, Button, x232 y175 w120 h22 gSettingsReset, Reset to Default Values
	Gui, 2:Add, Button, x292 y150 w90 h25 gSettingsCancel, Cancel
	Gui, 2:Add, GroupBox, x177 y53 w228 h95 , Hotkeys
	Gui, 2:Add, Text, x187 y70 w50 h20 , Pause
	Gui, 2:Add, ComboBox, x187 y86 w103 h20 vPauseHotkeyN R25, % SubStr(RegExReplace(KeyList, "(\|" PauseHotkeyN "\|)", "$1|"), 2)
	Gui, 2:Add, Text, x298 y70 w70 h20 , Start Game
	Gui, 2:Add, ComboBox, x298 y86 w103 h20 vStartGameHotkeyN R25, % SubStr(RegExReplace(KeyList, "(\|" StartGameHotkeyN "\|)", "$1|"), 2)
	Gui, 2:Add, Text, x187 y107 w70 h20 , New Game
	Gui, 2:Add, ComboBox, x187 y123 w103 h20 vNewGameHotkeyN R25,  % SubStr(RegExReplace(KeyList, "(\|" NewGameHotkeyN "\|)", "$1|"), 2)
	Gui, 2:Show, h202 w410, AHK-Snake Settings
	Gui, 2:+LastFound
	SettingsGUI := WinExist()
}
Return

ColorPicker:
cGuiControl := RegExReplace(A_GuiControl, "Button")
GuiControlGet, cRGB, , %cGuiControl%
cRGB := "0x" cRGB
Dlg_Color(cRGB, SettingsGUI)
StringReplace, cRGB, cRGB, 0x
StringUpper, cRGB, cRGB
GuiControl, 2:, %cGuiControl%, % cRGB
Return

UpdateSlider:
GuiControl, , Speed, %SliderVal%
Return

SettingsSubmit:
Gui, 2:Submit
Gui, 2:Destroy
If SnakeColorN is not xdigit
	SnakeColorN := SnakeColor
If StrLen(SnakeColorN) != 6
	SnakeColorN := SnakeColor
If BackColorN is not xdigit
	BackColorN := BackColor
If StrLen(BackColorN) != 6
	BackColorN := BackColor
If FoodColorN is not xdigit
	FoodColorN := FoodColor
If StrLen(FoodColorN) != 6
	FoodColorN := FoodColor
If !InStr(KeyList, "|" PauseHotkeyN "|")
	PauseHotkeyN := PauseHotkey
If !InStr(KeyList, "|" StartGameHotkeyN "|")
	StartGameHotkeyN := StartGameHotkey
If !InStr(KeyList, "|" NewGameHotkeyN "|")
	NewGameHotkeyN := NewGameHotkey
If (PauseHotkeyN != PauseHotkey) || (StartGameHotkeyN != StartGameHotkey) || (NewGameHotkeyN != NewGameHotkey) {
	MsgBox, 4, AHK-Snake Settings, Most changes will be applied at next new game.`nHowever, hotkey changes require a restart to update.`nRestart Now?
	IfMsgBox, Yes
		Reload
}
Else
	MsgBox, Changes will be applied at next new game.
Return

SettingsReset:
GuiControl, , SliderVal, 11
GuiControl, , Speed    , 11
GuiControl, Choose, GridLN, 3
GuiControl, , SnakeColorN, 000000
GuiControl, , BackColorN, FFFFFF
GuiControl, , FoodColorN, 000000
GuiControl, , SnakeAddN, 2
GuiControl, , PauseHotkeyN, P
GuiControl, , StartGameHotkeyN, Enter
GuiControl, , NewGameHotkeyN, N
Return

2GuiClose:
SettingsCancel:
Gui, 2:Destroy
Return

CreateBitmapVars:
sBut =
(Join
424d381000000000000036000000280000002000000020000000010020000000000002100000c30e0000c30e00
000000000000000000222222002222220022222200222222002222220022222200222222002222220022222200
22222200222222002222220022222200222222008b85852ccecece9eb8b8b8948d8d8d09222222002222220022
222200222222002222220022222200222222002222220022222200222222002222220022222200222222002222
220022222200222222002222220022222200222222002222220022222200222222002222220022222200222222
0022222200222222002222220094929278e8e7e8ffd6d6d6ff73736d2a22222200222222002222220022222200
222222002222220022222200222222002222220022222200222222002222220022222200222222002222220022
2222002222220022222200222222002222220022222200222222008888881c9b98986122222200222222002222
220022222200b8b7b7d9eaeaebffecececff8a87876d2222220022222200222222008e8b8b42aeaeae72222222
002222220022222200222222002222220022222200222222002222220022222200222222002222220022222200
2222220022222200222222002222220072727228d1d1d1f1f4f4f4ffb2b2b1bb8e8e8e6bb0b0ae92c5c5c5d2dd
dddeffd7d7d7ffdcdcdbffd5d5d5f2b3b3b39c8e8e8e4b7f7f7f4ed1d1d1ffefeff0ffc4c4c4de837b7b232222
220022222200222222002222220022222200222222002222220022222200222222002222220022222200222222
002222220022222200a7a7a75ae7e8e8ffd9d9d9ffe5e6e6ffe7e8e8ffe6e6e6ffe5e6e6ffd9d9d9ffd7d7d7ff
d6d6d6ffdfdfdfffeaeaeaffdededeffe2e2e2ffe2e2e2ffdbdbdbffe3e3e3ff8c8c8c3c222222002222220022
222200222222002222220022222200222222002222220022222200222222002222220022222200222222002222
22008d8d8d36e2e2e2ffdcdcdcffdadadaffdbdbdbffdadadaffdadadaffdedadcffe2daddffe2daddffdedadc
ffdadadaffdcdcdcffddddddffdadadaffe2e2e2ffd5d5d5ff5555550322222200222222002222220022222200
22222200222222002222220022222200222222002222220022222200222222002222220022222200b9b7b7b7e6
e6e7ffddddddffdbdcdbffdbdcdbfff4e0e7ffffe0edffeedde3ffe0dcddffe1dcddffefdce3ffffdeecfff2df
e6ffdbdcdbffdbdcdbffdededeffe3e3e3ffb0b0b0892222220022222200222222002222220022222200222222
00222222002222220022222200222222006f6c6c52cfcfcdbaa2a2a277bab8b8cff2f2f2ffdededeffd9dcdbff
ebe1e5ffffe5f2ffc2d8d0ff68d0a7ff33d596ff23e198ff23ea9eff34e19eff6cd6acffc7dad3ffffe4f1ffea
e0e4ffd9dcdaffe1e1e1fff2f2f2ffa7a7a79299999953b2b0b0926262620d2222220022222200222222002222
2200222222004b4b4b11cacac9f0ffffffffededeeffecededffdededeffdadddcfff6e6ecfff5e4ecff65c29e
ff00b96eff00c470ff00d780ff00ea8eff00f694ff00e68aff00d077ff00c274ff6dc8a4fffae5edfff3e4eaff
dadddcffe1e1e1ffedededffe9e9e9ffffffffffa6a6a699222222002222220022222200222222002222220068
626227efefefffebececffe0e0e0ffe1e1e1ffdee0dffff2e7ebfff6e7edff39b081ff00a558ff08bf7aff00db
88ff06dd8bff13d88dff12e393ff04ed94ff00e68fff07c77eff00ac5eff3eb687fff8e7edffefe6eaffdee0df
ffe2e2e2ffe1e1e1fffefeffffa3a3a3a22222220022222200222222002222220022222200222222008585837c
f1f1f2fee5e5e5ffe2e2e2ffe6e3e3ffffedf7ff4eb18cff009651ff0cbb79ff04ca80ff33a479ff607b71ff6e
6e6eff6e6f6eff5f7e72ff2fae7eff02d685ff0bc07cff009a53ff5bb895ffffeef8ffe4e2e2ffe2e2e2fff4f5
f5ffb4b4b4bc2222220022222200222222002222220022222200222222002222220022222200d2d2d2f5f0f1f1
ffe2e3e3fffff1faffa5cbbcff008a4cff0bab6fff05bf78ff4f8671ff89596cff836973ff7d7377ff7d7276ff
836671ff88586aff4b8c73ff04c57dff0aae71ff008f51ffb2d0c4fffff0f9ffe2e3e3fffafbfbffa2a2a29d22
22220022222200222222002222220022222200222222002222220060605c3af1f1f1ffe9e9e9ffe6e5e6fffff2
faff4aa784ff008c51ff02b772ff408d6fff8b5d6fff7b7a7aff808181ff838383ff838383ff7f8180ff7b797a
ff8b5a6dff3a9472ff01bd76ff008f52ff49a884fffff0f7ffe7e6e7fff4f4f4ffcfcfcfec2222220022222200
2222220022222200222222007f7f7f0299999953cacac9d6f4f4f4ffe6e6e6fff9eef2ffd6dedaff108f5fff01
9e63ff17a46eff726c6dff7f7478ff818181ff898989ff8e8e8eff8d8d8dff898989ff808181ff7f7076ff6b6d
6cff0faa6fff009d60ff149162ffdee1dffff5ecefffebebebffe5e5e5ff9c9c99532222220022222200222222
0022222200a3a1a18bfffffffffbfbfbffe5e5e5ffe8e8e8fffff6fcffb0cec3ff00844fff03a769ff2d946dff
7e6871ff7c7c7cff868686ff909090ff999999ff999999ff8d8d8dff838383ff7c7b7bff7f6a73ff329c74ff0a
ab6eff0d8e5dffc3d6cffffff3f9ffe7e7e7ffecececfff3f3f3ffd8d8d8dbb1b1b1772222220022222200bdbc
bcdeffffffffedededffe8e8e8ffeaeaeafffff8ffffaacbbfff00834dff03a769ff31916dff806872ff7d7d7d
ff878787ff929292ff9c9c9cff999999ff929292ff909090ff8b8a8bff8d7a81ff47a280ff1fb37bff1b9467ff
bed6cdfffff8fdffecececffeaeaeafff2f2f2fffdfdfdffd1d1d1be22222200222222008b8b8b56d6d6d6c8f1
f1f1ffedededffeaeaeafffff7fdffbdd4cbff008552ff02a568ff28976dff7c686fff7a7979ff7f7f7fff8787
87ff939393ff9f9f9fffa3a3a3ff9c9c9cff939192ff918389ff4aaf89ff2db581ff36a178ffd7e2defffff6fa
ffedededfff6f7f7ffffffffffd7d7d7f0a0a09e6c22222200222222002222220022222200a9a9a8aaffffffff
efefeffff9f2f4fff0edeeff1f9568ff009154ff00a868ff5a6f67ff816a73ff838584ff959595ffa5a5a5ffa9
a9a9ffa3a3a3ff9c9e9dffa28c95ff849991ff42c795ff3ab083ff59b18ffff7f2f4fff9f4f6fff8f8f8ffe9e9
e9f4a2a2a06c7f7f7f082222220022222200222222002222220022222200918e8e64fffffffff6f6f6fff3f3f3
ffffffffff8dc7b0ff249f6eff37c58fff54b690ffa38993ffa99da2ffa8aaa9ffa7a7a7ffa5a5a5ffa2a4a4ff
a7989effa68f98ff63c49fff51cfa0ff3aad81ff9ccebafffffffffff3f3f3fffefefeffdededed12222220022
22220022222200222222002222220022222200222222007f7f7f28f6f6f6fffcfcfcfff5f5f5fffefcfeffeff3
f2ff65bf9dff68c6a3ff64dfb0ff79caabffa6a0a2ffb198a1ffaf9ba3ffb09aa2ffb196a0ffa4a1a2ff74cdaa
ff5ddeadff5bc59dff61be9affeff3f2fffdfbfdfff5f5f5ffffffffffc7c7c7cd222222002222220022222200
2222220022222200222222002222220092928f60fbfbfbfffafafafff7f7f7fff7f6f7ffffffffffcae6dbff5a
c19aff70d1acff6de4b7ff75dfb7ff8fc8b2ff98c2b1ff97c4b3ff8ecdb5ff74e6bbff6deabaff6fd4aeff5bc5
9cffd1e9e0fffffffffff6f6f6fff7f7f7fffdfdfdffe6e6e6eb4d4d4d17222222002222220022222200222222
00222222006d696941fffffffffffffffffdfdfdfffefefefff8f8f8fffaf9faffffffffffc7e9dcff72d2adff
76d9b3ff80e8c1ff7bf5c6ff7afbcaff7affceff7afeccff80edc3ff74ddb5ff75d6b1ffccebe0fffffffffffa
f9f9fff8f8f8fffbfbfbfffafafaffffffffffe7e7e7fe6666660f222222002222220022222200222222007171
712df0f0f0fffffffffffcfcfcfffffffffffefefefff9f9f9fffcfbfbffffffffffe4f5efffa5e6cdff89e4c2
ff83eac2ff83f0c7ff83f6caff82f1c7ff89eac5ffa6e9d0ffe8f6f1fffffffffffbfbfbfff9f9f9ffffffffff
ffffffffffffffffffffffffc0c0c0c06666660a22222200222222002222220022222200222222007474745abb
bbbb90868383469d9d9d90fffffffffefefefffbfbfbfffcfbfbffffffffffffffffffe7f8f2ffd2f5e8ffcbf7
e6ffcbf9e8ffd2f8e9ffe9f9f3fffffffffffffffffffcfbfbfffbfbfbffffffffffffffffffb1b1b187acacac
60b1b1b18722222200222222002222220022222200222222002222220022222200222222002222220022222200
22222200b5b3b3bbfffffffffefefefffdfdfdfffcfcfcfffefdfdfffffffffffffffffffffefffffffdffffff
fefffffffefffffefdfdfffcfcfcfffdfdfdfffefefefff7f7f7f59595956d2222220022222200222222002222
2200222222002222220022222200222222002222220022222200222222002222220022222200222222006e6e6e
2efffffffffffffffffdfdfdfffffffffffffffffffefefefffdfdfdfffdfdfdfffdfdfdfffdfdfdfffdfdfdff
fffffffffffffffffdfdfdffffffffffc4c3c3a722222200222222002222220022222200222222002222220022
2222002222220022222200222222002222220022222200222222002222220022222200a3a3a372ffffffffffff
fffffffffffffffffffffefefefffffffffffffffffffefefefffefefefffefefeffffffffffffffffffffffff
ffffffffffffffffffe8e8e8df2222220022222200222222002222220022222200222222002222220022222200
222222002222220022222200222222002222220022222200222222009e9e9e45cececee3ffffffffffffffff85
82825295959561c4c3c4b4fbfbfbfffffffffffffffffffffffffffafafaffaeaeaea88a87875ee5e5e6f4ffff
ffffe4e4e4f47f7f7f062222220022222200222222002222220022222200222222002222220022222200222222
0022222200222222002222220022222200222222002222220055555503b4b4b3946e6e6b612222220022222200
22222200e4e4e4e7fffffffffffffffff9f9f9ff7b7b7b3e22222200222222008f8f8927cfcfcfaa8585852822
222200222222002222220022222200222222002222220022222200222222002222220022222200222222002222
220022222200222222002222220022222200222222002222220022222200222222002222220022222200b9b9b9
adf9f9f9fffefefeffb6b6b6b12222220022222200222222002222220022222200222222002222220022222200
222222002222220022222200222222002222220022222200222222002222220022222200222222002222220022
222200222222002222220022222200222222002222220022222200222222002222220074746d239e9e9e62c3c3
c38587878733222222002222220022222200222222002222220022222200222222002222220022222200222222
002222220022222200222222002222220022222200222222002222220022222200222222002222220022222200
222222002222220022222200222222002222220022222200222222002222220022222200222222002222220022
222200222222002222220022222200222222002222220022222200222222002222220022222200222222002222
220022222200222222000000
)
cBut =
(Join
424d360c00000000000036000000280000002000000020000000010018000000000000000000c40e0000c40e00
000000000000000000e4e6f0dde2e1e3e3e3eae2ece4dce3eae5e2e0dbd8e7dee8e2dce1e0dce1dedadfe2e2e2
dde0ded7ded7dce4ddd8e0d9dadbdfdcdedfdcdfdddbdfdad9dedcd8dcddd8dce1dbdde7e3d9e6e3dedfe6e5e1
e1dfe5e2e0e6e6e5e1e7e4dfeae3e8e2e7e6dfe5dae1e4dbe7e6e8e4e1e3e2e3dae7eae1e2e1e3e4e1e3e6e3e5
dfdee0dedde1e2e1e5e0e0e6dfdee7dcdbe4dedde1e0e0e0e2e3dfe0e2dcdce1d8e0e4dee1e4e2dcdedee5e5df
e0e6d5e1e8d9e1e6e5dbdee2e3e7e2e5e3e2f0e8f2e8e8e8e3e6dde8ece7dadae6dbdaeed2d6e1d8dce7d5d9ec
d7dfd5d5ddd2d9e1d7d9dfdad6dbdad5d6dad4d4dadadbdfd8d2e9d1cde0d3d0dfd8d6e2d6d5ded7d6dfdad9e3
dad9e3d9d9e5dadee3d8dee5dbddefd0d3e1eef3f2e4e7e5e4e1eaeee6f0eae9ebdfdfeb6c668f4a447d4b4880
414177403e7a453985382d75392f75372b7333257339287936267431226c31237130236f342773392c763c2e76
3c2e763d2f773f317940347c463e7f433b7a4a43805f5e86ced3dce6ece7edeff0ede5ecece9ebe9e8fc57518a
291e742b227c241b75241a771c0c7c21137c221777190e6f14066f17097314086c0e05600b045f140c69130b6a
100565150a6b1d107221147624187825137e2d1f842b1e802f237d47417cd0d5e4eaf1ece9eceaf8f3f0edeee5
e3e7f25e5b93322983342989312883271c781f11771f1572140c63130b6a190c781003770c0371150f740a0b66
0f0e6a0f0e6c130f6f1811721812711b1370211a75251d7a29217e31268734298647427fd4d8eaedf2f1f0eff1
f1ece9f1f4ebe9edf857578d2d247e3128832a2172322875706897a9a6cda2a1c95a5691170e6510026c211480
10086d14087e0f037915077d19097e1707761a0c751e12721a0d69252474211e73302887352a87494481d6d8ea
eef0f0f2eef3faf1fbedeceee9edff5d5b97352b882e237f362c79a096dcfcfdf4f9fbeffcfffbedeaff7f75b7
1c0c6a15076d160b6c170c72190c721a0e7213086523196c655da4928bc88781b82e2a83241e7d31258f33258b
4d4586dcdef0f4f5f3f3eef0edefeffbfff9e7ecef675aa82b198a3b3078b2a6cafffefceaebf9f5f6faeee8ed
f6f2edfdfef58d87b80f006c10087a0b106b120781100073604d96d5d0dff7f7f1fefffdfbfcffdcc9f0594b85
2319733427934c3d98d9e0e3f4f5f9f5f7f7f8f8fef0f3f1edf2f362589e2e22868282bef7f3fffffffaf4fef2
e8ebe9fbf2fffaf2f9f7f8eef4f7ff6662a40d017108007a18126b7d7ca8efedfffdf8fffffafbefefe9eff3e8
fffcffc5c3e1403c842f248a4e3f9adfe4e7f3f5f5f0f4eef5f2fbf7f8f6eff5f45b54972d258a4c4d978380b7
b5b0cff0fbf3f6f9fdf4eff8f9f1f8f9f6f1f4feede3e9fc392f821502779795c3f8fff5f9ffecf9f4f5f2edee
fbfcf2f3f8e9f9fff4f4fbff8e8fcb2b23824b3c97e2e6ebf7f9f9f6fcf1fcf8fdf9faf6f2f6f7635aa333279d
2b268f20157d2d1f7d6b6895dad6fafcfdfff4f5ebfbf6f7f6f8f2f3faf5b7b7d5aba4cff4f5fff8fef3f6f8ec
fafaf4f7f8f6fafafffbfaffcfcfe7acaed68686cc38308f52429adde1e6f2f4f5fbfff9f3f2f6fdfcf8f9fdfe
6357a3271b932d299a30259f2b1a9327157a473590dad5f5fdfff8fcfbfdf3f1f7fcfffaf3f8f6fbfff3f9f8fc
f4f0fbf3f4f2f4f7f5faf9ffbbb4e761569c382782251b75241d7e392e9653419ae4e6eefdfcfff7f9fafefbff
fffffff2f3f7665ba1362c972d2c8c27218c2c208a2f1e97210b8946368dd3d1eefbfcfffcfbfdf2f3f1fbfcf8
fffff3faf6fbf6f5fefaffffeff2ff7972b527197f2212812a10992f209a302698392c98524099e2e1eafdfcff
f1f4f8fcfcfffafafaf9f7fd6b5da531238d2e2a8930299233258f241b902a1a9716017b5a4c9ee0def4fdfffc
fbf9f9fef8fdfff8fdfaf8f8fbffffd9dcf8504c94180b791e118b231a8f2e199e24188e312a993225935c47a3
e5e4eefaf8fefbfffcf8fdfcfdfefcfcf8ff6855a636219b372b9b2e1b9a321a9c241f92201a852613921b0379
aca6d5fdfffefefcfbfdf8fafffafffdfff6f5fbff736eac14047a1a0c8f1b188c1e218a2a1f8d2c288d2c2990
3a2d994a3493ecebf5fcfbfdf8fff4fdf8f9fdfcfef2faf96557a93727923828973124922f1f9428248921108f
220c829394b0fdfff5f8f4f9fcfafafffbfdf6f5fef8fcf7f9fefcc0b9de2a157b1e07921e16981a23852b2193
2624882f269f3425985944a1e2ddecfffffcf8fbf9fdf8f9fcfbfdf0f8f76355a73525903728943124922f2093
271b91200e837a74aff5f5fff9f9f9fcfaf9faf4fff8f9eff4f8f3f6f6fcfcfafff3f5fdaea9d61d1072211390
1d178e2519892a2987302b9833298d4d3d8bf2f0f6f9faf6f9fafefdf8f9fbfafceff7f66254a634258e372894
3124902e2090230b914f4794e3ebf2fdfefff1ecf5f7f5f4fdf9fff7f9f9fdfffbf5f4f6f4f0f5f9faf8f7faff
a7a6ce2519712313892f1c932820852820923e35964d4189e2e4e5f6f8f2f9f9fffcf7f8f9f8faeef6f56255a5
33258b3527912f248c2a1d8b2b148eb8bcd4fbfffbf1efeefffbfcf3f3f3fafcff8d84b6d0cde6fdfffcfafdee
fbf5faf6f1fafbfdfec2c0de4b3d8b230e7b2e21872c1e9b2f21915a4a9ee6e6ecfbfef5f3f5f5fbf6f8f7f6f8
eef7f46356a632248a34268f2d2288261a8455469aebf6f3f2f6f0fbf3fdf6f4ecfafef8a7a8ca15046d4f4091
e3e4f8f2fae9f8f7f3f6eef8f3f1f0fdffffdfddf1847cb1504e8a352b963526994b3996dcdce8fffffbf6f7f5
f9f4f6f5f4f6edf6f36356a432248933278b2c2286231880817cb3f4fbfef3f7ebf2e7fbf4f3efd9e2df322a7d
0a007a110075645da6edf3fff2fae9f8f9f0ede5eff7f3f8fafef3fbfffbe1eaf8504d9c2c21874d3d95e1e3ee
f8f9f5f3f2f4f8f3f5f2f1f3ebf4f16255a330238533278b2d248523187e746cadf5f9fff1f5e9eee5f2fffbff
7f7da70900700f0d7e0d057a0e046f625b9edfe2f1fdfefaf2eef4f6f2f8eff3e8fbf9f9b0b3c82f297b352b8f
4e4195dadee3f7f9f3f5f4f8f7f2f4f0eff1e9f2ef6053a12f22843328892e268524197f3a2984d0d6dbf8f9f5
f8f4f3dad6e929197710067e050d6b0a0f720e08770f016b4a3d81bbb9cdedefe9f6f8f2f8f7f9d3beef483b79
2a198835279743368ae2e7e8f2f8edf1f1f1f2e9f6eef1e8e7ebf65f549d34248f2f27842b297b26217c201075
4f4881dbdceafbfaff968cb7160354210f72170a6c1805741b08751d0c7316086820116c46398d6358a86157a4
28237e26227b2b2382392d8d463c82dcdaf7f0eff1f3eeeff6f1f2eff5e4e8ecf15d55943222873027822d297b
2a237e2b1d8d1c15664f4c7ecdcaf860559b1b096c100272100776150777140775180c76180d73160b6b19106b
1d146e19106728217c28227b2d2380382c86453e7bdadaecf1f4ebf5f4eaeae8e7edf1e5e9ecf4605895322280
3328842f267d2a1e7e1e1b7e1f1c72120f573a367d30297a130b680f096e0e0b72110d6d0e0a6a100c6b17126e
19146f18146d1e186f241e75261a7a2d227e3025823729814b437fd8d8eaeff1ebe9eae1ece7f0ecebeddedef0
5c538c27186c2d1e72291b6d25156d19116e1d127217096e0d00601103630f04640c05660500640900620e0167
0e01670d006613056b16086e17096f1b0d7323136b291a6e28196d2a1c6e494079cecce2f0eff3ede8f1ebe6ef
e3e2e6dbdbe98985a96962956b6497666091675e91615c8f544c885b4d9463559c554a89554e87534e854d4a82
4c457e554e87584e8a554b875b508e6154925f5191615393655b90666091665e936b629a7f7aa1d3d3dfeae9ed
ebe4f1eae8e7e0e1dde9eeeddfe2eae1e5f0e4e6f1e3e4eee4e5efe6e7e5ecebede0dfe8dddce6e8e8eedce0e1
e3e8e7e0e5e4e2e7dee4e9e0e1e5dfe1e5dfe6e7e3e4e5e1e4e5e3eaebe9e3e3efe0e2eae2e4efe4e5f9dddfe9
e8efe8e5e7e1e9e5ebe9e9e3dddedcdbdedcdee4dfe0e6e1dadfdde0e1dfdddfd9dfd9dee4dfe0d8d7d3e4e5e3
d9d8dadcdbdfdbdadcdbdbdbd9ddd8d9ddd8dcddd9e0e1dde0e1dddedcdbdcdad9e0dedddedfdddcded8dce1df
e2e5eadee3e2dee5d8e0e3dae9e5ebe4e1e3e6e3ece1e0e9e0e4e5dde2e1dbdce0e8e4eadfd9dee3dbe6dddbda
dee2d6dce3d6d7dad8e2e2e8d7d5dbdcdcdcd8d9e3d8d9e3d8d9e3d9d8e2d8d7e0dad9e2dfdce5e0dde6e4dde4
e3e0e2dfe0e4dadae6dde0e5e3e7e1e7e7e7e7dff0
)
Return

LoadSettings() {
	Local File
	File := A_ScriptName ".settings.ini"
	IniRead, Speed          , %File%, Settings, Speed          , 11
	IniRead, GridLN         , %File%, Settings, GridLN         , 12
	IniRead, SnakeColorN    , %File%, Settings, SnakeColorN    , 000000
	IniRead, BackColorN     , %File%, Settings, BackColorN     , FFFFFF
	IniRead, FoodColorN     , %File%, Settings, FoodColorN     , 000000
	IniRead, SnakeAddN      , %File%, Settings, SnakeAddN      , 2
	IniRead, PauseHotkey    , %File%, Settings, PauseHotkey    , P
	IniRead, NewGameHotkey  , %File%, Settings, NewGameHotkey  , N
	IniRead, StartGameHotkey, %File%, Settings, StartGameHotkey, Enter
	PauseHotkeyN := PauseHotkey, NewGameHotkeyN := NewGameHotkey, StartGameHotkeyN := StartGamehotkey
}

SaveSettings() {
	Local File
	File := A_ScriptName ".settings.ini"
	IniWrite, %Speed%           , %File%, Settings, Speed
	IniWrite, %GridLN%          , %File%, Settings, GridLN
	IniWrite, %SnakeColorN%     , %File%, Settings, SnakeColorN
	IniWrite, %BackColorN%      , %File%, Settings, BackColorN
	IniWrite, %FoodColorN%      , %File%, Settings, FoodColorN
	IniWrite, %PauseHotkeyN%    , %File%, Settings, PauseHotkey
	IniWrite, %NewGameHotkeyN%  , %File%, Settings, NewGameHotkey
	IniWrite, %StartGameHotkeyN%, %File%, Settings, StartGameHotkey
	IniWrite, %SnakeAddN%       , %File%, Settings, SnakeAddN
}

GlobalsInit() {
	Global
 	Interval := 1000/Speed, GridL := GridLN   ;snake movement interval, and width of each block
	TotalGridX := Round(300/GridL)
	TotalGridY := Round((240)/GridL)
	If !FooterBrush
		FooterBrush := Gdip_BrushCreateSolid(0xFF222222)
	If !WhiteBrush
		WhiteBrush  := Gdip_BrushCreateSolid(0xFFFFFFFF)
	If !SnakeBrush || SnakeColor != SnakeColorN
		SnakeBrush  := Gdip_BrushCreateSolid("0xFF" SnakeColor := SnakeColorN)
  If !BackBrush || BackColor != BackColorN
		BackBrush   := Gdip_BrushCreateSolid("0xFF" BackColor := BackColorN)
	If !FoodBitmap || FoodColor != FoodColorN {
		FoodBrush   := Gdip_BrushCreateSolid("0xFF" FoodColor := FoodColorN)
	  FoodBitmap  := Gdip_CreateBitmap(15, 15)
		FoodGraphic := Gdip_GraphicsFromImage(FoodBitmap)                 ;create a bitmap of the food
		Gdip_FillRectangle(FoodGraphic, FoodBrush, 5 , 0 , 5, 5)          ;to easily copy into the window
		Gdip_FillRectangle(FoodGraphic, FoodBrush, 5 , 10, 5, 5)          ;each time we need to create a food
		Gdip_FillRectangle(FoodGraphic, FoodBrush, 10, 5 , 5, 5)
		Gdip_FillRectangle(FoodGraphic, FoodBrush, 0 , 5 , 5, 5)
		Gdip_DeleteBrush(FoodBrush)
	}
	SnakeAdd := SnakeAddN
	SnakeLen := 4
	Score := 0
	MoveDir := "Up"
	BodyParts := ""
}

WindowInit() {
	Local obm
	Gui, +E0x80000 +LastFound +OwnDialogs ;-Caption +AlwaysOnTop +ToolWindow
	WinID := WinExist()
  hbm  := CreateDIBSection(300, 280)
	hdc  := CreateCompatibleDC()
	obm  := SelectObject(hdc,hbm)
	G := Gdip_GraphicsFromHDC(hdc)
	Gdip_SetInterpolationMode(G, 7)   ;high-quality bicubic resizing, or something like that
	Gdip_SetSmoothingMode(G, 4)       ;anti-aliasing
	Gui, Show, % "x" (A_ScreenWidth-300)//2 " y" (A_ScreenHeight-280)//2
}

Win_Update() {
	Global
  Static X, Y
  If !X
 		X := (A_ScreenWidth-300)//2, Y := (A_ScreenHeight-280)//2
	Else
		WinGetPos, X, Y
	UpdateLayeredWindow(WinID, hdc, X, Y, 300, 280)
}

CreateTextSplashScreen(Text) {
	Global G
  pBrush := Gdip_BrushCreateSolid(0xAA646464)
	Gdip_FillRectangle(G, pBrush, 0, 0, 300, 240)
	Gdip_DeleteBrush(pBrush)
	hFamily := Gdip_FontFamilyCreate("Arial")
	hFont := Gdip_FontCreate(hFamily, 12, 0)
	hFormat := Gdip_StringFormatCreate(0x4000)
	Gdip_SetStringFormatAlign(hFormat, Align)
	CreateRectF(RC, 0, 0, 112, 120)
	StringDim := Gdip_MeasureString(G, Text, hFont, hFormat, RC)  ;figure out how many rows of text it is,
	StringSplit, String, StringDim, |                             ;so we can make the rectangle accordingly
	pBrush := Gdip_BrushCreateSolid(0x99222222)
	Gdip_FillRoundedRectangle(G, pBrush, 90, 120-String4//2, 120, Round(String4)+10, 17)
	Gdip_DeleteBrush(pBrush)
	Gdip_TextToGraphics(G, Text, "x94 y" 124-String4//2 " w112 cFFFFFFFF s12 Center r4")
  Win_Update()
}

Hotkeys(State) {
	Global PauseHotkey, NewGameHotkey
	Hotkey, %PauseHotkey%, Pause, % State
	Hotkey, %NewGameHotkey%, NewGame, % State
  Hotkey, Up   , ChangeDir, %State% P9
	Hotkey, Down , ChangeDir, %State% P9
	Hotkey, Left , ChangeDir, %State% P9
	Hotkey, Right, ChangeDir, %State% P9
	Hotkey, NumPadUp   , ChangeDir, %State% P9
	Hotkey, NumPadDown , ChangeDir, %State% P9
	Hotkey, NumPadLeft , ChangeDir, %State% P9
	Hotkey, NumPadRight, ChangeDir, %State% P9
  Hotkey, W, ChangeDir, %State% P9
	Hotkey, A, ChangeDir, %State% P9
	Hotkey, S, ChangeDir, %State% P9
	Hotkey, D, ChangeDir, %State% P9
}

WriteFile(file,data)
{
   Handle :=  DllCall("CreateFile","str",file,"Uint",0x40000000
                  ,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
   Loop
   {
     if strlen(data) = 0
        break
     StringLeft, Hex, data, 2
     StringTrimLeft, data, data, 2
     Hex = 0x%Hex%
     DllCall("WriteFile","UInt", Handle,"UChar *", Hex
     ,"UInt",1,"UInt *",UnusedVariable,"UInt",0)
    }

   DllCall("CloseHandle", "Uint", Handle)
   return
}

Cleanup:
SaveSettings()
Gdip_DisposeImage(FoodBitmap)
Gdip_DeleteGraphics(FoodGraphics)
Gdip_DeleteGraphics(G)
Gdip_DeleteBrush(BackBrush)
Gdip_DeleteBrush(WhiteBrush)
Gdip_DeleteBrush(FooterBrush)
Gdip_DeleteBrush(SnakeBrush)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_Shutdown(gToken)
ExitApp