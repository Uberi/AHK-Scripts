; Joystick als Maus verwenden
; http://www.autohotkey.com
; Dieses Script wandelt einen Joystick in eine Maus mit drei Tasten um.  Dadurch verhält sich
; jede Joystick-Taste wie eine Maustaste und verbraucht kaum CPU-Zeit.
; Außerdem ist die Zeigergeschwindigkeit abhängig davon, wie weit der Joystick
; vom Zentrum gedrückt wird. Verschiedene Einstellungen können auch im oberen Bereich des Scripts angepasst werden.

; Den folgenden Wert erhöhen, damit der Mauszeiger sich schneller bewegt:
JoyMultiplier = 0.30

; Den folgenden Wert verringern, damit weniger Weg vom Zentrum benötigt wird,
; um die Maus zu bewegen.  Allerdings muss möglicherweise erst der aktuelle Joystick kalibriert werden,
; damit er richtig zentriert ist, um einen Drift des Mauszeigers zu verhindern. Ein absolut straffer
; und zentrierter Joystick kann eine 1 verwenden:
JoyThreshold = 3

; Für die Invertierung der Y-Achsen kann die folgende Variable auf True gesetzt werden, wodurch
; die sich Maus vertikal in die entgegengesetzte Richtung des Sticks bewegt:
InvertYAxis := false

; Diese Werte können geändert werden, um beliebige Joystick-Tastennummern für
; die linke, rechte und mittlere Maustaste zu verwenden.  Zahlen von 1 bis 32 sind verfügbar.
; Verwendet das Joystick-Test-Script, um die aktuellen Joystick-Nummern einfach herauszufinden.
ButtonLeft = 1
ButtonRight = 2
ButtonMiddle = 3

; Falls der aktuelle Joystick einen Rundblickschalter (POV) hat, dann kann dieser als Mausrad verwendet werden.  Der
; folgende Wert ist die Anzahl der Millisekunden zwischen den Drehungen des Rades.
; Wird der Wert verringert, dreht sich das Rad schneller:
WheelDelay = 250

; Falls mehr als ein Joystick vorhanden ist, erhöht diesen Wert, um einen beliebigen Joystick
; zu verwenden:
JoystickNumber = 1

; ENDE DES KONFIGURATIONSBEREICHS -- Hier danach keine Änderungen durchführen,
; es sei denn, die allgemeine Funktionalität des Scripts soll geändert werden.

#SingleInstance

JoystickPrefix = %JoystickNumber%Joy
Hotkey, %JoystickPrefix%%ButtonLeft%, ButtonLeft
Hotkey, %JoystickPrefix%%ButtonRight%, ButtonRight
Hotkey, %JoystickPrefix%%ButtonMiddle%, ButtonMiddle

; Benötigte Achsenabstände berechnen, um den Mauszeiger bewegen zu können:
JoyThresholdUpper := 50 + JoyThreshold
JoyThresholdLower := 50 - JoyThreshold
if InvertYAxis
	YAxisMultiplier = -1
Else
	YAxisMultiplier = 1

SetTimer, WatchJoystick, 10  ; Joystick-Bewegung überwachen.

GetKeyState, JoyInfo, %JoystickNumber%JoyInfo
IfInString, JoyInfo, P  ; Joystick hat einen Rundblickschalter (POV), also als Mausrad verwenden.
	SetTimer, MouseWheel, %WheelDelay%

Return ; Ende des automatischen Ausführungsbereichs.


; Die unteren Subroutinen verwenden nicht KeyWait, weil ansonsten der
; WatchJoystick-Quasi-Thread unter dem Warten-auf-Tastendruck-Thread eingefangen wird,
; wodurch das Maus-Ziehen mit dem Joystick unterdrückt wird.

ButtonLeft:
SetMouseDelay, -1  ; Flüssigerer Bewegungsablauf.
MouseClick, left,,, 1, 0, D  ; Hält die linke Maustaste gedrückt.
SetTimer, WaitForLeftButtonUp, 10
Return

ButtonRight:
SetMouseDelay, -1  ; Flüssigerer Bewegungsablauf.
MouseClick, right,,, 1, 0, D  ; Hält die rechte Maustaste gedrückt.
SetTimer, WaitForRightButtonUp, 10
Return

ButtonMiddle:
SetMouseDelay, -1  ; Flüssigerer Bewegungsablauf.
MouseClick, middle,,, 1, 0, D  ; Hält die mittlere Maustaste gedrückt.
SetTimer, WaitForMiddleButtonUp, 10
Return

WaitForLeftButtonUp:
if GetKeyState(JoystickPrefix . ButtonLeft)
	return  ; Wenn die Taste immer noch gedrückt gehalten wird, dann warten.
; Ansonsten wurde die Taste losgelassen.
SetTimer, WaitForLeftButtonUp, off
SetMouseDelay, -1  ; Flüssigerer Bewegungsablauf.
MouseClick, left,,, 1, 0, U  ; Lässt die Maustaste los.
Return

WaitForRightButtonUp:
if GetKeyState(JoystickPrefix . ButtonRight)
	return  ; Wenn die Taste immer noch gedrückt gehalten wird, dann warten.
; Ansonsten wurde die Taste losgelassen.
SetTimer, WaitForRightButtonUp, off
MouseClick, right,,, 1, 0, U  ; Lässt die Maustaste los.
Return

WaitForMiddleButtonUp:
if GetKeyState(JoystickPrefix . ButtonMiddle)
	return  ; Wenn die Taste immer noch gedrückt gehalten wird, dann warten.
; Ansonsten wurde die Taste losgelassen.
SetTimer, WaitForMiddleButtonUp, off
MouseClick, middle,,, 1, 0, U  ; Lässt die Maustaste los.
Return

WatchJoystick:
MouseNeedsToBeMoved := false  ; Standardwert setzen.
SetFormat, float, 03
GetKeyState, joyx, %JoystickNumber%JoyX
GetKeyState, joyy, %JoystickNumber%JoyY
if joyx > %JoyThresholdUpper%
{
	MouseNeedsToBeMoved := true
	DeltaX := joyx - JoyThresholdUpper
}
else if joyx < %JoyThresholdLower%
{
	MouseNeedsToBeMoved := true
	DeltaX := joyx - JoyThresholdLower
}
Else
	DeltaX = 0
if joyy > %JoyThresholdUpper%
{
	MouseNeedsToBeMoved := true
	DeltaY := joyy - JoyThresholdUpper
}
else if joyy < %JoyThresholdLower%
{
	MouseNeedsToBeMoved := true
	DeltaY := joyy - JoyThresholdLower
}
Else
	DeltaY = 0
if MouseNeedsToBeMoved
{
	SetMouseDelay, -1  ; Flüssigerer Bewegungsablauf.
	MouseMove, DeltaX * JoyMultiplier, DeltaY * JoyMultiplier * YAxisMultiplier, 0, R
}
Return

MouseWheel:
GetKeyState, JoyPOV, %JoystickNumber%JoyPOV
if JoyPOV = -1  ; Kein Winkel.
	Return
if (JoyPOV > 31500 or JoyPOV < 4500)  ; Nach vorne
	Send {WheelUp}
else if JoyPOV between 13500 and 22500  ; Nach hinten
	Send {WheelDown}
Return
