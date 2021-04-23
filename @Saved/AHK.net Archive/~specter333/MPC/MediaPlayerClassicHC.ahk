; Media Player Classic Home Cinema Function Library by Specter333
; http://www.autohotkey.com/forum/viewtopic.php?p=490310#490310
; A complete list of functions can be found at the bottom of the page.
; Use Send functions to control Media Player Classic Home Cinema 
; with out it being active.
; Home page, http://mpc-hc.sourceforge.net/
; If being used on a local machine this function responds faster than MPCHTTP


MediaPlayerClassicHC(msg) 
	{
	; For "msg" use a number from the list of commands at the bottom of the page.
	SendMessage,0x0111,msg,,,ahk_class MediaPlayerClassicW
	}
MediaPlayerClassicHC_Play()
	{
	SendMessage,0x0111,887,,,ahk_class MediaPlayerClassicW
	}
MediaPlayerClassicHC_Pause()
	{
	SendMessage,0x0111,888,,,ahk_class MediaPlayerClassicW
	}
MediaPlayerClassicHC_PlayPause()
	{
	SendMessage,0x0111,889,,,ahk_class MediaPlayerClassicW
	}
MediaPlayerClassicHC_Stop()
	{
	SendMessage,0x0111,890,,,ahk_class MediaPlayerClassicW
	}
MediaPlayerClassicHC_FullScreen()
	{
	SendMessage,0x0111,830,,,ahk_class MediaPlayerClassicW
	}
MediaPlayerClassicHC_JumpForward()
	{
	SendMessage,0x0111,902,,,ahk_class MediaPlayerClassicW
	}
MediaPlayerClassicHC_JumpBackward()
	{
	SendMessage,0x0111,901,,,ahk_class MediaPlayerClassicW
	}
MediaPlayerClassicHC_PlayFaster()
	{
	SendMessage,0x0111,895,,,ahk_class MediaPlayerClassicW
	}
MediaPlayerClassicHC_PlaySlower()
	{
	SendMessage,0x0111,894,,,ahk_class MediaPlayerClassicW
	}
MediaPlayerClassicHC_PlayNormal()
	{
	SendMessage,0x0111,896,,,ahk_class MediaPlayerClassicW
	}
MediaPlayerClassicHC_VolumeUp()
	{
	SendMessage,0x0111,907,,,ahk_class MediaPlayerClassicW
	}
MediaPlayerClassicHC_VolumeDown()
	{
	SendMessage,0x0111,908,,,ahk_class MediaPlayerClassicW
	}
MediaPlayerClassicHC_Mute()
	{
	SendMessage,0x0111,909,,,ahk_class MediaPlayerClassicW
	}
MediaPlayerClassicHC_RootMenu()
	{
	SendMessage,0x0111,923,,,ahk_class MediaPlayerClassicW
	}
MediaPlayerClassicHC_Exit()
	{
	SendMessage,0x0111,816,,,ahk_class MediaPlayerClassicW
	}

/*	
Use one of the numbers from the commands below with the MediaPlayerClassicHC(msg)
function to call commands not included in this library.  

Use only the number, example the Open File function = MediaPlayerClassicHC(800)

800 Open File
801 Open DVD
802 Open Device
805 Save As
806 Save Image
807 Save Image (auto)
809 Load Subtitle
810 Save Subtitle
804 Close
814 Properties
816 Exit
889 Play/Pause
887 Play
888 Pause
890 Stop
891 Framestep
892 Framestep back
893 Go To
895 Increase Rate
894 Decrease Rate
896 Reset Rate
905 Audio Delay +10ms
906 Audio Delay -10ms
900 Jump Forward (small)
899 Jump Backward (small)
902 Jump Forward (medium)
901 Jump Backward (medium)
904 Jump Forward (large)
903 Jump Backward (large)
898 Jump Forward (keyframe)
897 Jump Backward (keyframe)
921 Next
920 Previous
919 Next Playlist Item
918 Previous Playlist Item
817 Toggle Caption&Menu
818 Toggle Seeker
819 Toggle Controls
820 Toggle Information
821 Toggle Statistics
822 Toggle Status
823 Toggle Subresync Bar
824 Toggle Playlist Bar
825 Toggle Capture Bar
826 Toggle Shader Editor Bar
827 View Minimal
828 View Compact
829 View Normal
830 Fullscreen
831 Fullscreen (w/o res.change)
832 Zoom 50`%
833 Zoom 100`%
834 Zoom 200`%
967 Zoom Auto Fit
860 Next AR Preset
835 VidFrm Half
836 VidFrm Normal
837 VidFrm Double
838 VidFrm Stretch
839 VidFrm Inside
840 VidFrm Outside
884 Always On Top
861 PnS Reset
862 PnS Inc Size
864 PnS Inc Width
866 PnS Inc Height
863 PnS Dec Size
865 PnS Dec Width
867 PnS Dec Height
876 PnS Center
868 PnS Left
869 PnS Right
870 PnS Up
871 PnS Down
872 PnS Up/Left
873 PnS Up/Right
874 PnS Down/Left
875 PnS Down/Right
877 PnS Rotate X+
878 PnS Rotate X-
879 PnS Rotate Y+
880 PnS Rotate Y-
881 PnS Rotate Z+
882 PnS Rotate Z-
907 Volume Up
908 Volume Down
909 Volume Mute
969 Volume boost increase
970 Volume boost decrease
971 Volume boost Min
972 Volume boost Max
922 DVD Title Menu
923 DVD Root Menu
924 DVD Subtitle Menu
925 DVD Audio Menu
926 DVD Angle Menu
927 DVD Chapter Menu
928 DVD Menu Left
929 DVD Menu Right
930 DVD Menu Up
931 DVD Menu Down
932 DVD Menu Activate
933 DVD Menu Back
934 DVD Menu Leave
943 Boss key
948 Player Menu (short)
949 Player Menu (long)
950 Filters Menu
886 Options
951 Next Audio
952 Prev Audio
953 Next Subtitle
954 Prev Subtitle
955 On/Off Subtitle
2302 Reload Subtitles
956 Next Audio (OGM)
957 Prev Audio (OGM)
958 Next Subtitle (OGM)
959 Prev Subtitle (OGM)
960 Next Angle (DVD)
961 Prev Angle (DVD)
962 Next Audio (DVD)
963 Prev Audio (DVD)
964 Next Subtitle (DVD)
965 Prev Subtitle (DVD)
966 On/Off Subtitle (DVD)
32769 Tearing Test
32778 Remaining Time
32770 Toggle Pixel Shader
32779 Toggle Direct3D fullscreen
32780 Goto Prev Subtitle
32781 Goto Next Subtitle
32782 Shift Subtitle Left
32783 Shift Subtitle Right
32784 Display Stats
24000 Subtitle Delay -
24001 Subtitle Delay +
808 Save thumbnails
*/
