#NoEnv

/*
Push(DataList,"abc")
Push(DataList,"def")
Push(DataList,"ghi")
Push(DataList,"jkl")
MsgBox % """" . Peek(DataList) . """`n""" . DataList . """"
MsgBox % """" . Pop(DataList) . """`n""" . DataList . """"
MsgBox % """" . Look(DataList) . """`n""" . DataList . """"
MsgBox % """" . Pull(DataList) . """`n""" . DataList . """"
MsgBox % """" . Pop(DataList) . """`n""" . DataList . """"
MsgBox % """" . Pull(DataList) . """`n""" . DataList . """"
*/

Push(ByRef DataList,Data)
{
 DataList .= ((DataList = "") ? "" : Chr(1)) . Data
}

Pop(ByRef DataList)
{
 Temp1 := InStr(DataList,Chr(1),False,0), Temp1 ? (Temp2 := SubStr(DataList,Temp1 + 1), DataList := SubStr(DataList,1,Temp1 - 1)) : (Temp2 := DataList, DataList := "")
 Return, Temp2
}

Peek(ByRef DataList)
{
 Return, SubStr(DataList,InStr(DataList,Chr(1),False,0) + 1)
}

Pull(ByRef DataList)
{
 Temp1 := InStr(DataList,Chr(1),False,2), Temp1 ? (Temp2 := SubStr(DataList,1,Temp1 - 1), DataList := SubStr(DataList,Temp1 + 1)) : (Temp2 := DataList, DataList := "")
 Return, Temp2
}

Look(ByRef DataList)
{
 Temp1 := InStr(DataList,Chr(1),False,2)
 Return, Temp1 ? SubStr(DataList,1,Temp1 - 1) : ""
}

Size(ByRef DataList)
{
 Chr1 := Chr(1)
 StringReplace, DataList, DataList, %Chr1%, %Chr1%, UseErrorLevel
 Return, ErrorLevel + 1
}