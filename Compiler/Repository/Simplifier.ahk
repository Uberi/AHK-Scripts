#NoEnv

#Include Code.ahk

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

/*
Possible Simplifications
------------------------

Resources:

* http://en.wikipedia.org/wiki/Category:Compiler_optimizations
* http://en.wikipedia.org/wiki/Compiler_optimization
* http://en.wikipedia.org/wiki/Constant_folding

Simplifications:

* common subexpression elimination:                  http://en.wikipedia.org/wiki/Common_subexpression_elimination
* integer bit shift right equivalance:               Integer1 // [Power of 2: Integer2] -> Integer1 >> [Log2(Integer2)]
* floor divide:                                      Floor(Number1 / Number2) -> Number1 // Number2
* divide by one:                                     Integer / [Evaluates to 1] -> Integer
* bitwise modulo:                                    Mod(Integer1,[Power of 2: Integer2]) -> Integer1 & [Integer2 - 1]
* x*0 = 0, x**0 = 1, x & 0 = 0, x ^ x = 0, (x<<2)<<1 = x<<3, (x>>2)<<1 = x>>1
* logical transforms:                                (!Something && !SomethingElse) -> !(Something || SomethingElse) ;many other different types of logical transforms too
* type specialization:                               If [Something that evaluates to a boolean: Expression] -> If Expression = True ;avoids needing to check both boolean truthiness and for string truthiness
* case sensitivity:                                  If [String: String1] = [String without alphabetic characters: String2] -> If String [Case sensitive compare] ;avoid case insensitivity routines that may be more complex or slow
* static single assignment                           http://en.wikipedia.org/wiki/Static_single_assignment_form
* strength reduction:                                http://en.wikipedia.org/wiki/Strength_reduction
* partial redundancy elimination:                    http://en.wikipedia.org/wiki/Partial_redundancy_elimination
* scalar replacement:                                http://kitty.2y.cc/doc/intel_cc_80/doc/c_ug/lin1074.htm
*/

/*

#Include Resources\Reconstruct.ahk
#Include Lexer.ahk
#Include Parser.ahk

SetBatchLines, -1

Code = 
(
1+2*(a//2)
)

If CodeInit()
{
    Display("Error initializing code tools.`n") ;display error at standard output
    ExitApp ;fatal error
}

FileName := A_ScriptFullPath
CodeSetScript(FileName,Errors,Files) ;set the current script file

CodeTreeInit()

CodeLexInit()
Tokens := CodeLex(Code,Tokens,Errors)

SyntaxTree := CodeParse(Tokens,Errors)

MsgBox % Clipboard := CodeReconstructShowSyntaxTree(CodeSimplify(SyntaxTree))
ExitApp
*/

class Simplifier
{
    static Operations := Object("_if",              Func("CodeSimplifyTernaryIf")
                               ,"_concatenate",     Func("CodeSimplifyConcatenate")
                               ,"_bit_and",         Func("CodeSimplifyBitwiseAnd")
                               ,"_bit_xor",         Func("CodeSimplifyBitwiseExclusiveOr")
                               ,"_bit_or",          Func("CodeSimplifyBitwiseOr")
                               ,"_bit_shift_left",  Func("CodeSimplifyBitwiseShiftLeft")
                               ,"_bit_shift_right", Func("CodeSimplifyBitwiseShiftRight")
                               ,"_add",             Func("CodeSimplifyAdd")
                               ,"_subtract",        Func("CodeSimplifySubtract")
                               ,"_multiply",        Func("CodeSimplifyMultiply")
                               ,"_divide",          Func("CodeSimplifyDivide")
                               ,"_divide_floor",    Func("CodeSimplifyDivideFloor")
                               ,"_not",             Func("CodeSimplifyLogicalNot")
                               ,"_invert",          Func("CodeSimplifyInvert")
                               ,"_bit_not",         Func("CodeSimplifyBitwiseNot")
                               ,"_exponentiate",    Func("CodeSimplifyExponentiate")
                               ,"_evaluate",        Func("CodeSimplifyEvaluate"))
}

;simplifies a syntax tree given as input
CodeSimplify(SyntaxTree)
{
    global CodeTreeTypes
    static SimplifyOperations := 

    If (SyntaxTree[1] = CodeTreeTypes.OPERATION) ;node is an operation
    {
        Operation := CodeSimplify(SyntaxTree[2])
        Result := [CodeTreeTypes.OPERATION,Operation]

        Index := 3
        Loop, % SyntaxTree.MaxIndex() - 2
            Result.Insert(CodeSimplify(SyntaxTree[Index])), Index ++

        If SimplifyOperations.HasKey(Operation[2])
            Return, SimplifyOperations[Operation[2]](Result)
        Return, Result
    }
    Else If (SyntaxTree[1] = CodeTreeTypes.BLOCK ;node is a block
            && SyntaxTree.MaxIndex() = 2 ;node contains only one subnode
            && SyntaxTree[2][1] = CodeTreeTypes.BLOCK) ;subnode is a block
        Return, CodeSimplify(SyntaxTree[2]) ;directly return the inner block

    Return, SyntaxTree
}

CodeSimplifyTernary(This,Node)
{
    global CodeTreeTypes
    Operand1 := Node[3], Operand2 := Node[4], Operand3 := Node[5]
    If (Operand1[1] = CodeTreeTypes.NUMBER) ;first operand is a number
        Return, (Operand1[2] = 0) ? Operand3 : Operand2
    If (Operand1[1] = CodeTreeTypes.STRING) ;first operand is a string
        Return, (Operand1[2] = "") ? Operand3 : Operand2
    Return, Node
}

CodeSimplifyConcatenate(This,Node)
{
    global CodeTreeTypes
    Operand1 := Node[3], Operand2 := Node[4]
    If ((Operand1[1] = CodeTreeTypes.NUMBER || Operand1[1] = CodeTreeTypes.STRING) ;first operand is a number or string
       && (Operand2[1] = CodeTreeTypes.NUMBER || Operand2[1] = CodeTreeTypes.STRING)) ;second operand is a number or string
        Return, CodeTreeString(Operand1[2] . Operand2[2])
    Return, Node
}

CodeSimplifyBitwiseAnd(This,Node)
{
    global CodeTreeTypes
    Operand1 := Node[3], Operand2 := Node[4]
    If (Operand1[1] = CodeTreeTypes.NUMBER && Operand2[1] = CodeTreeTypes.NUMBER) ;both operands are numbers
        Return, [CodeTreeTypes.NUMBER,Operand1[2] & Operand2[2],0,0]
    Return, Node
}

CodeSimplifyBitwiseExclusiveOr(This,Node)
{
    global CodeTreeTypes
    Operand1 := Node[3], Operand2 := Node[4]
    If (Operand1[1] = CodeTreeTypes.NUMBER) ;first operand is a number
    {
        If (Operand1[2] = 0) ;value of the first operand is the number 0
            Return, Operand2
        If (Operand2[1] = CodeTreeTypes.NUMBER) ;both operands are numbers
            Return, [CodeTreeTypes.NUMBER,Operand1[2] ^ Operand2[2],0,0]
    }
    If (Operand2[1] = CodeTreeTypes.NUMBER && Operand2[2] = 0) ;value of the second operand is the number 0
        Return, Operand1
    Return, Node
}

CodeSimplifyBitwiseOr(This,Node)
{
    global CodeTreeTypes
    Operand1 := Node[3], Operand2 := Node[4]
    If (Operand1[1] = CodeTreeTypes.NUMBER) ;first operand is a number
    {
        If (Operand1[2] = 0) ;value of the first operand is the number 0
            Return, Operand2
        If (Operand2[1] = CodeTreeTypes.NUMBER) ;both operands are numbers
            Return, [CodeTreeTypes.NUMBER,Operand1[2] | Operand2[2],0,0]
    }
    If (Operand2[1] = CodeTreeTypes.NUMBER && Operand2[2] = 0) ;value of the second operand is the number 0
        Return, Operand1
    Return, Node
}

CodeSimplifyBitwiseShiftLeft(This,Node)
{
    global CodeTreeTypes
    Operand1 := Node[3], Operand2 := Node[4]
    If (Operand1[1] = CodeTreeTypes.NUMBER) ;first operand is a number
    {
        If (Operand1[2] = 0) ;value of the first operand is the number 0
            Return, Operand2
        If (Operand2[1] = CodeTreeTypes.NUMBER) ;both operands are numbers
            Return, [CodeTreeTypes.NUMBER,Operand1[2] << Operand2[2],0,0]
    }
    If (Operand2[1] = CodeTreeTypes.NUMBER && Operand2[2] = 0) ;value of the second operand is the number 0
        Return, Operand1
    Return, Node
}

CodeSimplifyBitwiseShiftRight(This,Node)
{
    global CodeTreeTypes
    Operand1 := Node[3], Operand2 := Node[4]
    If (Operand1[1] = CodeTreeTypes.NUMBER) ;first operand is a number
    {
        If (Operand1[2] = 0) ;value of the first operand is the number 0
            Return, Operand2
        If (Operand2[1] = CodeTreeTypes.NUMBER) ;both operands are numbers
            Return, [CodeTreeTypes.NUMBER,Operand1[2] >> Operand2[2],0,0]
    }
    If (Operand2[1] = CodeTreeTypes.NUMBER && Operand2[2] = 0) ;value of the second operand is the number 0
        Return, Operand1
    Return, Node
}

CodeSimplifyAdd(This,Node)
{
    global CodeTreeTypes
    Operand1 := Node[3], Operand2 := Node[4]
    If (Operand1[1] = CodeTreeTypes.NUMBER) ;first operand is a number
    {
        If (Operand1[2] = 0) ;value of the first operand is the number 0
            Return, Operand2
        If (Operand2[1] = CodeTreeTypes.NUMBER) ;both operands are numbers
        Return, [CodeTreeTypes.NUMBER,Operand1[2] + Operand2[2],0,0]
    }
    If (Operand2[1] = CodeTreeTypes.NUMBER && Operand2[2] = 0) ;value of the second operand is the number 0
        Return, Operand1
    Return, Node
}

CodeSimplifySubtract(This,Node)
{
    global CodeTreeTypes
    Operand1 := Node[3], Operand2 := Node[4]
    If (Operand1[1] = CodeTreeTypes.NUMBER) ;first operand is a number
    {
        If (Operand1[2] = 0) ;value of the first operand is the number 0
            Return, Operand2
        If (Operand2[1] = CodeTreeTypes.NUMBER) ;both operands are numbers
            Return, [CodeTreeTypes.NUMBER,Operand1[2] - Operand2[2],0,0]
    }
    If (Operand2[1] = CodeTreeTypes.NUMBER && Operand2[2] = 0) ;value of the second operand is the number 0
        Return, Operand1
    Return, Node
}

CodeSimplifyMultiply(This,Node)
{
    global CodeTreeTypes
    Operand1 := Node[3], Operand2 := Node[4]
    If (Operand1[1] = CodeTreeTypes.NUMBER) ;first operand is a number
    {
        If (Operand1[2] = 1) ;value of the first operand is the number 1
            Return, Operand2
        If (Operand2[1] = CodeTreeTypes.NUMBER) ;both operands are numbers
            Return, [CodeTreeTypes.NUMBER,Operand1[2] * Operand2[2],0,0]
        If (Operand1[2] > 0 && (Operand1[2] & (Operand1[2] - 1)) = 0) ;value of the first operand is a number that is greater than than 0 and is a power of two
            Return, [CodeTreeTypes.OPERATION
                    ,[CodeTreeTypes.IDENTIFIER
                    ,"BITWISE_SHIFT_LEFT",0,0]
                    ,Operand2
                    ,[CodeTreeTypes.NUMBER
                        ,Floor(Log(Operand1[2]) / Log(2)),0,0]]
    }
    If (Operand2[1] = CodeTreeTypes.NUMBER) ;second operand is a number
    {
        If (Operand2[2] = 1) ;value of the second operand is the number 1
            Return, Operand1
        If (Operand2[2] > 0 && (Operand2[2] & (Operand2[2] - 1)) = 0) ;value of the second operand is a number that is greater than 0 and is a power of two
            Return, [CodeTreeTypes.OPERATION
                    ,[CodeTreeTypes.IDENTIFIER
                    ,"BITWISE_SHIFT_LEFT",0,0]
                    ,Operand1
                    ,[CodeTreeTypes.NUMBER
                        ,Floor(Log(Operand2[2]) / Log(2)),0,0]]
    }
    Return, Node
}

CodeSimplifyDivide(This,Node)
{
    global CodeTreeTypes
    Operand1 := Node[3], Operand2 := Node[4]
    If (Operand2[1] = CodeTreeTypes.NUMBER) ;second operand is a number
    {
        If (Operand2[2] = 1) ;value of the second operand is the number 1
            Return, Operand1
        If (Operand1[1] = CodeTreeTypes.NUMBER) ;both operands are numbers
            Return, [CodeTreeTypes.NUMBER,Operand1[2] / Operand2[2],0,0]
    }
    Return, Node
}

CodeSimplifyDivideFloor(This,Node)
{
    global CodeTreeTypes
    Operand1 := Node[3], Operand2 := Node[4]
    If (Operand2[1] = CodeTreeTypes.NUMBER) ;second operand is a number
    {
        If (Operand2[2] = 1) ;value of the second operand is the number 1
            Return, Operand1
        If (Operand1[1] = CodeTreeTypes.NUMBER) ;both operands are numbers
            Return, [CodeTreeTypes.NUMBER,Operand1[2] // Operand2[2],0,0]
        If (Operand2[2] > 0 && (Operand2[2] & (Operand2[2] - 1)) = 0) ;value of the second operand is a number that is greater than than 0 and is a power of two
            Return, [CodeTreeTypes.OPERATION
                    ,[CodeTreeTypes.IDENTIFIER
                    ,"BITWISE_SHIFT_RIGHT",0,0]
                    ,Operand1
                    ,[CodeTreeTypes.NUMBER
                        ,Floor(Log(Operand2[2]) / Log(2)),0,0]]
    }
    Return, Node
}

CodeSimplifyLogicalNot(This,Node)
{
    global CodeTreeTypes
    Operand := Node[3]
    If (Operand[1] = CodeTreeTypes.NUMBER) ;first operand is a number
        Return, [CodeTreeTypes.NUMBER,!Operand[2],0,0]
    If (Operand[1] = CodeTreeTypes.STRING) ;first operand is a string
        Return, [CodeTreeTypes.NUMBER,!Operand[2],0,0]
    Return, Node
}

CodeSimplifyInvert(This,Node)
{
    global CodeTreeTypes
    Operand := Node[3]
    If (Operand[1] = CodeTreeTypes.NUMBER) ;first operand is a number
        Return, [CodeTreeTypes.NUMBER,-Operand[2],0,0]
    Return, Node
}

CodeSimplifyBitwiseNot(This,Node)
{
    global CodeTreeTypes
    Operand := Node[3]
    If (Operand[1] = CodeTreeTypes.NUMBER) ;first operand is a number
        Return, [CodeTreeTypes.NUMBER,~Operand[2],0,0]
    Return, Node
}

CodeSimplifyExponentiate(This,Node)
{
    global CodeTreeTypes
    Operand1 := Node[3], Operand2 := Node[4]
    If (Operand2[1] = CodeTreeTypes.NUMBER) ;second operand is a number
    {
        If (Operand2[2] = 1) ;value of the second operand is the number 1
            Return, Operand1
        If (Operand1[1] = CodeTreeTypes.NUMBER) ;both operands are numbers
            Return, [CodeTreeTypes.NUMBER,Operand1[2] ** Operand2[2],0,0]
    }
    Return, Node
}

CodeSimplifyEvaluate(This,Node)
{
    If (Node.MaxIndex() = 3) ;evaluate operation has only one subexpression
        Return, Node[3] ;return the subexpression
    Return, Node
}