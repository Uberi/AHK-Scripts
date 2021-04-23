#NoEnv

class UnitTest
{
    Initialize()
    {
        global UnitTestTitle, UnitTestEntries
        Gui, UnitTest:Default
        Gui, Font, s16, Arial
        Gui, Add, Text, x0 y0 h30 vUnitTestTitle Center, Test Results:

        hImageList := IL_Create()
        IL_Add(hImageList,"shell32.dll",78) ;yellow triangle with exclamation mark
        IL_Add(hImageList,"shell32.dll",138) ;green circle with arrow facing right
        IL_Add(hImageList,"shell32.dll",135) ;two sheets of paper
        Gui, Font, s10
        Gui, Add, TreeView, x10 y30 vUnitTestEntries ImageList%hImageList%

        Gui, Font, s8
        Gui, Add, StatusBar
        Gui, +Resize +MinSize320x200
        Gui, Show, w500 h400, Unit Test
        Gui, +LastFound
        Return

        UnitTestGuiSize:
        Gui, UnitTest:Default
        GuiControl, Move, UnitTestTitle, w%A_GuiWidth%
        GuiControl, Move, UnitTestEntries, % "w" . (A_GuiWidth - 20) . " h" . (A_GuiHeight - 60)
        Gui, +LastFound
        WinSet, Redraw
        Return

        UnitTestGuiClose:
        ExitApp
    }

    Test(Tests,hNode = 0,State = "")
    {
        static TestPrefix := "Test_"
        static CategoryPrefix := "Category_"

        If !IsObject(State)
        {
            State := Object()
            State.Passed := 0
            State.Failed := 0
        }

        CurrentStatus := True
        For Key, Value In Tests
        {
            If IsFunc(Value)
            {
                If RegExMatch(Key,"iS)" . TestPrefix . "\K[\w_]+",TestName)
                {
                    ;run the test
                    Result := True
                    ;try TestResult := Value() ;wip
                    try TestResult := Object("Value",Value).Value()
                    catch e
                    {
                        CurrentStatus := False
                        Result := False
                        TestResult := e
                    }

                    ;update the interface
                    If Result ;test passed
                    {
                        State.Passed ++
                        hChildNode := TV_Add(TestName,hNode,"Icon2 Sort")
                    }
                    Else ;test failed
                    {
                        State.Failed ++
                        hChildNode := TV_Add(TestName,hNode,"Icon1 Sort")
                    }
                    If (TestResult != "") ;additional information
                        TV_Add(TestResult,hChildNode,"Icon3")

                    ;update the status bar
                    If State.Failed ;tests failed
                        SB_SetIcon("shell32.dll",78) ;yellow triangle with exclamation mark
                    Else ;all tests passed
                        SB_SetIcon("shell32.dll",138) ;green circle with arrow facing right
                    SB_SetText(State.Passed . " of " . (State.Passed + State.Failed) . " tests passed.")
                }
            }
            Else If IsObject(Value)
            {
                If RegExMatch(Key,"iS)" . CategoryPrefix . "\K[\w_]+",CategoryName)
                {
                    hChildNode := TV_Add(CategoryName,hNode,"Icon2 Expand Bold Sort")
                    If !UnitTest.Test(Value,hChildNode,State) ;test category
                    {
                        CurrentStatus := False
                        TV_Modify(hChildNode,"Icon1")
                    }
                }
            }
        }

        Return, CurrentStatus
    }
}