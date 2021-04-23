Fraction.ahk
============
Complete fractional math library.

Setup
-----

After downloading, extract the folder. In your project, include the Fraction.ahk library:

    #Include PATH_TO_LIBRARY\Fraction.ahk

Or alternatively, if the folder is located in your standard library:

    #Include <FOLDER_NAME\Fraction>

Usage
-----

### Creation

Create a `Fraction` object as follows:

    SomeFraction := new Fraction(5,2)

The above creates a `Fraction` object with a value of 5/2.

We can also use a single real or integral number:

    SomeFraction := new Fraction(2.75)

The above creates a `Fraction` object with a value of 11/4.

It is also possible to use a fraction string:

    SomeFraction := new Fraction("3 / 4")

The above creates a `Fraction` object with a value of 3/4.

Fraction strings may contain arbitrary amounts of whitespace.

### Operations

Given a fraction, we can apply operations to it:

    SomeFraction := new Fraction(1,2)
    SomeFraction.Add(new Fraction(3,4))

The object now has a value of 1/2 + 3/4, or 5/4.

Many of the methods return the object itself. That means we can chain methods together:

    SomeFraction := new Fraction(7,8)
    SomeFraction
        .Add(new Fraction(6,3))
        .Multiply(new Fraction(9,2))
        .Subtract(new Fraction(2,5))

The object now has a value of ((7/8 + 6/3) * 9/2) - 2/5, or 1003/80.

Many of the methods modify the object itself rather than returning a new object with the modifications.

If we need to keep the original object but also want the result of an operation, the following pattern applies:

    SomeFraction := new Fraction(1,5)
    Quotient := SomeFraction.Clone().Divide(new Fraction(1,2))

The object `SomeFraction` retains its value of 1/5, but the object `Quotient` has a value of (1/5) / (1/2), or 2/5.

### Fraction Reduction

By default, all fractions are automatically reduced to their smallest possible forms. That is, 3/6 will become 1/2, and 9/27 will become 1/3.

Reduction makes the denominator positive and the numerator assumes the final sign of the fraction.

If this behavior is not desired, or if performance can be gained by avoiding it, disable it for a given `Fraction` object using Fast mode:

    SomeFraction := new Fraction
    SomeFraction.Fast().Set(2,4)

The object now has a value of 2/4, rather than 1/2, which it would have if reduced.

While in Fast mode, we can still manually reduce fractions when needed:

    SomeFraction := new Fraction
    SomeFraction.Fast().Set(3,9)
    SomeFraction.Reduce()

The object now has a value of 1/3, since it has been reduced.

To disable Fast mode for a given `Fraction` object:

    SomeFraction := new Fraction
    SomeFraction.Fast().Set(3,9)
    SomeFraction.Fast(False)

The object now has a value of 1/3.

Fast mode also disables error checking for method parameters that accept `Fraction` objects.

Reference
---------

In addition to the standard object methods, the following are also available:

### SomeFraction := new Fraction(Numerator = 0,Denominator = "")

Creates and returns a new `Fraction` object.

Invalid values result in an exception being thrown.

There are 3 forms that the constructor accepts.

First, the explicit form:

    SomeFraction := new Fraction(x,y)

Where `x` and `y` are integer values denoting the value of the fraction's numerator and denominator, respectively. Additionally, `y` cannot be 0.

Second, the numerical form:

    SomeFraction := new Fraction(n)

Where `n` is a real number denoting the numerical value of the fraction.

Third, the fraction string form:

    SomeFraction := new Fraction(s)

Where `s` is a string of the form `{optional whitespace}{integer}{optional whitespace}/{optional whitespace}{integer}{optional whitespace}` denoting the value of the numerator and denominator. Additionally, the denominator cannot be 0.

### SomeFraction := SomeFraction.Set(Numerator = 0,Denominator = "")

Sets the fraction's value and returns the fraction.

Invalid values result in an exception being thrown.

This method behaves in the same way as the constructor, `SomeFraction := new Fraction(Numerator = 0,Denominator = "")`.

### SomeFraction := SomeFraction.Fast(Flag = True)

Enables or disables Fast mode and returns the fraction.

In Fast mode, fractions are not reduced to their simplest form unless explicitly reduced using `SomeFraction := SomeFraction.Reduce()`, as opposed to the default behavior, which is to always have the fractions in their simplest form.

Additionally, in Fast mode methods that expect `Fraction` objects as parameters will not check those parameters to make sure they are valid `Fraction` objects.

When `Flag` is truthy, Fast mode is enabled. When it is falsy, Fast mode is disabled.

Fast mode is applied only to the object itself, and does not affect other `Fraction` objects.

### SomeFraction := SomeFraction.Reduce()

Reduces the fraction to its simplest form and returns the fraction.

The simplest form is defined as the form in which the numerator and denominator are coprime. That is, they have no common factors other than 1.

### RealNumber := SomeFraction.ToNumber()

Returns the fraction's equivalent real number.

### StringFraction := SomeFraction.ToString()

Returns a string of the form `x/y`, where `x` is the fraction's numerator and `y` is the fraction's denominator.

### BooleanValue := SomeFraction.Equal(Value)

Returns a boolean value denoting whether the fraction is equal to `Value`, a `Fraction` object.

Invalid values result in an exception being thrown unless Fast mode is enabled.

### BooleanValue := SomeFraction.Less(Value)

Returns a boolean value denoting whether the fraction is less than `Value`, a `Fraction` object.

Invalid values result in an exception being thrown unless Fast mode is enabled.

### BooleanValue := SomeFraction.LessOrEqual(Value)

Returns a boolean value denoting whether the fraction is less than or equal to `Value`, a `Fraction` object.

Invalid values result in an exception being thrown unless Fast mode is enabled.

### BooleanValue := SomeFraction.Greater(Value)

Returns a boolean value denoting whether the fraction is greater than `Value`, a `Fraction` object.

Invalid values result in an exception being thrown unless Fast mode is enabled.

### BooleanValue := SomeFraction.GreaterOrEqual(Value)

Returns a boolean value denoting whether the fraction is greater than or equal to `Value`, a `Fraction` object.

Invalid values result in an exception being thrown unless Fast mode is enabled.

### SignValue := SomeFraction.Sign()

Returns an integer denoting the sign of the fraction.

If the fraction is positive, the integer is 1. If the fraction is negative, the integer is -1. Otherwise, the fraction is equal to 0, and the integer is 0.

### SomeFraction := SomeFraction.Abs()

Modifies the fraction so that it is positive and returns the fraction.

Both the numerator and the denominator are made positive.

### SomeFraction := SomeFraction.Add(Value)

Adds `Fraction` object `Value` to the fraction and returns the fraction.

Invalid values result in an exception being thrown unless Fast mode is enabled.

The fraction is modified in place.

### SomeFraction := SomeFraction.Subtract(Value)

Subtracts `Fraction` object `Value` from the fraction and returns the fraction.

Invalid values result in an exception being thrown unless Fast mode is enabled.

The fraction is modified in place.

### SomeFraction := SomeFraction.Multiply(Value)

Multiplies the fraction with `Fraction` object `Value` and returns the fraction.

Invalid values result in an exception being thrown unless Fast mode is enabled.

The fraction is modified in place.

### SomeFraction := SomeFraction.Divide(Value)

Divides the fraction by `Fraction` object `Value` and returns the fraction.

Invalid values result in an exception being thrown unless Fast mode is enabled.

The fraction is modified in place.

### SomeFraction := SomeFraction.Remainder(Value)

Sets the fraction to the remainder of dividing the fraction by `Fraction` object `Value` and returns the fraction.

Invalid values result in an exception being thrown unless Fast mode is enabled.

The fraction is modified in place.

### SomeFraction := SomeFraction.Exponentiate(Value)

Sets the fraction to the result of the fraction to the power of integer `Value` and returns the fraction.

The fraction is modified in place.

### SomeFraction := SomeFraction.GCD(Value)

Sets the fraction to the greatest common divisor of the fraction and `Fraction` object `Value` and returns the fraction.

The greatest common divisor is the largest positive number that can divide both fractions such that the result is a whole number.

The fraction is modified in place.

### SomeFraction := SomeFraction.LCM(Value)

Sets the fraction to the least common multiple of the fraction and `Fraction` object `Value` and returns the fraction.

The least common multiple is the smallest positive number that can be divided by both fractions such that the result is a whole number.

The fraction is modified in place.

License
-------

Copyright 2013 Anthony Zhang <azhang9@gmail.com>

This file is part of Fraction.ahk. Source code is available at <https://github.com/Uberi/Fraction.ahk>.

Fraction.ahk is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.