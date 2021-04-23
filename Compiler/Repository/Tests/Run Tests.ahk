#NoEnv

/*
Copyright 2011-2013 Anthony Zhang <azhang9@gmail.com>

This file is part of Autonomy. Source code is available at <https://github.com/Uberi/Autonomy>.

Autonomy is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#Include Unit Test.ahk

#Warn All
#Warn LocalSameAsGlobal, Off

UnitTest.Initialize()
UnitTest.Test(Tests)
Return

class Tests
{
    #Include Modules/Lexer.ahk
    #Include Modules/Parser.ahk
}

Equal(Value1,Value2,CaseSensitive = 1)
{
    If !IsObject(Value1)
    {
        If IsObject(Value2)
            Return, False
        If CaseSensitive
            Return, Value1 == Value2
        Else
            Return, Value1 = Value2
    }
    If !IsObject(Value2)
        Return, False

    For Key, Value In Value1
    {
        If !ObjHasKey(Value2,Key)
            Return, False
        If !Equal(Value,Value2[Key],CaseSensitive)
            Return, False
    }

    For Key, Value In Value2
    {
        If !ObjHasKey(Value1,Key)
            Return, False
        If !Equal(Value,Value1[Key],CaseSensitive)
            Return, False
    }

    Return, True
}

#Include ../
#Include Code.ahk