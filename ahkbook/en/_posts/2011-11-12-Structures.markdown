---
title: Structures
layout: post
permalink: /en/Structures.html
---

# Structures

A structure is simply a section of memory that contains structured data. Each piece of data in the structure is known as a "member" of the structure. Structures and their members have no meaning on their own; they are simply blocks of data.

## size of structures
The size of a given structure is equal to the sum of the sizes of each member. For example, the [Rect](http://msdn.microsoft.com/en-us/library/dd162897.aspx) structure is defined as follows:

    typedef struct _RECT {
      LONG left;
      LONG top;
      LONG right;
      LONG bottom;
    } RECT, *PRECT;

This shows to following information:

* The name of the structure (RECT)
* The names of the members ("left", "top", "right", and "bottom")
* The types of the members (LONG, LONG, LONG, and LONG)

Let's look at the last point in detail. The type of a member determines its size; a LONG is 4 bytes, a SHORT is two bytes, and a CHAR is one byte. In this case all of the members of the Rect structure are of type LONG, and therefore each member is 4 bytes in size. With four members of four bytes each, the total size of the structure is 16 bytes.

**Note:** Those "struct definitions" in this chapter are **not AutoHotkey code**, they're C / C++. Copying them somewhere in your script will make the script fail on startup.

## structure members
In order to access a member of a structure, one must know its type and offset. For example, accessing the "bottom" member of the Rect structure requires knowledge that it is of type LONG, and is the fourth member of the structure, after three members with the type LONG. To calculate the offset, we must walk through every member before it. A demonstration follows:

1. The offset starts at 0. That means the current offset is 0.
2. The "left" member is a LONG, and therefore is 4 bytes. That means the current offset is 0+4, or 4.
3. The "top" member is a LONG, and therefore is 4 bytes. That means the current offset is 4+4, or 8.
4. The "right" member is a LONG, and therefore is 4 bytes. That means the current offset is 8+4, or 12.
5. The "bottom" member has been reached, so we stop here. The final offset is 12.

Since we now know the type and offset of the member, we are now able to access it.

### pointer types
Pointer types can be fickle to calculate offsets for: on 32-bit systems they are 4 bytes in size, but on 64-bit systems they are 8 bytes in size. This is a problem when trying to write applications that work on both. The solution: a built in variable named `A_PtrSize` contains 4 on 32-bit systems and 8 on 64-bit systems. When calculating offsets, instead of adding 4 or 8 for a pointer type, simply add the variable `A_PtrSize`. For example, a member with two DWORD members and two PVOID members before it would have the offset 4+4+A\_PtrSize+A\_PtrSize, or 8+(A\_PtrSize\*2).

It should be noted that `A_PtrSize` exists only in AutoHotkey\_L or similarly recent versions, as the older versions do not support native 64-bit scripts, but the following workaround can be used in these cases:

{% highlight ahk linenos %}; any AutoHotkey version
PtrSize := A_PtrSize ? A_PtrSize : 4
{% endhighlight %}

## initializing structures
AutoHotkey has several facilities for creating structures. Before creating a structure, however, one must ensure there is a section of memory large enough to hold it.

Structures are often created in variables, for convenience and readability reasons. Since variables begin with a size of 0, it is nearly always necessary to expand it to the size of the structure. For this purpose, a function known as `VarSetCapacity()` may be used:

{% highlight ahk linenos %}; any AutoHotkey version
VarSetCapacity(RectVariable,16)
{% endhighlight %}

The above code would set the size of a variable to 16 bytes. This allows `Variable` to hold a Rect structure, as such a structure is also 16 bytes.

There is something to be aware of when setting the capacity of a variable: the memory allocated to the variable is not cleared. For example, if a Rect structure is supposed to contain 0 as the value of all members when created, it may not be so if the variable was not explicitly set to 0. That is, there may be unused data present in the memory within the variable. This can be mitigated by having VarSetCapacity set all the bytes in the variable to a certain number, usually 0:

{% highlight ahk linenos %}; any AutoHotkey version
VarSetCapacity(RectVariable,16,0)
{% endhighlight %}

The last parameter, `FillByte`, specifies the value to fill all bytes in the variable with. In this case, the variable that will contain our Rect structure has been initialized to have all members set to 0.

### member types
AutoHotkey provides a small set of types that map to just about any type one would need. Mapping the types of a structure with those built into AutoHotkey can sometimes be a challenge, however. Sometimes, it is simply something one needs to memorize; DWORD becomes `UInt`, LONG becomes `Int`, HANDLE becomes `UPtr`, etc. The mapping is not random, however: they are based on their sizes and certain other properties such as signedness and whether they are the same size across 32-bit and 64-bit operating systems.

It is helpful to memorize the simplest ones such as DWORD mapping to `UInt`, and look up any others that are unfamiliar. It is not feasible to memorize them all, but a [good reference](http://msdn.microsoft.com/en-us/library/aa383751.aspx) will be very useful when working with unknown types. A list of commonly used type mappings follow:

* PVOID becomes `UPtr`.
* DWORD becomes `UInt`.
* INT becomes `Int`.
* CHAR becomes `Char`.
* SHORT becomes `Short`.
* LONG becomes `Int`.
* LPCTSTR becomes `Str`.
* FLOAT becomes `Float`.

Mapping the type HCURSOR to an AutoHotkey type:

1. The reference page contains the following in the HCURSOR row: "typedef HICON HCURSOR;". This means that HCURSOR is a form of the type HICON.
2. The reference page contains the following in the HICON row: "typedef HANDLE HICON;". This means that HICON is a form of the type HANDLE.
3. The reference page contains the following in the HANDLE row: "typedef PVOID HANDLE;". This means that HANDLE is a form of the type PVOID.
4. PVOID is known to map to the AutoHotkey type `UPtr`.

When accessing something with the type HCURSOR, use the AutoHotkey type `UPtr`.

#### Note:
It should be noted that `UPtr` and certain other types exist only in AutoHotkey\_L or similarly recent versions, as the older versions did not have the need for a flexible pointer type. The following workaround can be used in these cases:

{% highlight ahk linenos %}; any AutoHotkey version
PointerType := A_PtrSize ? "UPtr" : "UInt"
{% endhighlight %}

A list of available AutoHotkey types is available in the documentation on the [DllCall page](http://www.autohotkey.com/docs/commands/DllCall.htm#types) ([AutoHotkey\_L](http://www.autohotkey.net/~Lexikos/AutoHotkey_L/docs/commands/DllCall.htm#types)).

## setting members
Members of a structure can be set using the `NumPut()` function:

{% highlight ahk linenos %}; any AutoHotkey version
NumPut(5000,RectVariable,12,"UInt")
{% endhighlight %}

Here, we have set the member at offset 12 (which was "bottom", as mentioned earlier) to the value 5000. Since we know that LONG maps to `UInt`, we have used `UInt` as the type.

In other words, the Rect structure's "bottom" member was set to 5000.

## retrieving members

Members of a structure can be retrieved using the `NumGet()` function:

{% highlight ahk linenos %}; any AutoHotkey version
BottomValue := NumGet(RectVariable,12,"UInt")
{% endhighlight %}

Here, we have retrieved the member at offset 12 (which was "bottom", as mentioned earlier), and stored it in the variable `BottomValue`. Since we know that LONG maps to `UInt`, we have used `UInt` as the type.

In other words, the Rect structure's "bottom" member was retrieved and stored in a variable.

## other considerations
### nested structures
Structures can be treated as types themselves; for example, the Rect structure may be considered a type named Rect that occupies 16 bytes of memory. This means it is possible to nest a structure within another structure. When doing so, the nested structure is considered a member of the containing structure. When calculating offsets, one may simply add the offset for the member containing the nested structure to the offset of the member desired within the nested structure. For example, assume a structure defined as follows:

    typedef struct _RECTANGLES {
      RECT first;
      RECT second;
      RECT third;
    } RECTANGLES, *PRECTANGLES;

To access the "bottom" member of the "second" member of the structure RECTANGLE:

1. Find the offset for "second". In this case, the sum of the sizes of the members before it ("first") is 16, so "second" is located at an offset of 16 bytes from the beginning of RECTANGLES
2. Find the offset for "bottom" within "second". In this case, the sum of the sizes of the members before it ("top", "left", and "right") is 12, so "bottom" is located at an offset of 12 bytes from the beginning of the Rect "second"
3. The sum of the two offsets is 16+12, or 28.

Accessing the "bottom" member can be done by using `NumPut()` or `NumGet()` with the RECTANGLES structure, with the type LONG and the offset 28.

### arrays
Arrays are a form of structure, in that they store members together in memory as structured data. However, arrays only have one type of member, and they can have varying numbers of them. For example, an array of 256 INT values is a structure containing 256 members, all with the type INT. The size of such an array is 256\*4, or 1024 bytes.

Strings in structures are also arrays; usually they are arrays with values of type CHAR, and can be accessed with the same method as other arrays. However, there are also functions to deal with strings in memory: `StrPut()` and `StrGet()`. Demonstration follows:

{% highlight ahk linenos %}; AutoHotkey_L or similarly recent versions
ResultString := StrGet(&StructureContainingAString + OffsetOfStringMember)
{% endhighlight %}

These functions retrieve the entire array and treat it as though it were a string, converting it into a string AutoHotkey can use normally.

Other features of the two include limiting of the string length and converting between codepages.

It should be noted that `StrPut()` and `StrGet()` exist only on AutoHotkey\_L or similarly recent versions, but the following workaround can be used in these cases:

{% highlight ahk linenos %}; any AutoHotkey version
DllCall("MulDiv","UInt",TheAddressOfTheString,"UInt",1,"UInt",1,"Str")
{% endhighlight %}

The two functions have also been backported to older versions of AutoHotkey, and are available as [libraries](http://www.autohotkey.com/forum/topic59738.html).

### structure library
The AutoHotkey library [Struct](http://www.autohotkey.com/forum/topic59581.html), by HotkeyIt, allows simple and intuitive creation of structures without difficult offset or type calculations. Given an initial structure description, it creates an object that allows access of structure members with the built-in object access syntax. Recommended if there are a lot of structs to manage and the performance drop is acceptable.

## summary
* Structures are sections of memory filled with structured data.
* Members are specific independant parts in the data.
* Members are accessed by their type and offset.
* Each type almost always needs to be mapped to an AutoHotkey built-in type to be used.
* AutoHotkey functions that are useful when working with structures are `VarSetCapacity()`, `NumPut()`, and `NumGet()`.

## example
As an example, we're calling the [MessageBoxIndirect](http://msdn.microsoft.com/en-us/library/windows/desktop/ms645511.aspx) function. It allows a even more customized MessageBox than AutoHotkey or the function we got to know in the last chapter.

The only parameter the MessageBoxIndirect function accepts is a pointer to a [MSGBOXPARAMS](http://msdn.microsoft.com/en-us/library/windows/desktop/ms645402.aspx) structure. We're going to fill it in and pass it to the function.

**Note:** As with the example in the previous chapter, this code will not work on non-Windows systems.

{% highlight ahk linenos %}; (theoretically) any AutoHotkey version.
; As of 25.11.11, this does not work for IronAHK.

; ============= config =============
IronAHK := false ; set to true if you're using IronAHK.
; ==================================

; ensure AutoHotkey classic / IronAHK compatibility:
ptr_size := A_PtrSize ? A_PtrSize : 4
ptr := A_PtrSize ? "UPtr" : "UInt"

; define flags:
MB_ABORTRETRYIGNORE := 0x00000002
MB_USERICON := 0x00000080

; set the button we will use + indicate we will provide a custom icon:
flags := MB_ABORTRETRYIGNORE | MB_USERICON 

; set the text that will be shown:
text := "This box is produced with a DllCall() to the MessageBoxIndirect function, "
		. "passing a MSGBOXPARAMS structure.`n`n"
		. "This allows you to set a custom icon and more."

; set the title that will be used:
caption := "ahkbook example"

; get a handle to the running AutoHotkey.exe: we will use an icon from inside it
hModule := DllCall("GetModuleHandle")

; choose the icon id to use (IronAHK has a different one):
icon := IronAHK ? 32512 : 159

; calculate struct size:
struct_size := 4*3 + ptr_size*7 
; cbSize, dwStyle and dwLanguageId are 4 bytes, others depend on system pointer size

VarSetCapacity(params, struct_size, 0) ; initialize structure

; filling in structure members we need:

; "The structure size, in bytes."
NumPut(struct_size,	params,	00+0*ptr_size,	"UInt")

; "A handle to the module that contains the icon resource identified by the lpszIcon member... "
NumPut(hModule,	params,	04+1*ptr_size,	ptr)

; "A null-terminated string that contains the message to be displayed."
NumPut(&text,	params,	04+2*ptr_size,	ptr)

; "A null-terminated string that contains the message box title."
NumPut(&caption,	params,	04+3*ptr_size,	ptr)

; "The contents and behavior of the dialog box."
NumPut(flags,	params,	04+4*ptr_size,	"UInt")

; "Identifies an icon resource."
NumPut(icon,	params,	08+4*ptr_size,	"UPtr")


; call the function and pass a pointer to the structure:
DllCall("MessageBoxIndirect", ptr, &params)
{% endhighlight %}
Running this you should get something like this:
![screenshot](images/structures-1.png)
The icon may differ depending on your AutoHotkey version.
