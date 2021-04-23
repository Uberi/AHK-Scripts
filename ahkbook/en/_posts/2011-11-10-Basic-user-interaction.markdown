---
title: "Basic user interaction: MsgBox & Co."
layout: post
permalink: /en/Basic-user-interaction.html
---

# Basic user interaction: `MsgBox` & Co.

## Working with the user
In an application, program or script, it is often needed to inform the user about something: whether an action completed successfully, any errors that occur, ...

It is also often necessary to get input from the user: maybe just a decision on yes/no, but also text or numbers. These things can be done by a program's window. However, there are easier ways, e.g. for scripts that don't need a window for anything else.

## Notifying the user & let him make decisions
For these two cases, the `MsgBox` command you already got to know is very useful. We already looked at cases like this:
{% highlight ahk linenos %}; any AutoHotkey version
MsgBox The operation completed successfully.
{% endhighlight %}
![screenshot](images/msgbox-1.png)
However, this isn't a lot. It doesn't give any first-shot visual information on what kind of message it is (question / error / notification) and my just be clicked away without being read. Also, the title of the box isn't very descriptive (it's the script's file name).

So we'll look at the other "mode" (or *overload*) of the command. You might remember, when [doing your first script](), there's a way to customize that box. An improved example:
{% highlight ahk linenos %}; any AutoHotkey version
MsgBox, 262208, Done., The operation completed successfully., 10
{% endhighlight %}
![screenshot](images/msgbox-2.png)
Well, that's pretty much. We got an icon and an own title. When running the code, you should also have heard a sound notification, and you might have noticed that you can't switch to another window, the box stays just in front. How to do that?

Look at the code: The 2nd param is, of course, the title, and the third one is the text to show. The last one is the timeout in seconds, after which the box will silently disappear. But the most awesome is the first param, which looks very strange. Those are the option for the box, which can be used for the icon (accompanied by sound), the available buttons (you can customize them!), the always-on-top behaviour and some other settings. It is just **the sum** of a few numbers Windows uses for that: [check out the available options]().

### Getting the user's decision
Let's take the following example:
{% highlight ahk linenos %}; any AutoHotkey version
MsgBox 33, Continue?, Do you wish to delete all files in "%A_ProgramFiles%"?
{% endhighlight %}
This will you give something like the following:
![screenshot](images/msgbox-3.png)
Now, your user can decide what to do. But how to recognize that in your script?

AutoHotkey has a special `if`-statement for that: `IfMsgBox`. This one is only valid directly below a `MsgBox` command. The values to compare with are:
* Yes
* No
* OK
* Cancel
* Abort
* Ignore
* Retry
* Continue
* TryAgain
* Timeout (present if the MsgBox timed out)

A usage example:
{% highlight ahk linenos %}; AutoHotkey classic and AutoHotkey_L
MsgBox 33, Continue?, Do you wish to delete all files in "%A_ProgramFiles%"?
IfMsgBox OK
	MsgBox No, that's not a good idea. I won't do that!
IfMsgBox Cancel
	MsgBox A wise decision!
{% endhighlight %}
As with any `if` statement, you use curly braces ({ and }) to enclose larger blocks here, and you can put an `else` below it.

### Getting the user's decision \#2
In AutoHotkey v2 and AutoHotkey\_H v2, this statement is removed. You must use a regular `if` statement and compare against the built-in variable `A_MsgBoxResult`.

### Getting the user's decision \#3
\[missing: info on IronAHK\]

## Getting more input
...

## More commands to use
* Progress
* SplashText
* SplashImage
