#NoEnv

ExpressionEscape(String)
{
 StringReplace, String, String, \, \e, All ;escape character
 StringReplace, String, String, % Chr(1), \d, All ;delimiter character
 Return, String
}

ExpressionUnescape(String)
{
 StringReplace, String, String, \d, % Chr(1), All ;delimiter character
 StringReplace, String, String, \e, \, All ;escape character
 Return, String
}