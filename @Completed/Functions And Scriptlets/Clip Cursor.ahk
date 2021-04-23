;AHK v1
#NoEnv

/*
ClipCursor()
Sleep, 5000
FreeCursor()
Sleep, 5000
*/

ClipCursor(ClipPositionX = 100,ClipPositionY = 100, ClipWidth = 200,ClipHeight = 200)
{
 VarSetCapacity(Rect,16,0), NumPut(ClipPositionX,Rect), NumPut(ClipPositionY,Rect,4), NumPut(ClipPositionX + ClipWidth,Rect,8), NumPut(ClipPositionY + ClipHeight,Rect,12)
 Return, DllCall("ClipCursor",A_PtrSize ? "UPtr" : "UInt",&Rect)
}

FreeCursor()
{
 Return, DllCall("ClipCursor",A_PtrSize ? "UPtr" : "UInt",0)
}