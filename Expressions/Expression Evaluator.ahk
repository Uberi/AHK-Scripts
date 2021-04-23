#NoEnv

;Temp1 = abc123de4f
;Temp2 = 3
;MsgBox % RecursiveParse("(InStr ""abc3de"" (. 3 ""de""))","Apply")
;ExitApp

;Expression = Bla := "Te""st" . "abc" . (5 + TestVar) . """" . TestFunc("TestString") . (2 * .4) . 0x4 * 5.873 . "abc" . Temp1 . "123" . """" . 34
ExitApp

Expression := RegExReplace(Expression,"S)([\)\w#@\$])(['\(])","$1.$2") ;implicit concatenation to explicit