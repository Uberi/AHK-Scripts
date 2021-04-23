#NoEnv ;this is necessary
#Include Thumbnail lib.ahk
; ^ Thumbnail lib.ahk can be found at http://www.autohotkey.com/forum/viewtopic.php?t=70839

/*	===== Possible Ideas =====
		+	Use 2 GUIs for thumbnail display to prevent flicker between cycles (overlapping their lifespan so that there is never a splitsecond where no thumbnail is being displayed)
		+	Round the corners of the GUI which shows the thumbnail
*/

/*
	Title: cycleWindow.ahk
		
		Allows user to tab through a narrowed subset of windows, as one would alt-tab through the set of all visible windows, or open a new window by launching a path, all in a single hotkey.
		
		Requires maul.esel's library "Thumbnail Lib.ahk" (http://www.autohotkey.net/~maul.esel/ThumbnailLib/Thumbnail%20Lib.ahk).
		
		Info:
		
			cycleWindow Version: 1.22

			Forum Link: http://www.autohotkey.com/forum/viewtopic.php?t=71596

			Author: Jon Smithers

			AutoHotkey Version: 1.0.48.05
		
			Platform: Windows Vista, Windows 7
*/




;NO return statement here

/*
	Group: Functions
	
	function: cycleWindow
	
	Cycles through a subset of windows or launches a path. 
		
	Parameters:
		title - Determines which windows will be included in the subset. This can be a title, like "Notepad", or something like "ahk_class CabinetWClass". Windows without a title are automatically removed. If this parameter is blank, the subset will include all windows, except those with blank titles, the Start Button window, as well as the bottom window, which is always "Program Manager". You can also employ a much more complicated and flexible method of determining the subset by putting "|" as the first character. See the "Inclusion/Exclusion" section below.
		regExp - A regular expression that describes how to trim the title of each window in the subset for display in the ListView. The listview will display only the first group in the regular expression. By default, regExp is "([^-]*).*". Simply putting "" will yield the same result. Specify the regular expression "(.*)" to not trim anything from the title. Specify "0" to not display the ListView at all. This parameter is useful because you may not want to see (for example) the " - Google Chrome" at the end of every Chrome window title. Specifying "(.*) - Google Chrome" here will trim that out. For more info on regular expressions, see <http://www.autohotkey.com/docs/misc/RegEx-QuickRef.htm>.
		pathToRun - The path used to open a new window in the case that no existing windows currently match the criteria to be in the subset, or in the case that you are holding the "cycleWindow_NewWindowKey" (which is initially set to "LWin") when the hotkey is pressed.
		
	Inclusion/Exclusion:
		This is a mode where cycleWindow uses a much more flexible and complex method of determing the subset. To use inclusions/exclusions, the first character of the title parameter must be "|".
		
		Format - "| includeCriteria_1, includeCriteria_2, ..., includeCriteria_X | excludeCriteria_1, excludeCriteria_2, ..., excludeCriteria_Y "
				
		The comma-separated list after the first "|" comprises the Inclusions. The comma-separated list after the second "|" comprises the Exclusions. Each criteria can be a window title, or a window class if it is preceded with "ahk_class" (only titles and classes are supported). 
		
		Commas should only be placed BETWEEN criteria of a comma-separated list (never at the end).
		
		It is also possible to specify 0 inclusions or 0 exclusions. Specifying 0 inclusions will include ALL windows except those that match the specified exclusions. Specifying 0 exclusions will simply not exclude any of the windows that match the specified inclusions.
		
		
	
	SETTINGS:
	
		A few easily-changeable tweaks that affect how the function acts.
		
		These can be found in the beginning lines of the function in cycleWindow.ahk. If you want these settings to differ between various calls of <cycleWindow>, you can add them as optional parameters to <cycleWindow>.
		
		cycleWindow_UseThumbnails - If you have Windows Vista or later, you can use window thumbnails. This is a nice way to show a window without having to actually activate it. This is the preferred way, but requires maul.esel's library from <http://www.autohotkey.com/forum/viewtopic.php?t=70839>.
		cycleWindow_thumbnailColor - Thumbnails are displayed on a GUI. This GUI, which is underneath the thumbnails, can be transparent or opaque. If you are using Aero (so the borders of your windows are transparent), having a colored GUI behind the thumbnails creates a nice highlighting effect. Specify the color of the highlight in this setting. To disable highlight, set it to "0" (this might be desirable if you don't use aero transparency).
		cycleWindow_thumbnailBorder - Thumbnails are displayed on a GUI. This determines how many pixels the GUI should extend out from behind the thumbnail, creating a border. If you are using Aero, the highlighting effect should be enough, so set this to 0.
		cycleWindow_disableThumbFade - Disables the highlight-fading that occurs when your release your finger from the holdkey (e.g. CapsLock). This feature uses the only global variable in <cycleWindow>.
		cycleWindow_ListViewGUI - The GUI number (1-99) that will be used to create the ListView which shows the window titles.
		cycleWindow_ThumbnailGUI - The GUI number (1-99) that will be used to create the windows' thumbnails (if cycleWindow_UseThumbnails is set to true).
		cycleWindow_matchMode - TitleMatchMode. Used with AHK's SetTitleMatchMode (http://www.autohotkey.com/docs/commands/SetTitleMatchMode.htm) to set how windows are to be searched with the title parameter. It has been set to 2, meaning that if a window contains *title*'s text anywhere in its title, it is considered a match. 
		cycleWindow_ListViewWidth - The width (in pixels) of the ListView. Increasing the width will cause the ListView to extend farther into the center of the screen. This is set initially to 200.
		cycleWindow_NewWindowKey - If this key is held down when you press the cycle key, the function launches a new window by running the path of the parameter pathToRun. It is set initially to "LWin".
		cycleWindow_reverseKey - If this key is held down when you press the cycle key, the function cycles backwards instead of fowards (like shift in Alt-Tab).
*/
cycleWindow(title="", regExp ="([^-]*).*", pathToRun="") {
	;Increase Thread Speed
	SetBatchLines, -1
	SetWinDelay, -1
	
	; ===== Settings =====
	cycleWindow_UseThumbnails := true
	cycleWindow_thumbnailColor := "FFFF00" ;"94D8F5"
	cycleWindow_thumbnailBorder := 0	
	cycleWindow_disableThumbFade := false
	cycleWindow_ListViewGUI := 1
	cycleWindow_ThumbnailGUI := 2
	cycleWindow_matchMode := 2
	cycleWindow_ListViewWidth := 200 ;150
	cycleWindow_NewWindowKey := "LWin"
	cycleWindow_reverseKey := "Shift"
	cycleWindow_useReverseKey := true
	;consider adding these as optional parameters for this function.
	; ====================
	
	SetTimer, incrementFade, off
	gui %cycleWindow_ThumbnailGUI%: Destroy
	;incase the thumbnail-fading fro the previous function-call of windowCycle hasn't finished it, cut it off now
	
	cycleWindow_debugMsg("(" . A_ThisHotkey . ")")
	thisHotkey := A_ThisHotkey
	RegExMatch(thisHotkey, "(.*) & (.*)", Match)
	   cycleWindow_cycleKey := Match2
	   cycleWindow_holdKey := Match1
	
	Gui %cycleWindow_ListViewGUI%: +Owner	;prevent button from showing on taskbar
	
	if (regExp = "") {
		regExp := "([^-]*).*"	;if you SPECIFICALLY put "" for regExp, it will show the whole title in the list view
	}


	if (title = "") {
		WinGet, IDs, list, %title%, , 
		gosub removeAllExtraneousWindows ;ProgramManager, Start, and Blank Titles
	}
	else if (substr(title, 1, 1) = "|") ;first character is "|"
	{
		gosub include_exclude
	}
	else {
		SetTitleMatchMode %cycleWindow_matchMode%		
		WinGet, IDs, list, %title%
		gosub removeBlankTitles
	}

	
	
	i := 1
	

	
	
	if (IDs = 0) OR (getKeyState(cycleWindow_NewWindowKey)) {
		run %pathToRun%
		gosub exitThread
	}
	if (IDs = 1) {
		gosub onlyOne
		gosub exitThread
	}

	gosub fashionListView
	
    	    
	loop
	{
		If (A_Index = 1) {
			win = % IDs%i%
			IfWinActive, ahk_id %win% ;if it's already activated, activate the next one
			{
				if (!getKeyState(cycleWindow_reverseKey))
					gosub increment_i
				else
					gosub decrement_i
				
				win = % IDs%i%
			}
		}
		gosub showWindow_i
		cycleWindow_debugMsg("Win " . i)

		if (cycleWindow_useReverseKey)
		{
			KeyWait, %cycleWindow_cycleKey%, T0.4	;wait for release of cycleKey, timeout after 400ms
		
			;The following loop waits for either
			; 	1 - cycleKey to be pressed (or held down)
			;	2 - holdKey to be released
			loop {
				if (!getKeyState(cycleWindow_holdKey, "P")) {
					win = % IDs%i%
					WinActivate, ahk_id %win%
					gosub exitThread					
				}
				if (getKeyState(cycleWindow_cycleKey, "P")) {
					break
				}
			}
		}
		else
		{
			loop {
				if (!getKeyState(cycleWindow_holdKey, "P")) {
					if (!getKeyState(cycleWindow_cycleKey, "P")) {
						win = % IDs%i%
						WinActivate, ahk_id %win%
						gosub exitThread
					}
					else {
						gosub decrement_i
						win = % IDs%i%
						continue
					}
				}
				
			
			}
		}
		
		
		
		if getKeyState(cycleWindow_NewWindowKey) {
			run %pathToRun%
			gosub exitThread
		}
		
		if (getKeyState(cycleWindow_reverseKey)) {
			gosub decrement_i
		}
		else {
			gosub increment_i
		}
    }

	return
	
	fashionListView:
		if (regExp != "0")
		{
			;if (IDs <= 2) 
			;	return
			; ^ uncomment if you don't want to see ListView when there's only 2 windows
			
			Gui %cycleWindow_ListViewGUI%: +AlwaysOnTop -Caption +LastFound
			Gui %cycleWindow_ListViewGUI%: color, 96BC35
			WinSet, transcolor, 96BC35  
			Gui %cycleWindow_ListViewGUI%: font, s16, Verdana  
			Gui %cycleWindow_ListViewGUI%: Add, ListView, NoSort -Multi -grid -Hdr r%IDs% w%cycleWindow_ListViewWidth% x-5 backgroundsilver, name
			loop %IDs%
			{
				thisID := IDs%A_INdex%
				WinGetTitle, thisTitle, ahk_id %thisID%
				Match1 := "failed match"
				RegExMatch(thisTitle, RegExp, Match)
				LV_Add("", Match1)
			}
		}

		if (cycleWindow_UseThumbnails)
			gosub fashionThumbnail
		
		xpos := A_ScreenWidth - cycleWindow_ListViewWidth - 5
		
		Gui %cycleWindow_ListViewGUI%: Show, NoActivate x%xpos% yCenter, cycleWindow ;this gui must be ontop of the others
	return
	
	fashionThumbnail:
		boxWidth := round(A_ScreenWidth * 4/5)
		boxHeight  := round(A_ScreenHeight * 4/5)
				
		Gui %cycleWindow_ThumbnailGUI%: color, %cycleWindow_thumbnailColor%
		Gui %cycleWindow_ThumbnailGUI%: -Caption +ToolWindow +LastFound -AlwaysOnTop ; +Border ;+toolwindow is there to make transparency work
		
		if (cycleWindow_thumbnailColor = 0) {
			Gui %cycleWindow_ThumbnailGUI%: color, EEAA99
			WinSet, TransColor, EEAA99 
			;when you have aero transparency, it's actually a very cool effect if you don't use this WinSet command
		}
		
		destinationHandle := WinExist()
	
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
						
			bw := cycleWindow_thumbnailBorder
			guiW := wDest + (2*bw)
			guiH := hDest + (2*bw)
			
			
			;Thumbnail_SetRegion(hThumb, 0, 0, wDest, hDest, 0, 0, hSource, hSource)
			Thumbnail_SetRegion(hThumb, bw, bw, wDest, hDest, 0, 0, wSource, hSource)
			;xDest, yDest
			;wDest, hDest
			;xSource, ySource
			;wSource, hSource
			
			
			WinGetPos, xPos, yPos, , , ahk_id %sourceHandle%
			xPos -= bw
			yPos -= bw
			
			
			
			
			Thumbnail_Show(hThumb) ; but it is not visible now...
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
	
	
	removeAllExtraneousWindows:
		IDs-- ;removes Program Manager, which is always at the end
		gosub removeBlankTitles
		;gosub printtitles
		gosub removeStart
		;gosub printtitles
	return
	
	removeBlankTitles:
		; make TITLES list
		loop %IDs%
		{
			WinGetTitle, titles%A_Index%, % "ahk_id "IDs%A_Index%			
		}
		
		
		loop %IDs%
		{
				;tooltip Checking title %A_Index%.
				;gosub printTitles


			if (titles%A_Index% = ""){
				index := A_Index
				nextIndex := A_Index
			
				;tooltip %index% is blank.
				;gosub printTitles
				
				loop
				{
					nextIndex++
										
						;tooltip switching %index% with %nextIndex%
						;gosub printTitles
					
					temp := titles%Index%
					titles%Index% := titles%nextIndex%
					titles%nextIndex% := temp
					
						;tooltip switched %Index% with %nextIndex%
						;gosub printTitles
					
					if (titles%index% != "") {
						; apply same change to the IDs list
						temp := IDs%index%
						IDs%Index% := IDs%nextIndex%
						IDs%nextIndex% := temp
						
						;tooltip %index% is no longer blank!
						;gosub printTitles
						
						break
					}
					else {
						;msgbox still blank!
						if (nextIndex >= IDs) {
							;tooltip WE REACHED THE END!!`rnextIndex %NextIndex%`rIds %ids%`rindex %index%
							;gosub printTitles
							IDs := index - 1
							;gosub printTitles
							goto removeBlankTitles__finished
						}
					}
				}
			}
		}
		removeBlankTitles__finished:
	return
	
	removeStart:
		loop %IDs%
		{
			if (titles%A_Index% = "Start"){
				WinGetClass, Temp, % "ahk_id " . IDs%A_Index%
				if (Temp = "Button") {
					index := A_Index
					nextIndex := A_Index + 1
					
					loop {
						titles%Index% := titles%nextIndex%
						IDs%Index% := IDs%nextIndex%

						if (nextIndex >= IDs) {
							IDs--	;only removed 1 window
							goto removeStart__finished
						}
						
						index++
						nextIndex++				
						
					}
				}
			}
			
		}
		removeStart__finished:
	return
	
	printTitles:
		msg := ""
		loop %IDs%
		{
			msg .= A_Index . ": " . titles%A_Index% . "`r"
		}
		msgbox, % msg

	return
	
	printPreTitles:
		msg := ""
		loop %preIDs%
		{
			msg .= A_Index . ": " . preTitles%A_Index% . " {" . preClasses%A_Index% . "}`r"
		}
		msgbox, % msg
	return
	
	include_exclude:

		;Separate inclusions/exclusions into 2 separate strings
		loop, parse, title, |, %A_Space%
		{
			if (A_Index = 1)
				continue	;first character is "|", so first loopfield will be blank
			
			if (A_Index = 2)
				Inclusions := A_Loopfield
			
			else if (A_Index = 3)
				Exclusions := A_Loopfield
		}
		;msgbox Inclusions "%inclusions%"`rexclusions "%exclusions%"
			
		if (Inclusions != "") {
			
			;get ID's of ALL windows
			WinGet, preIDs, List

			
			;Create these lists (for ALL windows):
			;	preTitles
			;	preClasses
			loop %preIDs%
			{
				WinGetTitle,  preTitles%A_Index%, % "ahk_id "preIDs%A_Index%
				WinGetClass, preClasses%A_Index%, % "ahk_id "preIDs%A_Index%
			}
			
			;debug
			;tooltip as is....
			;gosub printPreTitles
			
			IDs := 0
			
			;make a list of windows that fit the specified inclusions
			loop %preIDs% {
				;index_in_preIDs := %A_Index%
				
				;these are the attributes of the window to be examined
				testWin_ID    := preIDs%A_Index%
				testWin_Class := preClasses%A_Index%
				testWin_Title := preTitles%A_Index%
				
				
				
				
				;if the window matches, %include% will be changed to "true" by the end of this loop
				include := false
				loop, parse, Inclusions, `,, %A_Space%
				{
					;debug
					;debugMsg = Testing Window`rTitle: %testWin_Title%`rClass: %testWin_Class%
	;				tooltip %testWin_Title%`rvs`r%A_Loopfield%
	;				sleep 50
					
					;if the inclusion is an ahk_class, not a window title...
					RegExMatch(A_Loopfield, "^ahk_class +(.+)", temp)		;I'm not sure which of these lines would be fastest
					if (temp1 != "") {	;if (regexMatch(A_Loopfield, "^ahk_class")) { ;if (substr(A_Loopfield, 1, 9) = "ahk_class") {
										;temp := RegExMatch(A_Loopfield, "^ahk_class +(.+)")	;temp := substr(A_Loopfield, 11)
									
						;if the inclusion actually matches...
						if (temp1 = testWin_Class) {
							IDs++
							IDs%IDs% := testWin_ID
							titles%IDs% := testWin_Title

							;debug
	;						tooltip ADDED CLASS %temp1%
	;						gosub printTitles
						}
					}
					
					;if the inclusion is a window title and actually matches...
					else if (inStr(testWin_Title, A_Loopfield)) { ;if (A_Loopfield = testWin_Title) { 				
						IDs++
						IDs%IDs% := testWin_ID
						titles%IDs% := testWin_Title					
						
						;debug
	;					tooltip ADDED TITLE %testWin_Title%
	;					gosub printTitles
					}
					
					
				}
				
			
			}
		
		}
		else { 	;if (Inclusions = "")
			WinGet, IDs, list, , ,
			gosub removeAllExtraneousWindows
			
			if (regExp = "")e
				regExp := "([^- ]*).*"			
		}
		
		;code above this point does the INCLUDING
		;now to commence the EXCLUDING...
		
;;;		gosub printTitles
		
		loop, %IDs%
		{
			;A_Index - The window in the list which we're checking for excludability
;;;			msgbox (loop 2)`rIncluded Windows`rIndex %A_INDex%

			if (A_Index > IDs)
				break

			index := A_Index	;the index of the window IDs whome we are checking
			shiftIndex := index
			shiftNextIndex := index + 1

			loop {
				;A_Index - how many times we've checked this cell
;;;				msgbox (loop 3) `rCHECK EXCLUDABILITY for cell %index%
				
				;label___redo_iteration_of_exclude_loop:
				
				WinGetClass, testWin_Class, % "ahk_id " IDs%index%
				WinGetTitle, testWin_Title, % "ahk_id " IDs%index% 
				;msgbox title: %testWin_title%`rclass %testwin_class%
				
				loop, parse, Exclusions, `,, %A_Space%
				{
					;A_Index - The user-specified exclusion
;;;					tooltip loop 4`rCOMPARE with EXCLUSIONS for cell %index%`rExclusion %A_Index%: %a_loopfield%
;;;					gosub printTitles
					
					RegExMatch(A_Loopfield, "^ahk_class +(.+)", temp)
				
					if ((temp1 != "") AND (temp1 = testWin_Class)) OR (inStr(testWin_Title, A_Loopfield)) {
;;;						tooltip Exclude %A_loopfield%
					
						shiftNextIndex := shiftIndex + 1
						
						loop
						{
							;A_Index - How many shifts we've had to make having not yet reached the end of the list IDs
;;;							tooltip loop 5`rShift Following Windows`rMove %shiftnextindex% to %shiftindex%`r(# of shifts %A_Index%)`rExclude "%A_loopfield%"
;;;							gosub printtitles
							
							titles%shiftIndex% := titles%shiftNextIndex%
							   IDs%shiftIndex% :=    IDs%shiftNextIndex%
							
							shiftIndex++	
							shiftNextIndex++

							if (shiftNextIndex - IDs = 1) {
;;;								tooltip Exclude %A_loopfield%`rshiftNextIndex - IDs = (%shiftnextindex%) - (%IDs%) = 1`rFINISHED SHIFTING CELLS`rRecheck the initial cell
								IDs--
								
;;;								gosub printTitles
								shiftIndex := index
								shiftNextIndex := shiftIndex + 1
								goto label__continue_loop
								;goto label___redo_iteration_of_exclude_loop
								;msgbox This line of code never will never get run
							}
							else if (shiftNextIndex - IDs = 2) {
								IDs--
;;;								tooltip shiftIndex: %shiftindex%`rshiftnextindex: %shiftnextindex%`rIDs: %ids%
;;;								gosub printTitles
								tooltip
								break
								
							}
							else if (shiftNextIndex - IDs > 1) { 
								msgbox what is going on?`rIds %ids%`rshiftnextIndex %shiftnextindex% `rshiftindex %shiftindex%
								break	
							}
							else {
;;;								tooltip Exclude %A_loopfield%`rI have not reached the end of the IDs List 
								continue
							}
							
						}
						;msgbox this code would get run
					}
					
				}

					break				
				label__continue_loop:
					continue

			}
		
		}
		
		
		

		
		tooltip
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
		LV_Modify(i, "+Select")
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
	WinSet, transparent, 255
	WinGet, transparency, transparent
	
	SetTimer, incrementFade, 25
	return
	
	incrementFade:
		
		Gui %cycleWindow_ThumbnailGUI%: +LastFound
		WinGet, id, id
		
		
		WinGet, transparency, transparent, ahk_id %id%		
		;tooltip FADE %ID% from %transparency%
		
		if (transparency = "") {
			WinSet, transparent, 255, ahk_id %id%
			WinGet, transparency, transparent, ahk_id %id%		
			
		}
		transparency -= 26 ;13 ;52
		winset, transparent, %transparency%
		WinGet, transparency, transparent, ahk_id %id%		


		if (transparency <= 0) {
			Gui %cycleWindow_ThumbnailGUI%: Destroy
			settimer, incrementFade, off
		}
	return
}
/*
	function: cycleCurrentWindow
	
	Cycles through windows of the same class as the currently active window. This function simply gets the class of the active window, and passes it as a parameter to <cycleWindow>.
	
*/
cycleCurrentWindow(regExp ="([^-]*).*") {
	WinGetClass, class, A
		
	cycleWindow("ahk_class " . class, regExp)
}








/*
	Group: Examples
		(begin code)
			CapsLock & e::cycleWindow("ahk_class CabinetWClass", "", "C:\Users\Jon\School\Fall11") ;Windows Explorer
			
			CapsLock & p::cycleWindow("ahk_class MSPaintApp", "(.*) - Paint", "mspaint")
			
			CapsLock & v::cycleWindow("VLC ahk_class QWidget", "(.*) - VLC media player", "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe")
			
			CapsLock & i::cycleWindow("- Google Chrome", "(.*) - Google Chrome", "C:\Users\Jon\AppData\Local\Google\Chrome\Application\chrome.exe") 
			
			CapsLock & n::cycleWindow("ahk_class Notepad2U", "(.*) - Notepad2", "C:\Program Files (x86)\Notepad2\Notepad2.exe") 
			
			CapsLock & c::cycleCurrentWindow("([^\-]+).*")
		(end)	
*/

/*	
	Group: Changes
	
	5/10/2011-5/11/2011:
		+ fixed thumbnail-sizing bug occuring when corresponding window was about full height of the screen ('twas a silly mistake)
		+ removed obsolete cycleWindow_shrinkThumb setting
		+ removed Critical command from top of function, fixing some really weird issues resembling buffered hotkey threads (even though "#MaxThreadsBuffer" was off)
		+ fixed the highlight-fading's "cutting-out" issue, which was mostly accomplished through the change immediately above
		+ added ability to change ListView width
		
		The above changes constituted the 1.1 update
		
	5/13/2011:
		+ user can now cycle backwards on the first iteration (in the case that a window in the subset is already active), whereas before user could only cycle backwards on the second iteration and after.
		+ all parameters for cycleWindow are optional now
		+ the function always removes windows with blank titles from the list
		+ when all parameters are omitted, the function will also remove "progman" and "start". It also automatically uses the regex "([^\-]+).*" to display the title.
		+ the default regex for cycleCurrentWindow is "([^\-]+).*" as well, instead of "(.*)"

	5/20/2011-6/1/2011:
		+ Inclusion/Exclusion - much more flexible and complex way to narrow subset
		+ function only removes blank titles when the title parameter is blank (or excluded) or there are no inclusions specified within the title parameter (in the inclusion/exclusion mode)
		+ Added code that removes the specific "Start, ahk_class Button" window from the list rather than simply excluding all windows with "Start" in their title. This code is run whenever the removeBlankTitles code is run.
		+ modified default regexes	
		+ ListView width is now set initially to 200
		
		The above changes constituted the 1.2 update
		
	6/2/2011:
		+ Removed accidental "." from the end of the line LV_Modify(i, "+Select"), which may have prevented use with AHK_L. (update 1.21)
		+ Tidied up code for removing extraneous windows. The code for removeBlankTitles will ALWAYS get run (as before). However, other extraneous windows, like "Start" and "Progman", get removed when the title parameter is blank, or there are 0 inclusions. 
		+ Fixed bug in removeStart code for "Start, ahk_class Button" where the last window in the list would be excluded. (update 1.22)
		
*/
;	Current Known Issues:
