// $ANTLR 3.4 C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g 2012-05-26 23:04:59

import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

import org.antlr.runtime.tree.*;


@SuppressWarnings({"all", "warnings", "unchecked"})
public class AutoHotkeyParser extends Parser {
    public static final String[] tokenNames = new String[] {
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "AND", "ASSIGN", "BITWISE", "COMMENT", "COMPARE", "EXPONENT", "IDENTIFIER", "LINE_END", "NOT", "NUMBER", "OR", "PADDING", "PARAMETER", "SEPARATOR", "SHIFT", "STRING", "UNARY", "'%'", "'('", "')'", "'*'", "'**'", "'+'", "'++'", "'-'", "'--'", "'.'", "'/'", "'//'", "':'", "'::'", "'?'", "'~='"
    };

    public static final int EOF=-1;
    public static final int T__21=21;
    public static final int T__22=22;
    public static final int T__23=23;
    public static final int T__24=24;
    public static final int T__25=25;
    public static final int T__26=26;
    public static final int T__27=27;
    public static final int T__28=28;
    public static final int T__29=29;
    public static final int T__30=30;
    public static final int T__31=31;
    public static final int T__32=32;
    public static final int T__33=33;
    public static final int T__34=34;
    public static final int T__35=35;
    public static final int T__36=36;
    public static final int AND=4;
    public static final int ASSIGN=5;
    public static final int BITWISE=6;
    public static final int COMMENT=7;
    public static final int COMPARE=8;
    public static final int EXPONENT=9;
    public static final int IDENTIFIER=10;
    public static final int LINE_END=11;
    public static final int NOT=12;
    public static final int NUMBER=13;
    public static final int OR=14;
    public static final int PADDING=15;
    public static final int PARAMETER=16;
    public static final int SEPARATOR=17;
    public static final int SHIFT=18;
    public static final int STRING=19;
    public static final int UNARY=20;

    // delegates
    public Parser[] getDelegates() {
        return new Parser[] {};
    }

    // delegators


    public AutoHotkeyParser(TokenStream input) {
        this(input, new RecognizerSharedState());
    }
    public AutoHotkeyParser(TokenStream input, RecognizerSharedState state) {
        super(input, state);
    }

protected TreeAdaptor adaptor = new CommonTreeAdaptor();

public void setTreeAdaptor(TreeAdaptor adaptor) {
    this.adaptor = adaptor;
}
public TreeAdaptor getTreeAdaptor() {
    return adaptor;
}
    public String[] getTokenNames() { return AutoHotkeyParser.tokenNames; }
    public String getGrammarFileName() { return "C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g"; }


    public static class program_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "program"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:9:1: program : line ( ( LINE_END )+ line )* ;
    public final AutoHotkeyParser.program_return program() throws RecognitionException {
        AutoHotkeyParser.program_return retval = new AutoHotkeyParser.program_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token LINE_END2=null;
        AutoHotkeyParser.line_return line1 =null;

        AutoHotkeyParser.line_return line3 =null;


        Object LINE_END2_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:9:10: ( line ( ( LINE_END )+ line )* )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:9:12: line ( ( LINE_END )+ line )*
            {
            root_0 = (Object)adaptor.nil();


            pushFollow(FOLLOW_line_in_program25);
            line1=line();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, line1.getTree());

            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:9:17: ( ( LINE_END )+ line )*
            loop2:
            do {
                int alt2=2;
                int LA2_0 = input.LA(1);

                if ( (LA2_0==LINE_END) ) {
                    alt2=1;
                }


                switch (alt2) {
            	case 1 :
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:9:19: ( LINE_END )+ line
            	    {
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:9:19: ( LINE_END )+
            	    int cnt1=0;
            	    loop1:
            	    do {
            	        int alt1=2;
            	        int LA1_0 = input.LA(1);

            	        if ( (LA1_0==LINE_END) ) {
            	            alt1=1;
            	        }


            	        switch (alt1) {
            	    	case 1 :
            	    	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:9:19: LINE_END
            	    	    {
            	    	    LINE_END2=(Token)match(input,LINE_END,FOLLOW_LINE_END_in_program29); if (state.failed) return retval;
            	    	    if ( state.backtracking==0 ) {
            	    	    LINE_END2_tree = 
            	    	    (Object)adaptor.create(LINE_END2)
            	    	    ;
            	    	    adaptor.addChild(root_0, LINE_END2_tree);
            	    	    }

            	    	    }
            	    	    break;

            	    	default :
            	    	    if ( cnt1 >= 1 ) break loop1;
            	    	    if (state.backtracking>0) {state.failed=true; return retval;}
            	                EarlyExitException eee =
            	                    new EarlyExitException(1, input);
            	                throw eee;
            	        }
            	        cnt1++;
            	    } while (true);


            	    pushFollow(FOLLOW_line_in_program32);
            	    line3=line();

            	    state._fsp--;
            	    if (state.failed) return retval;
            	    if ( state.backtracking==0 ) adaptor.addChild(root_0, line3.getTree());

            	    }
            	    break;

            	default :
            	    break loop2;
                }
            } while (true);


            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "program"


    public static class line_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "line"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:11:1: line : ( ( hotkey )=> hotkey | ( command )=> command | expression );
    public final AutoHotkeyParser.line_return line() throws RecognitionException {
        AutoHotkeyParser.line_return retval = new AutoHotkeyParser.line_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        AutoHotkeyParser.hotkey_return hotkey4 =null;

        AutoHotkeyParser.command_return command5 =null;

        AutoHotkeyParser.expression_return expression6 =null;



        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:11:7: ( ( hotkey )=> hotkey | ( command )=> command | expression )
            int alt3=3;
            int LA3_0 = input.LA(1);

            if ( (LA3_0==34) && (synpred1_AutoHotkey())) {
                alt3=1;
            }
            else if ( (LA3_0==IDENTIFIER) ) {
                int LA3_2 = input.LA(2);

                if ( (synpred2_AutoHotkey()) ) {
                    alt3=2;
                }
                else if ( (true) ) {
                    alt3=3;
                }
                else {
                    if (state.backtracking>0) {state.failed=true; return retval;}
                    NoViableAltException nvae =
                        new NoViableAltException("", 3, 2, input);

                    throw nvae;

                }
            }
            else if ( ((LA3_0 >= NOT && LA3_0 <= NUMBER)||(LA3_0 >= STRING && LA3_0 <= 22)||LA3_0==27||LA3_0==29) ) {
                alt3=3;
            }
            else {
                if (state.backtracking>0) {state.failed=true; return retval;}
                NoViableAltException nvae =
                    new NoViableAltException("", 3, 0, input);

                throw nvae;

            }
            switch (alt3) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:11:9: ( hotkey )=> hotkey
                    {
                    root_0 = (Object)adaptor.nil();


                    pushFollow(FOLLOW_hotkey_in_line52);
                    hotkey4=hotkey();

                    state._fsp--;
                    if (state.failed) return retval;
                    if ( state.backtracking==0 ) adaptor.addChild(root_0, hotkey4.getTree());

                    }
                    break;
                case 2 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:12:5: ( command )=> command
                    {
                    root_0 = (Object)adaptor.nil();


                    pushFollow(FOLLOW_command_in_line66);
                    command5=command();

                    state._fsp--;
                    if (state.failed) return retval;
                    if ( state.backtracking==0 ) adaptor.addChild(root_0, command5.getTree());

                    }
                    break;
                case 3 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:13:5: expression
                    {
                    root_0 = (Object)adaptor.nil();


                    pushFollow(FOLLOW_expression_in_line72);
                    expression6=expression();

                    state._fsp--;
                    if (state.failed) return retval;
                    if ( state.backtracking==0 ) adaptor.addChild(root_0, expression6.getTree());

                    }
                    break;

            }
            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "line"


    public static class hotkey_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "hotkey"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:15:1: hotkey : '::' line ;
    public final AutoHotkeyParser.hotkey_return hotkey() throws RecognitionException {
        AutoHotkeyParser.hotkey_return retval = new AutoHotkeyParser.hotkey_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token string_literal7=null;
        AutoHotkeyParser.line_return line8 =null;


        Object string_literal7_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:15:9: ( '::' line )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:15:11: '::' line
            {
            root_0 = (Object)adaptor.nil();


            string_literal7=(Token)match(input,34,FOLLOW_34_in_hotkey81); if (state.failed) return retval;
            if ( state.backtracking==0 ) {
            string_literal7_tree = 
            (Object)adaptor.create(string_literal7)
            ;
            adaptor.addChild(root_0, string_literal7_tree);
            }

            pushFollow(FOLLOW_line_in_hotkey83);
            line8=line();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, line8.getTree());

            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "hotkey"


    public static class command_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "command"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:17:1: command : IDENTIFIER ( ( SEPARATOR !)? PARAMETER ( SEPARATOR ! PARAMETER )* )? ;
    public final AutoHotkeyParser.command_return command() throws RecognitionException {
        AutoHotkeyParser.command_return retval = new AutoHotkeyParser.command_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token IDENTIFIER9=null;
        Token SEPARATOR10=null;
        Token PARAMETER11=null;
        Token SEPARATOR12=null;
        Token PARAMETER13=null;

        Object IDENTIFIER9_tree=null;
        Object SEPARATOR10_tree=null;
        Object PARAMETER11_tree=null;
        Object SEPARATOR12_tree=null;
        Object PARAMETER13_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:17:10: ( IDENTIFIER ( ( SEPARATOR !)? PARAMETER ( SEPARATOR ! PARAMETER )* )? )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:17:12: IDENTIFIER ( ( SEPARATOR !)? PARAMETER ( SEPARATOR ! PARAMETER )* )?
            {
            root_0 = (Object)adaptor.nil();


            IDENTIFIER9=(Token)match(input,IDENTIFIER,FOLLOW_IDENTIFIER_in_command93); if (state.failed) return retval;
            if ( state.backtracking==0 ) {
            IDENTIFIER9_tree = 
            (Object)adaptor.create(IDENTIFIER9)
            ;
            adaptor.addChild(root_0, IDENTIFIER9_tree);
            }

            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:17:23: ( ( SEPARATOR !)? PARAMETER ( SEPARATOR ! PARAMETER )* )?
            int alt6=2;
            int LA6_0 = input.LA(1);

            if ( ((LA6_0 >= PARAMETER && LA6_0 <= SEPARATOR)) ) {
                alt6=1;
            }
            switch (alt6) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:17:25: ( SEPARATOR !)? PARAMETER ( SEPARATOR ! PARAMETER )*
                    {
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:17:34: ( SEPARATOR !)?
                    int alt4=2;
                    int LA4_0 = input.LA(1);

                    if ( (LA4_0==SEPARATOR) ) {
                        alt4=1;
                    }
                    switch (alt4) {
                        case 1 :
                            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:17:34: SEPARATOR !
                            {
                            SEPARATOR10=(Token)match(input,SEPARATOR,FOLLOW_SEPARATOR_in_command97); if (state.failed) return retval;

                            }
                            break;

                    }


                    PARAMETER11=(Token)match(input,PARAMETER,FOLLOW_PARAMETER_in_command101); if (state.failed) return retval;
                    if ( state.backtracking==0 ) {
                    PARAMETER11_tree = 
                    (Object)adaptor.create(PARAMETER11)
                    ;
                    adaptor.addChild(root_0, PARAMETER11_tree);
                    }

                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:17:47: ( SEPARATOR ! PARAMETER )*
                    loop5:
                    do {
                        int alt5=2;
                        int LA5_0 = input.LA(1);

                        if ( (LA5_0==SEPARATOR) ) {
                            alt5=1;
                        }


                        switch (alt5) {
                    	case 1 :
                    	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:17:49: SEPARATOR ! PARAMETER
                    	    {
                    	    SEPARATOR12=(Token)match(input,SEPARATOR,FOLLOW_SEPARATOR_in_command105); if (state.failed) return retval;

                    	    PARAMETER13=(Token)match(input,PARAMETER,FOLLOW_PARAMETER_in_command108); if (state.failed) return retval;
                    	    if ( state.backtracking==0 ) {
                    	    PARAMETER13_tree = 
                    	    (Object)adaptor.create(PARAMETER13)
                    	    ;
                    	    adaptor.addChild(root_0, PARAMETER13_tree);
                    	    }

                    	    }
                    	    break;

                    	default :
                    	    break loop5;
                        }
                    } while (true);


                    }
                    break;

            }


            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "command"


    public static class start_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "start"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:19:1: start : expression ;
    public final AutoHotkeyParser.start_return start() throws RecognitionException {
        AutoHotkeyParser.start_return retval = new AutoHotkeyParser.start_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        AutoHotkeyParser.expression_return expression14 =null;



        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:19:8: ( expression )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:19:10: expression
            {
            root_0 = (Object)adaptor.nil();


            pushFollow(FOLLOW_expression_in_start123);
            expression14=expression();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, expression14.getTree());

            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "start"


    public static class expression_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "expression"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:21:1: expression : assignment ( SEPARATOR ! assignment )* ;
    public final AutoHotkeyParser.expression_return expression() throws RecognitionException {
        AutoHotkeyParser.expression_return retval = new AutoHotkeyParser.expression_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token SEPARATOR16=null;
        AutoHotkeyParser.assignment_return assignment15 =null;

        AutoHotkeyParser.assignment_return assignment17 =null;


        Object SEPARATOR16_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:21:12: ( assignment ( SEPARATOR ! assignment )* )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:21:14: assignment ( SEPARATOR ! assignment )*
            {
            root_0 = (Object)adaptor.nil();


            pushFollow(FOLLOW_assignment_in_expression132);
            assignment15=assignment();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, assignment15.getTree());

            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:21:25: ( SEPARATOR ! assignment )*
            loop7:
            do {
                int alt7=2;
                int LA7_0 = input.LA(1);

                if ( (LA7_0==SEPARATOR) ) {
                    alt7=1;
                }


                switch (alt7) {
            	case 1 :
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:21:27: SEPARATOR ! assignment
            	    {
            	    SEPARATOR16=(Token)match(input,SEPARATOR,FOLLOW_SEPARATOR_in_expression136); if (state.failed) return retval;

            	    pushFollow(FOLLOW_assignment_in_expression139);
            	    assignment17=assignment();

            	    state._fsp--;
            	    if (state.failed) return retval;
            	    if ( state.backtracking==0 ) adaptor.addChild(root_0, assignment17.getTree());

            	    }
            	    break;

            	default :
            	    break loop7;
                }
            } while (true);


            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "expression"


    public static class assignment_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "assignment"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:23:1: assignment : ( ( ( access ASSIGN assignment )=> access ASSIGN ^ assignment ) | ternary );
    public final AutoHotkeyParser.assignment_return assignment() throws RecognitionException {
        AutoHotkeyParser.assignment_return retval = new AutoHotkeyParser.assignment_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token ASSIGN19=null;
        AutoHotkeyParser.access_return access18 =null;

        AutoHotkeyParser.assignment_return assignment20 =null;

        AutoHotkeyParser.ternary_return ternary21 =null;


        Object ASSIGN19_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:23:12: ( ( ( access ASSIGN assignment )=> access ASSIGN ^ assignment ) | ternary )
            int alt8=2;
            switch ( input.LA(1) ) {
            case 21:
                {
                int LA8_1 = input.LA(2);

                if ( (synpred3_AutoHotkey()) ) {
                    alt8=1;
                }
                else if ( (true) ) {
                    alt8=2;
                }
                else {
                    if (state.backtracking>0) {state.failed=true; return retval;}
                    NoViableAltException nvae =
                        new NoViableAltException("", 8, 1, input);

                    throw nvae;

                }
                }
                break;
            case NUMBER:
                {
                int LA8_2 = input.LA(2);

                if ( (synpred3_AutoHotkey()) ) {
                    alt8=1;
                }
                else if ( (true) ) {
                    alt8=2;
                }
                else {
                    if (state.backtracking>0) {state.failed=true; return retval;}
                    NoViableAltException nvae =
                        new NoViableAltException("", 8, 2, input);

                    throw nvae;

                }
                }
                break;
            case STRING:
                {
                int LA8_3 = input.LA(2);

                if ( (synpred3_AutoHotkey()) ) {
                    alt8=1;
                }
                else if ( (true) ) {
                    alt8=2;
                }
                else {
                    if (state.backtracking>0) {state.failed=true; return retval;}
                    NoViableAltException nvae =
                        new NoViableAltException("", 8, 3, input);

                    throw nvae;

                }
                }
                break;
            case IDENTIFIER:
                {
                int LA8_4 = input.LA(2);

                if ( (synpred3_AutoHotkey()) ) {
                    alt8=1;
                }
                else if ( (true) ) {
                    alt8=2;
                }
                else {
                    if (state.backtracking>0) {state.failed=true; return retval;}
                    NoViableAltException nvae =
                        new NoViableAltException("", 8, 4, input);

                    throw nvae;

                }
                }
                break;
            case 22:
                {
                int LA8_5 = input.LA(2);

                if ( (synpred3_AutoHotkey()) ) {
                    alt8=1;
                }
                else if ( (true) ) {
                    alt8=2;
                }
                else {
                    if (state.backtracking>0) {state.failed=true; return retval;}
                    NoViableAltException nvae =
                        new NoViableAltException("", 8, 5, input);

                    throw nvae;

                }
                }
                break;
            case NOT:
            case UNARY:
            case 27:
            case 29:
                {
                alt8=2;
                }
                break;
            default:
                if (state.backtracking>0) {state.failed=true; return retval;}
                NoViableAltException nvae =
                    new NoViableAltException("", 8, 0, input);

                throw nvae;

            }

            switch (alt8) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:23:14: ( ( access ASSIGN assignment )=> access ASSIGN ^ assignment )
                    {
                    root_0 = (Object)adaptor.nil();


                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:23:14: ( ( access ASSIGN assignment )=> access ASSIGN ^ assignment )
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:23:16: ( access ASSIGN assignment )=> access ASSIGN ^ assignment
                    {
                    pushFollow(FOLLOW_access_in_assignment164);
                    access18=access();

                    state._fsp--;
                    if (state.failed) return retval;
                    if ( state.backtracking==0 ) adaptor.addChild(root_0, access18.getTree());

                    ASSIGN19=(Token)match(input,ASSIGN,FOLLOW_ASSIGN_in_assignment166); if (state.failed) return retval;
                    if ( state.backtracking==0 ) {
                    ASSIGN19_tree = 
                    (Object)adaptor.create(ASSIGN19)
                    ;
                    root_0 = (Object)adaptor.becomeRoot(ASSIGN19_tree, root_0);
                    }

                    pushFollow(FOLLOW_assignment_in_assignment169);
                    assignment20=assignment();

                    state._fsp--;
                    if (state.failed) return retval;
                    if ( state.backtracking==0 ) adaptor.addChild(root_0, assignment20.getTree());

                    }


                    }
                    break;
                case 2 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:24:5: ternary
                    {
                    root_0 = (Object)adaptor.nil();


                    pushFollow(FOLLOW_ternary_in_assignment176);
                    ternary21=ternary();

                    state._fsp--;
                    if (state.failed) return retval;
                    if ( state.backtracking==0 ) adaptor.addChild(root_0, ternary21.getTree());

                    }
                    break;

            }
            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "assignment"


    public static class ternary_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "ternary"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:26:1: ternary : or ( '?' ^ ternary ':' ! ternary )? ;
    public final AutoHotkeyParser.ternary_return ternary() throws RecognitionException {
        AutoHotkeyParser.ternary_return retval = new AutoHotkeyParser.ternary_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token char_literal23=null;
        Token char_literal25=null;
        AutoHotkeyParser.or_return or22 =null;

        AutoHotkeyParser.ternary_return ternary24 =null;

        AutoHotkeyParser.ternary_return ternary26 =null;


        Object char_literal23_tree=null;
        Object char_literal25_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:26:10: ( or ( '?' ^ ternary ':' ! ternary )? )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:26:12: or ( '?' ^ ternary ':' ! ternary )?
            {
            root_0 = (Object)adaptor.nil();


            pushFollow(FOLLOW_or_in_ternary185);
            or22=or();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, or22.getTree());

            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:26:15: ( '?' ^ ternary ':' ! ternary )?
            int alt9=2;
            int LA9_0 = input.LA(1);

            if ( (LA9_0==35) ) {
                alt9=1;
            }
            switch (alt9) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:26:17: '?' ^ ternary ':' ! ternary
                    {
                    char_literal23=(Token)match(input,35,FOLLOW_35_in_ternary189); if (state.failed) return retval;
                    if ( state.backtracking==0 ) {
                    char_literal23_tree = 
                    (Object)adaptor.create(char_literal23)
                    ;
                    root_0 = (Object)adaptor.becomeRoot(char_literal23_tree, root_0);
                    }

                    pushFollow(FOLLOW_ternary_in_ternary192);
                    ternary24=ternary();

                    state._fsp--;
                    if (state.failed) return retval;
                    if ( state.backtracking==0 ) adaptor.addChild(root_0, ternary24.getTree());

                    char_literal25=(Token)match(input,33,FOLLOW_33_in_ternary194); if (state.failed) return retval;

                    pushFollow(FOLLOW_ternary_in_ternary197);
                    ternary26=ternary();

                    state._fsp--;
                    if (state.failed) return retval;
                    if ( state.backtracking==0 ) adaptor.addChild(root_0, ternary26.getTree());

                    }
                    break;

            }


            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "ternary"


    public static class or_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "or"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:28:1: or : and ( OR ^ and )* ;
    public final AutoHotkeyParser.or_return or() throws RecognitionException {
        AutoHotkeyParser.or_return retval = new AutoHotkeyParser.or_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token OR28=null;
        AutoHotkeyParser.and_return and27 =null;

        AutoHotkeyParser.and_return and29 =null;


        Object OR28_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:28:5: ( and ( OR ^ and )* )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:28:7: and ( OR ^ and )*
            {
            root_0 = (Object)adaptor.nil();


            pushFollow(FOLLOW_and_in_or209);
            and27=and();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, and27.getTree());

            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:28:11: ( OR ^ and )*
            loop10:
            do {
                int alt10=2;
                int LA10_0 = input.LA(1);

                if ( (LA10_0==OR) ) {
                    alt10=1;
                }


                switch (alt10) {
            	case 1 :
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:28:13: OR ^ and
            	    {
            	    OR28=(Token)match(input,OR,FOLLOW_OR_in_or213); if (state.failed) return retval;
            	    if ( state.backtracking==0 ) {
            	    OR28_tree = 
            	    (Object)adaptor.create(OR28)
            	    ;
            	    root_0 = (Object)adaptor.becomeRoot(OR28_tree, root_0);
            	    }

            	    pushFollow(FOLLOW_and_in_or216);
            	    and29=and();

            	    state._fsp--;
            	    if (state.failed) return retval;
            	    if ( state.backtracking==0 ) adaptor.addChild(root_0, and29.getTree());

            	    }
            	    break;

            	default :
            	    break loop10;
                }
            } while (true);


            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "or"


    public static class and_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "and"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:30:1: and : not ( AND ^ not )* ;
    public final AutoHotkeyParser.and_return and() throws RecognitionException {
        AutoHotkeyParser.and_return retval = new AutoHotkeyParser.and_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token AND31=null;
        AutoHotkeyParser.not_return not30 =null;

        AutoHotkeyParser.not_return not32 =null;


        Object AND31_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:30:6: ( not ( AND ^ not )* )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:30:8: not ( AND ^ not )*
            {
            root_0 = (Object)adaptor.nil();


            pushFollow(FOLLOW_not_in_and228);
            not30=not();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, not30.getTree());

            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:30:12: ( AND ^ not )*
            loop11:
            do {
                int alt11=2;
                int LA11_0 = input.LA(1);

                if ( (LA11_0==AND) ) {
                    alt11=1;
                }


                switch (alt11) {
            	case 1 :
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:30:14: AND ^ not
            	    {
            	    AND31=(Token)match(input,AND,FOLLOW_AND_in_and232); if (state.failed) return retval;
            	    if ( state.backtracking==0 ) {
            	    AND31_tree = 
            	    (Object)adaptor.create(AND31)
            	    ;
            	    root_0 = (Object)adaptor.becomeRoot(AND31_tree, root_0);
            	    }

            	    pushFollow(FOLLOW_not_in_and235);
            	    not32=not();

            	    state._fsp--;
            	    if (state.failed) return retval;
            	    if ( state.backtracking==0 ) adaptor.addChild(root_0, not32.getTree());

            	    }
            	    break;

            	default :
            	    break loop11;
                }
            } while (true);


            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "and"


    public static class not_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "not"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:32:1: not : ( NOT ^)? comparison ;
    public final AutoHotkeyParser.not_return not() throws RecognitionException {
        AutoHotkeyParser.not_return retval = new AutoHotkeyParser.not_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token NOT33=null;
        AutoHotkeyParser.comparison_return comparison34 =null;


        Object NOT33_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:32:6: ( ( NOT ^)? comparison )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:32:8: ( NOT ^)? comparison
            {
            root_0 = (Object)adaptor.nil();


            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:32:11: ( NOT ^)?
            int alt12=2;
            int LA12_0 = input.LA(1);

            if ( (LA12_0==NOT) ) {
                alt12=1;
            }
            switch (alt12) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:32:11: NOT ^
                    {
                    NOT33=(Token)match(input,NOT,FOLLOW_NOT_in_not247); if (state.failed) return retval;
                    if ( state.backtracking==0 ) {
                    NOT33_tree = 
                    (Object)adaptor.create(NOT33)
                    ;
                    root_0 = (Object)adaptor.becomeRoot(NOT33_tree, root_0);
                    }

                    }
                    break;

            }


            pushFollow(FOLLOW_comparison_in_not251);
            comparison34=comparison();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, comparison34.getTree());

            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "not"


    public static class comparison_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "comparison"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:34:1: comparison : regex ( COMPARE ^ regex )* ;
    public final AutoHotkeyParser.comparison_return comparison() throws RecognitionException {
        AutoHotkeyParser.comparison_return retval = new AutoHotkeyParser.comparison_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token COMPARE36=null;
        AutoHotkeyParser.regex_return regex35 =null;

        AutoHotkeyParser.regex_return regex37 =null;


        Object COMPARE36_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:34:12: ( regex ( COMPARE ^ regex )* )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:34:14: regex ( COMPARE ^ regex )*
            {
            root_0 = (Object)adaptor.nil();


            pushFollow(FOLLOW_regex_in_comparison259);
            regex35=regex();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, regex35.getTree());

            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:34:20: ( COMPARE ^ regex )*
            loop13:
            do {
                int alt13=2;
                int LA13_0 = input.LA(1);

                if ( (LA13_0==COMPARE) ) {
                    alt13=1;
                }


                switch (alt13) {
            	case 1 :
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:34:22: COMPARE ^ regex
            	    {
            	    COMPARE36=(Token)match(input,COMPARE,FOLLOW_COMPARE_in_comparison263); if (state.failed) return retval;
            	    if ( state.backtracking==0 ) {
            	    COMPARE36_tree = 
            	    (Object)adaptor.create(COMPARE36)
            	    ;
            	    root_0 = (Object)adaptor.becomeRoot(COMPARE36_tree, root_0);
            	    }

            	    pushFollow(FOLLOW_regex_in_comparison266);
            	    regex37=regex();

            	    state._fsp--;
            	    if (state.failed) return retval;
            	    if ( state.backtracking==0 ) adaptor.addChild(root_0, regex37.getTree());

            	    }
            	    break;

            	default :
            	    break loop13;
                }
            } while (true);


            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "comparison"


    public static class regex_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "regex"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:36:1: regex : concatenation ( '~=' ^ concatenation )* ;
    public final AutoHotkeyParser.regex_return regex() throws RecognitionException {
        AutoHotkeyParser.regex_return retval = new AutoHotkeyParser.regex_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token string_literal39=null;
        AutoHotkeyParser.concatenation_return concatenation38 =null;

        AutoHotkeyParser.concatenation_return concatenation40 =null;


        Object string_literal39_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:36:8: ( concatenation ( '~=' ^ concatenation )* )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:36:10: concatenation ( '~=' ^ concatenation )*
            {
            root_0 = (Object)adaptor.nil();


            pushFollow(FOLLOW_concatenation_in_regex278);
            concatenation38=concatenation();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, concatenation38.getTree());

            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:36:24: ( '~=' ^ concatenation )*
            loop14:
            do {
                int alt14=2;
                int LA14_0 = input.LA(1);

                if ( (LA14_0==36) ) {
                    alt14=1;
                }


                switch (alt14) {
            	case 1 :
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:36:26: '~=' ^ concatenation
            	    {
            	    string_literal39=(Token)match(input,36,FOLLOW_36_in_regex282); if (state.failed) return retval;
            	    if ( state.backtracking==0 ) {
            	    string_literal39_tree = 
            	    (Object)adaptor.create(string_literal39)
            	    ;
            	    root_0 = (Object)adaptor.becomeRoot(string_literal39_tree, root_0);
            	    }

            	    pushFollow(FOLLOW_concatenation_in_regex285);
            	    concatenation40=concatenation();

            	    state._fsp--;
            	    if (state.failed) return retval;
            	    if ( state.backtracking==0 ) adaptor.addChild(root_0, concatenation40.getTree());

            	    }
            	    break;

            	default :
            	    break loop14;
                }
            } while (true);


            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "regex"


    public static class concatenation_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "concatenation"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:38:1: concatenation : bitwise ( PADDING ! '.' ^ PADDING ! bitwise )* ;
    public final AutoHotkeyParser.concatenation_return concatenation() throws RecognitionException {
        AutoHotkeyParser.concatenation_return retval = new AutoHotkeyParser.concatenation_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token PADDING42=null;
        Token char_literal43=null;
        Token PADDING44=null;
        AutoHotkeyParser.bitwise_return bitwise41 =null;

        AutoHotkeyParser.bitwise_return bitwise45 =null;


        Object PADDING42_tree=null;
        Object char_literal43_tree=null;
        Object PADDING44_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:38:15: ( bitwise ( PADDING ! '.' ^ PADDING ! bitwise )* )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:38:17: bitwise ( PADDING ! '.' ^ PADDING ! bitwise )*
            {
            root_0 = (Object)adaptor.nil();


            pushFollow(FOLLOW_bitwise_in_concatenation296);
            bitwise41=bitwise();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, bitwise41.getTree());

            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:38:25: ( PADDING ! '.' ^ PADDING ! bitwise )*
            loop15:
            do {
                int alt15=2;
                int LA15_0 = input.LA(1);

                if ( (LA15_0==PADDING) ) {
                    alt15=1;
                }


                switch (alt15) {
            	case 1 :
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:38:27: PADDING ! '.' ^ PADDING ! bitwise
            	    {
            	    PADDING42=(Token)match(input,PADDING,FOLLOW_PADDING_in_concatenation300); if (state.failed) return retval;

            	    char_literal43=(Token)match(input,30,FOLLOW_30_in_concatenation303); if (state.failed) return retval;
            	    if ( state.backtracking==0 ) {
            	    char_literal43_tree = 
            	    (Object)adaptor.create(char_literal43)
            	    ;
            	    root_0 = (Object)adaptor.becomeRoot(char_literal43_tree, root_0);
            	    }

            	    PADDING44=(Token)match(input,PADDING,FOLLOW_PADDING_in_concatenation306); if (state.failed) return retval;

            	    pushFollow(FOLLOW_bitwise_in_concatenation309);
            	    bitwise45=bitwise();

            	    state._fsp--;
            	    if (state.failed) return retval;
            	    if ( state.backtracking==0 ) adaptor.addChild(root_0, bitwise45.getTree());

            	    }
            	    break;

            	default :
            	    break loop15;
                }
            } while (true);


            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "concatenation"


    public static class bitwise_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "bitwise"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:40:1: bitwise : shift ( BITWISE ^ shift )* ;
    public final AutoHotkeyParser.bitwise_return bitwise() throws RecognitionException {
        AutoHotkeyParser.bitwise_return retval = new AutoHotkeyParser.bitwise_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token BITWISE47=null;
        AutoHotkeyParser.shift_return shift46 =null;

        AutoHotkeyParser.shift_return shift48 =null;


        Object BITWISE47_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:40:10: ( shift ( BITWISE ^ shift )* )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:40:12: shift ( BITWISE ^ shift )*
            {
            root_0 = (Object)adaptor.nil();


            pushFollow(FOLLOW_shift_in_bitwise322);
            shift46=shift();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, shift46.getTree());

            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:40:18: ( BITWISE ^ shift )*
            loop16:
            do {
                int alt16=2;
                int LA16_0 = input.LA(1);

                if ( (LA16_0==BITWISE) ) {
                    alt16=1;
                }


                switch (alt16) {
            	case 1 :
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:40:20: BITWISE ^ shift
            	    {
            	    BITWISE47=(Token)match(input,BITWISE,FOLLOW_BITWISE_in_bitwise326); if (state.failed) return retval;
            	    if ( state.backtracking==0 ) {
            	    BITWISE47_tree = 
            	    (Object)adaptor.create(BITWISE47)
            	    ;
            	    root_0 = (Object)adaptor.becomeRoot(BITWISE47_tree, root_0);
            	    }

            	    pushFollow(FOLLOW_shift_in_bitwise329);
            	    shift48=shift();

            	    state._fsp--;
            	    if (state.failed) return retval;
            	    if ( state.backtracking==0 ) adaptor.addChild(root_0, shift48.getTree());

            	    }
            	    break;

            	default :
            	    break loop16;
                }
            } while (true);


            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "bitwise"


    public static class shift_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "shift"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:42:1: shift : addition ( SHIFT ^ addition )* ;
    public final AutoHotkeyParser.shift_return shift() throws RecognitionException {
        AutoHotkeyParser.shift_return retval = new AutoHotkeyParser.shift_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token SHIFT50=null;
        AutoHotkeyParser.addition_return addition49 =null;

        AutoHotkeyParser.addition_return addition51 =null;


        Object SHIFT50_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:42:8: ( addition ( SHIFT ^ addition )* )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:42:10: addition ( SHIFT ^ addition )*
            {
            root_0 = (Object)adaptor.nil();


            pushFollow(FOLLOW_addition_in_shift342);
            addition49=addition();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, addition49.getTree());

            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:42:19: ( SHIFT ^ addition )*
            loop17:
            do {
                int alt17=2;
                int LA17_0 = input.LA(1);

                if ( (LA17_0==SHIFT) ) {
                    alt17=1;
                }


                switch (alt17) {
            	case 1 :
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:42:21: SHIFT ^ addition
            	    {
            	    SHIFT50=(Token)match(input,SHIFT,FOLLOW_SHIFT_in_shift346); if (state.failed) return retval;
            	    if ( state.backtracking==0 ) {
            	    SHIFT50_tree = 
            	    (Object)adaptor.create(SHIFT50)
            	    ;
            	    root_0 = (Object)adaptor.becomeRoot(SHIFT50_tree, root_0);
            	    }

            	    pushFollow(FOLLOW_addition_in_shift349);
            	    addition51=addition();

            	    state._fsp--;
            	    if (state.failed) return retval;
            	    if ( state.backtracking==0 ) adaptor.addChild(root_0, addition51.getTree());

            	    }
            	    break;

            	default :
            	    break loop17;
                }
            } while (true);


            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "shift"


    public static class addition_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "addition"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:44:1: addition : multiplication ( ( '+' | '-' ) ^ multiplication )* ;
    public final AutoHotkeyParser.addition_return addition() throws RecognitionException {
        AutoHotkeyParser.addition_return retval = new AutoHotkeyParser.addition_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token set53=null;
        AutoHotkeyParser.multiplication_return multiplication52 =null;

        AutoHotkeyParser.multiplication_return multiplication54 =null;


        Object set53_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:44:10: ( multiplication ( ( '+' | '-' ) ^ multiplication )* )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:44:12: multiplication ( ( '+' | '-' ) ^ multiplication )*
            {
            root_0 = (Object)adaptor.nil();


            pushFollow(FOLLOW_multiplication_in_addition360);
            multiplication52=multiplication();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, multiplication52.getTree());

            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:44:27: ( ( '+' | '-' ) ^ multiplication )*
            loop18:
            do {
                int alt18=2;
                int LA18_0 = input.LA(1);

                if ( (LA18_0==26||LA18_0==28) ) {
                    alt18=1;
                }


                switch (alt18) {
            	case 1 :
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:44:29: ( '+' | '-' ) ^ multiplication
            	    {
            	    set53=(Token)input.LT(1);

            	    set53=(Token)input.LT(1);

            	    if ( input.LA(1)==26||input.LA(1)==28 ) {
            	        input.consume();
            	        if ( state.backtracking==0 ) root_0 = (Object)adaptor.becomeRoot(
            	        (Object)adaptor.create(set53)
            	        , root_0);
            	        state.errorRecovery=false;
            	        state.failed=false;
            	    }
            	    else {
            	        if (state.backtracking>0) {state.failed=true; return retval;}
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        throw mse;
            	    }


            	    pushFollow(FOLLOW_multiplication_in_addition375);
            	    multiplication54=multiplication();

            	    state._fsp--;
            	    if (state.failed) return retval;
            	    if ( state.backtracking==0 ) adaptor.addChild(root_0, multiplication54.getTree());

            	    }
            	    break;

            	default :
            	    break loop18;
                }
            } while (true);


            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "addition"


    public static class multiplication_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "multiplication"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:46:1: multiplication : unary ( ( '*' | '/' | '//' ) ^ unary )* ;
    public final AutoHotkeyParser.multiplication_return multiplication() throws RecognitionException {
        AutoHotkeyParser.multiplication_return retval = new AutoHotkeyParser.multiplication_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token set56=null;
        AutoHotkeyParser.unary_return unary55 =null;

        AutoHotkeyParser.unary_return unary57 =null;


        Object set56_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:46:16: ( unary ( ( '*' | '/' | '//' ) ^ unary )* )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:46:18: unary ( ( '*' | '/' | '//' ) ^ unary )*
            {
            root_0 = (Object)adaptor.nil();


            pushFollow(FOLLOW_unary_in_multiplication386);
            unary55=unary();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, unary55.getTree());

            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:46:24: ( ( '*' | '/' | '//' ) ^ unary )*
            loop19:
            do {
                int alt19=2;
                int LA19_0 = input.LA(1);

                if ( (LA19_0==24||(LA19_0 >= 31 && LA19_0 <= 32)) ) {
                    alt19=1;
                }


                switch (alt19) {
            	case 1 :
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:46:26: ( '*' | '/' | '//' ) ^ unary
            	    {
            	    set56=(Token)input.LT(1);

            	    set56=(Token)input.LT(1);

            	    if ( input.LA(1)==24||(input.LA(1) >= 31 && input.LA(1) <= 32) ) {
            	        input.consume();
            	        if ( state.backtracking==0 ) root_0 = (Object)adaptor.becomeRoot(
            	        (Object)adaptor.create(set56)
            	        , root_0);
            	        state.errorRecovery=false;
            	        state.failed=false;
            	    }
            	    else {
            	        if (state.backtracking>0) {state.failed=true; return retval;}
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        throw mse;
            	    }


            	    pushFollow(FOLLOW_unary_in_multiplication405);
            	    unary57=unary();

            	    state._fsp--;
            	    if (state.failed) return retval;
            	    if ( state.backtracking==0 ) adaptor.addChild(root_0, unary57.getTree());

            	    }
            	    break;

            	default :
            	    break loop19;
                }
            } while (true);


            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "multiplication"


    public static class unary_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "unary"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:48:1: unary : ( ( UNARY ^)? exponentiation ) ;
    public final AutoHotkeyParser.unary_return unary() throws RecognitionException {
        AutoHotkeyParser.unary_return retval = new AutoHotkeyParser.unary_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token UNARY58=null;
        AutoHotkeyParser.exponentiation_return exponentiation59 =null;


        Object UNARY58_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:48:8: ( ( ( UNARY ^)? exponentiation ) )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:48:10: ( ( UNARY ^)? exponentiation )
            {
            root_0 = (Object)adaptor.nil();


            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:48:10: ( ( UNARY ^)? exponentiation )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:48:12: ( UNARY ^)? exponentiation
            {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:48:17: ( UNARY ^)?
            int alt20=2;
            int LA20_0 = input.LA(1);

            if ( (LA20_0==UNARY) ) {
                alt20=1;
            }
            switch (alt20) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:48:17: UNARY ^
                    {
                    UNARY58=(Token)match(input,UNARY,FOLLOW_UNARY_in_unary419); if (state.failed) return retval;
                    if ( state.backtracking==0 ) {
                    UNARY58_tree = 
                    (Object)adaptor.create(UNARY58)
                    ;
                    root_0 = (Object)adaptor.becomeRoot(UNARY58_tree, root_0);
                    }

                    }
                    break;

            }


            pushFollow(FOLLOW_exponentiation_in_unary423);
            exponentiation59=exponentiation();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, exponentiation59.getTree());

            }


            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "unary"


    public static class exponentiation_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "exponentiation"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:50:1: exponentiation : increment ( '**' ^ unary )? ;
    public final AutoHotkeyParser.exponentiation_return exponentiation() throws RecognitionException {
        AutoHotkeyParser.exponentiation_return retval = new AutoHotkeyParser.exponentiation_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token string_literal61=null;
        AutoHotkeyParser.increment_return increment60 =null;

        AutoHotkeyParser.unary_return unary62 =null;


        Object string_literal61_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:50:16: ( increment ( '**' ^ unary )? )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:50:18: increment ( '**' ^ unary )?
            {
            root_0 = (Object)adaptor.nil();


            pushFollow(FOLLOW_increment_in_exponentiation433);
            increment60=increment();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, increment60.getTree());

            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:50:28: ( '**' ^ unary )?
            int alt21=2;
            int LA21_0 = input.LA(1);

            if ( (LA21_0==25) ) {
                alt21=1;
            }
            switch (alt21) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:50:30: '**' ^ unary
                    {
                    string_literal61=(Token)match(input,25,FOLLOW_25_in_exponentiation437); if (state.failed) return retval;
                    if ( state.backtracking==0 ) {
                    string_literal61_tree = 
                    (Object)adaptor.create(string_literal61)
                    ;
                    root_0 = (Object)adaptor.becomeRoot(string_literal61_tree, root_0);
                    }

                    pushFollow(FOLLOW_unary_in_exponentiation440);
                    unary62=unary();

                    state._fsp--;
                    if (state.failed) return retval;
                    if ( state.backtracking==0 ) adaptor.addChild(root_0, unary62.getTree());

                    }
                    break;

            }


            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "exponentiation"


    public static class increment_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "increment"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:52:1: increment : ( access ( '++' | '--' )* | ( '++' | '--' )+ access );
    public final AutoHotkeyParser.increment_return increment() throws RecognitionException {
        AutoHotkeyParser.increment_return retval = new AutoHotkeyParser.increment_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token set64=null;
        Token set65=null;
        AutoHotkeyParser.access_return access63 =null;

        AutoHotkeyParser.access_return access66 =null;


        Object set64_tree=null;
        Object set65_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:52:11: ( access ( '++' | '--' )* | ( '++' | '--' )+ access )
            int alt24=2;
            int LA24_0 = input.LA(1);

            if ( (LA24_0==IDENTIFIER||LA24_0==NUMBER||LA24_0==STRING||(LA24_0 >= 21 && LA24_0 <= 22)) ) {
                alt24=1;
            }
            else if ( (LA24_0==27||LA24_0==29) ) {
                alt24=2;
            }
            else {
                if (state.backtracking>0) {state.failed=true; return retval;}
                NoViableAltException nvae =
                    new NoViableAltException("", 24, 0, input);

                throw nvae;

            }
            switch (alt24) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:52:13: access ( '++' | '--' )*
                    {
                    root_0 = (Object)adaptor.nil();


                    pushFollow(FOLLOW_access_in_increment451);
                    access63=access();

                    state._fsp--;
                    if (state.failed) return retval;
                    if ( state.backtracking==0 ) adaptor.addChild(root_0, access63.getTree());

                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:52:20: ( '++' | '--' )*
                    loop22:
                    do {
                        int alt22=2;
                        int LA22_0 = input.LA(1);

                        if ( (LA22_0==27||LA22_0==29) ) {
                            alt22=1;
                        }


                        switch (alt22) {
                    	case 1 :
                    	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:
                    	    {
                    	    set64=(Token)input.LT(1);

                    	    if ( input.LA(1)==27||input.LA(1)==29 ) {
                    	        input.consume();
                    	        if ( state.backtracking==0 ) adaptor.addChild(root_0, 
                    	        (Object)adaptor.create(set64)
                    	        );
                    	        state.errorRecovery=false;
                    	        state.failed=false;
                    	    }
                    	    else {
                    	        if (state.backtracking>0) {state.failed=true; return retval;}
                    	        MismatchedSetException mse = new MismatchedSetException(null,input);
                    	        throw mse;
                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop22;
                        }
                    } while (true);


                    }
                    break;
                case 2 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:52:39: ( '++' | '--' )+ access
                    {
                    root_0 = (Object)adaptor.nil();


                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:52:39: ( '++' | '--' )+
                    int cnt23=0;
                    loop23:
                    do {
                        int alt23=2;
                        int LA23_0 = input.LA(1);

                        if ( (LA23_0==27||LA23_0==29) ) {
                            alt23=1;
                        }


                        switch (alt23) {
                    	case 1 :
                    	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:
                    	    {
                    	    set65=(Token)input.LT(1);

                    	    if ( input.LA(1)==27||input.LA(1)==29 ) {
                    	        input.consume();
                    	        if ( state.backtracking==0 ) adaptor.addChild(root_0, 
                    	        (Object)adaptor.create(set65)
                    	        );
                    	        state.errorRecovery=false;
                    	        state.failed=false;
                    	    }
                    	    else {
                    	        if (state.backtracking>0) {state.failed=true; return retval;}
                    	        MismatchedSetException mse = new MismatchedSetException(null,input);
                    	        throw mse;
                    	    }


                    	    }
                    	    break;

                    	default :
                    	    if ( cnt23 >= 1 ) break loop23;
                    	    if (state.backtracking>0) {state.failed=true; return retval;}
                                EarlyExitException eee =
                                    new EarlyExitException(23, input);
                                throw eee;
                        }
                        cnt23++;
                    } while (true);


                    pushFollow(FOLLOW_access_in_increment477);
                    access66=access();

                    state._fsp--;
                    if (state.failed) return retval;
                    if ( state.backtracking==0 ) adaptor.addChild(root_0, access66.getTree());

                    }
                    break;

            }
            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "increment"


    public static class access_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "access"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:54:1: access : dynamic ( '.' ^ dynamic )* ;
    public final AutoHotkeyParser.access_return access() throws RecognitionException {
        AutoHotkeyParser.access_return retval = new AutoHotkeyParser.access_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token char_literal68=null;
        AutoHotkeyParser.dynamic_return dynamic67 =null;

        AutoHotkeyParser.dynamic_return dynamic69 =null;


        Object char_literal68_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:54:9: ( dynamic ( '.' ^ dynamic )* )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:54:11: dynamic ( '.' ^ dynamic )*
            {
            root_0 = (Object)adaptor.nil();


            pushFollow(FOLLOW_dynamic_in_access486);
            dynamic67=dynamic();

            state._fsp--;
            if (state.failed) return retval;
            if ( state.backtracking==0 ) adaptor.addChild(root_0, dynamic67.getTree());

            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:54:19: ( '.' ^ dynamic )*
            loop25:
            do {
                int alt25=2;
                int LA25_0 = input.LA(1);

                if ( (LA25_0==30) ) {
                    alt25=1;
                }


                switch (alt25) {
            	case 1 :
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:54:21: '.' ^ dynamic
            	    {
            	    char_literal68=(Token)match(input,30,FOLLOW_30_in_access490); if (state.failed) return retval;
            	    if ( state.backtracking==0 ) {
            	    char_literal68_tree = 
            	    (Object)adaptor.create(char_literal68)
            	    ;
            	    root_0 = (Object)adaptor.becomeRoot(char_literal68_tree, root_0);
            	    }

            	    pushFollow(FOLLOW_dynamic_in_access493);
            	    dynamic69=dynamic();

            	    state._fsp--;
            	    if (state.failed) return retval;
            	    if ( state.backtracking==0 ) adaptor.addChild(root_0, dynamic69.getTree());

            	    }
            	    break;

            	default :
            	    break loop25;
                }
            } while (true);


            }

            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "access"


    public static class dynamic_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "dynamic"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:56:1: dynamic : ( '%' ^ IDENTIFIER '%' !| primary );
    public final AutoHotkeyParser.dynamic_return dynamic() throws RecognitionException {
        AutoHotkeyParser.dynamic_return retval = new AutoHotkeyParser.dynamic_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token char_literal70=null;
        Token IDENTIFIER71=null;
        Token char_literal72=null;
        AutoHotkeyParser.primary_return primary73 =null;


        Object char_literal70_tree=null;
        Object IDENTIFIER71_tree=null;
        Object char_literal72_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:56:10: ( '%' ^ IDENTIFIER '%' !| primary )
            int alt26=2;
            int LA26_0 = input.LA(1);

            if ( (LA26_0==21) ) {
                alt26=1;
            }
            else if ( (LA26_0==IDENTIFIER||LA26_0==NUMBER||LA26_0==STRING||LA26_0==22) ) {
                alt26=2;
            }
            else {
                if (state.backtracking>0) {state.failed=true; return retval;}
                NoViableAltException nvae =
                    new NoViableAltException("", 26, 0, input);

                throw nvae;

            }
            switch (alt26) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:56:12: '%' ^ IDENTIFIER '%' !
                    {
                    root_0 = (Object)adaptor.nil();


                    char_literal70=(Token)match(input,21,FOLLOW_21_in_dynamic505); if (state.failed) return retval;
                    if ( state.backtracking==0 ) {
                    char_literal70_tree = 
                    (Object)adaptor.create(char_literal70)
                    ;
                    root_0 = (Object)adaptor.becomeRoot(char_literal70_tree, root_0);
                    }

                    IDENTIFIER71=(Token)match(input,IDENTIFIER,FOLLOW_IDENTIFIER_in_dynamic508); if (state.failed) return retval;
                    if ( state.backtracking==0 ) {
                    IDENTIFIER71_tree = 
                    (Object)adaptor.create(IDENTIFIER71)
                    ;
                    adaptor.addChild(root_0, IDENTIFIER71_tree);
                    }

                    char_literal72=(Token)match(input,21,FOLLOW_21_in_dynamic510); if (state.failed) return retval;

                    }
                    break;
                case 2 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:56:35: primary
                    {
                    root_0 = (Object)adaptor.nil();


                    pushFollow(FOLLOW_primary_in_dynamic515);
                    primary73=primary();

                    state._fsp--;
                    if (state.failed) return retval;
                    if ( state.backtracking==0 ) adaptor.addChild(root_0, primary73.getTree());

                    }
                    break;

            }
            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "dynamic"


    public static class primary_return extends ParserRuleReturnScope {
        Object tree;
        public Object getTree() { return tree; }
    };


    // $ANTLR start "primary"
    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:58:1: primary : ( NUMBER | STRING | IDENTIFIER | '(' ! expression ')' !);
    public final AutoHotkeyParser.primary_return primary() throws RecognitionException {
        AutoHotkeyParser.primary_return retval = new AutoHotkeyParser.primary_return();
        retval.start = input.LT(1);


        Object root_0 = null;

        Token NUMBER74=null;
        Token STRING75=null;
        Token IDENTIFIER76=null;
        Token char_literal77=null;
        Token char_literal79=null;
        AutoHotkeyParser.expression_return expression78 =null;


        Object NUMBER74_tree=null;
        Object STRING75_tree=null;
        Object IDENTIFIER76_tree=null;
        Object char_literal77_tree=null;
        Object char_literal79_tree=null;

        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:58:10: ( NUMBER | STRING | IDENTIFIER | '(' ! expression ')' !)
            int alt27=4;
            switch ( input.LA(1) ) {
            case NUMBER:
                {
                alt27=1;
                }
                break;
            case STRING:
                {
                alt27=2;
                }
                break;
            case IDENTIFIER:
                {
                alt27=3;
                }
                break;
            case 22:
                {
                alt27=4;
                }
                break;
            default:
                if (state.backtracking>0) {state.failed=true; return retval;}
                NoViableAltException nvae =
                    new NoViableAltException("", 27, 0, input);

                throw nvae;

            }

            switch (alt27) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:58:12: NUMBER
                    {
                    root_0 = (Object)adaptor.nil();


                    NUMBER74=(Token)match(input,NUMBER,FOLLOW_NUMBER_in_primary524); if (state.failed) return retval;
                    if ( state.backtracking==0 ) {
                    NUMBER74_tree = 
                    (Object)adaptor.create(NUMBER74)
                    ;
                    adaptor.addChild(root_0, NUMBER74_tree);
                    }

                    }
                    break;
                case 2 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:58:21: STRING
                    {
                    root_0 = (Object)adaptor.nil();


                    STRING75=(Token)match(input,STRING,FOLLOW_STRING_in_primary528); if (state.failed) return retval;
                    if ( state.backtracking==0 ) {
                    STRING75_tree = 
                    (Object)adaptor.create(STRING75)
                    ;
                    adaptor.addChild(root_0, STRING75_tree);
                    }

                    }
                    break;
                case 3 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:58:30: IDENTIFIER
                    {
                    root_0 = (Object)adaptor.nil();


                    IDENTIFIER76=(Token)match(input,IDENTIFIER,FOLLOW_IDENTIFIER_in_primary532); if (state.failed) return retval;
                    if ( state.backtracking==0 ) {
                    IDENTIFIER76_tree = 
                    (Object)adaptor.create(IDENTIFIER76)
                    ;
                    adaptor.addChild(root_0, IDENTIFIER76_tree);
                    }

                    }
                    break;
                case 4 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:58:43: '(' ! expression ')' !
                    {
                    root_0 = (Object)adaptor.nil();


                    char_literal77=(Token)match(input,22,FOLLOW_22_in_primary536); if (state.failed) return retval;

                    pushFollow(FOLLOW_expression_in_primary539);
                    expression78=expression();

                    state._fsp--;
                    if (state.failed) return retval;
                    if ( state.backtracking==0 ) adaptor.addChild(root_0, expression78.getTree());

                    char_literal79=(Token)match(input,23,FOLLOW_23_in_primary541); if (state.failed) return retval;

                    }
                    break;

            }
            retval.stop = input.LT(-1);


            if ( state.backtracking==0 ) {

            retval.tree = (Object)adaptor.rulePostProcessing(root_0);
            adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop);
            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
    	retval.tree = (Object)adaptor.errorNode(input, retval.start, input.LT(-1), re);

        }

        finally {
        	// do for sure before leaving
        }
        return retval;
    }
    // $ANTLR end "primary"

    // $ANTLR start synpred1_AutoHotkey
    public final void synpred1_AutoHotkey_fragment() throws RecognitionException {
        // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:11:9: ( hotkey )
        // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:11:11: hotkey
        {
        pushFollow(FOLLOW_hotkey_in_synpred1_AutoHotkey46);
        hotkey();

        state._fsp--;
        if (state.failed) return ;

        }

    }
    // $ANTLR end synpred1_AutoHotkey

    // $ANTLR start synpred2_AutoHotkey
    public final void synpred2_AutoHotkey_fragment() throws RecognitionException {
        // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:12:5: ( command )
        // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:12:7: command
        {
        pushFollow(FOLLOW_command_in_synpred2_AutoHotkey60);
        command();

        state._fsp--;
        if (state.failed) return ;

        }

    }
    // $ANTLR end synpred2_AutoHotkey

    // $ANTLR start synpred3_AutoHotkey
    public final void synpred3_AutoHotkey_fragment() throws RecognitionException {
        // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:23:16: ( access ASSIGN assignment )
        // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:23:18: access ASSIGN assignment
        {
        pushFollow(FOLLOW_access_in_synpred3_AutoHotkey154);
        access();

        state._fsp--;
        if (state.failed) return ;

        match(input,ASSIGN,FOLLOW_ASSIGN_in_synpred3_AutoHotkey156); if (state.failed) return ;

        pushFollow(FOLLOW_assignment_in_synpred3_AutoHotkey158);
        assignment();

        state._fsp--;
        if (state.failed) return ;

        }

    }
    // $ANTLR end synpred3_AutoHotkey

    // Delegated rules

    public final boolean synpred1_AutoHotkey() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred1_AutoHotkey_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred2_AutoHotkey() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred2_AutoHotkey_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred3_AutoHotkey() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred3_AutoHotkey_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }


 

    public static final BitSet FOLLOW_line_in_program25 = new BitSet(new long[]{0x0000000000000802L});
    public static final BitSet FOLLOW_LINE_END_in_program29 = new BitSet(new long[]{0x0000000428783C00L});
    public static final BitSet FOLLOW_line_in_program32 = new BitSet(new long[]{0x0000000000000802L});
    public static final BitSet FOLLOW_hotkey_in_line52 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_command_in_line66 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_expression_in_line72 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_34_in_hotkey81 = new BitSet(new long[]{0x0000000428783400L});
    public static final BitSet FOLLOW_line_in_hotkey83 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_IDENTIFIER_in_command93 = new BitSet(new long[]{0x0000000000030002L});
    public static final BitSet FOLLOW_SEPARATOR_in_command97 = new BitSet(new long[]{0x0000000000010000L});
    public static final BitSet FOLLOW_PARAMETER_in_command101 = new BitSet(new long[]{0x0000000000020002L});
    public static final BitSet FOLLOW_SEPARATOR_in_command105 = new BitSet(new long[]{0x0000000000010000L});
    public static final BitSet FOLLOW_PARAMETER_in_command108 = new BitSet(new long[]{0x0000000000020002L});
    public static final BitSet FOLLOW_expression_in_start123 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_assignment_in_expression132 = new BitSet(new long[]{0x0000000000020002L});
    public static final BitSet FOLLOW_SEPARATOR_in_expression136 = new BitSet(new long[]{0x0000000028783400L});
    public static final BitSet FOLLOW_assignment_in_expression139 = new BitSet(new long[]{0x0000000000020002L});
    public static final BitSet FOLLOW_access_in_assignment164 = new BitSet(new long[]{0x0000000000000020L});
    public static final BitSet FOLLOW_ASSIGN_in_assignment166 = new BitSet(new long[]{0x0000000028783400L});
    public static final BitSet FOLLOW_assignment_in_assignment169 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_ternary_in_assignment176 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_or_in_ternary185 = new BitSet(new long[]{0x0000000800000002L});
    public static final BitSet FOLLOW_35_in_ternary189 = new BitSet(new long[]{0x0000000028783400L});
    public static final BitSet FOLLOW_ternary_in_ternary192 = new BitSet(new long[]{0x0000000200000000L});
    public static final BitSet FOLLOW_33_in_ternary194 = new BitSet(new long[]{0x0000000028783400L});
    public static final BitSet FOLLOW_ternary_in_ternary197 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_and_in_or209 = new BitSet(new long[]{0x0000000000004002L});
    public static final BitSet FOLLOW_OR_in_or213 = new BitSet(new long[]{0x0000000028783400L});
    public static final BitSet FOLLOW_and_in_or216 = new BitSet(new long[]{0x0000000000004002L});
    public static final BitSet FOLLOW_not_in_and228 = new BitSet(new long[]{0x0000000000000012L});
    public static final BitSet FOLLOW_AND_in_and232 = new BitSet(new long[]{0x0000000028783400L});
    public static final BitSet FOLLOW_not_in_and235 = new BitSet(new long[]{0x0000000000000012L});
    public static final BitSet FOLLOW_NOT_in_not247 = new BitSet(new long[]{0x0000000028782400L});
    public static final BitSet FOLLOW_comparison_in_not251 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_regex_in_comparison259 = new BitSet(new long[]{0x0000000000000102L});
    public static final BitSet FOLLOW_COMPARE_in_comparison263 = new BitSet(new long[]{0x0000000028782400L});
    public static final BitSet FOLLOW_regex_in_comparison266 = new BitSet(new long[]{0x0000000000000102L});
    public static final BitSet FOLLOW_concatenation_in_regex278 = new BitSet(new long[]{0x0000001000000002L});
    public static final BitSet FOLLOW_36_in_regex282 = new BitSet(new long[]{0x0000000028782400L});
    public static final BitSet FOLLOW_concatenation_in_regex285 = new BitSet(new long[]{0x0000001000000002L});
    public static final BitSet FOLLOW_bitwise_in_concatenation296 = new BitSet(new long[]{0x0000000000008002L});
    public static final BitSet FOLLOW_PADDING_in_concatenation300 = new BitSet(new long[]{0x0000000040000000L});
    public static final BitSet FOLLOW_30_in_concatenation303 = new BitSet(new long[]{0x0000000000008000L});
    public static final BitSet FOLLOW_PADDING_in_concatenation306 = new BitSet(new long[]{0x0000000028782400L});
    public static final BitSet FOLLOW_bitwise_in_concatenation309 = new BitSet(new long[]{0x0000000000008002L});
    public static final BitSet FOLLOW_shift_in_bitwise322 = new BitSet(new long[]{0x0000000000000042L});
    public static final BitSet FOLLOW_BITWISE_in_bitwise326 = new BitSet(new long[]{0x0000000028782400L});
    public static final BitSet FOLLOW_shift_in_bitwise329 = new BitSet(new long[]{0x0000000000000042L});
    public static final BitSet FOLLOW_addition_in_shift342 = new BitSet(new long[]{0x0000000000040002L});
    public static final BitSet FOLLOW_SHIFT_in_shift346 = new BitSet(new long[]{0x0000000028782400L});
    public static final BitSet FOLLOW_addition_in_shift349 = new BitSet(new long[]{0x0000000000040002L});
    public static final BitSet FOLLOW_multiplication_in_addition360 = new BitSet(new long[]{0x0000000014000002L});
    public static final BitSet FOLLOW_set_in_addition364 = new BitSet(new long[]{0x0000000028782400L});
    public static final BitSet FOLLOW_multiplication_in_addition375 = new BitSet(new long[]{0x0000000014000002L});
    public static final BitSet FOLLOW_unary_in_multiplication386 = new BitSet(new long[]{0x0000000181000002L});
    public static final BitSet FOLLOW_set_in_multiplication390 = new BitSet(new long[]{0x0000000028782400L});
    public static final BitSet FOLLOW_unary_in_multiplication405 = new BitSet(new long[]{0x0000000181000002L});
    public static final BitSet FOLLOW_UNARY_in_unary419 = new BitSet(new long[]{0x0000000028682400L});
    public static final BitSet FOLLOW_exponentiation_in_unary423 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_increment_in_exponentiation433 = new BitSet(new long[]{0x0000000002000002L});
    public static final BitSet FOLLOW_25_in_exponentiation437 = new BitSet(new long[]{0x0000000028782400L});
    public static final BitSet FOLLOW_unary_in_exponentiation440 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_access_in_increment451 = new BitSet(new long[]{0x0000000028000002L});
    public static final BitSet FOLLOW_access_in_increment477 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_dynamic_in_access486 = new BitSet(new long[]{0x0000000040000002L});
    public static final BitSet FOLLOW_30_in_access490 = new BitSet(new long[]{0x0000000000682400L});
    public static final BitSet FOLLOW_dynamic_in_access493 = new BitSet(new long[]{0x0000000040000002L});
    public static final BitSet FOLLOW_21_in_dynamic505 = new BitSet(new long[]{0x0000000000000400L});
    public static final BitSet FOLLOW_IDENTIFIER_in_dynamic508 = new BitSet(new long[]{0x0000000000200000L});
    public static final BitSet FOLLOW_21_in_dynamic510 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_primary_in_dynamic515 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_NUMBER_in_primary524 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_STRING_in_primary528 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_IDENTIFIER_in_primary532 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_22_in_primary536 = new BitSet(new long[]{0x0000000028783400L});
    public static final BitSet FOLLOW_expression_in_primary539 = new BitSet(new long[]{0x0000000000800000L});
    public static final BitSet FOLLOW_23_in_primary541 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_hotkey_in_synpred1_AutoHotkey46 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_command_in_synpred2_AutoHotkey60 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_access_in_synpred3_AutoHotkey154 = new BitSet(new long[]{0x0000000000000020L});
    public static final BitSet FOLLOW_ASSIGN_in_synpred3_AutoHotkey156 = new BitSet(new long[]{0x0000000028783400L});
    public static final BitSet FOLLOW_assignment_in_synpred3_AutoHotkey158 = new BitSet(new long[]{0x0000000000000002L});

}