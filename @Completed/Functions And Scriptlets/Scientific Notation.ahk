#NoEnv

/*
MsgBox % ScientificNotation(99)
    . "`n" . ScientificNotation(100)
    . "`n" . ScientificNotation(0.00001234)
*/

ScientificNotation(Value)
{
    Places := Floor(Log(Value))
    Return, Value / (10 ** Places) . "e" . Places
}