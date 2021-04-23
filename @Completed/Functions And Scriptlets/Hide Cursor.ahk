;AHK v1
#NoEnv

/*
HideCursor()
Sleep, 3000
ShowCursor()
*/

HideCursor()
{
 UPtr := A_PtrSize ? "UPtr" : "UInt", VarSetCapacity(ANDMask,128,0xFF), VarSetCapacity(XORMask,128,0x00), SystemCursors := "32512,32513,32514,32515,32516,32640,32641,32642,32643,32644,32645,32646,32648,32649,32650,32651" ;IDC_ARROW,IDC_IBEAM,IDC_WAIT,IDC_CROSS,IDC_UPARROW,IDC_SIZE,IDC_ICON,IDC_SIZENWSE,IDC_SIZENESW,IDC_SIZEWE,IDC_SIZENS,IDC_SIZEALL,IDC_NO,IDC_HAND,IDC_APPSTARTING,IDC_HELP
 Loop, Parse, SystemCursors, `,
 {
  hBlankCursor := DllCall("CreateCursor","UInt",0,"Int",0,"Int",0,"Int",32,"Int",32,UPtr,&ANDMask,UPtr,&XORMask)
  hCursor := DllCall("CopyImage",UPtr,hBlankCursor,"UInt",2,"Int",0,"Int",0,"Int",0)
  DllCall("SetSystemCursor",UPtr,hCursor,"Int",A_LoopField)
 }
}

ShowCursor()
{
 DllCall("SystemParametersInfo","UInt",0x57,"UInt",0,A_PtrSize ? "UPtr" : "UInt",0,"UInt",0) ;SPI_SETCURSORS
}