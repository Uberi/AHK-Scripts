#Include Thumbnail lib.ahk	
; ^ Thumbnail lib.ahk can be found at http://www.autohotkey.com/forum/viewtopic.php?t=70839

/*
	Title: cycleWindow.ahk
		Allows user to tab through a narrow subset of windows, as one would alt-tab through the set of all visible windows, or open a new window.
		
		cycleWindow Version: 1.0
		
		AutoHotkey Version: 1.0.48.05
		
		Platform: Win9x/NT
		
		Author: Jon Smithers
		
*/




;NO return statement here

/*
	Group: The Function
	
	function: cycleWindow
	
	Allows user to tab through a narrow subset of windows, as one would alt-tab through the set of all visible windows, or open a new window.
		
	Parameters:
		title - The function searches for windows with this title. For example, you would put "Notepad" to find all notepad windows (as they contain "Notepad" in their title). Note that this doesn't necessarily specify the window _title_ per say. It could be something like "ahk_class CabinetWClass".
		regExp - A regular expression that describes how to display each window title in the listview ("title" not related to above parameter). The listview will display only the first group in the regular expression. Leaving it blank, or specifying "" will cause the window titles to be displayed as they are ("(.*)"). Specify "0" to not display the listview at all. This parameter is useful becaues you may not want to see the " - Google Chrome" at the end of every Chrome window title. Specifying "(.*) - Google Chrome" here will trim that out. For more info on regular expressions, see <http://www.autohotkey.com/docs/misc/RegEx-QuickRef.htm>.
		pathToRun - The path used to open a new window if necessary.
		
	SETTINGS:
	
		A few easily-changeable tweaks that affect how the function acts.
		
		These can be found in the beginning lines of the function in cycleWindow.ahk. If you want these settings to differ between various calls of <cycleWindow>, you can add them as optional parameters to <cycleWindow>.
		
		cycleWindow_UseThumbnails - If you have Windows Vista or later, you can use window thumbnails. This is a nice way to show a window without having to actually activate it. This is the preferred way, but you will need to download maul.esel's library from <http://www.autohotkey.com/forum/viewtopic.php?t=70839>, and uncomment the "#Include Thumbnail lib.ahk" statement at the top of cycleWindow.ahk
		cycleWindow_thumbnailColor - Thumbnails are displayed on a GUI. This GUI, which is underneath the thumbnails, can be transparent or opaque. If you are using Aero (so the borders of your windows are transparent), having a colored GUI behind the thumbnails creates a nice highlighting effect. Specify the color of the highlight in this setting. To disable highlight, set it to "0" (this might be desirable if you don't use aero transparency).
		cycleWindow_thumbnailBorder - Thumbnails are displayed on a GUI. This displays how many pixels the GUI should extend out from behind the thumbnail, to create a border. If you are using Aero, the highlighting effect should be enough, so set this to 0.
		cycleWindow_disableThumbFade - Disables the highlight-fading that occurs when your release your finger from the holdkey (e.g. CapsLock). This feature uses the only global variable in <cycleWindow>.
		cycleWindow_ListViewGUI - The GUI number (1-99) that will be used to create the ListView which shows the window titles.
		cycleWindow_ThumbnailGUI - The GUI number (1-99) that will be used to create the windows' thumbnails (if cycleWindow_UseThumbnails is set to true).
		cycleWindow_matchMode - TitleMatchMode. Used with AHK's SetTitleMatchMode (http://www.autohotkey.com/docs/commands/SetTitleMatchMode.htm) to set how windows are to be searched with the title parameter. It has been set to 2, meaning that if a window contains *title*'s text anywhere in its title, it is considered a match. 
		cycleWindow_NewWindowKey - If this key is held down when you press the cycle key, the function launches a new window by running the path of the parameter pathToRun. It is set initially to "LWin".
		cycleWindow_shrinkThumb - Keep it set to false. This was an idea I chose not to fully implement.
*/
cycleWindow(title, regExp ="(.*)", pathToRun="") {
	;Increase Thread Speed
	Critical
	SetBatchLines, -1
	SetWinDelay, -1
	
	; ===== Settings =====
	cycleWindow_UseThumbnails := true
	cycleWindow_thumbnailColor := "FFFF00"   ;"94D8F5" ;"0"
	cycleWindow_thumbnailBorder := 2         ;0 or higher
	cycleWindow_disableThumbFade := false
	cycleWindow_ListViewGUI := 1             ;(1-99)
	cycleWindow_ThumbnailGUI := 2            ;(1-99)   
	cycleWindow_matchMode := 2	             ;(1-3)
	cycleWindow_NewWindowKey := "LWin"       ;http://www.autohotkey.com/docs/KeyList.htm
	cycleWindow_shrinkThumb := false
	;consider adding these as optional parameters for this function.
	; ====================
	
	
	gui %cycleWindow_ThumbnailGUI%: Destroy
	;fixes a quirk caused by thumbnail-fading when successive function-calls of windowCycle are performed shortly one after the other (i.e. you're releasing and pressing the hotkey really fast). The quirk is that the thumbnails are displayed with partial transparency since the cycleWindow_fadeOutThumbnail() function wasn't given enough time to finish fading out the thumbnail GUI.
	
	cycleWindow_debugMsg("(" . A_ThisHotkey . ")")
	thisHotkey := A_ThisHotkey
	RegExMatch(thisHotkey, "(.*) & (.*)", Match)
	   cycleWindow_cycleKey := Match2
	   cycleWindow_holdKey := Match1
	
	if (regExp="")
		regExp := "(.*)"

	SetTitleMatchMode %cycleWindow_matchMode%

	if (!getkeystate(cycleWindow_holdKey)) ;fixed a weird bug that i DO NOT UNDERSTAND
		gosub exitThread
		
	Gui %cycleWindow_ListViewGUI%: +Owner	;prevent button from showing on taskbar
	;Gui %cycleWindow_ThumbnailGUI%: +Owner	...
	

	;Hotkey, *%cycleWindow_cycleKey%, winCycle_doNothing	;merely prevents hotkey %key% from being inputted to the active window


	
	WinGet, IDs, list, %title%
	
	i := 1
	
	
	if (IDs = 0) OR (getKeyState(cycleWindow_NewWindowKey)) {
		run %pathToRun%
		gosub exitThread
	}
	if (IDs = 1) {
		gosub onlyOne
		gosub exitThread
	}

	gosub fashionGUI
	
    	    
	loop
	{
		win = % IDs%i%
		If (A_Index = 1) {
			IfWinActive, ahk_id %win% ;if it's already activated, activate the next one
			{
				gosub increment_i
				win = % IDs%i%
			}
		}
		gosub showWindow_i
		cycleWindow_debugMsg("Win " . i)

		KeyWait, %cycleWindow_cycleKey%, T0.4	;wait for release of cycleKey, timeout after 400ms
		


		;The following loop waits for either
		; 	1 - cycleKey to be pressed (or held down from previous iteration)
		;	2 - holdKey to be released
		loop {
			if (!getKeyState(cycleWindow_holdKey)) {
				WinActivate, ahk_id %win%
				gosub exitThread
			}
			if (getKeyState(cycleWindow_cycleKey, "P")) {
				break
			}
		}
		
		if getKeyState(cycleWindow_NewWindowKey) {
			run %pathToRun%
			gosub exitThread
		}
		
		if (getKeyState("Shift")) {
			gosub decrement_i
		}
		else {
			gosub increment_i
		}
    }

	return
	
	fashionGUI:
		if (regExp != "0")
		{
			;if (IDs <= 2) 
			;	return
			; ^ uncomment if you don't want to see ListView when there's only 2 windows
			
			Gui %cycleWindow_ListViewGUI%: +AlwaysOnTop -Caption +LastFound
			Gui %cycleWindow_ListViewGUI%: color, 96BC35
			WinSet, transcolor, 96BC35  
			Gui %cycleWindow_ListViewGUI%: font, s16, Verdana  
			Gui %cycleWindow_ListViewGUI%: Add, ListView, NoSort -Multi -grid -Hdr r%IDs% w150 x-5 backgroundsilver XXXcBlack, name
			loop %IDs%
			{
				thisID := IDs%A_INdex%
				WinGetTitle, thisTitle, ahk_id %thisID%
				RegExMatch(thisTitle, RegExp, Match)
				LV_Add("", Match1)
			}
		}

		if (cycleWindow_UseThumbnails)
			gosub fashionThumbnail
		
		xpos := A_ScreenWidth - 150 - 5
		
		Gui %cycleWindow_ListViewGUI%: Show, NoActivate x%xpos% yCenter, cycleWindow ;this gui must be ontop of the others
		
		gui %cycleWindow_ListViewGUI%: show, NoActivate
		;WHAT????!!!
		
	return
	
	fashionThumbnail:
		boxWidth := round(A_ScreenWidth * 4/5)
		boxHeight  := round(A_ScreenHeight * 4/5)
				
		Gui %cycleWindow_ThumbnailGUI%: color, %cycleWindow_thumbnailColor%
		Gui %cycleWindow_ThumbnailGUI%: -Caption +ToolWindow +LastFound -AlwaysOnTop ; +Border ;+toolwindow is there to make transparency work
		
		if (cycleWindow_thumbnailColor = 0) {
			Gui %cycleWindow_ThumbnailGUI%: color, EEAA99
			WinSet, TransColor, EEAA99 
		}
		
		;when you have aero transparency, it's actually a very cool effect if you don't use this WinSet command
		destinationHandle := WinExist()
		/*
		loop %IDs%
		{
			Gui %A_Index%: color, EEAA99
			Gui %A_Index%: -Caption +ToolWindow +LastFound ; +Border ;+toolwindow is there to make transparency work
			WinSet, TransColor, EEAA99
			destinationHandle := WinExist()
		} 
		*/
		loop %IDs%
		{
			sourceHandle := IDs%A_Index%
			hThumb%A_Index% := Thumbnail_Create(destinationHandle, sourceHandle)
			
			;hThumb := hThumb%A_Index%
			;cycleWindow_debugMsg("added thumbnail`rindex: " . A_Index . "`rhthumb: " . hThumb)
			;sleep 500
			
		}
		
		;Gui 3:  -caption +Toolwindow +LastFound +AlwaysOnTop
		;Gui 3: color, 949494
		;Gui 3: Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight% NA, grayVeil
		;WinSet, transparent, 200
	return
	
	showThumbnail_i:
				
		Gui %cycleWindow_ThumbnailGUI%: show, Hide
		
		;hide all thumbnails
		loop %IDs%
		{
			hThumb := hThumb%A_Index%
			bool := Thumbnail_Hide(hThumb)
			
			cycleWindow_debugMsg("hid thumbnail`rindex: " . A_Index . "`rhthumb: " . hThumb . "`nbool : " . bool)
			;sleep 500
		}
		hThumb := hThumb%i%
		
		sourceHandle := IDs%i%
		cycleWindow_debugMsg("THUMBNAIL`rsource: " . sourceHandle . "`n(hThumb : " . hThumb . ")")

		Thumbnail_GetSourceSize(hThumb, wSource, hSource)
		; REGION
			wDest := wSource
			hDest := hSource
			
			if (cycleWindow_shrinkThumb)
			{
		;		msgbox wDest %wdest%`nhDest %hdest%
				if (hDest > boxHeight){
					ratio := boxHeight / hDest
					hDest := boxHeight
		;		    msgbox original wDest %wDest%
					wDest := Round(wDest * ratio)
		;		    msgbox new wDest %wDest%
				}
		;		msgbox wDest %wdest%`nhDest %hdest%
				
				if (wDest > boxWidth){
					ratio := boxWidth / wDest
					wDest := boxWidth
		;		    msgbox original hDest %hDest%
					hDest := Round(hDest * ratio)
		;		    msgbox new hDest %hDest%    
				}
		;		msgbox wDest %wdest%`nhDest %hdest%
			}
			
			
			bw := cycleWindow_thumbnailBorder
			guiW := wDest + (2*bw)
			guiH := hDest + (2*bw)
			
			
			;Thumbnail_SetRegion(hThumb, 0, 0, wDest, hDest, 0, 0, hSource, hSource)
			Thumbnail_SetRegion(hThumb, bw, bw, wDest, hDest, 0, 0, hSource, hSource)
			;xDest, yDest
			;wDest, hDest
			;xSource, ySource
			;wSource, hSource

			
			WinGetPos, xPos, yPos, , , ahk_id %sourceHandle%
			xPos -= bw
			yPos -= bw
			
			
			
			
			Thumbnail_Show(hThumb) ; but it is not visible now...
			;Gui %cycleWindow_ThumbnailGUI%: Show, w%wDest% h%hDest% x%xPos% y%yPos% ; ... until we show the GUI
			Gui %cycleWindow_ThumbnailGUI%: Show, w%guiW% h%guiH% x%xPos% y%yPos% ; ... until we show the GUI
		
			gui %cycleWindow_ListViewGUI%: show, Noactivate ;put it on top of gui 2
	return

	destroyThumbnails:
		loop %IDs%
			{
				hThumb := hThumb%A_Index%
				bool := Thumbnail_Destroy
				
				cycleWindow_debugMsg("destroyed thumbnail`rindex: " . A_Index . "`rhthumb: " . hThumb . "`nbool : " . bool)
				;sleep 500
			}	
	return
	
	exitThread:
		Gui %cycleWindow_ListViewGUI%: destroy
		if (cycleWindow_UseThumbnails) {
			
			
			if (cycleWindow_disableThumbFade)
				Gui %cycleWindow_ThumbnailGUI%: Destroy
			else
				cycleWindow_fadeOutThumbnail(cycleWindow_ThumbnailGUI)
			
		}
		
		keywait, %cycleWindow_holdKey%, T1 ;prevents hotkey from reactivating before user can "lift his finger".
		cycleWindow_debugMsg("waiting for cycle key to lift`nCycle Key: " . getkeystate(cycleWindow_cycleKey) . "`nHold Key: " . getkeystate(cycleWindow_holdKey))
		keywait, %cycleWindow_cycleKey%, T5 ;this doesn't seem to work. Using option "L" just adds 1s delay no matter what.
		cycleWindow_debugMsg("")
		;Hotkey, *%cycleWindow_cycleKey%, off
		Critical, off
		exit
	return
	
	
	;winCycle_doNothing:
	;sendinput q
;	return
		
	showWindow_i:
		gosub ListView_highlight_i
		
		if (cycleWindow_UseThumbnails) {
			gosub showThumbnail_i
		}
		else
			WinActivate, ahk_id %win%
	return
	
	ListView_highlight_i:
		LV_Modify(i, "+Select").
	return

	decrement_i:
		i-- 
		if (i < 1)
			i := IDs ;# of elements in array IDs
	return
	increment_i:
		i++
		if (i > IDs)
			i := 1
	return
	onlyOne:
		win = % IDs%i%
		WinActivate, ahk_id %win%
		

		KeyWait, %cycleWindow_cycleKey%, T1
		if ErrorLevel ;if it timed out (the user held down the keys)
			run %pathToRun%
		;;;if (GetKeyState(cycleWindow_cycleKey, "P") and GetKeyState(cycleWindow_holdKey))
;;;			run %pathToRun%
	return


}

cycleWindow_debugMsg(msg) {
	;Coordmode, tooltip, screen
	;tooltip %msg%, %A_ScreenWidth%, %A_ScreenHeight%
}

cycleWindow_fadeOutThumbnail(guiNum) {
	global cycleWindow_ThumbnailGUI := guiNum
	Gui %cycleWindow_ThumbnailGUI%: +LastFound
	WinSet, transparent, 245
	SetTimer, incrementFade, 25
	return
	
	incrementFade:
		Gui %cycleWindow_ThumbnailGUI%: +LastFound
		WinGet, id, id
		WinGet, transparency, transparent, ahk_id %id%		
		transparency -= 26 ;52
		winset, transparent, %transparency%
		WinGet, transparency, transparent, ahk_id %id%		


		if (transparency <= 0) {
			Gui %cycleWindow_ThumbnailGUI%: Destroy
			settimer, incrementFade, off
		}
	return
}
/*
	Group: Examples
		(begin code)
			CapsLock & e::cycleWindow("ahk_class CabinetWClass","(.*)", "C:\Users\Jon\School\Fall11") ;Windows Explorer
			CapsLock & n::cycleWindow("Notepad2","(.*) - Notepad2", "C:\Program Files (x86)\1-Utilities\Notepad2 AHK\Notepad2(AHK).exe") 
			CapsLock & i::cycleWindow("- Google Chrome","(.*) - Google Chrome", "C:\Users\Jon\AppData\Local\Google\Chrome\Application\chrome.exe") 
			CapsLock & v::cycleWindow("VLC media player", "(.*) - VLC media player", "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe")
		(end)	
*/