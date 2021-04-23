#NoEnv

/*
p := new IOPort(0x378)

p.Write(255)
ToolTip, % p.Read()

Sleep, 1000

p.Write(0)
ToolTip, % p.Read()

Sleep, 1000
ExitApp

Esc::ExitApp
*/

class IOPort
{
    __New(Port,DLLPath = "")
    {
        this.Port := Port

        If (DLLPath = "")
            DLLPath := A_ScriptDir . "\inpout32.dll"

        this.hModule := DllCall("LoadLibrary","Str",DLLPath,"UPtr")
        If !this.hModule
            throw Exception("Could not load DLL from path """ . DLLPath . """.")
        this.pInput := DllCall("GetProcAddress","UPtr",this.hModule,"AStr","Inp32","UPtr")
        If !this.pInput
            throw Exception("Could not retrieve input function pointer.")
        this.pOutput := DllCall("GetProcAddress","UPtr",this.hModule,"AStr","Out32","UPtr")
        If !this.pOutput
            throw Exception("Could not retrieve output function pointer.")
    }

    Read()
    {
        Return, DllCall(this.pOutput,"Short",this.Port,"Short")
    }

    Write(Value)
    {
        DllCall(this.pOutput,"Short",this.Port,"Short",Value)
    }
}