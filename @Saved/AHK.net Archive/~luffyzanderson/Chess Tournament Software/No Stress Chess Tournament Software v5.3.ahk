/*© Copyright 2010 Luffy Z. Anderson, No Stress Chess
"the devil's never a maker.  the less that you give, you're a taker"  -  black sabbath, heavend and hell  -  1980
Use of this script is totally free for anyone and everyone.  Anyone and everyone has my permission to share it, change it, and/or sell it for now and forever with only 2 small
stipulations which are:
1.  if you change this you can do whatever you want but you have to put the following message in the main title bar: "Original Ideas and Code by: Luffy Z. Anderson of No Stress Chess"
2.  If anyone sells this or changes this and sells that then they must donate to me at least 1% of the gross profit from those sales but no more than $1,000 ever.
I claim no right to any royalties from any of my intellectual property 10 years after I create it.
Alrighty then, I hope that sounds good and fair and I hope this helps a lot of people have fun playing chess.  My email's luffyzanderson@yahoo.com and i'd love to hear from anyone reading this.
Take it easy,
-luffy

#################################################################################################################
##################################################################################################################
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
currently working on:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
user display and user imput.  This works great if you don't want to play in the tournament and it has less than 50 players.  otherwise, it takes too long to enter in player's info
and results.  since i want to be able to play too, i want to be able to enter in players and results much faster with an easy to use user imput display.
My number 1 priority right now is definately to give this software the ability to take player's info and round results from a user interface fast since that's currently taking forever! 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
known bugs:
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
there still might occasionally be problems with window activation/detection.  That's probably going to be an ongoing issue for a while.  i reduced the chances of this problem
occuring by 99.99% but had to considerably reduce the speed at which certificates are generated.  i haven't had a problem with it in the last 40 uses approximately.  if i can
create or utilize an existing autohotkey text script that allows different fonts and type sizes to produce nice looking text documents like microsoft word does then i won't need
to use find and replace anymore but can just create the files when needed instantly.

when generating certificates it's possible that double clicking won't work and the button will need to be utilized. it's also possible that the button will stop working as well.
i'm not sure why this is yet.  i did notice that the script used to generate certificates takes a lot of cpu power.  after just initial testing it seems that shutting down or pausing
other programs can help.  it works fine on my computer when i do that so far.  though i would like to make it so that it doesn't take so much cpu processing power for people
who have less powerful computers.  if i make the player number detection process simpler and require checking less files, lines, and fields it might help.  it could be something else
causing the bugs though.

If a player has played someone more than 2 times in a tournament they should not get a bonus but i haven't changed that yet.

it's showing regular and quick ratings on the certificates regardles of whether or not the game time allows both to be affected by results.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
what I'll work on next:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ability to set and change the default for files to use for both stats and certificate generation as well as what to save the names of the certificates as.

ability to generate certificates for all players at once.  it used to do this but it was slow and buggy.

modify the formulas used for estimated tournament performance ratings and estimated post tournament ratings to make them more accurate.  the wereg is almost definately off.  i had a 2260 beating a 2220
and the we was still at 1 for that round i think.  it should have been more like .53 i think.

add a round pairing system.

add the ability to keep track of multiple sections.

add the ability to get needed information from dbase files (dbf files) and to generate them for submission to uscf

helpful floating text when the user's cursor is hovering over something.

it's estimating rating changes when the game time shouldn't allow it.  that's okay for now since i'm using it for dual rated tournaments only at present.  but it would be nice
to have the option to have it not do that later.

i'd like it to have its own built in text software so it won't need to use microsoft word.  it would be nice to not have to use find and replace with window activation and
also, it would be easier for me to share this if it didn't have the stipulation that you need microsoft word to use it.  and thus, it might help chess become more popular
and make more people happy.
==================================================================================================================================================================================================
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
for anyone who's 
to examine this code here's some helpful stuff to know before getting started:
-------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
there are a lot of message boxes that look like this: "msgbox,%" or "msgbox" that have been commented out.  sometimes they have a line or more below them that are part of the
message as well.  if you ever want to check a specific part of this script then you can remove the semicolons to uncomment them and see the message boxes.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1200 is substituted for any unrated values for now.  if i can get an easy way to input date of birth and previous games played then i can get that accurate to uscf values. 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------
abbreviations (some of these may be used throughout this script and others may only be used in 1 specific part or certain sections.  
also, i've been in a hurry and haven't updated this list in a while):
--------------------------------------------------------------------------------------------------------------------------------------
c = color
cc = current certificate
cdb = current database
cgp = certificate generation player
cp = current player
ct = current tournament
ctl = current tournament lines (of the file itself)
fname = first name
gt = game time
i = iteration (current number of times a loop has executed including the current execution)
lname = last name
num = number
opp = opponent
p = player
pointstot = points total
pt = previous tournament
r = round
rat = rating
reg = regular
res = result
scp = seed check player
scpqr = seed check player quick rating
scprr = seed check player regular rating
sscdb = string split current database
ssct = string split current tournament
tg = total game
tp = total players;  tr = total rounds
we = winning expectancy
*/

coordmode, mouse, screen
SetTitleMatchMode, 2
SetTitleMatchMode, slow
SetBatchLines -1
#UseHook
thread, notimers, true
; Process, Priority,, High

abouttext = I created this software in mainly because I wanted:`n1.  Something that would allow me to print out achievement certificates with cool stats.`n2.  Something that could pair large open sections fairly, giving each player the best chance to have fun, learn, and be challenged.`n3.  Something that would be easy enough to learn how to use so that anyone with half a brain could learn to use it easily.`n4.  Because I thought it was a crying shame that there wasn't any good, free chess tournament software out there.`n`nI'm not saying this is "good" yet, I definately like some of things it does, and the price is right, but I still think it needs a lot of work.  For instance, just a few of the things I think I can make a whole lot better or add in the near future:`n1.  I think the database and tournament file management can easily be made much more managable but it just takes a lot of time to integrate new features like list sorting and multiple line selection.`n2
.  I think it would be very easy to add a clock feature to countdown 'till next round starts.`n3.  I think it's going to be very easy to write the autopairing, especially the No Stress Pairing, Round Robin, and Random.  The swiss's will probably be a little tougher but shouldn't be too hard.  But again, that's probably going to take considerable time.`n5.  Probably the first main thing I after should do next after writing the autopairing code is give it the ability to run multiple sections since the longer I wait to do that the more I'll want to kill myself once I actually start doing it
! `n`nUntil I find a good ASCII to DBF/DBF to ASCII convertor or write my own this can't work with Dbase files.  Sorry, I'd love to add that feature along with a million other things but it's just one of those things that's going to take some time to integrate.  I will add that and almost every other concievable nice feature possible eventually or die trying though. `n`nThis software was created entirely from scratch with a free programming language called autohotkey, www.autohotkey.com.  In my opinion that's a great language becasue it's free, reliable, tested, powerful, based off of C, and it has a great help file and forums with a lot of nice, helpful, and knowledgable programmers.  If you want to move a mountain with a computer, I'd say it's not a bad place to start.
instructionstext = Hey, what's up?  Thanx for trying out my software.  I hope you like it!`n`nI think that it should be able to do install itself and do everything on its own and be fairly easy to learn how to use.  I'd like streamline things more, fungshway it more, add more and improve existing boxes and text to help the user understand and learn how it works easier and faster but it just takes time.  Making this more user friendly is a top goal for me but it also cuts into the time I spend on other things like adding and improving a lot of other important features.`n`nI'd appreciate it if you, the user would please let me know if there's anything that you'd like to bring to my attention at: luffyzanderson@yahoo.com`n`nI'd especially appreciate knowing if anything fails to work or works incorrectly.  Any details that might help me pinpoint the problem would be nice too.
whythisisfreetext1 = "The devil is never a maker.  The less that you give, you're a taker."`n`n -  Black Sabbath, Heaven and Hell  -  1980`n`n`n`n"  In General:  Copyright in a work created on or after January 1, 1978, subsists from its creation and, except as provided by the following subsections, endures for a term consisting of the life of the author and 70 years after the author's death.  "`n`n - www.copyright.gov  -  2010.
whythisisfreetext2 = I like to look at things with different prespectives from time to time.  Maybe from time to time I connect dots that shouldn't be connected.  But when I think about the meaning of those 2 quotes I can't help but to think that there might be a connection to what they're saying.  The first quote, a very controversial one, seems to make at least a little bit of sense to me, and I can't help but to wonder how much wisdom, if any, there is to it.  The second quote seems to be describing what seem to be some very well intended laws which mean that if I was to copywrite this software (don't worry, I won't) and I lived to be 100 years old it would remain copywriten until the year 2149 (I was born 1/29/1979)
. `n`n`n`nIf I may be so bold I'd like to ask you to please take a second to consider a few questions
: `n`n1.  After reading those 2 quotes does anything seem odd to you
?  `n2.  Do you know about what percentage of the Roman population were slaves when it collapsed
? `n3.  Do you know what the road to Hell is paved with
? `n`n`n`nThis software (full version, no tricks) will always be available 100 percent free including all future versions.  In addition, as I work on improving it I'm also making the source code of previous versions available for free
.  I don't expect any donations for making and sharing this but I would not say "no" to any, and I would appreciate it.  I'm in a financial comma right now, and I don't have a bank account so if anyone wants to help support me financially they'd have to send a check to my alter ego, Josh Brackelsberg, at 1204 Aquarius, Fruita CO, 81521.  But I don't want anyone to feel bad 'cause I don't really expect much if anything for doing this and I know this software needs a lot of work and isn't very good (yet).
;---------------------------------------------------------------------------------------------------
;  initializing global variables (variables that need to be assigned before anything else)
;---------------------------------------------------------------------------------------------------
adbf:="None"
atf:="None"
cc := "None"
cdb := "C:\Program Files\No Stress Chess\Player Databases\Current Database.txt"
chatcount := 0
ct := "C:\Program Files\No Stress Chess\Tournaments\Current Tournament.txt"
currentr:=1
currentupdisplay:=1
currentboarddisplay:=1
opponent_error_message_num:=0
board_error_message_num:=0
color_error_message_num:=0
numresult_error_message_num:=0
pswapping=0
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
gosub start
; gosub tt		; (tool tip)
gosub addssetup	; (adds setup)
gosub ssdb	; (string split databbase)
gosub sst	; (string split tournament)
gosub ressetup	; (result setup)
gosub prdc	; (player round display compiling)
gosub uprdc	; (unpaired player ournd display compiling)
gosub wprdc	; (white player round display compiling)
gosub bprdc	; (black player round display compiling)
gosub playerstats
goto refreshctflb	; (certificate file listbox)

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;==================================================================================================================================================================================================
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;	Gui initialization
;------------------------------------------------------------------------------------------------------------------
;	this section sets up the user interface
;------------------------------------------------------------------------------------------------------------------
start:
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;  menu bar
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Gui, 1:Default
; Create the sub-menus for the menu bar:
Menu, FileMenu, Add, E&xit, FileExit
Menu, ChatMenu, Add, &SayHi, ChatSayHi
Menu, HelpMenu, Add, &About, HelpAbout
Menu, HelpMenu, Add, &Instructions, HelpInstructions
Menu, HelpMenu, Add, &WhyThisIsFree, HelpWhyThisIsFree
; Create the menu bar by attaching the sub-menus to it:
Menu, MainMenu, Add, &File, :FileMenu
Menu, MainMenu, Add, &Chat, :ChatMenu
Menu, MainMenu, Add, &Help, :HelpMenu
Gui,1:Menu, MainMenu	; Attach the menu bar to the window:
Gui,1:Color, FFFF00,	; Yellow
Gui,1: Show, center h700 w1500, No Stress Chess Tournament Software and Certificate Generator Created by Luffy Z. Anderson
;  gui,1:+AlwaysOnTop	;  this is nice but when a message box or new gui window comes up it covers it up, i'd have to toggle it off quite a bit.  too much bother for now.  maybe later i'll add this feature.
gui,1:+resize
gui,1:maximize
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Additional gui windows:
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; gui 11
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; variables handled:
;----------------------------------------------------------
;  gui11text = message after selecting a database file
;----------------------------------------------------------
Gui,11:Color, FFFF00,	; Yellow
Gui,11:Add, Text, w490 vgui11text, You've selected the following database file:`n`n %dbflb% `n`nWhat would you like to do?
Gui,11:Add, Button, Default, Load Database File
Gui,11:Add, Button,, Delete Database File
Gui,11:Add, Button,, Cancel

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; gui 12
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; variables handled:
;----------------------------------------------------------
;  gui12text = message after selecting a tournament file
;----------------------------------------------------------
Gui,12:Color, FFFF00,	; Yellow
Gui,12:Add, Text, w490 vgui12text, You've selected the following tournament file:`n`n %dbflb% `n`nWhat would you like to do?
Gui,12:Add, Button, Default, Load Tournament File
Gui,12:Add, Button,, Delete Tournament File
Gui,12:Add, Button,, Cancel

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; gui 21
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; variables handled:
;------------------------------
;  gui2text = message after selecting a database player
;----------------------------------------------------------
Gui,21:Color, FFFF00,	; Yellow
Gui,21:Add, Text, w375 vgui2text, You've selected the following player from the actve database:`n`n %dblb% `n`nWhat would you like to do?
Gui,21:Add, Button,, Add Player to the Tournament
Gui,21:Add, Button,, Delete Player from the Database
Gui,21:Add, Button,, Cancel
Gui,21:add, text, x450 y15, Player first name
gui,21: add, edit, x450 y30 vfname w200,
Gui,21: add, text, x450 y60, Player last name
gui,21:add, edit, vlname w200 x450 y75,
Gui,21: add, text, x450 y105, Player uscf #
gui,21: add, edit, vuscfnum w200 x450 y120,
gui,21: add, text, x450 y150, Player regular rating
gui,21: add, edit, vregrat w200  x450 y165,
gui,21: add, text, x450 y195, Player quick rating
gui,21: add, edit, vquickrat w200 x450 y210,
gui,21: add, text, x450 y240, Player previous regular games played (any number over 49 games is treated the same)
gui,21: add, edit, vregN w200 x450 y255,
gui,21: add, text, x450 y285, Player previous quick games played (any number over 49 games is treated the same)
gui,21: add, edit, vquickN w200 x450 y300,
gui,21:Add, Button, x450 y330, Modify Player Information in the Database

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; gui 22
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Gui,22:Color, FFFF00,	; Yellow
Gui,22:add, Text, w375 vgui22text, What would you like to do with this new baby of ours:`n`n %x% `n`n???
Gui,22:add, Button,, Add New Player to the Active Database
Gui,22:add, Button,, Add New Player to the Active Tournament
Gui,22:add, Button,, Add New Player to both the Active Database and the Active Tournament
Gui,22:add, Button,, Cancel

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; gui 23
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Gui,23:Color, FFFF00,	; Yellow
Gui,23:add, Text, w375 vgui23text, You've selected the following player from the actve tournament:`n`n %ctlb% `n`nWhat would you like to do?
Gui,23:add, Button,, Add Player to the Database
Gui,23:add, Button,, Remove Player from the Tournament
Gui,23:add, Button,, Cancel
Gui,23:add, text, x450 y15, Player first name
gui,23:add, edit, x450 y30 vtfname w200,
Gui,23:add, text, x450 y60, Player last name
gui,23:add, edit, x450 y75 vtlname w200,
Gui,23:add, text, x450 y105, Player uscf #
gui,23:add, edit, x450 y120 vtuscfnum w200,
gui,23:add, text, x450 y150, Player regular rating
gui,23:add, edit, x450 y165 vtregrat w200,
gui,23:add, text, x450 y195, Player quick rating
gui,23:add, edit, x450 y210 vtquickrat w200,
gui,23:add, text, x450 y240, Player previous regular games played (any number over 49 games is treated the same)
gui,23:add, edit, x450 y255 vtregN w200,
gui,23:add, text, x450 y285, Player previous quick games played (any number over 49 games is treated the same)
gui,23:add, edit, x450 y300 vtquickN w200,
gui,23:add, Button, x450 y330, Modify Player Information in the Tournament

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; gui 41
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; variables handled:
;----------------------------------------------------------
;  gui11text = message after selecting a certificate template
;----------------------------------------------------------
Gui,41:Color, FFFF00,	; Yellow
Gui,41:Add, Text, w490 vgui41text, You've selected the following certificate template file:`n`n %ctflb% `n`nWhat would you like to do?
Gui,41:Add, Button, Default, Load Certificate Template
Gui,41:Add, Button,, View the Certificate Template for Editing or Printing
Gui,41:Add, Button,, Delete Certificate Template
Gui,41:Add, Button,, Cancel
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; gui 99
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Gui,99:color, FFFF00	; Yellow
gui,99:add, text, w490, %abouttext%

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; gui 98
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Gui,98:color, FFFF00	; Yellow
gui,98:add, text, w490, %instructionstext%

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; gui 97
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
gui,97:color, FFFF00	; Yellow
gui,97:add, text, w1170 x15 y35 center, %whythisisfreetext1%
gui,97:add, text, w1170 x15 y200, %whythisisfreetext2%

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;  tab section  -  tab (1)  first line creates the tab and then the first tab is altered immediately after that
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
gui, add, Tab2, h695 w1095, (1)  Database and Tournament Files|(2)  Database and Tournament Data|(3)  Round Data|(4)  Tournament Standings |(5)  Generate Certificates
;  Gui, Add, Tab2, h700 w1605, (1)  a|(2)  b|(3)  c|(4)  d  this makes a second set of tabs on the bottom of the window.  very cool but i don't need it yet.

gui, add, text,, I can help you create and manage an almost unlimitted number of tournaments and databases with almost unlimited players.`nI tried to organize all my boxes, lists, and buttons in as fundamentally simple of a way as I could think of to try to help make it as easy as possible to learn and remember how to use me.`nI utilize permanent, hidden, independent data files so that your data will never be lost unless you, yourself save over it or delete it (unless there's a bug in my programming, in which case it's Luffy's fault).`nIf you're new to running tournaments I recommend making 1 new database file and 1 new tournament file first, then clicking on the 2nd tab on the top of me and going from there.  :)

gui,1:add,edit,	x15	y150	h20	w300	vnewdbf,
gui,1:add,button,	x320	y150	h20 vCreateNewDatabaseFile, &Create New Database File
gui,1:add,listBox,	x15	y175	r10	w300	vdbflb	gdbflb
gui,1:add,text,	x320	y195	h20, Total Database Files:
gui,1:add,text,	x320	y215	h20	w200	vguitexttotdbf,
gui,1:add,text,	x15	y315	h20, Active Database:
gui,1:add,text,	x100	y315	h40	w200	vguitextadbf,

Gui, Add, ComboBox,	x500	y150	vsavedbflb	r10	w300	gsavedbflb 
Gui, Add, Button, x805 y150 h20 vSaveDatabaseFile, &Save Database File

gui,1:add,edit,	x15	y380	h20	w300	vnewtf,
gui,1:add,button,	x320	y380	h20 vCreateNewTournamentFile, &Create New Tournament File
Gui,1:add,listBox,	x15	y405	r10	w300	vtflb	gtflb		
gui,1:add,text,	x320	y425	h20, Total Tournament Files:
gui,1:add,text,	x320	y445	h20	w200	vguitexttottf,
gui,1:add,text,	x15	y545	h20, Active Tournament:
gui,1:add,text,	x110	y545	h40	w200	vguitextatf,

gui,1:add,comboBox, x500 y380 vsavetflb gsavetflb w300 r10
gui,1:add,button, x805 y380 h20 vSaveTournamentFile, &Save Tournament File

gui,1:add,text,		x1115	y0		w280	,You can click on a recommendation for more information.`nI try to offer the most helpful recommendations I can.
gui,1:add,groupBox,	x1105	y30	h300	w300	center	,Local Chess Clubs:
gui,1:add,text,		x1115	y45	h45	w280	,If you're looking for a place to have fun playing chess or to get the word out about your own chess club's activities I think contacting these chess clubs might be a good idea: 
gui,1:add,button,		x1135	y90	h20	w20	gpreviousregion	,<
gui,1:add,edit,		x1155	y90	h20	w200	readonly	center	vguitextregion	,
gui,1:add,button,		x1355	y90	h20	w20	gnextregion	,>
gui,1:add,button,		x1115	y265	h20	gpreviouscca	,<-- previous club
gui,1:add,text,		x1115	y115	h150	w280	center	vguitextcca	gccaclick,
gui,1:add,button,		x1315	y265	h20	gnextcca		,next club -->
gui,1:add,text,		x1115	y285		w280	center	,______________________________________________
gui,1:add,text,		x1115	y300	h25	w280	,If you have a club you'd like me to add to my list you can let Luffy know at: luffyzanderson@yahoo.com.

gui,1:add,groupBox,	x1105	y340	h300	w300	,Random Stuff:
gui,1:add,text,		x1115	y355	h45	w280	,Just some random stuff that I think might be the best out there.  I hope this helps!  hehe!  :)
gui,1:add,button,		x1135	y400	h20	w20	gpreviousstuffgroup	,<
gui,1:add,edit,		x1155	y400	h20	w200	readonly	center	vguitextstuffgroup	,
gui,1:add,button,		x1355	y400	h20	w20	gnextstuffgroup	,>
gui,1:add,button,		x1115	y575	h20	gpreviousstuff	,<-- previous stuff
gui,1:add,text,		x1115	y425	h150	w280	center	vguitextstuff	gstuffclick,
gui,1:add,button,		x1315	y575	h20	gnextstuff	,next stuff -->
gui,1:add,text,		x1115	y595		w280	center	,______________________________________________
gui,1:add,text,		x1115	y610	h25	w280	,If you have a "Random Stuff" you'd like me to add to my list you can let Luffy know at: luffyzanderson@yahoo.com.
;---------------------------------------------------------------------------------------------------------------------
;  tab (2)  -  Database and Tournament Data
;---------------------------------------------------------------------------------------------------------------------
Gui,1:Tab, 2
Gui,1:add, text,, Have fun with these easy to create and manage player lists!  Isn't technology great?  :)
Gui,1:add, text, x15 y85, You can select a player from the active database to modify, delete, or add to the active tournament.
Gui,1:add, ListBox, vdblb gdblb x15 y100 w500 r10 
Gui,1:add, Text, x540 y105 w175 vtotdbptext,

gui,1:add, text, x15 y260, Player first name
gui,1:add, edit, x15 y275 vxfname w100,

gui,1:add, text, x120 y260, Player last name
gui,1:add, edit, x120 y275 vxlname w100,

gui,1:add, text, x225 y260, Player uscf #
gui,1:add, edit, x225 y275 vxuscfnum w100,

gui,1:add, text, x330 y260, Player regular rating
gui,1:add, edit, x330 y275 vxregrat w100,

gui,1:add, text, x435 y260, Player quick rating
gui,1:add, edit, x435 y275 vxquickrat w100,

gui,1:add, text, x540 y260, Prev. regular games
gui,1:add, edit, x540 y275 vxNreg w100,

gui,1:add, text, x645 y260, Prev. quick games
gui,1:add, edit, x645 y275 vxNquick w100,

gui,1:add, button, x750 y267, &Add New Player


Gui,1:add, text, x15 y330, You can select a player from the active tournament to modify, delete, or add to the active database.
Gui,1:add, ListBox, vtlb gtlb x15 y345 w500 r10
Gui,1:add, Text, x540 y350 w175 vtottptext,
Gui, Add, Text, x540 y370, Game Time in Minutes (Must be 1 or greater):
Gui, Add, Edit, x755 y370 h15 w50 vtempgt,
Gui, Add, Button, x810 y367 h20, &Reset Game Time
gui, add, text, x540 y390 vgttext gtempgt, Tournament Game Time is Currently set to: xxxxxxxxx minutes

gui,1:add,text,		x1115	y0		w280	,You can click on a recommendation for more information.`nI try to offer the most helpful recommendations I can.
gui,1:add,groupBox,	x1105	y30	h300	w300	center	,Local Chess Clubs:
gui,1:add,text,		x1115	y45	h45	w280	,If you're looking for a place to have fun playing chess or to get the word out about your own chess club's activities I think contacting these chess clubs might be a good idea: 
gui,1:add,button,		x1135	y90	h20	w20	gpreviousregion	,<
gui,1:add,edit,		x1155	y90	h20	w200	readonly	center	vguitextregion2,
gui,1:add,button,		x1355	y90	h20	w20	gnextregion	,>
gui,1:add,button,		x1115	y265	h20	gpreviouscca	,<-- previous club
gui,1:add,text,		x1115	y115	h150	w280	center	vguitextcca2	gccaclick,
gui,1:add,button,		x1315	y265	h20	gnextcca		,next club -->
gui,1:add,text,		x1115	y285		w280	center	,______________________________________________
gui,1:add,text,		x1115	y300	h25	w280	,If you have a club you'd like me to add to my list you can let Luffy know at: luffyzanderson@yahoo.com.

gui,1:add,groupBox,	x1105	y340	h300	w300	,Random Stuff:
gui,1:add,text,		x1115	y355	h45	w280	,Just some random stuff that I think might be the best out there.  I hope this helps!  hehe!  :)
gui,1:add,button,		x1135	y400	h20	w20	gpreviousstuffgroup	,<
gui,1:add,edit,		x1155	y400	h20	w200	readonly	center	vguitextstuffgroup2,
gui,1:add,button,		x1355	y400	h20	w20	gnextstuffgroup	,>
gui,1:add,button,		x1115	y575	h20	gpreviousstuff	,<-- previous stuff
gui,1:add,text,		x1115	y425	h150	w280	center	vguitextstuff2	gstuffclick,
gui,1:add,button,		x1315	y575	h20	gnextstuff	,next stuff -->
gui,1:add,text,		x1115	y595		w280	center	,______________________________________________
gui,1:add,text,		x1115	y610	h25	w280	,If you have a "Random Stuff" you'd like me to add to my list you can let Luffy know at: luffyzanderson@yahoo.com.
;--------------------------------------------------------------------------------
gui,1:tab,3	;  Round Data  -  tab (3)
;--------------------------------------------------------------------------------
; variables handled:
;--------------------------------------------------------------------------------
;  rdisplaytext = round #/total rounds
;--------------------------------------------------------------------------------
Gui, Add, text, x15 y30, Here you can manually pair players and enter in their results.  If Luffy wasn't too lazy to write the code for me I'd pair it automatically for you.  When I grow up I'll do it!  Well, either that or I'll be an austronaught!  :)
Gui, Add, text, x15 y45, To make a new round you can view the last round and click my "Next Round" button.  To change results you can left click OR right click them.`nTo move players you can use the arrow buttons OR click them and click where you want them to go.
Gui, Add, Text, x122 y80 w100 h20 center vrdisplaytext, 
Gui, Add, Text, x390 y80 w300 h20 , Autopairing Options (Not yet available)

Gui, Add, Text, x15 y144 w50 h20 center, PLYR #
Gui, Add, Text, x67 y144 w150 h20 center, UNPAIRED PLAYERS
Gui, Add, Text, x325 y144 w70 h20 center, BOARD
Gui, Add, Text, x482 y144 w110 h20 center, WHITE PLAYERS
Gui, Add, Text, x740 y144 w110 h20 center, BLACK PLAYERS

Gui, Add, Button, x42 y80 w40 h30 , First Round
Gui, Add, Button, x82 y80 w40 h30 , Prev. Round
Gui, Add, Button, x222 y80 w40 h30 , Next Round
Gui, Add, Button, x262 y80 w40 h30 , Last Round
Gui, Add, Button, x132 y100 w40 h30 , Unpair Round
Gui, Add, Button, x172 y100 w40 h30 , Delete Round

Gui, Add, Button, x330 y100 w50 h30 , No Stress
Gui, Add, Button, x382 y100 w50 h30 , Round Robin
Gui, Add, Button, x432 y100 w50 h30 , Random
Gui, Add, Button, x482 y100 w50 h30 , Swiss
Gui, Add, Button, x532 y100 w50 h30 , Swiss (Accel)
Gui, Add, Button, x582 y100 w50 h30 , Swiss (2x Accel)

Gui, Add, text, x22 y580 w310 h40 center vcurrentupdisplaytext,
Gui, Add, Button, x15 y620 w50 h40 , First 20 Unpaired Players
Gui, Add, Button, x65 y620 w50 h40 , Prev. 20 Unpaired Players
Gui, Add, Button, x135 y620 w50 h40 , Next 20 Unpaired Players
Gui, Add, Button, x185 y620 w50 h40 , Last 20 Unpaired Players

Gui, Add, text, x490 y580 w310 h20 center vcurrentboarddisplaytext,
Gui, Add, Button, x515 y600 w50 h40 , First 20 Boards
Gui, Add, Button, x570 y600 w50 h40 , Prev. 20 Boards
Gui, Add, Button, x665 y600 w50 h40 , Next 20 Boards
Gui, Add, Button, x720 y600 w50 h40 , Last 20 Boards

Gui, Add, Button, x15 y680 h20, &Detect Data Errors
gui, add, text, x120 y683 h15, Only the first 5 errors detected are shown.

Gui, Add, text, x15 y170 w50 h20 vp1 center,
Gui, Add, text, x15 y190 w50 h20 vp2 center,
Gui, Add, text, x15 y210 w50 h20 vp3 center,
Gui, Add, text, x15 y230 w50 h20 vp4 center,
Gui, Add, text, x15 y250 w50 h20 vp5 center,
Gui, Add, text, x15 y270 w50 h20 vp6 center,
Gui, Add, text, x15 y290 w50 h20 vp7 center,
Gui, Add, text, x15 y310 w50 h20 vp8 center,
Gui, Add, text, x15 y330 w50 h20 vp9 center,
Gui, Add, text, x15 y350 w50 h20 vp10 center,
Gui, Add, text, x15 y370 w50 h20 vp11 center,
Gui, Add, text, x15 y390 w50 h20 vp12 center,
Gui, Add, text, x15 y410 w50 h20 vp13 center,
Gui, Add, text, x15 y430 w50 h20 vp14 center,
Gui, Add, text, x15 y450 w50 h20 vp15 center,
Gui, Add, text, x15 y470 w50 h20 vp16 center,
Gui, Add, text, x15 y490 w50 h20 vp17 center,
Gui, Add, text, x15 y510 w50 h20 vp18 center,
Gui, Add, text, x15 y530 w50 h20 vp19 center,
Gui, Add, text, x15 y550 w50 h20 vp20 center,

Gui, Add, text, x67 y170 w150 h20 center vupname1 gupname1,
Gui, Add, text, x67 y190 w150 h20 center vupname2 gupname2,
Gui, Add, text, x67 y210 w150 h20 center vupname3 gupname3,
Gui, Add, text, x67 y230 w150 h20 center vupname4 gupname4,
Gui, Add, text, x67 y250 w150 h20 center vupname5 gupname5,
Gui, Add, text, x67 y270 w150 h20 center vupname6 gupname6,
Gui, Add, text, x67 y290 w150 h20 center vupname7 gupname7,
Gui, Add, text, x67 y310 w150 h20 center vupname8 gupname8,
Gui, Add, text, x67 y330 w150 h20 center vupname9 gupname9,
Gui, Add, text, x67 y350 w150 h20 center vupname10 gupname10,
Gui, Add, text, x67 y370 w150 h20 center vupname11 gupname11,
Gui, Add, text, x67 y390 w150 h20 center vupname12 gupname12,
Gui, Add, text, x67 y410 w150 h20 center vupname13 gupname13,
Gui, Add, text, x67 y430 w150 h20 center vupname14 gupname14,
Gui, Add, text, x67 y450 w150 h20 center vupname15 gupname15,
Gui, Add, text, x67 y470 w150 h20 center vupname16 gupname16,
Gui, Add, text, x67 y490 w150 h20 center vupname17 gupname17,
Gui, Add, text, x67 y510 w150 h20 center vupname18 gupname18,
Gui, Add, text, x67 y530 w150 h20 center vupname19 gupname19,
Gui, Add, text, x67 y550 w150 h20 center vupname20 gupname20,
Gui, Add, text, x217 y170 w65 h20 center vupres1 gupres1,
Gui, Add, text, x217 y190 w65 h20 center vupres2 gupres2,
Gui, Add, text, x217 y210 w65 h20 center vupres3 gupres3,
Gui, Add, text, x217 y230 w65 h20 center vupres4 gupres4,
Gui, Add, text, x217 y250 w65 h20 center vupres5 gupres5,
Gui, Add, text, x217 y270 w65 h20 center vupres6 gupres6,
Gui, Add, text, x217 y290 w65 h20 center vupres7 gupres7,
Gui, Add, text, x217 y310 w65 h20 center vupres8 gupres8,
Gui, Add, text, x217 y330 w65 h20 center vupres9 gupres9,
Gui, Add, text, x217 y350 w65 h20 center vupres10 gupres10,
Gui, Add, text, x217 y370 w65 h20 center vupres11 gupres11,
Gui, Add, text, x217 y390 w65 h20 center vupres12 gupres12,
Gui, Add, text, x217 y410 w65 h20 center vupres13 gupres13,
Gui, Add, text, x217 y430 w65 h20 center vupres14 gupres14,
Gui, Add, text, x217 y450 w65 h20 center vupres15 gupres15,
Gui, Add, text, x217 y470 w65 h20 center vupres16 gupres16,
Gui, Add, text, x217 y490 w65 h20 center vupres17 gupres17,
Gui, Add, text, x217 y510 w65 h20 center vupres18 gupres18,
Gui, Add, text, x217 y530 w65 h20 center vupres19 gupres19,
Gui, Add, text, x217 y550 w65 h20 center vupres20 gupres20,
Gui, Add, Button, x282 y167 w20 h20 vuptowp1 guptowp1, >
Gui, Add, Button, x282 y187 w20 h20 vuptowp2 guptowp2, >
Gui, Add, Button, x282 y207 w20 h20 vuptowp3 guptowp3, >
Gui, Add, Button, x282 y227 w20 h20 vuptowp4 guptowp4, >
Gui, Add, Button, x282 y247 w20 h20 vuptowp5 guptowp5, >
Gui, Add, Button, x282 y267 w20 h20 vuptowp6 guptowp6, >
Gui, Add, Button, x282 y287 w20 h20 vuptowp7 guptowp7, >
Gui, Add, Button, x282 y307 w20 h20 vuptowp8 guptowp8, >
Gui, Add, Button, x282 y327 w20 h20 vuptowp9 guptowp9, >
Gui, Add, Button, x282 y347 w20 h20 vuptowp10 guptowp10, >
Gui, Add, Button, x282 y367 w20 h20 vuptowp11 guptowp11, >
Gui, Add, Button, x282 y387 w20 h20 vuptowp12 guptowp12, >
Gui, Add, Button, x282 y407 w20 h20 vuptowp13 guptowp13, >
Gui, Add, Button, x282 y427 w20 h20 vuptowp14 guptowp14, >
Gui, Add, Button, x282 y447 w20 h20 vuptowp15 guptowp15, >
Gui, Add, Button, x282 y467 w20 h20 vuptowp16 guptowp16, >
Gui, Add, Button, x282 y487 w20 h20 vuptowp17 guptowp17, >
Gui, Add, Button, x282 y507 w20 h20 vuptowp18 guptowp18, >
Gui, Add, Button, x282 y527 w20 h20 vuptowp19 guptowp19, >
Gui, Add, Button, x282 y547 w20 h20 vuptowp20 guptowp20, >

Gui, Add, Button, x302 y167 w20 h20 vuptobp1 guptobp1, >>
Gui, Add, Button, x302 y187 w20 h20 vuptobp2 guptobp2, >>
Gui, Add, Button, x302 y207 w20 h20 vuptobp3 guptobp3, >>
Gui, Add, Button, x302 y227 w20 h20 vuptobp4 guptobp4, >>
Gui, Add, Button, x302 y247 w20 h20 vuptobp5 guptobp5, >>
Gui, Add, Button, x302 y267 w20 h20 vuptobp6 guptobp6, >>
Gui, Add, Button, x302 y287 w20 h20 vuptobp7 guptobp7, >>
Gui, Add, Button, x302 y307 w20 h20 vuptobp8 guptobp8, >>
Gui, Add, Button, x302 y327 w20 h20 vuptobp9 guptobp9, >>
Gui, Add, Button, x302 y347 w20 h20 vuptobp10 guptobp10, >>
Gui, Add, Button, x302 y367 w20 h20 vuptobp11 guptobp11, >>
Gui, Add, Button, x302 y387 w20 h20 vuptobp12 guptobp12, >>
Gui, Add, Button, x302 y407 w20 h20 vuptobp13 guptobp13, >>
Gui, Add, Button, x302 y427 w20 h20 vuptobp14 guptobp14, >>
Gui, Add, Button, x302 y447 w20 h20 vuptobp15 guptobp15, >>
Gui, Add, Button, x302 y467 w20 h20 vuptobp16 guptobp16, >>
Gui, Add, Button, x302 y487 w20 h20 vuptobp17 guptobp17, >>
Gui, Add, Button, x302 y507 w20 h20 vuptobp18 guptobp18, >>
Gui, Add, Button, x302 y527 w20 h20 vuptobp19 guptobp19, >>
Gui, Add, Button, x302 y547 w20 h20 vuptobp20 guptobp20, >>

Gui, Add, Text, x322 y170 w70 h20 center vboard1,
Gui, Add, Text, x322 y190 w70 h20 center vboard2,
Gui, Add, Text, x322 y210 w70 h20 center vboard3,
Gui, Add, Text, x322 y230 w70 h20 center vboard4,
Gui, Add, Text, x322 y250 w70 h20 center vboard5,
Gui, Add, Text, x322 y270 w70 h20 center vboard6,
Gui, Add, Text, x322 y290 w70 h20 center vboard7,
Gui, Add, Text, x322 y310 w70 h20 center vboard8,
Gui, Add, Text, x322 y330 w70 h20 center vboard9,
Gui, Add, Text, x322 y350 w70 h20 center vboard10,
Gui, Add, Text, x322 y370 w70 h20 center vboard11,
Gui, Add, Text, x322 y390 w70 h20 center vboard12,
Gui, Add, Text, x322 y410 w70 h20 center vboard13,
Gui, Add, Text, x322 y430 w70 h20 center vboard14,
Gui, Add, Text, x322 y450 w70 h20 center vboard15,
Gui, Add, Text, x322 y470 w70 h20 center vboard16,
Gui, Add, Text, x322 y490 w70 h20 center vboard17,
Gui, Add, Text, x322 y510 w70 h20 center vboard18,
Gui, Add, Text, x322 y530 w70 h20 center vboard19,
Gui, Add, Text, x322 y550 w70 h20 center vboard20,
Gui, Add, Button, x392 y167 w20 h20 vwptoup1 gwptoup1, <
Gui, Add, Button, x392 y187 w20 h20 vwptoup2 gwptoup2, <
Gui, Add, Button, x392 y207 w20 h20 vwptoup3 gwptoup3, <
Gui, Add, Button, x392 y227 w20 h20 vwptoup4 gwptoup4, <
Gui, Add, Button, x392 y247 w20 h20 vwptoup5 gwptoup5, <
Gui, Add, Button, x392 y267 w20 h20 vwptoup6 gwptoup6, <
Gui, Add, Button, x392 y287 w20 h20 vwptoup7 gwptoup7, <
Gui, Add, Button, x392 y307 w20 h20 vwptoup8 gwptoup8, <
Gui, Add, Button, x392 y327 w20 h20 vwptoup9 gwptoup9, <
Gui, Add, Button, x392 y347 w20 h20 vwptoup10 gwptoup10, <
Gui, Add, Button, x392 y367 w20 h20 vwptoup11 gwptoup11, <
Gui, Add, Button, x392 y387 w20 h20 vwptoup12 gwptoup12, <
Gui, Add, Button, x392 y407 w20 h20 vwptoup13 gwptoup13, <
Gui, Add, Button, x392 y427 w20 h20 vwptoup14 gwptoup14, <
Gui, Add, Button, x392 y447 w20 h20 vwptoup15 gwptoup15, <
Gui, Add, Button, x392 y467 w20 h20 vwptoup16 gwptoup16, <
Gui, Add, Button, x392 y487 w20 h20 vwptoup17 gwptoup17, <
Gui, Add, Button, x392 y507 w20 h20 vwptoup18 gwptoup18, <
Gui, Add, Button, x392 y527 w20 h20 vwptoup19 gwptoup19, <
Gui, Add, Button, x392 y547 w20 h20 vwptoup20 gwptoup20, <
Gui, Add, Button, x412 y167 w20 h20 vwpdown1 gwpdown1, \/
Gui, Add, Button, x412 y187 w20 h20 vwpdown2 gwpdown2, \/
Gui, Add, Button, x412 y207 w20 h20 vwpdown3 gwpdown3, \/
Gui, Add, Button, x412 y227 w20 h20 vwpdown4 gwpdown4, \/
Gui, Add, Button, x412 y247 w20 h20 vwpdown5 gwpdown5, \/
Gui, Add, Button, x412 y267 w20 h20 vwpdown6 gwpdown6, \/
Gui, Add, Button, x412 y287 w20 h20 vwpdown7 gwpdown7, \/
Gui, Add, Button, x412 y307 w20 h20 vwpdown8 gwpdown8, \/
Gui, Add, Button, x412 y327 w20 h20 vwpdown9 gwpdown9, \/
Gui, Add, Button, x412 y347 w20 h20 vwpdown10 gwpdown10, \/
Gui, Add, Button, x412 y367 w20 h20 vwpdown11 gwpdown11, \/
Gui, Add, Button, x412 y387 w20 h20 vwpdown12 gwpdown12, \/
Gui, Add, Button, x412 y407 w20 h20 vwpdown13 gwpdown13, \/
Gui, Add, Button, x412 y427 w20 h20 vwpdown14 gwpdown14, \/
Gui, Add, Button, x412 y447 w20 h20 vwpdown15 gwpdown15, \/
Gui, Add, Button, x412 y467 w20 h20 vwpdown16 gwpdown16, \/
Gui, Add, Button, x412 y487 w20 h20 vwpdown17 gwpdown17, \/
Gui, Add, Button, x412 y507 w20 h20 vwpdown18 gwpdown18, \/
Gui, Add, Button, x412 y527 w20 h20 vwpdown19 gwpdown19, \/
Gui, Add, Button, x412 y547 w20 h20 vwpdown20 gwpdown20, \/
Gui, Add, Button, x432 y167 w20 h20 vwpup1 gwpup1, /\
Gui, Add, Button, x432 y187 w20 h20 vwpup2 gwpup2, /\
Gui, Add, Button, x432 y207 w20 h20 vwpup3 gwpup3, /\
Gui, Add, Button, x432 y227 w20 h20 vwpup4 gwpup4, /\
Gui, Add, Button, x432 y247 w20 h20 vwpup5 gwpup5, /\
Gui, Add, Button, x432 y267 w20 h20 vwpup6 gwpup6, /\
Gui, Add, Button, x432 y287 w20 h20 vwpup7 gwpup7, /\
Gui, Add, Button, x432 y307 w20 h20 vwpup8 gwpup8, /\
Gui, Add, Button, x432 y327 w20 h20 vwpup9 gwpup9, /\
Gui, Add, Button, x432 y347 w20 h20 vwpup10 gwpup10, /\
Gui, Add, Button, x432 y367 w20 h20 vwpup11 gwpup11, /\
Gui, Add, Button, x432 y387 w20 h20 vwpup12 gwpup12, /\
Gui, Add, Button, x432 y407 w20 h20 vwpup13 gwpup13, /\
Gui, Add, Button, x432 y427 w20 h20 vwpup14 gwpup14, /\
Gui, Add, Button, x432 y447 w20 h20 vwpup15 gwpup15, /\
Gui, Add, Button, x432 y467 w20 h20 vwpup16 gwpup16, /\
Gui, Add, Button, x432 y487 w20 h20 vwpup17 gwpup17, /\
Gui, Add, Button, x432 y507 w20 h20 vwpup18 gwpup18, /\
Gui, Add, Button, x432 y527 w20 h20 vwpup19 gwpup19, /\
Gui, Add, Button, x432 y547 w20 h20 vwpup20 gwpup20, /\
Gui, Add, text, x452 y170 w170 h20 center vwpname1 gwpname1, 
Gui, Add, text, x452 y190 w170 h20 center vwpname2 gwpname2, 
Gui, Add, text, x452 y210 w170 h20 center vwpname3 gwpname3, 
Gui, Add, text, x452 y230 w170 h20 center vwpname4 gwpname4, 
Gui, Add, text, x452 y250 w170 h20 center vwpname5 gwpname5, 
Gui, Add, text, x452 y270 w170 h20 center vwpname6 gwpname6, 
Gui, Add, text, x452 y290 w170 h20 center vwpname7 gwpname7, 
Gui, Add, text, x452 y310 w170 h20 center vwpname8 gwpname8, 
Gui, Add, text, x452 y330 w170 h20 center vwpname9 gwpname9, 
Gui, Add, text, x452 y350 w170 h20 center vwpname10 gwpname10, 
Gui, Add, text, x452 y370 w170 h20 center vwpname11 gwpname11, 
Gui, Add, text, x452 y390 w170 h20 center vwpname12 gwpname12, 
Gui, Add, text, x452 y410 w170 h20 center vwpname13 gwpname13, 
Gui, Add, text, x452 y430 w170 h20 center vwpname14 gwpname14, 
Gui, Add, text, x452 y450 w170 h20 center vwpname15 gwpname15, 
Gui, Add, text, x452 y470 w170 h20 center vwpname16 gwpname16, 
Gui, Add, text, x452 y490 w170 h20 center vwpname17 gwpname17, 
Gui, Add, text, x452 y510 w170 h20 center vwpname18 gwpname18, 
Gui, Add, text, x452 y530 w170 h20 center vwpname19 gwpname19, 
Gui, Add, text, x452 y550 w170 h20 center vwpname20 gwpname20, 
Gui, Add, text, x622 y170 w30 h20 center vwpres1 gwpres1, 
Gui, Add, text, x622 y190 w30 h20 center vwpres2 gwpres2, 
Gui, Add, text, x622 y210 w30 h20 center vwpres3 gwpres3, 
Gui, Add, text, x622 y230 w30 h20 center vwpres4 gwpres4, 
Gui, Add, text, x622 y250 w30 h20 center vwpres5 gwpres5, 
Gui, Add, text, x622 y270 w30 h20 center vwpres6 gwpres6, 
Gui, Add, text, x622 y290 w30 h20 center vwpres7 gwpres7, 
Gui, Add, text, x622 y310 w30 h20 center vwpres8 gwpres8, 
Gui, Add, text, x622 y330 w30 h20 center vwpres9 gwpres9, 
Gui, Add, text, x622 y350 w30 h20 center vwpres10 gwpres10, 
Gui, Add, text, x622 y370 w30 h20 center vwpres11 gwpres11, 
Gui, Add, text, x622 y390 w30 h20 center vwpres12 gwpres12, 
Gui, Add, text, x622 y410 w30 h20 center vwpres13 gwpres13, 
Gui, Add, text, x622 y430 w30 h20 center vwpres14 gwpres14, 
Gui, Add, text, x622 y450 w30 h20 center vwpres15 gwpres15, 
Gui, Add, text, x622 y470 w30 h20 center vwpres16 gwpres16, 
Gui, Add, text, x622 y490 w30 h20 center vwpres17 gwpres17, 
Gui, Add, text, x622 y510 w30 h20 center vwpres18 gwpres18, 
Gui, Add, text, x622 y530 w30 h20 center vwpres19 gwpres19, 
Gui, Add, text, x622 y550 w30 h20 center vwpres20 gwpres20, 
Gui, Add, Button, x652 y167 w20 h20 vwptobp1 gwptobp1, >
Gui, Add, Button, x652 y187 w20 h20 vwptobp2 gwptobp2, >
Gui, Add, Button, x652 y207 w20 h20 vwptobp3 gwptobp3, >
Gui, Add, Button, x652 y227 w20 h20 vwptobp4 gwptobp4, >
Gui, Add, Button, x652 y247 w20 h20 vwptobp5 gwptobp5, >
Gui, Add, Button, x652 y267 w20 h20 vwptobp6 gwptobp6, >
Gui, Add, Button, x652 y287 w20 h20 vwptobp7 gwptobp7, >
Gui, Add, Button, x652 y307 w20 h20 vwptobp8 gwptobp8, >
Gui, Add, Button, x652 y327 w20 h20 vwptobp9 gwptobp9, >
Gui, Add, Button, x652 y347 w20 h20 vwptobp10 gwptobp10, >
Gui, Add, Button, x652 y367 w20 h20 vwptobp11 gwptobp11, >
Gui, Add, Button, x652 y387 w20 h20 vwptobp12 gwptobp12, >
Gui, Add, Button, x652 y407 w20 h20 vwptobp13 gwptobp13, >
Gui, Add, Button, x652 y427 w20 h20 vwptobp14 gwptobp14, >
Gui, Add, Button, x652 y447 w20 h20 vwptobp15 gwptobp15, >
Gui, Add, Button, x652 y467 w20 h20 vwptobp16 gwptobp16, >
Gui, Add, Button, x652 y487 w20 h20 vwptobp17 gwptobp17, >
Gui, Add, Button, x652 y507 w20 h20 vwptobp18 gwptobp18, >
Gui, Add, Button, x652 y527 w20 h20 vwptobp19 gwptobp19, >
Gui, Add, Button, x652 y547 w20 h20 vwptobp20 gwptobp20, >
Gui, Add, Button, x672 y167 w20 h20 vswap1 gswap1, ><
Gui, Add, Button, x672 y187 w20 h20 vswap2 gswap2, ><
Gui, Add, Button, x672 y207 w20 h20 vswap3 gswap3, ><
Gui, Add, Button, x672 y227 w20 h20 vswap4 gswap4, ><
Gui, Add, Button, x672 y247 w20 h20 vswap5 gswap5, ><
Gui, Add, Button, x672 y267 w20 h20 vswap6 gswap6, ><
Gui, Add, Button, x672 y287 w20 h20 vswap7 gswap7, ><
Gui, Add, Button, x672 y307 w20 h20 vswap8 gswap8 , ><
Gui, Add, Button, x672 y327 w20 h20 vswap9 gswap9, ><
Gui, Add, Button, x672 y347 w20 h20 vswap10 gswap10, ><
Gui, Add, Button, x672 y367 w20 h20 vswap11 gswap11, ><
Gui, Add, Button, x672 y387 w20 h20 vswap12 gswap12, ><
Gui, Add, Button, x672 y407 w20 h20 vswap13 gswap13, ><
Gui, Add, Button, x672 y427 w20 h20 vswap14 gswap14, ><
Gui, Add, Button, x672 y447 w20 h20 vswap15 gswap15, ><
Gui, Add, Button, x672 y467 w20 h20 vswap16 gswap16, ><
Gui, Add, Button, x672 y487 w20 h20 vswap17 gswap17, ><
Gui, Add, Button, x672 y507 w20 h20 vswap18 gswap18, ><
Gui, Add, Button, x672 y527 w20 h20 vswap19 gswap19, ><
Gui, Add, Button, x672 y547 w20 h20 vswap20 gswap20, ><
Gui, Add, Button, x692 y167 w20 h20 vbptowp1 gbptowp1, <
Gui, Add, Button, x692 y187 w20 h20 vbptowp2 gbptowp2, <
Gui, Add, Button, x692 y207 w20 h20 vbptowp3 gbptowp3, <
Gui, Add, Button, x692 y227 w20 h20 vbptowp4 gbptowp4, <
Gui, Add, Button, x692 y247 w20 h20 vbptowp5 gbptowp5, <
Gui, Add, Button, x692 y267 w20 h20 vbptowp6 gbptowp6, <
Gui, Add, Button, x692 y287 w20 h20 vbptowp7 gbptowp7, <
Gui, Add, Button, x692 y307 w20 h20 vbptowp8 gbptowp8, <
Gui, Add, Button, x692 y327 w20 h20 vbptowp9 gbptowp9, <
Gui, Add, Button, x692 y347 w20 h20 vbptowp10 gbptowp10, <
Gui, Add, Button, x692 y367 w20 h20 vbptowp11 gbptowp11, <
Gui, Add, Button, x692 y387 w20 h20 vbptowp12 gbptowp12, <
Gui, Add, Button, x692 y407 w20 h20 vbptowp13 gbptowp13, <
Gui, Add, Button, x692 y427 w20 h20 vbptowp14 gbptowp14, <
Gui, Add, Button, x692 y447 w20 h20 vbptowp15 gbptowp15, <
Gui, Add, Button, x692 y467 w20 h20 vbptowp16 gbptowp16, <
Gui, Add, Button, x692 y487 w20 h20 vbptowp17 gbptowp17, <
Gui, Add, Button, x692 y507 w20 h20 vbptowp18 gbptowp18, <
Gui, Add, Button, x692 y527 w20 h20 vbptowp19 gbptowp19, <
Gui, Add, Button, x692 y547 w20 h20 vbptowp20 gbptowp20, <
Gui, Add, text, x712 y170 w170 h20 center vbpname1 gbpname1, 
Gui, Add, text, x712 y190 w170 h20 center vbpname2 gbpname2, 
Gui, Add, text, x712 y210 w170 h20 center vbpname3 gbpname3, 
Gui, Add, text, x712 y230 w170 h20 center vbpname4 gbpname4, 
Gui, Add, text, x712 y250 w170 h20 center vbpname5 gbpname5, 
Gui, Add, text, x712 y270 w170 h20 center vbpname6 gbpname6, 
Gui, Add, text, x712 y290 w170 h20 center vbpname7 gbpname7, 
Gui, Add, text, x712 y310 w170 h20 center vbpname8 gbpname8, 
Gui, Add, text, x712 y330 w170 h20 center vbpname9 gbpname9, 
Gui, Add, text, x712 y350 w170 h20 center vbpname10 gbpname10, 
Gui, Add, text, x712 y370 w170 h20 center vbpname11 gbpname11, 
Gui, Add, text, x712 y390 w170 h20 center vbpname12 gbpname12, 
Gui, Add, text, x712 y410 w170 h20 center vbpname13 gbpname13, 
Gui, Add, text, x712 y430 w170 h20 center vbpname14 gbpname14, 
Gui, Add, text, x712 y450 w170 h20 center vbpname15 gbpname15, 
Gui, Add, text, x712 y470 w170 h20 center vbpname16 gbpname16, 
Gui, Add, text, x712 y490 w170 h20 center vbpname17 gbpname17, 
Gui, Add, text, x712 y510 w170 h20 center vbpname18 gbpname18, 
Gui, Add, text, x712 y530 w170 h20 center vbpname19 gbpname19, 
Gui, Add, text, x712 y550 w170 h20 center vbpname20 gbpname20, 
Gui, Add, text, x882 y170 w30 h20 vbpres1 gbpres1, 
Gui, Add, text, x882 y190 w30 h20 vbpres2 gbpres2, 
Gui, Add, text, x882 y210 w30 h20 vbpres3 gbpres3, 
Gui, Add, text, x882 y230 w30 h20 vbpres4 gbpres4, 
Gui, Add, text, x882 y250 w30 h20 vbpres5 gbpres5, 
Gui, Add, text, x882 y270 w30 h20 vbpres6 gbpres6, 
Gui, Add, text, x882 y290 w30 h20 vbpres7 gbpres7, 
Gui, Add, text, x882 y310 w30 h20 vbpres8 gbpres8, 
Gui, Add, text, x882 y330 w30 h20 vbpres9 gbpres9, 
Gui, Add, text, x882 y350 w30 h20 vbpres10 gbpres10, 
Gui, Add, text, x882 y370 w30 h20 vbpres11 gbpres11, 
Gui, Add, text, x882 y390 w30 h20 vbpres12 gbpres12, 
Gui, Add, text, x882 y410 w30 h20 vbpres13 gbpres13, 
Gui, Add, text, x882 y430 w30 h20 vbpres14 gbpres14, 
Gui, Add, text, x882 y450 w30 h20 vbpres15 gbpres15, 
Gui, Add, text, x882 y470 w30 h20 vbpres16 gbpres16, 
Gui, Add, text, x882 y490 w30 h20 vbpres17 gbpres17, 
Gui, Add, text, x882 y510 w30 h20 vbpres18 gbpres18, 
Gui, Add, text, x882 y530 w30 h20 vbpres19 gbpres19, 
Gui, Add, text, x882 y550 w30 h20 vbpres20 gbpres20, 
Gui, Add, Button, x912 y167 w20 h20 vbpdown1 gbpdown1, \/
Gui, Add, Button, x912 y187 w20 h20 vbpdown2 gbpdown2, \/
Gui, Add, Button, x912 y207 w20 h20 vbpdown3 gbpdown3, \/
Gui, Add, Button, x912 y227 w20 h20 vbpdown4 gbpdown4, \/
Gui, Add, Button, x912 y247 w20 h20 vbpdown5 gbpdown5, \/
Gui, Add, Button, x912 y267 w20 h20 vbpdown6 gbpdown6, \/
Gui, Add, Button, x912 y287 w20 h20 vbpdown7 gbpdown7, \/
Gui, Add, Button, x912 y307 w20 h20 vbpdown8 gbpdown8, \/
Gui, Add, Button, x912 y327 w20 h20 vbpdown9 gbpdown9, \/
Gui, Add, Button, x912 y347 w20 h20 vbpdown10 gbpdown10, \/
Gui, Add, Button, x912 y367 w20 h20 vbpdown11 gbpdown11, \/
Gui, Add, Button, x912 y387 w20 h20 vbpdown12 gbpdown12, \/
Gui, Add, Button, x912 y407 w20 h20 vbpdown13 gbpdown13, \/
Gui, Add, Button, x912 y427 w20 h20 vbpdown14 gbpdown14, \/
Gui, Add, Button, x912 y447 w20 h20 vbpdown15 gbpdown15, \/
Gui, Add, Button, x912 y467 w20 h20 vbpdown16 gbpdown16, \/
Gui, Add, Button, x912 y487 w20 h20 vbpdown17 gbpdown17, \/
Gui, Add, Button, x912 y507 w20 h20 vbpdown18 gbpdown18, \/
Gui, Add, Button, x912 y527 w20 h20 vbpdown19 gbpdown19, \/
Gui, Add, Button, x912 y547 w20 h20 vbpdown20 gbpdown20, \/
Gui, Add, Button, x932 y167 w20 h20 vbpup1 gbpup1, /\
Gui, Add, Button, x932 y187 w20 h20 vbpup2 gbpup2, /\
Gui, Add, Button, x932 y207 w20 h20 vbpup3 gbpup3, /\
Gui, Add, Button, x932 y227 w20 h20 vbpup4 gbpup4, /\
Gui, Add, Button, x932 y247 w20 h20 vbpup5 gbpup5, /\
Gui, Add, Button, x932 y267 w20 h20 vbpup6 gbpup6, /\
Gui, Add, Button, x932 y287 w20 h20 vbpup7 gbpup7, /\
Gui, Add, Button, x932 y307 w20 h20 vbpup8 gbpup8, /\
Gui, Add, Button, x932 y327 w20 h20 vbpup9 gbpup9, /\
Gui, Add, Button, x932 y347 w20 h20 vbpup10 gbpup10, /\
Gui, Add, Button, x932 y367 w20 h20 vbpup11 gbpup11, /\
Gui, Add, Button, x932 y387 w20 h20 vbpup12 gbpup12, /\
Gui, Add, Button, x932 y407 w20 h20 vbpup13 gbpup13, /\
Gui, Add, Button, x932 y427 w20 h20 vbpup14 gbpup14, /\
Gui, Add, Button, x932 y447 w20 h20 vbpup15 gbpup15, /\
Gui, Add, Button, x932 y467 w20 h20 vbpup16 gbpup16, /\
Gui, Add, Button, x932 y487 w20 h20 vbpup17 gbpup17, /\
Gui, Add, Button, x932 y507 w20 h20 vbpup18 gbpup18, /\
Gui, Add, Button, x932 y527 w20 h20 vbpup19 gbpup19, /\
Gui, Add, Button, x932 y547 w20 h20 vbpup20 gbpup20, /\
Gui, Add, Button, x952 y167 w20 h20 vbptoup1 gbptoup1, >
Gui, Add, Button, x952 y187 w20 h20 vbptoup2 gbptoup2, >
Gui, Add, Button, x952 y207 w20 h20 vbptoup3 gbptoup3, >
Gui, Add, Button, x952 y227 w20 h20 vbptoup4 gbptoup4, >
Gui, Add, Button, x952 y247 w20 h20 vbptoup5 gbptoup5, >
Gui, Add, Button, x952 y267 w20 h20 vbptoup6 gbptoup6, >
Gui, Add, Button, x952 y287 w20 h20 vbptoup7 gbptoup7, >
Gui, Add, Button, x952 y307 w20 h20 vbptoup8 gbptoup8, >
Gui, Add, Button, x952 y327 w20 h20 vbptoup9 gbptoup9, >
Gui, Add, Button, x952 y347 w20 h20 vbptoup10 gbptoup10, >
Gui, Add, Button, x952 y367 w20 h20 vbptoup11 gbptoup11, >
Gui, Add, Button, x952 y387 w20 h20 vbptoup12 gbptoup12, >
Gui, Add, Button, x952 y407 w20 h20 vbptoup13 gbptoup13, >
Gui, Add, Button, x952 y427 w20 h20 vbptoup14 gbptoup14, >
Gui, Add, Button, x952 y447 w20 h20 vbptoup15 gbptoup15, >
Gui, Add, Button, x952 y467 w20 h20 vbptoup16 gbptoup16, >
Gui, Add, Button, x952 y487 w20 h20 vbptoup17 gbptoup17, >
Gui, Add, Button, x952 y507 w20 h20 vbptoup18 gbptoup18, >
Gui, Add, Button, x952 y527 w20 h20 vbptoup19 gbptoup19, >
Gui, Add, Button, x952 y547 w20 h20 vbptoup20 gbptoup20, >

gui,1:add,text,		x1115	y0		w280	,You can click on a recommendation for more information.`nI try to offer the most helpful recommendations I can.
gui,1:add,groupBox,	x1105	y30	h300	w300	center	,Local Chess Clubs:
gui,1:add,text,		x1115	y45	h45	w280	,If you're looking for a place to have fun playing chess or to get the word out about your own chess club's activities I think contacting these chess clubs might be a good idea: 
gui,1:add,button,		x1135	y90	h20	w20	gpreviousregion	,<
gui,1:add,edit,		x1155	y90	h20	w200	readonly	center	vguitextregion3,
gui,1:add,button,		x1355	y90	h20	w20	gnextregion	,>
gui,1:add,button,		x1115	y265	h20	gpreviouscca	,<-- previous club
gui,1:add,text,		x1115	y115	h150	w280	center	vguitextcca3	gccaclick,
gui,1:add,button,		x1315	y265	h20	gnextcca		,next club -->
gui,1:add,text,		x1115	y285		w280	center	,______________________________________________
gui,1:add,text,		x1115	y300	h25	w280	,If you have a club you'd like me to add to my list you can let Luffy know at: luffyzanderson@yahoo.com.

gui,1:add,groupBox,	x1105	y340	h300	w300	,Random Stuff:
gui,1:add,text,		x1115	y355	h45	w280	,Just some random stuff that I think might be the best out there.  I hope this helps! :)
gui,1:add,button,		x1135	y400	h20	w20	gpreviousstuffgroup	,<
gui,1:add,edit,		x1155	y400	h20	w200	readonly	center	vguitextstuffgroup3,
gui,1:add,button,		x1355	y400	h20	w20	gnextstuffgroup	,>
gui,1:add,button,		x1115	y575	h20	gpreviousstuff	,<-- previous stuff
gui,1:add,text,		x1115	y425	h150	w280	center	vguitextstuff3	gstuffclick,
gui,1:add,button,		x1315	y575	h20	gnextstuff	,next stuff -->
gui,1:add,text,		x1115	y595		w280	center	,______________________________________________
gui,1:add,text,		x1115	y610	h25	w280	,If you have a "Random Stuff" you'd like me to add to my list you can let Luffy know at: luffyzanderson@yahoo.com.

;--------------------------------------------------------------------------------
Gui,1:tab,4	; tab (4) Player Stats
;--------------------------------------------------------------------------------
gui, add, text,, This tab shows how each player has performed each round and overall.`n`nUnder the round columns a "W" indicates "White".  "B" indicates "Black".  The number next to the color indication is the player number of the opponent played that round.`n"bye" is displayed if the player who's stats are shown in that line didn't play that round for any reason.`nThe last number in the round columns represents any points scored: 0 = lost, .5 = drew, and 1 = won.`n`nETPR = Estimated Tournament Performance Rating.  EPTR = Estimated Post Tournament Rating.`nOnly points aquired during actual games played are used to determine win percentage.`nAll points scored are used to determine the total points in the last column, including any points scored in rounds during which a player didn't play a game.
Gui, Add, ListView, r30 w1075 grid gts vts, First Name
gui,1:add,button,		x935	y40	h20	w40	gprintstats	gprintstats	,Print
gui,1:add,text,		x1115	y0		w280	,You can click on a recommendation for more information.`nI try to offer the most helpful recommendations I can.
gui,1:add,groupBox,	x1105	y30	h300	w300	center	,Local Chess Clubs:
gui,1:add,text,		x1115	y45	h45	w280	,If you're looking for a place to have fun playing chess or to get the word out about your own chess club's activities I think contacting these chess clubs might be a good idea: 
gui,1:add,button,		x1135	y90	h20	w20	gpreviousregion	,<
gui,1:add,edit,		x1155	y90	h20	w200	readonly	center	vguitextregion4,
gui,1:add,button,		x1355	y90	h20	w20	gnextregion	,>
gui,1:add,button,		x1115	y265	h20	gpreviouscca	,<-- previous club
gui,1:add,text,		x1115	y115	h150	w280	center	vguitextcca4	gccaclick,
gui,1:add,button,		x1315	y265	h20	gnextcca		,next club -->
gui,1:add,text,		x1115	y285		w280	center	,______________________________________________
gui,1:add,text,		x1115	y300	h25	w280	,If you have a club you'd like me to add to my list you can let Luffy know at: luffyzanderson@yahoo.com.

gui,1:add,groupBox,	x1105	y340	h300	w300	,Random Stuff:
gui,1:add,text,		x1115	y355	h45	w280	,Just some random stuff that I think might be the best out there.  I hope this helps!  hehe!  :)
gui,1:add,button,		x1135	y400	h20	w20	gpreviousstuffgroup	,<
gui,1:add,edit,		x1155	y400	h20	w200	readonly	center	vguitextstuffgroup4,
gui,1:add,button,		x1355	y400	h20	w20	gnextstuffgroup	,>
gui,1:add,button,		x1115	y575	h20	gpreviousstuff	,<-- previous stuff
gui,1:add,text,		x1115	y425	h150	w280	center	vguitextstuff4	gstuffclick,
gui,1:add,button,		x1315	y575	h20	gnextstuff	,next stuff -->
gui,1:add,text,		x1115	y595		w280	center	,______________________________________________
gui,1:add,text,		x1115	y610	h25	w280	,If you have a "Random Stuff" you'd like me to add to my list you can let Luffy know at: luffyzanderson@yahoo.com.
;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------
Gui,1:tab,5	; tab (5) generate certificates
;--------------------------------------------------------------------------------
gui, add, text,, I can help you to create and use certificate templates and use them to generate certificates of achievement with detailed individual tournament performance stats for any player from the active tournament.`nIf you're new to this I suggest following these 3 easy steps:`n1.  Create a new certificate template.`n2.  Edit the certificate to suite your needs and preferences.`n3.  Select a player and generate a certificate for them.

Gui, Add, Button, x425 y100 h20, &Refresh Certificate Template Lists

gui,1:add,edit,	x15	y150	h20	w300	vcnctf,
gui,1:add,button,	x320	y150	h20,	Create New Certificate Template
gui, Add, listBox,	x15	y175	r10	w300	vctflb	gctflb
gui,1:add,text,	x320	y195	h20	w200,	Total Templates
gui,1:add,text,	x320	y215	h20	w200	vguitexttotctf,
gui,1:add,text,	x15	y315	h20,	Active Certificate:
gui,1:add,text,	x100	y315	h30	w200	vguiactftext

Gui, Add, ComboBox,	x500	y150	r10	w300	vsavectflb	gsavectflb
Gui, Add, Button,	x805	y150	h20,	&Save Certificate Template

gui,1:add,text,	x15	y380	h20, You can select a player from the active tournament from this list to generate a certificate for.
Gui, Add, ListBox,	x15	y395	w500	r10	vCertificateListBox	gCertificateListBox

gui,1:add,text,		x1115	y0		w280	,You can click on a recommendation for more information.`nI try to offer the most helpful recommendations I can.
gui,1:add,groupBox,	x1105	y30	h300	w300	center	,Local Chess Clubs:
gui,1:add,text,		x1115	y45	h45	w280	,If you're looking for a place to have fun playing chess or to get the word out about your own chess club's activities I think contacting these chess clubs might be a good idea: 
gui,1:add,button,		x1135	y90	h20	w20	gpreviousregion	,<
gui,1:add,edit,		x1155	y90	h20	w200	readonly	center	vguitextregion5,
gui,1:add,button,		x1355	y90	h20	w20	gnextregion	,>
gui,1:add,button,		x1115	y265	h20	gpreviouscca	,<-- previous club
gui,1:add,text,		x1115	y115	h150	w280	center	vguitextcca5	gccaclick,
gui,1:add,button,		x1315	y265	h20	gnextcca		,next club -->
gui,1:add,text,		x1115	y285		w280	center	,______________________________________________
gui,1:add,text,		x1115	y300	h25	w280	,If you have a club you'd like me to add to my list you can let Luffy know at: luffyzanderson@yahoo.com.

gui,1:add,groupBox,	x1105	y340	h300	w300	,Random Stuff:
gui,1:add,text,		x1115	y355	h45	w280	,Just some random stuff that I think might be the best out there.  I hope this helps!  hehe!  :)
gui,1:add,button,		x1135	y400	h20	w20	gpreviousstuffgroup	,<
gui,1:add,edit,		x1155	y400	h20	w200	readonly	center	vguitextstuffgroup5,
gui,1:add,button,		x1355	y400	h20	w20	gnextstuffgroup	,>
gui,1:add,button,		x1115	y575	h20	gpreviousstuff	,<-- previous stuff
gui,1:add,text,		x1115	y425	h150	w280	center	vguitextstuff5	gstuffclick,
gui,1:add,button,		x1315	y575	h20	gnextstuff	,next stuff -->
gui,1:add,text,		x1115	y595		w280	center	,______________________________________________
gui,1:add,text,		x1115	y610	h25	w280	,If you have a "Random Stuff" you'd like me to add to my list you can let Luffy know at: luffyzanderson@yahoo.com.
;--------------------------------------------------------------------------------
;  tab (5)  -  unused
;--------------------------------------------------------------------------------
;  Gui, Tab, 5	; Enter Round Results

;--------------------------------------------------------------------------------
;  tab (6)  -  unused
;--------------------------------------------------------------------------------
;  Gui, Tab, 6	; Modify or delete player information

;--------------------------------------------------------------------------------
;  tab (7)  -  unused
;--------------------------------------------------------------------------------
;  Gui, Tab, 7	; Modify or delete player information
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ifnotexist, C:\Program Files\No Stress Chess
	{
	FileCreateDir, C:\Program Files\No Stress Chess
	FileCreateDir, C:\Program Files\No Stress Chess\Tournaments
	fileappend, 30, %ct%
	FileSetAttrib, +h, %ct%
	FileCreateDir, C:\Program Files\No Stress Chess\Player Databases
	fileappend, Line 1, %cdb%
	FileSetAttrib, +h, %cdb%
	FileCreateDir, C:\Program Files\No Stress Chess\Certificates
	return
	}
ifnotexist, C:\Program Files\No Stress Chess\Tournaments
	FileCreateDir, C:\Program Files\No Stress Chess\Tournaments
ifnotexist, C:\Program Files\No Stress Chess\Tournaments
	FileCreateDir, C:\Program Files\No Stress Chess\Player Databases
ifnotexist, C:\Program Files\No Stress Chess\Tournaments
	FileCreateDir, C:\Program Files\No Stress Chess\Certificates
ifnotexist, %cdb%
	{
	fileappend, line 1, %cdb%
	FileSetAttrib, +h, %cdb%
	}
ifnotexist, %ct%
	{
	fileappend, 30, %ct%
	FileSetAttrib, +h, %ct%
	}
return

;____________________________________________________________________________________________________________________________________________________________________________
;=========================================================================================================================================================
;  End of auto-execute section. The script is idle until the user does something.
;____________________________________________________________________________________________________________________________________________________________________________
;=========================================================================================================================================================
/*
tt:
CreateNewDatabaseFile_TT := "If you'd like to create a new database to keep track of players I recommend typing in the name in the edit box to the left and then clicking on this button."
SaveDatabaseFile_TT := "You can permanently save a player database you've been working on by typing in the name you wish in the edit box to the left of this button and then clicking on this button."
CreateNewTournamentFile_TT := "If you'd like to create a new tournament I recommend typing in the name in the edit box to the left and then clicking on this button."
SaveTournamentFile_TT := "You can permanently save a tournament you've been working on by typing in the name you wish in the edit box to the left of this button and then clicking on this button."
Gui, Add, Checkbox, vMyCheck, This control has no tooltip.
Gui, Show
OnMessage(0x200, "WM_MOUSEMOVE")
return

WM_MOUSEMOVE()
{
    static CurrControl, PrevControl, _TT  ; _TT is kept blank for use by the ToolTip command below.
    CurrControl := A_GuiControl
    If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
    {
        ToolTip  ; Turn off any previous tooltip.
        SetTimer, DisplayToolTip, 1000
        PrevControl := CurrControl
    }
    return

    DisplayToolTip:
    SetTimer, DisplayToolTip, Off
    ToolTip % %CurrControl%_TT  ; The leading percent sign tell it to use an expression.
    SetTimer, RemoveToolTip, 6000
    return

    RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
    return
}
*/
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
addssetup:
;----------------------------------
;  chess clubs
;----------------------------------
currentregion:=1
totcca:=2
currentcca:=1

totregions:=2
region1:="Western Colorado"
	region1totcca:=2
	region1cca1:="NO STRESS CHESS`n`nThis USCF Affiliate meets every Sunday from 4pm to 8pm at the Barnes and Noble in Grand Junction.`n`nIt is the deepest desire of this club's organizers that those who choose to come have the most fun possible and challenge their opponents to the upmost of their abilites.`n`nThere are no fees for this club and donations are not expected but greatly appreciated."
	region1ccaclick1:="www.meetup.com/no-stress-chess-co"
	region1cca2:="DELTA CHESS CLUB`n`nThe oldest chess club in Western Colorado meets every Tuesday from 6:30pm to 9:00pm at the Bill Heddles Recreation Center in Delta.`n`nEvery 6 months they also host the Delta Chess Amatuer Classic, which seems to be the best run, most popular, most fun chess tournament in Western Colorado."
	region1ccaclick2:="www.meetup.com/no-stress-chess-co"
region2:="Central Arizona"
	region2totcca:=5
	region2cca1:="GAME NIGHTZ`n`n""WE PLAY FOR A LIVING!""`n`n4 rnd, USCF G/30 every Saturday night from 6pm to 10pm.`n`nChess merchandise available for purchase.`n`nAvailable as a large venue with online and phone pre-registering available as well for interested tournament organizers."
	region2ccaclick1:="www.gamenightz.com"
	region2cca2:="UNITY CHESS`n`n""FIRST WE'LL UNITE PLAYING CHESS, THEN WE'LL UNITE THE WORLD!""`n`nShout out the founder of Unity Chess, FIDE master, and my buddy, Pedram Atoufi!  If you like chess I strongly recommend checking out his monthy tournament, The Unity Open, a monthly, USCF, 4 rnd, G/30 Swiss with lots of super-strong competitors and big prizes.`nClasses and lessons available too."
	region2ccaclick2:="www.unitychess.com"
	region2cca3:="VALLEY CHESS`n`nWeekly USCF tournaments all across the Valley of the Sun.`n`nLessons available from published author, life master, and 2007 United States Senior Champion, Joel Johnson."
	region2ccaclick3:="http://sites.google.com/site/valleychess/"
	region2cca4:="THE CHESS EMPORIUM`n`nI honestly think the Emporium's Friday Night Action offers the most chess for you buck and a great opportunity to practice slow thinking.  It's a month long USCF tournament where each player's allowed 2 hours for their first 40 moves and 1 hour for the rest of the game." 
	region2ccaclick4:="www.chessemporium.com"
	region2cca5:="AZ CHESS CENTRAL`n`nThis non-profit organization based out of Gilbert offers what seems to me at least to be the absolute best teaching and coaching and produces some of the strongest players in Arizona."
	region2ccaclick5:="www.azchesscentral.com"
guicontrol,, guitextregion, %region1%
guicontrol,, guitextregion2, %region1%
guicontrol,, guitextregion3, %region1%
guicontrol,, guitextregion4, %region1%
guicontrol,, guitextregion5, %region1%
guicontrol,, guitextcca, %region1cca1%
guicontrol,, guitextcca2, %region1cca1%
guicontrol,, guitextcca3, %region1cca1%
guicontrol,, guitextcca4, %region1cca1%
guicontrol,, guitextcca5, %region1cca1%

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;  Random Stuff
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
currentstuffgroup:=1
totstuffs:=1
currentstuff:=1

totstuffgroups:=2
stuffgroup1:="Attacking Books"
	stuffgroup1totstuffs:=1
	stuffgroup1stuff1:="FORMATION ATTACKS`nby:`nJoel Johnson`n`nLuffy: ""Wanna call it a draw Joel?""`nJoel: ""HAHAHA! I DIDN'T COME HERE TO DRAW!""`n`nJoel learned chess at around 18 years old, he learned from an old attacking master and that's how he always plays.  As an added bonus he actually speaks english so for once the author's points actually get across!"
	stuffgroup1stuffclick1:="www.lulu.com/product/paperback/formation-attacks/12922778"
stuffgroup2:="Free Training Sites"
	stuffgroup2totstuffs:=1
	stuffgroup2stuff1:="CHESSTEMPO.COM`n`nThis is what I consider to be the absolute best chess training site I've ever seen or heard of.  I don't know about tomorrow or next year, but for now, I just can't imagine anything else coming close.  The work that's put into it and the attention to every little detail is amazing to me."
	stuffgroup2stuffclick1:="www.chesstempo.com"
guicontrol,, guitextstuffgroup, %stuffgroup1%
guicontrol,, guitextstuffgroup2, %stuffgroup1%
guicontrol,, guitextstuffgroup3, %stuffgroup1%
guicontrol,, guitextstuffgroup4, %stuffgroup1%
guicontrol,, guitextstuffgroup5, %stuffgroup1%
guicontrol,, guitextstuff, %stuffgroup1stuff1%
guicontrol,, guitextstuff2, %stuffgroup1stuff1%
guicontrol,, guitextstuff3, %stuffgroup1stuff1%
guicontrol,, guitextstuff4, %stuffgroup1stuff1%
guicontrol,, guitextstuff5, %stuffgroup1stuff1%
return

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
previousregion:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(currentregion>1)
	currentregion-=1
else
	currentregion:=totregions
region:=region%currentregion%
totcca:=region%currentregion%totcca
currentcca:=1
cca:=region%currentregion%cca1
guicontrol,, guitextregion, %region%
guicontrol,, guitextregion2, %region%
guicontrol,, guitextregion3, %region%
guicontrol,, guitextregion4, %region%
guicontrol,, guitextregion5, %region%
guicontrol,, guitextcca, %cca%
guicontrol,, guitextcca2, %cca%
guicontrol,, guitextcca3, %cca%
guicontrol,, guitextcca4, %cca%
guicontrol,, guitextcca5, %cca%
return

;--------------------
nextregion:
;--------------------
if(currentregion<totregions)
	currentregion+=1
else
	currentregion:=1
region:=region%currentregion%
totcca:=region%currentregion%totcca
currentcca:=1
cca:=region%currentregion%cca1
guicontrol,, guitextregion, %region%
guicontrol,, guitextregion2, %region%
guicontrol,, guitextregion3, %region%
guicontrol,, guitextregion4, %region%
guicontrol,, guitextregion5, %region%
guicontrol,, guitextcca, %cca%
guicontrol,, guitextcca2, %cca%
guicontrol,, guitextcca3, %cca%
guicontrol,, guitextcca4, %cca%
guicontrol,, guitextcca5, %cca%
return

;--------------------
previouscca:
;--------------------
if(currentcca>1)
	currentcca-=1
else
	currentcca:=totcca
cca:=region%currentregion%cca%currentcca%
guicontrol,, guitextcca, %cca%
guicontrol,, guitextcca2, %cca%
guicontrol,, guitextcca3, %cca%
guicontrol,, guitextcca4, %cca%
guicontrol,, guitextcca5, %cca%
return

;--------------------
nextcca:
;--------------------
if(currentcca<totcca)
	currentcca+=1
else
	currentcca:=1
cca:=region%currentregion%cca%currentcca%
guicontrol,, guitextcca, %cca%
guicontrol,, guitextcca2, %cca%
guicontrol,, guitextcca3, %cca%
guicontrol,, guitextcca4, %cca%
guicontrol,, guitextcca5, %cca%
return

;--------------------
ccaclick:
;--------------------
ccarun:=region%currentregion%ccaclick%currentcca%
run, %ccarun%
return

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
previousstuffgroup:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(currentstuffgroup>1)
	currentstuffgroup-=1
else
	currentstuffgroup:=totstuffgroups
stuffgroup:=stuffgroup%currentstuffgroup%
totstuffs:=stuffgroup%currentstuffgroup%totstuffs
currentstuff:=1
stuff:=stuffgroup%currentstuffgroup%stuff1
guicontrol,, guitextstuffgroup, %stuffgroup%
guicontrol,, guitextstuffgroup2, %stuffgroup%
guicontrol,, guitextstuffgroup3, %stuffgroup%
guicontrol,, guitextstuffgroup4, %stuffgroup%
guicontrol,, guitextstuffgroup5, %stuffgroup%
guicontrol,, guitextstuff, %stuff%
guicontrol,, guitextstuff2, %stuff%
guicontrol,, guitextstuff3, %stuff%
guicontrol,, guitextstuff4, %stuff%
guicontrol,, guitextstuff5, %stuff%
return

;--------------------
nextstuffgroup:
;--------------------
if(currentstuffgroup<totstuffgroups)
	currentstuffgroup+=1
else
	currentstuffgroup:=1
stuffgroup:=stuffgroup%currentstuffgroup%
totstuffs:=stuffgroup%currentstuffgroup%totstuffs
currentstuff:=1
stuff:=stuffgroup%currentstuffgroup%stuff1
guicontrol,, guitextstuffgroup, %stuffgroup%
guicontrol,, guitextstuffgroup2, %stuffgroup%
guicontrol,, guitextstuffgroup3, %stuffgroup%
guicontrol,, guitextstuffgroup4, %stuffgroup%
guicontrol,, guitextstuffgroup5, %stuffgroup%
guicontrol,, guitextstuff, %stuff%
guicontrol,, guitextstuff2, %stuff%
guicontrol,, guitextstuff3, %stuff%
guicontrol,, guitextstuff4, %stuff%
guicontrol,, guitextstuff5, %stuff%
return

;--------------------
previousstuff:
;--------------------
if(currentstuff>1)
	currentstuff-=1
else
	currentstuff:=totstuffs
stuff:=stuffgroup%currentstuffgroup%stuff%currentstuff%
guicontrol,, guitextstuff, %stuff%
guicontrol,, guitextstuff2, %stuff%
guicontrol,, guitextstuff3, %stuff%
guicontrol,, guitextstuff4, %stuff%
guicontrol,, guitextstuff5, %stuff%
return

;--------------------
nextstuff:
;--------------------
if(currentstuff<totstuffs)
	currentstuff+=1
else
	currentstuff:=1
stuff:=stuffgroup%currentstuffgroup%stuff%currentstuff%
guicontrol,, guitextstuff, %stuff%
guicontrol,, guitextstuff2, %stuff%
guicontrol,, guitextstuff3, %stuff%
guicontrol,, guitextstuff4, %stuff%
guicontrol,, guitextstuff5, %stuff%

return

;--------------------
stuffclick:
;--------------------
stuffrun:=stuffgroup%currentstuffgroup%stuffclick%currentstuff%
run, %stuffrun%
return

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ressetup:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
totupres:=5
upres1:="Bye(0pt)"
upres2:="Bye(.5pt)"
upres3:="Bye(1pt)"
upres4:="Wthdrwn(0pt)"
upres5:="Forfeit(0pt)"
return

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;  round data:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
buttonFirstRound:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(currentr<>1)
	{
	blockinput, on
	pswapping:=0
	currentr = 1
	gosub prdc
	gosub uprdc
	gosub wprdc
	gosub bprdc
	blockinput, off
	}
return
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
buttonPrev.Round:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(currentr>1)
	{
	blockinput, on
	currentr -= 1
	pswapping:=0
	gosub prdc
	gosub uprdc
	gosub wprdc
	gosub bprdc
	blockinput, off
	}
return
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
buttonNextRound:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; msgbox, currentr = %currentr%`n`ntottr = %tottr%
if(currentr<tottr)
	{
	blockinput, on
	currentr+= 1
	pswapping:=0
	gosub prdc
	gosub uprdc
	gosub wprdc
	gosub bprdc
	blockinput, off
	return
	}
msgbox,4,,Create a new round?
ifmsgbox, no
	return
blockinput, on
currentr+=1
loop, %tottl%
	{
	i:=a_index
	if(i=1){
		y:=tl1_1 a_tab currentr
		continue
		}
	tl%i%:=tl%i% a_tab "???" a_tab "???" a_tab "???" a_tab "Bye(0pt)"
	y:=y "`n" tl%i%
	}
filedelete, %ct%
fileappend,%y%, %ct%
FileSetAttrib, +h, %ct%
gosub sst
gosub prdc
gosub uprdc
gosub wprdc
gosub bprdc
gosub playerstats
blockinput, off
return

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
buttonLastRound:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(currentr<tottr)
	{
	blockinput, on
	currentr:= tottr
	pswapping:=0
	gosub prdc
	gosub uprdc
	gosub wprdc
	gosub bprdc
	blockinput, off
	}
return

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
buttonUnpairRound:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
z:=tottp-r%currentr%totup
if(z=0)
	{
	msgbox Either I've corrupted the active tournament data file, or I'm not displaying the current tournament file data right, or else there isn't anyone to unpair for this round.
	return
	}
msgbox, 4,, You want me to undo every pairing for round %currentr% ?
IfMsgBox no
	return
blockinput, on
loop, %tottl%
	{
	i:=a_index
	if(i=1)
		continue
	tl%i%_%currentboardfield%:="???"
	tl%i%_%currentoppfield%:="???"
	tl%i%_%currentcfield%:="???"
	tl%i%_%currentresfield%:="Bye(0pt)"
	}
z:=7+tottr*4
loop, %tottl%
	{
	i:=a_index
	if(i=1)
		{
		y:=tl1
		continue
		}
	loop, %z%
		{
		i2:=a_index
		if(i2=1)
			{
			tl%i%:=tl%i%_1
			continue
			}
		tl%i%:=tl%i% a_tab tl%i%_%i2%
		}
	y:=y "`n" tl%i%
	}
filedelete, %ct%
fileappend,%y%, %ct%
FileSetAttrib, +h, %ct%
gosub sst
gosub prdc
gosub uprdc
gosub wprdc
gosub bprdc
gosub playerstats
blockinput, off
return

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ButtonDeleteRound:
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(tottr=1){
	msgbox, I'm NOT going to delete this round for you.`n`nSorry.  I sort of need at least 1 round in every tournament in order to function correctly.
	return
	}
msgbox, 4,, You want round %currentr% to dissapear like a fart in the wind?
IfMsgBox no
	return
blockinput, on
x:=tottr-1
loop, %tottl%
	{
	i:=a_index
	if(i=1){
		y:=tl1_1 a_tab x
		continue
		}
	tl%i%:=tpi%i%
	loop, %tottr%
		{
		r:=a_index
		if(r=currentr)
			continue
		boardfield:=4+4*r
		oppfield:=5+4*r
		cfield:=6+4*r
		resfield:=7+4*r
		tl%i%:=tl%i% a_tab tl%i%_%boardfield% a_tab tl%i%_%oppfield% a_tab tl%i%_%cfield% a_tab tl%i%_%resfield%
		}
	y:=y "`n" tl%i%
	}
filedelete, %ct%
fileappend,%y%, %ct%
FileSetAttrib, +h, %ct%
if(currentr=tottr)
	currentr-=1
gosub sst
gosub prdc
gosub uprdc
gosub wprdc
gosub bprdc
gosub playerstats
blockinput, off
return

;__________________________________________________________________________________________________________________________________________________________________________________________
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
buttonnostress:
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*  autopairs players using the following parameters in order of decending importance:
1.  matches up the players who've:
	1a.  played together the least
	1b.  got the closest points scored.
	1c.  got the closest ratings
2.  assigns colors in the following maner:
	2a.  player who's played black the least gets black
	2b.  players with higher ratings get black if both opponents have previously played black the same amount.
*/
if(currenthup=0)
	{
	msgbox,,,Seems everyone's already paired this round.`nIf you'd like me to autopair anyone I think you might want to unpair them first.`nYou can use the "Unpair Round" button if you'd like to.
	return
	}
msgbox, 4,, Seems you've chosen to autopair this round using NO STRESS pairing.`n`nThis will automatically assign boards, opponents, and colors to all unpaired players in the current round.`n`nShall we proceed?
IfMsgBox no
	return
; blockinput, on
return
loop, %tottl%
	{
	i:=a_index
	if(i=1)
		continue
	tl%i%_%currentboardfield%:="???"
	tl%i%_%currentoppfield%:="???"
	tl%i%_%currentcfield%:="???"
	tl%i%_%currentresfield%:="Bye(0pt)"
	}
z:=7+tottr*4
loop, %tottl%
	{
	i:=a_index
	if(i=1)
		{
		y:=tl1
		continue
		}
	loop, %z%
		{
		i2:=a_index
		if(i2=1)
			{
			tl%i%:=tl%i%_1
			continue
			}
		tl%i%:=tl%i% a_tab tl%i%_%i2%
		}
	y:=y "`n" tl%i%
	}
if(currentr<tottr)
	{
	loop, %tottl%
		{
		i:=a_index
		if(i=1){
			y:=tl1
			continue
			}
		tl%i%:=tpi%i%
		loop, %tottr%
			{
			r:=a_index
			if(r=currentr)
				{
				
				continue
				}
			if(r>currentr)
				continue
			boardfield:=4+4*r
			oppfield:=5+4*r
			cfield:=6+4*r
			resfield:=7+4*r
			tl%i%:=tl%i% a_tab tl%i%_%boardfield% a_tab tl%i%_%oppfield% a_tab tl%i%_%cfield% a_tab tl%i%_%resfield%
			}
		y:=y "`n" tl%i%
		}
	}
filedelete, %ct%
fileappend,%y%, %ct%
FileSetAttrib, +h, %ct%
gosub sst
gosub prdc
gosub uprdc
gosub wprdc
gosub bprdc
gosub playerstats
; blockinput, off
return
			
return
;__________________________________________________________________________________________________________________________________________________________________________________________
upres1:
;--------------------
click:="left"
y:=(currentupdisplay*20)-19
goto upres
;--------------------
upres2:
;--------------------
click:="left"
y:=(currentupdisplay*20)-18
goto upres
;--------------------
upres3:
;--------------------
click:="left"
y:=(currentupdisplay*20)-17
goto upres
;--------------------
upres4:
;--------------------
click:="left"
y:=(currentupdisplay*20)-16
goto upres
;--------------------
upres5:
;--------------------
click:="left"
y:=(currentupdisplay*20)-15
goto upres
;--------------------
upres6:
;--------------------
click:="left"
y:=(currentupdisplay*20)-14
goto upres
;--------------------
upres7:
;--------------------
click:="left"
y:=(currentupdisplay*20)-13
goto upres
;--------------------
upres8:
;--------------------
click:="left"
y:=(currentupdisplay*20)-12
goto upres
;--------------------
upres9:
;--------------------
click:="left"
y:=(currentupdisplay*20)-11
goto upres
;--------------------
upres10:
;--------------------
click:="left"
y:=(currentupdisplay*20)-10
goto upres
;--------------------
upres11:
;--------------------
click:="left"
y:=(currentupdisplay*20)-9
goto upres
;--------------------
upres12:
;--------------------
click:="left"
y:=(currentupdisplay*20)-8
goto upres
;--------------------
upres13:
;--------------------
click:="left"
y:=(currentupdisplay*20)-7
goto upres
;--------------------
upres14:
;--------------------
click:="left"
y:=(currentupdisplay*20)-6
goto upres
;--------------------
upres15:
;--------------------
click:="left"
y:=(currentupdisplay*20)-5
goto upres
;--------------------
upres16:
;--------------------
click:="left"
y:=(currentupdisplay*20)-4
goto upres
;--------------------
upres17:
;--------------------
click:="left"
y:=(currentupdisplay*20)-3
goto upres
;--------------------
upres18:
;--------------------
click:="left"
y:=(currentupdisplay*20)-2
goto upres
;--------------------
upres19:
;--------------------
click:="left"
y:=(currentupdisplay*20)-1
goto upres
;--------------------
upres20:
;--------------------
click:="left"
y:=(currentupdisplay*20)
goto upres
;--------------------
RButton::
;--------------------
click:="right"
mousegetpos,,,,z
if(z="Static94")
	{
	y:=(currentupdisplay*20)-19
	goto upres
	}
if(z="Static95")
	{
	y:=(currentupdisplay*20)-18
	goto upres
	}
if(z="Static96")
	{
	y:=(currentupdisplay*20)-17
	goto upres
	}
if(z="Static97")
	{
	y:=(currentupdisplay*20)-16
	goto upres
	}
if(z="Static98")
	{
	y:=(currentupdisplay*20)-15
	goto upres
	}
if(z="Static99")
	{
	y:=(currentupdisplay*20)-14
	goto upres
	}
if(z="Static100")
	{
	y:=(currentupdisplay*20)-13
	goto upres
	}
if(z="Static101")
	{
	y:=(currentupdisplay*20)-12
	goto upres
	}
if(z="Static102")
	{
	y:=(currentupdisplay*20)-11
	goto upres
	}
if(z="Static103")
	{
	y:=(currentupdisplay*20)-10
	goto upres
	}
if(z="Static104")
	{
	y:=(currentupdisplay*20)-9
	goto upres
	}
if(z="Static105")
	{
	y:=(currentupdisplay*20)-8
	goto upres
	}
if(z="Static106")
	{
	y:=(currentupdisplay*20)-7
	goto upres
	}
if(z="Static107")
	{
	y:=(currentupdisplay*20)-6
	goto upres
	}
if(z="Static108")
	{
	y:=(currentupdisplay*20)-5
	goto upres
	}
if(z="Static109")
	{
	y:=(currentupdisplay*20)-4
	goto upres
	}
if(z="Static110")
	{
	y:=(currentupdisplay*20)-3
	goto upres
	}
if(z="Static111")
	{
	y:=(currentupdisplay*20)-2
	goto upres
	}
if(z="Static112")
	{
	y:=(currentupdisplay*20)-1
	goto upres
	}
if(z="Static113")
	{
	y:=(currentupdisplay*20)
	goto upres
	}
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(z="Static154")
	{
	y:=(currentboarddisplay*20)-19
	goto wpres
	}
if(z="Static155")
	{
	y:=(currentboarddisplay*20)-18
	goto wpres
	}
if(z="Static156")
	{
	y:=(currentboarddisplay*20)-17
	goto wpres
	}
if(z="Static157")
	{
	y:=(currentboarddisplay*20)-16
	goto wpres
	}
if(z="Static158")
	{
	y:=(currentboarddisplay*20)-15
	goto wpres
	}
if(z="Static159")
	{
	y:=(currentboarddisplay*20)-14
	goto wpres
	}
if(z="Static160")
	{
	y:=(currentboarddisplay*20)-13
	goto wpres
	}
if(z="Static161")
	{
	y:=(currentboarddisplay*20)-12
	goto wpres
	}
if(z="Static162")
	{
	y:=(currentboarddisplay*20)-11
	goto wpres
	}
if(z="Static163")
	{
	y:=(currentboarddisplay*20)-10
	goto wpres
	}
if(z="Static164")
	{
	y:=(currentboarddisplay*20)-9
	goto wpres
	}
if(z="Static165")
	{
	y:=(currentboarddisplay*20)-8
	goto wpres
	}
if(z="Static166")
	{
	y:=(currentboarddisplay*20)-7
	goto wpres
	}
if(z="Static167")
	{
	y:=(currentboarddisplay*20)-6
	goto wpres
	}
if(z="Static168")
	{
	y:=(currentboarddisplay*20)-5
	goto wpres
	}
if(z="Static169")
	{
	y:=(currentboarddisplay*20)-4
	goto wpres
	}
if(z="Static170")
	{
	y:=(currentboarddisplay*20)-3
	goto wpres
	}
if(z="Static171")
	{
	y:=(currentboarddisplay*20)-2
	goto wpres
	}
if(z="Static172")
	{
	y:=(currentboarddisplay*20)-1
	goto wpres
	}
if(z="Static173")
	{
	y:=(currentboarddisplay*20)
	goto wpres
	}
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(z="Static194")
	{
	y:=(currentboarddisplay*20)-19
	goto bpres
	}
if(z="Static195")
	{
	y:=(currentboarddisplay*20)-18
	goto bpres
	}
if(z="Static196")
	{
	y:=(currentboarddisplay*20)-17
	goto bpres
	}
if(z="Static197")
	{
	y:=(currentboarddisplay*20)-16
	goto bpres
	}
if(z="Static198")
	{
	y:=(currentboarddisplay*20)-15
	goto bpres
	}
if(z="Static199")
	{
	y:=(currentboarddisplay*20)-14
	goto bpres
	}
if(z="Static200")
	{
	y:=(currentboarddisplay*20)-13
	goto bpres
	}
if(z="Static201")
	{
	y:=(currentboarddisplay*20)-12
	goto bpres
	}
if(z="Static202")
	{
	y:=(currentboarddisplay*20)-11
	goto bpres
	}
if(z="Static203")
	{
	y:=(currentboarddisplay*20)-10
	goto bpres
	}
if(z="Static204")
	{
	y:=(currentboarddisplay*20)-9
	goto bpres
	}
if(z="Static205")
	{
	y:=(currentboarddisplay*20)-8
	goto bpres
	}
if(z="Static206")
	{
	y:=(currentboarddisplay*20)-7
	goto bpres
	}
if(z="Static207")
	{
	y:=(currentboarddisplay*20)-6
	goto bpres
	}
if(z="Static208")
	{
	y:=(currentboarddisplay*20)-5
	goto bpres
	}
if(z="Static209")
	{
	y:=(currentboarddisplay*20)-4
	goto bpres
	}
if(z="Static210")
	{
	y:=(currentboarddisplay*20)-3
	goto bpres
	}
if(z="Static211")
	{
	y:=(currentboarddisplay*20)-2
	goto bpres
	}
if(z="Static212")
	{
	y:=(currentboarddisplay*20)-1
	goto bpres
	}
if(z="Static213")
	{
	y:=(currentboarddisplay*20)
	goto bpres
	}
else
	{
suspend, on
sendinput, {rbutton}
suspend, off
	}
return

;_____________________________________________________________________________________________________________________________________________________________________________
upres:
;_____________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(newupdisplayres%y%="")
	return
blockinput, on
if(newupdisplayres%y%="Bye(0pt)")
	currentupres:=1
if(newupdisplayres%y%="Bye(.5pt)")
	currentupres:=2
if(newupdisplayres%y%="Bye(1pt)")
	currentupres:=3
if(newupdisplayres%y%="Wthdrwn(0pt)")
	currentupres:=4
if(newupdisplayres%y%="Forfeit(0pt)")
	currentupres:=5
if(click="left")
	{
	if(currentupres<totupres)
		currentupres+=1
	else
		currentupres:=1
	newres:=upres%currentupres%
	}
else	{
	if(currentupres>1)
		currentupres-=1
	else
		currentupres:=totupres
	newres:=upres%currentupres%
	}
uptl:=y+1
tl%uptl%_%currentresfield%:=newres
; msgbox,% "currentupres = " currentupres "`n`nupres%currentupres% = " upres%currentupres% "`n`nupx = " upx "`n`ncurrentresfield = " currentresfield "`n`nnewres = " %newres%

z:=7+4*tottr
loop, %tottl%
	{
	i:=a_index
	if(i=1)
		{
		y:=tl%i%
		continue
		}
	if(i=uptl)
		{
		loop, %z%
			{
			z:=a_index
			if(z=1)
				{
				y:=y "`n" tl%uptl%_1
				continue
				}
			y:=y a_tab tl%uptl%_%z%
			}
		}
	else
		y:=y "`n"tl%i%
	}
filedelete, %ct%
fileappend, %y%, %ct%
FileSetAttrib, +h, %ct%
gosub sst
gosub uprdc
gosub playerstats
blockinput, off
return

;_____________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp1:	
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname1
bpx:=""
y:=(currentupdisplay*20)-19
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp2:	
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname2
bpx:=""
y:=(currentupdisplay*20)-18
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp3:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname3
bpx:=""
y:=(currentupdisplay*20)-17
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp4:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname4
bpx:=""
y:=(currentupdisplay*20)-16
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp5:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname5
bpx:=""
y:=(currentupdisplay*20)-15
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp6:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname6
bpx:=""
y:=(currentupdisplay*20)-14
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp7:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname7
bpx:=""
y:=(currentupdisplay*20)-13
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp8:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname8
bpx:=""
y:=(currentupdisplay*20)-12
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp9:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname9
bpx:=""
y:=(currentupdisplay*20)-11
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp10:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname10
bpx:=""
y:=(currentupdisplay*20)-10
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp11:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname11
bpx:=""
y:=(currentupdisplay*20)-9
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp12:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname12
bpx:=""
y:=(currentupdisplay*20)-8
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp13:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname13
bpx:=""
y:=(currentupdisplay*20)-7
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp14:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname14
bpx:=""
y:=(currentupdisplay*20)-6
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp15:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname15
bpx:=""
y:=(currentupdisplay*20)-5
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp16:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname16
bpx:=""
y:=(currentupdisplay*20)-4
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp17:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname17
bpx:=""
y:=(currentupdisplay*20)-3
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp18:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname18
bpx:=""
y:=(currentupdisplay*20)-2
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp19:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname19
bpx:=""
y:=(currentupdisplay*20)-1
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptowp20:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname20
bpx:=""
y:=(currentupdisplay*20)
goto, towp
;__________________________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp1:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname1
upx:=""
y:=(currentboarddisplay*20)-19
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp2:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname2
upx:=""
y:=(currentboarddisplay*20)-18
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp3:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname3
upx:=""
y:=(currentboarddisplay*20)-17
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp4:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname4
upx:=""
y:=(currentboarddisplay*20)-16
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp5:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname5
upx:=""
y:=(currentboarddisplay*20)-15
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp6:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname6
upx:=""
y:=(currentboarddisplay*20)-14
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp7:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname7
upx:=""
y:=(currentboarddisplay*20)-13
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp8:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname8
upx:=""
y:=(currentboarddisplay*20)-12
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp9:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname9
upx:=""
y:=(currentboarddisplay*20)-11
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp10:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname10
upx:=""
y:=(currentboarddisplay*20)-10
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp11:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname11
upx:=""
y:=(currentboarddisplay*20)-9
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp12:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname12
upx:=""
y:=(currentboarddisplay*20)-8
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp13:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname13
upx:=""
y:=(currentboarddisplay*20)-7
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp14:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname14
upx:=""
y:=(currentboarddisplay*20)-6
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp15:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname15
upx:=""
y:=(currentboarddisplay*20)-5
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp16:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname16
upx:=""
y:=(currentboarddisplay*20)-4
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp17:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname17
upx:=""
y:=(currentboarddisplay*20)-3
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp18:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname18
upx:=""
y:=(currentboarddisplay*20)-2
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp19:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname19
upx:=""
y:=(currentboarddisplay*20)-1
goto, towp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptowp20:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname20
upx:=""
y:=(currentboarddisplay*20)
goto, towp
;__________________________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
towp:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(upx="" and bpx="")
	return
 blockinput, on
newopp:=""
if(bpx=""){
	tlx:=newupdisplaytl%y%
	oldopp:=""
	}
else	{
	tlx:=newbpdisplaytl%y%
	if(tl%tlx%_%currentoppfield%<>"???"){
		oldopp:=tl%tlx%_%currentoppfield%
		tl%oldopp%_%currentoppfield%:="???"
		}
	}
tl%tlx%_%currentoppfield%:="???"
if(tl%tlx%_%currentresfield%="Bye(0pt)" or tl%tlx%_%currentresfield%= "Bye(.5pt)" or tl%tlx%_%currentresfield% = "Bye(1pt)" or tl%tlx%_%currentresfield% = "Wthdrwn(0pt)" or tl%tlx%_%currentresfield% = "Forfeit(0pt)")
	tl%tlx%_%currentresfield%:="???"
; msgbox,% "tl" tlx "_" currentoppfield " = " tl%tlx%_%currentoppfield% "`n`ntl" tlx "_" currentresfield " = " tl%tlx%_%currentresfield%
z:=currenthwb+1
loop, %z%
	{
	i:=a_index
	potentialboard%i%:=1
	loop, %tottl%
		{
		i2:=a_index
		if(i2=1)
			continue
		if(tl%i2%_%currentboardfield%=i)
			{
			if (tl%i2%_%currentcfield%="white"){
				potentialboard%i%:=0
			;	msgbox,% "tlx = " tlx "`n`nnamex = "namex "`n`nround " currentr " currenthwb = " currenthwb "`n`nz = " z "`n`n`n`ntl%tlx%_%currentoppfield% = " tl%tlx%_%currentoppfield% "`n`nopp = " opp "`n`ntl%opp%_%currentoppfield% = " tl%opp%_%currentoppfield% "`n`n`n`ni = " i a_tab "i2 = " i2 "`n`ntl%i2%_%currentboardfield% = " tl%i2%_%currentboardfield% "`n`ntl%i2%_%currentcfield% = " tl%i2%_%currentcfield% "`n`npotentialboard%i% = " potentialboard%i%
				continue
				}
			}
		}
	if(potentialboard%i%=1)
		{
	;	msgbox,% "the first board with an open spot for a white player is: " i
		boardx:=i
		loop, %tottl%
			{
			i3:=a_index
			if(i3=1)
				continue
			if(tl%i3%_%currentboardfield%=boardx and i3<>tlx){
				newopp:=i3
				tl%tlx%_%currentoppfield%:=newopp
				tl%newopp%_%currentoppfield%:=tlx
				if(tl%i3%_%currentresfield%="won")	
					tl%tlx%_%currentresfield%:="lost"
				if(tl%i3%_%currentresfield%="lost")
					tl%tlx%_%currentresfield%:="won"
				if(tl%i3%_%currentresfield%="drew")s
					tl%tlx%_%currentresfield%:="drew"
			;	msgbox,% "currentboardfield = " currentboardfield "`n`ncurrentresfield = " currentresfield "`n`ntl%tlx%_%currentresfield%:= " tl%tlx%_%currentresfield%
				}
			}
		break
		}
	}
tl%tlx%_%currentcfield%:="white"
tl%tlx%_%currentboardfield%:=boardx
; msgbox,% "tlx = " tlx "`n`noldopp = " oldopp "`n`nnewopp = " newopp "`n`ntl1 = " tl1_1 a_tab tl1_2 "`n`ntl2 = " tl2_1 a_tab tl2_2 a_tab tl2_3 a_tab tl2_4 a_tab tl2_5 a_tab tl2_6 a_tab tl2_7 a_tab tl2_8 a_tab tl2_9 a_tab tl2_10 a_tab tl2_11 a_tab tl2_12 a_tab tl2_13 a_tab tl2_14 a_tab tl2_15 "`n`ntl3 = " tl3_1 a_tab tl3_2 a_tab tl3_3 a_tab tl3_4 a_tab tl3_5 a_tab tl3_6 a_tab tl3_7 a_tab tl3_8 a_tab tl3_9 a_tab tl3_10 a_tab tl3_11 a_tab tl3_12 a_tab tl3_13 a_tab tl3_14 a_tab tl3_15
loop, %tottl%
	{
	i:=a_index
	if(i=1)	{
		y:=tl1
		continue
		}
	if(i=tlx or i=oldopp or i=newopp)
		{
	;	msgbox, i = %i%
		loop, %tottfields%
			{
			f:=a_index
			if(f=1)	{
				y:=y "`n" tl%i%_1
				continue
				}
			y:=y a_tab tl%i%_%f%
			}
		continue
		}
	y:=y "`n" tl%i%
	}
; msgbox, y = %y%
filedelete, %ct%
fileappend,%y%, %ct%
FileSetAttrib, +h, %ct%
gosub sst
gosub prdc
gosub uprdc
gosub bprdc
gosub wprdc
gosub playerstats
 blockinput, off
return

;_____________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp1:	
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname1
wpx:=""
y:=(currentupdisplay*20)-19
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp2:	
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname2
wpx:=""
y:=(currentupdisplay*20)-18
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp3:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname3
wpx:=""
y:=(currentupdisplay*20)-17
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp4:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname4
wpx:=""
y:=(currentupdisplay*20)-16
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp5:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname5
wpx:=""
y:=(currentupdisplay*20)-15
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp6:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname6
wpx:=""
y:=(currentupdisplay*20)-14
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp7:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname7
wpx:=""
y:=(currentupdisplay*20)-13
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp8:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname8
wpx:=""
y:=(currentupdisplay*20)-12
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp9:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname9
wpx:=""
y:=(currentupdisplay*20)-11
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp10:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname10
wpx:=""
y:=(currentupdisplay*20)-10
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp11:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname11
wpx:=""
y:=(currentupdisplay*20)-9
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp12:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname12
wpx:=""
y:=(currentupdisplay*20)-8
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp13:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname13
wpx:=""
y:=(currentupdisplay*20)-7
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp14:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname14
wpx:=""
y:=(currentupdisplay*20)-6
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp15:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname15
wpx:=""
y:=(currentupdisplay*20)-5
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp16:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname16
wpx:=""
y:=(currentupdisplay*20)-4
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp17:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname17
wpx:=""
y:=(currentupdisplay*20)-3
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp18:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname18
wpx:=""
y:=(currentupdisplay*20)-2
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp19:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname19
wpx:=""
y:=(currentupdisplay*20)-1
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
uptobp20:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, upx,,upname20
wpx:=""
y:=(currentupdisplay*20)
goto, tobp
;__________________________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp1:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname1
upx:=""
y:=(currentboarddisplay*20)-19
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp2:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname2
upx:=""
y:=(currentboarddisplay*20)-18
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp3:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname3
upx:=""
y:=(currentboarddisplay*20)-17
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp4:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname4
upx:=""
y:=(currentboarddisplay*20)-16
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp5:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname5
upx:=""
y:=(currentboarddisplay*20)-15
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp6:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname6
upx:=""
y:=(currentboarddisplay*20)-14
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp7:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname7
upx:=""
y:=(currentboarddisplay*20)-13
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp8:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname8
upx:=""
y:=(currentboarddisplay*20)-12
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp9:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname9
upx:=""
y:=(currentboarddisplay*20)-11
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp10:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname10
upx:=""
y:=(currentboarddisplay*20)-10
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp11:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname11
upx:=""
y:=(currentboarddisplay*20)-9
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp12:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname12
upx:=""
y:=(currentboarddisplay*20)-8
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp13:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname13
upx:=""
y:=(currentboarddisplay*20)-7
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp14:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname14
upx:=""
y:=(currentboarddisplay*20)-6
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp15:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname15
upx:=""
y:=(currentboarddisplay*20)-5
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp16:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname16
upx:=""
y:=(currentboarddisplay*20)-4
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp17:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname17
upx:=""
y:=(currentboarddisplay*20)-3
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp18:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname18
upx:=""
y:=(currentboarddisplay*20)-2
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp19:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname19
upx:=""
y:=(currentboarddisplay*20)-1
goto, tobp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptobp20:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname20
upx:=""
y:=(currentboarddisplay*20)
goto, tobp
;__________________________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
tobp:
;__________________________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(upx="" and wpx="")
	return
blockinput, on
newopp:=""
if(wpx=""){
	tlx:=newupdisplaytl%y%
	oldopp:=""
	}
else	{
	tlx:=newwpdisplaytl%y%
	if(tl%tlx%_%currentoppfield%<>"???"){
		oldopp:=tl%tlx%_%currentoppfield%
		tl%oldopp%_%currentoppfield%:="???"
		}
	}
tl%tlx%_%currentoppfield%:="???"
if(tl%tlx%_%currentresfield%="Bye(0pt)" or tl%tlx%_%currentresfield%= "Bye(.5pt)" or tl%tlx%_%currentresfield% = "Bye(1pt)" or tl%tlx%_%currentresfield% = "Wthdrwn(0pt)" or tl%tlx%_%currentresfield% = "Forfeit(0pt)")
	tl%tlx%_%currentresfield%:="???"
; msgbox,% "tl" tlx "_" currentoppfield " = " tl%tlx%_%currentoppfield% "`n`ntl" tlx "_" currentresfield " = " tl%tlx%_%currentresfield%
z:=currenthbb+1
loop, %z%
	{
	i:=a_index
	potentialboard%i%:=1
	loop, %tottl%
		{
		i2:=a_index
		if(i2=1)
			continue
		if(tl%i2%_%currentboardfield%=i)
			{
			if (tl%i2%_%currentcfield%="black"){
				potentialboard%i%:=0
			;	msgbox,% "tlx = " tlx "`n`nnamex = "namex "`n`nround " currentr " currenthwb = " currenthwb "`n`nz = " z "`n`n`n`ntl%tlx%_%currentoppfield% = " tl%tlx%_%currentoppfield% "`n`nopp = " opp "`n`ntl%opp%_%currentoppfield% = " tl%opp%_%currentoppfield% "`n`n`n`ni = " i a_tab "i2 = " i2 "`n`ntl%i2%_%currentboardfield% = " tl%i2%_%currentboardfield% "`n`ntl%i2%_%currentcfield% = " tl%i2%_%currentcfield% "`n`npotentialboard%i% = " potentialboard%i%
				continue
				}
			}
		}
	if(potentialboard%i%=1)
		{
	;	msgbox,% "the first board with an open spot for a black player is: " i
		boardx:=i
		loop, %tottl%
			{
			i3:=a_index
			if(i3=1)
				continue
			if(tl%i3%_%currentboardfield%=boardx and i3<>tlx){
				newopp:=i3
				tl%tlx%_%currentoppfield%:=newopp
				tl%newopp%_%currentoppfield%:=tlx
				if(tl%i3%_%currentresfield%="won")	
					tl%tlx%_%currentresfield%:="lost"
				if(tl%i3%_%currentresfield%="lost")
					tl%tlx%_%currentresfield%:="won"
				if(tl%i3%_%currentresfield%="drew")s
					tl%tlx%_%currentresfield%:="drew"
			;	msgbox,% "currentboardfield = " currentboardfield "`n`ncurrentresfield = " currentresfield "`n`ntl%tlx%_%currentresfield%:= " tl%tlx%_%currentresfield%
				}
			}
		break
		}
	}
tl%tlx%_%currentcfield%:="black"
tl%tlx%_%currentboardfield%:=boardx
z:=7+tottr*4
; msgbox,% "tlx = " tlx "`n`noldopp = " oldopp "`n`nnewopp = " newopp "`n`ntl1 = " tl1_1 a_tab tl1_2 "`n`ntl2 = " tl2_1 a_tab tl2_2 a_tab tl2_3 a_tab tl2_4 a_tab tl2_5 a_tab tl2_6 a_tab tl2_7 a_tab tl2_8 a_tab tl2_9 a_tab tl2_10 a_tab tl2_11 a_tab tl2_12 a_tab tl2_13 a_tab tl2_14 a_tab tl2_15 "`n`ntl3 = " tl3_1 a_tab tl3_2 a_tab tl3_3 a_tab tl3_4 a_tab tl3_5 a_tab tl3_6 a_tab tl3_7 a_tab tl3_8 a_tab tl3_9 a_tab tl3_10 a_tab tl3_11 a_tab tl3_12 a_tab tl3_13 a_tab tl3_14 a_tab tl3_15
loop, %tottl%
	{
	i:=a_index
	if(i=1)	{
		y:=tl1
		continue
		}
	if(i=tlx or i=oldopp or i=newopp)
		{
	;	msgbox, i = %i%
		loop, %z%
			{
			z:=a_index
			if(z=1)	{
				y:=y "`n" tl%i%_1
				continue
				}
			y:=y a_tab tl%i%_%z%
			}
		continue
		}
	y:=y "`n" tl%i%
	}
; msgbox, y = %y%
filedelete, %ct%
fileappend,%y%, %ct%
FileSetAttrib, +h, %ct%
gosub sst
gosub prdc
gosub uprdc
gosub wprdc
gosub bprdc
gosub playerstats
blockinput, off
return

;__________________________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup1:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname1
wpx:=""
y:=(currentboarddisplay*20)-19
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup2:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname2
wpx:=""
y:=(currentboarddisplay*20)-18
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup3:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname3
wpx:=""
y:=(currentboarddisplay*20)-17
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup4:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname4
wpx:=""
y:=(currentboarddisplay*20)-16
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup5:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname5
wpx:=""
y:=(currentboarddisplay*20)-15
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup6:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname6
wpx:=""
y:=(currentboarddisplay*20)-14
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup7:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname7
wpx:=""
y:=(currentboarddisplay*20)-13
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup8:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname8
wpx:=""
y:=(currentboarddisplay*20)-12
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup9:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname9
wpx:=""
y:=(currentboarddisplay*20)-11
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup10:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname10
wpx:=""
y:=(currentboarddisplay*20)-10
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup11:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname11
wpx:=""
y:=(currentboarddisplay*20)-9
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup12:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname12
wpx:=""
y:=(currentboarddisplay*20)-8
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup13:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname13
wpx:=""
y:=(currentboarddisplay*20)-7
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup14:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname14
wpx:=""
y:=(currentboarddisplay*20)-6
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup15:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname15
wpx:=""
y:=(currentboarddisplay*20)-5
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup16:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname16
wpx:=""
y:=(currentboarddisplay*20)-4
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup17:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname17
wpx:=""
y:=(currentboarddisplay*20)-3
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup18:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname18
wpx:=""
y:=(currentboarddisplay*20)-2
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup19:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname19
wpx:=""
y:=(currentboarddisplay*20)-1
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bptoup20:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, bpx,,bpname20
wpx:=""
y:=(currentboarddisplay*20)
goto, toup
;__________________________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup1:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname1
bpx:=""
y:=(currentboarddisplay*20)-19
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup2:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname2
bpx:=""
y:=(currentboarddisplay*20)-18
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup3:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname3
bpx:=""
y:=(currentboarddisplay*20)-17
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup4:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname4
bpx:=""
y:=(currentboarddisplay*20)-16
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup5:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname5
bpx:=""
y:=(currentboarddisplay*20)-15
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup6:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname6
bpx:=""
y:=(currentboarddisplay*20)-14
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup7:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname7
bpx:=""
y:=(currentboarddisplay*20)-13
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup8:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname8
bpx:=""
y:=(currentboarddisplay*20)-12
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup9:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname9
bpx:=""
y:=(currentboarddisplay*20)-11
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup10:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname10
bpx:=""
y:=(currentboarddisplay*20)-10
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup11:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname11
bpx:=""
y:=(currentboarddisplay*20)-9
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup12:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname12
bpx:=""
y:=(currentboarddisplay*20)-8
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup13:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname13
bpx:=""
y:=(currentboarddisplay*20)-7
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup14:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname14
bpx:=""
y:=(currentboarddisplay*20)-6
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup15:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname15
bpx:=""
y:=(currentboarddisplay*20)-5
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup16:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname16
bpx:=""
y:=(currentboarddisplay*20)-4
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup17:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname17
bpx:=""
y:=(currentboarddisplay*20)-3
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup18:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname18
bpx:=""
y:=(currentboarddisplay*20)-2
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup19:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname19
bpx:=""
y:=(currentboarddisplay*20)-1
goto, toup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wptoup20:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
guicontrolget, wpx,,wpname20
bpx:=""
y:=(currentboarddisplay*20)
goto, toup
;__________________________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
toup:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(bpx="" and wpx="")
	return
blockinput, on
oldopp:=""
if(wpx=""){
	tlx:=newbpdisplaytl%y%
	if(tl%tlx%_%currentoppfield%<>"???"){
		oldopp:=tl%tlx%_%currentoppfield%
		tl%oldopp%_%currentoppfield%:="???"
		}
	}
else	{
	tlx:=newwpdisplaytl%y%
	if(tl%tlx%_%currentoppfield%<>"???"){
		oldopp:=tl%tlx%_%currentoppfield%
		tl%oldopp%_%currentoppfield%:="???"
		}
	}
tl%tlx%_%currentboardfield%:="???"
tl%tlx%_%currentoppfield%:="???"
tl%tlx%_%currentcfield%:="???"
tl%tlx%_%currentresfield%:="Bye(0pt)"
z:=7+tottr*4
loop, %tottl%
	{
	i:=a_index
	if(i=1)	{
		y:=tl1
		continue
		}
	if(i=tlx or i=oldopp)
		{
	;	msgbox, i = %i%
		loop, %z%
			{
			z:=a_index
			if(z=1)	{
				y:=y "`n" tl%i%_1
				continue
				}
			y:=y a_tab tl%i%_%z%
			}
		continue
		}
	y:=y "`n" tl%i%
	}
; msgbox, y = %y%
filedelete, %ct%
fileappend,%y%, %ct%
FileSetAttrib, +h, %ct%
gosub sst
gosub prdc
gosub uprdc
gosub wprdc
gosub bprdc
gosub playerstats
blockinput, off
return

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown1:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-19
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown2:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-18
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown3:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-17
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown4:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-16
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown5:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-15
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown6:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-14
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown7:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-13
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown8:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-12
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown9:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-11
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown10:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-10
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown11:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-9
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown12:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-8
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown13:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-7
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown14:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-6
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown15:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-5
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown16:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-4
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown17:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-3
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown18:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-2
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown19:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-1
goto, wpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown20:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)
goto, wpdown
;_____________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpdown:
;_____________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(newwpdisplayname%y%="")
	return
blockinput, on
potentialboards:=currenthwb+1
wtl:=newwpdisplaytl%y%
board:=y
oldopp:=""
oldopp:=tl%wtl%_%currentoppfield%
if(oldopp<>"???" and oldopp<>"")
	{
	tl%oldopp%_%currentoppfield%:="???"
	tl%wtl%_%currentoppfield%:="???"
	}
loop, %potentialboards%
	{
	i:=a_index
	if(i<=board)
		continue
	potentialboard%i%:=1
;	msgbox,% "potentialboard%i% = " potentialboard%i%
	loop, %tottl%
		{
		i2:=a_index
		if(i2=1)
			continue
		if(tl%i2%_%currentboardfield%=i and tl%i2%_%currentcfield%="white")
			{
			potentialboard%i%:=0
			continue
			}
		if(i2=tottl and potentialboard%i%=1)	
			{
			tl%wtl%_%currentboardfield%:=i
			loop, %tottl%
				{
				i3:=a_index
				if(i3=1)
					continue
				if(tl%i3%_%currentboardfield%=i and tl%i3%_%currentcfield%="black")
					{
					tl%wtl%_%currentoppfield%:=i3
					tl%i3%_%currentoppfield%:=wtl
					if(tl%i3%_%currentresfield%="won")
						tl%wtl%_%currentresfield%:="lost"
					if(tl%i3%_%currentresfield%="lost")
						tl%wtl%_%currentresfield%:="won"
					if(tl%i3%_%currentresfield%="drew")
						tl%wtl%_%currentresfield%:="drew"
					if(tl%i3%_%currentresfield%="???")
						tl%wtl%_%currentresfield%:="???"
					}
				}
			goto wpdownpt2
			}
		}
	}
wpdownpt2:
gosub af
; msgbox, y = %y%
filedelete, %ct%
fileappend,%y%, %ct%
FileSetAttrib, +h, %ct%
gosub sst
gosub prdc
gosub uprdc
gosub wprdc
gosub bprdc
gosub playerstats
blockinput, off
return

;_____________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown1:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-19
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown2:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-18
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown3:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-17
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown4:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-16
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown5:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-15
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown6:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-14
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown7:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-13
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown8:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-12
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown9:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-11
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown10:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-10
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown11:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-9
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown12:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-8
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown13:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-7
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown14:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-6
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown15:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-5
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown16:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-4
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown17:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-3
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown18:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-2
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown19:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-1
goto, bpdown
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown20:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)
goto, bpdown
;__________________________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpdown:
;__________________________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(newbpdisplayname%y%="")
	return
blockinput, on
potentialboards:=currenthbb+1
btl:=newbpdisplaytl%y%
board:=y
oldopp:=""
oldopp:=tl%btl%_%currentoppfield%
if(oldopp<>"???" and oldopp<>"")
	{
	tl%oldopp%_%currentoppfield%:="???"
	tl%btl%_%currentoppfield%:="???"
	}
loop, %potentialboards%
	{
	i:=a_index
	if(i<=board)
		continue
	potentialboard%i%:=1
;	msgbox,% "potentialboard%i% = " potentialboard%i%
	loop, %tottl%
		{
		i2:=a_index
		if(i2=1)
			continue
		if(tl%i2%_%currentboardfield%=i and tl%i2%_%currentcfield%="black")
			{
			potentialboard%i%:=0
			continue
			}
		if(i2=tottl and potentialboard%i%=1)	
			{
			tl%btl%_%currentboardfield%:=i
			loop, %tottl%
				{
				i3:=a_index
				if(i3=1)
					continue
				if(tl%i3%_%currentboardfield%=i and tl%i3%_%currentcfield%="white")
					{
					tl%btl%_%currentoppfield%:=i3
					tl%i3%_%currentoppfield%:=btl
					if(tl%i3%_%currentresfield%="won")
						tl%btl%_%currentresfield%:="lost"
					if(tl%i3%_%currentresfield%="lost")
						tl%btl%_%currentresfield%:="won"
					if(tl%i3%_%currentresfield%="drew")
						tl%btl%_%currentresfield%:="drew"
					if(tl%i3%_%currentresfield%="???")
						tl%btl%_%currentresfield%:="???"
					}
				}
			goto bpdownpt2
			}
		}
	}
bpdownpt2:
gosub af
; msgbox, y = %y%
filedelete, %ct%
fileappend,%y%, %ct%
FileSetAttrib, +h, %ct%
gosub sst
gosub prdc
gosub uprdc
gosub wprdc
gosub bprdc
gosub playerstats
blockinput, off
return

;__________________________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup1:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-19
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup2:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-18
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup3:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-17
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup4:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-16
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup5:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-15
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup6:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-14
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup7:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-13
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup8:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-12
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup9:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-11
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup10:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-10
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup11:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-9
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup12:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-8
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup13:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-7
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup14:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-6
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup15:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-5
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup16:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-4
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup17:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-3
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup18:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-2
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup19:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-1
goto, wpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpup20:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)
goto, wpup
;____________________________________________________________________________________________________________________________________________________________________________
wpup:
;_____________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(newwpdisplayname%y%="")
	return
wtl:=newwpdisplaytl%y%
boardsearch:=y-1
; msgbox,,, boardsearch = %boardsearch%`n`ntestboardsearch = %testboardsearch%
if(boardsearch=0)
	return
blockinput, on
y:=0
; msgbox,,,% "boardsearch = " boardsearch
loop, %boardsearch%
	{
	i:=a_index
	potentialboard%i%=1
	loop, %tottl%
		{
		i2:=a_index
		if(i2=1)
			continue
		if(tl%i2%_%currentboardfield%=i and tl%i2%_%currentcfield%="white")
			{
			potentialboard%i%:=0
			}
		if(i2=tottl and potentialboard%i%=1)
			{
			x:=i
			if(x>y)
				{
				y:=x
				}
			}
		if(i=boardsearch and i2=tottl and y>0)
			{
			opp:=tl%wtl%_%currentoppfield%
			tl%wtl%_%currentoppfield%:="???"
			if(opp<>"???")
				tl%opp%_%currentoppfield%:="???"
			loop, %tottl%
				{
				i3:=a_index
				if(i3=1)
					continue
				if(tl%i3%_%currentboardfield%=y and tl%i3%_%currentcfield%="black")
					{
					tl%wtl%_%currentoppfield%:=i3
					tl%i3%_%currentoppfield%:=wtl
					if(tl%i3%_%currentresfield%="won")
						tl%wtl%_%currentresfield%:="lost"
					if(tl%i3%_%currentresfield%="lost")
						tl%wtl%_%currentresfield%:="won"
					if(tl%i3%_%currentresfield%="drew")
						tl%wtl%_%currentresfield%:="drew"
					if(tl%i3%_%currentresfield%="???")
						tl%wtl%_%currentresfield%:="???"
					break
					}
				}
			tl%wtl%_%currentboardfield%:=y
			goto wpuppt2
			}
		}
	}
wpuppt2:
; msgbox,% "new board = " tl%num%_%boardfield% "`n`nnew opp = " tl%num%_%oppfield% "`n`nnew result = " tl%num%_%resfield%
loop, %tottl%
	{
	i:=a_index
	if(i=1)
		{
		y:=tl1
		continue
		}
	loop, %tottfields%
		{
		f:=a_index
		if(f=1)
			{
			y:=y "`n" tl%i%_1
			continue
			}
		y:=y a_tab tl%i%_%f%
		}
	}
filedelete, %ct%
fileappend,%y%, %ct%
FileSetAttrib, +h, %ct%
gosub sst
gosub prdc
gosub uprdc
gosub wprdc
gosub bprdc
gosub playerstats
blockinput, off
return

;_____________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup1:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-19
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup2:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-18
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup3:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-17
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup4:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-16
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup5:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-15
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup6:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-14
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup7:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-13
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup8:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-12
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup9:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-11
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup10:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-10
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup11:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-9
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup12:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-8
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup13:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-7
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup14:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-6
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup15:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-5
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup16:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-4
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup17:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-3
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup18:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-2
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup19:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-1
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpup20:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)
goto, bpup
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;_____________________________________________________________________________________________________________________________________________________________________________
bpup:
;_____________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(newbpdisplayname%y%="")
	return
btl:=newbpdisplaytl%y%
boardsearch:=y-1
; msgbox,,, boardsearch = %boardsearch%`n`ntestboardsearch = %testboardsearch%
if(boardsearch=0)
	return
blockinput, on
y:=0
; msgbox,,,% "boardsearch = " boardsearch
loop, %boardsearch%
	{
	i:=a_index
	potentialboard%i%=1
	loop, %tottl%
		{
		i2:=a_index
		if(i2=1)
			continue
		if(tl%i2%_%currentboardfield%=i and tl%i2%_%currentcfield%="black")
			{
			potentialboard%i%:=0
			}
		if(i2=tottl and potentialboard%i%=1)
			{
			x:=i
			if(x>y)
				{
				y:=x
				}
			}
		if(i=boardsearch and i2=tottl and y>0)
			{
			opp:=tl%btl%_%currentoppfield%
			tl%btl%_%currentoppfield%:="???"
			if(opp<>"???")
				tl%opp%_%currentoppfield%:="???"
			loop, %tottl%
				{
				i3:=a_index
				if(i3=1)
					continue
				if(tl%i3%_%currentboardfield%=y and tl%i3%_%currentcfield%="white")
					{
					tl%btl%_%currentoppfield%:=i3
					tl%i3%_%currentoppfield%:=btl
					if(tl%i3%_%currentresfield%="won")
						tl%btl%_%currentresfield%:="lost"
					if(tl%i3%_%currentresfield%="lost")
						tl%btl%_%currentresfield%:="won"
					if(tl%i3%_%currentresfield%="drew")
						tl%btl%_%currentresfield%:="drew"
					if(tl%i3%_%currentresfield%="???")
						tl%btl%_%currentresfield%:="???"
					break
					}
				}
			tl%btl%_%currentboardfield%:=y
			goto bpuppt2
			}
		}
	}
bpuppt2:
; msgbox,% "new board = " tl%num%_%boardfield% "`n`nnew opp = " tl%num%_%oppfield% "`n`nnew result = " tl%num%_%resfield%
loop, %tottl%
	{
	i:=a_index
	if(i=1)
		{
		y:=tl1
		continue
		}
	loop, %tottfields%
		{
		f:=a_index
		if(f=1)
			{
			y:=y "`n" tl%i%_1
			continue
			}
		y:=y a_tab tl%i%_%f%
		}
	}
filedelete, %ct%
fileappend,%y%, %ct%
FileSetAttrib, +h, %ct%
gosub sst
gosub prdc
gosub uprdc
gosub wprdc
gosub bprdc
gosub playerstats
blockinput, off
return

;_____________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname1:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-19
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname2:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-18
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname3:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-17
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname4:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-16
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname5:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-15
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname6:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-14
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname7:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-13
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname8:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-12
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname9:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-11
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname10:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-10
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname11:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-9
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname12:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-8
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname13:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-7
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname14:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-6
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname15:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-5
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname16:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-4
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname17:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-3
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname18:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-2
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname19:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)-1
goto, upname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname20:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentupdisplay*20)
goto, upname
;_____________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
upname:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(newupdisplayname%y%="")
	{
	if(pswapping=1)
		{
		blockinput, on
		tl%p1swappingtl%_%currentboardfield%:="???"
		tl%p1swappingtl%_%currentoppfield%:="???"
		tl%p1swappingtl%_%currentcfield%:="???"
		tl%p1swappingtl%_%currentresfield%:="Bye(0pt)"
		if(p1swappingopp<>"???")
			tl%p1swappingopp%_%currentoppfield%:="???"
		goto upnamept2
		}
	else
		return
	}
blockinput, on
; msgbox,,,% "newupdisplayname%y% =  " newupdisplayname%y% , .6
if(pswapping=0)
	{
	pswapping:=1
	p1swappingtl:=newupdisplaytl%y%
	p1swappingboard:="???"
	p1swappingopp:="???"
	p1swappingc:="???"
	p1swappingres:=tl%p1swappingtl%_%currentresfield%
	blockinput, off
	return
	}
else	{
	p2swappingtl:=newupdisplaytl%y%
	tl%p1swappingtl%_%currentboardfield%:="???"
	tl%p1swappingtl%_%currentoppfield%:="???"
	tl%p1swappingtl%_%currentcfield%:="???"
	tl%p1swappingtl%_%currentresfield%:=tl%p2swappingtl%_%currentresfield%
	if(p1swappingopp<>"???")
		tl%p1swappingopp%_%currentoppfield%:=p2swappingtl
	tl%p2swappingtl%_%currentboardfield%:=p1swappingboard
	tl%p2swappingtl%_%currentoppfield%:=p1swappingopp
	tl%p2swappingtl%_%currentcfield%:=p1swappingc
	tl%p2swappingtl%_%currentresfield%:=p1swappingres
	goto upnamept2
	}
upnamept2:
gosub af
filedelete, %ct%
fileappend,%y%, %ct%
FileSetAttrib, +h, %ct%
gosub sst
gosub prdc
gosub uprdc
gosub wprdc
gosub bprdc
gosub playerstats
blockinput, off
return

;_____________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname1:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-19
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname2:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-18
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname3:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-17
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname4:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-16
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname5:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-15
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname6:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-14
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname7:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-13
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname8:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-12
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname9:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-11
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname10:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-10
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname11:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-9
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname12:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-8
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname13:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-7
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname14:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-6
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname15:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-5
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname16:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-4
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname17:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-3
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname18:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-2
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname19:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-1
goto, wpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname20:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)
goto, wpname
;_____________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpname:
/*___________________________________________________________________________________________________________________________________________________________________________
if a user clicks on a white player's name this will activate and do 1 of the following, depending on if they've already clicked on another player's name beforehand:
1.  if another player's name hasn't been selected first this should get the player's tournament line number, their board number, their opp number, their color (white), and their result.
2. if another player's name has already been clicked and the subroutine "sst" has not since been activated it should do one of two things, depending on whether the current field is blank or not:
	2a.  if the 2nd field is not blank it should swap the two player's data and adjust the opponent's opponent numbers from the moving player's boards if they exist.
	2b.  if the 2nd field is blank it should swap the first player to the board and adjust the moving player's old opponent's opponent if they exist.
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
variables handled:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
p1swappingtl
p1swappingboard
p1swappingopp
p1swappingc
p1swappingres
p2swappingtl
*/----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(newwpdisplayname%y%="")
	{
	if(pswapping=1)
		{
		blockinput, on
		tl%p1swappingtl%_%currentboardfield%:=y
		tl%p1swappingtl%_%currentcfield%:="white"
		tl%p1swappingtl%_%currentoppfield%:="???"
		if(tl%p1swappingtl%_%currentresfield%="Bye(0pt)" or tl%p1swappingtl%_%currentresfield%="Bye(.5pt)" or tl%p1swappingtl%_%currentresfield%="Bye(1pt)" or tl%p1swappingtl%_%currentresfield%="Wthdrwn(0pt)" or tl%p1swappingtl%_%currentresfield%="Forfeit(0pt)")
			tl%p1swappingtl%_%currentresfield%:="???"
		if(p1swappingopp<>"???")
			tl%p1swappingopp%_%currentoppfield%:="???"
		loop, %tottl%
			{
			i:=a_index
			if(i=1)
				continue
			if(tl%i%_%currentboardfield%=y and tl%i%_%currentcfield%="black")
				{
				tl%p1swappingtl%_%currentoppfield%:=i
				if(tl%i%_%currentresfield%="won")
					tl%p1swappingtl%_%currentresfield%:="lost"
				if(tl%i%_%currentresfield%="drew")
					tl%p1swappingtl%_%currentresfield%:="drew"
				if(tl%i%_%currentresfield%="lost")
					tl%p1swappingtl%_%currentresfield%:="won"
				if(tl%i%_%currentresfield%="???")
					tl%p1swappingtl%_%currentresfield%:="???"
				tl%i%_%currentoppfield%:=p1swappingtl
				goto wpnamept2
				}
			}
		goto wpnamept2
		}
	else
		return
	}
blockinput, on
; msgbox,,,% "newwpdisplayname%y% =  " newwpdisplayname%y% , .6
if(pswapping=0)
	{
	pswapping:=1
	p1swappingtl:=newwpdisplaytl%y%
	p1swappingboard:=tl%p1swappingtl%_%currentboardfield%
	p1swappingopp:=tl%p1swappingtl%_%currentoppfield%
	p1swappingc:=tl%p1swappingtl%_%currentcfield%
	p1swappingres:=tl%p1swappingtl%_%currentresfield%
	blockinput, off
	return
	}
else	{
	p2swappingtl:=newwpdisplaytl%y%
	tl%p1swappingtl%_%currentboardfield%:=tl%p2swappingtl%_%currentboardfield%
	if(p1swappingopp<>p2swappingtl)
		tl%p1swappingtl%_%currentoppfield%:=tl%p2swappingtl%_%currentoppfield%
	tl%p1swappingtl%_%currentcfield%:=tl%p2swappingtl%_%currentcfield%
	tl%p1swappingtl%_%currentresfield%:=tl%p2swappingtl%_%currentresfield%
	if(p1swappingopp<>"???" and p1swappingopp<>p2swappingtl)
		tl%p1swappingopp%_%currentoppfield%:=p2swappingtl
	if(tl%p2swappingtl%_%currentoppfield%<>"???" and p1swappingopp<>p2swappingtl)
		{
		x:=tl%p2swappingtl%_%currentoppfield%
		tl%x%_%currentoppfield%:=p1swappingtl
		}
	tl%p2swappingtl%_%currentboardfield%:=p1swappingboard
	if(p1swappingopp<>p2swappingtl)
		tl%p2swappingtl%_%currentoppfield%:=p1swappingopp
	tl%p2swappingtl%_%currentcfield%:=p1swappingc
	tl%p2swappingtl%_%currentresfield%:=p1swappingres
	goto wpnamept2
	}
wpnamept2:
gosub af
filedelete, %ct%
fileappend,%y%, %ct%
FileSetAttrib, +h, %ct%
gosub sst
gosub prdc
gosub uprdc
gosub wprdc
gosub bprdc
gosub playerstats
blockinput, off
return

;_____________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname1:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-19
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname2:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-18
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname3:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-17
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname4:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-16
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname5:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-15
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname6:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-14
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname7:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-13
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname8:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-12
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname9:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-11
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname10:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-10
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname11:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-9
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname12:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-8
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname13:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-7
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname14:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-6
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname15:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-5
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname16:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-4
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname17:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-3
gosub, bpname
return
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname18:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-2
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname19:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)-1
goto bpname
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname20:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
y:=(currentboarddisplay*20)
goto bpname
;_____________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bpname:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*___________________________________________________________________________________________________________________________________________________________________________
if a user clicks on a black player's name this will activate and do 1 of the following, depending on if they've already clicked on another player's name beforehand:
1.  if another player's name hasn't been selected first this should get the player's tournament line number, their board number, their opp number, their color, to "black", and their result.
2. if another player's name has already been clicked and the subroutine "sst" has not since been activated it should do one of two things, depending on whether the current field is blank or not:
	2a.  if the 2nd field is not blank it should swap the two player's data and adjust the opponent's opponent numbers from the moving player's boards if they exist.
	2b.  if the 2nd field is blank it should swap the first player to the board and adjust the moving player's old opponent's opponent if they exist.
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
variables handled:
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
p1swappingtl
p1swappingboard
p1swappingopp
p1swappingc
p1swappingres
p2swappingtl
*/----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(newbpdisplayname%y%="")
	{
	if(pswapping=1)
		{
		blockinput, on
		tl%p1swappingtl%_%currentboardfield%:=y
		tl%p1swappingtl%_%currentcfield%:="black"
		tl%p1swappingtl%_%currentoppfield%:="???"
		if(tl%p1swappingtl%_%currentresfield%="Bye(0pt)" or tl%p1swappingtl%_%currentresfield%="Bye(.5pt)" or tl%p1swappingtl%_%currentresfield%="Bye(1pt)" or tl%p1swappingtl%_%currentresfield%="Wthdrwn(0pt)" or tl%p1swappingtl%_%currentresfield%="Forfeit(0pt)")
			tl%p1swappingtl%_%currentresfield%:="???"
		if(p1swappingopp<>"???")
			tl%p1swappingopp%_%currentoppfield%:="???"
		loop, %tottl%
			{
			i:=a_index
			if(i=1)
				continue
			if(tl%i%_%currentboardfield%=y and tl%i%_%currentcfield%="white")
				{
				tl%p1swappingtl%_%currentoppfield%:=i
				if(tl%i%_%currentresfield%="won")
					tl%p1swappingtl%_%currentresfield%:="lost"
				if(tl%i%_%currentresfield%="drew")
					tl%p1swappingtl%_%currentresfield%:="drew"
				if(tl%i%_%currentresfield%="lost")
					tl%p1swappingtl%_%currentresfield%:="won"
				if(tl%i%_%currentresfield%="???")
					tl%p1swappingtl%_%currentresfield%:="???"
				tl%i%_%currentoppfield%:=p1swappingtl
				goto bpnamept2
				}
			}
		goto bpnamept2
		}
	else
		return
	}
blockinput, on
; msgbox,,,% "newwpdisplayname%y% =  " newwpdisplayname%y% , .6
if(pswapping=0)
	{
	pswapping:=1
	p1swappingtl:=newbpdisplaytl%y%
	p1swappingboard:=tl%p1swappingtl%_%currentboardfield%
	p1swappingopp:=tl%p1swappingtl%_%currentoppfield%
	p1swappingc:=tl%p1swappingtl%_%currentcfield%
	p1swappingres:=tl%p1swappingtl%_%currentresfield%
	blockinput, off
	return
	}
else	{
	p2swappingtl:=newbpdisplaytl%y%
	tl%p1swappingtl%_%currentboardfield%:=tl%p2swappingtl%_%currentboardfield%
	if(p1swappingopp<>p2swappingtl)
		tl%p1swappingtl%_%currentoppfield%:=tl%p2swappingtl%_%currentoppfield%
	tl%p1swappingtl%_%currentcfield%:=tl%p2swappingtl%_%currentcfield%
	tl%p1swappingtl%_%currentresfield%:=tl%p2swappingtl%_%currentresfield%
	if(p1swappingopp<>"???" and p1swappingopp<>p2swappingtl)
		tl%p1swappingopp%_%currentoppfield%:=p2swappingtl
	if(tl%p2swappingtl%_%currentoppfield%<>"???" and p1swappingopp<>p2swappingtl)
		{
		x:=tl%p2swappingtl%_%currentoppfield%
		tl%x%_%currentoppfield%:=p1swappingtl
		}
	tl%p2swappingtl%_%currentboardfield%:=p1swappingboard
	if(p1swappingopp<>p2swappingtl)
		tl%p2swappingtl%_%currentoppfield%:=p1swappingopp
	tl%p2swappingtl%_%currentcfield%:=p1swappingc
	tl%p2swappingtl%_%currentresfield%:=p1swappingres
	goto bpnamept2
	}
bpnamept2:
gosub af
filedelete, %ct%
fileappend,%y%, %ct%
FileSetAttrib, +h, %ct%
gosub sst
gosub prdc
gosub uprdc
gosub wprdc
gosub bprdc
gosub playerstats
blockinput, off
return

;_____________________________________________________________________________________________________________________________________________________________________________
;--------------------
wpres1:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-19
goto wpres
;--------------------
wpres2:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-18
goto wpres
;--------------------
wpres3:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-17
goto wpres
;--------------------
wpres4:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-16
goto wpres
;--------------------
wpres5:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-15
goto wpres
;--------------------
wpres6:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-14
goto wpres
;--------------------
wpres7:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-13
goto wpres
;--------------------
wpres8:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-12
goto wpres
;--------------------
wpres9:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-11
goto wpres
;--------------------
wpres10:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-10
goto wpres
;--------------------
wpres11:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-9
goto wpres
;--------------------
wpres12:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-8
goto wpres
;--------------------
wpres13:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-7
goto wpres
;--------------------
wpres14:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-6
goto wpres
;--------------------
wpres15:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-5
goto wpres
;--------------------
wpres16:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-4
goto wpres
;--------------------
wpres17:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-3
goto wpres
;--------------------
wpres18:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-2
goto wpres
;--------------------
wpres19:
;--------------------
click:="left"
y:=(currentboarddisplay*20)-1
goto wpres
;--------------------
wpres20:
;--------------------
click:="left"
y:=(currentboarddisplay*20)
goto wpres
;_____________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
wpres:
;____________________________________________________________________________________________________________________________________________________________________________
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(newwpdisplayres%y%="")
	return
; msgbox,,,% "newwpdisplayres%y% = " newwpdisplayres%y% , .6
blockinput, on
if(click="left")
	{
	if(newwpdisplayres%y%="???")
		newwpres:="won"
	if(newwpdisplayres%y%="won")
		newwpres:="drew"
	if(newwpdisplayres%y%="drew")
		newwpres:="lost"
	if(newwpdisplayres%y%="lost")
		newwpres:="???"
	}
else	{
	if(newwpdisplayres%y%="???")
		newwpres:="lost"
	if(newwpdisplayres%y%="lost")
		newwpres:="drew"
	if(newwpdisplayres%y%="drew")
		newwpres:="won"
	if(newwpdisplayres%y%="won")
		newwpres:="???"
	}
wptl:=newwpdisplaytl%y%
tl%wptl%_%currentresfield%:=newwpres
newbpres:=""
if(newbpdisplayres%y%<>"")
	{
	if(newwpres="???")
		newbpres:="???"
	if(newwpres="won")
		newbpres:="lost"
	if(newwpres="drew")
		newbpres:="drew"
	if(newwpres="lost")
		newbpres:="won"
	bptl:=newbpdisplaytl%y%
	tl%bptl%_%currentresfield%:=newbpres
	}
; msgbox,,,% "newbpdisplayres%y% = " newbpdisplayres%y% "`n`ntl%wptl%_%currentresfield% = " tl%wptl%_%currentresfield% "`n`ntl%bptl%_%currentresfield% = " tl%bptl%_%currentresfield%
loop, %tottl%
	{
	i:=a_index
	if(i=1)
		{
		y:=tl%i%
		continue
		}
	if(i=wptl)
		{
		loop, %tottfields%
			{
			f:=a_index
			if(f=1)
				{
				y:=y "`n" tl%wptl%_1
				continue
				}
			y:=y a_tab tl%wptl%_%f%
			}
		continue
		}
	if(newbpres<>"" and i=bptl)
		{
		loop, %tottfields%
			{
			f:=a_index
			if(f=1)
				{
				y:=y "`n" tl%bptl%_1
				continue
				}
			y:=y a_tab tl%bptl%_%f%
			}
		continue
		}
	y:=y "`n"tl%i%
	}
;msgbox,,,% "tottfields = " tottfields "`n`ny = " y ,
filedelete, %ct%
fileappend, %y%, %ct%
FileSetAttrib, +h, %ct%
gosub sst
gosub prdc
gosub uprdc
