#include, GL.ahk

INIRead, num, settings.ini, settings, number of uran atoms, 31
INIRead, usesounds, settings.ini, settings, enable sounds, 1
INIRead, shownames, settings.ini, settings, enable names, 1
INIRead, fod, settings.ini, settings, depth unsharp, 1

INIRead, speed, settings.ini, settings, speed, 1.0
INIRead, neutronspeed, settings.ini, settings, speed of neutrons, 2.0
INIRead, bariumspeed, settings.ini, settings, speed of barium, 0.7
INIRead, kryptonspeed, settings.ini, settings, speed of krypton, 0.7

INIRead, wndw, settings.ini, settings, window width, 640
INIRead, wndh, settings.ini, settings, window height, 480



SetWorkingDir, data

GL_Init()
MCI_Init()

Gui, +LastFound +Resize
Hotkey, IfWinActive, % "ahk_id " WinExist()
Hotkey, Space, Space
Hotkey, IfWinActive, % "ahk_id " WinExist()
Hotkey, Esc, Esc
Hotkey, IfWinActive, % "ahk_id " WinExist()
Hotkey, F1, F1
OnMessage(0x0200, "MsgHandler")
OnMessage(0x0201, "MsgHandler")
OnMessage(0x0202, "MsgHandler")

audioplay := 1
Loop, imphenzia_soundtrack_explosion04.mp3
  soundfile := A_LoopFileShortPath
if (usesounds)
{
  if (MCI_SendString("open " soundfile " alias test")=0)
  {
    audioexist := 1
    MCI_SendString("close test")
  }
}

hRC := GL_UseWindow("GUI 1")
perspective := GL_GenLists()
ortho := GL_GenLists(2)
Gui, show, w%wndw% h%wndh%, Uran Kernspaltung (Simulation)
GL_SwapBuffers()
OnExit, ExitSub

GL_LimitFrameRate(30)
GL_Enable("DEPTH_TEST")
GL_DepthFunc("LEQUAL")
GL_ClearDepth(1)
GL_Hint("PERSPECTIVE_CORRECTION_HINT", "NICEST")
GL_ShadeModel("SMOOTH")

GL_Enable("TEXTURE_2D")
color_neutron := 0x8000FF
color_krypton := 0xFFFFFF
color_barium := 0xFF
color_uran := 0xFF00

GL_LightAmbient(1, 0x000000)
GL_LightDiffuse(1, 0xFFFFFF)
GL_LightSpecular(1, 0xFFFFFF)
GL_LightPosition(1, 100, 100, 0, 1)

GL_Enable("NORMALIZE")
GL_Enable("LIGHTING")
GL_EnableLight(1)
GL_Enable("COLOR_MATERIAL")


sphere := GL_GenLists()
GL_NewList(sphere)
GL_Sphere(32, 16)
GL_EndList()

GL_TexGenMode("S", "SPHERE_MAP")
GL_TexGenMode("T", "SPHERE_MAP")
;GL_TexGenMode("S", "OBJECT_LINEAR")
;GL_TexGenMode("T", "OBJECT_LINEAR")
GL_Enable("TEXTURE_GEN_S")
GL_Enable("TEXTURE_GEN_T")

GL_Enable("CULL_FACE")

Loop, 5
{
  i := A_Index
  texture_explosion%i% := GL_LoadTexImage2D("TEXTURE_2D", "explosion" i ".png")
  explosion%i% := GL_CreateTextureAnimation(texture_explosion%i%, 4, 4, 70, 70, 11)
}

texture_symbols := GL_Load2DMipmaps("TEXTURE_2D", "symbols.png")
symbols := GL_CreateTextureAnimation(texture_symbols, 4, 4, 40, -40)
sym_play := symbols
sym_pause := symbols+4
sym_rew := symbols+8

texture_symbols_audio := GL_Load2DMipmaps("TEXTURE_2D", "symbols_audio.png")
symbols_audio_on := GL_CreateTextureAnimation(texture_symbols_audio, 2, 2, 40, -40)
symbols_audio_off := symbols_audio_on+2

texture_names := GL_Load2DMipmaps("TEXTURE_2D", "names.png")
names_neutron := GL_CreateTextureAnimation(texture_names, 1, 4, 128, -32)
names_barium := names_neutron+1
names_krypton := names_neutron+2
names_uran := names_neutron+3

lightmap_neutron := GL_LoadTexImage2D("TEXTURE_2D", "lightmap_neutron.png")
neutron := GL_GenLists()
GL_NewList(neutron)
if (!(GL_IsEnabled("TEXTURE_2D") && (lightmap_neutron)))
{
  GL_Color(color_neutron)
  GL_Enable("COLOR_MATERIAL")
}
else
  GL_BindTexture("TEXTURE_2D", lightmap_neutron)
GL_CallList(sphere)
GL_EndList()

lightmap_krypton := GL_LoadTexImage2D("TEXTURE_2D", "lightmap_krypton.png")
krypton := GL_GenLists()
GL_NewList(krypton)
if (!(GL_IsEnabled("TEXTURE_2D") && (lightmap_krypton)))
{
  GL_Color(color_krypton)
  GL_Enable("COLOR_MATERIAL")
}
else
  GL_BindTexture("TEXTURE_2D", lightmap_krypton)
GL_PushMatrix()
GL_Scale(5)
GL_CallList(sphere)
GL_PopMatrix()
GL_EndList()

lightmap_barium := GL_LoadTexImage2D("TEXTURE_2D", "lightmap_barium.png")
barium := GL_GenLists()
GL_NewList(barium)
if (!(GL_IsEnabled("TEXTURE_2D") && (lightmap_barium)))
{
  GL_Color(color_barium)
  GL_Enable("COLOR_MATERIAL")
}
else
  GL_BindTexture("TEXTURE_2D", lightmap_barium)
GL_PushMatrix()
GL_Scale(5)
GL_CallList(sphere)
GL_PopMatrix()
GL_EndList()

lightmap_uran := GL_LoadTexImage2D("TEXTURE_2D", "lightmap_uran.png")
uran := GL_GenLists()
GL_NewList(uran)
if (!(GL_IsEnabled("TEXTURE_2D") && (lightmap_uran)))
{
  GL_Color(color_uran)
  GL_Enable("COLOR_MATERIAL")
}
else
  GL_BindTexture("TEXTURE_2D", lightmap_uran)
GL_PushMatrix()
GL_Scale(10)
GL_CallList(sphere)
GL_PopMatrix()
GL_EndList()

scene := GL_GenLists()

focusX := 0
focusY := 0
focusZ := -100

neutronspeed := neutronspeed * speed
bariumspeed := bariumspeed * speed
kryptonspeed := kryptonspeed * speed

max := num*2+1

if (audioexist)
{
  Loop, % num
    MCI_SendString("open " soundfile " alias " A_Index)
}

recalc:
run := 0

Loop, % max
{
  i := A_Index
  if (A_Index=1)
  {
    neutron1x := 0
    neutron1y := -10
    neutron1z := -focusZ
    neutron1exist := 1
    uran1x := 0
    uran1y := 0
    uran1z := 0
    uran1hit := 0
    uran1exist := 1
    Random, explosionclip1, 1, 5
    distance1x := GL_CalcDistance(neutron1x, 0, 0, uran1x, 0, 0)
    distance1y := GL_CalcDistance(neutron1y, 0, 0, uran1y, 0, 0)
    distance1z := GL_CalcDistance(neutron1z, 0, 0, uran1z, 0, 0)
    distance1 := GL_CalcDistance(neutron1x, neutron1y, neutron1z, uran1x, uran1y, uran1z)
    neutron1forcex := distance1x / distance1 * neutronspeed
    neutron1forcey := distance1y / distance1 * neutronspeed
    neutron1forcez := distance1z / distance1 * neutronspeed
    neutron1forcex := (uran1x < neutron1x) ? -neutron1forcex : neutron1forcex
    neutron1forcey := (uran1y < neutron1y) ? -neutron1forcey : neutron1forcey
    neutron1forcez := (uran1z < neutron1z) ? -neutron1forcez : neutron1forcez
  }
  else if (A_Index<=num)
  {
    neutron%i%exist := 0
    posok := 0
    while (!posok)
    {
      Random, uran%i%x, -80.0, 80.0
      Random, uran%i%y, -80.0, 80.0
      Random, uran%i%z, -100.0, 10.0
      posok := 1
      Loop, % i-1
      {
        if (GL_CalcDistance(uran%i%x, uran%i%y, uran%i%z, uran%A_Index%x, uran%A_Index%y, uran%A_Index%z) <= 30)
        {
          posok := 0
          break
        }
      }
    }
    uran%i%hit := 0
    uran%i%exist := 1
    Random, explosionclip%i%, 1, 5
  }
  else
    neutron%i%exist := 0
  uran%i%namealpha := barium%i%namealpha := krypton%i%namealpha := neutron%i%namealpha := 1
}

recalc := ""

/*
Nummerierung:

              1
             / \
            /   \
           /     \
          /       \
         /         \
        2           3
       / \         / \
      /   \       /   \
     4     5     6     7
    / \   / \   / \   / \
   8   9 10 11 12 13 14 15



Benennung:
                                   (=1*2)
neutron1 -X-> uran1 -+--> barium1  /
                     |            /
                     +--> neutron2 -X-> ...
                     |                                       (=3*2)
                     +--> neutron3 -X-> uran3 -+--> barium3  /
                     |            \            |            /
                     +--> krypton1 \           +--> neutron6 -X-> ...
                                    (=1*2+1)   |
                                               +--> neutron7 -X-> ...
                                               |            \
                                               +--> krypton3 \
                                                              (=3*2+1)
*/ 

use_accum := (fod) ? 1 : 0
mouse_rotate := 0
if (use_accum)
  mouse_rotate := 0

Loop
{
  GL_CallList(perspective)
  if (use_accum)
    GL_Clear("ACCUM_BUFFER_BIT")

  Loop, % (use_accum) ? 4 : 1
  {
    if (A_Index=1)
    {
      GL_Clear("COLOR_BUFFER_BIT | DEPTH_BUFFER_BIT")
      GL_LoadIdentity()

      if (mouse_rotate)
      {
        GL_Translate(0, 0, focusZ)
        MouseGetPos, mx, my
        GL_RotateX(my)
        GL_RotateY(mx)
        GL_Translate(0, 0, -focusZ)
      }
      if ((recalc="") || (run))
      {
        GL_NewList(scene, "COMPILE_AND_EXECUTE")
        GL_PushMatrix()

        GL_Translate(0, 0, focusZ)
        Loop, % max
        {
          i := A_Index
          if ((uran%i%hit>0) && (uran%i%hit<17))
            uran%i%hit ++
          if (uran%i%exist)
          {
            if (uran%i%hit <= 8)
            {
              if ((neutron%i%exist) && (uran%i%hit = 0) && (GL_CalcDistance(neutron%i%x, neutron%i%y, neutron%i%z, uran%i%x, uran%i%y, uran%i%z) <= 10))
              {
                if ((audioexist) && (audioplay))
                  MCI_SendString("play " i " from 0")
                uran%i%hit := 1
                neutron%i%exist := 0
              }

              GL_PushMatrix()
              GL_Translate(uran%i%x, uran%i%y, uran%i%z)
              GL_CallList(uran)
              GL_PopMatrix()
            }
            else
            {
              uran%i%exist := 0
              neutron%i%exist := 0
              na := i*2
              nb := na+1
              neutron%na%exist := neutron%nb%exist := 1
              krypton%i%x := barium%i%x := neutron%na%x := neutron%nb%x := uran%i%x
              krypton%i%y := barium%i%y := neutron%na%y := neutron%nb%y := uran%i%y
              krypton%i%z := barium%i%z := neutron%na%z := neutron%nb%z := uran%i%z

              Random, krypton%i%dstx, krypton%i%x-1.0, krypton%i%x+1.0
              Random, krypton%i%dsty, krypton%i%y-1.0, krypton%i%y+1.0
              Random, krypton%i%dstz, krypton%i%z-1.0, krypton%i%z+1.0
              krypton%i%distx := GL_CalcDistance(krypton%i%x, 0, 0, krypton%i%dstx, 0, 0)
              krypton%i%disty := GL_CalcDistance(krypton%i%y, 0, 0, krypton%i%dsty, 0, 0)
              krypton%i%distz := GL_CalcDistance(krypton%i%z, 0, 0, krypton%i%dstz, 0, 0)
              krypton%i%dist := GL_CalcDistance(krypton%i%x, krypton%i%y, krypton%i%z, krypton%i%dstx, krypton%i%dsty, krypton%i%dstz)
              krypton%i%forcex := krypton%i%distx / krypton%i%dist * kryptonspeed
              krypton%i%forcey := krypton%i%disty / krypton%i%dist * kryptonspeed
              krypton%i%forcez := krypton%i%distz / krypton%i%dist * kryptonspeed
              krypton%i%forcex := (krypton%i%dstx > krypton%i%x) ? -krypton%i%forcex : krypton%i%forcex
              krypton%i%forcey := (krypton%i%dsty > krypton%i%y) ? -krypton%i%forcey : krypton%i%forcey
              krypton%i%forcez := (krypton%i%dstz > krypton%i%z) ? -krypton%i%forcez : krypton%i%forcez

              Random, barium%i%dstx, barium%i%x-1.0, barium%i%x+0.0
              Random, barium%i%dsty, barium%i%y-1.0, barium%i%y+1.0
              Random, barium%i%dstz, barium%i%z-1.0, barium%i%z+1.0
              barium%i%distx := GL_CalcDistance(barium%i%x, 0, 0, barium%i%dstx, 0, 0)
              barium%i%disty := GL_CalcDistance(barium%i%y, 0, 0, barium%i%dsty, 0, 0)
              barium%i%distz := GL_CalcDistance(barium%i%z, 0, 0, barium%i%dstz, 0, 0)
              barium%i%dist := GL_CalcDistance(barium%i%x, barium%i%y, barium%i%z, barium%i%dstx, barium%i%dsty, barium%i%dstz)
              barium%i%forcex := barium%i%distx / barium%i%dist * bariumspeed
              barium%i%forcey := barium%i%disty / barium%i%dist * bariumspeed
              barium%i%forcez := barium%i%distz / barium%i%dist * bariumspeed
              barium%i%forcex := (barium%i%dstx > barium%i%x) ? -barium%i%forcex : barium%i%forcex
              barium%i%forcey := (barium%i%dsty > barium%i%y) ? -barium%i%forcey : barium%i%forcey
              barium%i%forcez := (barium%i%dstz > barium%i%z) ? -barium%i%forcez : barium%i%forcez

              if (!uran%na%exist)
              {
                Random, neutron%na%dstx, neutron%na%x-1.0, neutron%na%x+1.0
                Random, neutron%na%dsty, neutron%na%y-1.0, neutron%na%y+1.0
                Random, neutron%na%dstz, neutron%na%z-1.0, neutron%na%z+1.0
              }
              else
              {
                neutron%na%dstx := uran%na%x
                neutron%na%dsty := uran%na%y
                neutron%na%dstz := uran%na%z
              }
              neutron%na%distx := GL_CalcDistance(neutron%na%x, 0, 0, neutron%na%dstx, 0, 0)
              neutron%na%disty := GL_CalcDistance(neutron%na%y, 0, 0, neutron%na%dsty, 0, 0)
              neutron%na%distz := GL_CalcDistance(neutron%na%z, 0, 0, neutron%na%dstz, 0, 0)
              neutron%na%dist := GL_CalcDistance(neutron%na%x, neutron%na%y, neutron%na%z, neutron%na%dstx, neutron%na%dsty, neutron%na%dstz)
              neutron%na%forcex := neutron%na%distx / neutron%na%dist * neutronspeed
              neutron%na%forcey := neutron%na%disty / neutron%na%dist * neutronspeed
              neutron%na%forcez := neutron%na%distz / neutron%na%dist * neutronspeed
              neutron%na%forcex := (neutron%na%dstx < neutron%na%x) ? -neutron%na%forcex : neutron%na%forcex
              neutron%na%forcey := (neutron%na%dsty < neutron%na%y) ? -neutron%na%forcey : neutron%na%forcey
              neutron%na%forcez := (neutron%na%dstz < neutron%na%z) ? -neutron%na%forcez : neutron%na%forcez

              if (!uran%nb%exist)
              {
                Random, neutron%nb%dstx, neutron%nb%x-1.0, neutron%nb%x+1.0
                Random, neutron%nb%dsty, neutron%nb%y-1.0, neutron%nb%y+1.0
                Random, neutron%nb%dstz, neutron%nb%z-1.0, neutron%nb%z+1.0
              }
              else
              {
                neutron%nb%dstx := uran%nb%x
                neutron%nb%dsty := uran%nb%y
                neutron%nb%dstz := uran%nb%z
              }
              neutron%nb%distx := GL_CalcDistance(neutron%nb%x, 0, 0, neutron%nb%dstx, 0, 0)
              neutron%nb%disty := GL_CalcDistance(neutron%nb%y, 0, 0, neutron%nb%dsty, 0, 0)
              neutron%nb%distz := GL_CalcDistance(neutron%nb%z, 0, 0, neutron%nb%dstz, 0, 0)
              neutron%nb%dist := GL_CalcDistance(neutron%nb%x, neutron%nb%y, neutron%nb%z, neutron%nb%dstx, neutron%nb%dsty, neutron%nb%dstz)
              neutron%nb%forcex := neutron%nb%distx / neutron%nb%dist * neutronspeed
              neutron%nb%forcey := neutron%nb%disty / neutron%nb%dist * neutronspeed
              neutron%nb%forcez := neutron%nb%distz / neutron%nb%dist * neutronspeed
              neutron%nb%forcex := (neutron%nb%dstx < neutron%nb%x) ? -neutron%nb%forcex : neutron%nb%forcex
              neutron%nb%forcey := (neutron%nb%dsty < neutron%nb%y) ? -neutron%nb%forcey : neutron%nb%forcey
              neutron%nb%forcez := (neutron%nb%dstz < neutron%nb%z) ? -neutron%nb%forcez : neutron%nb%forcez
            }
          }
          else if (uran%i%hit>0)
          {
            krypton%i%x += krypton%i%forcex
            krypton%i%y += krypton%i%forcey
            krypton%i%z += krypton%i%forcez
            GL_PushMatrix()
            GL_Translate(krypton%i%x, krypton%i%y, krypton%i%z)
            GL_CallList(krypton)
            GL_PopMatrix()

            barium%i%x += barium%i%forcex
            barium%i%y += barium%i%forcey
            barium%i%z += barium%i%forcez
            GL_PushMatrix()
            GL_Translate(barium%i%x, barium%i%y, barium%i%z)
            GL_CallList(barium)
            GL_PopMatrix()
          }
          if (neutron%i%exist)
          {
            neutron%i%x += neutron%i%forcex
            neutron%i%y += neutron%i%forcey
            neutron%i%z += neutron%i%forcez
            GL_PushMatrix()
            GL_Translate(neutron%i%x, neutron%i%y, neutron%i%z)
            GL_CallList(neutron)
            GL_PopMatrix()
          }

          if ((uran%i%hit>0) && (uran%i%hit<17))
          {
            explosionclip := explosionclip%i%
            GL_PushMatrix()
            GL_Translate(uran%i%x, uran%i%y, uran%i%z)
            GL_CallList(explosion%explosionclip%+uran%i%hit-1)
            GL_PopMatrix()
            uran%i%hit ++
          }
        }
        GL_PopMatrix()
        if (use_accum)
          GL_Accum("ACCUM", 0.25)
        GL_EndList()
      }
      else
        GL_CallList(scene)
      recalc := 0
    }
    else if (use_accum)
    {
      GL_Clear("COLOR_BUFFER_BIT | DEPTH_BUFFER_BIT")
      GL_LoadIdentity()
      GL_Translate(focusX, focusY, focusZ)
      
      if (A_Index=2)
        GL_Rotate(fod, -1, 0, 0)
      else if (A_Index=3)
        GL_Rotate(fod, 0.5, -0.5, 0)
      else if (A_Index=4)
        GL_Rotate(fod, 0.5, +0.5, 0)
      
      GL_Translate(-focusX, -focusY, -focusZ)
      GL_CallList(scene)
    }
  }
  if (use_accum)
    GL_Accum("RETURN", 1)

  if (shownames)
  {
    GL_LoadIdentity()
    GL_GetDouble("MODELVIEW_MATRIX", 16, m)
    GL_GetDouble("PROJECTION_MATRIX", 16, p)
    GL_GetInteger("VIEWPORT", 4, v)
    Loop, % max
    {
      i := A_Index
      if (A_Index<=num)
      {
        if (uran%i%exist)
          GL_Project(uran%i%x, uran%i%y+12, uran%i%z+focusZ, &m, &p, &v, winuran%i%x, winuran%i%y, winuran%i%z)
        else
        {
          GL_Project(barium%i%x, barium%i%y+7, barium%i%z+focusZ, &m, &p, &v, winbarium%i%x, winbarium%i%y, winbarium%i%z)
          GL_Project(krypton%i%x, krypton%i%y+7, krypton%i%z+focusZ, &m, &p, &v, winkrypton%i%x, winkrypton%i%y, winkrypton%i%z)
        }
      }
      if (neutron%i%exist)
        GL_Project(neutron%i%x, neutron%i%y+3, neutron%i%z+focusZ, &m, &p, &v, winneutron%i%x, winneutron%i%y, winneutron%i%z)
    }
  }


  GL_CallList(ortho)

  if (shownames)
  {
    GL_GetDouble("MODELVIEW_MATRIX", 16, m)
    GL_GetDouble("PROJECTION_MATRIX", 16, p)
    GL_GetInteger("VIEWPORT", 4, v)
    Loop, % max
    {
      i := A_Index
      if (A_Index<=num)
      {
        if (uran%i%exist)
        {
          GL_UnProject(winuran%i%x, winuran%i%y, winuran%i%z, &m, &p, &v, ox, oy, oz)
          GL_Color(1, 1, 1, 1)
          GL_PushMatrix()
          GL_Translate(Round(ox), Round(oy), 0)
          GL_CallList(names_uran)
          GL_PopMatrix()
        }
        else
        {
          if (run)
            barium%i%namealpha -= 0.004
          GL_Color(1, 1, 1, barium%i%namealpha)

          GL_UnProject(winbarium%i%x, winbarium%i%y, winbarium%i%z, &m, &p, &v, ox, oy, oz)
          GL_PushMatrix()
          GL_Translate(Round(ox), Round(oy), 0)
          GL_CallList(names_barium)
          GL_PopMatrix()

          GL_UnProject(winkrypton%i%x, winkrypton%i%y, winkrypton%i%z, &m, &p, &v, ox, oy, oz)
          GL_PushMatrix()
          GL_Translate(Round(ox), Round(oy), 0)
          GL_CallList(names_krypton)
          GL_PopMatrix()
        }
      }
      if (neutron%i%exist)
      {
        if (run)
          neutron%i%namealpha -= 0.004
        GL_Color(1, 1, 1, neutron%i%namealpha)
        GL_UnProject(winneutron%i%x, winneutron%i%y, winneutron%i%z, &m, &p, &v, ox, oy, oz)
        GL_PushMatrix()
        GL_Translate(Round(ox), Round(oy), 0)
        GL_CallList(names_neutron)
        GL_PopMatrix()
      }
    }
  }
  GL_Disable("DEPTH_TEST")
  GL_Color(1, 1, 1, 1)

  if (!cursorX)
    cursorX := 0
  if (!cursorY)
    cursorY := 0

  GL_Translate(30, screenh-30)
  if (GL_IsPointInCircle(cursorX, cursorY, 30, screenh-30, 20))
  {
    if (lbutton)
    {
      if (!ldownon)
        ldownon := "rew"
      GL_CallList(sym_rew+2)
    }
    else
    {
      GL_CallList(sym_rew+1)
      if (ldownon = "rew")
      {
        ldownon := ""
        recalc := 1
      }
    }
  }
  else
    GL_CallList(sym_rew)
  GL_LoadIdentity()

  GL_Translate(70, screenh-30)
  sym_play_pause := (run) ? sym_pause : sym_play
  if (GL_IsPointInCircle(cursorX, cursorY, 70, screenh-30, 20))
  {
    if (lbutton)
    {
      if (!ldownon)
        ldownon := "play"
      GL_CallList(sym_play_pause+2)
    }
    else
    {
      GL_CallList(sym_play_pause+1)
      if (ldownon = "play")
      {
        ldownon := ""
        run := !run
      }
    }
  }
  else
    GL_CallList(sym_play_pause)
  GL_LoadIdentity()

  if (audioexist)
  {
    GL_Translate(screenw-30, screenh-30)
    sym_audio := (audioplay) ? symbols_audio_off : symbols_audio_on
    if (GL_IsPointInCircle(cursorX, cursorY, screenw-30, screenh-30, 20))
    {
      if (lbutton)
      {
        audioplay := !audioplay
        lbutton := 0
      }
      GL_CallList((audioplay) ? symbols_audio_off+1 : symbols_audio_on+1)
    }
    else
      GL_CallList((audioplay) ? symbols_audio_on : symbols_audio_off)
    GL_LoadIdentity()

    if ((ldownon) && (!lbutton))
      ldownon := ""
  }

  GL_SwapBuffers()
  if (recalc)
    goto, recalc
}
return

Space:
run := !run
return

Esc:
recalc := 1
return

F1:
audioplay := !audioplay
return

GuiSize:
screenw := A_GuiWidth
screenh := A_GuiHeight
GL_Viewport(0, 0, A_GuiWidth, A_GuiHeight)

GL_NewList(perspective)
GL_MatrixMode("PROJECTION")
GL_LoadIdentity()
GL_Perspective(90, A_GuiWidth/A_GuiHeight)
GL_MatrixMode("MODELVIEW")
GL_LoadIdentity()
GL_Enable("DEPTH_TEST")
GL_Enable("CULL_FACE")
GL_EndList()

GL_NewList(ortho)
GL_MatrixMode("PROJECTION")
GL_LoadIdentity()
GL_Ortho(0, A_GuiWidth, A_GuiHeight, 0, -1, 1000)
GL_MatrixMode("MODELVIEW")
GL_LoadIdentity()
GL_Disable("CULL_FACE")
GL_EndList()
return

MsgHandler(wParam, lParam, msg, hwnd)
{
  global
  if ((msg>=0x0200) && (msg<=0x0209))
  {
    cursorX := lParam & 0xFFFF
    cursorY := lParam >> 16
  }
  if (msg=0x0201)
    lbutton := 1
  else if (msg=0x202)
    lbutton := 0
}

MCI_Init()
{
  return DllCall("LoadLibrary", "str", "winmm", (A_PtrSize) ? "ptr" : "uint")
}

MCI_Cleanup()
{
  ptr := (A_PtrSize) ? "ptr" : "uint"
  return DllCall("FreeLibrary", ptr, DllCall("GetModuleHandle", "str", "winmm", ptr))
}

MCI_Execute(command)
{
  astr := (A_IsUnicode) ? "astr" : "str"
  return DllCall("winmm\mciExecute", astr, command)
}

MCI_SendString(command, return="DEFAULT", callback="")
{
  ptr := (A_PtrSize) ? "ptr" : "uint"
  aw := (A_IsUnicode) ? "W" : "A"
  if (return="STRING")
  {
    VarSetCapacity(returnstring, size := (1024 * ((A_IsUnicode) ? 2 : 1)), 0)
    preturnstring := &returnstring
  }
  else
    size := preturnstring := 0
  if (callback!="")
    hcallback := RegisterCallback(callback)
  result := DllCall("winmm\mciSendString" aw, "str", command, ptr, preturnstring, "uint", size, ptr, hcallback)
  if (return="STRING")
  {
    retstr := ""
    Loop, 1024
    {
      if (a := NumGet(returnstring, (A_Index-1) * ((A_IsUnicode) ? 2 : 1), (A_IsUnicode) ? "ushort" : "uchar")=0)
        return retstr
      retstr .= chr(a)
    }
    return retstr
  }
  return result
}

GuiClose:
ExitSub:
GL_DeleteContext(hRC)
GL_Cleanup()
MCI_Cleanup()
ExitApp