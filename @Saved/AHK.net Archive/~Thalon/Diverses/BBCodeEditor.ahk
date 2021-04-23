; AHK BBCodeWriter - An offline BBCode editor
; Copyright (C) 2006  AGermanUser
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
    
  ; Set constants for Icon Buttons
  BS_ICON := 64
  IMAGE_ICON := 1
  
  ; Initialise button variable - AlwaysOnTop button
  PinnedPressed = 0

  ; List of Gui controls of MainGUI to rebuild DataTbl within Anchor function -> functions.ahk
  DataTblCtrlList =
    (Ltrim
      EdtComment,wh
      GrpMenuBorder,w
      GrpCstmBorder,w
      BtnCustomize,x
      ChkSig,y
      DDLSig,y
      BtnEditSig,y
      BtnDelSig,y
      BtnSend,xy
      BtnPreview,xy
      BtnReset,xy
      BtnPinned,x
    )

  ; Read status of 'custom tags' button bar
  IniRead, CstmBarEnabled, BBCodeWriter.ini, CstmToolBar, CstmBarEnabled, 1

  ; Read previous Gui dimensions and position
  IniRead, PosX, BBCodeWriter.ini, GuiPosition  , X_Pos, 331
  IniRead, PosY, BBCodeWriter.ini, GuiPosition  , Y_Pos, 339
  IniRead, GuiW, BBCodeWriter.ini, GuiDimension , W_Gui, 610
  IniRead, GuiH, BBCodeWriter.ini, GuiDimension , H_Gui, 272
  
  ; Read previous Control dimensions
  IniRead, EdtY, BBCodeWriter.ini, EditSize     , Y_Edt, 69
  IniRead, EdtW, BBCodeWriter.ini, EditSize     , W_Edt, 600
  IniRead, EdtH, BBCodeWriter.ini, EditSize     , H_Edt, 203
  IniRead, EdtX, BBCodeWriter.ini, EditSize     , X_Edt, 5
  IniRead, GrpW, BBCodeWriter.ini, GroupBoxSize , W_Grp, 600
  IniRead, ChkY, BBCodeWriter.ini, CheckboxYPos , Y_Chk, 248
  IniRead, DDLY, BBCodeWriter.ini, DDListYPos   , Y_DDL, 245
  IniRead, BSgY, BBCodeWriter.ini, BtnSigYPos   , Y_BSg, 247
  IniRead, BG1X, BBCodeWriter.ini, BtnMainGui   , X_BG1, 405
  IniRead, BG2X, BBCodeWriter.ini, BtnMainGui   , X_BG2, 470
  IniRead, BG3X, BBCodeWriter.ini, BtnMainGui   , X_BG3, 545
  IniRead, BG3Y, BBCodeWriter.ini, BtnMainGui   , Y_BG3, 244
  IniRead, BG4X, BBCodeWriter.ini, BtnMainGui   , X_BG4, 580 
  
  ; List of Colors for Font Color GUI
  ListOfColors = darkred|red|orange|brown|yellow|green|olive|cyan|blue|darkblue|indigo|violet|white|black
  StringSplit, ArrayOfColors, ListOfColors, |
  
  ; Default Font sizes for Font Size GUI
  ListOfFontSizes = 7|9|12|18|24
  StringSplit, ArrayOfFontSizes, ListOfFontSizes, |
  
  ; List of Smileys for Smiley GUI
  ListOfSmileys =
   (LTrim
      :D
      :)
      :(
      :o
      :shock:
      :?
      8)
      :lol:
      :x
      :P
      :oops:
      :cry:
      :evil:
      :twisted:
      :roll:
      :wink:
      :!:
      :?:
      :idea:
      :arrow:
      :|
      :mrgreen:
    ) 
  StringSplit, ArrayOfSmileys, ListOfSmileys, `n
Return

;##############################################################################
;###### Custom BBCode Tags from CustomTags.ini ################################
;##############################################################################
ReadCustomTags:
  IniRead, BBStartTag1 , CustomTags.ini, BtnCustom1  , BBStartTag1
  IniRead, BBEndTag1   , CustomTags.ini, BtnCustom1  , BBEndTag1
  IniRead, BBToolTip1  , CustomTags.ini, BtnCustom1  , BBToolTip1
  IniRead, Cstm1Icon   , CustomTags.ini, BtnCustom1  , Cstm1Icon
  IniRead, Cstm1Enabled, CustomTags.ini, BtnCustom1  , Cstm1Enabled
  
  IniRead, BBStartTag2 , CustomTags.ini, BtnCustom2  , BBStartTag2
  IniRead, BBEndTag2   , CustomTags.ini, BtnCustom2  , BBEndTag2
  IniRead, BBToolTip2  , CustomTags.ini, BtnCustom2  , BBToolTip2
  IniRead, Cstm2Icon   , CustomTags.ini, BtnCustom2  , Cstm2Icon
  IniRead, Cstm2Enabled, CustomTags.ini, BtnCustom2  , Cstm2Enabled
  
  IniRead, BBStartTag3 , CustomTags.ini, BtnCustom3  , BBStartTag3
  IniRead, BBEndTag3   , CustomTags.ini, BtnCustom3  , BBEndTag3
  IniRead, BBToolTip3  , CustomTags.ini, BtnCustom3  , BBToolTip3
  IniRead, Cstm3Icon   , CustomTags.ini, BtnCustom3  , Cstm3Icon
  IniRead, Cstm3Enabled, CustomTags.ini, BtnCustom3  , Cstm3Enabled
  
  IniRead, BBStartTag4 , CustomTags.ini, BtnCustom4  , BBStartTag4
  IniRead, BBEndTag4   , CustomTags.ini, BtnCustom4  , BBEndTag4
  IniRead, BBToolTip4  , CustomTags.ini, BtnCustom4  , BBToolTip4
  IniRead, Cstm4Icon   , CustomTags.ini, BtnCustom4  , Cstm4Icon
  IniRead, Cstm4Enabled, CustomTags.ini, BtnCustom4  , Cstm4Enabled
  
  IniRead, BBStartTag5 , CustomTags.ini, BtnCustom5  , BBStartTag5
  IniRead, BBEndTag5   , CustomTags.ini, BtnCustom5  , BBEndTag5
  IniRead, BBToolTip5  , CustomTags.ini, BtnCustom5  , BBToolTip5
  IniRead, Cstm5Icon   , CustomTags.ini, BtnCustom5  , Cstm5Icon
  IniRead, Cstm5Enabled, CustomTags.ini, BtnCustom5  , Cstm5Enabled
  
  IniRead, BBStartTag6 , CustomTags.ini, BtnCustom6  , BBStartTag6
  IniRead, BBEndTag6   , CustomTags.ini, BtnCustom6  , BBEndTag6
  IniRead, BBToolTip6  , CustomTags.ini, BtnCustom6  , BBToolTip6
  IniRead, Cstm6Icon   , CustomTags.ini, BtnCustom6  , Cstm6Icon
  IniRead, Cstm6Enabled, CustomTags.ini, BtnCustom6  , Cstm6Enabled
  
  IniRead, BBStartTag7 , CustomTags.ini, BtnCustom7  , BBStartTag7
  IniRead, BBEndTag7   , CustomTags.ini, BtnCustom7  , BBEndTag7
  IniRead, BBToolTip7  , CustomTags.ini, BtnCustom7  , BBToolTip7
  IniRead, Cstm7Icon   , CustomTags.ini, BtnCustom7  , Cstm7Icon
  IniRead, Cstm7Enabled, CustomTags.ini, BtnCustom7  , Cstm7Enabled
  
  IniRead, BBStartTag8 , CustomTags.ini, BtnCustom8  , BBStartTag8
  IniRead, BBEndTag8   , CustomTags.ini, BtnCustom8  , BBEndTag8
  IniRead, BBToolTip8  , CustomTags.ini, BtnCustom8  , BBToolTip8
  IniRead, Cstm8Icon   , CustomTags.ini, BtnCustom8  , Cstm8Icon
  IniRead, Cstm8Enabled, CustomTags.ini, BtnCustom8  , Cstm8Enabled
  
  IniRead, BBStartTag9 , CustomTags.ini, BtnCustom9  , BBStartTag9
  IniRead, BBEndTag9   , CustomTags.ini, BtnCustom9  , BBEndTag9
  IniRead, BBToolTip9  , CustomTags.ini, BtnCustom9  , BBToolTip9
  IniRead, Cstm9Icon   , CustomTags.ini, BtnCustom9  , Cstm9Icon
  IniRead, Cstm9Enabled, CustomTags.ini, BtnCustom9  , Cstm9Enabled
  
  IniRead, BBStartTag10, CustomTags.ini, BtnCustom10 , BBStartTag10
  IniRead, BBEndTag10  , CustomTags.ini, BtnCustom10 , BBEndTag10
  IniRead, BBToolTip10 , CustomTags.ini, BtnCustom10 , BBToolTip10
  IniRead, Cstm10Icon  , CustomTags.ini, BtnCustom10 , Cstm10Icon
  IniRead, Cstm10Enabled, CustomTags.ini, BtnCustom10, Cstm10Enabled
; ___________________________________________________________________________________________________
;                                                                                inserted by °digit° |
; ~~~ Add NEW Next 10 Custom IniRead ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  IniRead, BBStartTag11 , CustomTags.ini, BtnCustom11  , BBStartTag11
  IniRead, BBEndTag11   , CustomTags.ini, BtnCustom11  , BBEndTag11
  IniRead, BBToolTip11  , CustomTags.ini, BtnCustom11  , BBToolTip11
  IniRead, Cstm11Icon   , CustomTags.ini, BtnCustom11  , Cstm11Icon
  IniRead, Cstm11Enabled, CustomTags.ini, BtnCustom11  , Cstm11Enabled

  IniRead, BBStartTag12 , CustomTags.ini, BtnCustom12  , BBStartTag12
  IniRead, BBEndTag12   , CustomTags.ini, BtnCustom12  , BBEndTag12
  IniRead, BBToolTip12  , CustomTags.ini, BtnCustom12  , BBToolTip12
  IniRead, Cstm12Icon   , CustomTags.ini, BtnCustom12  , Cstm12Icon
  IniRead, Cstm12Enabled, CustomTags.ini, BtnCustom12  , Cstm12Enabled

  IniRead, BBStartTag13 , CustomTags.ini, BtnCustom13  , BBStartTag13
  IniRead, BBEndTag13   , CustomTags.ini, BtnCustom13  , BBEndTag13
  IniRead, BBToolTip13  , CustomTags.ini, BtnCustom13  , BBToolTip13
  IniRead, Cstm13Icon   , CustomTags.ini, BtnCustom13  , Cstm13Icon
  IniRead, Cstm13Enabled, CustomTags.ini, BtnCustom13  , Cstm13Enabled

  IniRead, BBStartTag14 , CustomTags.ini, BtnCustom14  , BBStartTag14
  IniRead, BBEndTag14   , CustomTags.ini, BtnCustom14  , BBEndTag14
  IniRead, BBToolTip14  , CustomTags.ini, BtnCustom14  , BBToolTip14
  IniRead, Cstm14Icon   , CustomTags.ini, BtnCustom14  , Cstm14Icon
  IniRead, Cstm14Enabled, CustomTags.ini, BtnCustom14  , Cstm14Enabled

  IniRead, BBStartTag15 , CustomTags.ini, BtnCustom15  , BBStartTag15
  IniRead, BBEndTag15   , CustomTags.ini, BtnCustom15  , BBEndTag15
  IniRead, BBToolTip15  , CustomTags.ini, BtnCustom15  , BBToolTip15
  IniRead, Cstm15Icon   , CustomTags.ini, BtnCustom15  , Cstm15Icon
  IniRead, Cstm15Enabled, CustomTags.ini, BtnCustom15  , Cstm15Enabled

  IniRead, BBStartTag16 , CustomTags.ini, BtnCustom16  , BBStartTag16
  IniRead, BBEndTag16   , CustomTags.ini, BtnCustom16  , BBEndTag16
  IniRead, BBToolTip16  , CustomTags.ini, BtnCustom16  , BBToolTip16
  IniRead, Cstm16Icon   , CustomTags.ini, BtnCustom16  , Cstm16Icon
  IniRead, Cstm16Enabled, CustomTags.ini, BtnCustom16  , Cstm16Enabled

  IniRead, BBStartTag17 , CustomTags.ini, BtnCustom17  , BBStartTag17
  IniRead, BBEndTag17   , CustomTags.ini, BtnCustom17  , BBEndTag17
  IniRead, BBToolTip17  , CustomTags.ini, BtnCustom17  , BBToolTip17
  IniRead, Cstm17Icon   , CustomTags.ini, BtnCustom17  , Cstm17Icon
  IniRead, Cstm17Enabled, CustomTags.ini, BtnCustom17  , Cstm17Enabled

  IniRead, BBStartTag18 , CustomTags.ini, BtnCustom18  , BBStartTag18
  IniRead, BBEndTag18   , CustomTags.ini, BtnCustom18  , BBEndTag18
  IniRead, BBToolTip18  , CustomTags.ini, BtnCustom18  , BBToolTip18
  IniRead, Cstm18Icon   , CustomTags.ini, BtnCustom18  , Cstm18Icon
  IniRead, Cstm18Enabled, CustomTags.ini, BtnCustom18  , Cstm18Enabled

  IniRead, BBStartTag19 , CustomTags.ini, BtnCustom19  , BBStartTag19
  IniRead, BBEndTag19   , CustomTags.ini, BtnCustom19  , BBEndTag19
  IniRead, BBToolTip19  , CustomTags.ini, BtnCustom19  , BBToolTip19
  IniRead, Cstm19Icon   , CustomTags.ini, BtnCustom19  , Cstm19Icon
  IniRead, Cstm19Enabled, CustomTags.ini, BtnCustom19  , Cstm19Enabled

  IniRead, BBStartTag20, CustomTags.ini, BtnCustom20 , BBStartTag20
  IniRead, BBEndTag20  , CustomTags.ini, BtnCustom20 , BBEndTag20
  IniRead, BBToolTip20 , CustomTags.ini, BtnCustom20 , BBToolTip20
  IniRead, Cstm20Icon  , CustomTags.ini, BtnCustom20 , Cstm20Icon
  IniRead, Cstm20Enabled, CustomTags.ini, BtnCustom20, Cstm20Enabled
; ___________________________________________________________________________________________________|
Return
;##############################################################################
;###### End of Custom BBCode Tags #############################################
;##############################################################################


;##############################################################################
;###### language variables ####################################################
;##############################################################################
ReadLangStrings:
  ; GUI1 (Main Gui) ###########################################################
  ; Gui1 MenuBar
  IniRead, lang_gui1_filemenu, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_filemenu
  IniRead, lang_gui1_editmenu, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_editmenu
  
  ; Gui1 FileMenu
  IniRead, lang_gui1_open, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_open
  IniRead, lang_gui1_savepost, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_savepost
  IniRead, lang_gui1_saveaspost, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_saveaspost
  IniRead, lang_gui1_savesig, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_savesig
  IniRead, lang_gui1_pref, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_pref
  IniRead, lang_gui1_exit, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_exit
  
  ; Gui1 EditMenu
  IniRead, lang_gui1_undo, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_undo
  IniRead, lang_gui1_cut, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_cut
  IniRead, lang_gui1_copy, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_copy
  IniRead, lang_gui1_paste, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_paste
  IniRead, lang_gui1_delete, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_delete
  IniRead, lang_gui1_select, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_select
  IniRead, lang_gui1_clear, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_clear
  
  ; Gui1 HelpMenu
  IniRead, lang_gui1_shortcut, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_shortcut
  IniRead, lang_gui1_clipboarduse, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_clipboarduse
  IniRead, lang_gui1_customize, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_customize
  IniRead, lang_gui1_bbcode, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_bbcode  
  IniRead, lang_gui1_update, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_update
  IniRead, lang_gui1_about, %A_ScriptDir%\lang\%Lang%, Gui1Menu, lang_gui1_about
  
  ; Gui1 ToolTips for IconButtons
  IniRead, lang_gui1_TTBold, %A_ScriptDir%\lang\%Lang%, Gui1ToolTips, lang_gui1_TTBold
  IniRead, lang_gui1_TTItalic, %A_ScriptDir%\lang\%Lang%, Gui1ToolTips, lang_gui1_TTItalic
  IniRead, lang_gui1_TTUnderline, %A_ScriptDir%\lang\%Lang%, Gui1ToolTips, lang_gui1_TTUnderline
  IniRead, lang_gui1_TTQuote, %A_ScriptDir%\lang\%Lang%, Gui1ToolTips, lang_gui1_TTQuote
  IniRead, lang_gui1_TTCode, %A_ScriptDir%\lang\%Lang%, Gui1ToolTips, lang_gui1_TTCode
  IniRead, lang_gui1_TTUrl, %A_ScriptDir%\lang\%Lang%, Gui1ToolTips, lang_gui1_TTUrl
  IniRead, lang_gui1_TTUrlDesc, %A_ScriptDir%\lang\%Lang%, Gui1ToolTips, lang_gui1_TTUrlDesc
  IniRead, lang_gui1_TTEmail, %A_ScriptDir%\lang\%Lang%, Gui1ToolTips, lang_gui1_TTEmail
  IniRead, lang_gui1_TTImage, %A_ScriptDir%\lang\%Lang%, Gui1ToolTips, lang_gui1_TTImage
  IniRead, lang_gui1_TTColor, %A_ScriptDir%\lang\%Lang%, Gui1ToolTips, lang_gui1_TTColor
  IniRead, lang_gui1_TTSize, %A_ScriptDir%\lang\%Lang%, Gui1ToolTips, lang_gui1_TTSize
  IniRead, lang_gui1_TTListNum, %A_ScriptDir%\lang\%Lang%, Gui1ToolTips, lang_gui1_TTListNum
  IniRead, lang_gui1_TTLetter, %A_ScriptDir%\lang\%Lang%, Gui1ToolTips, lang_gui1_TTLetter
  IniRead, lang_gui1_TTListUnNum, %A_ScriptDir%\lang\%Lang%, Gui1ToolTips, lang_gui1_TTListUnNum
  IniRead, lang_gui1_TTListElement, %A_ScriptDir%\lang\%Lang%, Gui1ToolTips, lang_gui1_TTListElement
  IniRead, lang_gui1_TTSmileys, %A_ScriptDir%\lang\%Lang%, Gui1ToolTips, lang_gui1_TTSmileys
  IniRead, lang_gui1_TTPinned, %A_ScriptDir%\lang\%Lang%, Gui1ToolTips, lang_gui1_TTPinned
  
  ; Gui1 subroutines
  IniRead, lang_gui1_MsgExit, %A_ScriptDir%\lang\%Lang%, Gui1Subroutines, lang_gui1_MsgExit
  IniRead, lang_gui1_MsgEditSig, %A_ScriptDir%\lang\%Lang%, Gui1Subroutines, lang_gui1_MsgEditSig
  IniRead, lang_gui1_MsgDelSig, %A_ScriptDir%\lang\%Lang%, Gui1Subroutines, lang_gui1_MsgDelSig
  IniRead, lang_gui1_MsgBtnReset, %A_ScriptDir%\lang\%Lang%, Gui1Subroutines, lang_gui1_MsgBtnReset
  IniRead, lang_gui1_MsgOverWrite, %A_ScriptDir%\lang\%Lang%, Gui1Subroutines, lang_gui1_MsgOverWrite
  IniRead, lang_gui1_MsgOpenRecentFile, %A_ScriptDir%\lang\%Lang%, Gui1Subroutines, lang_gui1_MsgOpenRecentFile 
  IniRead, lang_gui1_MsgOpenRecentFileError, %A_ScriptDir%\lang\%Lang%, Gui1Subroutines, lang_gui1_MsgOpenRecentFileError
  IniRead, lang_gui1_MsgCheckUpdates, %A_ScriptDir%\lang\%Lang%, Gui1Subroutines, lang_gui1_MsgCheckUpdates
  IniRead, lang_gui1_MsgNewUpdates, %A_ScriptDir%\lang\%Lang%, Gui1Subroutines, lang_gui1_MsgNewUpdates
  IniRead, lang_gui1_MsgUpdateVisit, %A_ScriptDir%\lang\%Lang%, Gui1Subroutines, lang_gui1_MsgUpdateVisit
  IniRead, lang_gui1_MsgNoNewUpdate, %A_ScriptDir%\lang\%Lang%, Gui1Subroutines, lang_gui1_MsgNoNewUpdate
  StringReplace, lang_gui1_MsgEditSig, lang_gui1_MsgEditSig, ~n~, `n, All
  StringReplace, lang_gui1_MsgCheckUpdates, lang_gui1_MsgCheckUpdates, ~n~, `n, All
  StringReplace, lang_gui1_MsgNewUpdates, lang_gui1_MsgNewUpdates, ~n~, `n, All
  
  ; Gui1 controls (label)
  IniRead, lang_gui1_ChkSignature, %A_ScriptDir%\lang\%Lang%, Gui1Controls, lang_gui1_ChkSignature
  IniRead, lang_gui1_BtnEditSig, %A_ScriptDir%\lang\%Lang%, Gui1Controls, lang_gui1_BtnEditSig
  IniRead, lang_gui1_BtnDelSig, %A_ScriptDir%\lang\%Lang%, Gui1Controls, lang_gui1_BtnDelSig
  IniRead, lang_gui1_BtnSend, %A_ScriptDir%\lang\%Lang%, Gui1Controls, lang_gui1_BtnSend
  IniRead, lang_gui1_BtnPreview, %A_ScriptDir%\lang\%Lang%, Gui1Controls, lang_gui1_BtnPreview
  IniRead, lang_gui1_BtnReset, %A_ScriptDir%\lang\%Lang%, Gui1Controls, lang_gui1_BtnReset
  IniRead, lang_gui1_BtnCustomize, %A_ScriptDir%\lang\%Lang%, Gui1Controls, lang_gui1_BtnCustomize
  
  ; Gui1 titles
  IniRead, lang_gui1_TtlGui1, %A_ScriptDir%\lang\%Lang%, Gui1Titles, lang_gui1_TtlGui1
  IniRead, lang_gui1_TtlOpenPost, %A_ScriptDir%\lang\%Lang%, Gui1Titles, lang_gui1_TtlOpenPost
  IniRead, lang_gui1_TtlSavePost, %A_ScriptDir%\lang\%Lang%, Gui1Titles, lang_gui1_TtlSavePost
  IniRead, lang_gui1_TtlSaveSig, %A_ScriptDir%\lang\%Lang%, Gui1Titles, lang_gui1_TtlSaveSig
  IniRead, lang_gui1_TtlMsgExit, %A_ScriptDir%\lang\%Lang%, Gui1Titles, lang_gui1_TtlMsgExit
  IniRead, lang_gui1_TtlMsgEditSig, %A_ScriptDir%\lang\%Lang%, Gui1Titles, lang_gui1_TtlMsgEditSig
  IniRead, lang_gui1_TtlMsgDelSig, %A_ScriptDir%\lang\%Lang%, Gui1Titles, lang_gui1_TtlMsgDelSig
  IniRead, lang_gui1_TtlMsgBtnReset, %A_ScriptDir%\lang\%Lang%, Gui1Titles, lang_gui1_TtlMsgBtnReset
  IniRead, lang_gui1_TtlMsgOverWrite, %A_ScriptDir%\lang\%Lang%, Gui1Titles, lang_gui1_TtlMsgOverWrite
  IniRead, lang_gui1_TtlMsgOpenRecentFile, %A_ScriptDir%\lang\%Lang%, Gui1Titles, lang_gui1_TtlMsgOpenRecentFile
  IniRead, lang_gui1_TtlMsgOpenRecentFileError, %A_ScriptDir%\lang\%Lang%, Gui1Titles, lang_gui1_TtlMsgOpenRecentFileError
  IniRead, lang_gui1_TtlMsgCheckUpdates, %A_ScriptDir%\lang\%Lang%, Gui1Titles, lang_gui1_TtlMsgCheckUpdates
  
  ; GUI2 (Font Color Gui) #####################################################
  ; Gui2 controls
  IniRead, lang_gui2_TxtColor1, %A_ScriptDir%\lang\%Lang%, Gui2Controls, lang_gui2_TxtColor1
  IniRead, lang_gui2_TxtColor2, %A_ScriptDir%\lang\%Lang%, Gui2Controls, lang_gui2_TxtColor2
  IniRead, lang_gui2_TxtColor3, %A_ScriptDir%\lang\%Lang%, Gui2Controls, lang_gui2_TxtColor3
  IniRead, lang_gui2_TxtColor4, %A_ScriptDir%\lang\%Lang%, Gui2Controls, lang_gui2_TxtColor4
  IniRead, lang_gui2_TxtColor5, %A_ScriptDir%\lang\%Lang%, Gui2Controls, lang_gui2_TxtColor5
  IniRead, lang_gui2_TxtColor6, %A_ScriptDir%\lang\%Lang%, Gui2Controls, lang_gui2_TxtColor6
  IniRead, lang_gui2_TxtColor7, %A_ScriptDir%\lang\%Lang%, Gui2Controls, lang_gui2_TxtColor7
  IniRead, lang_gui2_TxtColor8, %A_ScriptDir%\lang\%Lang%, Gui2Controls, lang_gui2_TxtColor8
  IniRead, lang_gui2_TxtColor9, %A_ScriptDir%\lang\%Lang%, Gui2Controls, lang_gui2_TxtColor9
  IniRead, lang_gui2_TxtColor10, %A_ScriptDir%\lang\%Lang%, Gui2Controls, lang_gui2_TxtColor10
  IniRead, lang_gui2_TxtColor11, %A_ScriptDir%\lang\%Lang%, Gui2Controls, lang_gui2_TxtColor11
  IniRead, lang_gui2_TxtColor12, %A_ScriptDir%\lang\%Lang%, Gui2Controls, lang_gui2_TxtColor12
  IniRead, lang_gui2_TxtColor13, %A_ScriptDir%\lang\%Lang%, Gui2Controls, lang_gui2_TxtColor13
  IniRead, lang_gui2_TxtColor14, %A_ScriptDir%\lang\%Lang%, Gui2Controls, lang_gui2_TxtColor14
  IniRead, lang_gui2_BtnCustomColor, %A_ScriptDir%\lang\%Lang%, Gui2Controls, lang_gui2_BtnCustomColor
  
  ; Gui2 titles
  IniRead, lang_gui2_TtlGui2, %A_ScriptDir%\lang\%Lang%, Gui2Titles, lang_gui2_TtlGui2
  
  ; GUI3 (Font Size) ##########################################################
  ; Gui3 controls
  IniRead, lang_gui3_DDLSize, %A_ScriptDir%\lang\%Lang%, Gui3Controls, lang_gui3_DDLSize
  IniRead, lang_gui3_BtnSubmitUserDefinedSize, %A_ScriptDir%\lang\%Lang%, Gui3Controls, lang_gui3_BtnSubmitUserDefinedSize
  
  ; Gui3 titles
  IniRead, lang_gui3_TtlGui3, %A_ScriptDir%\lang\%Lang%, Gui3Titles, lang_gui3_TtlGui3
  
  ; GUI4 (Smiley Gui) #########################################################
  ; Gui4 controls
  IniRead, lang_gui4_TxtAddSmiley, %A_ScriptDir%\lang\%Lang%, Gui4Controls, lang_gui4_TxtAddSmiley
  
  ; Gui4 titles
  IniRead, lang_gui4_TtlGui4, %A_ScriptDir%\lang\%Lang%, Gui4Titles, lang_gui4_TtlGui4
  
  ; GUI5 (Help Gui) ###########################################################
  ; Gui5 titles
  IniRead, lang_gui5_TtlShortcuts, %A_ScriptDir%\lang\%Lang%, Gui5Titles, lang_gui5_TtlShortcuts
  IniRead, lang_gui5_TtlClipboard, %A_ScriptDir%\lang\%Lang%, Gui5Titles, lang_gui5_TtlClipboard
  IniRead, lang_gui5_TtlCustomize, %A_ScriptDir%\lang\%Lang%, Gui5Titles, lang_gui5_TtlCustomize
  IniRead, lang_gui5_TtlBBCode, %A_ScriptDir%\lang\%Lang%, Gui5Titles, lang_gui5_TtlBBCode
  
  ; GUI6 (Preferences Gui) ####################################################
  ; Gui6 subroutines
  IniRead, lang_gui6_MsgBrowserExe, %A_ScriptDir%\lang\%Lang%, Gui6Subroutines, lang_gui6_MsgBrowserExe
  
  ; Gui6 controls
  IniRead, lang_gui6_GrpGeneral, %A_ScriptDir%\lang\%Lang%, Gui6Controls, lang_gui6_GrpGeneral
  IniRead, lang_gui6_TxtFontSize, %A_ScriptDir%\lang\%Lang%, Gui6Controls, lang_gui6_TxtFontSize
  IniRead, lang_gui6_TxtLanguage, %A_ScriptDir%\lang\%Lang%, Gui6Controls, lang_gui6_TxtLanguage
  IniRead, lang_gui6_TxtBrowser, %A_ScriptDir%\lang\%Lang%, Gui6Controls, lang_gui6_TxtBrowser
  IniRead, lang_gui6_TxtHistory, %A_ScriptDir%\lang\%Lang%, Gui6Controls, lang_gui6_TxtHistory
  IniRead, lang_gui6_BtnClearHistory, %A_ScriptDir%\lang\%Lang%, Gui6Controls, lang_gui6_BtnClearHistory  
  IniRead, lang_gui6_GrpCstmBBCodeTags, %A_ScriptDir%\lang\%Lang%, Gui6Controls, lang_gui6_GrpCstmBBCodeTags
  IniRead, lang_gui6_ChkCstmBtns, %A_ScriptDir%\lang\%Lang%, Gui6Controls, lang_gui6_ChkCstmBtns
  IniRead, lang_gui6_BtnOK, %A_ScriptDir%\lang\%Lang%, Gui6Controls, lang_gui6_BtnOK
  
  ; Gui6 titles
  IniRead, lang_gui6_TtlGui6, %A_ScriptDir%\lang\%Lang%, Gui6Titles, lang_gui6_TtlGui6
  IniRead, lang_gui6_TtlChooseBrowser, %A_ScriptDir%\lang\%Lang%, Gui6Titles, lang_gui6_TtlChooseBrowser
  IniRead, lang_gui6_TtlMsgBrowserExe, %A_ScriptDir%\lang\%Lang%, Gui6Titles, lang_gui6_TtlMsgBrowserExe
  
  ; GUI7 (About Gui) ##########################################################
  ; Gui7 controls
  IniRead, lang_gui7_TxtThread, %A_ScriptDir%\lang\%Lang%, Gui7Controls, lang_gui7_TxtThread
  IniRead, lang_gui7_TxtForumLink, %A_ScriptDir%\lang\%Lang%, Gui7Controls, lang_gui7_TxtForumLink 
  IniRead, lang_gui7_TxtHomepage, %A_ScriptDir%\lang\%Lang%, Gui7Controls, lang_gui7_TxtHomepage
  IniRead, lang_gui7_TxtGPL, %A_ScriptDir%\lang\%Lang%, Gui7Controls, lang_gui7_TxtGPL
  StringReplace, lang_gui7_TxtGPL, lang_gui7_TxtGPL, ~n~, `n, All
  
  ; Gui7 titles
  IniRead, lang_gui7_TtlGui7, %A_ScriptDir%\lang\%Lang%, Gui7Titles, lang_gui7_TtlGui7
  
  ; GUI8 (Credits Gui) ########################################################
  ; Gui8 titles
  IniRead, lang_gui8_TtlGui8, %A_ScriptDir%\lang\%Lang%, Gui8Titles, lang_gui8_TtlGui8
  
  ; GUI9 (Custom button Gui) ##################################################
  ; Gui9 titles
  IniRead, lang_gui9_TtlGui9, %A_ScriptDir%\lang\%Lang%, Gui9Titles, lang_gui9_TtlGui9
  IniRead, lang_gui9_TtlOpenIcon, %A_ScriptDir%\lang\%Lang%, Gui9Titles, lang_gui9_TtlOpenIcon
  IniRead, lang_gui9_TtlMsgAssignIcon, %A_ScriptDir%\lang\%Lang%, Gui9Titles, lang_gui9_TtlMsgAssignIcon
  
  ; Gui9 controls
  IniRead, lang_gui9_GrpCstmBBCodeTags, %A_ScriptDir%\lang\%Lang%, Gui9Controls, lang_gui9_GrpCstmBBCodeTags
  IniRead, lang_gui9_TxtStartTag, %A_ScriptDir%\lang\%Lang%, Gui9Controls, lang_gui9_TxtStartTag
  IniRead, lang_gui9_TxtEndTag, %A_ScriptDir%\lang\%Lang%, Gui9Controls, lang_gui9_TxtEndTag
  IniRead, lang_gui9_TxtToolTipTag, %A_ScriptDir%\lang\%Lang%, Gui9Controls, lang_gui9_TxtToolTipTag
  IniRead, lang_gui9_TxtIcon, %A_ScriptDir%\lang\%Lang%, Gui9Controls, lang_gui9_TxtIcon
  IniRead, lang_gui9_TxtEnable, %A_ScriptDir%\lang\%Lang%, Gui9Controls, lang_gui9_TxtEnable
  IniRead, lang_gui9_BtnCstmSave, %A_ScriptDir%\lang\%Lang%, Gui9Controls, lang_gui9_BtnCstmSave  
  
  ; Gui9 subroutines
  IniRead, lang_gui9_MsgAssignIcon, %A_ScriptDir%\lang\%Lang%, Gui9Subroutines, lang_gui9_MsgAssignIcon
Return
;##############################################################################
;###### End of language variables #############################################
;##############################################################################


;##############################################################################
;####### MainGUI ##############################################################
;##############################################################################
CreateMainMenu:
  ; Read recent files from BBCodeWriter.ini
  IniRead, RecentFilesList, BBCodeWriter.ini, Recent, RecentFiles

  Menu, Tray, Icon, %A_ScriptDir%\phpbb\ico\bbcode.ico

  ; Define Menu Bar
  Menu, FileMenu, Add, %lang_gui1_open%, LoadPosting
  Menu, FileMenu, Add
  Menu, FileMenu, Add, %lang_gui1_savepost%, SavePosting 
  Menu, FileMenu, Add, %lang_gui1_saveaspost%, SaveAsPosting
  Menu, FileMenu, Add
  Menu, FileMenu, Add, %lang_gui1_savesig%, SaveSignature
  Menu, FileMenu, Add
  Menu, FileMenu, Add, %lang_gui1_pref%, CreatePreferencesGUI
  Menu, FileMenu, Add
  
  If RecentFilesList is not space
    {
      Loop, Parse, RecentFilesList, |
        {
          Menu, FileMenu, Add, %A_Index% %A_LoopField%, Recent%A_Index%
        }
      Menu, FileMenu, Add
    }

  Menu, FileMenu, Add, %lang_gui1_exit%, GuiClose
  
  Menu, EditMenu, Add, %lang_gui1_undo%, UndoChanges
  Menu, EditMenu, Add
  Menu, EditMenu, Add, %lang_gui1_cut%, CutText
  Menu, EditMenu, Add, %lang_gui1_copy%, CopyText
  Menu, EditMenu, Add, %lang_gui1_paste%, PasteText
  Menu, EditMenu, Add, %lang_gui1_delete%, DeleteText
  Menu, EditMenu, Add, %lang_gui1_select%, SelectAllText
  Menu, EditMenu, Add
  Menu, EditMenu, Add, %lang_gui1_clear%, ClearClip
  
  Menu, HelpMenu, Add, %lang_gui1_shortcut%, DisplayShortcuts
  Menu, HelpMenu, Add, %lang_gui1_clipboarduse%, DisplayTip
  Menu, HelpMenu, Add
  Menu, HelpMenu, Add, %lang_gui1_customize%, DisplayCustomize
  Menu, HelpMenu, Add, %lang_gui1_bbcode%, DisplayBBCode
  Menu, HelpMenu, Add
  Menu, HelpMenu, Add, %lang_gui1_update%, CheckForUpdate
  Menu, HelpMenu, Add
  Menu, HelpMenu, Add, %lang_gui1_about%, CreateAboutGUI
  
  Menu, MenuBar, Add, %lang_gui1_filemenu%, :FileMenu
  Menu, MenuBar, Add, %lang_gui1_editmenu%, :EditMenu
  Menu, MenuBar, Add, &?, :HelpMenu
Return

CreateMainGui:
  ; Fill variable for DropDown control
  SigList = |
  Loop, %A_ScriptDir%\signatures\*.txt
    {
      SigList = %SigList%|%A_LoopFileName%
    }

  ; Attach Menu bar to Gui
  Gui, 1:Menu, MenuBar
  
  Gui, 1:Margin, 5, 5
  Gui, 1:+Resize
    
  ; Borderline between Menu and IconButtons
  Gui, 1:Add, GroupBox, vGrpMenuBorder xm ym-11 w%GrpW% h8 
  
  ; Add Icon Buttons
  Gui, 1:Add, Button, gBtnBold vBtnBold xm ym h25 w25 Section +%BS_ICON%
  Gui, 1:Add, Button, gBtnItalic vBtnItalic xp+28 yp h25 w25 +%BS_ICON%
  Gui, 1:Add, Button, gBtnUnderline vBtnUnderline xp+28 yp h25 w25 +%BS_ICON%
  Gui, 1:Add, Button, gBtnQuote vBtnQuote xp+28 yp h25 w25 +%BS_ICON%
  Gui, 1:Add, Button, gBtnCode vBtnCode xp+28 yp h25 w25 +%BS_ICON%
  Gui, 1:Add, Button, gBtnUrl vBtnUrl xp+35 yp h25 w25 +%BS_ICON%
  Gui, 1:Add, Button, gBtnUrlDesc vBtnUrlDesc xp+28 yp h25 w25 +%BS_ICON%
  Gui, 1:Add, Button, gBtnEmail vBtnEmail xp+28 yp h25 w25 +%BS_ICON%
  Gui, 1:Add, Button, gBtnImage vBtnImage xp+35 yp h25 w25 +%BS_ICON%
  Gui, 1:Add, Button, gBtnColor vBtnColor xp+28 yp h25 w25 +%BS_ICON%
  Gui, 1:Add, Button, gBtnSize vBtnSize xp+28 yp h25 w25 +%BS_ICON%
  Gui, 1:Add, Button, gBtnListNum vBtnListNum xp+35 yp h25 w25 +%BS_ICON%
  Gui, 1:Add, Button, gBtnListLetter vBtnListLetter xp+28 yp h25 w25 +%BS_ICON%
  Gui, 1:Add, Button, gBtnListUnNum vBtnListUnNum xp+28 yp h25 w25 +%BS_ICON%
  Gui, 1:Add, Button, gBtnListElement vBtnListElement xp+28 yp h25 w25 +%BS_ICON%
  Gui, 1:Add, Button, gBtnSmileys vBtnSmileys xp+39 yp h25 w25 +%BS_ICON%
  Gui, 1:Add, Button, gBtnPinned vBtnPinned x%BG4X% yp h25 w25 +%BS_ICON%

  If CstmBarEnabled = 1
    {  
      ; Borderline between IconButtons and Custom buttons
      Gui, 1:Add, GroupBox, vGrpCstmBorder xm ym+23 Section w%GrpW% h8
      
      ; Add Custom Buttons
      Gui, 1:Add, Button, gBtnCustom1   vBtnCustom1  xm ys+11 h25 w25 +%BS_ICON%
      Gui, 1:Add, Button, gBtnCustom2   vBtnCustom2  xp+28 yp h25 w25 +%BS_ICON%
      Gui, 1:Add, Button, gBtnCustom3   vBtnCustom3  xp+28 yp h25 w25 +%BS_ICON%
      Gui, 1:Add, Button, gBtnCustom4   vBtnCustom4  xp+28 yp h25 w25 +%BS_ICON%
      Gui, 1:Add, Button, gBtnCustom5   vBtnCustom5  xp+28 yp h25 w25 +%BS_ICON%
      Gui, 1:Add, Button, gBtnCustom6   vBtnCustom6  xp+28 yp h25 w25 +%BS_ICON%
      Gui, 1:Add, Button, gBtnCustom7   vBtnCustom7  xp+28 yp h25 w25 +%BS_ICON%
      Gui, 1:Add, Button, gBtnCustom8   vBtnCustom8  xp+28 yp h25 w25 +%BS_ICON%
      Gui, 1:Add, Button, gBtnCustom9   vBtnCustom9  xp+28 yp h25 w25 +%BS_ICON%
      Gui, 1:Add, Button, gBtnCustom10  vBtnCustom10 xp+28 yp h25 w25 +%BS_ICON%
; ___________________________________________________________________________________________________
;                                                                                inserted by °digit° |
; ~~~ Add NEW Next 10 Custom Buttons ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      Gui, 1:Add, Button, gBtnCustom11  vBtnCustom11 xp+32 yp h25 w25 +%BS_ICON%  ; xp+28 changed
      Gui, 1:Add, Button, gBtnCustom12  vBtnCustom12 xp+28 yp h25 w25 +%BS_ICON%
      Gui, 1:Add, Button, gBtnCustom13  vBtnCustom13 xp+28 yp h25 w25 +%BS_ICON%
      Gui, 1:Add, Button, gBtnCustom14  vBtnCustom14 xp+28 yp h25 w25 +%BS_ICON%
      Gui, 1:Add, Button, gBtnCustom15  vBtnCustom15 xp+28 yp h25 w25 +%BS_ICON%
      Gui, 1:Add, Button, gBtnCustom16  vBtnCustom16 xp+28 yp h25 w25 +%BS_ICON%
      Gui, 1:Add, Button, gBtnCustom17  vBtnCustom17 xp+28 yp h25 w25 +%BS_ICON%
      Gui, 1:Add, Button, gBtnCustom18  vBtnCustom18 xp+28 yp h25 w25 +%BS_ICON%
      Gui, 1:Add, Button, gBtnCustom19  vBtnCustom19 xp+28 yp h25 w25 +%BS_ICON%
      Gui, 1:Add, Button, gBtnCustom20  vBtnCustom20 xp+28 yp h25 w25 +%BS_ICON%
; ___________________________________________________________________________________________________|

      Gui, 1:Add, Button, gBtnCustomize vBtnCustomize x%BG3X% yp+3 h20 w60, %lang_gui1_BtnCustomize%
    }

  Gui, 1:Font, s%EdtFontSize% 
  Gui, 1:Add, Edit, vEdtComment xs y%EdtY% h%EdtH% w%EdtW% Section
  Gui, 1:Font
  
  Gui, 1:Add, Checkbox, gChkSig vChkSig xs y%ChkY% Section, %lang_gui1_ChkSignature%
  Gui, 1:Add, DropDownList, vDDLSig xs+70 y%DDLY% r8 w160 Sort, %SigList%
  Gui, 1:Add, Button, gBtnEditSig vBtnEditSig xp+165 y%BSgY% h17 w42, %lang_gui1_BtnEditSig%
  Gui, 1:Add, Button, gBtnDelSig vBtnDelSig xp+47 y%BSgY% h17 w42, %lang_gui1_BtnDelSig%
  
  Gui, 1:Add, Button, gBtnSend vBtnSend x%BG1X% y%BG3Y% w60, %lang_gui1_BtnSend%
  Gui, 1:Add, Button, gBtnPreview vBtnPreview x%BG2X% y%BG3Y% w60, %lang_gui1_BtnPreview%
  Gui, 1:Add, Button, gBtnReset vBtnReset x%BG3X% y%BG3Y% w60, %lang_gui1_BtnReset%
  
  Gui, 1:Add, Statusbar
  SB_SetParts(100,133) 
  SB_SetIcon(A_ScriptDir "\phpbb\ico\clean.ico", 1, 2)
  
  ; Create Gui, but hide it for now - due to following Icon assignment
  Gui, 1:Show, x%PosX% y%PosY% w%GuiW% h%GuiH% +Hide, %ScriptName% - %lang_gui1_TtlGui1%
  
  WinGet, WinHandle, ID, AHK BBCodeWriter   ;Handle needed for Search-dialog
  
  ; Wait for Gui Creation
  WinWait, %ScriptName%
    
  ; Find the Window Handle
  WinHandle := WinExist(ScriptName)
    
  ; Assign icons to buttons 
  SetButtonGraphic(WinHandle, "2",  A_ScriptDir "\phpbb\ico\bold.ico"              , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "3",  A_ScriptDir "\phpbb\ico\italic.ico"            , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "4",  A_ScriptDir "\phpbb\ico\underline.ico"         , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "5",  A_ScriptDir "\phpbb\ico\quote.ico"             , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "6",  A_ScriptDir "\phpbb\ico\code.ico"              , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "7",  A_ScriptDir "\phpbb\ico\url.ico"               , 16, 16, IMAGE_ICON)
; _______________________________________________________________________________________________________
;                                               "\phpbb\ico\url.ico"                 chanched by °digit° |
  SetButtonGraphic(WinHandle, "8",  A_ScriptDir "\phpbb\ico\urldescribe.ico"       , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "9",  A_ScriptDir "\phpbb\ico\mail.ico"              , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "10", A_ScriptDir "\phpbb\ico\img.ico"               , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "11", A_ScriptDir "\phpbb\ico\color.ico"             , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "12", A_ScriptDir "\phpbb\ico\font.ico"              , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "13", A_ScriptDir "\phpbb\ico\listnum.ico"           , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "14", A_ScriptDir "\phpbb\ico\listletter.ico"        , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "15", A_ScriptDir "\phpbb\ico\listunnum.ico"         , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "16", A_ScriptDir "\phpbb\ico\listelement.ico"       , 16, 16, IMAGE_ICON)
; _______________________________________________________________________________________________________
;                                               "\phpbb\ico\smileys\icon_smile.ico"  chanched by °digit° |
  SetButtonGraphic(WinHandle, "17", A_ScriptDir "\phpbb\ico\BtnSmile.ico"          , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "18", A_ScriptDir "\phpbb\ico\unpinned.ico"          , 16, 16, IMAGE_ICON)

  If CstmBarEnabled = 1
    { 
      SetButtonGraphic(WinHandle, "20", A_ScriptDir "\phpbb\ico\" Cstm1Icon  , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "21", A_ScriptDir "\phpbb\ico\" Cstm2Icon  , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "22", A_ScriptDir "\phpbb\ico\" Cstm3Icon  , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "23", A_ScriptDir "\phpbb\ico\" Cstm4Icon  , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "24", A_ScriptDir "\phpbb\ico\" Cstm5Icon  , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "25", A_ScriptDir "\phpbb\ico\" Cstm6Icon  , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "26", A_ScriptDir "\phpbb\ico\" Cstm7Icon  , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "27", A_ScriptDir "\phpbb\ico\" Cstm8Icon  , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "28", A_ScriptDir "\phpbb\ico\" Cstm9Icon  , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "29", A_ScriptDir "\phpbb\ico\" Cstm10Icon , 16, 16, IMAGE_ICON)
; ___________________________________________________________________________________________________
;                                                                                inserted by °digit° |
; ~~~ Add NEW Next 10 Custom ICONs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      SetButtonGraphic(WinHandle, "30", A_ScriptDir "\phpbb\ico\" Cstm11Icon , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "31", A_ScriptDir "\phpbb\ico\" Cstm12Icon , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "32", A_ScriptDir "\phpbb\ico\" Cstm13Icon , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "33", A_ScriptDir "\phpbb\ico\" Cstm14Icon , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "34", A_ScriptDir "\phpbb\ico\" Cstm15Icon , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "35", A_ScriptDir "\phpbb\ico\" Cstm16Icon , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "36", A_ScriptDir "\phpbb\ico\" Cstm17Icon , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "37", A_ScriptDir "\phpbb\ico\" Cstm18Icon , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "38", A_ScriptDir "\phpbb\ico\" Cstm19Icon , 16, 16, IMAGE_ICON)
      SetButtonGraphic(WinHandle, "39", A_ScriptDir "\phpbb\ico\" Cstm20Icon , 16, 16, IMAGE_ICON)
    }
; ___________________________________________________________________________________________________|
  Gui, 1:Show, x%PosX% y%PosY% w%GuiW% h%GuiH%, %ScriptName% - %lang_gui1_TtlGui1%

  ; Disable ComboBox, 'Edit' button, 'Del' button & focus Edit control
  GuiControl, 1:Disable, DDLSig
  GuiControl, 1:Disable, BtnEditSig
  GuiControl, 1:Disable, BtnDelSig 
  GuiControl, 1:Focus  , EdtComment

  ; Hide disabled custom buttons
  GuiControl, 1:Show%Cstm1Enabled%, BtnCustom1
  GuiControl, 1:Show%Cstm2Enabled%, BtnCustom2
  GuiControl, 1:Show%Cstm3Enabled%, BtnCustom3
  GuiControl, 1:Show%Cstm4Enabled%, BtnCustom4
  GuiControl, 1:Show%Cstm5Enabled%, BtnCustom5
  GuiControl, 1:Show%Cstm6Enabled%, BtnCustom6
  GuiControl, 1:Show%Cstm7Enabled%, BtnCustom7
  GuiControl, 1:Show%Cstm8Enabled%, BtnCustom8
  GuiControl, 1:Show%Cstm9Enabled%, BtnCustom9
  GuiControl, 1:Show%Cstm10Enabled%, BtnCustom10                    
; ___________________________________________________________________________________________________
;                                                                                inserted by °digit° |
; ~~~ Add NEW Next 10 Custom GuiControl ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  GuiControl, 1:Show%Cstm11Enabled%, BtnCustom11
  GuiControl, 1:Show%Cstm12Enabled%, BtnCustom12
  GuiControl, 1:Show%Cstm13Enabled%, BtnCustom13
  GuiControl, 1:Show%Cstm14Enabled%, BtnCustom14
  GuiControl, 1:Show%Cstm15Enabled%, BtnCustom15
  GuiControl, 1:Show%Cstm16Enabled%, BtnCustom16
  GuiControl, 1:Show%Cstm17Enabled%, BtnCustom17
  GuiControl, 1:Show%Cstm18Enabled%, BtnCustom18
  GuiControl, 1:Show%Cstm19Enabled%, BtnCustom19
  GuiControl, 1:Show%Cstm20Enabled%, BtnCustom20
; ___________________________________________________________________________________________________|
  ; Needed for Tooltips
  SetTimer, ShowTip, 100
Return

;Functions for search-dialog
;Hotkeys for handling of search-dialog
#IfWinActive, AHK BBCodeWriter 7
^f::
;Create GUI every time because it can cause problems with hotkeys in other apps
IfWinNotExist Search... ahk_class AutoHotkeyGUI
{
  Gui, 11:+AlwaysOnTop +owner1
  Gui, 11:Add, Edit, w250 vEditSearch
  Gui, 11:Add, Button, gFindString Default section, Next
  Gui, 11:Add, Button, x+5 gFindPreviousString, Previous
  Gui, 11:Add, Button, gFindFirstString x+5, First
  Gui, 11:Add, Button, gFindLastString x+5, Last
  Gui, 11:Add, Text, xs+0 ys+30 w250 h35 vtxtSearchStatus +border
}
Clipboard_Backup := ClipboardAll
Clipboard =
SendInput, ^c
ClipWait, 1
GuiControl, 11:, Edit1, %Clipboard%
Clipboard := Clipboard_Backup
Gui, 11:Show, , Search...
GuiControl, 11:Focus, Edit1, 
return

11GuiClose:
Gui, 11:Destroy
return

#IfWinActive, Search... ahk_class AutoHotkeyGUI
Esc::Gui, 11:Hide

#IfWinActive, AHK BBCodeWriter 7 ahk_class AutoHotkeyGUI
^Esc::Gui, 11:Destroy
^Enter::GoSub, FindString
^Backspace::GoSub, FindPreviousString
^Home::GoSub, FindFirstString
^End::GoSub, FindLastString

#IfWinActive
;End Hotkeys for handling of search-dialog

;Search-functions
;Find always first string
FindFirstString:
lastFind = Thalon ist der oberoberoberbeste     ;most unlikely to have as search-string :-D
GoSub FindString
return

FindLastString:
GuiControlGet, EdtComment, 1:, EdtComment   ;Necessary if "Last" is performed as first search
pos := StrLen(EdtComment)
GoSub, FindPreviousString
return
;Find first/next string
FindString:
IfWinExist Search... ahk_class AutoHotkeyGUI
{
  InitSearch()
  StringGetPos, pos, EdtComment, %EditSearch% ,,offset            ; find the position of the search string
  FinishSearch()
}
Return

;Find previous string
FindPreviousString:
IfWinExist Search... ahk_class AutoHotkeyGUI
{
  InitSearch()
  PostLength := StrLen(EdtComment)
  StringGetPos, pos, EdtComment, %EditSearch% ,r1, % PostLength - pos           ; find the position of the search string
  FinishSearch()
}
Return

InitSearch()
{
  global
  GuiControlGet, EdtComment, 1:, EdtComment
  GuiControlGet, EditSearch, 11:, EditSearch
  
  if (EditSearch != lastFind) 
  {
    offset = 0
    ;hits = 0
  }
  
  GuiControl 1:Focus, EdtComment                           ; focus on main help window to show selection
  SendMessage 0xB6, 0, -999, Edit1, ahk_id %WinHandle%  ; Scroll to top
}

FinishSearch()
{
  global
  if (pos = -1) 
  {
    if (offset = 0) 
    {
;      SB_SetText("'" . EditSearch . "' not found", 1)      ;xxx disabled Statusbar
;      SB_SetText("", 2)
      GuiControl, 11:, txtSearchStatus, % "'" . EditSearch . "' not found"
    }
    else
    {
;      SB_SetText("No more occurrences of '" . EditSearch . "'")      ;xxx disabled Statusbar
;      SB_SetText("", 2)
      GuiControl, 11:, txtSearchStatus, % "No more occurrences of '" . EditSearch . "'"
      offset = 0
      ;hits = 0
    }
    return
  }
  StringLeft __s, EdtComment, %pos%                        ; cut off end to count lines
  StringReplace __s,__s,`n,`n,UseErrorLevel             ; Errorlevel <- line number
  addToPos=%Errorlevel%
  SendMessage 0xB6, 0, ErrorLevel, Edit1, ahk_id %WinHandle% ; Scroll to visible
  offset := pos + addToPos + Strlen(EditSearch)
  SendMessage 0xB1, pos + addToPos, offset, Edit1, ahk_id %WinHandle% ; Select search text
  ; http://msdn.microsoft.com/en-us/library/bb761637(VS.85).aspx
  ; Scroll the caret into view in an edit control:
  SendMessage, EM_SCROLLCARET := 0xB7, 0, 0, Edit1, ahk_id %WinHandle%
  lastFind = %EditSearch%
  ;hits++
  ;SB_SetText("'" . EditSearch . "' found in line " . addToPos + 1, 1)     ;xxx disabled Statusbar
  ;SB_SetText(hits . (hits = 1 ? " hit" : " hits"), 2)
  GuiControl, 11:, txtSearchStatus, % "'" . EditSearch . "' found in line " . addToPos + 1
}
;End Search-functions
;End of Functions für Search dialog

GuiSize:
  ; If Gui is not minimized
  If (A_EventInfo <> 1)
    {
      GuiIsNotMinimized := true
      
      Anchor("EdtComment"   , "wh"      )
      Anchor("GrpMenuBorder", "w"       )
      Anchor("GrpCstmBorder", "w"       )
      Anchor("BtnCustomize" , "x"       )
      Anchor("ChkSig"       , "y"       )
      Anchor("DDLSig"       , "y"       )
      Anchor("BtnEditSig"   , "y"       )
      Anchor("BtnDelSig"    , "y"       )
      Anchor("BtnSend"      , "xy", true)
      Anchor("BtnPreview"   , "xy", true)
      Anchor("BtnReset"     , "xy", true)
      Anchor("BtnPinned"    , "x"       )
      WinSet, Redraw,, %ScriptName%
    }
  Else
    GuiIsNotMinimized := false
Return

GuiClose:
  If PinnedPressed
    GoSub, BtnPinned
  
  ; Write list of recent files to BBCodeWriter.ini
  IniWrite, %RecentFilesList%, BBCodeWriter.ini, Recent, RecentFiles
      
  If GuiIsNotMinimized
    {
      ; Save Gui size and position
      WinGetPos, PosX, PosY, GuiW, GuiH, %ScriptName%
      GuiW := GuiW - 8   ; Subtract Gui Margin and border width 
      GuiH := GuiH - 46  ; Subtract title bar and menu height

      ; Save controls sizes and positions      
      GuiControlGet, Edt, Pos, EdtComment
      GuiControlGet, Grp, Pos, GrpMenuBorder
      GuiControlGet, Chk, Pos, ChkSig                                                                  
      GuiControlGet, DDL, Pos, DDLSig
      GuiControlGet, BSg, Pos, BtnEditSig
      GuiControlGet, BG3, Pos, BtnReset
      
      ; Right justify BtnSend, BtnPreview, BtnCustomize and BtnReset with EdtComment
      BG1X := EdtX + EdtW - 200 ; edit ctrl right border - 3x Btn width - 15px gap - 5px gap
      BG2X := EdtX + EdtW - 135 ; edit ctrl right border - 2x Btn width - 15px gap
      BG3X := EdtX + EdtW - 60  ; edit ctrl right border - 1x Btn width
      BG4X := EdtX + EdtW - 25  ; edit ctrl right border - 1x Btn width
      
      ; Write sizes and positions to BBCodeWriter.ini
      IniWrite, %PosX%, BBCodeWriter.ini, GuiPosition , X_Pos
      IniWrite, %PosY%, BBCodeWriter.ini, GuiPosition , Y_Pos   
      IniWrite, %GuiW%, BBCodeWriter.ini, GuiDimension, W_Gui
      IniWrite, %GuiH%, BBCodeWriter.ini, GuiDimension, H_Gui      
      IniWrite, %EdtY%, BBCodeWriter.ini, EditSize    , Y_Edt
      IniWrite, %EdtW%, BBCodeWriter.ini, EditSize    , W_Edt
      IniWrite, %EdtH%, BBCodeWriter.ini, EditSize    , H_Edt
      IniWrite, %EdtX%, BBCodeWriter.ini, EditSize    , X_Edt
      IniWrite, %GrpW%, BBCodeWriter.ini, GroupBoxSize, W_Grp
      IniWrite, %ChkY%, BBCodeWriter.ini, CheckboxYPos, Y_Chk
      IniWrite, %DDLY%, BBCodeWriter.ini, DDListYPos  , Y_DDL
      IniWrite, %BSgY%, BBCodeWriter.ini, BtnSigYPos  , Y_BSg
      IniWrite, %BG1X%, BBCodeWriter.ini, BtnMainGui  , X_BG1 
      IniWrite, %BG2X%, BBCodeWriter.ini, BtnMainGui  , X_BG2
      IniWrite, %BG3X%, BBCodeWriter.ini, BtnMainGui  , X_BG3
      IniWrite, %BG3Y%, BBCodeWriter.ini, BtnMainGui  , Y_BG3
      IniWrite, %BG4X%, BBCodeWriter.ini, BtnMainGui  , X_BG4
    }
  
  MsgBox, 8243, %lang_gui1_TtlMsgExit%, %lang_gui1_MsgExit% 
  IfMsgBox, Yes
    {
      GoSub, SaveAsPosting
      ExitApp
    }
  IfMsgBox, No
    ExitApp
Return
;##############################################################################  
;####### End of MainGUI #######################################################
;##############################################################################


;##############################################################################
;####### Color Gui ############################################################
;##############################################################################
SelectFontColor:
  Gui, 1:+Disabled
  Gui, 2:+owner +ToolWindow +AlwaysOnTop
  Gui, 2:Margin, 5, 5

  Gui, 2:Add, Picture, gColor1 xm ym, %A_ScriptDir%\phpbb\images\color1.gif
  Gui, 2:Add, Text, gColor1 xp+20 yp, %lang_gui2_TxtColor1%
  Gui, 2:Add, Picture, gColor2 xp-20 yp+20, %A_ScriptDir%\phpbb\images\color2.gif
  Gui, 2:Add, Text, gColor2 xp+20 yp, %lang_gui2_TxtColor2%
  Gui, 2:Add, Picture, gColor3 xp-20 yp+20, %A_ScriptDir%\phpbb\images\color3.gif
  Gui, 2:Add, Text, gColor3 xp+20 yp, %lang_gui2_TxtColor3%
  Gui, 2:Add, Picture, gColor4 xp-20 yp+20, %A_ScriptDir%\phpbb\images\color4.gif
  Gui, 2:Add, Text, gColor4 xp+20 yp, %lang_gui2_TxtColor4%
  Gui, 2:Add, Picture, gColor5 xp-20 yp+20, %A_ScriptDir%\phpbb\images\color5.gif
  Gui, 2:Add, Text, gColor5 xp+20 yp, %lang_gui2_TxtColor5%
  Gui, 2:Add, Picture, gColor6 xp-20 yp+20, %A_ScriptDir%\phpbb\images\color6.gif
  Gui, 2:Add, Text, gColor6 xp+20 yp, %lang_gui2_TxtColor6%
  Gui, 2:Add, Picture, gColor7 xp-20 yp+20, %A_ScriptDir%\phpbb\images\color7.gif
  Gui, 2:Add, Text, gColor7 xp+20 yp, %lang_gui2_TxtColor7%

  Gui, 2:Add, Picture, gColor8 xm+100 ym, %A_ScriptDir%\phpbb\images\color8.gif
  Gui, 2:Add, Text, gColor8 xp+20 yp, %lang_gui2_TxtColor8%
  Gui, 2:Add, Picture, gColor9 xp-20 yp+20, %A_ScriptDir%\phpbb\images\color9.gif
  Gui, 2:Add, Text, gColor9 xp+20 yp, %lang_gui2_TxtColor9%
  Gui, 2:Add, Picture, gColor10 xp-20 yp+20, %A_ScriptDir%\phpbb\images\color10.gif
  Gui, 2:Add, Text, gColor10 xp+20 yp, %lang_gui2_TxtColor10%
  Gui, 2:Add, Picture, gColor11 xp-20 yp+20, %A_ScriptDir%\phpbb\images\color11.gif
  Gui, 2:Add, Text, gColor11 xp+20 yp, %lang_gui2_TxtColor11%
  Gui, 2:Add, Picture, gColor12 xp-20 yp+20, %A_ScriptDir%\phpbb\images\color12.gif
  Gui, 2:Add, Text, gColor12 xp+20 yp, %lang_gui2_TxtColor12%
  Gui, 2:Add, Picture, gColor13 xp-20 yp+20, %A_ScriptDir%\phpbb\images\color13.gif
  Gui, 2:Add, Text, gColor13 xp+20 yp, %lang_gui2_TxtColor13%
  Gui, 2:Add, Picture, gColor14 xp-20 yp+20, %A_ScriptDir%\phpbb\images\color14.gif
  Gui, 2:Add, Text, gColor14 xp+20 yp, %lang_gui2_TxtColor14%
   
  Gui, 2:Add, Button, gBtnCustomColor xm yp+25, %lang_gui2_BtnCustomColor%

  ; Thanks to Micha for his help with calling the system color picker
  ; Details under http://www.autohotkey.com/forum/topic9436.html
    
  ; Most of the setup for the color picker dialog needs to be done only once,
  ; which is why this section is here rather than in the button's subroutine.
  
  /*
  typedef struct tagCHOOSECOLOR {
    DWORD lStructSize;
    HWND hwndOwner;
    HINSTANCE hInstance;
    COLORREF rgbResult;
    COLORREF* lpCustColors;
    DWORD Flags;
    LPARAM lCustData;
    LPCCHOOKPROC lpfnHook;
    LPCTSTR lpTemplateName;
  } CHOOSECOLOR, *LPCHOOSECOLOR;
  */
  
  SizeOfStructForChooseColor = 0x24
  VarSetCapacity(StructForChooseColor, SizeOfStructForChooseColor, 0)
  VarSetCapacity(StructArrayForChooseColor, 64, 0)
  
  Gui, +LastFound
  GuiHWND := WinExist()  ; Relies on the line above to get the unique ID of GUI window.
  
  InsertInteger(SizeOfStructForChooseColor, StructForChooseColor, 0 )  ; DWORD lStructSize
  InsertInteger(GuiHWND                   , StructForChooseColor, 4 )  ; HWND hwndOwner (makes dialog "modal").
  InsertInteger(0x0                       , StructForChooseColor, 8 )  ; HINSTANCE hInstance
  InsertInteger(0x0                       , StructForChooseColor, 12)  ; clr.rgbResult =  0;
  InsertInteger(&StructArrayForChooseColor, StructForChooseColor, 16)  ; COLORREF *lpCustColors
  InsertInteger(0x00000100                , StructForChooseColor, 20)  ; Flag: Anycolor
  InsertInteger(0x0                       , StructForChooseColor, 24)  ; LPARAM lCustData
  InsertInteger(0x0                       , StructForChooseColor, 28)  ; LPCCHOOKPROC lpfnHook
  InsertInteger(0x0                       , StructForChooseColor, 32)  ; LPCTSTR lpTemplateName
Return

Color1:
  Color := ArrayOfColors1
  GoSub, SelectedColor
Return

Color2:
  Color := ArrayOfColors2
  GoSub, SelectedColor
Return

Color3:
  Color := ArrayOfColors3
  GoSub, SelectedColor
Return

Color4:
  Color := ArrayOfColors4
  GoSub, SelectedColor
Return

Color5:
  Color := ArrayOfColors5
  GoSub, SelectedColor
Return

Color6:
  Color := ArrayOfColors6
  GoSub, SelectedColor
Return

Color7:
  Color := ArrayOfColors7
  GoSub, SelectedColor
Return

Color8:
  Color := ArrayOfColors8
  GoSub, SelectedColor
Return

Color9:
  Color := ArrayOfColors9
  GoSub, SelectedColor
Return

Color10:
  Color := ArrayOfColors10
  GoSub, SelectedColor
Return

Color11:
  Color := ArrayOfColors11
  GoSub, SelectedColor
Return

Color12:
  Color := ArrayOfColors12
  GoSub, SelectedColor
Return

Color13:
  Color := ArrayOfColors13
  GoSub, SelectedColor
Return

Color14:
  Color := ArrayOfColors14
  GoSub, SelectedColor
Return

SelectedColor:
  Gui, 1:-Disabled
  Gui, 2:Destroy
  Gui, 1:Default
  
  If ComposeMode = 0
    {    
      ; Check if text is highlighted
      GuiControl, 1:Focus, EdtComment
      Send, ^c
    }

  If CtrlKeyDown != D
    {      
      ; No Text was highlighted    
      If Clipboard is Space
        {    
          Control, EditPaste, [color=%Color%][/color], Edit1, %ScriptName%
          Send, {Left 8}
        }
    
      ; Some text was highlighted
      Else
        {
          If ComposeMode
            {
              EndTagLen := EndTagSum + 8
              Control, EditPaste, [color=%Color%]%Clipboard%[/color], Edit1, %ScriptName%
              GuiControl, 1:Focus, EdtComment 
              Send, {Left %EndTagLen%}
              Clipboard =
            }
          Else
            {
              Control, EditPaste, [color=%Color%]%Clipboard%[/color], Edit1, %ScriptName%
              Clipboard =
            }
        }

      ; Reset variables for ComposeMode      
      SB_SetIcon(A_ScriptDir "\phpbb\ico\clean.ico", 1, 2)
      ComposeMode := false
      
      ; Clear ComposeList and Statusbar Part3
      ComposeList =
      SB_SetText(ComposeList,3)
      
      EndTagSum = 0      
    }
  Else
    {
      EndTagSum := EndTagSum + 8
      
      ; No Text was highlighted    
      If Clipboard is Space
        Clipboard = [color=%Color%][/color]
      Else
        Clipboard = [color=%Color%]%Clipboard%[/color]

      ; Set variables for ComposeMode
      SB_SetIcon(A_ScriptDir "\phpbb\ico\compose.ico", 1, 2)
      ComposeMode := true

      ; Add StartTag to ComposeList      
      ComposeList = %ComposeList% color -
      SB_SetText(ComposeList,3)
    } 
Return

BtnCustomColor:
  WinSet, AlwaysOnTop, Toggle, %lang_gui2_TtlGui2%
  Gui, 2:+Disabled
  
  nRC := DllCall("comdlg32\ChooseColorA", str, StructForChooseColor)  ; Display the dialog.
  If (Errorlevel <> 0) || (nRC = 0)
    {
      Gui, 2:-Disabled
      WinSet, AlwaysOnTop, Toggle, %lang_gui2_TtlGui2%
      WinActivate, %lang_gui2_TtlGui2%
      Return
    }
  
  ; Otherwise, the user pressed OK in the dialog, so determine what was selected.
  SetFormat, Integer, H  ; Show RGB color extracted below in hex format.
  ChosenColor := BGRtoRGB(ExtractInteger(StructForChooseColor, 12))
  StringTrimLeft, ChosenColor, ChosenColor, 2
  StringLen, RGBLen, ChosenColor
  If RGBLen = 2
    ChosenColor = #0000%ChosenColor%
  If RGBLen = 4
    ChosenColor = #00%ChosenColor% 
  If RGBLen = 6
    ChosenColor = #%ChosenColor%
    
  SetFormat, Integer, D
  
  Gui, 2:-Disabled
  WinSet, AlwaysOnTop, Toggle, %lang_gui2_TtlGui2%
  GoSub, 2GuiClose
  Gui, 1:Default
  
  ; Check if text is highlighted
  If ComposeMode = 0
    Send, ^c

  If CtrlKeyDown != D
    {      
      ; No Text was highlighted    
      If Clipboard is Space
        {    
          Control, EditPaste, [color=%ChosenColor%][/color], Edit1, %ScriptName%
          Send, {Left 8}
        }
    
      ; Some text was highlighted
      Else
        {
          If ComposeMode
            {
              EndTagLen := EndTagSum + 8
              Control, EditPaste, [color=%ChosenColor%]%Clipboard%[/color], Edit1, %ScriptName%
              GuiControl, 1:Focus, EdtComment 
              Send, {Left %EndTagLen%}
              Clipboard =
            }
          Else
            {
              Control, EditPaste, [color=%ChosenColor%]%Clipboard%[/color], Edit1, %ScriptName%
              Clipboard =
            }
        }

      ; Reset variables for ComposeMode      
      SB_SetIcon(A_ScriptDir "\phpbb\ico\clean.ico", 1, 2)
      ComposeMode := false

      ; Clear ComposeList and Statusbar Part3
      ComposeList =
      SB_SetText(ComposeList,3)
      
      EndTagSum = 0      
    }
  Else
    {
      EndTagSum := EndTagSum + 8
      
      ; No Text was highlighted    
      If Clipboard is Space
        Clipboard = [color=%ChosenColor%][/color]
      Else
        Clipboard = [color=%ChosenColor%]%Clipboard%[/color]

      ; Set variables for ComposeMode
      SB_SetIcon(A_ScriptDir "\phpbb\ico\compose.ico", 1, 2)
      ComposeMode := true
      
      ; Add StartTag to ComposeList      
      ComposeList = %ComposeList% color -
      SB_SetText(ComposeList,3)              
    }
Return

2GuiClose:
  Gui, 1:-Disabled
  Gui, 2:Destroy
  GuiControl, 1:Focus, EdtComment
Return
;##############################################################################
;####### End of ColorGui ######################################################
;##############################################################################


;##############################################################################
;####### FontSize Gui #########################################################
;##############################################################################
SelectFontSize:
  StringSplit, ArrayOfFontSizesLabel, lang_gui3_DDLSize, |

  Gui, 1:+Disabled
  Gui, 3:+owner +ToolWindow +AlwaysOnTop
  Gui, 3:Margin, 5, 5
  
  Gui, 3:Add, Button, gBtnTiny h20 w100, %ArrayOfFontSizesLabel1%
  Gui, 3:Add, Button, gBtnSmall h20 w100, %ArrayOfFontSizesLabel2%
  Gui, 3:Add, Button, gBtnNormal h20 w100, %ArrayOfFontSizesLabel3%
  Gui, 3:Add, Button, gBtnLarge h20 w100, %ArrayOfFontSizesLabel4%
  Gui, 3:Add, Button, gBtnHuge h20 w100, %ArrayOfFontSizesLabel5%
  Gui, 3:Add, GroupBox, xm yp+23 w100 h8
  Gui, 3:Add, Edit, vEdtUserFontSize w35 h20 Number
  Gui, 3:Add, UpDown, Range1-29, 14
  Gui, 3:Add, Button, gBtnSubmitUserDefinedSize xp+42 yp h20 w58 Default, %lang_gui3_BtnSubmitUserDefinedSize%
Return

BtnTiny:
  ; Chosen FontSize
  Size := ArrayOfFontSizes1
  GoSub, SelectedSize
Return

BtnSmall:
  ; Chosen FontSize
  Size := ArrayOfFontSizes2
  GoSub, SelectedSize
Return

BtnNormal:
  ; Chosen FontSize
  Size := ArrayOfFontSizes3
  GoSub, SelectedSize
Return

BtnLarge:
  ; Chosen FontSize
  Size := ArrayOfFontSizes4
  GoSub, SelectedSize
Return

BtnHuge:
  ; Chosen FontSize
  Size := ArrayOfFontSizes5
  GoSub, SelectedSize
Return

BtnSubmitUserDefinedSize:
  Gui, 3:Submit, NoHide
  Size = %EdtUserFontSize%
  GoSub, SelectedSize
Return

SelectedSize:
  Gui, 3:Submit, NoHide
  Gui, 1:-Disabled
  
  If ComposeMode = 0
    {
      ; Check if text is highlighted
      GuiControl, 1:Focus, EdtComment
      Send, ^c
    }
  
  Gui, 1:+Disabled
  GuiControl, 3:Focus, SelectedSize

  Gui, 1:-Disabled
  Gui, 3:Destroy
    
  If CtrlKeyDown != D
    {
      ; No Text was highlighted    
      If Clipboard is Space
        {
          Control, EditPaste, [size=%Size%][/size], Edit1, %ScriptName%
          Send, {Left 7}
        }
    
      ; Some text was highlighted
      Else
        {
          If ComposeMode
            {
              Gui, 1:Default          
              EndTagLen := EndTagSum + 7
              GuiControl, 1:Focus, EdtComment
              Control, EditPaste, [size=%Size%]%Clipboard%[/size], Edit1, %ScriptName%
              Send, {Left %EndTagLen%}
              Clipboard =              

            }
          Else
            {
              Control, EditPaste, [size=%Size%]%Clipboard%[/size], Edit1, %ScriptName%
              Clipboard =
            }
        }

      ; Reset variables for ComposeMode      
      SB_SetIcon(A_ScriptDir "\phpbb\ico\clean.ico", 1, 2)
      ComposeMode := false
      
      ; Clear ComposeList and Statusbar Part3
      ComposeList =
      SB_SetText(ComposeList,3)
            
      EndTagSum = 0      
    }
  Else
    {
      EndTagSum := EndTagSum + 7
      Gui, 1:Default

      ; No Text was highlighted    
      If Clipboard is Space
        Clipboard = [size=%Size%][/size]
      Else
        Clipboard = [size=%Size%]%Clipboard%[/size]

      ; Set variables for ComposeMode
      SB_SetIcon(A_ScriptDir "\phpbb\ico\compose.ico", 1, 2)
      ComposeMode := true
      
      ; Add StartTag to ComposeList      
      ComposeList = %ComposeList% size -
      SB_SetText(ComposeList,3)                         
    }
Return

3GuiClose:
  Gui, 1:-Disabled
  Gui, 3:Destroy
  GuiControl, 1:Focus, EdtComment
Return
;##############################################################################
;####### End of  FontSize Gui #################################################
;##############################################################################


;##############################################################################
;####### Smiley Gui ###########################################################
;##############################################################################
SelectSmiley:
  Gui, 1:+Disabled
  Gui, 4:+owner +ToolWindow +AlwaysOnTop
  Gui, 4:Margin, 5, 5
  
  Gui, 4:Add, Text, Section, %lang_gui4_TxtAddSmiley%
  Gui, 4:Add, Text, xs+92 ys w52 h18 ReadOnly Right
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley1  xs ys+20 h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley2  xp+25 yp h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley3  xp+25 yp h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley4  xp+25 yp h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley5  xp+25 yp h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley6  xp+25 yp h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley7  xs ys+45 h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley8  xp+25 yp h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley9  xp+25 yp h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley10 xp+25 yp h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley11 xp+25 yp h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley12 xp+25 yp h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley13 xs ys+70 h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley14 xp+25 yp h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley15 xp+25 yp h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley16 xp+25 yp h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley17 xp+25 yp h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley18 xp+25 yp h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley19 xs ys+95 h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley20 xp+25 yp h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley21 xp+25 yp h22 w22 +%BS_ICON%
  Gui, 4:Add, Button, gBtnAddSmiley vBtnAddSmiley22 xp+25 yp h22 w22 +%BS_ICON%
  
  ; Create Gui, but hide it for now - due to following icon assignment
  Gui, 4:Show, +Hide, %lang_gui4_TtlGui4%
  
  ; Wait for Gui Creation
  WinWait, %lang_gui4_TtlGui4%
    
  ; Find the Window Handle
  WinHandle := WinExist(lang_gui4_TtlGui4)
  
  ; Assign icons to buttons
  SetButtonGraphic(WinHandle, "1",  A_ScriptDir "\phpbb\ico\smileys\icon_biggrin.ico"  , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "2",  A_ScriptDir "\phpbb\ico\smileys\icon_smile.ico"    , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "3",  A_ScriptDir "\phpbb\ico\smileys\icon_sad.ico"      , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "4",  A_ScriptDir "\phpbb\ico\smileys\icon_surprised.ico", 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "5",  A_ScriptDir "\phpbb\ico\smileys\icon_eek.ico"      , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "6",  A_ScriptDir "\phpbb\ico\smileys\icon_confused.ico" , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "7",  A_ScriptDir "\phpbb\ico\smileys\icon_cool.ico"     , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "8",  A_ScriptDir "\phpbb\ico\smileys\icon_lol.ico"      , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "9",  A_ScriptDir "\phpbb\ico\smileys\icon_mad.ico"      , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "10", A_ScriptDir "\phpbb\ico\smileys\icon_razz.ico"     , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "11", A_ScriptDir "\phpbb\ico\smileys\icon_redface.ico"  , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "12", A_ScriptDir "\phpbb\ico\smileys\icon_cry.ico"      , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "13", A_ScriptDir "\phpbb\ico\smileys\icon_evil.ico"     , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "14", A_ScriptDir "\phpbb\ico\smileys\icon_twisted.ico"  , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "15", A_ScriptDir "\phpbb\ico\smileys\icon_rolleyes.ico" , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "16", A_ScriptDir "\phpbb\ico\smileys\icon_wink.ico"     , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "17", A_ScriptDir "\phpbb\ico\smileys\icon_exclaim.ico"  , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "18", A_ScriptDir "\phpbb\ico\smileys\icon_question.ico" , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "19", A_ScriptDir "\phpbb\ico\smileys\icon_idea.ico"     , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "20", A_ScriptDir "\phpbb\ico\smileys\icon_arrow.ico"    , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "21", A_ScriptDir "\phpbb\ico\smileys\icon_neutral.ico"  , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "22", A_ScriptDir "\phpbb\ico\smileys\icon_mrgreen.ico"  , 16, 16, IMAGE_ICON)
  
  Gui, 4:Show, AutoSize, %lang_gui4_TtlGui4%

  ; Retrieve scripts PID
  Process, Exist
  pid_this := ErrorLevel
  
  ; Retrieve unique ID number (HWND/handle)
  WinGet, hw_gui, ID, ahk_class AutoHotkeyGUI ahk_pid %pid_this%
  
  ; Call "ShowSmileTooltip" when script receives WM_MOUSEMOVE message
  WM_MOUSEMOVE = 0x200
  OnMessage(WM_MOUSEMOVE, "HandleMessage")
Return

BtnAddSmiley:
  StringTrimLeft, SmileyNumber, A_GuiControl, 12
  Smiley := ArrayOfSmileys%SmileyNumber%
  GoSub, 4GuiClose
  GuiControl, 1:Focus, EdtComment
  Control, EditPaste, %Smiley%, Edit1, %ScriptName%
Return

4GuiClose:
  Gui, 1:-Disabled
  Gui, 4:Destroy
Return
;##############################################################################
;####### End of Smiley Gui ####################################################
;##############################################################################


;##############################################################################
;####### Help Gui #############################################################
;##############################################################################
CreateInfoGui:
  Gui, 5:+ToolWindow +AlwaysOnTop
  Gui, 5:Margin, 5, 5
  
  Gui, 5:Add, Picture, w48 h48 Section, %A_ScriptDir%\phpbb\ico\logo.ico
  Gui, 5:Font, S12 W600 
  Gui, 5:Add, Text,xp+60 yp+15, %ScriptName%
  Gui, 5:Font
  Gui, 5:Add, Edit, xs ys+55 r15 w460 ReadOnly  
  Gui, 5:Show, AutoSize, %InfoTitle%
  
  GuiControl, 5:, Edit1, %DisplayText%
Return

DisplayShortcuts:
  ; Put content of shortcuts.txt into a variable
  FileRead, DisplayText, %A_ScriptDir%\text\%LangPrfx%_shortcuts.txt
  InfoTitle = %lang_gui5_TtlShortcuts%
  GoSub, CreateInfoGui
Return

DisplayTip:
  ; Put content of tip.txt into a variable
  FileRead, DisplayText, %A_ScriptDir%\text\%LangPrfx%_tip.txt
  InfoTitle = %lang_gui5_TtlClipboard%
  GoSub, CreateInfoGui
Return

DisplayCustomize:
  ; Put content of customize.txt into a variable
  FileRead, DisplayText, %A_ScriptDir%\text\%LangPrfx%_customize.txt
  InfoTitle = %lang_gui5_TtlCustomize%
  GoSub, CreateInfoGui
Return

DisplayBBCode:
  ; Put content of bbcode.txt into a variable
  FileRead, DisplayText, %A_ScriptDir%\text\%LangPrfx%_bbcode.txt
  InfoTitle = %lang_gui5_TtlBBCode%
  GoSub, CreateInfoGui
Return

5GuiClose:
  Gui, 5:Destroy
Return
;##############################################################################
;####### End of Help GUI ######################################################
;##############################################################################


;##############################################################################
;####### Preferences GUI ######################################################
;##############################################################################
CreatePreferencesGUI:
  ; Save content of EdtComment
  Gui, 1:Submit, NoHide
  Comment = %EdtComment%
  
  ; Build pipe-delimited list for Language drop-down list
  Loop, %A_ScriptDir%\lang\*.ini
    {
      IniRead, LangName, %A_LoopFileFullPath%, Data, LangName
      DDLLangList = %DDLLangList%%LangName%|
    }
  ; Remove last pipe char
  StringTrimRight, DDLLangList, DDLLangList, 1

  ; Create Gui
  Gui, 1:+Disabled
  Gui, 6:+owner +ToolWindow +AlwaysOnTop
  Gui, 6:Margin, 5, 5
  
  Gui, 6:Add, Picture, w48 h48 Section, %A_ScriptDir%\phpbb\ico\logo.ico
  Gui, 6:Font, S12 W600 
  Gui, 6:Add, Text, xp+55 yp+15, %ScriptName%
  Gui, 6:Font
  
  Gui, 6:Add, Groupbox, xp-55 yp+40 w331 h128 Section, %lang_gui6_GrpGeneral%  
  Gui, 6:Add, Text, xs+13 ys+22, %lang_gui6_TxtFontSize%
  Gui, 6:Add, DropDownList, vDDLFontSize xp+80 yp-3 w39 r5, 8|10|12|14|16
  Gui, 6:Add, Text, xs+13 ys+48, %lang_gui6_TxtLanguage%
  Gui, 6:Add, DropDownList, vDDLLang xp+80 yp-3 r5 w100, %DDLLangList% 
  Gui, 6:Add, Text, xs+13 ys+74, %lang_gui6_TxtBrowser%
  Gui, 6:Add, Edit, vBrowserPath xp+80 yp-3 w200 r1, %BrowserExe%
  Gui, 6:Add, Button, gChooseBrowser xp+205 yp+2 w19 h17, ...
  Gui, 6:Add, Text, xs+13 ys+100, %lang_gui6_TxtHistory%
  Gui, 6:Add, Button, gClearHistory xp+80 yp-3 w80 h21, %lang_gui6_BtnClearHistory%
  
  Gui, 6:Add, Groupbox, xm ys+132 w331 h48 Section, %lang_gui6_GrpCstmBBCodeTags%
  Gui, 6:Add, Checkbox, vChkCstmBtns xs+13 ys+22 Checked%CstmBarEnabled%, %lang_gui6_ChkCstmBtns%
  
  Gui, 6:Add, Button, gBtnPrefApply vBtnPrefApply xs+271 ys+53 w60, %lang_gui6_BtnOK%
  
  ; Preselect language DDL from BBCodeWriter.ini
  IniRead, LangName, %A_ScriptDir%\lang\%Lang%, Data, LangName
  GuiControl, 6:ChooseString, DDLLang, %LangName%
  
  ; Preselect font size DDL from 'EdtFontSize'
  GuiControl, 6:ChooseString, DDLFontSize, %EdtFontSize%
  
  Gui, 6:Show,, %lang_gui6_TtlGui6%
  
  ; Focus on 'OK' button
  GuiControl, 6:Focus, BtnPrefApply
Return

ChooseBrowser:
  FileSelectFile, PrefBrowser, Options, %A_ProgramFiles%, %lang_gui6_TtlChooseBrowser% , *.exe
  
  ; User didn't press CANCEL
  If PrefBrowser is not space
    GuiControl, 6:, BrowserPath, %PrefBrowser%
Return

ClearHistory:
  RecentFilesList =
  IniWrite, %RecentFilesList%, BBCodeWriter.ini, Recent, RecentFiles
  GoSub, RebuildFileMenu
Return

BtnPrefApply:
  RestartRequired := false
  Gui, 6:Submit, NoHide
  
  ; Check if font size has been changed
  If DDLFontSize != %EdtFontSize%
    {
      EdtFontSize = %DDLFontSize%
      IniWrite, %DDLFontSize%, BBCodeWriter.ini, Preferences, EdtFontSize
      
      ; Change font within main GUI
      Gui, 1:-Disabled
      Gui, 1:Font, s%EdtFontSize%
      GuiControl, 1:Font, EdtComment
      Gui, 1:Font
      Gui, 1:+Disabled
    }

  ; Check path to browser .exe file
  If BrowserPath is not space
    {
      IniWrite, %BrowserPath%, BBCodeWriter.ini, Browser, PrefBrowser
      IniRead, BrowserExe, BBCodeWriter.ini, Browser, PrefBrowser, iexplore.exe
    }
  Else
    {
      Gui, 6:+OwnDialogs
      MsgBox,, %lang_gui6_TtlMsgBrowserExe%, %lang_gui6_MsgBrowserExe%
      Return
    }
  
  ; Check if Language has been changed 
  If DDLLang != %LangName%
    {
      Loop, %A_ScriptDir%\lang\*.ini
        {
          IniRead, LangName, %A_ScriptDir%\lang\%A_LoopFileName%, Data, LangName
          If LangName = %DDLLang%
            {
              IniWrite, %A_LoopFileName%, BBCodeWriter.ini, Language, Lang
              RestartRequired := true
              Break
            }
          Else
            Continue
        }
    }

  If ChkCstmBtns != %CstmBarEnabled%
    {
      IniWrite, %ChkCstmBtns%, BBCodeWriter.ini, CstmToolBar, CstmBarEnabled
      RestartRequired := true

      ; Save Gui size and position
      WinGetPos, PosX, PosY, GuiW, GuiH, %ScriptName%
      GuiW := GuiW - 8   ; Subtract Gui Margin and border width 
      GuiH := GuiH - 46  ; Subtract title bar and menu height

      ; Save controls sizes and positions          
      GuiControlGet, Edt, 1:Pos, EdtComment
      GuiControlGet, Grp, 1:Pos, GrpMenuBorder
      GuiControlGet, Chk, 1:Pos, ChkSig                                                                  
      GuiControlGet, DDL, 1:Pos, DDLSig
      GuiControlGet, BSg, 1:Pos, BtnEditSig
      GuiControlGet, BG3, 1:Pos, BtnReset

      ; Right justify BtnSend, BtnPreview, BtnCustomize and BtnReset with EdtComment
      BG1X := EdtX + EdtW - 200 ; edit ctrl right border - 3x Btn width - 15px gap - 5px gap
      BG2X := EdtX + EdtW - 135 ; edit ctrl right border - 2x Btn width - 15px gap
      BG3X := EdtX + EdtW - 60  ; edit ctrl right border - 1x Btn width
      BG4X := EdtX + EdtW - 25  ; edit ctrl right border - 1x Btn width      
      
      If ChkCstmBtns
        {
          EdtY += 34
          ChkY += 34
          DDLY += 34
          BSgY += 34
          BG3Y += 34
          GuiH += 34
        }
      Else
        {
          EdtY -= 34
          ChkY -= 34
          DDLY -= 34
          BSgY -= 34
          BG3Y -= 34
          GuiH -= 34        
        }
    }
  
  GoSub, NeedRestart
Return

NeedRestart:
  If RestartRequired
    {
      ; Save WinTitle
      WinGetTitle, Gui1WinTitle, %ScriptName%
      StringTrimLeft, CheckGui1Title, Gui1WinTitle, 23
      ChangeGui1Title := true
      If CheckGui1Title = %lang_gui1_TtlGui1%
        ChangeGui1Title := false
      
      GoSub, RebuildGUI1 ; -> "general subroutines"
      
      ; Rename WinTitle  
      If ChangeGui1Title
        WinSetTitle, %ScriptName%,, %Gui1WinTitle%
    }
  Else
    GoSub, 6GuiClose
Return
  
6GuiClose:
  ; Reset variable to avoid double assigning when opening PreferencesGUI again
  DDLLangList =
   
  Gui, 1:-Disabled
  Gui, 6:Destroy
Return
;##############################################################################
;####### End of Preferences GUI ###############################################
;##############################################################################


;##############################################################################
;####### About GUI ############################################################
;##############################################################################
CreateAboutGUI:
  Gui, 1:+Disabled
  Gui, 7:+owner +ToolWindow +AlwaysOnTop
  Gui, 7:Margin, 5, 5
  
  Gui, 7:Add, Picture, gShowCredits w48 h48 Section, %A_ScriptDir%\phpbb\ico\logo.ico
  Gui, 7:Font, S12 W600 
  Gui, 7:Add, Text,xp+60 yp+15, %ScriptName%
  Gui, 7:Font
  Gui, 7:Add, Text, xp ys+35, by AGermanUser a.k.a AGU
  Gui, 7:Add, Text, xs+20 yp+35, %lang_gui7_TxtThread%
  Gui, 7:Add, Text, xp yp+15 cBlue gForumLink vURL_ForumLink, %lang_gui7_TxtForumLink%
  Gui, 7:Add, Text, xp yp+25, %lang_gui7_TxtHomepage%
  Gui, 7:Add, Text, xp yp+15 cBlue gHomepage vURL_Homepage, www.autohotkey.net/~AGermanUser
  Gui, 7:Font, norm 
  Gui, 7:Add, Text, xm yp+40, %lang_gui7_TxtGPL% 
  Gui, 7:Show, AutoSize, %lang_gui7_TtlGui7%
  
  ; Retrieve scripts PID
  Process, Exist
  pid_this := ErrorLevel
  
  ; Retrieve unique ID number (HWND/handle)
  WinGet, hw_gui, ID, ahk_class AutoHotkeyGUI ahk_pid %pid_this%
  
  ; Call "HandleMessage" when script receives WM_SETCURSOR message
  WM_SETCURSOR = 0x20
  OnMessage(WM_SETCURSOR, "HandleMessage")
  
  ; Call "HandleMessage" when script receives WM_MOUSEMOVE message
  WM_MOUSEMOVE = 0x200
  OnMessage(WM_MOUSEMOVE, "HandleMessage")
Return

ForumLink:
  If LangPrfx = en
    Run, http://www.autohotkey.com/forum/topic6161.html
  If LangPrfx = de
    Run, http://de.autohotkey.com/forum/topic30.html
Return

Homepage:
  Run, http://www.autohotkey.net/~AGermanUser/BBCodeWriter/homepage/index.html
Return

ShowCredits:
  GoSub, CreateCreditsGUI
Return

7GuiClose:
  Gui, 1:-Disabled  
  Gui, 7:Destroy
Return
;##############################################################################
;####### End of About GUI #####################################################
;##############################################################################


;##############################################################################
;####### Credits GUI ##########################################################
;##############################################################################
CreateCreditsGUI:
  WinH = 99               ; Height of GUI
  YPos1  := WinH   + 5    ; Bottom of GUI Window
  YPos2  := YPos1  + 25   ; 25 pixels gap
  YPos3  := YPos2  + 25
  YPos4  := YPos3  + 25
  YPos5  := YPos4  + 25
  YPos6  := YPos5  + 25
  YPos7  := YPos6  + 25
  YPos8  := YPos7  + 25
  YPos9  := YPos8  + 25
  YPos10 := YPos9  + 25
  YPos11 := YPos10 + 25
  YPos12 := YPos11 + 30
  YPos13 := YPos12 + 60
  YPos14 := YPos13 + 40
  YPos15 := YPos14 + 35

  Gui, 7:+Disabled
  Gui, 8:+ToolWindow +AlwaysOnTop
  Gui, 8:Margin, 0, 0
  
  Gui, 8:Add, Picture, vIcon1  x12 y%YPos1% h16 w16, %A_ScriptDir%\phpbb\ico\smileys\icon_mrgreen.ico
  Gui, 8:Add, Text,    vText1  x30, toralf
  Gui, 8:Add, Picture, vIcon2  x12 y%YPos2% h16 w16, %A_ScriptDir%\phpbb\ico\smileys\icon_razz.ico
  Gui, 8:Add, Text,    vText2  x30, shimanov
  Gui, 8:Add, Picture, vIcon3  x12 y%YPos3% h16 w16, %A_ScriptDir%\phpbb\ico\smileys\icon_cool.ico
  Gui, 8:Add, Text,    vText3  x30, roundfile
  Gui, 8:Add, Picture, vIcon4  x12 y%YPos4% h16 w16, %A_ScriptDir%\phpbb\ico\smileys\icon_biggrin.ico
  Gui, 8:Add, Text,    vText4  x30, Titan
  Gui, 8:Add, Picture, vIcon5  x12 y%YPos5% h16 w16, %A_ScriptDir%\phpbb\ico\smileys\icon_wink.ico
  Gui, 8:Add, Text,    vText5  x30, PhiLho
  Gui, 8:Add, Picture, vIcon6  x12 y%YPos6% h16 w16, %A_ScriptDir%\phpbb\ico\smileys\icon_twisted.ico
  Gui, 8:Add, Text,    vText6  x30, evl
  Gui, 8:Add, Picture, vIcon7  x12 y%YPos7% h16 w16, %A_ScriptDir%\phpbb\ico\smileys\icon_smile.ico
  Gui, 8:Add, Text,    vText7  x30, d-man 
  Gui, 8:Add, Picture, vIcon8  x12 y%YPos8% h16 w16, %A_ScriptDir%\phpbb\ico\smileys\icon_mrgreen.ico
  Gui, 8:Add, Text,    vText8  x30, Laszlo
  Gui, 8:Add, Picture, vIcon9  x12 y%YPos9% h16 w16, %A_ScriptDir%\phpbb\ico\smileys\icon_biggrin.ico
  Gui, 8:Add, Text,    vText9  x30, Micha
  Gui, 8:Add, Picture, vIcon10  x12 y%YPos10% h16 w16, %A_ScriptDir%\phpbb\ico\smileys\icon_cool.ico
  Gui, 8:Add, Text,    vText10  x30, Mart
  Gui, 8:Add, Picture, vIcon11  x78 y%YPos11% h32 w32, %A_ScriptDir%\phpbb\ico\cents.ico
  Gui, 8:Add, Text,    vText11  x48 y%YPos12%, BoBo's two cents
  Gui, 8:Add, Text,    vText12  x54 y%YPos13%, and of course ...
  Gui, 8:Add, Picture, vIcon12  x78 y%YPos14% h32 w32, %A_ScriptDir%\phpbb\ico\ahk.ico
  Gui, 8:Add, Text,    vText13  x60 y%YPos15%, Chris Mallet for`n  AutoHotkey
  
  Gui, 8:Show, w189 h%WinH%, %lang_gui8_TtlGui8%
  
  Loop
    { 
      YPos1 -= 2
      GuiControl, 8:Move, Icon1, y%YPos1%
      GuiControl, 8:Move, Text1, y%YPos1%
      YPos2 -= 2
      GuiControl, 8:Move, Icon2, y%YPos2%
      GuiControl, 8:Move, Text2, y%YPos2%
      YPos3 -= 2
      GuiControl, 8:Move, Icon3, y%YPos3%
      GuiControl, 8:Move, Text3, y%YPos3%
      YPos4 -= 2
      GuiControl, 8:Move, Icon4, y%YPos4%
      GuiControl, 8:Move, Text4, y%YPos4%
      YPos5 -= 2
      GuiControl, 8:Move, Icon5, y%YPos5%
      GuiControl, 8:Move, Text5, y%YPos5%
      YPos6 -= 2
      GuiControl, 8:Move, Icon6, y%YPos6%
      GuiControl, 8:Move, Text6, y%YPos6%
      YPos7 -= 2
      GuiControl, 8:Move, Icon7, y%YPos7%
      GuiControl, 8:Move, Text7, y%YPos7%              
      YPos8 -= 2
      GuiControl, 8:Move, Icon8, y%YPos8%
      GuiControl, 8:Move, Text8, y%YPos8%
      YPos9 -= 2
      GuiControl, 8:Move, Icon9, y%YPos9%
      GuiControl, 8:Move, Text9, y%YPos9%
      YPos10 -= 2
      GuiControl, 8:Move, Icon10, y%YPos10%
      GuiControl, 8:Move, Text10, y%YPos10%
      YPos11 -= 2
      GuiControl, 8:Move, Icon11, y%YPos11%
      YPos12 -= 2
      GuiControl, 8:Move, Text11, y%YPos12%
      YPos13 -= 2
      GuiControl, 8:Move, Text12, y%YPos13%
      YPos14 -= 2
      GuiControl, 8:Move, Icon12, y%YPos14%
      YPos15 -= 2
      GuiControl, 8:Move, Text13, y%YPos15%       
      
      GuiControlGet, Text13, 8:Pos
      If (Text13Y <= 56)
        Break
      Sleep 100
    }
  Sleep 1000

8GuiEscape:
8GuiClose:
  Gui, 7:-Disabled
  Gui, 8:Destroy
Return
;##############################################################################
;####### End of Credits GUI ###################################################
;##############################################################################

;##############################################################################
;####### Custom Buttons GUI ###################################################
;##############################################################################
; *******************************************************************************************************************************
CreateCstmBtnsGUI:
  Gui, 1:+Disabled
  Gui, 9:+owner +ToolWindow +AlwaysOnTop
  Gui, 9:Margin, 5, 5
  
  Gui, 9:Add, Picture, w48 h48 Section, %A_ScriptDir%\phpbb\ico\logo.ico
  Gui, 9:Font, S12 W600 
  Gui, 9:Add, Text, xp+55 yp+15, %ScriptName%
  Gui, 9:Font
; ______________________________________________________________________________________________________________
  Gui, 9:Add, Groupbox, xp-55 yp+40 w500 h550 Section, %lang_gui9_GrpCstmBBCodeTags%   ; h300 changed by °digit°
  
  Gui, 9:Add, Text, xs+48 ys+25, %lang_gui9_TxtStartTag%
  Gui, 9:Add, Text, xp+79 yp, %lang_gui9_TxtEndTag%
  Gui, 9:Add, Text, xp+99 yp, %lang_gui9_TxtToolTipTag%
  Gui, 9:Add, Text, xp+121 yp, %lang_gui9_TxtIcon%
  Gui, 9:Add, Text, xp+106 yp, %lang_gui9_TxtEnable%
  
  Gui, 9:Add, GroupBox, xs+10 ys+40 w20 h26
  Gui, 9:Add, Picture, vPicCstm1Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm1Icon%
  Gui, 9:Add, Edit, vEdtCstm1StartTag xp+25 yp-3 w70 r1, %BBStartTag1%
  Gui, 9:Add, Edit, vEdtCstm1EndTag xp+75 yp w70 r1, %BBEndTag1%
  Gui, 9:Add, Edit, vEdtCstm1ToolTip xp+75 yp w112 r1, %BBToolTip1%
  Gui, 9:Add, Edit, vEdtCstm1Icon xp+117 yp w112 r1 ReadOnly, %Cstm1Icon%
  Gui, 9:Add, Button, vBtnCstm1DefIcon gBtnCstm1DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm1Enable xp+44 yp+2 Checked%Cstm1Enabled%

  Gui, 9:Add, GroupBox, xs+10 ys+65 w20 h26
  Gui, 9:Add, Picture, vPicCstm2Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm2Icon%
  Gui, 9:Add, Edit, vEdtCstm2StartTag xp+25 yp-3 w70 r1, %BBStartTag2%
  Gui, 9:Add, Edit, vEdtCstm2EndTag xp+75 yp w70 r1, %BBEndTag2%
  Gui, 9:Add, Edit, vEdtCstm2ToolTip xp+75 yp w112 r1, %BBToolTip2%
  Gui, 9:Add, Edit, vEdtCstm2Icon xp+117 yp w112 r1 ReadOnly, %Cstm2Icon%
  Gui, 9:Add, Button, vBtnCstm2DefIcon gBtnCstm2DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm2Enable xp+44 yp+2 Checked%Cstm2Enabled% 

  Gui, 9:Add, GroupBox, xs+10 ys+90 w20 h26
  Gui, 9:Add, Picture, vPicCstm3Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm3Icon%
  Gui, 9:Add, Edit, vEdtCstm3StartTag xp+25 yp-3 w70 r1, %BBStartTag3%
  Gui, 9:Add, Edit, vEdtCstm3EndTag xp+75 yp w70 r1, %BBEndTag3%
  Gui, 9:Add, Edit, vEdtCstm3ToolTip xp+75 yp w112 r1, %BBToolTip3%
  Gui, 9:Add, Edit, vEdtCstm3Icon xp+117 yp w112 r1 ReadOnly, %Cstm3Icon%
  Gui, 9:Add, Button, vBtnCstm3DefIcon gBtnCstm3DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm3Enable xp+44 yp+2 Checked%Cstm3Enabled%

  Gui, 9:Add, GroupBox, xs+10 ys+115 w20 h26
  Gui, 9:Add, Picture, vPicCstm4Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm4Icon%
  Gui, 9:Add, Edit, vEdtCstm4StartTag xp+25 yp-3 w70 r1, %BBStartTag4%
  Gui, 9:Add, Edit, vEdtCstm4EndTag xp+75 yp w70 r1, %BBEndTag4%
  Gui, 9:Add, Edit, vEdtCstm4ToolTip xp+75 yp w112 r1, %BBToolTip4%
  Gui, 9:Add, Edit, vEdtCstm4Icon xp+117 yp w112 r1 ReadOnly, %Cstm4Icon%
  Gui, 9:Add, Button, vBtnCstm4DefIcon gBtnCstm4DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm4Enable xp+44 yp+2 Checked%Cstm4Enabled%

  Gui, 9:Add, GroupBox, xs+10 ys+140 w20 h26
  Gui, 9:Add, Picture, vPicCstm5Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm5Icon%
  Gui, 9:Add, Edit, vEdtCstm5StartTag xp+25 yp-3 w70 r1, %BBStartTag5%
  Gui, 9:Add, Edit, vEdtCstm5EndTag xp+75 yp w70 r1, %BBEndTag5%
  Gui, 9:Add, Edit, vEdtCstm5ToolTip xp+75 yp w112 r1, %BBToolTip5%
  Gui, 9:Add, Edit, vEdtCstm5Icon xp+117 yp w112 r1 ReadOnly, %Cstm5Icon%
  Gui, 9:Add, Button, vBtnCstm5DefIcon gBtnCstm5DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm5Enable xp+44 yp+2 Checked%Cstm5Enabled%

  Gui, 9:Add, GroupBox, xs+10 ys+165 w20 h26
  Gui, 9:Add, Picture, vPicCstm6Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm6Icon%
  Gui, 9:Add, Edit, vEdtCstm6StartTag xp+25 yp-3 w70 r1, %BBStartTag6%
  Gui, 9:Add, Edit, vEdtCstm6EndTag xp+75 yp w70 r1, %BBEndTag6%
  Gui, 9:Add, Edit, vEdtCstm6ToolTip xp+75 yp w112 r1, %BBToolTip6%
  Gui, 9:Add, Edit, vEdtCstm6Icon xp+117 yp w112 r1 ReadOnly, %Cstm6Icon%
  Gui, 9:Add, Button, vBtnCstm6DefIcon gBtnCstm6DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm6Enable xp+44 yp+2 Checked%Cstm6Enabled%
  
  Gui, 9:Add, GroupBox, xs+10 ys+190 w20 h26
  Gui, 9:Add, Picture, vPicCstm7Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm7Icon%
  Gui, 9:Add, Edit, vEdtCstm7StartTag xp+25 yp-3 w70 r1, %BBStartTag7%
  Gui, 9:Add, Edit, vEdtCstm7EndTag xp+75 yp w70 r1, %BBEndTag7%
  Gui, 9:Add, Edit, vEdtCstm7ToolTip xp+75 yp w112 r1, %BBToolTip7%
  Gui, 9:Add, Edit, vEdtCstm7Icon xp+117 yp w112 r1 ReadOnly, %Cstm7Icon%
  Gui, 9:Add, Button, vBtnCstm7DefIcon gBtnCstm7DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm7Enable xp+44 yp+2 Checked%Cstm7Enabled%
  
  Gui, 9:Add, GroupBox, xs+10 ys+215 w20 h26
  Gui, 9:Add, Picture, vPicCstm8Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm8Icon%
  Gui, 9:Add, Edit, vEdtCstm8StartTag xp+25 yp-3 w70 r1, %BBStartTag8%
  Gui, 9:Add, Edit, vEdtCstm8EndTag xp+75 yp w70 r1, %BBEndTag8%
  Gui, 9:Add, Edit, vEdtCstm8ToolTip xp+75 yp w112 r1, %BBToolTip8%
  Gui, 9:Add, Edit, vEdtCstm8Icon xp+117 yp w112 r1 ReadOnly, %Cstm8Icon%
  Gui, 9:Add, Button, vBtnCstm8DefIcon gBtnCstm8DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm8Enable xp+44 yp+2 Checked%Cstm8Enabled%
  
  Gui, 9:Add, GroupBox, xs+10 ys+240 w20 h26
  Gui, 9:Add, Picture, vPicCstm9Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm9Icon%
  Gui, 9:Add, Edit, vEdtCstm9StartTag xp+25 yp-3 w70 r1, %BBStartTag9%
  Gui, 9:Add, Edit, vEdtCstm9EndTag xp+75 yp w70 r1, %BBEndTag9%
  Gui, 9:Add, Edit, vEdtCstm9ToolTip xp+75 yp w112 r1, %BBToolTip9%
  Gui, 9:Add, Edit, vEdtCstm9Icon xp+117 yp w112 r1 ReadOnly, %Cstm9Icon%
  Gui, 9:Add, Button, vBtnCstm9DefIcon gBtnCstm9DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm9Enable xp+44 yp+2 Checked%Cstm9Enabled%
  
  Gui, 9:Add, GroupBox, xs+10 ys+265 w20 h26
  Gui, 9:Add, Picture, vPicCstm10Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm10Icon%
  Gui, 9:Add, Edit, vEdtCstm10StartTag xp+25 yp-3 w70 r1, %BBStartTag10%
  Gui, 9:Add, Edit, vEdtCstm10EndTag xp+75 yp w70 r1, %BBEndTag10%
  Gui, 9:Add, Edit, vEdtCstm10ToolTip xp+75 yp w112 r1, %BBToolTip10%
  Gui, 9:Add, Edit, vEdtCstm10Icon xp+117 yp w112 r1 ReadOnly, %Cstm10Icon%
  Gui, 9:Add, Button, vBtnCstm10DefIcon gBtnCstm10DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm10Enable xp+44 yp+2 Checked%Cstm10Enabled%
; ___________________________________________________________________________________________________
;                                                                                inserted by °digit° |
; ~~~ Add NEW Next 10 Custom ??????? ~~~~~~every GroupBox ys+[25] to the one before ~~~~~~~~~~~~~~~~~

  Gui, 9:Add, GroupBox, xs+10 ys+290 w20 h26
  Gui, 9:Add, Picture, vPicCstm11Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm11Icon%
  Gui, 9:Add, Edit, vEdtCstm11StartTag xp+25 yp-3 w70 r1, %BBStartTag11%
  Gui, 9:Add, Edit, vEdtCstm11EndTag xp+75 yp w70 r1, %BBEndTag11%
  Gui, 9:Add, Edit, vEdtCstm11ToolTip xp+75 yp w112 r1, %BBToolTip11%
  Gui, 9:Add, Edit, vEdtCstm11Icon xp+117 yp w112 r1 ReadOnly, %Cstm11Icon%
  Gui, 9:Add, Button, vBtnCstm11DefIcon gBtnCstm11DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm11Enable xp+44 yp+2 Checked%Cstm11Enabled%

  Gui, 9:Add, GroupBox, xs+10 ys+315 w20 h26
  Gui, 9:Add, Picture, vPicCstm12Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm12Icon%
  Gui, 9:Add, Edit, vEdtCstm12StartTag xp+25 yp-3 w70 r1, %BBStartTag12%
  Gui, 9:Add, Edit, vEdtCstm12EndTag xp+75 yp w70 r1, %BBEndTag12%
  Gui, 9:Add, Edit, vEdtCstm12ToolTip xp+75 yp w112 r1, %BBToolTip12%
  Gui, 9:Add, Edit, vEdtCstm12Icon xp+117 yp w112 r1 ReadOnly, %Cstm12Icon%
  Gui, 9:Add, Button, vBtnCstm12DefIcon gBtnCstm12DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm12Enable xp+44 yp+2 Checked%Cstm12Enabled%

  Gui, 9:Add, GroupBox, xs+10 ys+340 w20 h26
  Gui, 9:Add, Picture, vPicCstm13Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm13Icon%
  Gui, 9:Add, Edit, vEdtCstm13StartTag xp+25 yp-3 w70 r1, %BBStartTag13%
  Gui, 9:Add, Edit, vEdtCstm13EndTag xp+75 yp w70 r1, %BBEndTag13%
  Gui, 9:Add, Edit, vEdtCstm13ToolTip xp+75 yp w112 r1, %BBToolTip13%
  Gui, 9:Add, Edit, vEdtCstm13Icon xp+117 yp w112 r1 ReadOnly, %Cstm13Icon%
  Gui, 9:Add, Button, vBtnCstm13DefIcon gBtnCstm13DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm13Enable xp+44 yp+2 Checked%Cstm13Enabled%

  Gui, 9:Add, GroupBox, xs+10 ys+365 w20 h26
  Gui, 9:Add, Picture, vPicCstm14Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm14Icon%
  Gui, 9:Add, Edit, vEdtCstm14StartTag xp+25 yp-3 w70 r1, %BBStartTag14%
  Gui, 9:Add, Edit, vEdtCstm14EndTag xp+75 yp w70 r1, %BBEndTag14%
  Gui, 9:Add, Edit, vEdtCstm14ToolTip xp+75 yp w112 r1, %BBToolTip14%
  Gui, 9:Add, Edit, vEdtCstm14Icon xp+117 yp w112 r1 ReadOnly, %Cstm14Icon%
  Gui, 9:Add, Button, vBtnCstm14DefIcon gBtnCstm14DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm14Enable xp+44 yp+2 Checked%Cstm14Enabled%

  Gui, 9:Add, GroupBox, xs+10 ys+390 w20 h26
  Gui, 9:Add, Picture, vPicCstm15Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm15Icon%
  Gui, 9:Add, Edit, vEdtCstm15StartTag xp+25 yp-3 w70 r1, %BBStartTag15%
  Gui, 9:Add, Edit, vEdtCstm15EndTag xp+75 yp w70 r1, %BBEndTag15%
  Gui, 9:Add, Edit, vEdtCstm15ToolTip xp+75 yp w112 r1, %BBToolTip15%
  Gui, 9:Add, Edit, vEdtCstm15Icon xp+117 yp w112 r1 ReadOnly, %Cstm15Icon%
  Gui, 9:Add, Button, vBtnCstm15DefIcon gBtnCstm15DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm15Enable xp+44 yp+2 Checked%Cstm15Enabled%

  Gui, 9:Add, GroupBox, xs+10 ys+415 w20 h26
  Gui, 9:Add, Picture, vPicCstm16Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm16Icon%
  Gui, 9:Add, Edit, vEdtCstm16StartTag xp+25 yp-3 w70 r1, %BBStartTag16%
  Gui, 9:Add, Edit, vEdtCstm16EndTag xp+75 yp w70 r1, %BBEndTag16%
  Gui, 9:Add, Edit, vEdtCstm16ToolTip xp+75 yp w112 r1, %BBToolTip16%
  Gui, 9:Add, Edit, vEdtCstm16Icon xp+117 yp w112 r1 ReadOnly, %Cstm16Icon%
  Gui, 9:Add, Button, vBtnCstm16DefIcon gBtnCstm16DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm16Enable xp+44 yp+2 Checked%Cstm16Enabled%

  Gui, 9:Add, GroupBox, xs+10 ys+440 w20 h26
  Gui, 9:Add, Picture, vPicCstm17Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm17Icon%
  Gui, 9:Add, Edit, vEdtCstm17StartTag xp+25 yp-3 w70 r1, %BBStartTag17%
  Gui, 9:Add, Edit, vEdtCstm17EndTag xp+75 yp w70 r1, %BBEndTag17%
  Gui, 9:Add, Edit, vEdtCstm17ToolTip xp+75 yp w112 r1, %BBToolTip17%
  Gui, 9:Add, Edit, vEdtCstm17Icon xp+117 yp w112 r1 ReadOnly, %Cstm17Icon%
  Gui, 9:Add, Button, vBtnCstm17DefIcon gBtnCstm17DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm17Enable xp+44 yp+2 Checked%Cstm17Enabled%

  Gui, 9:Add, GroupBox, xs+10 ys+465 w20 h26
  Gui, 9:Add, Picture, vPicCstm18Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm18Icon%
  Gui, 9:Add, Edit, vEdtCstm18StartTag xp+25 yp-3 w70 r1, %BBStartTag18%
  Gui, 9:Add, Edit, vEdtCstm18EndTag xp+75 yp w70 r1, %BBEndTag18%
  Gui, 9:Add, Edit, vEdtCstm18ToolTip xp+75 yp w112 r1, %BBToolTip18%
  Gui, 9:Add, Edit, vEdtCstm18Icon xp+117 yp w112 r1 ReadOnly, %Cstm18Icon%
  Gui, 9:Add, Button, vBtnCstm18DefIcon gBtnCstm18DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm18Enable xp+44 yp+2 Checked%Cstm18Enabled%

  Gui, 9:Add, GroupBox, xs+10 ys+490 w20 h26
  Gui, 9:Add, Picture, vPicCstm19Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm19Icon%
  Gui, 9:Add, Edit, vEdtCstm19StartTag xp+25 yp-3 w70 r1, %BBStartTag19%
  Gui, 9:Add, Edit, vEdtCstm19EndTag xp+75 yp w70 r1, %BBEndTag19%
  Gui, 9:Add, Edit, vEdtCstm19ToolTip xp+75 yp w112 r1, %BBToolTip19%
  Gui, 9:Add, Edit, vEdtCstm19Icon xp+117 yp w112 r1 ReadOnly, %Cstm19Icon%
  Gui, 9:Add, Button, vBtnCstm19DefIcon gBtnCstm19DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm19Enable xp+44 yp+2 Checked%Cstm19Enabled%

  Gui, 9:Add, GroupBox, xs+10 ys+515 w20 h26
  Gui, 9:Add, Picture, vPicCstm20Icon xp+2 yp+8 w16 h16, %A_ScriptDir%\phpbb\ico\%Cstm20Icon%
  Gui, 9:Add, Edit, vEdtCstm20StartTag xp+25 yp-3 w70 r1, %BBStartTag20%
  Gui, 9:Add, Edit, vEdtCstm20EndTag xp+75 yp w70 r1, %BBEndTag20%
  Gui, 9:Add, Edit, vEdtCstm20ToolTip xp+75 yp w112 r1, %BBToolTip20%
  Gui, 9:Add, Edit, vEdtCstm20Icon xp+117 yp w112 r1 ReadOnly, %Cstm20Icon%
  Gui, 9:Add, Button, vBtnCstm20DefIcon gBtnCstm20DefIcon xp+117 yp+2 w19 h17, ...
  Gui, 9:Add, Checkbox, vChkCstm20Enable xp+44 yp+2 Checked%Cstm20Enabled%

; ___________________________________________________________________________________________________|

  Gui, 9:Add, Button, vBtnCstmSave gBtnCstmSave xs+440 ys+556 w60 r1, %lang_gui9_BtnCstmSave%   ; ys+306 changed by °digit°
  Gui, 9:Show,, %lang_gui9_TtlGui9%
Return

9GuiClose: 
  Gui, 1:-Disabled
  Gui, 9:Destroy
Return

BtnCstm1DefIcon:
  CstmBtnIcon = EdtCstm1Icon
  CstmBtnPic = PicCstm1Icon
  GoSub, AssignIcon
Return

BtnCstm2DefIcon:
  CstmBtnIcon = EdtCstm2Icon
  CstmBtnPic = PicCstm2Icon
  GoSub, AssignIcon
Return

BtnCstm3DefIcon:
  CstmBtnIcon = EdtCstm3Icon
  CstmBtnPic = PicCstm3Icon
  GoSub, AssignIcon
Return

BtnCstm4DefIcon:
  CstmBtnIcon = EdtCstm4Icon
  CstmBtnPic = PicCstm4Icon
  GoSub, AssignIcon
Return

BtnCstm5DefIcon:
  CstmBtnIcon = EdtCstm5Icon
  CstmBtnPic = PicCstm5Icon
  GoSub, AssignIcon
Return

BtnCstm6DefIcon:
  CstmBtnIcon = EdtCstm6Icon
  CstmBtnPic = PicCstm6Icon
  GoSub, AssignIcon
Return

BtnCstm7DefIcon:
  CstmBtnIcon = EdtCstm7Icon
  CstmBtnPic = PicCstm7Icon
  GoSub, AssignIcon
Return

BtnCstm8DefIcon:
  CstmBtnIcon = EdtCstm8Icon
  CstmBtnPic = PicCstm8Icon
  GoSub, AssignIcon
Return

BtnCstm9DefIcon:
  CstmBtnIcon = EdtCstm9Icon
  CstmBtnPic = PicCstm9Icon
  GoSub, AssignIcon
Return

BtnCstm10DefIcon:
  CstmBtnIcon = EdtCstm10Icon
  CstmBtnPic = PicCstm10Icon
  GoSub, AssignIcon
Return
; ___________________________________________________________________________________________________
;                                                                                inserted by °digit° |
; ~~~ Add NEW Next 10 Custom ??????? ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
BtnCstm11DefIcon:
  CstmBtnIcon = EdtCstm11Icon
  CstmBtnPic = PicCstm11Icon
  GoSub, AssignIcon
Return

BtnCstm12DefIcon:
  CstmBtnIcon = EdtCstm12Icon
  CstmBtnPic = PicCstm12Icon
  GoSub, AssignIcon
Return

BtnCstm13DefIcon:
  CstmBtnIcon = EdtCstm13Icon
  CstmBtnPic = PicCstm13Icon
  GoSub, AssignIcon
Return

BtnCstm14DefIcon:
  CstmBtnIcon = EdtCstm14Icon
  CstmBtnPic = PicCstm14Icon
  GoSub, AssignIcon
Return

BtnCstm15DefIcon:
  CstmBtnIcon = EdtCstm15Icon
  CstmBtnPic = PicCstm15Icon
  GoSub, AssignIcon
Return

BtnCstm16DefIcon:
  CstmBtnIcon = EdtCstm16Icon
  CstmBtnPic = PicCstm16Icon
  GoSub, AssignIcon
Return

BtnCstm17DefIcon:
  CstmBtnIcon = EdtCstm17Icon
  CstmBtnPic = PicCstm17Icon
  GoSub, AssignIcon
Return

BtnCstm18DefIcon:
  CstmBtnIcon = EdtCstm18Icon
  CstmBtnPic = PicCstm18Icon
  GoSub, AssignIcon
Return

BtnCstm19DefIcon:
  CstmBtnIcon = EdtCstm19Icon
  CstmBtnPic = PicCstm19Icon
  GoSub, AssignIcon
Return

BtnCstm20DefIcon:
  CstmBtnIcon = EdtCstm20Icon
  CstmBtnPic = PicCstm20Icon
  GoSub, AssignIcon
Return

; ___________________________________________________________________________________________________|

AssignIcon:
  Gui, 9:-AlwaysOnTop
  
  FileSelectFile, CstmIconPath,, %A_ScriptDir%\phpbb\ico, %lang_gui9_TtlOpenIcon%, *.ico
  SplitPath, CstmIconPath, CstmIconName, CstmIconDir
  
  If CstmIconPath is not space
    {
      If CstmIconDir = %IconPath%
        {
          GuiControl, 9:, %CstmBtnIcon%, %CstmIconName%
          GuiControl, 9:, %CstmBtnPic%, %CstmIconPath%        
        }
      Else
        MsgBox, 8208, %lang_gui9_TtlMsgAssignIcon%, %lang_gui9_MsgAssignIcon%       
    }
    
  Gui, 9:+AlwaysOnTop
Return

BtnCstmSave:
  Gui, 9:Submit, NoHide
; ___________________________________________________________________________________________________
  Loop, 20                                                              ; Loop, 10 changed by °digit°
    {
      CheckCstmStartTag := EdtCstm%A_Index%StartTag
      CheckCstmEndTag   := EdtCstm%A_Index%EndTag
      CheckCstmTooltip  := EdtCstm%A_Index%ToolTip
      CheckCstmIcon     := EdtCstm%A_Index%Icon
      CheckCstmState    := ChkCstm%A_Index%Enable
      
      CompareBBStartTag := BBStartTag%A_Index%
      CompareBBEndTag   := BBEndTag%A_Index%
      CompareBBToolTip  := BBToolTip%A_Index%
      CompareCstmIcon   := Cstm%A_Index%Icon
      CompareCstmState  := Cstm%A_Index%Enabled

      ; Compare content of associated variables with ini-filled variables 
      If CheckCstmStartTag != %CompareBBStartTag%
        {
          IniWrite, %CheckCstmStartTag%, CustomTags.ini, BtnCustom%A_Index%, BBStartTag%A_Index%
          BBStartTag%A_Index% = %CheckCstmStartTag%
        }
      If CheckCstmEndTag != %CompareBBEndTag%
        {
          IniWrite, %CheckCstmEndTag%, CustomTags.ini, BtnCustom%A_Index%, BBEndTag%A_Index%
          BBEndTag%A_Index% = %CheckCstmEndTag% 
        }
      If CheckCstmTooltip != %CompareBBToolTip%
        {
          IniWrite, %CheckCstmTooltip%, CustomTags.ini, BtnCustom%A_Index%, BBToolTip%A_Index%
          BBToolTip%A_Index% = %CheckCstmTooltip% 
        }
      If CheckCstmIcon != %CompareBBToolTip%
        {
          IniWrite, %CheckCstmIcon%, CustomTags.ini, BtnCustom%A_Index%, Cstm%A_Index%Icon
          Cstm%A_Index%Icon = %CheckCstmIcon% 
        }
      If CheckCstmState != %CompareCstmState%
        {
          IniWrite, %CheckCstmState%, CustomTags.ini, BtnCustom%A_Index%, Cstm%A_Index%Enabled
          Cstm%A_Index%Enabled = %CheckCstmState% 
          
          ; Disable/Enable button depending on state
          GuiControl, 1:Show%CheckCstmState%, BtnCustom%A_Index%
        }
    }

  ; Reassign button icons in case they have been changed
  SetButtonGraphic(WinHandle, "20", A_ScriptDir "\phpbb\ico\" Cstm1Icon  , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "21", A_ScriptDir "\phpbb\ico\" Cstm2Icon  , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "22", A_ScriptDir "\phpbb\ico\" Cstm3Icon  , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "23", A_ScriptDir "\phpbb\ico\" Cstm4Icon  , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "24", A_ScriptDir "\phpbb\ico\" Cstm5Icon  , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "25", A_ScriptDir "\phpbb\ico\" Cstm6Icon  , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "26", A_ScriptDir "\phpbb\ico\" Cstm7Icon  , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "27", A_ScriptDir "\phpbb\ico\" Cstm8Icon  , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "28", A_ScriptDir "\phpbb\ico\" Cstm9Icon  , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "29", A_ScriptDir "\phpbb\ico\" Cstm10Icon , 16, 16, IMAGE_ICON)
; ___________________________________________________________________________________________________
;                                                                                inserted by °digit° |
; ~~~ Add NEW Next 10 Reassign button icons ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  SetButtonGraphic(WinHandle, "30", A_ScriptDir "\phpbb\ico\" Cstm11Icon , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "31", A_ScriptDir "\phpbb\ico\" Cstm12Icon , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "32", A_ScriptDir "\phpbb\ico\" Cstm13Icon , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "33", A_ScriptDir "\phpbb\ico\" Cstm14Icon , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "34", A_ScriptDir "\phpbb\ico\" Cstm15Icon , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "35", A_ScriptDir "\phpbb\ico\" Cstm16Icon , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "36", A_ScriptDir "\phpbb\ico\" Cstm17Icon , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "37", A_ScriptDir "\phpbb\ico\" Cstm18Icon , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "38", A_ScriptDir "\phpbb\ico\" Cstm19Icon , 16, 16, IMAGE_ICON)
  SetButtonGraphic(WinHandle, "39", A_ScriptDir "\phpbb\ico\" Cstm20Icon , 16, 16, IMAGE_ICON)
; ___________________________________________________________________________________________________|
  GoSub, 9GuiClose
Return
;##############################################################################
;####### End of Custom Buttons GUI ############################################
;##############################################################################


;##############################################################################
;####### MainGui Button Code ##################################################
;##############################################################################
; Hotkeys should only work within BBCodeWriter
#IfWinActive, AHK BBCodeWriter ahk_class AutoHotkeyGUI

F1::
BtnBold:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags("[b]", "[/b]")
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment  
      If MoveCaret
        Send, {Left %EndTagLen%}
    }      
  Else
    Clipboard := ComposeBBCodeTags("[b]", "[/b]")
Return

F2::
BtnItalic:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags("[i]", "[/i]")
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment 
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    Clipboard := ComposeBBCodeTags("[i]", "[/i]")
Return

F3::
BtnUnderline:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags("[u]", "[/u]")
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment 
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    Clipboard := ComposeBBCodeTags("[u]", "[/u]")
Return

F4::
BtnQuote:
  PasteBBCode := SetBBCodeTags("[quote]", "[/quote]")
  Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
  GuiControl, 1:Focus, EdtComment 
  If MoveCaret
    Send, {Left %EndTagLen%}
Return

F5::
BtnCode:
  PasteBBCode := SetBBCodeTags("[code]", "[/code]")
  Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
  GuiControl, 1:Focus, EdtComment 
  If MoveCaret
    Send, {Left %EndTagLen%}
Return

F6::
BtnUrl:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags("[url]", "[/url]")
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment 
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    Clipboard := ComposeBBCodeTags("[url]", "[/url]")
Return

BtnUrlDesc:
  Gui +OwnDialogs
  PasteURL =
  URLDescription =
  Inputbox, PasteURL, Enter URL, e.g. http:`/`/www.google.com,,,120,,,,, %Clipboard%
  If Errorlevel = 0
    {
      ; Check if text is highlighted within EdtComment (edit control in main GUI)
      Clipboard =
      GuiControl, 1:Focus, EdtComment
      Send, ^c
      
      If Clipboard is not space
        Inputbox, URLDescription, Enter Linktext, e.g. Google,,,120,,,,, %Clipboard%
      Else
        Inputbox, URLDescription, Enter Linktext, e.g. Google,,,120
        
      Control, EditPaste, [url=%PasteURL%]%URLDescription%[/url], Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment      
    }
Return

BtnEmail:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags("[email]", "[/email]")
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment 
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    Clipboard := ComposeBBCodeTags("[email]", "[/email]")
Return

F10::
BtnImage:
  PasteBBCode := SetBBCodeTags("[img]", "[/img]")
  Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
  GuiControl, 1:Focus, EdtComment
  If MoveCaret
    Send, {Left %EndTagLen%}
Return

F9::
BtnColor:
  GoSub, SelectFontColor      
  Gui, 2:Show, w200, %lang_gui2_TtlGui2%    
  GuiControl, 1:Focus, EdtComment
Return

BtnSize:
  GoSub, SelectFontSize      
  Gui, 3:Show, Center, %lang_gui3_TtlGui3%
  GuiControl, 3:Focus, EdtUserFontSize
  ; Highlight edit control content
  Send, ^a
   
  GuiControl, 1:Focus, EdtComment
Return

BtnListNum:
  PasteBBCode := SetBBCodeTags("[list=1]", "[/list]")
  Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
  GuiControl, 1:Focus, EdtComment 
  If MoveCaret
    Send, {Left %EndTagLen%}
Return

BtnListLetter:
  PasteBBCode := SetBBCodeTags("[list=a]", "[/list]")
  Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
  GuiControl, 1:Focus, EdtComment 
  If MoveCaret
    Send, {Left %EndTagLen%}
Return

F7::
BtnListUnNum:
  PasteBBCode := SetBBCodeTags("[list]", "[/list]")
  Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
  GuiControl, 1:Focus, EdtComment 
  If MoveCaret
    Send, {Left %EndTagLen%}
Return

F8::
BtnListElement:
  Control, EditPaste, [*], Edit1, %ScriptName%
  GuiControl, 1:Focus, EdtComment
Return

F12::
BtnSmileys:
  GoSub, SelectSmiley
Return

BtnPinned:
  ; Find the Window Handle
  WinHandle := WinExist(ScriptName)
  
  If PinnedPressed = 0
    {
      SetButtonGraphic(WinHandle, "18", A_ScriptDir "\phpbb\ico\pinned.ico", 16, 16, IMAGE_ICON)  
      PinnedPressed = 1
    }
  Else
    {
      SetButtonGraphic(WinHandle, "18", A_ScriptDir "\phpbb\ico\unpinned.ico", 16, 16, IMAGE_ICON)
      PinnedPressed = 0
    }
  WinSet, AlwaysOnTop, Toggle, %ScriptName%
Return

; ###### Custom buttons glabels ###############################################
BtnCustom1:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag1, BBEndTag1)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment  
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    Clipboard := ComposeBBCodeTags(BBStartTag1, BBEndTag1)
Return

BtnCustom2:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag2, BBEndTag2)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment  
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag2, BBEndTag2)
Return

BtnCustom3:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag3, BBEndTag3)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment  
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag3, BBEndTag3)
Return

BtnCustom4:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag4, BBEndTag4)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment  
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag4, BBEndTag4)
Return

BtnCustom5:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag5, BBEndTag5)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment  
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag5, BBEndTag5)
Return

BtnCustom6:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag6, BBEndTag6)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment  
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag6, BBEndTag6)
Return

BtnCustom7:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag7, BBEndTag7)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment  
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag7, BBEndTag7)
Return

BtnCustom8:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag8, BBEndTag8)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment  
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag8, BBEndTag8)
Return

BtnCustom9:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag9, BBEndTag9)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment  
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag9, BBEndTag9)
Return

BtnCustom10:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag10, BBEndTag10)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment  
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag10, BBEndTag10)
Return
; ___________________________________________________________________________________________________
;                                                                                inserted by °digit° |
; ~~~ Add NEW Next 10 Custom ??????? ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
BtnCustom11:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag11, BBEndTag11)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    Clipboard := ComposeBBCodeTags(BBStartTag11, BBEndTag11)
Return

BtnCustom12:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag12, BBEndTag12)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag12, BBEndTag12)
Return

BtnCustom13:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag13, BBEndTag13)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag13, BBEndTag13)
Return

BtnCustom14:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag14, BBEndTag14)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag14, BBEndTag14)
Return

BtnCustom15:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag15, BBEndTag15)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag15, BBEndTag15)
Return

BtnCustom16:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag16, BBEndTag16)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag16, BBEndTag16)
Return

BtnCustom17:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag17, BBEndTag17)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag17, BBEndTag17)
Return

BtnCustom18:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag18, BBEndTag18)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag18, BBEndTag18)
Return

BtnCustom19:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag19, BBEndTag19)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag19, BBEndTag19)
Return

BtnCustom20:
  If CtrlKeyDown != D
    {
      PasteBBCode := SetBBCodeTags(BBStartTag20, BBEndTag20)
      Control, EditPaste, %PasteBBCode%, Edit1, %ScriptName%
      GuiControl, 1:Focus, EdtComment
      If MoveCaret
        Send, {Left %EndTagLen%}
    }
  Else
    ClipBoard := ComposeBBCodeTags(BBStartTag20, BBEndTag20)
Return
; ___________________________________________________________________________________________________|

BtnCustomize:
  GoSub, CreateCstmBtnsGUI
Return
; ###### End of Custom buttons glabels ########################################

ChkSig:
  Gui, 1:Submit, NoHide
  GuiControl, 1:Enable%ChkSig%, DDLSig
  GuiControl, 1:Enable%ChkSig%, BtnEditSig
  GuiControl, 1:Enable%ChkSig%, BtnDelSig
Return

BtnEditSig:
  Gui, 1:Submit, NoHide
  
  If DDLSig is not space
    {
      MsgBox, 8244, %lang_gui1_TtlMsgEditSig%, %lang_gui1_MsgEditSig%
      IfMsgBox, Yes
        {
          If DDLSig is not space
            {
              ; Paste signature text in main-gui edit control 
              FileRead, SigText, %A_ScriptDir%\signatures\%DDLSig%
              GuiControl, 1:, EdtComment
              Control, EditPaste, %SigText%, Edit1, %ScriptName%
              
              ; Add signature path and filename to GUI1 window title
              WinSetTitle, %ScriptName%,, %ScriptName% - %A_ScriptDir%\signatures\%DDLSig%  
            }
        }
      Else
        GuiControl, 1:Focus, EdtComment
    }
Return

BtnDelSig:
  Gui, 1:Submit, NoHide
  
  If DDLSig is not space
    {
      MsgBox, 8228, %lang_gui1_TtlMsgDelSig%, %lang_gui1_MsgDelSig%`n`n    %DDLSig%?
      IfMsgBox, Yes
        {
          FileDelete, %A_ScriptDir%\signatures\%DDLSig%
        
          ; Re-read SigList for DropDownList
          SigList = |
          Loop, %A_ScriptDir%\signatures\*.txt
            {
              SigList = %SigList%|%A_LoopFileName%
            }  
          GuiControl, 1:, DDLSig, %SigList%
        }
      Else
        GuiControl, 1:Focus, EdtComment
    }
Return

BtnSend:
  Gui, 1:Submit, NoHide
  
  If ChkSig = 1
    If DDLSig is not space
      {
        FileRead, SigText, %A_ScriptDir%\signatures\%DDLSig%
        EdtComment = %EdtComment%`n`n%SigText%
      }
  
  Clipboard = %EdtComment%
  Gui, 1:Show, Minimize
Return

; Create Preview (see BBCodePreview.ahk)
BtnPreview:
  Gui, 1:Submit, NoHide
  bbcode = %EdtComment%
  FileDelete, preview.html
  GoSub, CreatePreview
Return

BtnReset:
  Gui, 1:+OwnDialogs
  MsgBox, 8225, %lang_gui1_TtlMsgBtnReset%, %lang_gui1_MsgBtnReset%
  IfMsgBox, Cancel
    {
      GuiControl, 1:Focus, EdtComment
      Return
    }
  GuiControl, 1:Focus, EdtComment
  GuiControl, 1:Text, EdtComment
  
  ; Reset window title
  WinSetTitle, %ScriptName%,, %ScriptName% - %lang_gui1_TtlGui1%
Return
;##############################################################################
;####### End of MainGui Button Code ###########################################
;##############################################################################


;##############################################################################  
;####### Subroutines for Menubar ##############################################
;##############################################################################
^o::
LoadPosting:
  FileSelectFile, PostPathLoad,, %A_ScriptDir%\postings\, %lang_gui1_TtlOpenPost%, *.txt
  
  If PostPathLoad is not Space
    {
      ; Build list of recent files
      TmpFilesList = %PostPathLoad%
      
      ; File is already listed in FileMenu
      IfInString, RecentFilesList, %PostPathLoad%
        Loop, Parse, RecentFilesList, |
          {
            If A_Index <= 5
              IfNotInString, TmpFilesList, %A_LoopField%
                TmpFilesList = %TmpFilesList%|%A_LoopField%
          }          
       
      ; File is not listed in FileMenu
      Else     
        Loop, Parse, RecentFilesList, |
          {
            If A_Index <= 4
              TmpFilesList = %TmpFilesList%|%A_LoopField%
          }
       
      RecentFilesList = %TmpFilesList%
      GoSub, RebuildFileMenu
      
      ; Add path and filename to Gui1 window title
      WinSetTitle, %ScriptName%,, %ScriptName% - %PostPathLoad% 
    
      ; Put content of textfile in variable and pass to edit control
      FileRead, AttachPosting, %PostPathLoad%
      GuiControl,1:, EdtComment, %AttachPosting%
      
      ; Move caret at the end of the string
      Send, ^{END}
      
      ; Flush 'AttachPosting' to free memory
      AttachPosting =
    }
Return

^s::
SavePosting:
  WinGetTitle, Gui1WinTitle, %ScriptName%

  ; Retrieve filepath
  StringLen, Gui1TitleLen , ScriptName
  Gui1TitleLen := Gui1TitleLen + 3
  StringTrimLeft, Gui1WinTitle, Gui1WinTitle, %Gui1TitleLen%
  
  If Gui1WinTitle = %lang_gui1_TtlGui1%
    {
      GoSub, SaveAsPosting
      Return
    }
  Else
    {
      MsgBox, 8225, %lang_gui1_TtlMsgOverWrite%, %lang_gui1_MsgOverWrite%`n`n    %Gui1WinTitle%?
      IfMsgBox, OK
        {
          Gui,1:Submit, NoHide
          FileDelete, %Gui1WinTitle%
          FileAppend, %EdtComment%, %Gui1WinTitle%
        }
    }
Return

SaveAsPosting:
  Gui, 1:Submit, NoHide
  PostTitle = %A_YYYY%-%A_MM%-%A_DD%_%A_Hour%-%A_Min%_Posting

  ; Easier renaming - highlighting the word 'posting' -> "general subroutines"
  SetTimer, RenameHelper
  
  FileSelectFile, PostPathSave, S24, %A_ScriptDir%\postings\%PostTitle%.txt, %lang_gui1_TtlSavePost%, *.txt 

  If PostPathSave is not Space
    {
      ; Check if given name has a file extension
      StringRight, PostFileType, PostPathSave, 4
      If (PostFileType = ".txt")
        FileDelete, %PostPathSave% 
      Else
        {
          PostPathSave = %PostPathSave%.txt
          FileDelete, %PostPathSave%
        }
      
      ; Build list of recent files
      TmpFilesList = %PostPathSave%
      
      ; File is already listed in FileMenu
      IfInString, RecentFilesList, %PostPathSave%
        
        Loop, Parse, RecentFilesList, |
          {
            If A_Index <= 5
              IfNotInString, TmpFilesList, %A_LoopField%
                TmpFilesList = %TmpFilesList%|%A_LoopField%
          }
      ; File is not listed in FileMenu
      Else
        Loop, Parse, RecentFilesList, |
          {
            If A_Index <= 4
              TmpFilesList = %TmpFilesList%|%A_LoopField%
          }
        
      RecentFilesList = %TmpFilesList%
      GoSub, RebuildFileMenu

      FileAppend, %EdtComment%, %PostPathSave%
      WinSetTitle, %ScriptName%,, %ScriptName% - %PostPathSave%
    }
Return

^g::
SaveSignature:
  Gui, 1:Submit, NoHide
  
  FileSelectFile, SigPathSave, S24, %A_ScriptDir%\signatures\%DDLSig%, %lang_gui1_TtlSaveSig%, *.txt
  
  If SigPathSave is not space
    {
      StringRight, SigFileType, SigPathSave, 4
      If (SigFileType = ".txt")
        {
          FileDelete, %SigPathSave%
          FileAppend, %EdtComment%, %SigPathSave%  
        }
      Else
        {
          SigPathSave = %SigPathSave%.txt
          FileDelete, %SigPathSave%
          FileAppend, %EdtComment%, %SigPathSave%
        }
    }
  
  ; Re-read SigList for DropDownList
  SigList = |
  Loop, %A_ScriptDir%\signatures\*.txt
    {
      SigList = %SigList%|%A_LoopFileName%
    }
  GuiControl, 1:, DDLSig, %SigList% 
Return


UndoChanges:
  Send, ^z
Return

CutText:
  Send, ^x
Return

CopyText:
  Send, ^c
Return

PasteText:
  Send, ^v
Return

DeleteText:
  Send, {DEL} 
Return

^a::
SelectAllText:
  Send, ^{HOME}
  Send, ^+{END}
Return

^f::
ClearClip:
  Clipboard =
Return

Recent1:
  FileNmbr = 1
  GoSub, OpenRecentFile
Return

Recent2:
  FileNmbr = 2
  GoSub, OpenRecentFile  
Return

Recent3:
  FileNmbr = 3
  GoSub, OpenRecentFile
Return

Recent4:
  FileNmbr = 4
  GoSub, OpenRecentFile
Return

Recent5:
  FileNmbr = 5
  GoSub, OpenRecentFile
Return

OpenRecentFile:
  Loop, Parse, RecentFilesList, |
    {
      If A_Index = %FileNmbr%
        {
          MsgBox, 8225, %lang_gui1_TtlMsgOpenRecentFile%, %lang_gui1_MsgOpenRecentFile%`n`n    %A_LoopField%?
          IfMsgBox, OK
            {
              ; Add path and filename to Gui1 window title
              WinSetTitle, %ScriptName%,, %ScriptName% - %A_LoopField%

              ; Put content of textfile in variable
              FileRead, AttachPosting, %A_LoopField%
              If Errorlevel = 0
                {              
                  ; Rebuild list of recent files - put new file in 1st position
                  TmpFilesList = %A_LoopField%
    
                  Loop, Parse, RecentFilesList, |
                    {
                      If A_Index <= 5
                        IfNotInString, TmpFilesList, %A_LoopField%
                          TmpFilesList = %TmpFilesList%|%A_LoopField%
                    }                              
                  RecentFilesList = %TmpFilesList%
                  GoSub, RebuildFileMenu
                      
                  ; Pass variable to edit control
                  GuiControl,1:, EdtComment, %AttachPosting%
                  
                  ; Move caret at the end of the string
                  Send, ^{END}
                  
                  ; Flush 'AttachPosting' to free memory
                  AttachPosting =
                }
              ; Error occured during opening the file
              Else
                {
                  MsgBox, 8208, %lang_gui1_TtlMsgOpenRecentFileError%, %lang_gui1_MsgOpenRecentFileError%
                  
                  ErrorFile = %A_LoopField%
                  TmpFilesList =
                  
                  Loop, Parse, RecentFilesList, |
                    {
                      If A_Index <= 5
                        IfNotInString, ErrorFile, %A_LoopField%
                          TmpFilesList = %TmpFilesList%|%A_LoopField%
                    } 
                  StringTrimLeft, TmpFilesList, TmpFilesList, 1
                  RecentFilesList = %TmpFilesList%
                  GoSub, RebuildFileMenu
                }
            }
          Break
        }
      Else
        Continue
    }
Return

RebuildFileMenu:
  Gui, 1:Menu
  Menu, FileMenu, DeleteAll 

  Menu, FileMenu, Add, %lang_gui1_open%, LoadPosting
  Menu, FileMenu, Add
  Menu, FileMenu, Add, %lang_gui1_savepost%, SavePosting 
  Menu, FileMenu, Add, %lang_gui1_saveaspost%, SaveAsPosting
  Menu, FileMenu, Add
  Menu, FileMenu, Add, %lang_gui1_savesig%, SaveSignature
  Menu, FileMenu, Add
  Menu, FileMenu, Add, %lang_gui1_pref%, CreatePreferencesGUI
  Menu, FileMenu, Add
  
  If RecentFilesList is not space
    {
      Loop, Parse, RecentFilesList, |
        {
          Menu, FileMenu, Add, %A_Index% %A_LoopField%, Recent%A_Index%
        }
        Menu, FileMenu, Add
    }

  Menu, FileMenu, Add, %lang_gui1_exit%, GuiClose

  ; Sleep is needed to avoid a redrawing bug when dettaching and reattaching menu bar too fast  
  Sleep, 10
  
  Gui, 1:Menu, MenuBar
Return

; Highlight the "posting" within proposed filename YYYY-MM-DD_HH-mm_Posting.txt for easier saving
RenameHelper:
  WinWait, %lang_gui1_TtlSavePost%
  
  ; Save clipboard data
  ClipSaved := ClipboardAll

  ; Highlight and copy last four chars of PostTitle
  Send, {End}{Left 4}
  Send, {SHIFT DOWN}{Right 4}{SHIFT UP}
  Send, ^c
  CheckForFileType = %Clipboard%

  If CheckForFileType = .txt
    {
      Send, {END}{Left 11}
      Send, {SHIFT DOWN}{Right 7}{SHIFT UP}
    }
  Else
    {
      Send, {END}{Left 7}
      Send, {SHIFT DOWN}{Right 7}{SHIFT UP}    
    }

  ; Restore Clipboard and free memory of ClipSaved & CheckForFileType  
  Clipboard := ClipSaved
  ClipSaved =
  CheckForFileType =
  
  SetTimer, RenameHelper, Off
Return

CheckForUpdate:
  MsgBox, 8228, %lang_gui1_TtlMsgCheckUpdates%, %lang_gui1_MsgCheckUpdates%
  IfMsgBox, Yes 
    {
      URLDownloadToFile, http://file.autohotkey.net/AGermanUser/BBCodeWriter/version.txt, %A_ScriptDir%\version.txt
      FileRead, InternetVersion, %A_ScriptDir%\version.txt
      
      ; Convert InternetVersion to float
      InternetVersion := Internetversion+= 0
      If ErrorLevel =  0
        {
          LocalVersion = %Version%
          Loop, Parse, Version, .
            {
              If A_Index = 1
                LocalVersion = %A_LoopField%.
              Else
                LocalVersion = %LocalVersion%%A_LoopField%
            }
          If LocalVersion < %InternetVersion%
            {
              MsgBox, 8228, %lang_gui1_TtlMsgCheckUpdates%, %lang_gui1_MsgNewUpdates% %InternetVersion%`n`n%lang_gui1_MsgUpdateVisit%
              IfMsgBox, Yes
                GoSub, ForumLink
            }
          If LocalVersion >= %InternetVersion%
            MsgBox,, %lang_gui1_TtlMsgCheckUpdates%, %lang_gui1_MsgNoNewUpdate%
        }
      Else
        MsgBox, Error  
    } 
Return
;##############################################################################  
;####### End of Subroutines for MenuBar #######################################
;##############################################################################


;##############################################################################
;####### ToolTip Code for MainGui #############################################
;##############################################################################

; Thanks to Rajat for this code
; Details under http://www.autohotkey.com/forum/topic2891.html
ShowTip:
  IfWinNotActive, %ScriptName%
    Return
  
    MouseGetPos,,,, ACtrl
      Tip =
    
    If ACtrl = Button2
      Tip = %lang_gui1_TTBold%
  
    If ACtrl = Button3
      Tip = %lang_gui1_TTItalic%
  
    If ACtrl = Button4
      Tip = %lang_gui1_TTUnderline%
    
    If ACtrl = Button5
      Tip = %lang_gui1_TTQuote%
  
    If ACtrl = Button6
      Tip = %lang_gui1_TTCode%
    
    If ACtrl = Button7
      Tip = %lang_gui1_TTUrl%
  
    If ACtrl = Button8
      Tip = %lang_gui1_TTUrlDesc%
  
    If ACtrl = Button9
      Tip = %lang_gui1_TTEmail%
  
    If ACtrl = Button10
      Tip = %lang_gui1_TTImage%
      
    If ACtrl = Button11
      Tip = %lang_gui1_TTColor%
  
    If ACtrl = Button12
      Tip = %lang_gui1_TTSize%
  
    If ACtrl = Button13
      Tip = %lang_gui1_TTListNum%
      
    If ACtrl = Button14
      Tip = %lang_gui1_TTLetter%
  
    If ACtrl = Button15
      Tip = %lang_gui1_TTListUnNum%
  
    If ACtrl = Button16
      Tip = %lang_gui1_TTListElement%
  
    If ACtrl = Button17
      Tip = %lang_gui1_TTSmileys%
      
    If ACtrl = Button18
      Tip = %lang_gui1_TTPinned%

    If CstmBarEnabled = 1
      {      
        If ACtrl = Button20
          Tip = %BBToolTip1%
        
        If ACtrl = Button21
          Tip = %BBToolTip2%
    
        If ACtrl = Button22
          Tip = %BBToolTip3%
          
        If ACtrl = Button23
          Tip = %BBToolTip4%
          
        If ACtrl = Button24
          Tip = %BBToolTip5%
          
        If ACtrl = Button25
          Tip = %BBToolTip6%
          
        If ACtrl = Button26
          Tip = %BBToolTip7%
          
        If ACtrl = Button27
          Tip = %BBToolTip8%
          
        If ACtrl = Button28
          Tip = %BBToolTip9%
          
        If ACtrl = Button29
          Tip = %BBToolTip10%
; ___________________________________________________________________________________________________
;                                                                                inserted by °digit° |
; ~~~ Add NEW Next 10 CstmBarEnabled ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        If ACtrl = Button30
          Tip = %BBToolTip11%

        If ACtrl = Button31
          Tip = %BBToolTip12%

        If ACtrl = Button32
          Tip = %BBToolTip13%

        If ACtrl = Button33
          Tip = %BBToolTip14%

        If ACtrl = Button34
          Tip = %BBToolTip15%

        If ACtrl = Button35
          Tip = %BBToolTip16%

        If ACtrl = Button36
          Tip = %BBToolTip17%

        If ACtrl = Button37
          Tip = %BBToolTip18%

        If ACtrl = Button38
          Tip = %BBToolTip19%

        If ACtrl = Button39
          Tip = %BBToolTip20%
; ___________________________________________________________________________________________________|
      }

    If ACtrl <> %LastCtrl%
      {
        SB_SetText(Tip) 
        LastCtrl = %ACtrl%
      }
      
    ; Check for pressed shift key  
    GetKeyState, CtrlKeyDown, Ctrl , P
    If CtrlKeyDown = D
      {
        SB_SetText("Tag-Composing Mode", 2)
        
        ; Disable all buttons not capable for compose mode
        GuiControl, 1:Disable, BtnQuote
        GuiControl, 1:Disable, BtnCode
        GuiControl, 1:Disable, BtnUrlDesc
        GuiControl, 1:Disable, BtnImage
        GuiControl, 1:Disable, BtnListNum
        GuiControl, 1:Disable, BtnListLetter
        GuiControl, 1:Disable, BtnListUnNum
        GuiControl, 1:Disable, BtnListElement
        GuiControl, 1:Disable, BtnSmileys
      }
    Else
      {
        SB_SetText("", 2)
        
        ; Reset deactivation
        GuiControl, 1:Enable, BtnQuote
        GuiControl, 1:Enable, BtnCode
        GuiControl, 1:Enable, BtnUrlDesc
        GuiControl, 1:Enable, BtnImage
        GuiControl, 1:Enable, BtnListNum
        GuiControl, 1:Enable, BtnListLetter
        GuiControl, 1:Enable, BtnListUnNum
        GuiControl, 1:Enable, BtnListElement
        GuiControl, 1:Enable, BtnSmileys      
      }
Return
;##############################################################################
;####### End of ToolTip Code for MainGui ######################################
;##############################################################################


;##############################################################################
;####### General subroutines ##################################################
;##############################################################################
RebuildGUI1:
  ; Read used language from BBCodewriter.ini and get language prefix
  IniRead, Lang, BBCodeWriter.ini, Language, Lang
  IniRead, LangPrfx, %A_ScriptDir%\lang\%Lang%, Data, LangPrfx
  
  ; Read state of custom buttons bar and Y Pos of edit control & action bar controls
  IniRead, CstmBarEnabled, BBCodeWriter.ini, CstmToolBar, CstmBarEnabled
  
  GoSub, 6GuiClose
  
  Gui, 1:Submit, NoHide
  
  ; Needed for later preselection
  UsedSignature = %DDLSig%
  
  ; Destroy Menubar and Main Gui
  Gui, 1:Menu
  Menu, FileMenu, Delete
  Menu, EditMenu, Delete
  Menu, HelpMenu, Delete
  Menu, MenuBar,  Delete	
  Gui, 1:Destroy

  ResetAnchor := true

  ; Rebuild main gui
  Gui, 1:Default
  GoSub, ReadLangStrings
  GoSub, CreateMainMenu
  GoSub, CreateMainGui
  
  ; Paste former content of controls
  GuiControl, 1:, EdtComment, %EdtComment%
  Send, ^{END} 
  If ChkSig
    {
      GuiControl, 1:, ChkSig, %ChkSig%
      GuiControl, 1:Enable%ChkSig%, DDLSig
    }
  GuiControl, 1:ChooseString, DDLSig, %UsedSignature%

  ResetAnchor := false
Return
;##############################################################################
;####### End of general subroutines ###########################################
;##############################################################################
