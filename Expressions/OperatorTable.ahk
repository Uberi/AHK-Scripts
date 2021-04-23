;operator, precedence, associativity, parameter count

OperatorTable = 
( Comments

:= 0 R 2
+= 0 R 2
-= 0 R 2
*= 0 R 2
/= 0 R 2
//= 0 R 2
.= 0 R 2
|= 0 R 2
&= 0 R 2
^= 0 R 2
>>= 0 R 2
<<= 0 R 2
;wip: ternary operator? (precendence 1 and 2, 3 parameters)
|| 3 L 2
&& 4 L 2
\! 5 R 1 ;low-precedence logical NOT
= 6 L 2
== 6 L 2
<> 6 L 2
!= 6 L 2
> 7 L 2
< 7 L 2
>= 7 L 2
<= 7 L 2
\. 8 L 2 ;concatenation
& 9 L 2 ;bitwise AND
^ 9 L 2
| 9 L 2
<< 10 L 2
>> 10 L 2
+ 11 L 2
- 11 L 2
* 12 L 2 ;multiplication
/ 12 L 2
// 12 L 2
\- 13 R 1 ;unary minus
! 13 R 1 ;logical NOT
~ 13 R 1
\& 13 R 1 ;address
\* 13 R 1 ;dereference
** 14 R 2
\++ 15 R 1 ;prefix increment
\-- 15 R 1 ;prefix decrement
++ 15 L 1 ;postfix increment
-- 15 L 1 ;postfix decrement
. 16 L 2 ;object access
`% 17 R 1

)
OperatorList := SubStr(RegExReplace(OperatorTable,"iS) \d+ [LR] \d+\n","`n"),2,-1)
Sort, OperatorList, F OperatorLengthSort

OperatorLengthSort(Operator1,Operator2)
{
 Return, StrLen(Operator2) - StrLen(Operator1)
}

Precedence(Operator)
{
 global OperatorTable
 Temp1 := InStr(OperatorTable,"`n" . Operator . " ") + StrLen(Operator) + 2
 Return, SubStr(OperatorTable,Temp1,InStr(OperatorTable," ",False,Temp1) - Temp1)
}

Associativity(Operator)
{
 global OperatorTable
 Return, SubStr(OperatorTable,InStr(OperatorTable," ",False,InStr(OperatorTable,"`n" . Operator . " ") + StrLen(Operator) + 2) + 1,1)
}

ArgumentCount(Operator)
{
 global OperatorTable
 Return, SubStr(OperatorTable,InStr(OperatorTable,"`n",False,InStr(OperatorTable,"`n" . Operator . " ") + 1) - 1,1)
}