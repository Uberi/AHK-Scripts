#NoEnv
#Persistent
#SingleInstance Force

;############################## Load Invariables ###############################
7ZIPURL = http://freewares.tistory.com/attachment/ek010000000001.zip
UNZIPURL = http://freewares.tistory.com/attachment/fk030000000000.EXE
FFMPEGURL = http://freewares.tistory.com/attachment/fk030000000001.7z
TOPNGURL = http://freewares.tistory.com/attachment/ek010000000000.zip

IFormats := "BMP,CUT,DDS,G3,GIF,HDR,ICO,IFF,LBM,JNG,JPG,JIF,JPEG,JPE,KOA,MNG,PBM,PCD,PCX,PGM,PNG,PPM,PSD,RAS,SGI,TGA,TARGA,TIF,TIFF,WAP,WBMP,WBM,XBM,XPM"
AFormats := "AAC,AC3,AIFF,ALAW,APE,AU,DAUD,DTS,FLAC,TTA,WAV,RM,MP3,OGG"
StringReplace, Auncompressed, AFormats, `,MP3`,OGG,,
OGGFormat := "OGG(High),OGG(Medium),OGG(Low)"

;############################ DEFAULT INI SETTINGS #############################
INIDEFAULT =
(
[QuickConverter]
Hotkey=F12

[Image]
IEXT=JPG

[Audio]
AEXT1=MP3(320K)
AEXT2=MP3(192K)
AEXT3=WMA(64K)
)

;########################### Read Settings from INI ############################
IfNotExist, QC.INI
FileAppend, %INIDEFAULT%, QC.INI

IniRead, Hotkey, QC.INI, QuickConverter, Hotkey
IniRead, Iext, QC.INI, Image, Iext
IniRead, Aext1, QC.INI, Audio, Aext1
IniRead, Aext2, QC.INI, Audio, Aext2
IniRead, Aext3, QC.INI, Audio, Aext3

Hotkey, %Hotkey%, StartConvert, P1                                ;Assign Hotkey
;############################# Create Tray Menus ###############################
Menu, Tray, NoStandard
Menu, Tray, Color, 999999
Menu, Tray, Add, QuickConverter
Menu, Tray, Add
Menu, Tray, Add, Settings
Menu, Tray, Default, Settings
Menu, Tray, Add, Exit

;########################### Check Thirdparty Files ############################
topng:=FileExist("topng.exe")
ffmpeg:=FileExist("ffmpeg.exe")
ffmpegdll:=FileExist("pthreadGC2.dll")

If (topng && ffmpeg && ffmpegdll)
{
   Return
}
Else                                                ;Get 3rd files from internet
{
   Gui, +AlwaysOnTop -Caption +LastFound
   Gui, Color, 747474
   Gui, Font, CFFFFFF
   Gui, Add, Text, x5 y5, Getting Necessary Files...
   Gui, Show, Center w180 h20
                                                         ;Gather Necessary Files
   URLDownloadToFile, %unzipURL%, unzip.exe
   URLDownloadToFile, %7zipURL%, 7zip.zip
   URLDownloadToFile, %ToPngURL%, topng.zip
   URLDownloadToFile, %FFMPEGURL%, ffmpeg.7z
   Runwait, unzip.exe 7zip.zip 7za.exe,,hide
   Runwait, unzip.exe topng.zip,,hide
   Runwait, 7za.exe e ffmpeg.7z,,hide
   SetTimer, CleanUp, 5000
   Gui, Destroy
   Return
}
Return
;###############################################################################
;############################### Auto Execution End ############################
;###############################################################################

QuickConverter:
Msgbox,,QuickConverter - Convert Media Files in Smart way,QuickConverter is a Frontend converter`nQuickConverter could be realized with following libraries`n`nFFMPEG : http://ffmpeg.mplayerhq.hu/`nFFMPEG Custom Build : http://ffdshow.faireal.net/mirror/ffmpeg/`nToPng : http://www.bcheck.net/apps/#topng`n`nalso great supports in AutoHotkey Forum helped me a lot`nand it's part of my project named qTray (http://qtray.net)`nThanks for using it!
Return

Exit:
Exitapp
Return

;############################## Create Settings GUI ############################
Settings:
Suspend
Gui, Font, CRED Bold
Gui, Add, Text, x6 y10 w120 h10, HOW IT WORKS? :
Gui, Font
Gui, Add, Text, x6 y30 w440 h50, When you select a file or files and hit the hotkey that you selected below`, QuickConverter Converts selected files immediately with specified rules depend on file extension. (image conversion does not affect to size)
Gui, Add, GroupBox, x6 y90 w440 h50, 1) Set Hotkey
Gui, Add, Text, x16 y113 w190 h20, Convert Immediately When I Hit...
Gui, Add, Hotkey, x216 y110 w90 h20 vHotkey, %HotKey%
Gui, Add, Text, x316 y113 w120 h20, With Following Rules

IextList = JPG|PNG|GIF|BMP|TGA|TIF|HDR|PBM|PGM|PPM|WBM|XPM
StringReplace, IextList, IextList, %Iext%|,, ;prevent to doule exists
Gui, Add, GroupBox, x6 y150 w440 h50, 2) Conversion Rules for Image Files
Gui, Add, Text, x16 y173 w50 h20, Convert
Gui, Add, Button, x66 y170 w230 h20 gSupportedImageFormats, Every Supported Image Formats
Gui, Add, Text, x306 y173 w20 h20, To
Gui, Add, DropDownList, x336 y170 w100 h20 r100 vIext, %Iext%||%IextList%

Aext1List = MP3(320K)|MP3(256K)|MP3(192K)|MP3(128K)|OGG(High)|OGG(Medium)|OGG(Low)
Aext2List = MP3(320K)|MP3(256K)|MP3(192K)|MP3(128K)
Aext3List = WMA(64K)|WMA(48K)|WMA(32K)
StringReplace, Aext1List, Aext1List, %Aext1%|,,
StringReplace, Aext2List, Aext2List, %Aext2%|,,
StringReplace, Aext3List, Aext3List, %Aext3%|,,
Gui, Add, GroupBox, x6 y210 w440 h110, 3) Conversion Rules for Audio Files
Gui, Add, Text, x16 y233 w50 h20, Convert
Gui, Add, Button, x66 y230 w230 h20 gUncompressedFormats, Every Uncompressed Audio Formats
Gui, Add, Text, x306 y233 w20 h20, To
Gui, Add, DropDownList, x336 y230 w100 h20 r100 vAext1, %AEXT1%||%Aext1list%
Gui, Add, Text, x16 y263 w50 h20, Convert
Gui, Add, Button, x66 y260 w230 h20, OGG
Gui, Add, Text, x306 y263 w20 h20, To
Gui, Add, DropDownList, x336 y260 w100 h20 r100 vAext2, %AEXT2%||%Aext2list%
Gui, Add, Text, x16 y293 w50 h20, Convert
Gui, Add, Button, x66 y290 w230 h20, MP3
Gui, Add, Text, x306 y293 w20 h20, To
Gui, Add, DropDownList, x336 y290 w100 h20 r100 vAext3, %AEXT3%||%Aext3list%

Gui, Add, Button, x6 y330 w200 h30 gSaveSettings, Save Settings
Gui, Add, Button, x256 y330 w190 h30, Cancel
Gui, Show, Center w456 h370, QuickConverter Settings
Return

GuiClose:
Suspend, Off
Gui, Destroy
Return


SupportedImageFormats:
Msgbox,,Supported Image Formats,BMP - Windows or OS/2 Bitmap`nCUT - Dr . Halo`nDDS - DirectX Surface`nG3 - Raw fax format CCITT G.3`nGIF - Graphics Interchange Format`nHDR - High Dynamic Range Image`nICO - Windows Icon`nIFF,LBM - IFF Interleaved Bitmap`nJNG - JPEG Network Graphics`nJPG, JIF, JPEG, JPE - JPEG JFIF Compliant`nKOA - C64 Koala Graphics`nMNG - Multiple Network Graphics`nPBM - Portable Bitmap (ASCII)`nPCD - Kodak PhotoCD`nPCX - Zsoft Paintbrush`nPGM - Portable Greymap (RAW)`nPNG - Portable Network Graphics`nPPM - Portable Pixelmap (ASCII)`nPSD - Adobe Photoshop`nRAS - Sun Raster Image`nSGI - SGI Image Format`nTGA,TARGA - Truevision Targe`nTIF,TIFF - Tagged Image File Format`nWAP,WBMP,WBM - Wireless Bitmap`nXBM - X11 Bitmap Format`nXPM - X11 Pixmap Format
Return

UncompressedFormats:
Msgbox,,Supported Uncompressed Formats,AAC - Advanced Audio Coding`nAC3 - Raw AC3`nAIFF - Audio Interchange File Format`nALAW - PCM A law format`nAPE - Monkey's Audio`nAU - SUN AU Format`nDAUD - D-Cinema Audio Format`nDTS - Raw Digital Theater System`nFLAC - Raw Free Lossless Audio Codec`nTTA - True Audio`nWAV - Waveform Audio Format
Return

SaveSettings:
Gui, Submit
IniWrite, %Hotkey%, QC.INI, QuickConverter, Hotkey
IniWrite, %Iext%, QC.INI, Image, Iext
IniWrite, %Aext1%, QC.INI, Audio, Aext1
IniWrite, %Aext2%, QC.INI, Audio, Aext2
IniWrite, %Aext3%, QC.INI, Audio, Aext3
Reload
Return

ButtonCancel:
Suspend, Off
Gui, Destroy
Return

;################################# Core Mechanism ##############################
STARTCONVERT:
Starttime := A_TickCount
B_Index = 0
{
     TempVar := ClipboardAll
     Clipboard =
     Send ^c
     Clipwait, 1
if ErrorLevel
   {
      TrayTip,QuickConverter,1. Wrong Icons(eg:My Computer) Included in Selection`n2. or pressed Hotkey too fast`n3. Context Menu is up,10,3
      return
   }
   FileName := Clipboard
   Clipboard := TempVar
   
Loop, Parse, FileName, `n, `r
{
   FileGetSize, DumpSize, %A_LoopField%
If DumpSize != 0                                                 ;File or Folder
   {
   SplitPath, A_LoopField,,DIR,ExtCheck,FileName
If ExtCheck in %IFormats%,%AFormats%                            ;Extension Check
{
   If ExtCheck in %IFormats%                            ;If Source is image file
   {
      IfExist,%DIR%\%FILENAME%.%IEXT%                      ;Prevent to Overwrite
      {
         TrayTip,QuickConverter,Same File Name (%FILENAME%.%IEXT%) Exists`, skipped,10,3
         Continue
      }
      Else
      Run, %ComSpec% /c ToPng.exe `"%A_LoopField%`" %Iext%,,Hide  ;Convert Image
   }
   Else If ExtCheck in %AUncompressed% ;If Source is in uncompressed Audio Format List
   {
      IfExist,%DIR%\%FILENAME%.OGG                         ;Prevent to Overwrite
      {
         TrayTip,QuickConverter,Same File Name (%FILENAME%.OGG) Exists`, skipped,10,3
         Continue
      }
      IfExist,%DIR%\%FILENAME%.MP3                         ;Prevent to Overwrite
      {
         TrayTip,QuickConverter,Same File Name (%FILENAME%.MP3) Exists`, skipped,10,3
         Continue
      }
      If Aext1 in %OGGFormat%                              ;If converting to OGG
      {
         TrayTip,,Converting %FileName%.%ExtCheck% To %FileName%.%Aext1%,10
         If Aext1 = OGG(High)
         Runwait, %ComSpec% /c ffmpeg.exe -i `"%A_LoopField%`" -acodec libvorbis -aq 255 -ac 2 -y -map_meta_data `"%DIR%`\%FileName%`".OGG`:`"%A_LoopField%`" `"%DIR%`\%FileName%`".OGG,,Hide
         If Aext1 = OGG(Medium)
         Runwait, %ComSpec% /c ffmpeg.exe -i `"%A_LoopField%`" -acodec libvorbis -aq 150 -ac 2 -y -map_meta_data `"%DIR%`\%FileName%`".OGG`:`"%A_LoopField%`" `"%DIR%`\%FileName%`".OGG,,Hide
         If Aext1 = OGG(Low)
         Runwait, %ComSpec% /c ffmpeg.exe -i `"%A_LoopField%`" -acodec libvorbis -aq 100 -ac 2 -y -map_meta_data `"%DIR%`\%FileName%`".OGG`:`"%A_LoopField%`" `"%DIR%`\%FileName%`".OGG,,Hide
      }
      Else                                                 ;If converting to MP3
      {
         StringMid, Aext1Bit, Aext1, 5, 4
         TrayTip,,Converting %FileName%.%ExtCheck% to %Filename%.%Aext1%
         Runwait, %ComSpec% /c ffmpeg.exe -i `"%A_LoopField%`" -acodec libmp3lame -ab %Aext1Bit% -y -map_meta_data `"%DIR%`\%FileName%`".MP3`:`"%A_LoopField%`" `"%DIR%`\%FileName%`".MP3,,Hide
      }
   }
   Else If ExtCheck = OGG                                 ;If Source is OGG File
   {
      IfExist,%DIR%\%FILENAME%.MP3                         ;Prevent to Overwrite
      {
         TrayTip,QuickConverter,Same File Name (%FILENAME%.MP3) Exists`, skipped,10,3
         Continue
      }
      Else
      {
         StringMid, Aext2Bit, Aext2, 5, 4
         TrayTip,,Converting %FileName%.%ExtCheck% to %Filename%.%Aext2%
         Runwait, %ComSpec% /c ffmpeg.exe -i `"%A_LoopField%`" -acodec libmp3lame -ab %Aext2Bit% -y -map_meta_data `"%DIR%`\%FileName%`".MP3`:`"%A_LoopField%`" `"%DIR%`\%FileName%`".MP3,,Hide
      }
   }
   Else If ExtCheck = MP3                                 ;If Source is MP3 File
   {
      IfExist,%DIR%\%FILENAME%.WMA                         ;Prevent to Overwrite
      {
         TrayTip,QuickConverter,Same File Name (%FILENAME%.WMA) Exists`, skipped,10,3
         Continue
      }
      Else
      {
         StringMid, Aext3Bit, Aext3, 5, 3
         TrayTip,,Converting %FileName%.%ExtCheck% to %Filename%.%Aext3%,10
         Runwait, %ComSpec% /c ffmpeg.exe -i `"%A_LoopField%`" -acodec wmav2 -ab %Aext3Bit% -y -map_meta_data `"%DIR%`\%FileName%`".WMA`:`"%A_LoopField%`" `"%DIR%`\%FileName%`".WMA,,Hide
      }
   }
}
Else
B_Index++
   }
   C_Index := A_Index - B_Index
   ElapsedTime := A_TickCount - StartTime
   ElapsedTime := ElapsedTime / 1000
   StringTrimRight, ElapsedTime, ElapsedTime, 4
   TrayTip,QuickConverter,Converted total of %C_Index% Files in %ElapsedTime% Secs,10,1
}
}
Return

CleanUP:
SetTimer, CleanUp, Off
FileDelete, unzip.exe
FileDelete, 7zip.zip
FileDelete, topng.zip
FileDelete, ffmpeg.7z
FileDelete, 7za.exe
FileDelete, ffplay.exe
Return