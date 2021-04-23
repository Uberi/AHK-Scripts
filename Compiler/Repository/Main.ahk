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

#Warn All
#Warn LocalSameAsGlobal, Off

SetBatchLines, -1

/*
TODO
----

Short term tasks:

* add binary ^^ in as logical XOR
* add the unary + back in as the indentity function that does nothing but return its parameter
* remove bitwise ops maybe? use this instead: with bits, { (1 shift_left x) or (1 shift_right x) }
* class([ field: {}, x: y ]) is a function that takes a standard object def and binds the instance to each method's "this" param and gives some helpers for instantiation
* parse a(b,c) with parameters having Number nodes as keys, so we can correctly do $a(1: b, 2: c)$
* make unit tests for the new lexer escape behavior
* consider $ representing the current context, so $.args has the arguments and $ has contexts
* consider using , to denote an array and [] to denote an object: x := 1, 2, 3
    * still need a good way to represent empty or single element arrays
    * could make arrays transparent like in MATLAB: everything is transparently in an array
    * make blocks accept a single array parameter in this case, also allows multiple return values to work
* Unit tests for error handler
* Error tolerance for parser by ignoring an operation like want.to.autocomplete.%INVALID% by simply returning the valid operands in the operator parser (want.to.autocomplete).

Long term tasks:

* meta-algorithms like something.sort(stable: false, parallelizable: true) and meta data structures like x := collection(retrieval: 1, insertion: 5, removal: 0) where the numbers are how important each property is and the function chooses the best algorithm automatically
* backend with Parrot VM: https://en.wikipedia.org/wiki/Parrot_virtual_machine
* symbols are just normal objects that implement hashing with their contents rather than their memory address
* finish the flow analysis module as per: http://matt.might.net/articles/intro-static-analysis/
* implement all control flow and exceptions using continuations, continuation passing style is the norm with implicit continuations parameter, sort of like the "this" param in other languages
    * have "self" and $ available at all times, which represent the object instance and the passed continuations object/scope object
    * return(x), continue(), base.break()
    * http://matt.might.net/articles/by-example-continuation-passing-style/
    * implement await function to replace functionality of https://github.com/kriskowal/q
* statically verified guard statements that allow for static typing library, algebraic data typing: x#{self is Number} means x must always be statically determinable to be a number
* async "promise" and green thread system with async exceptions
* use OBJECT KEY for prototype/metatable: "base" object: obj[base]._get, etc. scope objects will always have the "base" property set to the "base" property of the enclosing scope, in order to give enclosing code access to the base of objects. inheritance is obj[base]._get := fn('key) { PARENT_OBJECT[key] }
* do something about the enumerability of object bases; they should not be enumerable, maybe special case in the enumerator
* "userdata"/"bytes" type like in lua/python: custom user-defined blocks of memory that have literals and having two variants: GC managed or explicitly managed
* make a code formatter that can infer style settings from a code sample
* static tail recursion elimination (make sure cases like $.return a ? b() : c() are handled by checking if the following bytecode instruction after the call is either a return or one or more unconditional jumps that leads to a return)
    * read http://neopythonic.blogspot.ca/2009/04/tail-recursion-elimination.html
    * improves usability of continuation passing style
* have the .each method return the result: squares := [1, 2, 3].each (fn ('x) { x ** 2 })
* % operator can format strings, .= can append to array
* FFI with libffi for DllCall-like functionality
* multiple catch clauses in exception handler, and each accepting a condition for catching: try {} catch e: e Is KeyboardInterrupt {}
* to make an object, use ClassName()
* named parameter "key" for functions such as [].max(), [].min(), [].sort(), etc. that allows the user to specify a function that specifies the key to use in place of the actual key, together with a custom comparison function with named parameter "compare"
* "with" statement that sets an object as a scope (needs internal support, or use $ := something), or possibly use binding to rebind this: {some code here}.bind(scope_object)
* refinement pattern: matcher := with Patterns, { ["hello", "hi"]..[" ", "`t"][1:Infinity].."world!" }) and: date := with Time, { next.friday + weeks * 2 }
* "ensure" or "assert" statements allow code to be statically verified
* macro { tokens.match({ comment .. line }).replace { result[1] } `n other compile-time code here } syntax for token-level replacements
* "is" operator that checks current class and recursively checks base classes
* "in" operator that checks for membership
* Function objects should have an call() method that applies a given array as the arguments, and allows specifying the "this" object, possibly as a named parameter
* for-loops and try-catch-else-finally should have an Else clause that executes if the loop did not break or an exception was not thrown
*/

FileName := A_ScriptFullPath ;set the file name of the current file

;Value = "a``r``nb`tc````d``"e"
;Value = abc param1, param2`ndef param1 + sin 45`n!ghi + 5 * jkl 123, 456
;Value = Something a, b, c`n4+5`nTest 1, 2, 3
;Value = a ? b : c`nd && e || f
;Value = 1 + sin x, y
;Value = sin x + 1, y
;Value = x !y
;Value = 1 - 2 * 3 + 5 ** 3
;Value = 1 - 2 * (3 + 6e3) ** 3
;Value = a.b[c].d.e[f]
;Value = a(b)(c,d)(e)
;Value = a ? b := 2 : c := 3
;Value = {}()
;Value = x := 'name
;Value = x.y.z
;Value = 1 + {2}
;Value = f(x,,,,,,,,y)
;Value = f x,, y: 'abc, z
;Value = 1 - 2 * 3
;Value = [a, f: g, b, 4, d: e,, c]
;Value = 1`n `n `n `n `n `n2`n    `n   `r
;Value = x < y > z`nx < y
;Value = x[a]+x[ : : ]+x[ : : c]+x[ : b : ]+x[ : b : c]+x[a : : ]+x[a : : c]+x[a : b : ]+x[ a : b : c]+x[ : ]+x[ : b]+x[a : ]+x[a : b]
Value = x.y += z`nx //= y`nx[y] := z

/* ;lexer testing
l := new Code.Lexer(Value)
Tokens := []
While, Token := l.Next()
    Tokens.Insert(Token)
MsgBox % Clipboard := Reconstruct.Tokens(Tokens)
;MsgBox % Clipboard := Dump.Tokens(Tokens)
ExitApp
*/

;/* ;parser testing
l := new Code.Lexer(Value)
p := new Code.Parser(l)
SyntaxTree := p.Parse()
MsgBox % Clipboard := Reconstruct.Tree(SyntaxTree)
;MsgBox % Clipboard := Dump.Tree(SyntaxTree)
ExitApp
*/

/* ;simplifier testing
l := new Code.Lexer(Value)
p := new Code.Parser(l)
SyntaxTree := p.Parse()
SimplifiedSyntaxTree := CodeSimplify(SyntaxTree)
MsgBox % Clipboard := Reconstruct.Tree(SimplifiedSyntaxTree)
ExitApp
*/

;/* ;bytecoder testing
l := new Code.Lexer(Value)
p := new Code.Parser(l)
b := new Code.Bytecoder
SyntaxTree := p.Parse()
Bytecode := b.Convert(SyntaxTree)
MsgBox % Clipboard := Dump.Bytecode(Bytecode)
ExitApp
*/

#Include Resources\Reconstruct.ahk

#Include Code.ahk
;#Include Simplifier.ahk