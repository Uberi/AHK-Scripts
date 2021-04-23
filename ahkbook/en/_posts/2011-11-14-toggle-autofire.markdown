---
title: "'toggle' and 'autofire'"
layout: post
permalink: /en/toggle-autofire.html
---

# What is a toggle?
A toggle can be thought of as a lightswitch. While the toggle is on, the script does something, often repeating an action. As soon as you "flip the switch," the repeating action stops. AutoHotkey's [Pause](http://d.ahk4.me/~Pause) command is one example of a toggle. A checkbox can be 'toggled' on and off.

## A simple example
Let's try a simple example autofire. Start with a script that [Loop](http://d.ahk4.me/~Loop)s an action, such as sending a key:
{% highlight ahk linenos %}; any AutoHotkey version
Loop
	Send z
{% endhighlight %}
However, this script will go on forever. If we use the [Pause](http://d.ahk4.me/~Pause) command, we can turn it on and off:
{% highlight ahk linenos %}; any AutoHotkey version
Pause On
Loop
	Send z
F8::Pause
{% endhighlight %}
What happened? The first command, [Pause](http://d.ahk4.me/~Pause), immediately "pauses" execution. This means that the script has temporarily stopped. It will not continue executing until the user unchecks "Pause Script" from the tray menu, or the script executes the Pause command. The script can either turn it off explicitly ("Pause off"), or toggle the paused state ("Pause, Toggle" or simply "Pause"). In this script, each press of the F8 key (See [Hotkeys]()) will toggle it; the first one will turn it on, the second off, etc. While the script is executing (not paused) it will repeatedly send the **z** keypress.

A script doesn't need to be constantly sending keys to use a toggle; it could for example toggle a window's color between red and green. There is one concept essential to toggles called the "logical not."

# The logical not
(Prerequisite: [Expressions](http://d.ahk4.me/Expressions))
The 'not' operation works as it does in logic: if a value is true, it returns false; and if a value is false, it returns true. In AutoHotkey, "true" is anything which is not 0 or blank, and "false" is anything 0 or blank (an empty string). The built in variables `true` and `false` contain 1 and 0, respectively. Try the following example:
{% highlight ahk linenos %}; any AutoHotkey version
MsgBox % "Not 1 is: " . (not 1)
MsgBox % "Not 0 is: " . (not 0)
MsgBox % "Not ""hello"" is: " . (not "hello")
MsgBox % "Not """" (empty) is: " . (not "")
{% endhighlight %}
We can use this to implement a toggle: 
{% highlight ahk linenos %}; any AutoHotkey version
t := false
F8::
 t := !t
 MsgBox % t
 return
{% endhighlight %}
Run the above script and press F8 few times; notice how it switches between 0 and 1. `t` stands for Toggle. Using **inline assignment** we can shorten this:
{% highlight ahk linenos %}; any AutoHotkey version
F8:: MsgBox % (t := !t)
{% endhighlight %}
`t`, like all variables, starts out blank (false). Then, in the MsgBox, we give it a new value each time. While this technique is not essential, it can significantly shorten (and clean up) code.

## A more complex example <!-- add more later? -->
Here's another way we can implement our simple example:
{% highlight ahk linenos %}; any AutoHotkey version
#MaxThreadsPerHotkey 2
F8::
 t := !t
 While t
	Send z
return
{% endhighlight %}
Let's break it down. **#MaxThreadsPerHotkey 2** is essential to the script. It says that while the F8 hotkey is working (typing) we can trigger it a second time. This way, it is able to stop itself. **t := !t** toggles the variable `t`. Then, while that variable is `true`, we will send z. When the hotkey is pressed again, `t` will gain a new value (false) and the while loop in each thread (the thread doing the sending, and the one which just "turned off" `t`) will finish.

# Final reading

It is worth reading these sections of the AHK documentation to further understand toggles:
[#MaxThreadsPerHotkey](http://www.autohotkey.net/~Lexikos/AutoHotkey_L/docs/commands/_MaxThreadsPerHotkey.htm)
[Threads](http://www.autohotkey.net/~Lexikos/AutoHotkey_L/docs/misc/Threads.htm)
[While](http://www.autohotkey.com/docs/commands/While.htm)
[SetTimer](http://www.autohotkey.net/~Lexikos/AutoHotkey_L/docs/commands/SetTimer.htm)

Additionally, [The Definitive AutoFire Thread](http://www.autohotkey.com/forum/topic69474.html) contains every way to implement an autofire imaginable, from Pause to SetTimer to While and more.