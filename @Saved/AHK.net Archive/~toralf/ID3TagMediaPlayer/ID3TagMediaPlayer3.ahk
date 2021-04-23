; MediaPlayer with AudioGenie3 and BASS
; www.autohotkey.com/forum/topic55456.html
; for AHK 1.0.48.05
; by toralf
; Version 0.1 (2010-02-20)
; 
; NEEDS: bass wrapper            www.autohotkey.com/forum/topic55454.html
;        AudioGenie3 wrapper     www.autohotkey.com/forum/topic55452.html

#NoEnv
#SingleInstance Force
SetBatchLines, -1
OnExit, Exit
#Include AG3.ahk          ;include AudioGenie3 wrapper
#Include bass.ahk         ;include BASS wrapper
AG3_Init()                ;start AudioGenie3 und GDI+
BASS_Load()               ;load BASS

Language = Deu            ;set language (DEU or ENG)
Show_GUI()  
Return

Esc::
GuiClose:
Exit:
  SetTimer, UpdateGuiControls, Off
  BASS_Free()               ;free BASS
  AG3_Stop()                ;stop AudiGenie3 und GDI+
  ExitApp
Return

HandleFilePaths:
  Gui, 1:Submit, NoHide 
  HandleFilePaths(CbbFilePath,A_GuiControl,ChkRecurse)
Return
HandleFilePaths(CbbFilePath="",ControlID="",ChkRecurse=0){
  static ListOfFilePath="X:\Comedy\Michael Mittermeier\",LastFilePath
  global Gui1HWND,Language
; msgbox, HandleFilePaths( %CbbFilePath% , %ControlID% , %ChkRecurse% ) 
  If (ControlID = "CbbFilePath"){    ;user changes text in combobox or selected an existing path
    ToolTip
    GuiControlGet, ControlHwnd, 1:Hwnd, CbbFilePath
    ControlGetPos, X, Y, , H, ,ahk_id %ControlHwnd%
    If InStr("|" ListOfFilePath "|","|" CbbFilePath "|"){   ;user selected an existing choice
      ScanPath(CbbFilePath,ChkRecurse)
    }Else If (StrLen(CbbFilePath) = 1){
      If InStr(FileExist(CbbFilePath ":\"),"D"){
        CbbFilePath .= ":\"
        GuiControl, 1:, CbbFilePath, % "|" ListOfFilePath (ListOfFilePath ? "|" : "") CbbFilePath "||"
        SendInput {End}        
      }
    }Else{  ;check for paths
      Loop, %CbbFilePath%*, 2
      {
        If (A_Index > 10){
          ListFullPath .= "`n... and some/many more"
          Break
        }
        FullPath := A_Index = 1 ? A_LoopFileLongPath "\" : ""
        ListFullPath .= "`n" A_LoopFileName
      }
      If (FullPath AND !InStr(LastFilePath, CbbFilePath)){        ;choose if single possibility
        GuiControl, 1:, CbbFilePath, % "|" ListOfFilePath (ListOfFilePath ? "|" : "") FullPath "||"
        SendInput {End}
        CbbFilePath := FullPath
      }Else                                                    ;offer choices
        ToolTip, Valid possibilities:%ListFullPath%, %X% , % Y + H 
    }
    If !InStr(FileExist(CbbFilePath "*"),"D")    ;check if path exists at all
      ToolTip, %CbbFilePath%`nis not a valid path., %X% , % Y + H 
    Else
      GuiControl, 1:+Default, BtnUpdate          ;make it easy to update ListView
    LastFilePath := CbbFilePath       ;remember last text, to allow manual delete of characters
  }Else If (ControlID = "BtnBrowse"){    ;user wants to select a new path
    Name := Language = "DEU" ? "Selektiere einen Ordner zur Suche nach Musik Dateien" : "Select a folder to scan for music files"
    FileSelectFolder, CbbFilePath, ::{20d04fe0-3aea-1069-a2d8-08002b30309d}, 0, %Name%    
    If InStr(FileExist(CbbFilePath),"D"){
      ListOfFilePath .= (ListOfFilePath ? "|" : "") CbbFilePath "\"
      GuiControl, 1:, CbbFilePath, |%ListOfFilePath%||
      ScanPath(CbbFilePath "\",ChkRecurse)
    }
  }Else If (ControlID = "BtnUpdate" AND InStr(FileExist(CbbFilePath),"D")){   ;update current path
    If !InStr("|" ListOfFilePath "|","|" CbbFilePath "|"){         ;add path if new path
      ListOfFilePath .= (ListOfFilePath ? "|" : "") CbbFilePath
      GuiControl, 1:, CbbFilePath, |%ListOfFilePath%||
    }
    ScanPath(CbbFilePath,ChkRecurse)
  }Else If (!CbbFilePath AND !ControlID AND !ChkRecurse){ ;return current path list, e.g. for startup
    Return ListOfFilePath    
  }
}
ScanPath(FilePath,Recurse){
  global Language,CurrentPathForLsv,ListOfFrames
  Name := Language = "DEU" ? "Dateien" : "Files"
  
  GuiControl, 1:-Redraw,LsvFiles              ;TODO: Show Progress
  LV_Delete()
  
  Loop, %FilePath%*.mp3, , %Recurse%            ;TODO: Not only mp3!!! But which files are allowed???
  {
    AG3_Open(A_LoopFileLongPath)
;     MsgBox, % AG3_Open(A_LoopFileLongPath) "`n" ErrorLevel
    StringReplace, RelPath, A_LoopFileDir , % SubStr(FilePath,1,-1), .
    Row := LV_Add("", A_LoopFileName, RelPath "\")
    Loop, Parse, ListOfFrames, |  ;get content of all FrameIDs
      LV_Modify(Row, "Col" A_Index + 2 , AG3_ID3TFrame(A_LoopField))
    LV_Modify(Row, "Col" LV_GetCount("Column"), AG3_GetID3PictureCount())
    If (Mod(A_Index,10)=0)
      GuiControl, 1:, TxtNumFiles, %A_Index% %Name%
  }
  CurrentPathForLsv = %FilePath% 
  LV_ModifyCol(1, "Sort")
  LV_Modify(1, "Select") 
  LV_ModifyCol()
  GuiControl, 1:, TxtNumFiles, % LV_GetCount() " " Name
  GuiControl, 1:+Redraw,LsvFiles
  
  GuiControl, 1:+Default, BtnPlay
}

Show_GUI(){
  global
  ;specify all ID3 text or URL frameIDs you are interested in (APIC will be added at the end automatically)
  ListOfFrames := "TALB|TIT1|TIT2|TIT3|TPE1|TPE2|TPE3|TPE4|TPOS|TRCK|TYER|COMM"
  local Name,SS_BITMAP=0xE
  Gui, 1:+LastFound +OwnDialogs +Resize
  Gui1HWND := WinExist()
  
  Gui, 1:Add, ComboBox, w500 r10 Section +Sort vCbbFilePath gHandleFilePaths, % HandleFilePaths()
  Gui, 1:Add, Button, ys-1 r1 vBtnBrowse gHandleFilePaths, &...
  Name := Language = "DEU" ? "&Recursiv" : "&Recurse"
  Gui, 1:Add, CheckBox, ys+4 r1 vChkRecurse Checked, %Name%
  Name := Language = "DEU" ? "Akt&ualisiere" : "&Update"
  Gui, 1:Add, Button, ys-1 r1 vBtnUpdate gHandleFilePaths, %Name%
  Name := Language = "DEU" ? "Dateien" : "Files"
  Gui, 1:Add, Text, ys+4 w100 vTxtNumFiles , ???? %Name%
  Name := Language = "DEU" ? "Datei|Pfad" : "File|Path"
  Gui, 1:Add, ListView, xm w1000 r20 vLsvFiles gLsvFiles -Multi AltSubmit, %Name%|%ListOfFrames%|#APIC
  Gui, 1:Add, Button, xm Section vBtnPlay gBtnPlay Default, Pl&ay
  Gui, 1:Add, Button, x+5 vBtnStop gBtnStop, &Stop
  Gui, 1:Add, Button, x+5 vBtnPause gBtnPause, &Pause
  BASS_ProgressMeter_Add("xm")
  Gui, 1:Add, Slider, x+5 yp-50 Range-100-0 h100 vSldVolume gSldVolume Vertical NoTicks ToolTip , % BASS_Volume() * -100
  Gui, 1:Add, Slider, xm w200 vSldTrack gSldTrack HWNDhSldTrack NoTicks ToolTip ,
  Gui, 1:Add, Text, xm w200 r1 vTxtTrack Right, 
  Gui, 1:Add, Text, ys Section r1, APIC
  Gui, 1:Add, Edit, x+5 ys-3 w40 r1 Right ReadOnly -WantReturn,
  Gui, 1:Add, UpDown, Wrap vUpdNumAPIC gUpdNumAPIC , 1
  Gui, 1:Add, Text, xs w135 r1 vTxtTypeAPIC ,
  Gui, 1:Add, Picture, xs w135 h135 %SS_BITMAP% vPctAPIC HwndhPctAPIC,
  Gui, 1:Add, Edit, ys w400 r13 vEdtTags ReadOnly , 
  Gui, 1:Show, AutoSize, MediaPlayer with AudioGenie3 and BASS v0.1     ;show GUI  
}

UpdNumAPIC:
  Gui, 1:Submit, NoHide 
  AG3_ShowID3Picture(hPctAPIC, UpdNumAPIC)
  GuiControl, 1:, TxtTypeAPIC, % AG3_PictureTypeName(AG3_GetID3PictureType(UpdNumAPIC), Language)
Return

;user selected a file in listview
LsvFiles:
  If (A_GuiEvent = "I" AND InStr(ErrorLevel, "S", true)){
    FileGotSelected(A_EventInfo)
  }Else If (A_GuiEvent = "DoubleClick")
    GoSub, BtnPlay
Return
FileGotSelected(Row){
  global ListOfFrames,CurrentPathForLsv,hPctAPIC,Language
  LV_GetText(FileName, Row, 1)     ;get file name and path
  LV_GetText(RelPath, Row, 2)
  AG3_Open(CurrentPathForLsv RelPath FileName)   ;open it with AudioGenie
  Tags := "Tags : " AG3_FoundTags() "`n"
  Loop, Parse, ListOfFrames, |    ;get content of all FrameIDs
     Tags .= (Val := AG3_ID3TFrame(A_LoopField)) ? A_LoopField " = " Val "`n" : ""
  Tags .= "#APIC = " NumAPIC := AG3_GetID3PictureCount()
  GuiControl, 1:, EdtTags, %Tags%
  If NumAPIC{     ;check if picture available
    AG3_ShowID3Picture(hPctAPIC, 1)   ;show first picture and adjust picture type name
    GuiControl, 1:+Range1-%NumAPIC%, UpdNumAPIC,
    GuiControl, 1:, UpdNumAPIC,1
    GuiControl, 1:, TxtTypeAPIC, % AG3_PictureTypeName(AG3_GetID3PictureType(1), Language)
  }Else{
    AG3_ShowID3Picture(hPctAPIC)      ;remove any shown picture from control
    GuiControl, 1:+Range0-0, UpdNumAPIC
    GuiControl, 1:, UpdNumAPIC,0
    GuiControl, 1:, TxtTypeAPIC,   ;reset text info
  }  
}

BtnPlay:
  ControlMusic("Play", LV_GetNext(0, "Focused"))   ;get selected file/row
Return
ControlMusic(Modus, Row){
  static hStream,LengthInSec
  global CurrentPathForLsv,hSldTrack 
  If (Modus = "Play" AND Row){ ;play selected row
    BASS_Stop()                      ;stop playback of currently played song
    LV_GetText(FileName, Row, 1)     ;get file name and path
    LV_GetText(RelPath, Row, 2)
    hStream := BASS_Play(CurrentPathForLsv RelPath FileName)  ;play file
    GuiControl, 1:, SldTrack, 0        ;adjust Track Slider
    LengthInSec := BASS_Bytes2Seconds(hStream,BASS_GetLen(hStream))
    GuiControl, 1:+Range0-%LengthInSec%, SldTrack,
    SetTimer, UpdateGuiControls, 250
  } 
   
  UpdateGuiControls:
    BASS_ProgressMeter_Update(hStream) ;update progress meter
    MouseGetPos, , , , ControlHWND, 3  ;check and update Track Slider 
    If !(hSldTrack = ControlHWND And GetKeyState("LButton"))
      GuiControl, 1:, SldTrack, % PosInSec := BASS_Bytes2Seconds(hStream,BASS_GetPos(hStream))
    If (PosInSec >= 0){
      Name := Language = "DEU" ? Floor(PosInSec) " sek von " Floor(LengthInSec) " sek = " Floor(LengthInSec - PosInSec) " sek verbleibent"
                               : Floor(PosInSec) " sec of " Floor(LengthInSec) " sec = " Floor(LengthInSec - PosInSec) " sec left"
      GuiControl, 1:, TxtTrack, %Name%      ;ToDO: Update doesn't have to be that often  !!! ???
    }Else{
      LV_Modify(Row + 1, "Focus Select")    ;play next file in line, when done
      GoSub, BtnPlay
    }    
  Return
}
BtnStop:
  SetTimer, UpdateGuiControls, Off   ;stop update off progress meter 
  hStream := BASS_Stop()             ;stop playback
Return
BtnPause:
  hStream := BASS_Pause()            ;toogle pause of playback
Return 
SldTrack:
  Gui, 1:Submit, NoHide              ;set new position in stream
  BASS_SetPos(hStream,BASS_Seconds2Bytes(hStream,SldTrack))
Return
SldVolume:
  Gui, 1:Submit, NoHide 
  BASS_Volume(SldVolume / -100)      ;adjust master valume
Return
