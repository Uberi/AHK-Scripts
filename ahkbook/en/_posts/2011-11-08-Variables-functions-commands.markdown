---
title: Variables, commands and function stuff
layout: post
permalink: /en/Variables-functions-commands.html
---

# Variables, commands and function stuff

## Creating a variable
AutoHotkey is a scripting language, designed to make things easy and fast to be coded. Variables don't need to be created, "declared".
They aren't typed either. So you can use a variable and assign some text to it or a number, it doesn't matter.

{% highlight ahk linenos %}
; any AutoHotkey version
MyVar := "Hello!"
{% endhighlight %}
This simply creates a variable named `MyVar` and assigns the string <cite>Hello!</cite> (*without the quotes*) to it.
If this is put in the auto-execute section, it should automatically be available to the rest of the auto-execute section below and all labels.
There's more to be said about [variable scoping]() when we deal with functions later.

### Concat text, numbers and variables
If you want to concat text, numbers or variables in tradtional mode, you needn't to anything (except leave a space between 2 percent signs).

In expressional mode, there's the *concat operator*, which is simply a dot (`.`).
However, using it is **optional**, you may just leave a space in there.
{% highlight ahk linenos %}; any AutoHotkey version except AutoHokey v2 and AutoHotkey_H v2.
name := "Tim"
message = %user% is very clever! ; tradtional concat
{% endhighlight %}
{% highlight ahk linenos %}; any AutoHotkey version
votes := 12
result := "Votes for " . user . ": " votes ; using 2 explicit concats and 1 implicit
{% endhighlight %}

### \#MustDeclare
...

## Referencing a variable
Referencing a variable is basicly easy. However, there's one big pitfall beginners often have problem with, called <cite>traditional vs. expressional</cite>. This not only affects variables, but also strings.

### traditional:
We'll start with traditional:
{% highlight ahk linenos %}
; any AutoHotkey version except AutoHokey v2 and AutoHotkey_H v2.
MyVar = Hello! ; traditional assignment: using "=", no quotes
MsgBox The content of "MyVar": %MyVar% ; command (traditional)
My2ndVar =  %MyVar% ; traditional assignment: % around a variable
{% endhighlight %}
As you see, usually when referencing a variable, it is delimited by percent-signs.
Literal text does not need to be enclosed in quotes, if they are present, they're taken as literal quotes. But that is not always the case.

In AutoHotkey v2 (and AutoHotkey\_H v2), literal **assignments** (i.e. line 2 and 4) are not supported. Command calls are still supported, using traditional syntax.

### expressional
When assigning a variable with `:=`, you force the left side to be an expression. As expressions also appear in some other cases, it's important to know how to deal with them.
{% highlight ahk linenos %}
; any AutoHotkey version
MyVar := "Hello!"
IsLabel(MyVar) ; dummy function call using expressional version
My2ndVar := MyVar
{% endhighlight %}
As you see, in expressional mode variables are **not** enclosed in percent signs.
Literal text must be enclosed in double-quotes (AutoHotkey v2 and AutoHotkey\_H v2 also support single quotes).

## commands & functions
In AutoHotkey, there are 2 ways of executing code: *commands* and *functions*.

As you saw above, commands (like `MsgBox`) use the traditional mode by default, functions (like `IsLabel()`) use expressional mode.
Additionally, in function calls, parameters are enclosed in parentheses whereas they aren't in commands.
{% highlight ahk linenos %}; any AutoHotkey version
user := "Tom"
MsgBox Hi %user%! ; command: no parentheses, no quotes, but %-signs

suffix := "_2"
IsLabel("AnyLabel" suffix) ; function: parentheses + quotes, no %-signs
{% endhighlight %}

### forcing expression mode
You can force expressional mode for a command parameter with a single percent sign:
{% highlight ahk linenos %}
MsgBox % "This is a parameter in enforced expression mode."
{% endhighlight %}
But you can't do the contrary for functions.

### `OutputVar` and `InputVar`
A special case of command parameters are those called <cite>InputVar</cite> or <cite>OutputVar</cite> (+ some exceptions with other names such as in [SplitPath]()).
Those are taken as variable names: if you pass e.g. `MyVar` it won't take the string <cite>MyVar</cite> but the variable `MyVar`.

### AutoHotkey v2
In AutoHotkey v2 (and AutoHotkey\_H v2), you can decide for everything whether you want to use command or function syntax to call it.

\[missing: about input and output vars in AHK v2\]

## Summary
To prevent you from doing the common <cite>traditional vs. expressional</cite> mistake, here's a summary from the help file's FAQ:

<blockquote><!-- use html as markdown can't handle liquid code tags in blockquote -->
<h4>When are quotation marks used with commands and their parameters?</h4>
Double quotes (") have special meaning only within expressions. In all other places, they are treated literally as if they were normal characters. However, when a script launches a program or document, the operating system usually requires quotes around any command-line parameter that contains spaces, such as in this example:
{% highlight ahk linenos %}Run, Notepad.exe "C:\My Documents\Address List.txt"{% endhighlight %}

<h4>When exactly are variable names enclosed in percent signs?</h4>
Variable names are always enclosed in percent signs except in cases illustrated below:<br/>

1) In parameters that are input or output variables:
{% highlight ahk linenos %}StringLen, OutputVar, InputVar{% endhighlight %}
2) On the left side of an assignment:
{% highlight ahk linenos %}Var = 123abc{% endhighlight %}
3) On the left side of traditional (non-expression) if-statements:
{% highlight ahk linenos %}If Var1 < %Var2%{% endhighlight %}
4) Everywhere in expressions. For example: 
{% highlight ahk linenos %}If (Var1 <> Var2)
    Var1 := Var2 + 100{% endhighlight %}
</blockquote>

