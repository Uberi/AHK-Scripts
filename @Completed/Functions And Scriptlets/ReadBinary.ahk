#NoEnv

/*
f := FileOpen(A_Temp . "\Test.bin","rw")
f.WriteUChar(1)
f.WriteUChar(2)
f.WriteUChar(3)
f.WriteUChar(4)
MsgBox % ReadBits(f,20,12)
*/

ReadBits(File,Offset,Count) ;file is file object, offset is in bits, count is in bits
{
    File.Seek(Offset >> 3)
    Result := ""
    Loop, % (Offset & 7 != 0) + Ceil(Count / 8)
    {
        Number := File.ReadUChar()
        If (Number = "")
            Return, ""
        Value := ""
        Loop, 8
        {
            Value := (Number & 1) . Value
            Number >>= 1
        }
        Result .= Value
    }
    Return, SubStr(Result,(Offset & 7) + 1,Count)
}