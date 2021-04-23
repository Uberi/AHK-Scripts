#Include Switch-Case.ahi

test=1
Gosub, TestSwitch
test=2
Gosub, TestSwitch
test=One
Gosub, TestSwitch
test=Two
Gosub, TestSwitch
test=
Gosub, TestSwitch
test=3
Gosub, TestSwitch
test=4
Gosub, TestSwitch
test=5
Gosub, TestSwitch
Exit

TestSwitch:
switch(test)
	if case(1)
		msgbox, % "passed(" switch(0,1) ")=case(1)"
	else if case(2)
		msgbox, % "passed(" switch(0,1) ")=case(2)"
	else if case(3)
		msgbox, % "passed(" switch(0,1) ")=case(3)"
	else if case("One")
		msgbox, % "passed(" switch(0,1) ")=case(One)"
	else if case("Two")
		msgbox, % "passed(" switch(0,1) ")=case(Two)"
	else if case("Three")
		msgbox, % "passed(" switch(0,1) ")=case(Three)"
	else
		msgbox, % "passed(" switch(0,1) ")=case(<default>)"
return