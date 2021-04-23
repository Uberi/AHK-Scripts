/*
||------------------------------
||------------------------------
|| Name: Guess It
|| Version: 1.0
|| Author: tidbit
|| Description: A simple game that guesses a result you generate.
||------------------------------
||------------------------------
*/
#SingleInstance, force
var=1
words=
(
fox
raccoon
frog
hedgehog
badger
otter
chair
sofa
banana
apple
orange
grapes
strawberry
teddy
monkey
gorilla
polar
table
watermelon
bear
panda
bear
bed
pineapple
robot
lion
desk
grapefruit
balloons
tiger
bookcase
coconut
blocks
zebra
drawers
lemon
doll
hippo
cupboard
mango
puppet
elephant
kite
rhino
board
giraffe
game
crocodile
jump
camel
rope
bear
ball
deer
cards
wolf
unicycle
kangaroo
yo-yo
lizard
video
koala
cake
toothbrush
mailman
house
flower
red
cookies
toothpaste
scientist
apartment
grass
green
pudding
towel
clown
roof
tree
pink
muffin
razor
fairy
chimney
leaves
orange
ice-cream
brush
pirate
living
sunflower
gray
apple
comb
pilot
room
garden
black
pie
toilet
)

Gui, Add, Text, cblue x36 y2  h20 vtext1 , Choose a 2 Digit Number`, such as 25.
Gui, Add, Text, cblue x6 y22  h20 vtext2 , With that Number`, subtract the 2 Digits from the overall Number.
Gui, Add, Text, cred x36 y42  h20 vtext3, 25 can be broken down to 2 and 5. 
Gui, Add, Text, CRed x26 y62  h20 vtext4,So subtract 25, 2 and 5:    25-2-5 = 18
Gui, Add, Button, x96 y102 w100 h20 vnext gnext, Next --->
; Generated using SmartGUI Creator 4.0
Gui, Show,, Guess It`, By: tidbit
Return

next:
	random, mode, 1, 2
	xx=6
	yy=42
	random, answer, 1, 100
	answer:=VarReadLine(words, answer)
	GuiControl, hide, text1
	GuiControl, hide, text2
	GuiControl, hide, text3
	GuiControl, hide, text4
	GuiControl, hide, next
	Gui, font, s9 cBlue Bold
	Gui, add, text, +Center x6 y6, Now`, with the Number you got with the previous step, find the Number and remeber the word associated with it.`n Click Finish when done.
	Gui, font, S8 norm cBlack

	Loop, 99
	{
		rword:=VarReadLine(words, "R")
		StringSplit, num, var
		equ:=var-num1-num2
		If ( Mod(A_index, 9 ) = 0 )
			rword:=answer

		Gui, add, text, +Center +Border x%xx% y%yy%  w70 h32, %A_index%`n%rword%

		If mode=1
		{
			If (yy>=375)
			{
				xx+=72
				yy:=42
				continue
			}
			var++
			yy+=34
		}

		If mode=2
		{
			If (xx>=690)
			{
				xx:=6
				yy+=34
				continue
			}
			var++
			xx+=72
		}
	}

	Gui, add, Button, x6 gFinish, Finish --->
	gui, show, AutoSize Center, Pick the object.
Return

Finish:
	Gui, 2: font, s16 Bold
	Gui, 2: Color, 888888
	Gui, 2: add, text, x6 y6, You guessed:
	Gui, 2: add, text, Clime y6, %answer%
	Gui, 2: add, Button, x6 y56 gReplay, Replay?
	Gui, 2: add, Button, x200 yp+0 gQuit, Quit?
	Gui, 2: Show, , Results.
Return

Replay:
	Reload
Return

Quit:
	exitapp
Return


esc::
GuiClose:
2GuiClose:
	ExitApp


; ------------------------------
; Functions
; ------------------------------
	VarReadLine(_Input, _Line)
	{
		If _Line=R
		{
			Loop, Parse, _Input, `n
				line:=A_index
			Random, line, 1, %line%
			Loop, Parse, _Input, `n
			{
				If A_index= %line%
					Return A_LoopField
			}
		}
		Else
		{
			Loop, Parse, _Input, `n
			{
				If A_index=%_Line%
					Return A_LoopField
			}
		}
	}