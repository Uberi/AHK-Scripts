; testing.ahk_l
#Include LSON.ahk
#SingleInstance, force

test1 = [1,2,3,"\"abc",5]
result1 = [1, 2, 3, "\"abc", 5]

test2 = [1,  2  ,3  ]
result2 = [1, 2, 3]

test3 = `   [  1,2  ]  `
result3 = [1, 2]

test4 = { abc:"def"}
result4 = {"abc": "def"}

test5 = [1,2,["a","b"],3]
result5 = [1, 2, ["a", "b"], 3]

test6 = ["abc\"",[1,"de"],{ ky: 123}]
result6 = ["abc\"", [1, "de"], {"ky": 123}]

test7 = [123,456,1.0e8]
result7 = [123, 456, 100000000.000000]

test8 = {[1,2,3]: "abc"}
result8 = {[1, 2, 3]: "abc"}

test9 = {[1,2,3]: "abc", { 1:"a",5:"b","123.x":"d" }: [1,2,3] }
result9 = {[1, 2, 3]: "abc", {"1": "a", "5": "b", "123.x": "d"}: [1, 2, 3]}

test10 = { { a:"a",{ 123:"cde"}:"test"}: ["a","b",{["x"]:"y"}], "x": [{ 3:"three","IV":{ 4:"four"} }]} ;
result10 = {{{"123": "cde"}: "test", "a": "a"}: ["a", "b", {["x"]: "y"}], "x": [{"3": "three", "IV": {"4": "four"}}]}

test11 = { { { Key: "Value"}: "Value1"}: "Value2"}
result11 = {{{"Key": "Value"}: "Value1"}: "Value2"}

test12 = [1,2,/]
result12 = [1, 2, /]

test13 = ["a",2,"III",{ /: "test" }, { repeat: /4 }, { ["obj"]: "test" }, /6/1k]
result13 = ["a", 2, "III", {/: "test"}, {"repeat": /4}, {["obj"]: "test"}, /6/1k]

test14 = ["a","b",[1,2] ;error: Unexpected end of string
result14 = Unexpected end of string

test15 = [/2,"abc",123] ;error: Self-reference not found: /2 at position 2
result15 = Self-reference not found: /2 at position 2

test16 = x ;error: object not recognized
result16 = object not recognized

test17 = []
result17 = []

test18 = {}
result18 = []

test19 = [1337, 0x1337]
result19 = [1337, 4919]

test20 = [-1]
result20 = [-1]

test21 = [ -1]
result21 = [-1]

test22 = [- 1]
result22 = [-1]

test23 = [5,4,3,2,1,0,-1, -    2, - 3]
result23 = [5, 4, 3, 2, 1, 0, -1, -2, -3]

test24 = { "\t foo": "\\t" }
result24 = {"\t foo": "\\t"}

test25 = ["tab \t","no tab \\t","tab \\\t","no tab \\\\t","tab \\\\\t","no tab \\\\\\t"]
result25 = ["tab \t", "no tab \\t", "tab \\\t", "no tab \\\\t", "tab \\\\\t", "no tab \\\\\\t"]

tests = 1-23 ; which ones to test?
list := expand(tests)
showSuccess := true

loop, parse, list, `,, %A_Space%%A_Tab%
{
    try
        y := LSON(LSON(test%A_LoopField%), true)
    catch e
        y := e
    error := !(y == result%A_LoopField%)
    if (showSuccess || error)
        msgbox, , % "Parsing #" A_LoopField ": " (error ? "Error" : "Success"), %y%
}

msgbox, , LSON Parse Testing, Parsing tests %tests% completed!

; msgbox % text "`n`ntoken: " token "`ntype: " tokentype "`nchar after token: " c " at " pos "`nchar before token: " cb "`nobj: " lson(ret) "`nmode: " mode

expand( range ) {
    p := 0
    while p := RegExMatch(range, "\s*(-?\d++)(?:\s*-\s*(-?\d++))?", f, p+1+StrLen(f))
        loop % (f2 ? f2-f1 : 0) + 1
            ret .= "," (A_Index-1) + f1
    return SubStr(ret, 2)
}
