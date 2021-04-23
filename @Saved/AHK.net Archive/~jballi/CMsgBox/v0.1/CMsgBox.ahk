;-- v0.1 (Preview)
;*************************
;*                       *
;*        CMsgBox        *
;*    (Custom MsgBox)    *
;*                       *
;*************************
;
;
;   Description
;   ===========
;   This function displays a custom Msgbox window where the developer can
;   specify a custom icon, custom button labels, and custom font and window
;   options.
;
;
;
;   Parameters
;   ==========
;
;     Name
;     ----
;               Description
;               -----------
;
;     p_Owner
;
;               Owner window number.  [Optional]
;
;               If defined, the Owner window is disabled and ownership of the
;               Custom MsgBox window is assigned to the Owner window.  This
;               makes the Custom MsgBox window modal which prevents the user
;               from interacting with the Owner window until the Custom MsgBox
;               window is closed.
;
;
;
;     p_Title
;
;               Window title.  [Optional]  The default is the current script
;               name (sans the extention).
;
;               If p_Title begins with "++", the window title is formed by
;               using the current script name (sans extention), adding a space,
;               and then adding the value of p_Title (sans the "++" prefix).
;               For example, a p_Title of "++- Control Error" becomes
;               "ThisScriptName - Control Error".
;
;
;
;     p_Text
;
;               Message text.  [Optional]  If blank and p_Buttons is also
;               blank, p_Text is set to the value of s_DefaultText.
;
;
;
;     p_Icon
;
;               Icon to display.  [Optional]  The default is the icon defined in
;               s_DefaultIcon.  Valid values are as follows:
;
;                1) Standard MsgBox icons.  To show a standard MsgBox icon,
;                   specify one of the following values:
;
;                     Value     Meaning     Standard MsgBox icon
;                     -----     -------     --------------------
;                     !         Alert       Exclamation mark ("!") (Yellow)
;                     A         ""          ""
;                     Alert     ""          ""
;
;
;                     W         Warning     Exclamation mark ("!") (Yellow)
;                     Warn      ""          ""
;                     Warning   ""          ""
;
;
;                     E         Error       Stop hand or X (Red)
;                     Error     ""          ""
;                     X         ""          ""
;
;
;                     ?         Question    Question mark ("?") bubble
;                     Q         ""          ""
;                     Question  ""          ""
;
;
;                     I         Info        Info ("i") bubble
;                     Info      ""          ""
;
;
;                   Standard MsgBox icons are collected from the "User32.dll"
;                   file.
;
;                   Values for standard MsgBox icons also determine the default
;                   buttons for the p_Buttons parameter.  See the p_Buttons 
;                   description for more information.
;
;
;                2) Program icon.  Specify "*" (asterisk) to show the program's
;                   icon.  If the script is not compiled, the the AutoHotkey
;                   program icon is used.
;
;
;                3) Custom icon.  To use an icon from the default icon file
;                   (s_DefaultIconfile, usually "Shell32.dll") or from a
;                   specific file ("IconFile" option from the p_Options
;                   parameter), specify the the associated icon number.  If the
;                   custom icon file does not contains icons (Ex: .jpg, .gif,
;                   etc.), p_Icon should be set to 1.
;
;
;                4) No icon.  If this parameter is blank and s_DefaultIcon is
;                   also blank, no icon will be shown.  See the "NoIcon" option
;                   (p_Options parameter) for more options.
;
;
;
;     p_Buttons
;
;               Button label(s)  [Optional].  Syntax and options are as follows:
;
;                o  Multiple button labels are delimited by the "|" (pipe) 
;                   character.  For example:
;
;                       Abort|Retry|Cancel
;
;                   In this example, 3 buttons are created: Abort, Retry, and
;                   Cancel.
;
;
;                o  Putting an "*" (asterisk) character in front of a button
;                   label will make that button the default.  For example:
;
;                     Yes|*No
;
;                   In this example, the "No" button will be the default.
;
;
;                   If a default button is not specified, the first button will
;                   be made the default.
;
;
;               If p_Buttons is blank and p_Icon contains a value representing
;               a standard MsgBox icon, p_Buttons will be set to one of the
;               following static variables:
;
;                   Standard MsgBox group   Variable assigned to P_Buttons
;                   ---------------------   ------------------------------
;                   Error                   s_DefaultErrorButtons
;                   Question                s_DefaultQuestionButtons
;                   Alert                   s_DefaultAlertButtons
;                   Warning                 s_DefaultWarningButtons
;                   Info                    s_DefaultInfoButtons
;
;
;
;     p_Options
;
;               Options for operation of the CMsgBox window.  [Optional]  See
;               the "Additional Info" section at the bottom of this description
;               for more information.
;
;               This parameter allows the developer to add or remove options
;               that will affect the operation of the CMsgBox window.
;
;               Most of the options should be preceded with a "+" or "-"
;               character to indicate whether the option is to be enabled or
;               disabled. For example:
;
;                 +EscapeToClose
;
;
;               The following options (listed in alphabetic order) are
;               supported:
;
;                 Name 
;                 ----
;
;                           Description
;                           -----------
;
;                 ButtonsCenter
;
;                           Buttons are positioned in the center.  For example:
;
;                             ****************************************
;                             *                                      *
;                             *  Icon  ------- Message text -------  *
;                             *                                      *
;                             *         |Button1|  |Button2|         *
;                             *                                      *
;                             ****************************************
;
;                           This option was created for references purposes
;                           only.  Buttons are automatically centered unless the
;                           ButtonsLeft or ButtonsRight option is enabled.
;
;
;
;                 ButtonsLeft
;
;                           Buttons are positioned left-justified.  For example:
;
;                             ****************************************
;                             *                                      *
;                             *  Icon  ------- Message text -------  *
;                             *                                      *
;                             *  |Button1|  |Button2|                *
;                             *                                      *
;                             ****************************************
;
;                           This option takes precedence over the ButtonsRight
;                           option.
;
;
;
;
;                 ButtonsRight
;
;                           Buttons are positioned right-justified.  For
;                           example:
;
;                             ****************************************
;                             *                                      *
;                             *  Icon  ------- Message text -------  *
;                             *                                      *
;                             *                |Button1|  |Button2|  *
;                             *                                      *
;                             ****************************************
;
;
;
;                 Checkbox={CheckboxLabel}
;                 Checkbox="{Checkbox Label}"
;
;                           Adds one or more checkboxes to the bottom left
;                           corner of the CMsgBox window.  A common use for this
;                           option is to add a "Don't ask me again" checkbox.
;
;                           The syntax and options for {Checkbox_Label} are as
;                           follows:
;
;                             o Multiple checkbox labels are delimited by the
;                               "|" (pipe) character.  For example:
;
;                                   Option1|Option2|Option3
;
;                               In this example, 3 checkboxes are created:
;                               Option1, Option2, and Option3.
;
;
;                             o Putting an "*" (asterisk) character in front of
;                               a checkbox label will pre-check that checkbox.
;                               For example:
;
;                                       *Option_1|Option_2
;
;                               In this example, the checkbox with the
;                               "Option_1" label will contain a check mark when
;                               the window is displayed.
;
;                               More than one label can contain a "*" (asterisk)
;                               character.
;
;
;                           This option takes precedence over the Radio option.
;
;
;                                                                     
;                 Close
;
;                           Allow the window to be closed with any of the
;                           following methods:
;
;                               1)  The Close button on the title bar (if
;                                   displayed).
;
;                               2)  Alt+F4.
;
;                               3)  Escape key (if EscapeToClose is enabled).
;
;
;                           This option may automatically be enabled if the
;                           EnableCloseIfButton or EnableCloseIfOneButton
;                           options are used.  See the descriptions for these
;                           options for more information.
;
;
;
;                 Copy
;
;                           If enabled, the contents of the CMsgBox window are
;                           copied to the clipboard when the user enters Ctrl+C.
;                           The format is very similar to what is generated when
;                           Ctrl+C is entered on a standard MsgBox window.
;
;
;
;                 EnableCloseIfButton={ButtonLabel}
;                 EnableCloseIfButton={Button_Label}
;                 EnableCloseIfButton="{Button Label}"                          ;-- Need a shorter name
;
;                           Automatically enables the Close option if a button
;                           with the label of {ButtonLabel} is included as one
;                           of the the buttons (p_Buttons).  A common use for
;                           this option is to enable the Close option if a
;                           "Cancel" button has been defined as one of the
;                           buttons.  For example:
;
;                             EnableCloseIfButton=Cancel
;
;
;                           If the CMsgBox widow is closed without pressing and
;                           of the provided buttons (p_Buttons), the value of
;                           {ButtonLabel} is returned instead of "_Close".
;                               
;
;
;                 EnableCloseIfOneButton                                        ;--- Need a shorter name
;
;                           Automatically enables the Close option if only one
;                           button has been defined.  If the CMsgBox widow is
;                           closed without pressing the only provided button
;                           (p_Buttons), the button label is returned instead of
;                           "_Close".
;
;
;
;                 EscapeToClose
;
;                           Allow the user to close the CMsgBox window by
;                           hitting the Escape key.
;
;                           Note: This option has no effect unless the Close
;                           option is enabled.
;
;
;
;                 IconFile={IconFileName}
;                 IconFile="{Icon File Name}"
;
;                           Specify a custom icon file.
;
;                           Note: This option is ignored unless p_Icon contains
;                           a number.  See the p_Icon parameter description for
;                           more information.
;
;
;
;                 NoIcon
;
;                           This option overrides the values of p_Icon and
;                           s_DefaultIcon so that no icon is shown.
;
;                           This option is useful if you don't want to show an
;                           an icon but a default icon (s_DefaultIcon) has been
;                           defined.
;
;                           This option is also useful if you don't to show an
;                           icon but do want to use the default buttons and/or
;                           default sounds for the standard MsgBox icons.
;
;
;
;                 MinTextW={MinimumTextWidth}
;
;                           Sets the width of the Text control to
;                           {MinimumTextWidth} (width in pixels) if the actual
;                           width would be less than {MinimumTextWidth}.
;
;                           Note 1: This option is ignored if a width for the
;                           Text control is specified in the s_TextOptions
;                           variable or in the p_TextOptions parameter.
;
;                           Note 2:  If the value of this option is greater than
;                           the calculated maximum width (based on the
;                           s_MaxWindowPct variable), the calculated maximum
;                           width is used instead.

;
;
;
;                 MinTextH={MinimumTextHeight}
;
;                           Sets the height of the Text control to
;                           {MinimumTextHeight} (height in pixels) if the actual
;                           height would be less than {MinimumTextHeight}.
;
;                           Note: This option is ignored if a height for the
;                           Text control is specified in the s_TextOptions
;                           variable or in the p_TextOptions parameter.
;
;
;
;                 NoButtons
;
;                           This option overrides the values of p_Buttons,
;                           s_DefaultButtons, and all of the
;                           s_Default{xxxx}Buttons so that no buttons are
;                           displayed.
;
;                           Important: If used, make sure that that the user has
;                           a means of closing the window (see the Close and
;                           EscapeToClose options).
;
;
;
;                 GroupBox={GroupBoxTitle}
;                 GroupBox="{GroupBox Title}"
;
;                           A rectangular border/frame around the icon and
;                           message text controls.  The {GroupBoxTitle} is
;                           displayed at the upper-left edge of the box.  To
;                           create a GroupBox without a title, set
;                           {GroupBoxTitle} to the "1" character.  For example:
;
;                               +GroupBox=1
;
;
;
;                 Radio={RadioLabel}
;                 Radio="{Radio Label}"
;
;                           Adds one or more radio buttons to the bottom left
;                           corner of the CMsgBox window.  This option is
;                           ignored if the Checkbox option is enabled.
;
;                           The syntax and options for {RadioLabel} are as
;                           follows:
;
;                             o Multiple radio button labels are delimited by
;                               the "|" (pipe) character.  For example:
;
;                                 Option1|Option2|Option3
;
;                               In this example, 3 radio buttons are
;                               created: Option1, Option2, and Option3.
;
;
;                             o Putting an "*" (asterisk) character in front of
;                               a radio button label will pre-select that radio
;                               button.  For example:
;
;                                 *Option_1|Option_2
;
;                               In this example, the radio button with the
;                               "Option_1" label will be pre-selected.
;
;                               If there is an "*" (asterisk) character in more
;                               than one radio button label, only the last radio
;                               button label with "*" will be pre-selected.
;
;
;                           Important: Once selected, a radio button in a radio
;                           button group cannot be unselected.
;
;
;
;                 Sound
;
;                           If the Sound option is enabled, a sound is played
;                           when the CMsgBox window is displayed.  Action is as
;                           follows and in the order of precedence:
;
;                               1)  If the SoundFile option is enabled, the
;                                   sound file assigned to that option is
;                                   played.
;
;
;                               2)  If using the standard Msgbox icons, the
;                                   standard system sounds that are associated
;                                   with those icons are played.
;
;
;                               3)  If using a custom icon, the system
;                                   "Question" sound is played if a question
;                                   mark ("?") is found in the p_Text parameter,
;                                   otherwise the system "Info" sound is played.
;
;
;
;                 SoundFile={SoundFileName}
;                 SoundFile="{Sound File Name}"
;
;                           Specify a custom sound file.  
;
;                           Note: This option has no effect unless the Sound
;                           option is enabled.
;
;
;
;                 Timeout={Timeout}
;
;                           Window timeout.  {Timeout} is the timeout period in
;                           seconds.
;
;
;
;               Additional Info
;               ---------------
;               Options from this parameter (if any) are appended to the options
;               defined in the s_Options variable (if any).  To disable any of
;               options defined in s_Options, specify the option with a "-"
;               prefix.  For example:
;
;                 -EscapeToClose
;
;
;               To override an option, specify the option with a new value.  For
;               example:
;
;                 +Timeout=30
;
;
;
;     p_GUIOptions
;
;
;               GUI Options.  [Optional]  See the "Additional Info" section at
;               the bottom of this description for more information.
;
;               Some common options include the the following (not case
;               sensitive):
;
;                 Option
;                 ------
;                           Description
;                           -----------
;
;                 +AlwaysOnTop
;
;                           Makes the window stay on top of all other windows.
;
;
;                 +Border
;
;                           If used with the"-Caption" option (see below),
;                           creates a thin border around the window.
;
;
;                 -Border
;
;                           If used without the "-Caption" option, removes the
;                           title bar from the window and creates a thick border
;                           around the window.
;
;
;                 -Caption
;
;                           Removes the title bar and borders from the window.
;
;
;                  -MinimizeBox
;
;                           Disables the minimize button in the title bar (if it
;                           exists).
;
;                           Note: To insure that CMsgBox window is modal, this
;                           option is always added to this parameter.
;
;
;                 -SysMenu
;
;                           This option removes the following from the title
;                           bar: 
;
;                             System menu
;                             Icon
;                             Minimize button
;                             Maximize button
;                             Close button
;
;
;                 +ToolWindow
;
;                           Creates a narrow title bar and removes the Minimize
;                           and Maximize buttons (if they exist).
;
;
;
;              Additional Info
;               ---------------
;                o  Options are applied in the order they defined.
;
;
;                o  To use more than one option, include a space between each
;                   option.  For example:
;
;                     "-Caption +Border"
;
;
;                o  Options from this parameter (if any) are appended to the
;                   options defined in the s_GUIOptions variable (if any).  To
;                   reverse any of options defined in s_GUIOptions, specify the
;                   option with a "+"  or "-" prefix.  For example:
;
;                     +Border
;
;
;                o  For more information, see the AutoHotkey documentation
;                   -- Keyword: GUI, section: Options.
;
;
;
;     p_IconOptions
;
;               Options for the Picture control.  [Optional]  See the
;               "Additional Info" section at the bottom of this description for
;               more information.
;
;               This parameter allows the developer to specify additional or
;               overriding options for the Picture control.  Some commonly used
;               options include the following (listed in alphabetical order):
;
;                 Option 
;                 ------
;                           Description
;                           -----------
;
;                 +Border
;
;                           Creates a thin border around the Picture control.
;
;
;
;                 h{pixels}
;
;                           Determines the height (in pixels) of the Picture
;                           control.
;
;
;
;                 w{pixels}
;
;                           Determines the width (in pixels) of the Picture
;                           control.
;
;
;
;               Additional Info
;               ---------------
;                o  Options are applied in the order they defined.
;
;
;                o  To use more than one option, include a space between each
;                   option.  For example:
;
;                     "w100 h100"
;
;
;               o  Options from this parameter (if any) are appended to the
;                  options defined in the s_IconOptions variable (if any).  To
;                  override a s_IconOptions option, specify the option with a
;                  new value.  For example:
;
;                    w200
;
;
;                o  For a complete list of options, see the AutoHotkey
;                   documentation -- Keyword: GUI, section: Positioning and
;                   Sizing of Controls
;
;
;
;     p_TextOptions
;
;               Options for the Text control.  [Optional]  See the "Additional
;               Info" section at the bottom of this description for more
;               information.
;
;               This parameter allows the developer to specify additional or
;               overriding options for the Text control.  Some commonly used
;               options include the following (listed in alphabetical order):
;
;                 Option 
;                 ------
;                           Description
;                           -----------
;
;                 c{Color}
;
;                           Font color.  "{Color}" is an HTML color name or
;                           6-digit hex RGB color value.  Example values: Blue,
;                           F0F0F0, EEAA99.
;
;                           For more information, see the AutoHotkey 
;                           documentation (Keyword: color names)
;
;                           Note: This option will override any color values
;                           defined in the p_TextFontOptions parameter.
;
;
;
;                 Center
;
;                           Centers the text within the available width.
;
;
;
;                 h{pixels}
;
;                           Determines the height (in pixels) of the Text
;                           control.
;
;
;
;                 Left
;
;                           Left-justifies the text.
;
;
;
;                 r{NumberOfRows}
;
;                           {NumberOfRows} is number of rows of text that can
;                           visibly fit inside the control.
;
;
;
;                 Right
;
;                           Right-justifies the text.
;
;
;
;                 w{pixels}
;
;                           Determines the width (in pixels) of the Text
;                           control.
;
;
;
;               Additional Info
;               ---------------
;                o  Options are applied in the order they defined.
;
;
;                o  To use more than one option, include a space between each
;                   option.  For example:
;
;                     "w200 h200 Center"
;
;
;               o  Options from this parameter (if any) are appended to the
;                  options defined in the s_TextOptions variable (if any).  To
;                  override a s_TextOptions option, specify the option with a
;                  new value.  For example:
;
;                    w200
;
;
;                o  For a complete list of options, see the AutoHotkey
;                   documentation -- Keyword: GUI, section: Positioning and
;                   Sizing of Controls
;
;
;
;     p_TextFont
;
;               Font name for the Text control.  [Optional]  The default is the
;               value contained in s_DefaultTextFont.
;
;               For a list of commonly used font names, see the AutoHotkey
;               documentation -- Keyword: Fonts.
;
;
;
;     p_TextFontOptions
;
;               Font options.  [Optional]  The defaults are the options defined
;               in s_DefaultTextFontOptions.
;
;               The following font options are available (not case sensitive):
;
;                 c{HTML color name or 6-digit hex RGB color value}
;                 s{Font size (in points)}
;                 Bold
;                 Italic
;                 Strike
;                 Underline
;                 Norm
;
;
;               To use more than one option, include a space between each
;               option.  For example:
;
;                 "cBlue s10 bold underline"
;
;               For more information, see the AutoHotkey documentation --
;               Keyword: GUI, section: Font.
;
;
;
;     p_ButtonOptions
;
;               Options for the Button controls.  [Optional]  See the
;               "Additional Info" section at the bottom of this description for
;               more information.
;
;               This parameter allows the developer to specify additional or
;               overriding options for the Button controls.  Some commonly used
;               options include the following (listed in alphabetical order):
;
;                 Option 
;                 ------
;                           Description
;                           -----------
;
;                 Center
;
;                           Centers the text within the available width.
;
;
;
;                 h{pixels}
;
;                           Determines the height (in pixels) of the Button
;                           control.
;
;
;
;                 Left
;
;                           Left-justifies the text.
;
;
;
;                 r{NumberOfRows}
;
;                           NumberOfRows is number of rows of text that can
;                           visibly fit inside the control.
;
;                           Important: Do not include this option if you want
;                           the height of the control to be dynamic.
;
;
;
;                 Right
;
;                           Right-justifies the text.
;
;
;
;                 w{pixels}
;
;                           Determines the width (in pixels) of the Button
;                           control.
;
;
;
;               Additional Info
;               ---------------
;                o  Options are applied in the order they defined.
;
;
;                o  To use more than one option, include a space between
;                   each option.  For example:
;
;                     "w200 Left"
;
;
;                o  Options from this parameter (if any) are appended to the
;                   options defined in the s_ButtonOptions variable (if any).
;                   To override a s_ButtonOptions option, specify the option
;                   with a new value.  For example:
;
;                     w200
;
;
;               o   For a complete list of options, see the AutoHotkey
;                   documentation -- Keyword: GUI, section: Positioning and
;                   Sizing of Controls.
;
;
;
;     p_ButtonFont
;
;               Font name for the Button control.  [Optional]  The default is
;               the value contained in s_DefaultButtonFont.
;
;               For a list of commonly used font names, see the AutoHotkey
;               documentation -- Keyword: Fonts
;
;
;
;     p_ButtonFontOptions
;
;               Font options.  [Optional]  The defaults are the options defined
;               in s_DefaultButtonFontOptions (if any).
;
;               The following font options are available (not case sensitive):
;
;                 s{Font size (in points)}
;                 Bold
;                 Italic
;                 Strike
;                 Underline
;                 Norm
;
;
;               To use more than one option, include a space between each
;               option.  For example:
;
;                 "s10 bold underline"
;
;               For more information, see the AutoHotkey documentation --
;               Keyword: GUI, section: Font.
;
;
;
;     p_BGColor
;
;               Sets the background color of the GUI. [Optional]  The default is
;               the color defined in s_DefaultBGColor.
;
;               To set, specify one of the 16 primary HTML color names or a
;               6-digit hex RGB color value.  Example values: Blue, F0F0F0,
;               EEAA99, Default.
;
;               For more information, see the AutoHotkey documentation --
;               Keyword: color names.
;
;
;
;   Processing and Usage Notes
;   ==========================
;   To improve usability, the "+AlwaysOnTop" GUI option is automatically removed
;   if p_Owner is specified.
;
;
;
;   Programming Notes
;   =================
;    o  Variables.  In an attempt to easily identify the variables used by this
;       function, variable names have been defined using the following syntax:
;
;        -  Function parameters.  Parameter variables are prefixed with "p_".
;           For example: p_Title.
;
;
;        -  Global variables.  In an attempt to ensure that global variables
;           do not collide with other script variables, global variables are
;           prefixed with the function name.  For example: CMsgBox_Command.
;
;
;        -  Static variables.  Most static variables are prefixed with "s_".
;           For example: s_StartGUI.  Static variables used to represent Win32
;           constants (if any) are named as defined by Microsoft.
;
;           Many of the static variable are used to store the function's default
;           or initial values.  Some of these variables contain the equivalent
;           of system defaults but others contain personal preferences.  Most of
;           the static variables include a description.  Please feel free to
;           change any of the values. 
;
;
;        -  Option variables.  For this function, option variables are
;           dynamically created from default and parameter values.  Option
;           variables are prefixed with "o_".  For example: o_EscapeToClose.
;
;           There are two types of option variables: Boolean and Assignment.
;
;           Boolean option variables are either enabled (set to TRUE) or
;           disabled (the variable does not exist (the default) or set to
;           FALSE).  To check to see if these options are enanbled or not, the
;           option variable can be tested by doing a simple boolean test.  For
;           example: "If o_OptionName" or "If not o_OptionName".
;
;           Assignment option variables are either enabled (contain any
;           non-blank value) or disabled (the variable does not exist (the 
;           default) or is blank).  Since "0" is possible assignment value, you
;           can't do simple boolean tests to see if these options are enabled or
;           not.  Use StrLen or test for Space type for these options.  For
;           example: "If StrLen(o_AssignmentOption)" or "If o_AssignmentOption
;           is Space".
;
;
;        -  Local variables.  Local variables that may or may not be used in
;           multiple locations in the script are prefixed with "l_".  For
;           example: l_Result.
;
;
;        -  Temporary variables.  Temporary local variables (if any) are
;           prefixed with "t_".  For example: t_Index.  Temporary variables
;           should be used sparingly.
;
;
;
;   Return Codes
;   ============
;   If the user clicks on one of the provided buttons, the button label (sans
;   the "*" (asterisk), "&" (ampersand), and "`n" (new line) characters) is
;   returned.
;
;   If the user closes the window without pressing one of the provided buttons,
;   "_Close" is returned.  Exceptions: See the EnableCloseIfButton and
;   EnableCloseIfOneButton options.
;
;   If the window closes because the timeout period has expired, "_Timeout" is
;   returned.
;
;   
;
;   ErrorLevel
;   ==========
;   Errorlevel is set to 0 unless one of the following conditions apply:
;
;       1)  If the function is unable to create a CMsgBox window for any
;           reason, ErrorLevel is set to the word FAIL.
;
;
;       2)  If the Checkbox option is used, ErrorLevel is assigned a "1"
;           (checked) or "0" (not checked) character for every checkbox label
;           defined. So if there are 5 checkboxes, Errorlevel will contain 5
;           characters.  For example:
;
;               01100
;
;           In this example, the 2nd and 3rd checkboxes are checked.
;
;
;       3)  If the Radio option is used, ErrorLevel is set to the number of the
;           currently selected button: 1 is the first radio button, 2 is the
;           second, and so on.  If there is no radion button selected,
;           ErrorLevel is set to 0.
;
;
;   Important:  ErrorLevel is set regardless of how the Custom MsgBox window is
;   closed.  If action is performed based on the ErrorLevel value, be sure to
;   check the return value before proceeding.
;
;   
;
;   Credit/References
;   =================
;   Inspiration and some code for this function extracted from the following:
;
;       Author: Danny Ben Shitrit (aka Icarus)
;       Source: http://www.autohotkey.com/forum/viewtopic.php?t=32367
;
;       Author: Roland
;       Source: http://www.autohotkey.com/forum/viewtopic.php?p=63485#63485
;
;   Thanks to everyone who contributed.
;
;
;
;   Calls To Other Functions
;   ========================
;   CMsgBox_DisableCloseButton
;
;       Author:     Skan
;       Source:     Included
;       Forum/Site: http://www.autohotkey.com/forum/viewtopic.php?p=62506#62506
;
;
;   CMsgBox_PopupXY
;
;       Source:     Included
;       Forum/Site: http://www.autohotkey.com/forum/viewtopic.php?t=20885
;
;-------------------------------------------------------------------------------
CMsgBox(p_Owner=""
       ,p_Title=""
       ,p_Text=""
       ,p_Icon=""
       ,p_Buttons=""
       ,p_Options=""
       ,p_GUIOptions=""
       ,p_IconOptions=""
       ,p_TextOptions=""
       ,p_TextFont=""
       ,p_TextFontOptions=""
       ,p_ButtonOptions=""
       ,p_ButtonFont=""
       ,p_ButtonFontOptions=""
       ,p_BGColor="")
    {
    ;[====================]
    ;[  Global variables  ]
    ;[====================]
    Global CMsgBox_Command


    ;[====================]
    ;[  Static variables  ]
    ;[====================]
    Static Dumm926

          ,s_StartGUI:=62
                ;-- Default starting GUI window number for the CMsgBox window.
                ;   Change if desired.


          ,s_ActiveGUI
                ;-- This variable stores the currently active GUI.  If this
                ;   function is called while a ListManagerGUI window is still
                ;   active, this variable is used to temporarily disable the
                ;   active ListManagerGUI window so that an error message can be
                ;   displayed and dismissed.


          ,s_ActiveError:=false
                ;-- This variable is set to true if the function is currently
                ;   processing a duplicate-call error message.


          ,s_MarginX:=13
          ,s_MarginY:=13
                ;-- Margins and spacing between object groups


          ,s_DefaultText:="Press OK to continue."
                ;-- Default message text.


          ,s_DefaultButtons:="*OK"
                ;-- This default is used when no buttons and no (or an invalid)
                ;   icon is defined.


          ,s_DefaultErrorButtons   :="*OK"
          ,s_DefaultQuestionButtons:="*&Yes|&No"
          ,s_DefaultAlertButtons   :="*OK"
          ,s_DefaultWarningButtons :="*OK|Cancel"
          ,s_DefaultInfoButtons    :="*OK"
                ;-- These defaults are used when an standard MsgBox icon is
                ;   defined but buttons are not.  Change if desired.


          ,s_DefaultErrorSound     :="*16"  ;-- *16=System Stop/Error sound
          ,s_DefaultQuestionSound  :="*32"  ;-- *32=System Question sound
          ,s_DefaultAlertSound     :="*48"  ;-- *48=System Exclamation sound
          ,s_DefaultWarningSound   :="*48"  ;-- *48=System Exclamation sound
          ,s_DefaultInfoSound      :="*64"  ;-- *64=System Info sound
                ;-- These default sounds are used if a standard MsgBox icon is
                ;   used.  Change if desired.


          ,s_DefaultIcon:=""
                ;-- Default icon.  Leave blank if there is no default icon.


          ,s_DefaultIconFile:="Shell32.dll"
                ;-- Default icon file.  This file, usually "Shell32.dll", is
                ;   used if a standard MsgBox icon is not used AND the IconFile
                ;   option (p_Options) is not used.


          ,s_Options:="+Copy +EnableCloseIfButton=Cancel +EnableCloseIfOneButton +EscapeToClose +Sound"
                ;-- Initial options for the operation of the CMsgBox window.
                ;   Change if desired.  Leave blank if there are no initial
                ;   options.


          ,s_IconOptions:=""
                ;-- Initial options for the Picture control.
                ;
                ;   By default, the width and height for the Picture control is
                ;   dynamic but either can be made static by specifying a width
                ;   or height here or in the p_IconOptions parameter.


          ,s_TextOptions:=""
                ;-- Initial options for the Text control.
                ;
                ;   By default the width and height for the Text control is
                ;   dynamic.  The width can be made static by specifying a width
                ;   here or in the p_TextOptions parameter.  The height can be
                ;   made static by specifying a height or Number-of-rows here or
                ;   in the p_TextOptions parameter.


          ,s_DefaultTextFont:=""
                ;-- Default font for the Text control.  Leave blank to use the
                ;   system default font as the default.


          ,s_DefaultTextFontOptions:=""
                ;-- Default font options for the Text control.  Leave blank to
                ;   use the system default as the default.


          ,s_MaxWindowPct:=60
                ;-- If an initial width for the Text control is not defined
                ;   (s_TextOptions) AND a width for the Text control is not
                ;   specified by the developer (p_TextOptions parameter), the
                ;   CMsgBox window is is automatically limited to this percent
                ;   of the monitor work area.  This is accomplished by setting
                ;   the width of the Text control to a fixed value.
                ;
                ;   Important: This variable helps to control the maximum WIDTH
                ;   of the CMsgBox window.  There is currently no method to 
                ;   limit the height of the winow.


          ,s_ButtonOptions:="w75"
                ;-- Initial options for the Button controls.
                ;
                ;   Note: By default, the height for the Button control(s) is
                ;   dynamic but it can be made static by specifying a height
                ;   here or in the p_ButtonOptions parameter.


          ,s_DefaultButtonFont:=""
                ;-- Default font for the Text control.  Leave blank to use the
                ;   system default font as the default.


          ,s_DefaultButtonFontOptions:=""
                ;-- Default font options for the Text control.  Leave blank to
                ;   use the system default as the default.


           ,s_ButtonSpacer:=6
                ;-- The space between each button, in pixels. Do not set this
                ;   variable to blank.


          ,s_GUIOptions:="+AlwaysOnTop -SysMenu"
                ;-- Initial window options.  Leave blank if there are no initial
                ;   options.


          ,s_DefaultBGColor:=""
                ;-- Default background color.  Leave blank to use the system
                ;   default as the default.


          ;------------------
          ;-- System metrics
          ;------------------
          ,SM_CYCAPTION
            ;-- 04. Height of a regular size caption area (title bar), in
            ;   pixels.

          ,SM_CYSMCAPTION
            ;-- 51. Height of a small caption (title bar), in pixels.

          ,SM_CXBORDER
            ;-- 05. Width of a window border, in pixels.

          ,SM_CYBORDER
            ;-- 06  Height of a window border, in pixels.

          ,SM_CYMENU
            ;-- 15. Height of a single-line menu bar, in pixels.

          ,SM_CXFIXEDFRAME
            ;-- 07. The width (in pixels) of the horizontal border for fixed
            ;   window.

          ,SM_CYFIXEDFRAME
            ;-- 08. The height (in pixels) of the horizontal border for fixed
            ;   window.

          ,SM_CXSIZEFRAME
            ;-- 32. The width (in pixels) of the horizontal border for a window
            ;   that can be resized.

          ,SM_CYSIZEFRAME
            ;-- 33. The height (in pixels) of the horizontal border for a window
            ;   that can be resized.

          ,SM_CXVSCROLL
            ;-- 02. Width of a vertical scroll bar, in pixels.



    ;**************************
    ;*                        *
    ;*     CMsgBox window     *
    ;*    already showing?    *
    ;*                        *
    ;**************************
    IfWinExist ahk_group CMsgBox_Group
        {
        if not s_ActiveError
            {
            ;-- Set s_ActiveError
            s_ActiveError:=true


            ;-- Disable active CMsgBox window
            gui %s_ActiveGUI%:+Disabled
    
    
            ;-- Alert the user.  Wait for a response.
            MsgBox
                ,262160  ;-- 262160=0 (OK button) + 16 (Error icon) + 262144 (AOT)
                ,%A_ThisFunc% Error,
                   (ltrim join`s
                    A %A_ThisFunc% window already exists.  Only one %A_ThisFunc%
                    window can be used at a time.  %A_Space%
                   )
    
            ;-- Enable and activate active CMsgBox window
            gui %s_ActiveGUI%:-Disabled
            gui %s_ActiveGUI%:Show


            ;-- Reset s_ActiveError
            s_ActiveError:=false
            }    


        ;-- Return to sender
        Errorlevel=FAIL
        return ""
        }



    ;********************
    ;*                  *
    ;*    Initialize    *
    ;*                  *
    ;********************
    SplitPath A_ScriptName,,,,l_ScriptName
    CMsgBox_Command:=""
    l_ErrorLevel:=0
    l_Result:=""
    l_Showing:=false


    ;-- System metrics
    SysGet l_MonitorWorkArea,MonitorWorkArea

    if SM_CYCAPTION is Space
        {
        SysGet SM_CYCAPTION,4
        SysGet SM_CYSMCAPTION,51
        SysGet SM_CXBORDER,5
        SysGet SM_CYBORDER,6
        SysGet SM_CYMENU,15
        SysGet SM_CXFIXEDFRAME,7
        SysGet SM_CYFIXEDFRAME,8
        SysGet SM_CXSIZEFRAME,32
        SysGet SM_CYSIZEFRAME,33
        SysGet SM_CXVSCROLL,2
        }



    ;************************
    ;*                      *
    ;*      Parameters      *
    ;*    (Set defaults)    *
    ;*                      *
    ;************************
    ;[=========]
    ;[  Owner  ]
    ;[=========]
    p_Owner=%p_Owner%  ;-- AutoTrim
    if p_Owner is not Integer
        p_Owner=0
     else
        if p_Owner not between 1 and 99
            p_Owner=0
         else
            {
            ;-- Window exist?
            gui %p_Owner%:+LastFoundExist
            IfWinNotExist
                p_Owner=0
            }


    ;[=========]
    ;[  Title  ]
    ;[=========]
    p_Title=%p_Title%  ;-- AutoTrim
    if p_Title is Space
        p_Title:=l_ScriptName
     else
        {
        ;-- Append to script name if p_title begins with "++"?
        if SubStr(p_Title,1,2)="++"
            {
            StringTrimLeft p_Title,p_Title,2
            p_Title:=l_ScriptName . A_Space . p_Title
            }
        }


    ;[========]
    ;[  Text  ]
    ;[========]
    if p_Text is Space
        if p_Buttons is Space
            p_Text:=s_DefaultText



    ;[========]
    ;[  Icon  ]
    ;[========]
    p_Icon=%p_Icon%  ;-- AutoTrim
    if p_Icon is Space
        p_Icon:=s_DefaultIcon


    ;[===========]
    ;[  Buttons  ]
    ;[===========]
    p_Buttons=%p_Buttons%  ;-- AutoTrim
    if p_Buttons is Space
        {
        ;-- Alert
        if p_Icon in !,A,Alert
            p_Buttons:=s_DefaultAlertButtons
         else
            ;-- Warning
            if p_Icon in W,Warn,Warning
                p_Buttons:=s_DefaultWarningButtons
             else
                ;-- Question
                if p_Icon in ?,Q,Question
                    p_Buttons:=s_DefaultQuestionButtons
                 else
                    ;-- Error/Stop
                    if p_Icon in E,Error,X
                        p_Buttons:=s_DefaultErrorButtons
                     else
                        ;-- Info
                        if p_Icon in I,Info
                            p_Buttons:=s_DefaultInfoButtons
                         else
                            ;-- Not a standard MsgBox icon
                            p_Buttons:=s_DefaultButtons
        }


    ;-- If a default button is not set, make the first button the default
    if InStr(p_Buttons,"*")=0
        p_Buttons:="*" . p_Buttons


    ;[===========]
    ;[  Options  ]
    ;[===========]
    p_Options:=s_Options . A_Space . p_Options
    p_Options=%p_Options%  ;-- AutoTrim


    ;[===============]
    ;[  GUI options  ]
    ;[===============]
    p_GUIOptions:=s_GUIOptions . A_Space . p_GUIOptions
    p_GUIOptions=%p_GUIOptions%  ;-- AutoTrim
    if p_Owner
        {
        StringReplace,p_GUIOptions,p_GUIOptions,+AlwaysOnTop,,All
        StringReplace,p_GUIOptions,p_GUIOptions,AlwaysOnTop,,All
        }


    ;[================]
    ;[  Icon options  ]
    ;[================]
    p_IconOptions:=s_IconOptions . A_Space . p_IconOptions
    p_IconOptions=%p_IconOptions%  ;-- AutoTrim


    ;[================]
    ;[  Text options  ]
    ;[================]
    p_TextOptions:=s_TextOptions . A_Space . p_TextOptions
    p_TextOptions=%p_TextOptions%  ;-- AutoTrim


    ;[=============]
    ;[  Text font  ]
    ;[=============]
    p_TextFont=%p_TextFont%  ;-- AutoTrim
    if p_TextFont is Space
        p_TextFont:=s_DefaultTextFont


    ;[=====================]
    ;[  Text font options  ]
    ;[=====================]
    p_TextFontOptions=%p_TextFontOptions%  ;-- AutoTrim
    if p_TextFontOptions is Space
        p_TextFontOptions:=s_DefaultTextFontOptions


    ;[==================]
    ;[  Button options  ]
    ;[==================]
    p_ButtonOptions:=s_ButtonOptions . A_Space . p_ButtonOptions
    p_ButtonOptions=%p_ButtonOptions%  ;-- AutoTrim


    ;[===============]
    ;[  Button font  ]
    ;[===============]
    p_ButtonFont=%p_ButtonFont%  ;-- AutoTrim
    if p_ButtonFont is Space
        p_ButtonFont:=s_DefaultButtonFont


    ;[=======================]
    ;[  Button font options  ]
    ;[=======================]
    p_ButtonFontOptions=%p_ButtonFontOptions%  ;-- AutoTrim
    if p_ButtonFontOptions is Space
        p_ButtonFontOptions:=s_DefaultButtonFontOptions


    ;[====================]
    ;[  Background color  ]
    ;[====================]
    p_BGColor=%p_BGColor%  ;-- AutoTrim
    if p_BGColor is Space
        p_BGColor:=s_DefaultBGColor



    ;*********************************
    ;*                               *
    ;*    Extract/Process options    *
    ;*                               *
    ;*********************************
    ;-- Initialize 
    l_DQLoop:=false


    ;-- Assignment options
    l_AssignmentOptions=
       (ltrim join`s
        Checkbox
        EnableCloseIfButton
        GroupBox
        IconFile
        MinTextW
        MinTextH
        Radio
        SoundFile
        Timeout
       )
        ;-- This is a list of option names that can be assigned a value
        ;   (Ex: Timeout=25).  If a new assignment option is added, don't forget
        ;   to add it to this list.


    ;-- Note: If undefined, options are assumed to be FALSE (not enabled)
    loop parse,p_Options,%A_Space%
        {
        ;[============]
        ;[  DQ loop?  ]
        ;[============]
        if l_DQLoop
            {
            ;-- Append value
            %l_DQLoopVar%:=%l_DQLoopVar% . A_Space . A_LoopField


            ;-- Trailing DQ?
            if SubStr(%l_DQLoopVar%,StrLen(%l_DQLoopVar%))=""""
                {
                ;-- Trim trailing DQ
                StringTrimRight %l_DQLoopVar%,%l_DQLoopVar%,1


                ;-- Blank out if option is NOT enabled
                if not l_OptionEnabled
                    %l_DQLoopVar%:=""


                ;-- We're done with this one
                l_DQLoop:=false
                }


            continue
            }


        ;-- Blank or too short?
        if StrLen(A_LoopField)<2
            continue


        ;[============]
        ;[  Enabled?  ]
        ;[============]
        l_OptionEnabled:=true
        if SubStr(A_LoopField,1,1)="-"
            l_OptionEnabled:=false


        ;-- Break it down
        l_Option:=A_LoopField
        if SubStr(A_LoopField,1,1)="+"
        or SubStr(A_LoopField,1,1)="-"
            StringTrimLeft l_Option,l_Option,1


        ;[======================]
        ;[  Assignment options  ]
        ;[======================]
        l_DQLoop:=false
        l_AssignmentOption:=false
        loop parse,l_AssignmentOptions,%A_Space%
            {
            if SubStr(l_Option,1,StrLen(A_LoopField))=A_LoopField
                {
                l_AssignmentOption:=true
                o_%A_LoopField%:=SubStr(l_Option,StrLen(A_LoopField)+1)


                ;-- Trim assignment operator (if any)
                if SubStr(o_%A_LoopField%,1,1)="="
                    StringTrimLeft o_%A_LoopField%,o_%A_LoopField%,1


                ;-- Leading DQ?
                if SubStr(o_%A_LoopField%,1,1)=""""
                    {
                    ;-- Trim leading DQ
                    StringTrimLeft o_%A_LoopField%,o_%A_LoopField%,1
    
    
                    ;-- Trailing DQ?
                    if SubStr(o_%A_LoopField%,StrLen(o_%A_LoopField%))=""""
                        StringTrimRight o_%A_LoopField%,o_%A_LoopField%,1
                     else
                        {
                        l_DQLoop:=true
                        l_DQLoopVar:="o_" . A_LoopField
                        }
                    }


                ;-- Blank out if option is NOT enabled
                if not l_OptionEnabled
                    o_%A_LoopField%:=""
    
    
                break
                }
            }


            ;-- Assignment option found?
            if l_AssignmentOption
                continue


        ;[======================]
        ;[  Valid option name?  ]
        ;[======================]
        l_ValidOptionName:=true
        loop parse,l_Option
            {
            if A_LoopField is AlNum
                continue

            if A_LoopField in #,_,@,$,?,[,]
                continue

            l_ValidOptionName:=false
            break
            }

        if not l_ValidOptionName
            continue


        ;[==================]
        ;[  Regular option  ]
        ;[==================]
        if l_OptionEnabled
            o_%l_Option%:=true
         else
            o_%l_Option%:=false
        }



    ;*********************************
    ;*                               *
    ;*    Post-extract processing    *
    ;*                               *
    ;*********************************
;;;;;    ;-- NoIcon?
;;;;;    if o_NoIcon
;;;;;        p_Icon=

    ;-- NoButtons?
    if o_NoButtons
        p_Buttons=


    ;-- MinTextW
    if o_MinTextW is not Number
        o_MinTextW:=""


    ;-- MinTextH
    if o_MinTextH is not Number
        o_MinTextH:=""


    ;-- Timeout
    if o_Timeout is Number
        o_Timeout:=o_Timeout*1000
     else
        o_Timeout:=""


    ;--------------------------------------
    ;--         EnableCloseIfButton
    ;-- (Disable option if not applicable)
    ;--------------------------------------
    if o_EnableCloseIfButton is not Space
        if Instr("|" . RegExReplace(p_Buttons,"[*&\n]","") . "|" 
                ,"|" . RegExReplace(o_EnableCloseIfButton,"[*&\n]") . "|")
            o_Close:=true
         else
            o_EnableCloseIfButton:=""


    ;--------------------------------------
    ;--       EnableCloseIfOneButton
    ;-- (Disable option if not applicable)
    ;--------------------------------------
    if o_EnableCloseIfOneButton
        if InStr(p_Buttons,"|")=0
            o_Close:=true
         else
            o_EnableCloseIfOneButton:=false



    ;************************************
    ;*                                  *
    ;*       Find available window      *
    ;*    (Starting with s_StartGUI)    *
    ;*                                  *
    ;************************************
    l_GUI:=s_StartGUI
    loop
        {
        ;-- Window available?
        gui %l_GUI%:+LastFoundExist
        IfWinNotExist
            {
            s_ActiveGUI:=l_GUI
            break
            }

        ;-- Nothing available?
        if l_GUI=99
            {
            MsgBox
                ,262160  ;-- 262160=0 (OK button) + 16 (Error icon) + 262144 (AOT)
                ,CMsgBox Error,
                   (ltrim  join`s
                    Unable to create CMsgBox window.  GUI windows %s_StartGUI%
                    to 99 are already in use.  %A_Space%
                   )

            outputdebug
                ,End Func: %A_ThisFunc% (Unable to create CMsgBox window)
            Errorlevel=FAIL
            return ""
            }

        ;-- Increment window number
        l_GUI++
        }



    ;*************************************
    ;*                                   *
    ;*     Resolve incomplete values     *
    ;*    (Icon, Iconfile, SoundFile)    *
    ;*                                   *
    ;*************************************
    ;-- Set default sound
    if p_Text contains ?
        l_SoundFile:="*32"  ;-- *32=System Question sound
     else
        l_SoundFile:="*-1"  ;-- *64=System default sound


    ;[===========]
    ;[  No icon  ]
    ;[===========]
    if p_Icon is Space
        {
        l_Icon:=""
        l_IconFile:=""
        }
     else
         ;[================]
         ;[  Program icon  ]
         ;[================]
        if p_Icon=*
            {
            l_Icon=1
            if A_IsCompiled
                l_IconFile:=A_ScriptName
             else
                l_IconFile:=A_AhkPath


            ;-- Override?
            if o_NoIcon
                l_Icon:=""
            }
         else
            ;[===============]
            ;[  Custom icon  ]
            ;[===============]
            if p_Icon is Number
                {
                l_Icon:=p_Icon
                l_IconFile:=s_DefaultIconFile
                if o_IconFile is not Space
                    l_IconFile:=o_IconFile


                ;-- Override?
                if o_NoIcon
                    l_Icon:=""
                }
             else
                {
                ;[========================]
                ;[  Standard Msgbox icon  ]
                ;[========================]
                l_IconFile:="User32.dll"


                ;-- Alert
                if p_Icon in !,A,Alert
                    {
                    l_Icon=2
                    l_SoundFile:=s_DefaultAlertSound
                    }
                 else
                    ;-- Warning
                    if p_Icon in W,Warn,Warning
                        {
                        l_Icon=2
                        l_SoundFile:=s_DefaultWarningSound
                        }
                     else
                        ;-- Question
                        if p_Icon in ?,Q,Question
                            {
                            l_Icon=3
                            l_SoundFile:=s_DefaultQuestionSound
                            }
                         else
                            ;-- Error/Stop
                            if p_Icon in E,Error,X
                                {
                                l_Icon=4
                                l_SoundFile:=s_DefaultErrorSound
                                }
                             else
                                ;-- Info or none of the above
                                {
                                l_Icon=5
                                l_SoundFile:=s_DefaultInfoSound
                                }

                ;-- Override?
                if o_NoIcon
                    l_Icon:=""
                }



    ;**********************************
    ;*                                *
    ;*    Adjust text width/height    *
    ;*                                *
    ;**********************************
    ;-- Initialize
    l_TextControlH=0


    ;[=========]
    ;[  Width  ]
    ;[=========]
    ;-- Width for the Text control already fixed?
    if InStr(A_Space . p_TextOptions," w")=0
        {
        ;-- Create temporary window with dummy objects to determine width
        if (p_TextFont or p_TextFontOptions)
            gui %l_GUI%:Font,%p_TextFontOptions%,%p_TextFont%
        gui %l_GUI%:Add,Text,%p_TextOptions%,%p_Text%
        GUIControlGet l_TextControl,%l_GUI%:Pos,Static1

        l_PictureControlW=0
        if l_icon
            {
            gui %l_GUI%:Add,Picture,%p_IconOptions%,%l_IconFile%
            GUIControlGet l_PictureControl,%l_GUI%:Pos,Static2
            }

        gui %l_GUI%:Destroy


        ;--------------------------
        ;-- Calculate window width
        ;--------------------------
        l_CMsgBoxW:=l_PictureControlW+l_TextControlW+(s_MarginX*3)
        if o_GroupBox is not Space
            l_CMsgBoxW:=l_CMsgBoxW+(s_MarginX*2)


        ;-- Adjust for borders (if any)
        if InStr(p_GUIOptions,"-Caption")
            {
            if InStr(p_GUIOptions,"+Border")
                ;-- Add width of simple window border
                l_CMsgBoxW:=l_CMsgBoxW+(SM_CXBORDER*2)
            }
         else
            ;-- Add width of standard borders for a fixed window
            l_CMsgBoxW:=l_CMsgBoxW+(SM_CXFIXEDFRAME*2)



        ;-- Calculate maximum window/text width
        l_MaxCMsgBoxW:=Round(l_MonitorWorkAreaRight*(s_MaxWindowPct/100))
        

        ;--------------------
        ;-- Window too wide?
        ;--------------------
        if (l_CMsgBoxW>l_MaxCMsgBoxW)
            {
            ;-- Calculate max Text control width
            l_MaxTextControlW:=l_TextControlW-(l_CMsgBoxW-l_MaxCMsgBoxW)

            ;-- Set window size to max by adding "width" option to p_TextOptions
            p_TextOptions:=p_TextOptions . " w" . l_MaxTextControlW
            }
         else
            {
            ;----------------------------
            ;-- Text control too narrow?
            ;----------------------------
            ;-- MinTextW option?
            if o_MinTextW
                {
                ;-- Width of Text control less than MinTextW?
                if (l_TextControlW<o_MinTextW)
                    {
                    ;-- Calculate the maximum width of the Text control
                    l_MaxTextControlW:=l_TextControlW+(l_MaxCMsgBoxW-l_CMsgBoxW)


                    ;-- Set o_MinTextW to the lesser of o_MinTextW and l_MaxTextControlW
                    if (o_MinTextW<l_MaxTextControlW)
                        p_TextOptions:=p_TextOptions . " w" . o_MinTextW
                     else
                        p_TextOptions:=p_TextOptions . " w" . l_MaxTextControlW
                    }
                }
            }
        }


    ;[==========]
    ;[  Height  ]
    ;[==========]
    ;-- MinTextH option?
    if o_MinTextH 
        {
        ;-- Height for the Text control already fixed?
        if InStr(A_Space . p_TextOptions," h")=0
       and InStr(A_Space . p_TextOptions," r")=0
            {
            ;--------------------
            ;-- Determine height
            ;--------------------
            ;-- Actual height not already known?
            if (l_TextControlH=0 or InStr(A_Space . p_TextOptions," w"))
                {
                ;-- OK, I don't know the actual height but is the incomplete
                ;-- height value less than o_MinTextH?
                if (l_TextControlH<o_MinTextH)
                    {
                    ;-- Create temporary window with a dummy text object to
                    ;   determine the actual height
                    if (p_TextFont or p_TextFontOptions)
                        gui %l_GUI%:Font,%p_TextFontOptions%,%p_TextFont%
                    gui %l_GUI%:Add,Text,%p_TextOptions%,%p_Text%
                    GUIControlGet l_TextControl,%l_GUI%:Pos,Static1
                    gui %l_GUI%:Destroy
                    }
                }


            ;-----------------------
            ;-- Set minimum height?
            ;-----------------------
            if (l_TextControlH<o_MinTextH)
                p_TextOptions:=p_TextOptions . " h" . o_MinTextH
            }
        }


    ;*******************
    ;*                 *
    ;*    Build GUI    *
    ;*                 *
    ;*******************
    ;-- Owner?
    if p_Owner
        {
        gui %p_Owner%:+Disabled
        gui %l_GUI%:+Owner%p_Owner%
            ;-- These commands must be performed first and in this order.
        }

    ;[===============]
    ;[  GUI options  ]
    ;[===============]
    gui %l_GUI%:Margin,%s_MarginX%,%s_MarginY%
    gui %l_GUI%:+LabelCMsgBox_
            || %p_GUIOptions%
            || -MinimizeBox


    ;[====================]
    ;[  Background color  ]
    ;[====================]
    if p_BGColor is not Space
        gui %l_GUI%:Color,%p_BGColor%


    ;[============]
    ;[  GroupBox  ]
    ;[============]
    Static CMsgBox_GroupBox
    if o_GroupBox is not Space
        gui %l_GUI%:Add
           ,GroupBox
           ,+Wrap  ;+Border
                || vCMsgBox_GroupBox
           ,% (o_GroupBox=1 ? "" : o_GroupBox)


    ;[========]
    ;[  Icon  ]
    ;[========]
    Static CMsgBox_Icon
    if l_Icon
        {
        ;-- Icon options
        l_IconOptions:=p_IconOptions . A_Space . "Section"
        if o_GroupBox is not Space
            l_IconOptions:=l_IconOptions
                . " xp+" . s_MarginX
                . " yp+" . s_MarginY*2

        if l_Icon>1
            l_IconOptions:=l_IconOptions . A_Space . "Icon" . l_Icon


        ;-- Add it
        gui %l_GUI%:Add
           ,Picture
           ,%l_IconOptions%  ;+Border
                || vCMsgBox_Icon
           ,%l_IconFile%
        }


    ;[========]
    ;[  Text  ]
    ;[========]
    Static CMsgBox_Text

    ;-- Set Font/Font options
    if (p_TextFont or p_TextFontOptions)
        gui %l_GUI%:Font,%p_TextFontOptions%,%p_TextFont%


    ;-- Text options
    if l_Icon
        p_TextOptions:="x+" . s_MarginX . " yp " . p_TextOptions
     else
        if o_GroupBox is not Space
            p_TextOptions:="Section "
                . " xp+" . s_MarginX
                . " yp+" . s_MarginY*2
                . A_Space
                . p_TextOptions
        else
            p_TextOptions:="Section " . p_TextOptions


    ;-- Text control
    gui %l_GUI%:Add
       ,Text
       ,%p_TextOptions%  ;+Border
            || vCMsgBox_Text
            || gCMsgBox_DragAction
       ,%p_Text%


    ;-- Reset font/size to system default
    gui %l_GUI%:font


    ;[=================]
    ;[  Size GroupBox  ]
    ;[=================]
    l_YOption=
    if o_GroupBox is not Space
        {
        ;-- Get position/size of icon and text controls
        l_IconControlW=0
        l_IconControlH=0
        if l_Icon
            GUIControlGet l_IconControl,%l_GUI%:Pos,CMsgBox_Icon

        GUIControlGet l_TextControl,%l_GUI%:Pos,CMsgBox_Text
            
        
        ;--- Calculate GroupBox W/H
        l_GBControlW:=l_IconControlW+l_TextControlW+(s_MarginX*3)
        if (l_IconControlH>l_TextControlH)
            l_GBControlH:=l_IconControlH+(s_MarginY*4)
         else
            l_GBControlH:=l_TextControlH+(s_MarginY*4)


        ;-- Adjust GroupBox W/H
        GUIControl
            ,%l_GUI%:Move
            ,CMsgBox_GroupBox
            ,w%l_GBControlW% h%l_GBControlH%
        
        
        ;-- Get position/size of GroupBox
        GUIControlGet l_GBControl,Pos,GBControl
        
        l_YOption:="y" . l_GBControlH+(s_MarginY*2) . A_Space
        }


    ;[============]
    ;[  Checkbox  ]
    ;[============]
    Static CMsgBox_Checkbox1
          ,CMsgBox_Checkbox2
          ,CMsgBox_Checkbox3
          ,CMsgBox_Checkbox4
          ,CMsgBox_Checkbox5
          ,CMsgBox_Checkbox6
          ,CMsgBox_Checkbox7
          ,CMsgBox_Checkbox8
          ,CMsgBox_Checkbox9
                ;-- Note:  The total number of checkboxes is limited to the
                ;   number of static variables for the Checkbox controls.  If
                ;   more than 9 checkboxes are needed, simply add more static
                ;   variables --  CMsgBox_Checkbox10, CMsgBox_Checkbox11, etc.


    if o_CheckBox is not Space
        {
        loop parse,o_Checkbox,|,                
            gui %l_GUI%:Add
                ,Checkbox
                ,% (A_Index=1 ? "xm " . l_YOption : "y+5 ")
                 . (InStr(A_LoopField,"*") ? " Checked " : "")
                 . " vCMsgBox_Checkbox" . A_Index
                ,% RegExReplace(A_LoopField, "\*")

        ;-- Reset l_YOption
        l_YOption=
        }
     else
        {
        ;[=========]
        ;[  Radio  ]
        ;[=========]
        Static CMsgBox_Radio
        if o_Radio is not Space
            {
            loop parse,o_Radio,|,                
                gui %l_GUI%:Add
                    ,Radio
                    ,% (A_Index=1 ? "xm " . l_YOption : "y+5 ")
                    .  (InStr(A_LoopField,"*") ? " Checked " : "")
                    .  (A_Index=1 ? " vCMsgBox_Radio" : "")
                    ,% RegExReplace(A_LoopField, "\*")


            ;-- Reset l_YOption
            l_YOption=
            }
        }


    ;[===========]
    ;[  Buttons  ]
    ;[===========]
    ;-------------------------
    ;-- Set Font/Font options
    ;-------------------------
    if (p_ButtonFont or p_ButtonFontOptions)
        gui %l_GUI%:Font,%p_ButtonFontOptions%,%p_ButtonFont%


    Static CMsgBox_Button1
          ,CMsgBox_Button2
          ,CMsgBox_Button3
          ,CMsgBox_Button4
          ,CMsgBox_Button5
          ,CMsgBox_Button6
          ,CMsgBox_Button7
          ,CMsgBox_Button8
          ,CMsgBox_Button9
                ;-- Note:  Static variables are used instead of using the
                ;   button's ClassNN because other button-type objects 
                ;   (Checkbox and Radio) are conditionally included.
                ;   
                ;   If more than 9 buttons are needed, simply add more static
                ;   variables -- CMsgBox_Button10, CMsgBox_Button11, etc.


    ;------------------
    ;-- Create buttons
    ;------------------
    l_NbrOfButtons=0
    loop parse,p_Buttons,|
        {
        l_NbrOfButtons++

        ;-- Add button
        gui %l_GUI%:Add
            ,Button
            ,% (A_Index=1 ? "xm " . l_YOption : "x+" . s_ButtonSpacer . A_Space)
                . (InStr(A_LoopField,"*") ? "Default " : A_Space)
                . p_ButtonOptions
                . " vCMsgBox_Button" . A_Index
                . " gCMsgBox_Button"
            ,% RegExReplace(A_LoopField, "\*")


        ;-- Set focus if default
        if A_LoopField contains *
            GUIControl
                ,%l_GUI%:Focus
                ,CMsgBox_Button%A_Index%
        }


    ;-- Set font/size to system default
    gui %l_GUI%:font


    ;-- Render but don't display
    gui %l_GUI%:Show,AutoSize Hide,%p_Title%


    ;[===================]
    ;[  Arrange buttons  ]
    ;[===================]
    if p_Buttons is not Space
        {
        ;-- Get window width
        gui %l_GUI%:+LastFound
        WinGetPos,,,l_CMsgBoxW


        ;-- Adjust for borders (if any)
        if InStr(p_GUIOptions,"-Caption")
            {
            if InStr(p_GUIOptions,"+Border")
                ;-- Substract width of simple window border
                l_CMsgBoxW:=l_CMsgBoxW-(SM_CXBORDER*2)
            }
         else
            ;-- Substract width of standard borders for a fixed window
            l_CMsgBoxW:=l_CMsgBoxW-(SM_CXFIXEDFRAME*2)


        ;-- Calculate total button width
        l_TotalButtonWidth=0
        loop %l_NbrOfButtons%
            {
            GUIControlGet
                ,l_Button%A_Index%Control
                ,%l_GUI%:Pos
                ,CMsgBox_Button%A_Index%
    
    
            l_TotalButtonWidth:=l_TotalButtonWidth+l_Button%A_Index%ControlW
    
            if A_Index>1
                l_TotalButtonWidth:=l_TotalButtonWidth+s_ButtonSpacer
            }
    
    
        ;-- Adjust GroupBox width
        if o_GroupBox is not Space
            if (l_TotalButtonWidth>l_GBControlW)
                {
                l_GBControlW:=l_TotalButtonWidth
                GUIControl
                    ,%l_GUI%:Move
                    ,CMsgBox_GroupBox
                    ,w%l_GBControlW%
                }
    
    
        ;-- Calculate 1st button position
        if o_ButtonsLeft
            l_StartButtonPos:=s_MarginX
         else
            if o_ButtonsRight
                l_StartButtonPos:=l_CMsgBoxW-l_TotalButtonWidth-s_MarginX
             else
                l_StartButtonPos:=l_CMsgBoxW/2-(l_TotalButtonWidth/2)
    
    
        ;-- Move 'em
        l_ButtonPos=0
        loop %l_NbrOfButtons%
            {
            GUIControl
                ,%l_GUI%:MoveDraw
                ,CMsgBox_Button%A_Index%
                ,% "x" l_StartButtonPos+l_ButtonPos
    
            l_ButtonPos:=l_ButtonPos+l_Button%A_Index%ControlW+s_ButtonSpacer
            }
        }


    ;[====================]
    ;[  Collect GUI hWnd  ]
    ;[====================]
    gui %l_GUI%:+LastFound
    WinGet l_CMsgBox_hWnd,ID
    GroupAdd CMsgBox_Group,ahk_id %l_CMsgBox_hWnd%


    ;[=========================]
    ;[  Disable close button?  ]
    ;[=========================]
    if not o_Close
        CMsgBox_DisableCloseButton(l_CMsgBox_hWnd)



    ;*****************
    ;*               *
    ;*    Show it    *
    ;*               *
    ;*****************
    if p_OWner
        {
        ;-- Calculate X/Y and Show it
        CMsgBox_PopupXY(p_OWner,l_GUI,l_PosX,l_PosY)
        gui %l_GUI%:Show,x%l_PosX% y%l_PosY%
        }
     else
        gui %l_GUI%:Show   ;,,%p_Title%

    l_Showing:=true



    ;********************
    ;*                  *
    ;*    Play sound    *
    ;*                  *
    ;********************
    ;-- Sound enabled?
    if o_Sound
        {
        ;-- Custom sound file?
        if o_SoundFile is not Space
            l_SoundFile:=o_SoundFile

        ;-- Play it
        if l_SoundFile is not Space
            SoundPlay %l_SoundFile%  ;,wait
        }



    ;*****************
    ;*               *
    ;*    Timeout    *
    ;*               *
    ;*****************
    if o_Timeout is not Space
        SetTimer CMsgBox_Timeout,%o_Timeout%



    ;*****************************
    ;*                           *
    ;*    Wait for a response    *
    ;*                           *
    ;*****************************
    loop
        {
        sleep 50  ;-- Responsive to buttons and hotkeys
        if StrLen(l_Result)
            {
            ;[=============]
            ;[  Checkbox?  ]
            ;[=============]
            if o_CheckBox is not Space
                {
                l_ErrorLevel=

                gui %l_GUI%:Submit,NoHide
                loop parse,o_CheckBox,|
                    l_ErrorLevel:=l_ErrorLevel . CMsgBox_Checkbox%A_Index%
                }
             else
                {
                ;[==========]
                ;[  Radio?  ]
                ;[==========]
                if o_Radio is not Space
                    {
                    gui %l_GUI%:Submit,NoHide
                    l_ErrorLevel:=CMsgBox_Radio
                    }
                }

            break
            }


        ;[============]
        ;[  Command?  ]
        ;[============]
        if CMsgBox_Command=CopyTextToClipboard
            {
            if o_Copy
                {
                ;----------------
                ;-- Build report
                ;----------------
                t_Buttons:=p_Buttons
                StringReplace t_Buttons,t_Buttons,*,,All
                StringReplace t_Buttons,t_Buttons,&,,All
                StringReplace t_Buttons,t_Buttons,`n,,All
                StringReplace t_Buttons,t_Buttons,|,%A_Space% %A_Space%,All

                l_Report=
                    (ltrim
                     ---------------------------
                     %p_Title%
                     ---------------------------
                     %p_Text%
                     ---------------------------
                     %t_Buttons%
                     ---------------------------

                    )

                ;-- Convert for pasting
                StringReplace,l_Report,l_Report,`n,`r`n,All


                ;-- Save report to clipboard
                Clipboard:=l_Report                
                SoundPlay *-1  ;-- System default sound


                ;-- Housekeeping
                l_Report=
                }


            CMsgBox_Command:=""
            continue
            }
        }



    ;**********************
    ;*                    *
    ;*    Shut it down    *
    ;*                    *
    ;**********************
    ;-- Enable owner
    if p_Owner
        gui %p_Owner%:-Disabled
    

    ;-- Destroy window
    gui %l_GUI%:Destroy



    ;************************
    ;*                      *
    ;*    Set ErrorLevel    *
    ;*     Return result    *
    ;*                      *
    ;************************
    ErrorLevel:=l_ErrorLevel
    return l_Result





    ;*****************************
    ;*                           *
    ;*                           *
    ;*        Subroutines        *
    ;*         (CMsgBox)         *
    ;*                           *
    ;*                           *
    ;*****************************
    CMsgBox_DragAction:
    
    ;-- Drag it
    PostMessage 0xA1,2  ;-- Goyyah trick.  Only works if object type is "Text"
    return



    CMsgBox_Button:

    ;-- Window showing yet?
    if not l_Showing
        return


    ;-- Find selected button
    l_ButtonIndex:=SubStr(A_GUIControl,StrLen(A_GUIControl))
    loop parse,p_Buttons,|
        if (A_Index=l_ButtonIndex)
            ;-- Button label without extraneous chars ("*", "&", and "`n")
            l_Result:=RegExReplace(A_LoopField,"[*&\n]")

    return



    CMsgBox_Timeout:
    SetTimer CMsgBox_Timeout,Off
    l_Result:="_Timeout"
    return



    CMsgBox_Escape:

    ;-- Bounce if o_EscapeToClose is not enabled
    if not o_EscapeToClose
        return



    CMsgBox_Close:

    ;-- Bounce if Close is not enabled
    if not o_Close
        return


    ;[==========================]
    ;[  Determine return value  ]
    ;[==========================]
    ;-- No buttons?
    if p_Buttons is Space
        l_Result:="_Close"
     else
        if o_EnableCloseIfButton is not Space
            ;-- Button label without extraneous chars ("*", "&", and "`n")
            l_Result:=RegExReplace(o_EnableCloseIfButton,"[*&\n]")
         else
            if o_EnableCloseIfOneButton
                ;-- Button label without extraneous chars ("*", "&", and "`n")
                l_Result:=RegExReplace(p_Buttons,"[*&\n]")
             else
                l_Result:="_Close"


    ;-- Return to sender
    return
    }





;***************************
;*                         *
;*                         *
;*         Hotkeys         *
;*        (CMsgBox)        *
;*                         *
;*                         *
;***************************
;-- Begin #IfWinActive directive
#IfWinActive ahk_group CMsgBox_Group


;[==========]
;[  Ctrl+C  ]
;[==========]
;-- Note: Native is not used here to stop hotkey from generating a system beep.
^c::
CMsgBox_Command=CopyTextToClipboard
return



;-- End #IfWinActive directive
#IfWinActive




;***************************
;*                         *
;*                         *
;*        Functions        *
;*                         *
;*                         *
;***************************
; Function: DisableCloseButton
; Author: Skan
; Source: http://www.autohotkey.com/forum/viewtopic.php?p=62506#62506
;
;
; Synopsis
; --------
; This function is used disable the Close button on the title bar and remove
; the "Close" menu item from SysMenu.
;
; Important: This function does not disable the ALT+F4 option.  The user can
; use ALT+F4 to close the window/hide the window unless additional restrictions
; have been employed.
;
;-------------------------------------------------------------------------------
CMsgBox_DisableCloseButton(hWnd="") { 
 If hWnd= 
    hWnd:=WinExist("A") 
 hSysMenu:=DllCall("GetSystemMenu","Int",hWnd,"Int",FALSE) 
 nCnt:=DllCall("GetMenuItemCount","Int",hSysMenu) 
 DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-1,"Uint","0x400") 
 DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-2,"Uint","0x400") 
 DllCall("DrawMenuBar","Int",hWnd) 
Return "" 
}



;*****************
;*               *
;*    PopupXY    *
;*               *
;*****************
;
;
;   Description
;   ===========
;   When passed a parent and child window, this function calculates the center
;   position for the child window relative to the parent window.  If necessary,
;   the calculated window positions are adjusted so that the child window will
;   fit within the primary monitor work area.
;
;
;
;   Parameters
;   ==========
;
;       Parameter           Description
;       ---------           -----------
;       p_Parent            For the parent window, this parameter can contain
;                           either the GUI window number (from 1 to 99) or the
;                           window title. [Required]
;
;                           From the AHK documentation...
;                           The title or partial title of the window (the
;                           matching behavior is determined by
;                           SetTitleMatchMode). To use a window class, specify
;                           ahk_class ExactClassName (shown by Window Spy). To
;                           use a process identifier (PID), specify ahk_pid
;                           %VarContainingPID%. To use a window's unique
;                           ID number, specify ahk_id %VarContainingID%.
;
;
;       p_Child             For the child (pop-up) window, this parameter can
;                           contain either the GUI window number (from 1 to 99)
;                           or the window title. [Required]  See the 
;                           p_Parent description for more information.
;
;
;       p_ChildX            The calculated "X" position for the child window is
;                           returned in this variable. [Required]  This
;                           parameter must contain a variable name.
;
;
;       p_ChildY            The calculated "Y" position for the child window is
;                           returned in this variable. [Required]  This
;                           parameter must contain a variable name.
;
;
;
;   Return Codes
;   ============
;   The function does not return a value but the p_ChildX and p_ChildY variables
;   are updated to contain the calculated X/Y values.  If the parent or child
;   windows cannot be found, these variables are set to 0.
;
;   
;
;   Calls To Other Functions
;   ========================
;   (None)
;
;
;-------------------------------------------------------------------------------
CMsgBox_PopupXY(p_Parent,p_Child,ByRef p_ChildX,ByRef p_ChildY)
    {
    ;[===============]
    ;[  Environment  ]
    ;[===============]
    l_DetectHiddenWindows:=A_DetectHiddenWindows
    DetectHiddenWindows On
    SysGet l_MonitorWorkArea,MonitorWorkArea
    p_ChildX=0
    p_ChildY=0


    ;[=================]
    ;[  Parent window  ]
    ;[=================]
    ;-- If necessary, collect hWnd
    if p_Parent is Integer
        if p_Parent between 1 and 99
            {
            gui %p_Parent%:+LastFoundExist
            IfWinExist
                {
                gui %p_Parent%:+LastFound
                p_Parent:="ahk_id " . WinExist()
                }
            }

    ;-- Collect position/size
    WinGetPos l_ParentX,l_ParentY,l_ParentW,l_ParentH,%p_Parent%


    ;-- Anything found?
    if l_ParentX is Space
        return


    ;[================]
    ;[  Child window  ]
    ;[================]
    ;-- If necessary, collect hWnd
    if p_Child is Integer
        if p_Child between 1 and 99
            {
            gui %p_Child%:+LastFoundExist
            IfWinExist
                {
                gui %p_Child%:+LastFound
                p_Child:="ahk_id " . WinExist()
                }
            }


    ;-- Collect position/size
    WinGetPos,,,l_ChildW,l_ChildH,%p_Child%


    ;-- Anything found?
    if l_ChildW is Space
        return


    ;[=======================]
    ;[  Calculate child X/Y  ]
    ;[=======================]
    p_ChildX:=round(l_ParentX+((l_ParentW-l_ChildW)/2))
    p_ChildY:=round(l_ParentY+((l_ParentH-l_ChildH)/2))

    ;-- Adjust if necessary
    if (p_ChildX<l_MonitorWorkAreaLeft)
        p_ChildX:=l_MonitorWorkAreaLeft

    if (p_ChildY<l_MonitorWorkAreaTop)
        p_ChildY:=l_MonitorWorkAreaTop

    l_MaximumX:=l_MonitorWorkAreaRight-l_ChildW
    if (p_ChildX>l_MaximumX)
        p_ChildX:=l_MaximumX

    l_MaximumY:=l_MonitorWorkAreaBottom-l_ChildH
    if (p_ChildY>l_MaximumY)
        p_ChildY:=l_MaximumY


    ;[=====================]
    ;[  Reset environment  ]
    ;[=====================]
    DetectHiddenWindows %l_DetectHiddenWindows%


    ;[====================]
    ;[  Return to sender  ]
    ;[====================]
    return
    }

