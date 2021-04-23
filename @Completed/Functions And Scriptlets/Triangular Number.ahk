;AHK v1
#NoEnv

;MsgBox % TriangularNumber(10)

TriangularNumber(Index)
{
 Return, (Index * (Index + 1)) >> 1
}