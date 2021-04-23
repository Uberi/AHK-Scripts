DEMONSTRATION OF HOW ihidestr() WORKS

the scripts in this folder demonstrate the process of obfuscating
and unobfuscating sensitive literal strings in your autohotkey
source code. you can use copies of these scripts to develop
and test your own personal hidestr routines to use with your own
copy of Dynamic Ofuscator.

Run 'hidestr_ENCODER_program.ahk' found in this folder and it
will read the 'INPUT_ahkprogram_with_hidestr.ahk' autohotkey
script file into a string and then find and replace any
ihidestr()'s it finds in the autoexecture section. if it finds
them then it will convert any literal text it finds passed as a
parameter to the function into obfuscated literal text and it
will convert the function name from ihidestr() to
decode_ihidestr(). It will then write the altered script to a
file named 'OUTPUT_ahkprogram_with_hidestr.ahk'.

the 'hidestr_ENCODER_program.ahk' program has a copy of some of the code that is in the Dynamic Obfuscator program including the 'replaceHIDESTRcalls()' function and the encode_ihidestr()'
function. the first function is the the one from the obfuscator
that finds the ihidestr() calls and the second is the function that will actually replace any literal string found in that function
with an obfuscated literal string. 

the 'INPUT_ahkprogram_with_hidestr.ahk' script surrounds some
literal strings in its autoexecute section with the ihidestr()
function. the 'hidestr_ENCODER_program' will convert those to
obfuscated literal strings. the 'INPUT_ahkprogram_with_hidestr'
script also includes the ihidestr() dummy function and the 
decode_ihidestr() function that actually decodes and returns
the obfuscated literal string. this reflects what you must
include in your own source files in order to use ihidestr()
with the projects you are obfuscating.

After you have run the 'hidestr_ENCODER_program.ahk', open its
output, the 'OUTPUT_ahkprogram_with_hidestr.ahk' script in your
text editor to see how the literal strings in the autoexecute section were obfuscated. Now run the file and review the text boxes that pop up in order to verify that the decoding of the obfuscated literal strings is being done correctly.

there is one extra thing that the obfuscator does that this
example doesn't do. this example will find ihidestr() functions
in your source code and convert then to decode_ihidestr()
functions but will not obfuscate the decode_ihidestr() function call itself. dynamic obfuscator will also obfuscate all occurances
of decode_ihidestr() that are found in your source code including
its function definition section and calls to decode_ihidestr()
that were converted from ihidestr() by the obfuscator.