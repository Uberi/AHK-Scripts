#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
DetectHiddenWindows, On

If (!pToken := Gdip_Startup()){
  MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system.
  ExitApp
}


Gui, color, yellow
GUI, add, text, x20 y450, This is GDI+ research code
Gui, 1: Add, Picture, x450 y340 w100 h100 0xE vProgressBar
Gui, show, w400 h500, Example GDI+

GuiControlGet, _hwnd, hwnd, ProgressBar

HWND := WinExist("A")

hdc_WINDOW      := GetDC(HWND)                                               ; MASTER DC on the Window

; 1.  THis is my main frame
hbm_main := CreateDIBSection(400, 400)
hdc_main := CreateCompatibleDC()
obm     := SelectObject(hdc_main, hbm_main)
G        := Gdip_GraphicsFromHDC(hdc_main)

SetTimer, DRAW_SCENE, 70


;some brushes
   BLOCKWORLD_C_YELLOW  := Gdip_BrushCreateSolid(0xFFFF0e00e)
   BLOCKWORLD_C_OLVIVE  := Gdip_BrushCreateSolid(0xFF808000)
   BLOCKWORLD_C_TURCI   := Gdip_BrushCreateSolid(0xff008080)
   pBGREEN              := Gdip_BrushCreateSolid(0xff00FF00)
   pBTURCI              := Gdip_BrushCreateSolid(0xff008080)
   pBWHITE              := Gdip_BrushCreateSolid(0xffFFFFFF)
   pBBLACK              := Gdip_BrushCreateSolid(0xff000000)

GOSUB, SETUP_SCENE
return     
   
   
SETUP_SCENE:   
; Draw Background
   Gdip_FillRectangle(G,pBBLACK,0,0,400,400)
   
   SPRITES  := 11  ;23
   Prefix   := "ef32_"
   
   CNT  := 0
   Loop, % SPRITES
   {
      num := a_index ".0"
      SetFormat,float,03.0   
      num += 0
      LOAD_OBJECT(A_ScriptDir "\effect\" Prefix num ".png" )
   }
   
   
   
   counter  := 1
   Max      := SPRITES
   plus := true
   Loop
   {
      Gdip_FillRectangle(G,pBBLACK,50,50,bw,bh)
      Gdip_DrawImage(G, BITMAP_%counter%, 50, 50, bw, bh,0,0,bw,bh)
      If(counter = Max){
         plus := false
      }else if(counter = 1){
         plus := true
      }
   
      If(plus){
         ++counter
      }else{
         --counter
      }
      sleep, 70
   }
return


GuiClose:
exitapp


LOAD_OBJECT(path){
   global
   
   If(fileexist(path) = ""){
      msgbox errer`n%path%
      return, 0
   }
   ++CNT

   BITMAP_%CNT% := Gdip_CreateBitmapFromFile(path)
   
   bw   := Gdip_GetImageWidth(BITMAP_%CNT%)
   bh   := Gdip_GetImageHeight(BITMAP_%CNT%)
   
   Return, CNT
}


;draws the scene
DRAW_SCENE:
   BitBlt(hdc_WINDOW,0, 0, 400,400, hdc_main,0,0)
return

#Include %A_ScriptDir%\..\Lib\Gdip.ahk