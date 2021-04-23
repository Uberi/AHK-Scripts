#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#Singleinstance force
#include gdip.ahk


CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

Gui, +Owner  ; +Owner prevents a taskbar button from appearing.
Gui, Color, 000000
Gui, font, cWhite W100 s8, Verdana
Gui, Add, Text, vMyText x5 y5 w250 r3
Gui, +ToolWindow
Gui, +AlwaysOnTop
Gui, Show, NA x0 yCenter w250 h75
Gui, +Resize
Gui, Add, Picture, vMyPic w5 x5

updateOSD("Idle")
toggle = 0
#MaxThreadsPerHotkey 2
#InstallMouseHook

currentItem := "temp"


if (!pToken:=Gdip_Startup()) {
      msgbox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
      ExitApp
   }
   
blocks = stone, cobble, sand, sandStone, glass, stoneBricks, netherRack, netherBrick, dirt, gravel
metals =  goldOre, ironOre, goldBar, ironBar
misc = coal, wood, darkWood, birch, planks, cactus, clayBalls, sign, sugarCane, pumpkin
food = rawPork, rawChicken, rawBeef, rawFish, pork, chicken, beef, fish, wheat, bread, melon, eggs
GroupList := blocks, metals, misc, food

*F4:: ;auto types /home. Use when you fall into lava, start drowning, or to escape a hissing creeper after a skeleton pushes you off of a ledge
	BlockInput,  Send
	Send, t
	sleep 100
	SendInput, {Raw}/home
	sleep 100
	SendInput, {Enter}
	BlockInput, Off
	return
 
^0::  ;get user input for setup
{
	KeyWait Control
	UpdateOSD("Choose a block group to view member blocks. Click submit to start respective setup.")
	Gui, Add, DropDownList, vGroupChoice gChoiceDisplay lowercase, Blocks|Metals|Misc|Food
	Gui, Add, Text, vBlockList cWhite w250 r3
	Gui, Add, Button, default y+20, Submit
	Gui, Add, Button, x+20 , Cancel
	Gui, Show, x0 yCenter AutoSize
	return
}

ChoiceDisplay:
	Gui Submit
	sometext := %GroupChoice%
	GuiControl,, BlockList, %sometext%
	Gui, Show, x0 yCenter AutoSize
	;GuiControl, Focus, vGroupChoice
return

ButtonSubmit:
	Gui Submit
	GuiControl, Hide, GroupChoice
	GuiControl, Hide, BlockList
	GuiControl, Hide, Ok
	GuiControl, Hide, Cancel
	refreshOSD()
	setup(GroupChoice)
return

ButtonCancel:
	GuiControl, Hide, GroupChoice
	GuiControl, Hide, BlockList
	GuiControl, Hide, Ok
	GuiControl, Hide, Cancel
	updateOSD("Idle")
	refreshOSD()
return
	

setup(blockGroup)
{
	global
	updateOSD("**** Press Space when ready ****")
	KeyWait, Space, Down
	field_begin := 0
	Loop, parse, %blockGroup%, CSV, %A_Space%
	{
		updateOSD("Click on block type " A_LoopField)
		 x := saveBMP(A_LoopField)
		refreshOSD()
	}
	;set Inventory text Divider
	if(getInvDivYPos() == 2) ;if this is true then ErrorLevel = 2 after  an ImageSearch attempt. Meaning the file DNE. 
	{
		updateOSD("Click: 'Inventory' Text")
		KeyWait, LButton, D
		MouseGetPos, TempX, TempY
		KeyWait, LButton
		MypBitmap := Gdip_BitmapFromScreen((TempX-40) "|" (TempY-5) "|" 80 "|"10)
		elevel := Gdip_SaveBitmapToFile(MypBitmap, "InvDiv.bmp") 
		if(elevel = 0)
			updateOSD("Saved successfully")
		DeleteObject(MypBitmap)	
		updatePic("*w0 *h0 InvDiv.bmp")
	}
	return
}

saveBMP(block)
{
	KeyWait, LButton, D
	MouseGetPos, TempX, TempY
	KeyWait, LButton
	TLX := TempX - 8
	TLY := TempY - 8
	BW := 16
	BH := 16
	BlockInput, MouseMove
	Sleep 100
	Click
	MouseMove, 200, 200, R
	Sleep 500
	MypBitmap := Gdip_BitmapFromScreen(TLX "|" TLY "|" BW "|" BH)
	updateOSD(Gdip_SaveBitmapToFile(MypBitmap, block ".bmp") )
	DeleteObject(MypBitmap)
	MouseMove, TempX, TempY
	BlockInput MouseMoveOff
	updatePic("*w0 *h0 " block ".bmp")
	refreshOSD()
return 1
}

^z:: ;shows the blocktype of "currentItem" and also prints some hotkey info
{
	KeyWait Control ;possibly helps deal with Windows aggresive control key monitoring. Used to have it where the game was in focus but pressing ESC sends a CTRL + ESC and therefore opening the start menu. Annoying. Don't remember if this fixed it. The gui stealing focus when it updates might have caused it too.
	updateOSD("auto-furnace ^c, stash all ^b, get all ^n, toss junk ^f")
	updatePic("*w0 *h0 " currentItem ".bmp")
	return
}

^b:: ;puts all "currentItem" from player inventory into entity inventory (chests)
{
	KeyWait Control
	stashAll(currentItem)
return
}

^n:: ;takes all "currentItem" from entity inventory and puts into player inventory
{
	KeyWait Control
	retrieveAll(currentItem)
return
}	


^o:: ;get furnace info
{
	updateOSD("Click: Furnace Load Slot (Raw)")
	KeyWait, LButton, D
	KeyWait, LButton
	MouseGetPos, TempX, TempY
	FurnaceLoadX := TempX
	FurnaceLoadY := TempY
	updateOSD("Click: Furnace Output Slot (Cooked)")
	KeyWait, LButton, D
	KeyWait, LButton
	MouseGetPos, TempX, TempY
	FurnaceOutX := TempX	
	FurnaceOutY := TempY
	updateOSD("Click: Furnace Fuel Slot")
	KeyWait, LButton, D
	KeyWait, LButton
	MouseGetPos, TempX, TempY
	FurnaceFuelX := TempX	
	FurnaceFuelY := TempY
	SendInput, {Escape}
	updateOSD("Done")
return
}

^x:: ;Find mat at cursor
{
	KeyWait Control
	BlockInput, MouseMove
	MouseGetPos, TempX, TempY
	MouseMove, 200, 200, R	
	field_begin := 0
	sleep 150

	Loop, parse, GroupList, CSV, %A_Space%
	{
		updateOSD("Searching")
		ImageSearch, FoundX, FoundY, TempX - 30, TempY - 30, TempX + 30, TempY + 30, *30 %A_ScriptDir%\%A_LoopField%.bmp
		if ErrorLevel = 2
			updateOSD("File " %A_LoopField% ".bmp Does not exist")
		else if ErrorLevel = 0
		{
			currentItem := A_LoopField
			updateOSD("Found block " . A_LoopField)
			updatePic("*w0 *h0 " A_LoopField ".bmp")
			MouseMove, TempX, TempY
			BlockInput MouseMoveOff
			refreshOSD()
			return
		}
		else
			continue
	}
	ImageSearch, FoundX, FoundY, TempX - 30, TempY - 30, TempX + 30, TempY + 30, *30 %A_ScriptDir%\temp.bmp
	if ErrorLevel = 0
	{
		currentItem := temp
		updateOSD("Found block " . temp)
		updatePic("*w0 *h0 " temp ".bmp")
		MouseMove, TempX, TempY
		BlockInput MouseMoveOff
		refreshOSD()
		return
	}
	else
	{
		currentItem := temp
		updateOSD("Could not ID. Click to save as temp.")
		MouseMove, TempX, TempY
		BlockInput MouseMoveOff
		refreshOSD()
		saveBMP(temp)	
		updateOSD("Saved as temp successfully")
	}
	return
}


^c:: ;1 click furnace
{
	KeyWait Control
	GUIControl, Hide, MyPic
	retry := 1
	tries := 3
	BlockInput, MouseMove
	startY := getInvDivYPos()
	Click Right
	MouseGetPos, SaveX, SaveY
	Sleep 200
	startFurnaceLoad:
	ImageSearch, FoundX, FoundY, 0, startY, A_ScreenWidth, A_ScreenHeight, *40 %A_ScriptDir%\%currentItem%.bmp
	if ErrorLevel = 2
		updateOSD("File Does not exist")
	else if ErrorLevel = 1
	{
		updateOSD("Mats not found. Try :" . retry . " of " . tries)
		retry++
		if(retry < (tries + 1))
			goto startFurnaceLoad
	}
	else
	{
		updateOSD("Tracking at  x: " . FoundX . " y: " . FoundY)
		MouseMove, FoundX, FoundY
		Click
		Sleep 50
		MouseMove, FurnaceLoadX, FurnaceLoadY
		Click
		Sleep 50
		MouseMove, FurnaceOutX, FurnaceOutY
		Send, +{Click}
		Sleep 100
	}
	MouseMove, SaveX, SaveY
	SendInput, {Esc}
	Sleep 50
	BlockInput, MouseMoveOff
	GUIControl, Show, MyPic
	UpdateOSD("Done")
	return
}

^v:: ;fuel furnace
{
	KeyWait Control
	GUIControl, Hide, MyPic
	retry := 1
	tries := 3
	BlockInput, MouseMove
	startY := getInvDivYPos()
	Click Right
	MouseGetPos, SaveX, SaveY
	Sleep 200	
	startFuelLoad:
	ImageSearch, FoundX, FoundY, 0, startY, A_ScreenWidth, A_ScreenHeight, *40 %A_ScriptDir%\coal.bmp
	if ErrorLevel = 2
		updateOSD("File Does not exist: " coal ".bmp")
	else if ErrorLevel = 1
	{
		updateOSD("Mats not found. Try :" . retry . " of " . tries)
		retry++
		if(retry < (tries + 1))
			goto startFuelLoad
	}
	else
	{
		updateOSD("Tracking at  x: " . FoundX . " y: " . FoundY)
		MouseMove, FoundX, FoundY
		Click
		Sleep 50
		MouseMove, FurnaceFuelX, FurnaceFuelY
		Click
		Sleep 50
		MouseMove, FoundX, FoundY
		Click
		Sleep 50
	}
	MouseMove, SaveX, SaveY
	SendInput, {Esc}
	Sleep 50
	BlockInput, MouseMoveOff
	GUIControl, Show, MyPic
	UpdateOSD("Done")
	return
}

^k:: ;autofisher
{
    Toggle := !Toggle
    If (!Toggle){
		updateOSD("IDLE")
		return
	}
BlockInput, MouseMove
	Begin:
    If (!Toggle){
		updateOSD("IDLE")
		return
	}
	updateOSD("Casting")
		Click Right
		Sleep 2000
		BlockInput, MouseMoveOff
	
	;find the bobber on the screen
	Search:
    If (!Toggle){
		updateOSD("IDLE")
		return
	}
	ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *40 %A_ScriptDir%\bobber.png
if ErrorLevel = 2
    MsgBox Could not find the bobber image file.
else if ErrorLevel = 1
{
	updateOSD("Bobber Not Found")
   goto Search
}
else
{
   ; MsgBox The icon was found at %FoundX%x%FoundY%.
	updateOSD("Tracking at  x: " . FoundX . " y: " . FoundY)
	Sleep 100
	goto Search2
}
	;bobber was found. now track the bobber and wait for it to go underwater
	Search2:
    If (!Toggle){
		updateOSD("IDLE")
		return
	}
	ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *40 %A_ScriptDir%\bobber.png
if ErrorLevel = 2
    MsgBox Could not find the bobber image file.
else if ErrorLevel = 1
{
   updateOSD("Potential Bite")
   goto Search3
}
else
{
	updateOSD("Tracking at  x: " . FoundX . " y: " . FoundY)
   Sleep 100
	goto Search2
}
		Search3:
    If (!Toggle){
		updateOSD("IDLE")
		return
	}
	ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *100 %A_ScriptDir%\bobber.png
if ErrorLevel = 2
    MsgBox Could not find the bobber image file.
else if ErrorLevel = 1
	updateOSD("LOST THE BOBBER")
else
{
	ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *40 %A_ScriptDir%\bobber.png
	if ErrorLevel = 1
	{
		updateOSD("**REELING**")
		Click Right
		Sleep 500
		goto Begin
	}
	else
		updateOSD("Just a nibble")
		Sleep 250
		goto Search
}
updateOSD("IDLE")
return
}


^f:: ;toss all of "currentItem"
{
	KeyWait Control	
	/* This uses same code as stashAll(item) except for the clickLoop() call which adds the optional "isTossing" param
	*/
	divY := getInvDivYPos()
	if(divY = 1 OR divY = 2)
		return
	else
		clickLoop(currentItem, divY, 0, 1)
	SendInput, e
	return
}

^p:: ;QUIT
	Gui, Destroy
	Gdip_Shutdown(pToken)
	ExitApp
Return

getInvDivYPos()
{
	ImageSearch, FoundX, FoundY, 0, startY, A_ScreenWidth, A_ScreenHeight, *40 %A_ScriptDir%\InvDiv.bmp
	if(ErrorLevel = 2)
		UpdateOSD("Inventory Divider File not found, run appropriate setup.")
	else if(ErrorLevel = 1)
		UpdateOSD("Inventory Divider could not be found on screen. Stopping")
	else
		return FoundY
	return ErrorLevel
}

stashALL(item) ;performs a shift+click on all "currentItem" in player inventory
{
	divY := getInvDivYPos()
	if(divY = 1 OR divY = 2)
		return
	else
	clickLoop(item, divY)
	return
}

retrieveALL(item) ;performs a shift+click on all "currentItem" in entity inventory (chest, dispenser, etc. anywhere above "INVENTORY" text)
{
	divY := getInvDivYPos()
	if(divY = 1 OR divY = 2)
		return
	else
	clickLoop(item, 0, divY)
	return
}

clickLoop(item, startY, endY = 0, isTossing = 0) ;control loop wrapper for clickAll function. I added the "isTossing" param hackishly to add support for the throw away operation. A better solution would be making clickLoop and clickAll more generic
{
	GUI, Cancel ;Hide the GUI or the loop will be confused by the CurrentItem tooltip!
	MouseGetPos, SaveX, SaveY
	if(endY = 0)
		endY := A_ScreenHeight
	BlockInput, MouseMove
	BlockInput, On
	if(isTossing == 0) ; if I am NOT tossing the item, then I NEED to shift click
	{
		SendInput, {Shift Down}
	}
	else 				; if I AM tossing, then I NEED to open the inventory and I don't need to shift click
	{
		SendInput, e
		sleep 100
	}
	
	/* This MouseMove + Sleep Combination prevents premature loop cancellation due to how antiStuck() works.
	Moving the mouse and waiting assures that first inventory slots aren't obscured by mouse pointer hover highlight.
	*/
	MouseMove, 50, 50
	Sleep 50
	/*
	LOOP START
	*/
	Loop, 40
	{
		loopCond := clickALL(item, startY, endY)
		if(loopCond = 2)
			break
		else if(loopCond = 1)
			break
		else
		{
			if(isTossing) ;If I am tossing junk move the mouse outside the inventory and toss it
			{
				;sleep 25
				MouseMove, 50, 50
				SendInput, {Click}
				;sleep 25
			}
			continue
		}
	}
	resetStuck()
	SendInput, {Shift Up}
	sleep 50
	updateOSD("Done")
	MouseMove, SaveX, SaveY
	BlockInput, MouseMoveOff
	BlockInput, Off
	GUI, Show, NA
	return
}

oldX := 0
oldY := 0
antiStuck(newX, newY) ;Without AntiStuck if an item doesn't move at a shift click the program will keep on trying to continue until all loop iterations finish (default : 40 iterations)
{
	global
	if(oldX >= newX && oldY >= newY) ;assumes clicks move right then down, one way only. Encountering an item left and up of the last click spot breaks the loop
	{
		return 1
	}
	else
	{
		oldX := newX
		oldY := newY
		return 0
	}
}

resetStuck() ;resets oldX and oldY to default so new operations don't auto-antiStuck out
{
	global
	oldX := 0
	oldY := 0
	return
}

clickALL(item, startY, endY)
{
	iDivPos := getInvDivYPos() ;get position of "INVENTORY" divider on screen
	retry := 0
	tries := 3
	startClickSearch:
	MouseMove, 50, 50
	ImageSearch, FoundX, FoundY, 0, startY, A_ScreenWidth, endY, *40 %A_ScriptDir%\%item%.bmp
	if ErrorLevel = 2
		updateOSD("File Does Not Exist : %item%")
	else if ErrorLevel = 1
	{
		retry++
		updateOSD("Can't find mats or job is done. Try :" . retry . " of " . tries)
		if(retry>= tries)
		{
			return 1
		}	
		else
		{
			goto startClickSearch
		}
	}
	else
	{
		if(antiStuck(FoundX, FoundY) == 1)
		{
			return 1
		}
		MouseMove, FoundX, FoundY
		SendInput, {Click}
	}
	return ErrorLevel
}

updatePic(string)
	{
		global
		osdPic=%string%
		if(class_control="true")
			{
				IfWinActive, ahk_class %class%
					GuiControl,, MyPic, %osdPic%
			}
		else
			GuiControl,, MyPic, %osdPic%
		;Gui, Show, x0 yCenter AutoSize
		return
	}
	
refreshOSD()
{
	global
	Gui, Show, NA x0 yCenter AutoSize
	return
}

updateOSD(string)
	{
		global
		osdText=%string%
		if(class_control="true")
			{
				IfWinActive, ahk_class %class%
					GuiControl,, MyText, %osdText%
			}
		else
			GuiControl,, MyText, %osdText%
		;Gui, Show, x0 yCenter AutoSize
		;SetTimer,unshowOSD,2500
		return
	}