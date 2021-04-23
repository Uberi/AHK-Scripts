---
title: Repeating things
layout: post
permalink: /en/Repeating.html
---

# Repeating things

## a simple loop
Sometimes you want to do something "forever" or as long as the script runs. Or you want to do it several times, but you don't know exactly how long. For those cases, enclose it in a `Loop`-block:
{% highlight ahk linenos %}; any AutoHotkey version
Loop
{
	MsgBox Loop iteration %A_Index%
}
{% endhighlight %}
As you see above, the built-in variable `A_Index` contains the current iteration count. If you just want to repeat one line, you can leave out the braces.

As the above may consume a lot of memory, you may want it to wait some time before the next iteration:
{% highlight ahk linenos %}; any AutoHotkey version
Loop
{
	MsgBox Loop iteration %A_Index%
	sleep 1000 ; waits 1000 ms = 1 s before going on
}
{% endhighlight %}

### `SetTimer`
For less memory consumption and to be able to do other things during the "wait-period", you can also use [SetTimer]() instead of a loop.

### repeating x times
Sometimes you also want to repeat something but only a certain number of iterations. That's very easy:
{% highlight ahk linenos %}; any AutoHotkey version
Loop 10 ; does 10 iterations
{
	MsgBox Loop iteration %A_Index%
}
{% endhighlight %}
You can also use a variable here. There's only a slight difference in AutoHotkey v2 and AutoHotkey\_H v2:
In all other versions, you must enclose the variable in percent signs. In AutoHotkey v2 and AutoHotkey\_H v2, leave the percent signs out (`Loop` accepts an expression parameter).

### `break` and `continue`
During loop execution, you may sometimes discover something which should stop the loop or the current iteration.
In all kinds of loops presented here (except for `SetTimer`, which isn't a real loop), you can use `break` to stop the loop, and `continue` to skip the rest of the current iteration:
{% highlight ahk linenos %}; any AutoHotkey version
Loop
{
	if (breakNow)
		break
	if (skipIteration)
		continue
	; do something here that may change "breakNow" or "skipIteration"
}
{% endhighlight %}

## `while` & `until`
If there's only one condition that may cause a `break`, you way also use a `while`-loop or a loop-`until`.
{% highlight ahk linenos %}; any AutoHotkey version
While (!breakNow)
{
	; do something that may change "breakNow"
}
{% endhighlight %}
{% highlight ahk linenos %}; AutoHotkey_L, AutoHotkey_H, AutoHotkey v2 and AutoHotkey_H v2
Loop
{
	; do something that may change "breakNow"
} until breakNow
{% endhighlight %}
The difference is that `while` checks the condition **before** the iteration, whereas `until` checks it **after** the iteration (so there's always at least one iteration).

## `for` (each)
AutoHotkey has also a `for` loop (which corresponds to `foreach` in many other languages). We will cover this when dealing with objects later.

## Loop parse, reg, file, ...
...

