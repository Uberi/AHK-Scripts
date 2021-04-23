import java.io.*;
import org.antlr.runtime.*;
import org.antlr.runtime.debug.DebugEventSocketProxy;


public class __Test__ {

    public static void main(String args[]) throws Exception {
        AutoHotkeyLexer lex = new AutoHotkeyLexer(new ANTLRFileStream("C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\output\\__Test___input.txt", "UTF8"));
        CommonTokenStream tokens = new CommonTokenStream(lex);

        AutoHotkeyParser g = new AutoHotkeyParser(tokens, 49100, null);
        try {
            g.start();
        } catch (RecognitionException e) {
            e.printStackTrace();
        }
    }
}