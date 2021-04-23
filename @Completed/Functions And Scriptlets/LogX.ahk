;AHK v1
#NoEnv

;MsgBox % LogX(6,7776) ;6 ** X = 76, X = 5

;calculate the logarithm of a number in an arbitrary base
LogX(NumberBase,Value)
{
 Return, Log(Value) / Log(NumberBase)
}