---
title: Working with conditions
layout: post
permalink: /en/Working-with-conditions.html
---

# Working with conditions

## Conditions
You will notice, it is often needed to do things only *if something is like this or that* or if it is not.
This is common to all programming and scripting languages, and most of them use the word `if` to do that.

## if
So in AutoHotkey. As you got to know previously, AutoHotkey has a so-called expressional and a traditional mode. This also applies to `if`.
{% highlight ahk linenos %}
If (A_OSVersion == "WIN_98")
	MsgBox Oh, your computer is pretty old.
{% endhighlight %}
The above is an example for the expressional way: the actual comparison must be enclosed in braces.

{% highlight ahk linenos %}
If A_IsAdmin = 1
	MsgBox This script is executed as administrator.
{% endhighlight %}
Now this is the traditional way: no braces, the left side is **always** a variable, the right side is taken as literal string (or number).

As this is only a comparison for `true`/`false` (`1`/`0` in AutoHotkey), you can leave out the second part: `if A_IsAdmin` is enough. This also applies when using expressional mode: if you want, include `A_IsAdmin` in braces. You could also do a comparison to AutoHotkey's "constants" **true** and **false**.

It is often recommended to use expressional mode instead of traditional, because it is the same as in other languages, it is considered a <cite>better style</cite>, and traditional is removed in AutoHotkey v2 (and AutoHotkey\_H v2).

### comparison (==, =, !=, ...)
Of course you may sometimes want to do different comparisons. For example, the `=` operator compares **case-insensitive** in AutoHotkey (it doesn't care about lower- / uppercase). To do *case-sensitive comparison*, use the `==` operator instead.

As you might guess, `!=` (or also `<>`) checks whether the left and the right side are **not equal**. Also you might prefix a variable (or a condition enclosed in braces) by `!` or `not`.

AutoHotkey also supports `>`, `<`, `>=` and [a lot more]() ([AutoHotkey\_L]()).

### blocks
To do more than one line based on a condition, enclose those lines in curly braces:
{% highlight ahk linenos %}
if (!A_IsAdmin)
{
	MsgBox This script must be run as administrator.
	ExitApp ; closes the script
}
{% endhighlight %}

### More `if`
AutoHotkey classic, AutoHotkey\_L and AutoHotkey\_H also support several "if-like" statements such as `IfEqual`, `IfLess`, `IfGreater`, `IfLessOrEqual`, `IfWinActive`, `IfWinExist`, `IfWinNotActive`, `IfWinNotExist`, `IfExist`, `IfInString`, ... . Using those is discouraged today as they are often considered "bad style" and they're about to be removed in AutoHotkey v2, AutoHotkey\_H v2 and IronAHK. All of them can be worked around by using the "normal" `if` plus a comparison.

A special case is `IfMsgBox`, which can't be worked around in AutoHotkey classic, AutoHotkey\_L and AutoHotkey\_H. Still it will be replaced by something else in AutoHotkey v2, IronAHK and AutoHotkey\_H v2. We'll look at this further in the next chapter when we deal with the specifics of the `MsgBox` command.

## else
As all other languages, AutoHotkey also has an `else` statement. It can be put beneath any `if`-Block, and it can also be combined with an extra condition:
{% highlight ahk linenos %}
if (A_IsAdmin)
{
	MsgBox This script is run as admin.
}
else if (A_OSVersion == "WIN_VISTA")
{
	MsgBox This script is not run as admin. You might check your UAC settings.
}
else
	MsgBox This script is not run as admin.
{% endhighlight %}
You can also combine `else` with those special if-statements mentioned above.

## Combining conditions
Also, you might sometimes want to check for multiple conditions: if both, at least one, or none of them applies.
This is only supported in expression mode: combine the conditions with the word `and` (or `&&`) to check for both, and with `or` (or `||`) to check for at least one.

{% highlight ahk linenos %}
if (A_IsAdmin AND A_Year > 2011)
	MsgBox This script is run as administrator in 2012 or later.
{% endhighlight %}

