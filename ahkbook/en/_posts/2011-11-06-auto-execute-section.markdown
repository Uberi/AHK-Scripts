---
title: the "auto-execute" section
layout: post
permalink: /en/auto-execute-section.html
---

# The "auto-execute" section

## When a script starts...
If you know other programming languages, you might have noticed in your first script, that AutoHotkey doesn't have some special `Main()` or `__init__()` function that is used as starting point for the script.
When an AutoHotkey script launches, it just starts execution from the first line of your script. It continues from there line by line until it hits an end point.
This is called the *auto-execute section*.

## End points
An end point is marked by a `return` statement. An example:
{% highlight ahk linenos %}
MsgBox This is line 1. Execution starts here.
MsgBox This is line 2. Execution continues here.
MsgBox This is line 3. Execution will stop at the "return" in line 4.
return

MsgBox This is line 6. This will never be executed.
{% endhighlight %}

## Exceptions
There are some exceptions to this rule:

* Any [user-defined function]() in the auto-execute section will *not be executed* unless it is explicitly called. It is just ignored.
* Any [hotkey]() also is *not executed*, and **it stops the execution**, as if there was a `return` statement before it.

