---
title: Working with bits
layout: post
permalink: /en/Working-with-bits.html
---
# Bitwise Operations #

## Understanding Binary
Before you can use bitwise operations, you need to understand how numbers are stored in a computer's memory. The simplest form is "switches" which are either off or on. Programmers represent these as 0 and 1 (called 'bits'), respectively.

### Base 10 ###
Binary, or Base 2, is simply another way to write numbers. In everyday life, we use Base 10. We have the Ones place, the Tens place, the Hundreds place, and so on. More technically, each digit is multiplied by 10^n, where *n* represents the distance from the right, starting from 0. Thus, the number 647 is equivalent to ``(6 * 100) + (4 * 10) + (7 * 1)``, or ``(6 * 10^2) + (4 * 10^1) + (7 * 10^0)``. (Yes, 10^0 is 1, and this is no place to discuss why.)

### Base 2 ###
Base 2, or "Binary," works exactly the same way. Each digit is multiplied by 2^n, where *n* is the distance from the right, starting at 0. Thus, the number 1101001 in binary is equivalent to ``(1 * 64) + (1 * 32) + (0 * 16) + (1 * 8) + (0 * 4) + (0 * 2) + (1 * 1)``. In base 10, that is 105.

## Basic Operations ##
So what is 1+1 in Binary? It's certainly not 2; binary doesn't have a 2! It's *10*, which means ``(1 * 2^1) + (0 * 2^0)``. All of the basic arithmetic operations &#8212; addition, subtraction, multiplication, and division &#8212; work in binary just as well as they do in Base 10. Because of this, there's no real reason to use them in Binary as opposed to base 10. However, there are some other operations which always pertain to Binary: the bitwise AND, the bitwise OR, the bitwise XOR, the bitwise NOT, and the bit-shifts left and right.

### The Bitwise AND ###
The bitwise AND (represented by a single ampersand '&' in AutoHotkey) takes two digits at a time. If they are both 1, then the result is 1. Otherwise, the result is false. Here's an example:

     1100
    &1010
    _____
     1000

Notice how the only '1' in the result occurred when both operands had a 1 in that place. 1 & 1 = 1; 1 & 0 = 0; 0 & 1 = 0; 0 & 0 = 0.

### The Bitwise OR ###
The bitwise OR (a single pipe '|' in AutoHotkey) has a different effect. It takes two operands, and if *at least one* of them is true (a 1) then the result is 1. Example:

     1100
    |1010
    _____
     1110

Notice how the only '0' in the result occurred when both operands (digits) were 0.

### The Bitwise NOT ###
The bitwise NOT (~ in AutoHotkey) takes only *one* operand. It then "flips" every bit (digit) &#8212; if it is 0, the result is 1, if it is 1, the result is 0. Example 1:

    ~1010
    _____
     0101

Example 2:

    ~0001
    _____
     1110

### The Bitwise XOR ###
The bitwise XOR, short for eXclusive-OR (*Note:* the bitwise XOR is ^ in AutoHotkey; ** is used to represent exponentiation) takes two operands. If they are not the same, the result is 1, otherwise it is 0. Another way of saying this is "one or the other is true, but not both" (which is where the term exclusive OR comes from.) Example:

     1010
    ^1100
    _____
     0110

### The Bit shift left and the bit shift right ###
The bit shift left (<<) and the bit shift right (>>) take one operand. Then, they literally slide the bits (digits) left or right. Example:

    00001010 << 3
    _____________
    01010000

Another:

    0011100 >> 2
    ____________
    0000111

Note that if you shift a bit off of the side, it will "fall off": it is lost. Example:

    0101 >> 1
    _________
    0010

These operators are very similar to multiplying by or dividing by powers of 2. (Which should make sense, since binary is Base 2). Therefore, ``3 << 5`` is the same as ``3 * 2**5`` (remember, in AutoHotkey, ** represents exponentiation), which equals 96. Remember that digits slide off, so ``3 >> 1`` is not 1.5 (3/2) but rather *1*. See the example:

    0011      (3 in binary)
    >> 1      (slide it to the right by 1)
    ____
    0001      (1 in binary)

## Bitwise Assignments ##
Bitwise assignments are slightly odd-looking creatures such as ``>>=``, ``^=``, and ``|=``. These take a variable to the left and an argument to the right, plug them into an operation (specified by the type of operator before the equals-sign), evaluate the result, and store it back into the variable. For example,

{% highlight ahk lineos %}
MyVar := 5 ; 101 in binary
MyVar |= 2 ; 101 | 010 = 111 = 7
MsgBox % MyVar ; 7

MyVar := 5  ; 101 in binary
MyVar <<= 2 ; 101<<2 = 10100 = 20
MsgBox % MyVar ; 20
{% endhighlight %}

## Conclusion: Real applications ##
Now that you know the basics of Binary and operations you can do on it, what is it useful for? Probably not a lot in everyday scripting, but it becomes more useful with the WinAPI and structures that need to be passed to it. It does occasionally pop up in unexpected places like the [MsgBox](http://l.autohotkey.net/docs/commands/MsgBox.htm) command. Take a look at the options. How does the command know if you want a particular option (if you've added one option to another)? It uses bitwise operations. For example, if you want a question mark and the buttons Yes, No, and Cancel, you would add 3+32 to get 35. The MsgBox command can then use bitwise operations (pseudo-code):

    If (VarContaining35 & 32)
        ; add the '?' icon

This works because each option which can only have 2 states &#8212; on or off &#8212; (all except the 'button' ones) is a multiple of 2, and therefore has only a single 1 in its binary representation. Therefore, OR'ing them all together is the same as  adding them, and you can retrieve the value of a single bit (option) by using the binary AND operator.