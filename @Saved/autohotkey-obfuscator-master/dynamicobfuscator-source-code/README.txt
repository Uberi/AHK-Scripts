Dynamic Obfuscator - Obfuscator for Autohotkey, written in Autohotkey
http://dynamicobfuscator.com

Authored by: David Malia, Augusta, ME USA 
			 http://davidmalia.com

Copyright David Malia 2011

*open source*

This program can take an autohotkey script and transform it into a script that works the same but the function names, parameters, labels, and variables are replaced with obfuscated versions of those. 

This program is different from other obfuscators because it can automatically use the dynamic variable creation abilities of autohotkey to create Dynamic Obfuscation.  I use this term to refer to an obfuscated object name that is dynamically constructed out of object name fragments at run time and these fragments are themselves obfuscated. This allows the extra securing of code and the ability to break sections of code.

To run the Dynamic Obfuscator just launch the dynamicobfuscater.ahk file found in the same directory as this file. 

The obfuscator is designed so that you will still be able to continue running and testing your code in it's unobfuscated state as you move towards more and more obfuscation and as you add more features or updates to your autohotkey script.

1) You must add some mandatory obfuscator command comment tags to your source code. see documentation manual.

2) Run the obfuscator and choose 'Create Translations Map'. This function will crunch through your source code files and create an output translations map file. That file will contain commands to create obfuscations for objects like function names, parameter names, variable names, and label names. It can also contain commands that will change the obfuscation encoding defaults for objects. It can also have commands that will add sections of code to a class and make that class 'secure' allowing you to later on 'break' that whole section of code by using an obfuscator DUMP command.

Choose include map file:
an input file that contains a list of all the source code files in your project. no modification of the source code files will be made.

Output Translations Map file:
will create an output file that will have translation 'commands' in it. ok to use a relative file name here. if no path is used it will use the same path as the field above.

Sticky fields:
The fields in which you can select or enter file names in the Dynamic Obfuscator interface are 'sticky' in that once you set a file name then that file name will keep being prefilled into that field even on restarts of the obfuscator. The obfuscator stores the last files used by it here:

A_AppData . "\dynamicobfuscator\lastobffiles.txt"

3) Run the obfuscate source code function. This will use 3 files, the 'include map' file, the 'translations map' file, and the output obfuscated autohotkey file name which should of course end in ahk. At the top of this window are a few checkboxes to remove all comments, blank lines, tabs, and to randomize the order of program segments. It's best to first test your obfuscated output code without selecting any of these checkboxes and then start selecting them during obfuscation.

4) Test output obfuscated code. it will be all one big autohotkey file.