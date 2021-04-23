#Include Gdip.ahk

/*
Name:    Verts
version: 1.2 (Sat March 17, 2012)
Created: Tue March 13, 2012
Author:  tidbit


CAUTION! Before reading this code, I apologize for how awful it is. Even I get confused reading it!
Enjoy.



Description:
   Plot out all controls of a window into a 3d space.
   This can be used to debug the layout visually.
   Some windows/programs generate an interesting output. And with some tweaking you could make some interesting 3D game maps or even buildings/structures.

Keys:
   ctrl & j --- runs the program on th active window.
   esc      --- Exit

Notes:
   * GDI+ by tic is REQUIRED. I have not #Included it yet. Sorry.
        GDI+ url: http://www.autohotkey.com/forum/viewtopic.php?t=32238
   * My functions would probably make anyone else cry, sorry. I'm no math magician or geometry master!
   * The code itself would probably make anyone cry, I apologize!
   * Optimizations/improvement are _VERY_ welcome.
   * The output is in .obj format. A standard 3D format.
   * This does nothing advanced, don't expect to much.
   * The program exits after saving the files.
   * Some controls and windows comes out black, I do not know why.

coordinates info:
   WINDOWS coordinates
      [1]                  [2]
      x, y                 x+w, y
      ---------------------
      |                   |
      |                   |
      ---------------------
      x, y+h               x+w, y+h
      [3]                  [4]

   .OBJ coordinates
      [2][0,1]             [3][1,1]
      x, y                 x+w, y
      ---------------------
      |                   |
      |                   |
      ---------------------
      x, y+h               x+w, y+h
      [1][0,0]             [4][1,0]


functions:
   rnd(min=0.0, max=1.0)
   materials(name, image, win, mode=0, r=0, g=0, b=0)
   Rect(x,y,z,w,h, mode=0, comment="", name="")
{

*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
onexit, quit

dbg:=0 ; debug. doesn't do much.
filename=untitled
filesPath=%A_ScriptDir%\%filename%_Images

; if 0, it'll save 1 image of the entire window.
; if 1, it'll save an each for each and every control.
;  this may take longer, as a window could have hundreds of controls.
;  this also generates more accurate models.
;  when using 1, please note that not all controls can be get. so stuff might be black.
PerControlImage:=0
; the image name to use if in single image mode (0). Just the name, not the ext.
image=Window

pToken := Gdip_Startup()

; create the saving folder if it doesn't exist.
if (!FileExist(filesPath))
   FileCreateDir, %filesPath%

; a small test GUI
Gui, add, button, x6 y6 w300, button
Gui, add, edit, x6 y+6 w200 r4, Edit
gui, show, , title
Return

j::
   ; header for the .obj file.
   header=
   (ltrim
   # 3D window analysis thing
   # By: tidbit
   mtllib %filename%.mtl

   )


   ; the base window
   ; ---------------------------------------------
   ; get the active window info and its hwnd.
   ; then we plot the base plane, the one at the very bottom.
   WinGetActiveStats, Title, ww, wh, wx, wy
   WinGet, ID, ID, A
   wx:=0, wy:=0 ; start the window at 0,0 in the 3d space
   vertCoords.=rect(wx, wy, 0, ww, wh, 0, "Base_Window", "Base_Window")

   ; now we decide how to get and save the image of the base plane.
   ; if 0, save the window to the image file set at the top.
   ; if 1, we give the window its own unique image.
   if (PerControlImage=0) ; use the same image for everything.
      materials.=materials("Base_Window", image, ID, 0, rnd(0.5, 1.0), rnd(0.5, 1.0), rnd(0.5, 1.0))
   else ; use the image as defined by the rect() function above
      materials.=materials("Base_Window", "Base_Window", ID, 0, rnd(0.5, 1.0), rnd(0.5, 1.0), rnd(0.5, 1.0))

   ; all the Controls
   ; ---------------------------------------------
   ; get all the Controls.
   ; then parse them.
   WinGet, Controls, ControlList, %Title%

   ; get all the cordinates of a control and plot them ...
   ; ...and their UV coords, depending on the mode.
   Loop, Parse, Controls, `n, `r
   {
      ControlGetPos, cx, cy, cw, ch, %A_LoopField%, %Title%
      vertCoords.=rect(cx, cy, A_Index/10, cw, ch, PerControlImage, A_LoopField, A_LoopField)

      ; debug stuff
      ; blah.=A_LoopField "`n" "x: " cx "`n" "y: " cy "`n" "w: " cw "`n" "h: " ch "`n" "---`n" ww "`n" wh "`n`n"

      ; this applies a random material color for every object.
      ; it also tries to asigns the apropriate texture for each object (control)
      if (PerControlImage=0) ; use the same image for everything.
         materials.=materials(A_LoopField, image, ID, PerControlImage, rnd(0.5, 1.0), rnd(0.5, 1.0), rnd(0.5, 1.0))
      else ; use the image with the same name as the control.
         materials.=materials(A_LoopField, A_LoopField, ID, PerControlImage, rnd(0.5, 1.0), rnd(0.5, 1.0), rnd(0.5, 1.0))
   }


   ; update the Files
   ; ---------------------------------------------
   ; yadda yadda yadda
   
   if (dbg)
   {
      ; MsgBox % blah
      MsgBox % vertcoords
      MsgBox % materials
   }
   else
   {
      ToolTip deleting
      FileDelete, %filesPath%\%filename%.obj
      FileDelete, %filesPath%\%filename%.mtl
      sleep, 200
      ToolTip saving
      sleep, 400
      FileAppend, %header%`n%vertcoords%, %filesPath%\%filename%.obj
      FileAppend, %materials%, %filesPath%\%filename%.mtl
   }

   gosub, quit
Return



quit:
   Gdip_Shutdown(pToken)
ExitApp



; ----------------+===========+----------------
; ----------------: FUNCTIONS :----------------
; ----------------+===========+----------------

; AHK should really have a built-in random function, hehe.
rnd(min=0.0, max=1.0)
{
   random, rnd, %min%, %max%
   return rnd
}

; materials(name, image, win, mode=0, r=0, g=0, b=0)
;    name:  The name of the material. this gets called by the .obj file.
;    image: The images name to be saved as. NO EXTENSION.
;    win:   expects an HWND. The windows HWND that contains the control(s) you want to gather.
;    mode:  0 or 1. 0 = get the whole window and only the whole window. 1 = give every control its own image.
;    r,g,b: This is the RGB color of the lane you see when NOT in a textured view.
materials(name, image, win, mode=0, r=0, g=0, b=0)
{
   Global filesPath ; oh hush.
   static offset:=0 ; this is to avoid saving the same image dozens of times in Mode 0

   image:=regexreplace(image, "[\\/*?"":<>|]+", "_")

   if (mode=0 && offset=0) ; image of the entire window
   {
      pBitmap := Gdip_BitmapFromHWND(win)
      Gdip_SaveBitmapToFile(pBitmap, filesPath "\" image ".png")
      offset+=1
   }
   Else if (mode=1)
   {
      ControlGet, OutputVar, Hwnd,, %name%, AHK_id %win%
      pBitmap := Gdip_BitmapFromHWND(OutputVar)
      Gdip_SaveBitmapToFile(pBitmap, filesPath "\" image ".png")
      ; offset:=0 ; reset it, just incase (which could be never, but whatever)
   }

   ; blah=newmtl %name%`nKd %r% %g% %b%`nmap_Kd %filesPath%\%image%.png`n`n
   Gdip_DisposeImage(pBitmap)
   return "newmtl " name "`nKd " r " " g " " b "`nmap_Kd " filesPath "\" image ".png`n`n"
}

; Rect(x,y,z,w,h, mode=0, comment="", name="")
; note: this is a PLANE. a flat object with no thickness.
; x:       X coordinate of upper-left corner
; y:       Depending on your program, this may be the "Up" or the width.
; z:       Depending on your program, this may be the "Up" or the width.
; w:       How long the object should be.
; h:       How tall the object should be.
; mode:    0 or 1. Determines how to assign the textures and their UV coords.
;             0: 1 image only, reused by every plane.
;             1: 1 image for ever plane,
; comment: The comment that goes in the .obj file. Not needed, but it helps organize things.
; name:    This is the objects name AND determines what material to use, if any.
Rect(x,y,z,w,h, mode=0, comment="", name="")
{
   static offset:=0, ww:=0, wh:=0
   ScaleD:=0.01

   if (offset==0)
   {
      wW:=w
      wH:=h
   }

   if (mode=0) ; whole image relative mode
   {
      texBotL:="vt " x*(1/wW)     " " (wh-(y+h))*(1/wh) "`n"
      texTopL:="vt " x*(1/wW)     " " (wh-y)*(1/wh)     "`n"
      texTopR:="vt " (x+w)*(1/wW) " " (wh-y)*(1/wh)     "`n"
      texBotR:="vt " (x+w)*(1/wW) " " (wh-(y+h))*(1/wh) "`n"
   }
   else ; per control 100% fill.
   {
      texBotL:="vt " 0 " " 0 "`n"
      texTopL:="vt " 0 " " 1 "`n"
      texTopR:="vt " 1 " " 1 "`n"
      texBotR:="vt " 1 " " 0 "`n"
   }

   coords:= "# " comment "`n"
          . "o " name "`n"
          . "v " x*ScaleD     " " z " " (y+h)*ScaleD "`n" ; 3D bot L
          . "v " x*ScaleD     " " z " " y*ScaleD     "`n" ; 3D top L
          . "v " (x+w)*ScaleD " " z " " y*ScaleD     "`n" ; 3D top R
          . "v " (x+w)*ScaleD " " z " " (y+h)*ScaleD "`n" ; 3D bot R
          . texBotL . texTopL . texTopR . texBotR         ; 2D tex coords
          . "vn " 0.0 " " 1.0 " " 0.0 "`n"                ; Vertex Normals

   if (name!="")
      coords.="usemtl " name "`ns off`n"

   coords.="f " 1+offset "/" 1+offset "/" 1 " " 2+offset "/" 2+offset "/" 1 " " 3+offset "/" 3+offset "/" 1 " " 4+offset "/" 4+offset "/" 1 "`n`n"
   ; coords.="f " 1+offset "/" 1+offset " " 2+offset "/" 2+offset " " 3+offset "/" 3+offset "/" " " 4+offset "/" 4+offset "`n`n"

   offset+=4
   return coords
}


Esc::
guiclose:
Exitapp