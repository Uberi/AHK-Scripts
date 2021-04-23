; AHK BBCodeWriter - An offline BBCode editor
; Copyright (C) 2006  AGermanUser
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

;##############################################################################
;####### Functions ############################################################
;##############################################################################
; Icon Buttons
SetButtonGraphic(WindowHWND, CtrlInstance, ImgPath, bHeight=32, bWidth=32, ImgType=0)
  {
    ; Thanks to corrupt for this function.
    ; Details under http://www.autohotkey.com/forum/topic4047.html

    ; WindowHWND    = Window handle
    ; CtrlInstance  = Button Number (same as the # in ClassNN in Window Spy)
    ; ImgPath       = Path to the icon to be displayed 
    ; ImgType       = BS_ICON
    ; bHeight       = icon height (default = 32)
    ; bWidth        = icon width  (default = 32)
    
    ; Set Constants
    NULL=
    LR_LOADFROMFILE := 16
    BM_SETIMAGE := 247
    
    ; Find the handle to the Button based on the windle handle and button number
    Loop, %CtrlInstance%
      {
        CtrlHandle := DllCall("FindWindowExA"
                             , "Uint", WindowHWND
                             , "Uint", CtrlHandle
                             , "str", "Button"
                             , "str", NULL
                             , "Uint")
        If CtrlHandle = 0
          Return
      }
    
    ; Load the image from the file and retrieve the image handle
    ImgHwnd%CtrlInstance% := DllCall("LoadImage"
                                    , "UInt", NULL
                                    , "Str", ImgPath
                                    , "UInt", ImgType
                                    , "Int", bWidth
                                    , "Int", bHeight
                                    , "UInt", LR_LOADFROMFILE
                                    , "UInt")
    
    ; Assign the image to the button 
    DllCall("SendMessage"
           , "UInt", CtrlHandle
           , "UInt", BM_SETIMAGE
           , "UInt", ImgType
           , "UInt", ImgHwnd%CtrlInstance%)
    
    ; Return the handle to the image
    retImg := ImgHwnd%CtrlInstance%
    Return, %retImg%
  }

; Needed for BBCodePreview.ahk
StringReplaceWord(In_String,In_StartWordPos,In_WordLength,In_ReplaceText)
  {
    ; In_String       : InputVar
    ; In_StartWordPos : Position of Substring to be replaced (determined with StringGetPos)
    ; In_WordLength   : Number of chars substring consists of
    ; In_ReplaceText  : Substring gets replaced with this string
  
    local Length, Before, After, Ret_Val
    StringLen, Length, In_String
    If (In_StartWordPos>Length)OR(In_StartWordPos+In_WordLength>Length)OR(Length=0)
      Return, %In_String%
    StringLeft, Before, In_String, In_StartWordPos
    StringRight, After, In_String, Length-(In_StartWordPos+In_WordLength)
    Ret_Val=%Before%%In_ReplaceText%%After%   
    Return, %Ret_Val%
  }

; Needed for displaying URL in About GUI 
HandleMessage(p_w, p_l, p_m, p_hw)
  {
    ; Thanks to shimanov for this function
    ; Details under http://www.autohotkey.com/forum/topic6299.html
    
    ; p_w             : WPARAM value
    ; p_l             : LPARAM value
    ; p_m             : message number
    ; p_hw            : window handle HWND
    
    ; Further details can be found in the documentation for 'OnMessage()'
    
    global   WM_SETCURSOR, WM_MOUSEMOVE, 
    static   URL_hover, h_cursor_hand, h_old_cursor, CtrlIsURL, HovrdCtrl
   
    If (p_m = WM_SETCURSOR)
      {
        If URL_hover
          Return, true
      }
    Else If (p_m = WM_MOUSEMOVE)
      {
        ; Mouse cursor hovers URL text control
        StringLeft, CtrlIsURL, A_GuiControl, 3
        If (CtrlIsURL = "URL")
          {
            If URL_hover=
              {
                Gui, Font, cBlue underline
                GuiControl, Font, %A_GuiControl%
                HovrdCtrl = %A_GuiControl%
               
                h_cursor_hand := DllCall("LoadCursor", "uint", 0, "uint", 32649)
               
                URL_hover := true
              }                 
              h_old_cursor := DllCall("SetCursor", "uint", h_cursor_hand)
          }
        ; Mouse cursor doesn't hover URL text control
        Else
          {
            If URL_hover
              {
                Gui, Font, norm cBlue 
                GuiControl, Font, %HovrdCtrl%
               
                DllCall("SetCursor", "uint", h_old_cursor)
               
                URL_hover=
              }
          }
        
        ; For text control tooltip in Smiley GUI
        If A_Gui = 4
          {
            MouseGetPos,,,, ASmiley
            
            If ASmiley =
              GuiControl, 4:, Static2
            If ASmiley = Button1
              GuiControl, 4:, Static2, :D
            If ASmiley = Button2
              GuiControl, 4:, Static2, :)
            If ASmiley = Button3
              GuiControl, 4:, Static2, :(
            If ASmiley = Button4
              GuiControl, 4:, Static2, :o
            If ASmiley = Button5
              GuiControl, 4:, Static2, :shock:    
            If ASmiley = Button6
              GuiControl, 4:, Static2, :?    
            If ASmiley = Button7
              GuiControl, 4:, Static2, 8)    
            If ASmiley = Button8
              GuiControl, 4:, Static2, :lol:    
            If ASmiley = Button9
              GuiControl, 4:, Static2, :x    
            If ASmiley = Button10
              GuiControl, 4:, Static2, :P    
            If ASmiley = Button11
              GuiControl, 4:, Static2, :oops:    
            If ASmiley = Button12
              GuiControl, 4:, Static2, :cry:
            If ASmiley = Button13
              GuiControl, 4:, Static2, :evil:
            If ASmiley = Button14
              GuiControl, 4:, Static2, :twisted:
            If ASmiley = Button15
              GuiControl, 4:, Static2, :roll:
            If ASmiley = Button16
              GuiControl, 4:, Static2, :wink:
            If ASmiley = Button17
              GuiControl, 4:, Static2, :!:
            If ASmiley = Button18
              GuiControl, 4:, Static2, :?:
            If ASmiley = Button19
              GuiControl, 4:, Static2, :idea:
            If ASmiley = Button20
              GuiControl, 4:, Static2, :arrow:
            If ASmiley = Button21
              GuiControl, 4:, Static2, :|
            If ASmiley = Button22
              GuiControl, 4:, Static2, :mrgreen:
          }
      }
  }

; Paste routine for icon buttons in BBCodeEditor.ahk
SetBBCodeTags(In_StartTag, In_EndTag)
  {
    ; In_StartTag     : Opening bbcode tag (e.g. [url])
    ; In_EndTag       : Closing bbcode tag (e.g. [/url])
    
    local Ret_Val
        
    ;Determine length of EndTag
    StringLen, EndTagLen, In_EndTag
    
    ;Check whether some text was highlighted
    If ComposeMode = 0
      {
        GuiControl, 1:Focus, EdtComment
        Send, ^c
      }
    
    ; No Text was highlighted
    If Clipboard is space
      {
        MoveCaret := true
        Ret_Val = %In_StartTag%%In_EndTag%
      }
    ; Some text was highlighted
    Else
      {
        If ComposeMode
          {
            MoveCaret := true
            EndTagLen := EndTagLen + EndTagSum
            Ret_Val = %In_StartTag%%Clipboard%%In_EndTag%
            Clipboard =
          }
        Else
          {
            MoveCaret := false
            Ret_Val = %In_StartTag%%Clipboard%%In_EndTag%
            Clipboard =
          }
      }
    
    ; Reset variables for ComposeMode
    SB_SetIcon(A_ScriptDir "\phpbb\ico\clean.ico", 1, 2)
    ComposeMode := false
    EndTagSum = 0
    
    ; Clear ComposeList and Statusbar Part3
    ComposeList =
    SB_SetText(ComposeList,3)
    
    Return, %Ret_Val%
  }

ComposeBBCodeTags(In_StartTag, In_EndTag)
  {
    ; In_StartTag     : Opening bbcode tag (e.g. [url])
    ; In_EndTag       : Closing bbcode tag (e.g. [/url])
    
    local Ret_Val
        
    ;Determine length of EndTag
    StringLen, EndTagLen, In_EndTag
    EndTagSum := EndTagSum + EndTagLen

    ;Check whether some text was highlighted
    If ComposeMode = 0
      {
        GuiControl, 1:Focus, EdtComment
        Send, ^c
      }
    
    ; No Text was highlighted
    If Clipboard is space
      Ret_Val = %In_StartTag%%In_EndTag%
    ; Some text was highlighted
    Else
      Ret_Val = %In_StartTag%%Clipboard%%In_EndTag%
    
    ; Set variables for ComposeMode
    SB_SetIcon(A_ScriptDir "\phpbb\ico\compose.ico", 1, 2)
    ComposeMode := true
    
    ; Add In_StartTag to ComposeList
    StringTrimLeft, ComposeListEntry, In_StartTag, 1
    StringTrimRight, ComposeListEntry, ComposeListEntry, 1
    ComposeList = %ComposeList% %ComposeListEntry% -
    SB_SetText(ComposeList,3)
    
    Return, %Ret_Val%      
  }

Anchor(In_CtrlVar, In_Anchor, Draw = false) 
  { 
    ; Thanks to Titan for this function (v3.4.2)
    ; Details under http://www.autohotkey.com/forum/topic4348.html
    
    ; In_CtrlVar  : Controls associated variable (e.g. "MyEdit")
    ; In_Anchor   : Anchors (x, y, w, h)
    ; Draw        : true/1 to use MoveDraw otherwise leave blank for a normal Move  
  
    ; store control positions and sizes in an internally parsable table-like format
    static DataTbl
    global ResetAnchor, DataTblCtrlList
  	
  	If ResetAnchor
      {
        DataTbl =
        StringSplit, CtrlListArray, DataTblCtrlList, `n

        ; Loop 12 times because of twelve controls in GuiSize label
        Loop, %CtrlListArray0%
          {
            StringSplit, CtrlEntryArray, CtrlListArray%A_Index%, `,
            
            GuiControlGet, CtrlPS, Pos, %CtrlEntryArray1%
            Signtre = `n%A_Gui%:%CtrlEntryArray1%
            PrsHlp = x.w.y.h./.7.%A_GuiWidth%.%A_GuiHeight%
            StringSplit, PrsHlp, PrsHlp, .
            
            Loop, 4
              RelFact%A_Index% += !RegExMatch(CtrlEntryArray2, PrsHlp%A_Index% . "(?P<" . A_Index . ">[\d.]+)", RelFact)

            If !InStr(DataTbl, Signtre)
              DataTbl := DataTbl . Signtre . CtrlPSX - PrsHlp7 * RelFact1 . PrsHlp5 . CtrlPSW - PrsHlp7 * RelFact2
                      .  PrsHlp5 . CtrlPSY - PrsHlp8 * RelFact3 . PrsHlp5 . CtrlPSH - PrsHlp8 * RelFact4 . PrsHlp5                         
          }
        
        ResetAnchor := false
      }
        
  	
    ; Retrieve control's size and position
    GuiControlGet, CtrlPS, Pos, %In_CtrlVar%
    ; If control doesn't exist or this thread isn't called by a GUI event... 
    If !A_Gui or ErrorLevel
      Return

    ; Create identifier for the control in the current window
    Signtre = `n%A_Gui%:%In_CtrlVar%
    ; Period-delimited variable for parsing support
    PrsHlp = x.w.y.h./.7.%A_GuiWidth%.%A_GuiHeight%
    StringSplit, PrsHlp, PrsHlp, .
  	
    ; Retrieve relative factors by RegEx and store them into "RelFact" array
    Loop, 4
      RelFact%A_Index% += !RegExMatch(In_Anchor, PrsHlp%A_Index% . "(?P<" . A_Index . ">[\d.]+)", RelFact)

    ; If current signature is not found in the data table, concatenate each value 
    ; subtracted by the gui width for x/w or height for y/h and multiplied by it's factor.
    If !InStr(DataTbl, Signtre)
      DataTbl := DataTbl . Signtre . CtrlPSX - PrsHlp7 * RelFact1 . PrsHlp5 . CtrlPSW - PrsHlp7 * RelFact2
              .  PrsHlp5 . CtrlPSY - PrsHlp8 * RelFact3 . PrsHlp5 . CtrlPSH - PrsHlp8 * RelFact4 . PrsHlp5

    ; For each of the four possible anchors (again):
    Loop, 4
      If InStr(In_Anchor, PrsHlp%A_Index%) 
        {
          ; Alias for the Loop index
          LoopIdx = %A_Index%
          ; For x/w, PrsHlp6 equals to the GUI width, otherwise height 
        	PrsHlp6 += !cx AND (cx := LoopIdx > 2)
          ; This regular expression assigns the variable CtrlPS1 to the absolute dimension
          ; stored in the data table:
        	RegExMatch(DataTbl, Signtre . "(?:(-?[\d.]+)/){" . LoopIdx . "}", CtrlPS)
          ; Concatenate the new value and it's anchor to the variable 'NewVal':
        	NewVal := NewVal . PrsHlp%LoopIdx% . CtrlPS1 + PrsHlp%PrsHlp6% * RelFact%LoopIdx%
        }
    ; If Draw is true use GuiControl, MoveDraw instead of normal GuiControl, Move 
    If Draw
      GCtrlMv = Draw
    ; Update the positions of the control
    GuiControl, Move%GCtrlMv%, %In_CtrlVar%, %NewVal%
  }

; Needed for ColorPicker in Color GUI
ExtractInteger(ByRef pSource, pOffset = 0, pIsSigned = false, pSize = 4)
  {
    ; See DllCall documentation for details.
    SourceAddress := &pSource + pOffset  ; Get address and apply the caller's offset.
    Result := 0   ; Init prior to accumulation in the loop.
    Loop %pSize%  ; For each byte in the integer:
      {
        Result := Result | (*SourceAddress << 8 * (A_Index - 1))  ; Build the integer from its bytes.
        SourceAddress += 1  ; Move on to the next byte.
      }
    If (!pIsSigned OR pSize > 4 OR Result < 0x80000000)
      Return, Result  ; Signed vs. unsigned doesn't matter in these cases.
    ; Otherwise, convert the value (now known to be 32-bit) to its signed counterpart:
    Return, -(0xFFFFFFFF - Result + 1)
  }

; Needed for ColorPicker in Color GUI
InsertInteger(pInteger, ByRef pDest, pOffset = 0, pSize = 4)
  {
    ; To preserve any existing contents in pDest, only pSize number of bytes starting at
    ; pOffset are altered in it. The caller must ensure that pDest has sufficient capacity.
    Mask := 0xFF  ; This serves to isolate each byte, one by one.
    Loop %pSize%  ; Copy each byte in the integer into the structure as raw binary data.
      {
        DllCall("RtlFillMemory", "UInt", &pDest + pOffset + A_Index - 1, "UInt", 1  ; Write one byte.
               , "UChar", (pInteger & Mask) >> 8 * (A_Index - 1))
        Mask := Mask << 8  ; Set it up for isolation of the next byte.
      }
  }

; Needed for ColorPicker in Color GUI
BGRtoRGB(oldValue)
  {
    Value := (oldValue & 0x00ff00)
    Value += ((oldValue & 0xff0000) >> 16)
    Value += ((oldValue & 0x0000ff) << 16) 
    Return, Value
  }
;##############################################################################
;####### End of Functions definition ##########################################
;##############################################################################
