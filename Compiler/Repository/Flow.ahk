#NoEnv

;#Include Code.ahk

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

;/*
#Include Resources\Reconstruct.ahk
#Include Lexer.ahk
#Include Parser.ahk
#Include Bytecode.ahk

SetBatchLines, -1

Code := "while test,{ test := 0 }"
Code := "a ? b : c"

If CodeInit()
{
    MsgBox Error initializing code tools.
    ExitApp ;fatal error
}

FileName := A_ScriptFullPath
CodeSetScript(FileName,Errors,Files) ;set the current script file

CodeTreeInit()

CodeLexInit()
Tokens := CodeLex(Code,Errors)

SyntaxTree := CodeParse(Tokens,Errors)

CodeBytecodeInit()
Bytecode := CodeBytecode(SyntaxTree)

FlowGraph := CodeFlow(Bytecode,Errors)
MsgBox % Bytecode . "`n" . Show(FlowGraph)
ExitApp
*/

CodeFlow(ByRef Bytecode,ByRef Errors) ;wip: return annotated AST
{
    SymbolTable := Object("main",1), CurrentLabel := "main"
    FlowGraph := [], Index := 0, CurrentBlock := ""
    Loop, Parse, Bytecode, `n, %A_Space%%A_Tab%
    {
        ;parse bytecode line
        If SubStr(A_LoopField,1,1) = "`;" ;line is a comment
            CurrentBlock .= A_LoopField . "`n" ;add to output
        Else If SubStr(A_LoopField,1,1) = ":" ;line is a label definition
        {
            Index ++, FlowGraph[Index] := CurrentBlock ;insert the new block into the symbol table
            CurrentBlock := "" ;reset the current block to blank

            SymbolTable[CurrentLabel] := Index ;add an entry to the symbol table
            CurrentLabel := SubStr(A_LoopField,2)
        }
        Else ;line is an instruction
        {
            Temp1 := InStr(A_LoopField," ")
            If Temp1
                Instruction := SubStr(A_LoopField,1,Temp1 - 1), Parameter := SubStr(A_LoopField,Temp1 + 1)
            Else
                Instruction := A_LoopField, Parameter := ""
            CurrentBlock .= A_LoopField . "`n"
        }
    }

    Index ++, FlowGraph[Index] := CurrentBlock ;insert the new block into the symbol table
    SymbolTable[CurrentLabel] := Index ;add an entry to the symbol table

    ;wip
    For Index, Block In FlowGraph
    {
        FoundPos := 1, FoundPos1 := 1, Block1 := ""
        While, FoundPos := RegExMatch(Block,"S):(\w+)",Match,FoundPos)
        {
            Block1 .= SubStr(Block,FoundPos1,FoundPos - FoundPos1) . ":" . (SymbolTable.HasKey(Match1) ? SymbolTable[Match1] : Match1)
            FoundPos += StrLen(Match), FoundPos1 := FoundPos
        }
        Block1 .= SubStr(Block,FoundPos1)
        FlowGraph[Index] := Block1
    }

    Return, FlowGraph
}