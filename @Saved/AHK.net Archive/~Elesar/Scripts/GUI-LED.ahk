/*
   Arduino LED Controller
*/
;<=====  System Settings  ====================================================>
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%

;<=====  Arduino Settings  ===================================================>
ARDUINO_Port	:= "COM3"
ARDUINO_Baud	:= 115200
ARDUINO_Parity	:= "N"
ARDUINO_Data	:= 8
ARDUINO_Stop	:= 1

;<=====  Setup Arduino Connection  ===========================================>
arduino_setup(start_polling_serial:=false)

;<=====  GUI  ================================================================>
Gui, Add, Button, x5 y5 w100 h30 gLEDOff, Off
Gui, Add, Button, xp y+5 w100 h30 gLEDRed, Red
Gui, Add, Button, xp y+5 w100 h30 gLEDGreen, Green
Gui, Add, Button, xp y+5 w100 h30 gLEDBlue, Blue
Gui, Add, Button, xp y+5 w100 h30 gLEDYellow, Yellow
Gui, Add, Button, xp y+5 w100 h30 gLEDPink, Pink
Gui, Add, Button, xp y+5 w100 h30 gLEDTeal, Teal
Gui, Add, Button, xp y+5 w100 h30 gLEDWhite, White
Gui, Add, Button, xp y+5 w100 h30 gCycle, Cycle
Gui, Add, Edit, x+5 y5 w200 vMessage,
Gui, Add, Button, xp y+5 w200 h30 gSendMorse, Send Morse Code
Gui, Show, xCenter yCenter, ArduinoLED
return

;<=====  Labels  =============================================================>
LEDOff:
   setColor(0)
   return
   
LEDRed:
   setColor(1)
   Sleep, 5000
   GoSub, LEDOff
   return
   
LEDGreen:
   setColor(2)
   Sleep, 5000
   GoSub, LEDOff
   return
   
LEDBlue:
   setColor(4)
   Sleep, 5000
   GoSub, LEDOff
   return

LEDYellow:
   setColor(3)
   Sleep, 5000
   GoSub, LEDOff
   return

LEDPink:
   setColor(5)
   Sleep, 5000
   GoSub, LEDOff
   return
   
LEDTeal:
   setColor(6)
   Sleep, 5000
   GoSub, LEDOff
   return
   
LEDWhite:
   setColor(7)
   Sleep, 5000
   GoSub, LEDOff
   return

Cycle:
   setColor(1)
   Sleep, 1000
   setColor(2)
   Sleep, 1000
   setColor(3)
   Sleep, 1000
   setColor(4)
   Sleep, 1000
   setColor(5)
   Sleep, 1000
   setColor(6)
   Sleep, 1000
   setColor(7)
   Sleep, 1000
   setColor(0)
   return

SendMorse:
   Gui, Submit, NoHide
   morseCode(Message)
   return

GuiClose:
OnExit:
   arduino_close()
   ExitApp

;<=====  Functions  ==========================================================>
setColor(value){
   ;Critical
   if(value == 0){
      arduino_send("0")
   }if(value == 1){
      arduino_send("0")
      arduino_send("1")
   }if(value == 2){
      arduino_send("0")
      arduino_send("2")
   }if(value == 3){
      arduino_send("0")
      arduino_send("1")
      arduino_send("2")
   }if(value == 4){
      arduino_send("0")
      arduino_send("4")
   }if(value == 5){
      arduino_send("0")
      arduino_send("1")
      arduino_send("4")
   }if(value == 6){
      arduino_send("0")
      arduino_send("2")
      arduino_send("4")
   }if(value == 7){
      arduino_send("0")
      arduino_send("1")
      arduino_send("2")
      arduino_send("4")
   }
}

morseCode(string){
   /*
      A dash is equal to three dots
      The space between parts of the same letter is equal to one dot
      The space between two letters is equal to three dots
      The space between two words is seven dots
   */
   
   ; Build array of morse codes
   morse := {A:"01", B:"1000", C: "1010", D:"100", E:"0", F:"0010", G:"110", H:"0000", I:"00", J:"0111", K:"101", L:"0100", M:"11", N:"10", O:"111", P:"0110", Q:"1101", R:"010", S:"000", T:"1", U:"001", V:"0001", W:"011", X:"1001", Y:"1011", Z:"1100", 1:"01111", 2:"00111", 3:"00011", 4:"00001", 5:"00000", 6:"10000", 7:"11000", 8:"11100", 9:"11110", 0:"11111"}
   
   ; Parse string and send letters
   StringUpper, string, string
   Loop, Parse, string
   {
      if(A_LoopField == " ")
         morse_space()
      else{
         letter := morse[A_LoopField]
         Loop, Parse, letter
         {
            if(A_LoopField == 0)
               morse_dot()
            if(A_LoopField == 1)
               morse_dash()
            morse_subLetterSpace()
         }
         morse_letterSpace()
      }
   }
   setColor(1)
   Sleep, 500
   setColor(0)
}

morse_dot(){
   arduino_send("4")
   Sleep, 125
   arduino_send("0")
}

morse_dash(){
   arduino_send("4")
   Sleep, 375
   arduino_send("0")
}

morse_subLetterSpace(){
   Sleep, 125
}

morse_letterSpace(){
   Sleep, 375
}

morse_space(){
   Sleep, 875
}

;<=====  Includes  ===========================================================>
#Include Arduino.ahk