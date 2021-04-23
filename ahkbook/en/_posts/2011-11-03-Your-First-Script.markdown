---
title: Your first script
layout: post
permalink: /en/Your-First-Script.html
---
# Your first script

## Let's start
You should have chosen and installed your AutoHotkey version now. We'll do our first script.

## Create a script file
If you have used the AutoHotkey classic or AutoHotkey\_L installer, right-click on your desktop or any folder and select New > AutoHotkey Script from the context menu. Open the newly created file in your editor. If you haven't run an installer, just open your favorite editor (or use Windows Notepad) and save it as a file with the extension ".ahk".

In the editor, type the following code:
{% highlight ahk linenos %}; any AutoHotkey version
MsgBox Hello, World!
{% endhighlight %}

Save your file again now.

---
### Note:
Make sure you chose the correct encoding. If you have installed AutoHotkey classic or AutoHotkey\_L ANSI, use, of course, ANSI, otherwise use UTF-8.

* In Windows Notepad, this setting is available under `File` > `Save As...` > `encoding`.
* In Notepad++, it's in the menu bar under `Encoding`.

---
## Execute your script
If you have run an installer, just double-click the file for executing it. Otherwise use the command line to run `[Path/To/YourAutoHotkey].exe "[Path/to/your/script].ahk"`. You can also drag your script file on the executable in Windows Explorer or on your desktop.

For IronAHK on Linux / Ubuntu / Mac, run `mono IronAHK.exe [Path/to/our/script].ahk`.

You should see a box appear similar to the screenshot below:
![MsgBox screenshot](images/Hello-World-1.png)

## What happened?
The first word in your code above, `MsgBox`, is an AutoHotkey command that instructs AutoHotkey to show that box. The rest of the code is, as you might have guessed, the message to display.

## Extending that example
You can customize the MsgBox further:
![2nd MsgBox screenshot](images/Hello-World-2.png)

Use the following code:

{% highlight ahk linenos %}; any AutoHotkey version
MsgBox, 36, a question, Would you like to say "Hello, World"?
{% endhighlight %}

## Comments
As in all programming and scripting languages, you can add comments to AutoHotkey source code as well:

{% highlight ahk linenos %}; any AutoHotkey version
/***********************************
This is my first script!
Impressive, isn't it?
************************************
*/
MsgBox ; this displays a box saying "Click OK to continue"
{% endhighlight %}

So you can see: the character for one-line comments is the semicolon (`;`). This can of course be used in the same line as code, but it must be at the end and there must be at least one space or tab before the semicolon.

For multi-line comments, you use `/*` and `*/`. There can be more text on the same line as the comment start (as in the example), but **the comment-end must be alone in a line!**

## Escape sequences
Now, maybe you want to make a box saying "1, 2, 3"? This should be as easy:
{% highlight ahk linenos %}
MsgBox 1, 2, 3
{% endhighlight %}
But what's that? The MsgBox looks more like this:
![screenshot](images/Escaping-1.png)

Well, AutoHotkey uses commas to separate parameters from each other. As you saw [above](#extending_that_example), the `MsgBox` command has more than one parameter, so it takes 1, 2 and 3 as three parameters. How to prevent that?

AutoHotkey has, as most other languages, so-called *escape sequences*. Those prevent some characters from being read as syntax.
AutoHotkey's escape character is not the backslash (`\`) as in some other languages, it is the backtick (\`).

- - -
The allowed escape sequences are:

* `` `, `` - a literal **comma**. If not escaped, this might be read as parameter delimiter.
* `` `% `` - a literal **percent sign**. If not escaped, `%` is used for variables. We'll look at that later.
* \`\` - a literal **backtick**. If not escaped, this is used as escape char.
* `` `; `` - a literal **semicolon**. As you just learned, this is usually used for comments. If there's no space or tab to the left of the semicolon, this is not used.
* `` `n `` - a literal **newline**. As AutoHotkey has no explicit line end char, each code line ends at the next newline. An exception are [continuation sections]().
* `` `r `` - a **carriage return**. This sign is used in Windows before each newline.
* `` `b `` - a literal **backspace**
* `` `t `` - a horizontal **tab**
* `` `v `` - a **vertical tab**, which corresponds to Ascii value 11. It can also be manifest in some applications by typing Control+K. 
* `` `a `` - an **alert (bell)**, which corresponds to Ascii value 7. It can also be manifest in some applications by typing Control+G. 
* `` `f `` - a **formfeed**, which corresponds to Ascii value 12. It can also be manifest in some applications by typing Control+L.
* `""` - Within an [expression](), two consecutive quotes enclosed inside a literal string resolve to a single literal **quote**.
* `` `" `` or `` `' `` - This replaces the above in AutoHotkey v2.

- - -
So now we can do the above example:
{% highlight ahk linenos %}
MsgBox 1`, 2`, 3
{% endhighlight %}
And it works!
![screenshot](images/Escaping-2.png)

