/* ----------------------------------------------------------------------------
Keyboard Led Sound Meter - By redyrthgin
Started Feb 17, 2011
Last Update April 13, 2011

 Takes all sound levels output through speakers and converts that into a 
 keyboard visualization using the num lock, caps lock and scroll lock lights.
 Similar to media player visualizations. This script compresses the sound 
 level so even if you listen quietly, the visual effect will be full. 
 Does not actually press the keys, so you can still use the functionallity 
 of those buttons. You will just have to remember if you hit them or not.
 
 FEATURES: - Lights the keyboard leds in tune to any sound your computer plays
           - Reacts to sound level only (ie cannot react to bass hits)
           - Looks cool, now with a nice flowing effect
           - No interference whatsoever with key presses (for keys listed at the bottom)
           - Remembers num/caps/scroll settings, returning them on exit or pause
           - Pauses the led display when no sound detected, returning leds
           - Knows if you change num/caps/scroll during use and correctly 
             displays them on exit/pause.
           - No mater the volume level, the meter will adjust itself and work
           - Fully configurable! Ha..
           - Free!
           - Small footprint. ~5Mb ram used, 0-1% cpu
           - Probably won't fuxors your keyboard
           - Cool debug screen
           - Did I mention it works for anything*? Youtube, vent, netflix, winamp, games, 
             avis, dvds, error beeps... if you can hear it from an analogue output on 
             your sound card (speaker, headphone, etc) the meter should work.
 
 NOTE: - The lights on your keyboard may be in a differnt order then mine. Change 
         what the peak variable equals down where i say "Change this section" 
       - Code still underconstruction, random variables and such should be eatten.

 TODO/PROBABLYWONTDO
 Better settings/methods of figuring out when to light each lights
 Its a bit messy. Could be cleaned into a few functions and less variables etc.
 Optimization. haha
 Dither lights so there are more then 3-4 stages. lights blink slower/faster
 try - max: goes above avg, peaks and starts falling. that was a max
     - min: same but down
 
 DONE (i think)
 Fix it so it actually resets the lights on exit
 Fix it so it doesn't get 'choked' up. For some reason it will just blink all
  the lights slowly sometimes. Seems to happen mostly when using "reload
  this script"
 Possibly a way to keep the keyboard from duplicating keypresses so frequently
 If the user presses the capslock while script is running, when the script pauses
  or ends, those lights are not correct
 
 THANKS TO
    Sean - using his keyboard led lighting method 
         - http://www.autohotkey.com/forum/topic17954.html
    Lexikos - using his Vista Audio Control Functions 
            - http://www.autohotkey.com/forum/topic23792.html
    Tidbit - Helped condense the pause-on-key-press from 500 to 50 lines.
    Autohotkey - I'm sure you understand why
    Internet - For showing me the idea of a keyboard led flasher 
               for your hdd which lead to one for winamp
               (http://www.winamp.com/visualization/keyboard-led-flasher/222098)
               which lead to this - one for all sounds!
*/ ----------------------------------------------------------------------------

#include VA.ahk         ;see http://www.autohotkey.com/forum/viewtopic.php?t=2379
#NoEnv
#SingleInstance, Force
Menu Tray, Add, Toggle Debug, t_Debug
Menu Tray, Add, Toggle Debug Type, t_DebugType
OnExit, ExitLED
Menu, Tray, Icon, Shell32.dll, 201, 1


debug = 0               ;enable this for an annoying tooltip to follow your mouse
useToolTip = 0		;should debug be tooltip or desktop overlay
ledKeyState = 0         ;keep track of num/scroll/caps status changes while running
highestPeak = 0.55      ;running average upper bound on sound level
lowestPeak = 0.45       ;running average lower bound on sound level
highestUpRate = 1       ;Mulipler of how fast to raise upper bound
highestDownRate = 10    ;Divisor of how slow upper bound falls down
lowestUpRate = 10       ;Divisor of how slow lower bound rises up
lowestDownRate = 1      ;Mulipler of how fast to lower lower bound
minVol = 0.0005         ;Min volume level for script to trigger on
MeterLength = 30        ;for debug graph
averageShort = 0.0      ;running average of past averageShortTime of sound level
averageShortTime = 300  ;average past ms to find how loud the song section is (keep x10)
dynamicRange = 0.5    
dynamicPeak  = 0
drScaled = 0.5
drScLast = 1
beatRate = 300
idle = 0                ;is the script idling? (like if no sound)
idleTime = 500          ;idle time before checking if the sound level came back up
idleTrigger = 500       ;how long the sound level should be low before going into idle
idleCounter = 500       ;keeps track of how long the level is low
keyboardAvg = 0         ;counter for when we pass keyboardAveTime
keyboardAvgTime = 30    ;average over this time for led changes

ledWant = 0
ledHave = 0
tieGoesDown = 0
breakNow = 0
rawr = 0

;Giant list of every key on a keyboard. This is used to setup a hotkey for each 
; key on the keyboard so we can pause the script when you push a button so the 
; script doesn't fuxors with your key presses.
list = ~*Esc|~*F1|~*F2|~*F3|~*F4|~*F5|~*F6|~*F7|~*F8|~*F9|~*F10|~*F11|~*F12
list .= "|~*F13|~*F14|~*F15|~*F16|~*F17|~*F18|~*F19|~*F20|~*F21|~*F22|~*F23|~*F24"
list .= "|~*PrintScreen|~*`|~*1|~*2|~*3|~*4|~*5|~*6|~*7|~*8|~*9|~*0|~*-|~*=|~*\"
list .= "|~*bs|~*Tab|~*Shift|~*Control|~*Alt|~*LWin|~*RWin|~*AppsKey|~*[|~*]"
list .= "|~*;|~*'|~*Enter|~*a|~*b|~*c|~*d|~*e|~*f|~*g|~*h|~*i|~*j|~*k|~*l|~*m"
list .= "|~*n|~*o|~*p|~*q|~*r|~*s|~*t|~*u|~*v|~*w|~*x|~*y|~*z|~*Up|~*Down"
list .= "|~*Left|~*Right|~*Ins|~*Del|~*Home|~*End|~*PgUp|~*PgDn|~*Numpad0"
list .= "|~*Numpad1|~*Numpad2|~*Numpad3|~*Numpad4|~*Numpad5|~*Numpad6|~*Numpad7"
list .= "|~*Numpad8|~*Numpad9|~*NumpadDot|~*NumpadDiv|~*NumpadMult|~*NumpadAdd"
list .= "|~*NumpadSub|~*NumpadIns|~*NumpadEnd|~*NumpadDown|~*NumpadPgDn"
list .= "|~*NumpadLeft|~*NumpadClear|~*NumpadRight|~*NumpadHome|~*NumpadUp"
list .= "|~*NumpadPgUp|~*NumpadDel|~*NumpadEnter|~*,|~*.|~*Browser_Back"
list .= "|~*Browser_Forward|~*Browser_Refresh|~*Browser_Stop|~*Browser_Search"
list .= "|~*Browser_Favorites|~*Browser_Home|~*Volume_Mute|~*Volume_Down"
list .= "|~*Volume_Up|~*Media_Next|~*Media_Prev|~*Media_Stop|~*Media_Play_Pause"
list .= "|~*Launch_Mail|~*Launch_Media|~*Launch_App1|~*Launch_App2|~*Space"

;Load the keys into a key handler, so if someone pushes one, it will fire!
loop, parse, list, |
        hotkey, %A_LoopField%, handler


CustomColor = 101010 ; Can be any RGB color (it will be made transparent below).
Gui +LastFound -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, %CustomColor%
Gui, Font, s8, Arial ;Set a large font size (32-point).
Gui, Add, Text, vMyText cWhite w205 h285  ; XX & YY serve to auto-size the window.
; Make all pixels of this color transparent and make the text itself translucent (150):
;WinSet, Transparent, 200
WinSet, TransColor, %CustomColor% 255
;SetTimer, UpdateOSD, 200
;Gosub, UpdateOSD  ; Make the first update immediate rather than waiting for the timer.
Gui, Show, x0 y0 NoActivate  ; NoActivate avoids deactivating the currently active window.
;WinSet, Transparent, OFF



;Get keyboard handler and keyboard status 
; You can try changing the KeyboardClass if it doesn't pick your keyboard up. 
; Switch the number at the end to try another keyboard. I've read that usb 
; keyboards are often not keyboard 0, so try 1 or 2.
hKeybd := DllCall("CreateFile"
                  , "str", "\\.\GLOBALROOT\Device\KeyboardClass0"
                  , "Uint", 0
                  , "Uint", 3
                  , "Uint", 0
                  , "Uint", 3
                  , "Uint", 0
                  , "Uint", 0)

DllCall("DeviceIoControl"
        , "Uint", hKeybd
        , "Uint", 0x000B0040   ;IOCTL_KEYBOARD_QUERY_INDICATORS
        , "Uint", 0
        , "Uint", 0
        , "Uint*", _nStatus_
        , "Uint", 4
        , "Uint*", nReturn
        , "Uint", 0) 

;Saving num/caps/scroll lock settings since we are going to use their lights
; and want to know what they were set to for later
ledKeyState := 0 | _nStatus_ >> 16
        
;Grab audio device. You can switch to "recording" (or something else) if you want
; Vista Audio Control page (http://www.autohotkey.com/forum/viewtopic.php?t=23792) 
; has a script (topology2.ahk) that will list the valid devices you can use here. 
audioMeter := VA_GetAudioMeter("playback")

;Don't need channelcount. For my system I get stereo/left/right channels, 
; so the first is all that's needed, which is default
; Other people might want/need to use a different channel. You will have to 
; recode part of this scrip to do that. Not plug-n-play.
;VA_IAudioMeterInformation_GetMeteringChannelCount(audioMeter, channelCount)

;"The peak value for each channel is recorded over one device
;  period and made available during the subsequent device period."
VA_GetDevicePeriod("playback", devicePeriod)

;Even though we just got the device's period, you can set your own polling rate.
; If the leds are off/dark too much? Try higher.. and vice versa.
; Probably don't want to set it faster then the device's period. In milliseconds.
; Try to keep at multiple of 10 to match with averaging time slices used
devicePeriod = 10

;This is to get the meter seeded. Otherwise, the meter is off even more
; Highest and lowest peak can not be the same value.
;VA_IAudioMeterInformation_GetPeakValue(audioMeter, averageShort)
if(averageShort > 0) {
    highestPeak := averageShort + (averageShort * .1)
    lowestPeak := averageShort - (averageShort * .1)
}


;Do this now so we don't have to each loop. 
averageShortPeriods := averageShortTime / devicePeriod

;Right now I don't have any reason to stop.. 
Loop {

    ;Get the peak value across all channels. - since last poll I believe
    ; Not an average, but the highest level since. 
    VA_IAudioMeterInformation_GetPeakValue(audioMeter, peakValue)  

    ;Check if we should go into idle mode, and if so return keyboard leds to user
    if(peakValue < minVol)
        idleCounter -= devicePeriod
    else
        idleCounter = %idleTrigger%
    if(idleCounter <= 0) {
        ToolTip,                      ;stops/closes debug
        GuiControl,, MyText,
        idle = 1
        _nStatus_:= 0 | ledKeyState << 16
        DllCall("DeviceIoControl"
                , "uint", hKeybd
                , "uint", 0x000B0008  ;IOCTL_KEYBOARD_SET_INDICATORS
                , "uint*", _nStatus_
                , "uint", 4
                , "uint", 0
                , "uint", 0
                , "uint*", nReturn
                , "uint", 0)
    }    

    ;If the sound level was low, sleep for a while and then check again
    ; When waking up, grab any indicator changes while we were sleeping
    while(idle) {
        Sleep, %idleTime%
        VA_IAudioMeterInformation_GetPeakValue(audioMeter, peakValue)  
        if(peakValue > minVol){
            idle = 0
            DllCall("DeviceIoControl"
                    , "Uint", hKeybd
                    , "Uint", 0x000B0040   ;IOCTL_KEYBOARD_QUERY_INDICATORS
                    , "Uint", 0
                    , "Uint", 0
                    , "Uint*", _nStatus_
                    , "Uint", 4
                    , "Uint*", nReturn
                    , "Uint", 0) 
            ledKeyState := 0 | _nStatus_ >> 16
        }
    }

    ;Update and find the average song level for the past Short timeframe
    ; Average short is not really used currently, but since this isnt release code
    ; but rather under development, I've left it. Nice to see for debugging.
    ; Also can be(was) used for when to light leds.
    averagePast += devicePeriod
    i := averageShort / averageShortPeriods
    j := peakValue  / averageShortPeriods
    averageShort := averageShort - i + j



    highestDownRate = 20
    lowestUpRate = 20
    highestUpRate = 1
    lowestDownRate = 1

    drScaled := dynamicRange / highestPeak
    foo = 2
    drScDiff := Abs(drScaled - drScLast)
    drScLast := drScaled
    ;dyRn :=  Log(1 / sqrt((1 - drScaled)))      ;scale dynamic range to volume level
    ;dyrn := ((Log(1-drScaled))*-500)
    ;dyrn := sqrt(sqrt(sqrt(drScaled))) * 20 + .1
    if(drScaled < 0.1)                           
        dyrn := drScaled**0.2 * 10 + 0.1         ;exponent .2 power (5th root) scaling from ~6.5 to ~2.5
    else if (drScaled < 0.3)
        dyrn := sqrt(drScaled-.07) * 40          ;sqrt scaling from 20 to ~7.5
        dyrn := 20                               ;hard stuck at 20
    ;dyrn2 := sqrt(sqrt(sqrt(drScaled))) * 1.25 + .01
    dyrn2 := drScaled**0.125 * 1.25 + 0.01       ;exp .125 power (8th root) scaling from 1.25 to ~0.5
    ;dyrn2 := drScaled * 2 + .01
    ;i := log(1/(1-drScaled))
    ;dyrn := (i*30+1.5)/log(5)
    ;msgbox, %drScaled%  |  %i%  |  %dyrn% `n %highestPeak%   |   %dynamicRange%   |   %averageShort%
    
    
    if (foo = 1) {                          ;Static
        hDn := highestDownRate
        lUp := lowestUpRate
        hUp := highestUpRate
        lDn := lowestDownRate
        
    } else if (foo = 2) {                  ;smaller range -> larger rates -> slower changes
        hDn := highestDownRate ;/ sqrt(drScaled)
        lUp := dyrn ;lowestUpRate * sqrt(drScaled)
        hUp := highestUpRate ;* sqrt(drScaled)
        lDn := dyrn2 ;lowestDownRate ;* sqrt(drScaled)
        
    } else if (foo = 3) {                  ;smaller range -> smaller rates -> faster changes
        hDn := highestDownRate ;* Sqrt(drScaled)
        lUp := lowestUpRate * Sqrt(drScaled)
        hUp := highestUpRate ;* Sqrt(drScaled)
        lDn := lowestDownRate * Sqrt(Sqrt(drScaled))
        

        if(hUp < 0.5)
            hUp = 0.5
        if(lUp <= hUp)
            lUp := hUp + 0.1
        ;if(lDn < 0.5)
        ;    lDn = 0.5
        if(hDn <= lDn)
            ;MsgBox, %drScaled% = %dynamicRange%  %highestPeak%
            hDn := lDn + 0.5            
    }
    
    

    
    ;Update high peak
    ; Move high peak toward the actual sound value/level
    if (peakValue >= highestPeak) {
        diff := peakValue - highestPeak
        diffInv := 1 / diff ;/ drScaled ;/ highestPeak
        ;i := highestPeak / (diffInv / highestUpRate)
        ;j := peakValue / (diffInv / highestUpRate)
        i := highestPeak / (diffInv / hUp)
        j := peakValue / (diffInv / hUp)        
        highestPeak := highestPeak - i + j
    } else {
        diff := peakValue - highestPeak
        diffInv := 1 / diff ;/ drScaled ;/ highestPeak
        ;diffInv := 
        ;i := highestPeak / (diffInv * highestDownRate)
        ;j := peakValue / (diffInv * highestDownRate)
        i := highestPeak / (diffInv * hDn)
        j := peakValue / (diffInv * hDn)
        k := i - j    

        highestPeak := highestPeak + i - j
    }
    
   
    ;Update low peak
    ; Move low peak toward the actual sound value/level
    if (peakValue < lowestPeak) {
        diff := peakValue - lowestPeak
        diffInv := 1 / diff ;/ drScaled ;/ highestPeak
        ;i := lowestPeak / (diffInv / lowestDownRate)
        ;j := peakValue / (diffInv / lowestDownRate)
        i := highestPeak / (diffInv / lDn)
        j := peakValue / (diffInv / lDn)          
        lowestPeak := lowestPeak + i - j
    } else {
        diff := peakValue - lowestPeak
        diffInv := 1 / diff ;/ drScaled ;/ highestPeak
        ;i := lowestPeak / (diffInv * lowestUpRate)
        ;j := peakValue / (diffInv * lowestUpRate)
        i := lowestPeak / (diffInv * lUp)
        j := peakValue / (diffInv * lUp)
        k := i + j 
        if(breakNow) {
            Msgbox, .pv %peakValue% `n hp %highestPeak% `n d %diff% `n di %diffInv% `n i %i% `n j %j% `n k %k%
            breakNow = 0
        }        
        lowestPeak := lowestPeak - i + j  
    }    
    
    
    
    if(lowestPeak >= highestPeak - (dynamicRange * .1)) {
        lowestPeak := peakValue - (dynamicRange * .1)
        rawr += 1
        tooltip, lowhigh %rawr%
    }
    
    ;Find the dynamic range and peak
    ; The whole trouble with this script was this issue
    ; Without a dynamic range and peak, if the user turns down the volume
    ; or up, the meter wont work. 
    ; (only used in debugging now)
    dynamicRange := highestPeak - lowestPeak
    insideRange := peakValue - lowestPeak
    dynamicPeak := insideRange / dynamicRange        


    ;Depending on where the current sound level is, note which led we want 
    ; turned on.
    if (peakValue >= highestpeak)
        ledWant += 8
    else if (peakValue > lowestpeak + (dynamicRange * .5)) 
        ledWant += 4
    else if (peakValue >= lowestpeak) 
        ledWant += 2
   
    ;If enough time has passed, we can now average the values collected
    ; and light the leds. Without averaging over a perio of time the 
    ; leds light too quickly and look like poo. They usually flash on and 
    ; off so quickly they appear to be pretty much on all the time.
    ; And/or they turn on/off at the same time, so there is no growth/decay effect.
    ; Often it will look like all 3 blink on and off together. Very ugly.
    if(keyboardAvg >= keyboardAvgTime) {
        
        ;Find the average.
        i := keyboardAvg / devicePeriod
        ledWant /= i

        if(tieGoesDown = 1) {                    ;tie goes down
            if (ledWant <= 1)
                ledWant = 0
            else if (ledWant <= 3)
                ledWant = 1
            else if (ledWant <= 6)
                ledWant = 2
            else
                ledWant = 3
        } else if(tieGoesDown = 0) {             ;tie goes up
            if (ledWant < 1)
                ledWant = 0
            else if (ledWant < 3)
                ledWant = 1
            else if (ledWant < 6)
                ledWant = 2
            else
                ledWant = 3
        } 
        
        
        ;We don't want the meter jumping from top to bottom, 
        ; so only go up and down in steps.
        if(ledWant > ledHave)
             ledHave += 1
        else if(ledWant < ledHave)
             ledHave -= 1

        ;Decide what levels to light each keyboard led at.
        ; Change this section if you have a different light layout
        ; Add 1, 2, 4 to peak for scroll, num, caps lock lights.
        peak = 0                                 ;no lights on (default)
        if(ledHave = 3)                          
            peak = 7                             ;1+2+4 = all lights on
        else if(ledHave = 2)
            peak = 6                             ;2+4 = num + caps
        else if(ledHave = 1)
            peak = 2                             ;2 = only numlock

        ;Either turn some/all lights on, or turn them all off. 
        ; If the vol is very low, forget it
        if (peak > 0 && peakValue > minVol)
            nStatus := 0 | peak << 16
        else
            nStatus := 0        

        ;Actual call to change the keyboard leds
        DllCall("DeviceIoControl"
                , "uint", hKeybd
                , "uint", 0x000B0008          ;IOCTL_KEYBOARD_SET_INDICATORS
                , "uint*", nStatus
                , "uint", 4
                , "uint", 0
                , "uint", 0
                , "uint*", nReturn
                , "uint", 0)

           ;Reset some things now that we have updated leds
           keyboardAvg = 0
           ledWantLast := ledWant
           ledWant = 0
       }
       
    ;Enable to see an annoying tooltip. Looks Cool
    if (debug) {
        meter := MakeMeter(peakValue, MeterLength)
        dmeter := MakeMeter(dynamicPeak, MeterLength)
        drmeter := MakeMeter(drScaled, MeterLength)
        drScDiff *= 100
        drsdm := MakeMeter(drScDiff, meterLength)
        j := lowestpeak + (dynamicRange * .5)
        fmeter := MakeFakeLights(peakValue, lowestpeak, j, highestpeak)
        lhm := MakeFakeLights(ledHave, 1.000000, 2.000000, 3.000000)
        meterDiff := Abs(dynamicPeak - peakValue)
        pps := 1000 / averageTimeBetweenPeaks

        tt = Polling %devicePeriod%ms, averaged over %keyboardAvgTime%ms `n 
        tt .= "drsd " drScDiff "	" drsdm "`n"
        tt .= "drs " drScaled "	" drmeter "`n"
        tt .= "pv " peakValue "	" meter "`n"
        tt .= "dp " dynamicPeak "	" dmeter "`n"
        tt .= fmeter "`n"
        tt .= lhm "`n"
        tt .= "lp " lowestPeak "	hp " highestPeak "`n"
        tt .= "dr " dynamicRange "	as " averageShort "`n"
        tt .= "dyRn " dyRn "`n"
        tt .= "ic " idleCounter "	lks " ledKeyState "`n"
        tt .= "am " audioMeter "	tgd " tieGoesDown "`n"
        tt .= "hDn " hDn "`n"
        tt .= "lUp " lUp "`n"
        tt .= "hUp " hUp "`n"
        tt .= "lDn " lDn "`n"
        
        if(useToolTip) {
        	ToolTip, %tt%
        	GuiControl,, MyText, 
        } else {
        	ToolTip, 
        	GuiControl,, MyText, %tt%
        }
    }
    
    ;Add the time we'll be sleeping, and take a nap
    keyboardAvg += devicePeriod        
    Sleep, %devicePeriod%
}


/* ----------------------------------------------------------------------------
  Turn the float peakValue into a graph thingy, debug
  Looks kinda like: 
   ||||||||||||||..............
  and then
   ||||||||||||||||||||||......
*/ ----------------------------------------------------------------------------
MakeMeter(fraction, size) {
    global MeterLength
    
    ;If the given float is larger then 1, then since we are assuming it is 
    ; less then 1 always, the graph will become HUGE, and break all kinds of 
    ; formatting, or worse take forever to create.
    if(fraction > 1) {
        i := fraction - 1
        fraction := fraction - i       
        Loop % fraction*size
	    meter .= "|"
        meter .= " [over]"
    } else if (fraction < 0) {
        if (size > 10)
            Loop % size - 10
                meter .= " "
        meter .= " [under]"
    } else {
        Loop % fraction*size
	    meter .= "|"
    }
    return meter
}


/* ----------------------------------------------------------------------------
  Makes a text version of the led graph. Super simple.
  Looks kinda like: 
    [0.282]  [0.582]           
  and then
    [0.282]  [0.582]  [.929]
*/ ----------------------------------------------------------------------------
MakeFakeLights(fraction, level1, level2, level3) {
    if(fraction >=  level1)
        meter .= "[" level1 "]"
    if(fraction >=  level2)
        meter .= "[" level2 "]"        
    if(fraction >=  level3)
        meter .= "[" level3 "]"        
    return meter
}


/* ----------------------------------------------------------------------------
  Shows a nifty debug window with lots of information
*/ ----------------------------------------------------------------------------
t_Debug:
if(debug) {
    debug = 0
    ToolTip,
    GuiControl,, MyText,
} else
    debug  = 1
Return


/* ----------------------------------------------------------------------------
  Switches between tooltip and desktop overlay debug display modes
*/ ----------------------------------------------------------------------------
t_DebugType:
if(useToolTip) {
    useToolTip = 0
} else
    useToolTip = 1
Return


/* ----------------------------------------------------------------------------
  gtfo? clean up on your way out
  Reset leds to how they should be and close keyboard handler
*/ ----------------------------------------------------------------------------
ExitLED:
    _nStatus_:= 0 | ledKeyState << 16
    DllCall("DeviceIoControl", "Uint", hKeybd, "Uint", 0x000B0008, "UintP", _nStatus_, "Uint", 4, "Uint", 0, "Uint", 0, "UintP", nReturn, "Uint", 0)   ; IOCTL_KEYBOARD_SET_INDICATORS
    DllCall("CloseHandle", "Uint", hKeybd)
ExitApp


F6::
tieGoesDown += 1
if(tieGoesDown > 1)
   tieGoesDown = 0
Return

;F7::
;breakNow = 1
;Return



/* ----------------------------------------------------------------------------
  This hotkeys fires on any key press in order to keep the scrpt from doubling
   key presses, ignoring key presses, or holding keys. This happens when the 
   leds are updated at the same time as a key press. Now with this fix the 
   script just doesnt run when you hit a key(s).
*/ ----------------------------------------------------------------------------
handler:
stringreplace, key, A_ThisHotkey, ~*,, all
KeyWait, %key%
Return

/* ----------------------------------------------------------------------------
  These hotkeys make note of any num/scroll/capslock changes you make while
   the script is running so the correct lights can be returned to the user 
   when the script exits or sleeps (no sound).
*/ ----------------------------------------------------------------------------
~*ScrollLock::
if GetKeyState("ScrollLock", "T")
    ledKeyState += 1
else
    ledKeyState -= 1
KeyWait, ScrollLock
Return

~*Capslock::
if GetKeyState("Capslock", "T")
    ledKeyState += 4
else
    ledKeyState -= 4
KeyWait, capslock
Return

~*Numlock::
if GetKeyState("Numlock", "T")
    ledKeyState += 2
else
    ledKeyState -= 2
KeyWait, Numlock
Return