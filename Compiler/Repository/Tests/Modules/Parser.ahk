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

class Category_Parser
{
    
}

ParserTest(Parser,Result,Value,Position)
{
    If !Equal(Result,Value)
        throw "Invalid output."
    If Parser.Lexer.Position != Position
        throw "Invalid position."
}

ParserTestException(Result,Message,Location,Position)
{
    If Result.Message != Message
        throw "Invalid error message."
    If Result.What != Location
        throw "Invalid error location."
    If Result.Extra != Position
        throw "Invalid error position."
}