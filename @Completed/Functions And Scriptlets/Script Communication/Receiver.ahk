#NoEnv

OnMessage(0x4A,"Receive")
Return

Receive(wParam,lParam)
{
 Temp1 := NumGet(lParam + 4), Temp2 := NumGet(lParam + 8)
 VarSetCapacity(Buffer,Temp1,10), DllCall("RtlMoveMemory","UInt",&Buffer,"UInt",Temp2,"UInt",Temp1)
 ToolTip % Buffer
}