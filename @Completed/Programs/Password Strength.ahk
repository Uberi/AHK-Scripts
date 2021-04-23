Gui, Font, S26 CDefault Bold, Arial
Gui, Add, Text, x2 y0 w650 h50 +Center, Password Strength
Gui, Font, S18 CDefault Bold, Arial
Gui, Add, Edit, x2 y50 w650 h40 +Password gCalculateStrength vPasswordField
Gui, Add, Text, x2 y100 w650 h30 +Center, It would take
Gui, Font, S24 CDefault Bold, Arial
Gui, Add, Text, x2 y130 w650 h40 +Center vStrength
Gui, Font, S18 CDefault Bold, Arial
Gui, Add, Text, x2 y170 w650 h60 +Center, to crack this password with brute force on current hardware.
Gui, +ToolWindow +AlwaysOnTop
Gosub, CalculateStrength
Gui, Show, w655 h235, Password Strength
Return

GuiEscape:
GuiClose:
ExitApp

CalculateStrength:
GuiControlGet, Temp1,, PasswordField
GuiControl,, Strength, % PasswordStrength(Temp1)
Return

PasswordStrength(Pass)
{
 CalculationsPerSecond = 10000000
 PassLen := StrLen(Pass)
 If PassLen < 3
  Return, "almost no time"
 Else If PassLen < 8
 {
  CommonPassList := ",god,sex1234,cool,1313,star,golf,bear,dave,pass,aaaa,6969,jake,matt,1212,fish,fuck,porn,4321,2000,4128,test,shit,love,baby,cunt,mark,3333,john,sexy,5150,4444,2112,fred,mike,1111,tits,paul,mine,king,fire,5555,slut,girl,2222,asdf,time,7777,rock,xxxx,ford,dick,bill,wolf,blue,alex,cock,beer,eric,6666,jackbeach,great,black,pussy,12345,frank,tiger,japan,money,naked,11111,angel,stars,apple,porno,steve,viper,horny,ou812,kevin,buddy,teens,young,jason,lucky,girls,lover,brian,kitty,bubba,happy,cream,james,xxxxx,booty,kelly,boobs,penis,eagle,white,enter,chevy,smith,chris,green,sammy,super,magic,power,enjoy,scott,david,video,qwert,paris,women,juice,dirty,music,peter,bitch,house,hello,billy,movie123456,prince,guitar,butter,jaguar,united,turtle,muffin,cooper,nascar,redsox,dragon,zxcvbn,qwerty,tomcat,696969,654321,murphy,987654,amanda,brazil,wizard,hannah,lauren,master,doctor,eagle1,gators,squirt,shadow,mickey,mother,monkey,bailey,junior,nathan,abc123,knight,alexis,iceman,fuckme,tigers,badboy,bonnie,purple,debbie,angela,jordan,andrea,spider,harley,ranger,dakota,booger,iwantu,aaaaaa,lovers,player,flyers,suckit,hunter,beaver,morgan,matrix,boomer,runner,batman,scooby,edward,thomas,walter,helpme,gordon,tigger,jackie,casper,robert,booboo,boston,monica,stupid,access,coffee,braves,xxxxxx,yankee,saturn,buster,gemini,barney,apples,soccer,rabbit,victor,august,hockey,peanut,tucker,killer,canada,george,johnny,sierra,blazer,andrew,spanky,doggie,232323,winter,zzzzzz,brandy,gunner,beavis,compaq,horney,112233,carlos,arthur,dallas,tennis,sophie,ladies,calvin,shaved,pepper,giants,surfer,fender,samson,austin,member,blonde,blowme,fucked,daniel,donald,golden,golfer,cookie,summer,bronco,racing,sandra,hammer,pookie,joseph,hentai,joshua,diablo,birdie,maggie,sexsex,little,biteme,666666,topgun,ashley,willie,sticky,cowboy,animal,silver,yamaha,qazwsx,fucker,justin,skippy,orange,banana,lakers,marvin,merlin,driver,rachel,marine,slayer,angels,asdfgh,bigdog,vagina,apollo,cheese,toyota,parker,maddog,travis,121212,london,hotdog,wilson,sydney,martin,dennis,voodoo,ginger,magnum,action,nicole,carter,erotic,sparky,jasper,777777,yellow,smokey,dreams,camaro,xavier,teresa,freddy,secret,steven,jeremy,viking,falcon,snoopy,russia,taylor,nipple,111111,eagles,131313,winner,tester,123123,miller,rocket,legend,flower,theman,please,oliver,albertporsche,rosebud,chelsea,amateur,7777777,diamond,tiffany,jackson,scorpio,cameron,testing,shannon,madison,mustang,bond007,letmein,michael,gateway,phoenix,thx1138,raiders,forever,peaches,jasmine,melissa,gregory,cowboys,dolphin,charles,cumshot,college,bulldog,1234567,ncc1701,gandalf,leather,cumming,hunting,charlie,rainbow,asshole,bigcock,fuckyou,jessica,panties,johnson,naughty,brandon,anthony,william,ferrari,chicken,heather,chicago,voyager,yankees,rangers,packers,newyork,trouble,bigtits,winston,thunder,welcome,bitches,warrior,panther,broncos,richard,8675309,private,zxcvbnm,nipples,blondes,fishing,matthew,hooters,patrick,freedom,fucking,extreme,blowjob,captain,bigdick,abgrtyu,chester,monster,maxwell,arsenal,crystal,rebecca,pussies,florida,phantom,scooter,successfirebird,password,12345678,steelers,mountain,computer,baseball,xxxxxxxx,football,qwertyui,jennifer,danielle,sunshine,starwars,whatever,nicholas,swimming,trustno1,midnight,princess,startrek,mercedes,superman,bigdaddy,maverick,einstein,dolphins,hardcore,redwings,cocacola,michelle,victoria,corvette,butthead,marlboro,srinivas,internet,redskins,11111111,access14,rush2112,scorpion,iloveyou,samantha,mistress,"
  IfInString, CommonPassList, `,%Pass%`,
   Return, "almost no time"
 }
 PossibleChars = 0
 StringCaseSense, On
 If Pass Contains a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z
  PossibleChars += 26
 If Pass Contains A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z
  PossibleChars += 26
 If Pass Contains 1,2,3,4,5,6,7,8,9,0
  PossibleChars += 10
 If Pass Contains !,@,#,$,`%,^,&,*,/,?,_,~,-,(,),,,,.,-,=,:
  PossibleChars += 20
 If Pass Contains [,],\,;,',{,},|,",<,>
  PossibleCombinations += 11
 PossibleCombinations = %PossibleChars%
 Loop, %PassLen%
  PossibleCombinations := BigIntMultiply(PossibleCombinations,PassLen)
 TimeSeconds := BigIntDivide(PossibleCombinations,CalculationsPerSecond,6)
 TrimLeadingZeros(TimeSeconds)
 If (BigIntCompare(TimeSeconds,60) = -1)
 {
  If TimeSeconds = 0
   Return, "almost no time"
  Return, TimeSeconds . " seconds"
 }
 TimeSeconds := SubStr(TimeSeconds,1,InStr(TimeSeconds,".") - 1)
 ParseList = minute|60,hour|60,day|24,month|30,year|12,thousand years|1000,million years|1000,billion years|1000,trillion years|1000,quadrillion years|1000,quintillion years|1000,sextillion years|1000,septillion years|1000,octillion years|1000,nonillion years|1000,decillion years|1000,undecillion years|1000,duodecillion years|1000,tredecillion years|1000
 TempTime = %TimeSeconds%
 PrevTime = %TimeSeconds%
 PrevUnit = seconds
 Loop, Parse, ParseList, CSV
 {
  StringSplit, Temp, A_LoopField, |
  TempTime := BigIntDivide(TempTime,Temp2)
  TrimLeadingZeros(TempTime)
  TempTime := SubStr(TempTime,1,InStr(TempTime,".") - 1)
  Temp3 := BigIntCompare(TempTime,1)
  If Temp3 In -1,0
  {
   TempTime = %PrevTime%
   Temp1 = %PrevUnit%
   Break
  }
  PrevTime = %TempTime%
  PrevUnit = %Temp1%
 }
 If (StrLen(TempTime) > 15)
  Return, "an incredibly long time"
 Temp2 = %TempTime%
 TempTime .= " " . Temp1
 If Temp2 = 1
  TempTime = a %Temp1%
 Else If Temp1 In minute,hour,day,month,year
  TempTime .= "s"
 Return, "about " . TempTime
}

TrimLeadingZeros(ByRef Num)
{
 Amount = 0
 While, ((SubStr(Num,A_Index,1) = 0) && (SubStr(Num,A_Index + 1,1) <> "."))
  Amount ++
 If Amount
  StringTrimLeft, Num, Num, %Amount%
}

TrimTrailingZeros(ByRef Num)
{
 Amount = 0
 While, (SubStr(Num,(A_Index * -1) + 1,1) = 0)
  Amount ++
 If Amount
  StringTrimRight, Num, Num, %Amount%
}

BigIntCompare(Num1,Num2)
{
 Temp1 := InStr(Num1,".")
 Temp2 := InStr(Num2,".")
 If (Temp1 || Temp2)
 {
  Decimal1 := SubStr(Num1,Temp1 + 1)
  Decimal2 := SubStr(Num2,Temp2 + 1)
  Num1 := SubStr(Num1,1,Temp1 - 1)
  Num2 := SubStr(Num2,1,Temp2 - 1)
 }
 Num1Len := StrLen(Num1)
 Num2Len := StrLen(Num2)
 If Num1Len > %Num2Len%
  Return, 1
 If Num1Len < %Num2Len%
  Return, -1
 If (Num1 . "!" = Num2 . "!")
  Return, 5
 Loop, Parse, Num1
 {
  Temp3 := SubStr(Num2,A_Index,1)
  If A_LoopField > %Temp3%
   Return, 1
  If A_LoopField < %Temp3%
   Return, -1
 }
 If (Temp1 || Temp2)
 {
  Temp1 := StrLen(Decimal1)
  Temp2 := StrLen(Decimal2)
  If Temp1 < %Temp2%
  {
   Loop, % Temp2 - Temp1
    Decimal1 .= 0
  }
  Else If Temp1 > %Temp2%
  {
   Loop, % Temp1 - Temp2
    Decimal2 .= 0
  }
  Loop, Parse, Decimal1
  {
   Temp1 := SubStr(Decimal2,A_Index,1)
   If A_LoopField > %Temp1%
    Return, 1
   If A_LoopField < %Temp1%
    Return, -1
  }
 }
 Return, 0
}

BigIntSubtract(Num1,Num2)
{
 MaxLen := StrLen(Num1), Rem := 0
 Loop, %MaxLen%
  Sum := SubStr(Num1,MaxLen - (A_Index - 1),1) - (SubStr(Num2,MaxLen - (A_Index - 1),1) + Rem), Rem := Floor((9 - Sum) / 10), Erg := Mod((Sum + 10),10), Result := Erg . Result
 Return, SubStr(Result,StrLen(Num2) - 1)
}

BigIntDivide(Num,Divisor,Precision = 6)
{
 NumLen := StrLen(Num), Rem := 0
 Loop, % NumLen + Precision
  Temp1 := A_Index <= NumLen ? SubStr(Num,A_Index,1) : 0, ((A_Index - 1) = NumLen) ? Result .= ".", Temp1 += (Rem * 10), Result .= (Temp1) // Divisor, Rem := Mod(Temp1,Divisor)
 Return, Result
}

BigIntMultiply(Num1,Num2)
{
 Num1Len := StrLen(Num1), Num2Len := StrLen(Num2), Temp1 := Num1Len + Num2Len, VarSetCapacity(Result,Temp1,48), NumPut(0,Result,Temp1,"Char")
 Loop, %Num2Len%
 {
  Index1 := Num2Len - (A_Index - 1), Num := 0
  Loop, %Num1Len%
  {
   Index2 := Num1Len - (A_Index - 1)
   Temp1 := SubStr(Result,Index1 + Index2,1) + (SubStr(Num1,Index2,1) * SubStr(Num2,Index1,1)) + Num
   Num := Temp1 // 10
   NumPut(Mod(Temp1,10) + 48,Result,(Index1 + Index2) - 1,"Char")
  }
  NumPut(Num + 48,Result,(Index1 + Index2) - 2,"Char")
 }
 Return, Num ? Result : SubStr(Result,2)
}