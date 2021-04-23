Show(ShowObject,Padding = "")
{
    If (Padding = "")
        ListLines, Off
    If IsFunc(ShowObject)
    {
        If (Padding = "")
            ListLines, On
        Return, "function(" . ShowObject.Name . ")"
    }
    If !IsObject(ShowObject)
    {
        If (Padding = "")
            ListLines, On
        If ShowObject Is Number
            Return, ShowObject
        Return, """" . ShowObject . """"
    }
    ObjectContents := "{`n"
    For Key, Value In ShowObject
        ObjectContents .= Padding . "`t" . Show(Key,Padding . "`t") . ": " . Show(Value,Padding . "`t") . ",`n"
    ObjectContents .= Padding . "}"
    If (Padding = "")
        ListLines, On
    Return, ObjectContents
}