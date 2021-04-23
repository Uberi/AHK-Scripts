#NoEnv

ExampleIndex := 8
Gosub, Example%ExampleIndex%
ExitApp

Example1:
;Example 1: Object methods
TestObject := Object("One","The value of this property is one.","TestMethod",Func("TestMethodSingleParam"))
MsgBox % TestObject.TestMethod("Hello","World")
Return

TestMethodSingleParam(this,Param1,Param2)
{
    Return, "this.One: " . this.One . "`nParam1: " . Param1 . "`nParam2: " . Param2
}

Example2:
;Example 2: A shallow object copy (copying the object reference, not the object data)
Object1 := Object()
Object2 := Object1 ;now Object2 refers to the same object as Object1
Return

Example3:
;Example 3: A deep object copy, including the object's bases (similar to SomeObject.Clone(), but nested objects are copied too)
Object1 := Object("Key","Value")
Object2 := ObjectDuplicate(Object1) ;now Object2 does not refer to the same object as Object1, but contains the same data. Object1.base has also been duplicated.
Return

ObjectDuplicate(DuplicateObject,ReservedList = 0)
{
    If !ReservedList
        ReservedList := Object(&DuplicateObject,"") ;keep track of unique objects within root object
    If !IsObject(DuplicateObject)
        Return, DuplicateObject
    ObjectCopy := Object("base",ObjectDuplicate(DuplicateObject.base))
    For Key, Value In DuplicateObject
    {
        If ReservedList[&Value]
            Continue ;skip circular references
        ObjInsert(ObjectCopy,Key,ObjectDuplicate(Value,ReservedList))
    }
    Return, ObjectCopy
}

Example4:
;Example 4: Show the contents of an object, along with any nested objects
TestObject := Object(1,"One",2,Object("Number","Two","2nd","Second"),3,"Three")
MsgBox % ShowObject(TestObject)
Return

ShowObject(ShowObject,Padding = "")
{
    ListLines, Off
    If !IsObject(ShowObject)
    {
        ListLines, On
        Return, ShowObject
    }
    ObjectContents := ""
    For Key, Value In ShowObject
    {
        If IsObject(Value)
            Value := "`n" . ShowObject(Value,Padding . A_Tab)
        ObjectContents .= Padding . Key . ": " . Value . "`n"
    }
    ObjectContents := SubStr(ObjectContents,1,-1)
    If (Padding = "")
        ListLines, On
    Return, ObjectContents
}

Example5:
;Example 5: Parse an object description (in the format defined by ShowObject()) into an object
ObjectDescription = 
( RTrim0
ABC: 
	A: 
		File: Test
		Position: 20
		Type: SYNTAX_ELEMENT
		Value: 
Something
B: 
	File: Test
	Position: 21
	Type: IDENTIFIER
	Value: FunctionCall
C: Some Text
)
MsgBox % ShowObject(ParseObject(ObjectDescription))
Return

ParseObject(ObjectDescription)
{
    ListLines, Off
    PreviousIndentLevel := 1, PreviousKey := "", Result := Object(), ObjectPath := [], PathIndex := 0, TempObject := Result ;initialize values
    Loop, Parse, ObjectDescription, `n, `r ;loop over each line of the object description
    {
        IndentLevel := 1
        While, (SubStr(A_LoopField,A_Index,1) = "`t") ;retrieve the indentation level
            IndentLevel ++
        Temp1 := InStr(A_LoopField,":",0,IndentLevel)
        If !Temp1 ;not a key-value pair, treat as a continuation of the value of the previous pair
        {
            TempObject[PreviousKey] .= "`n" . A_LoopField
            Continue
        }
        Key := SubStr(A_LoopField,IndentLevel,Temp1 - IndentLevel), Value := SubStr(A_LoopField,Temp1 + 2)
        If (IndentLevel = PreviousIndentLevel) ;sibling object
            TempObject[Key] := Value
        Else If (IndentLevel > PreviousIndentLevel) ;nested object
            TempObject[PreviousKey] := Object(Key,Value), TempObject := TempObject[PreviousKey], ObjInsert(ObjectPath,PreviousKey), PathIndex ++
        Else ;(IndentLevel < PreviousIndentLevel) ;parent object
        {
            Temp1 := PreviousIndentLevel - IndentLevel, ObjRemove(ObjectPath,PathIndex - Temp1,PathIndex), PathIndex -= Temp1 ;update object path

            ;get parent object
            TempObject := Result
            Loop, %PathIndex%
                TempObject := TempObject[ObjectPath[A_Index]]
            TempObject[Key] := Value
        }
        PreviousIndentLevel := IndentLevel, PreviousKey := Key
    }
    ListLines, On
    Return, Result
}

Example6:
;Example 6: Get and set values from nested objects
TestObject := Object(1,"One",2,Object("Number","Two","2nd","Second"),3,"Three")
ObjectSetDeep(TestObject,[2,"Number"],"Something")
MsgBox % ObjectGetDeep(TestObject,[2,"Number"])
Return

ObjectSetDeep(ByRef InputObject,ObjectPath,ByRef Value)
{
    Temp1 := InputObject, MaxIndex := ObjMaxIndex(ObjectPath)
    Loop, % MaxIndex - 1
        Temp1 := Temp1[ObjectPath[A_Index]]
    Temp1[ObjectPath[MaxIndex]] := Value
}

ObjectGetDeep(ByRef InputObject,ObjectPath)
{
    Temp1 := InputObject
    Loop, % ObjMaxIndex(ObjectPath)
        Temp1 := Temp1[ObjectPath[A_Index]]
    Return, Temp1
}

Example7:
;Example 7: Display an object in a TreeView
TestObject := Object(1,"One",2,Object("Number","Two","2nd","Second"),3,"Three")
DisplayObject(TestObject)
Return

DisplayObject(DisplayObject,ParentID = 0)
{
    ListLines, Off
    If (ParentID = 0)
    {
        Gui, Add, Text, x10 y0 w300 h30 Center, Object Contents
        Gui, Add, TreeView, x10 y30 w300 h230
    }
    For Key, Value In DisplayObject
        IsObject(Value) ? DisplayObject(Value,TV_Add(Key,ParentID,"Bold Expand")) : TV_Add(Key . ": " . Value,ParentID)
    If (ParentID = 0)
    {
        Gui, +ToolWindow +AlwaysOnTop +LastFound
        WindowID := WinExist()
        Gui, Show, w320 h270
        While, WinExist("ahk_id " . WindowID)
            Sleep, 100
        Gui, Destroy
        ListLines, On
        Return
    }
}

Example8:
;Example 9: Object with custom iterator.
i := new Iterator
For Key, Value In i
    MsgBox "%Key%"="%Value%"

class Iterator
{
    _NewEnum()
    {
        Return, new this.Enumerator
    }

    class Enumerator
    {
        __New()
        {
            this.Index := 1
        }

        Next(ByRef Output1,ByRef Output2)
        {
            If this.Index <= 5
            {
                Output1 := this.Index
                Output2 := "Test " . this.Index
                this.Index ++
                Return, 1
            }
            Return, 0
        }
    }
}