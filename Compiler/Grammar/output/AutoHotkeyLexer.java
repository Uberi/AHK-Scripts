// $ANTLR 3.4 C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g 2012-05-26 23:04:59

import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked"})
public class AutoHotkeyLexer extends Lexer {
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
    // delegators
    public Lexer[] getDelegates() {
        return new Lexer[] {};
    }

    public AutoHotkeyLexer() {} 
    public AutoHotkeyLexer(CharStream input) {
        this(input, new RecognizerSharedState());
    }
    public AutoHotkeyLexer(CharStream input, RecognizerSharedState state) {
        super(input,state);
    }
    public String getGrammarFileName() { return "C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g"; }

    // $ANTLR start "T__21"
    public final void mT__21() throws RecognitionException {
        try {
            int _type = T__21;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:2:7: ( '%' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:2:9: '%'
            {
            match('%'); 

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "T__21"

    // $ANTLR start "T__22"
    public final void mT__22() throws RecognitionException {
        try {
            int _type = T__22;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:3:7: ( '(' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:3:9: '('
            {
            match('('); 

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "T__22"

    // $ANTLR start "T__23"
    public final void mT__23() throws RecognitionException {
        try {
            int _type = T__23;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:4:7: ( ')' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:4:9: ')'
            {
            match(')'); 

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "T__23"

    // $ANTLR start "T__24"
    public final void mT__24() throws RecognitionException {
        try {
            int _type = T__24;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:5:7: ( '*' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:5:9: '*'
            {
            match('*'); 

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "T__24"

    // $ANTLR start "T__25"
    public final void mT__25() throws RecognitionException {
        try {
            int _type = T__25;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:6:7: ( '**' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:6:9: '**'
            {
            match("**"); 



            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "T__25"

    // $ANTLR start "T__26"
    public final void mT__26() throws RecognitionException {
        try {
            int _type = T__26;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:7:7: ( '+' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:7:9: '+'
            {
            match('+'); 

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "T__26"

    // $ANTLR start "T__27"
    public final void mT__27() throws RecognitionException {
        try {
            int _type = T__27;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:8:7: ( '++' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:8:9: '++'
            {
            match("++"); 



            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "T__27"

    // $ANTLR start "T__28"
    public final void mT__28() throws RecognitionException {
        try {
            int _type = T__28;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:9:7: ( '-' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:9:9: '-'
            {
            match('-'); 

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "T__28"

    // $ANTLR start "T__29"
    public final void mT__29() throws RecognitionException {
        try {
            int _type = T__29;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:10:7: ( '--' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:10:9: '--'
            {
            match("--"); 



            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "T__29"

    // $ANTLR start "T__30"
    public final void mT__30() throws RecognitionException {
        try {
            int _type = T__30;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:11:7: ( '.' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:11:9: '.'
            {
            match('.'); 

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "T__30"

    // $ANTLR start "T__31"
    public final void mT__31() throws RecognitionException {
        try {
            int _type = T__31;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:12:7: ( '/' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:12:9: '/'
            {
            match('/'); 

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "T__31"

    // $ANTLR start "T__32"
    public final void mT__32() throws RecognitionException {
        try {
            int _type = T__32;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:13:7: ( '//' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:13:9: '//'
            {
            match("//"); 



            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "T__32"

    // $ANTLR start "T__33"
    public final void mT__33() throws RecognitionException {
        try {
            int _type = T__33;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:14:7: ( ':' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:14:9: ':'
            {
            match(':'); 

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "T__33"

    // $ANTLR start "T__34"
    public final void mT__34() throws RecognitionException {
        try {
            int _type = T__34;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:15:7: ( '::' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:15:9: '::'
            {
            match("::"); 



            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "T__34"

    // $ANTLR start "T__35"
    public final void mT__35() throws RecognitionException {
        try {
            int _type = T__35;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:16:7: ( '?' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:16:9: '?'
            {
            match('?'); 

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "T__35"

    // $ANTLR start "T__36"
    public final void mT__36() throws RecognitionException {
        try {
            int _type = T__36;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:17:7: ( '~=' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:17:9: '~='
            {
            match("~="); 



            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "T__36"

    // $ANTLR start "PARAMETER"
    public final void mPARAMETER() throws RecognitionException {
        try {
            int _type = PARAMETER;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:64:11: ( 'x' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:64:13: 'x'
            {
            match('x'); 

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "PARAMETER"

    // $ANTLR start "ASSIGN"
    public final void mASSIGN() throws RecognitionException {
        try {
            int _type = ASSIGN;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:66:9: ( ':=' | '+=' | '-=' | '*=' | '/=' | '//=' | '.=' | '|=' | '&=' | '^=' | '>>=' | '<<=' )
            int alt1=12;
            switch ( input.LA(1) ) {
            case ':':
                {
                alt1=1;
                }
                break;
            case '+':
                {
                alt1=2;
                }
                break;
            case '-':
                {
                alt1=3;
                }
                break;
            case '*':
                {
                alt1=4;
                }
                break;
            case '/':
                {
                int LA1_5 = input.LA(2);

                if ( (LA1_5=='=') ) {
                    alt1=5;
                }
                else if ( (LA1_5=='/') ) {
                    alt1=6;
                }
                else {
                    NoViableAltException nvae =
                        new NoViableAltException("", 1, 5, input);

                    throw nvae;

                }
                }
                break;
            case '.':
                {
                alt1=7;
                }
                break;
            case '|':
                {
                alt1=8;
                }
                break;
            case '&':
                {
                alt1=9;
                }
                break;
            case '^':
                {
                alt1=10;
                }
                break;
            case '>':
                {
                alt1=11;
                }
                break;
            case '<':
                {
                alt1=12;
                }
                break;
            default:
                NoViableAltException nvae =
                    new NoViableAltException("", 1, 0, input);

                throw nvae;

            }

            switch (alt1) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:66:11: ':='
                    {
                    match(":="); 



                    }
                    break;
                case 2 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:66:18: '+='
                    {
                    match("+="); 



                    }
                    break;
                case 3 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:66:25: '-='
                    {
                    match("-="); 



                    }
                    break;
                case 4 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:66:32: '*='
                    {
                    match("*="); 



                    }
                    break;
                case 5 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:66:39: '/='
                    {
                    match("/="); 



                    }
                    break;
                case 6 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:66:46: '//='
                    {
                    match("//="); 



                    }
                    break;
                case 7 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:66:54: '.='
                    {
                    match(".="); 



                    }
                    break;
                case 8 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:66:61: '|='
                    {
                    match("|="); 



                    }
                    break;
                case 9 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:66:68: '&='
                    {
                    match("&="); 



                    }
                    break;
                case 10 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:66:75: '^='
                    {
                    match("^="); 



                    }
                    break;
                case 11 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:66:82: '>>='
                    {
                    match(">>="); 



                    }
                    break;
                case 12 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:66:90: '<<='
                    {
                    match("<<="); 



                    }
                    break;

            }
            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "ASSIGN"

    // $ANTLR start "SEPARATOR"
    public final void mSEPARATOR() throws RecognitionException {
        try {
            int _type = SEPARATOR;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:68:11: ( ',' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:68:13: ','
            {
            match(','); 

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "SEPARATOR"

    // $ANTLR start "OR"
    public final void mOR() throws RecognitionException {
        try {
            int _type = OR;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:70:5: ( ( 'o' | 'O' ) ( 'r' | 'R' ) | '||' )
            int alt2=2;
            int LA2_0 = input.LA(1);

            if ( (LA2_0=='O'||LA2_0=='o') ) {
                alt2=1;
            }
            else if ( (LA2_0=='|') ) {
                alt2=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 2, 0, input);

                throw nvae;

            }
            switch (alt2) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:70:7: ( 'o' | 'O' ) ( 'r' | 'R' )
                    {
                    if ( input.LA(1)=='O'||input.LA(1)=='o' ) {
                        input.consume();
                    }
                    else {
                        MismatchedSetException mse = new MismatchedSetException(null,input);
                        recover(mse);
                        throw mse;
                    }


                    if ( input.LA(1)=='R'||input.LA(1)=='r' ) {
                        input.consume();
                    }
                    else {
                        MismatchedSetException mse = new MismatchedSetException(null,input);
                        recover(mse);
                        throw mse;
                    }


                    }
                    break;
                case 2 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:70:37: '||'
                    {
                    match("||"); 



                    }
                    break;

            }
            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "OR"

    // $ANTLR start "AND"
    public final void mAND() throws RecognitionException {
        try {
            int _type = AND;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:72:6: ( ( 'a' | 'A' ) ( 'n' | 'N' ) ( 'd' | 'D' ) | '&&' )
            int alt3=2;
            int LA3_0 = input.LA(1);

            if ( (LA3_0=='A'||LA3_0=='a') ) {
                alt3=1;
            }
            else if ( (LA3_0=='&') ) {
                alt3=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 3, 0, input);

                throw nvae;

            }
            switch (alt3) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:72:8: ( 'a' | 'A' ) ( 'n' | 'N' ) ( 'd' | 'D' )
                    {
                    if ( input.LA(1)=='A'||input.LA(1)=='a' ) {
                        input.consume();
                    }
                    else {
                        MismatchedSetException mse = new MismatchedSetException(null,input);
                        recover(mse);
                        throw mse;
                    }


                    if ( input.LA(1)=='N'||input.LA(1)=='n' ) {
                        input.consume();
                    }
                    else {
                        MismatchedSetException mse = new MismatchedSetException(null,input);
                        recover(mse);
                        throw mse;
                    }


                    if ( input.LA(1)=='D'||input.LA(1)=='d' ) {
                        input.consume();
                    }
                    else {
                        MismatchedSetException mse = new MismatchedSetException(null,input);
                        recover(mse);
                        throw mse;
                    }


                    }
                    break;
                case 2 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:72:52: '&&'
                    {
                    match("&&"); 



                    }
                    break;

            }
            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "AND"

    // $ANTLR start "NOT"
    public final void mNOT() throws RecognitionException {
        try {
            int _type = NOT;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:74:6: ( ( 'n' | 'N' ) ( 'o' | 'O' ) ( 't' | 'T' ) )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:74:8: ( 'n' | 'N' ) ( 'o' | 'O' ) ( 't' | 'T' )
            {
            if ( input.LA(1)=='N'||input.LA(1)=='n' ) {
                input.consume();
            }
            else {
                MismatchedSetException mse = new MismatchedSetException(null,input);
                recover(mse);
                throw mse;
            }


            if ( input.LA(1)=='O'||input.LA(1)=='o' ) {
                input.consume();
            }
            else {
                MismatchedSetException mse = new MismatchedSetException(null,input);
                recover(mse);
                throw mse;
            }


            if ( input.LA(1)=='T'||input.LA(1)=='t' ) {
                input.consume();
            }
            else {
                MismatchedSetException mse = new MismatchedSetException(null,input);
                recover(mse);
                throw mse;
            }


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "NOT"

    // $ANTLR start "COMPARE"
    public final void mCOMPARE() throws RecognitionException {
        try {
            int _type = COMPARE;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:76:10: ( '>' | '<' | '>=' | '<=' | '=' | '==' | '<>' | '!=' )
            int alt4=8;
            switch ( input.LA(1) ) {
            case '>':
                {
                int LA4_1 = input.LA(2);

                if ( (LA4_1=='=') ) {
                    alt4=3;
                }
                else {
                    alt4=1;
                }
                }
                break;
            case '<':
                {
                switch ( input.LA(2) ) {
                case '=':
                    {
                    alt4=4;
                    }
                    break;
                case '>':
                    {
                    alt4=7;
                    }
                    break;
                default:
                    alt4=2;
                }

                }
                break;
            case '=':
                {
                int LA4_3 = input.LA(2);

                if ( (LA4_3=='=') ) {
                    alt4=6;
                }
                else {
                    alt4=5;
                }
                }
                break;
            case '!':
                {
                alt4=8;
                }
                break;
            default:
                NoViableAltException nvae =
                    new NoViableAltException("", 4, 0, input);

                throw nvae;

            }

            switch (alt4) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:76:12: '>'
                    {
                    match('>'); 

                    }
                    break;
                case 2 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:76:18: '<'
                    {
                    match('<'); 

                    }
                    break;
                case 3 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:76:24: '>='
                    {
                    match(">="); 



                    }
                    break;
                case 4 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:76:31: '<='
                    {
                    match("<="); 



                    }
                    break;
                case 5 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:76:38: '='
                    {
                    match('='); 

                    }
                    break;
                case 6 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:76:44: '=='
                    {
                    match("=="); 



                    }
                    break;
                case 7 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:76:51: '<>'
                    {
                    match("<>"); 



                    }
                    break;
                case 8 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:76:58: '!='
                    {
                    match("!="); 



                    }
                    break;

            }
            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "COMPARE"

    // $ANTLR start "BITWISE"
    public final void mBITWISE() throws RecognitionException {
        try {
            int _type = BITWISE;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:78:10: ( '&' | '^' | '|' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:
            {
            if ( input.LA(1)=='&'||input.LA(1)=='^'||input.LA(1)=='|' ) {
                input.consume();
            }
            else {
                MismatchedSetException mse = new MismatchedSetException(null,input);
                recover(mse);
                throw mse;
            }


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "BITWISE"

    // $ANTLR start "SHIFT"
    public final void mSHIFT() throws RecognitionException {
        try {
            int _type = SHIFT;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:80:8: ( '<<' | '>>' )
            int alt5=2;
            int LA5_0 = input.LA(1);

            if ( (LA5_0=='<') ) {
                alt5=1;
            }
            else if ( (LA5_0=='>') ) {
                alt5=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 5, 0, input);

                throw nvae;

            }
            switch (alt5) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:80:10: '<<'
                    {
                    match("<<"); 



                    }
                    break;
                case 2 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:80:17: '>>'
                    {
                    match(">>"); 



                    }
                    break;

            }
            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "SHIFT"

    // $ANTLR start "UNARY"
    public final void mUNARY() throws RecognitionException {
        try {
            int _type = UNARY;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:82:8: ( '-' | '!' | '~' | '&' | '*' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:
            {
            if ( input.LA(1)=='!'||input.LA(1)=='&'||input.LA(1)=='*'||input.LA(1)=='-'||input.LA(1)=='~' ) {
                input.consume();
            }
            else {
                MismatchedSetException mse = new MismatchedSetException(null,input);
                recover(mse);
                throw mse;
            }


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "UNARY"

    // $ANTLR start "IDENTIFIER"
    public final void mIDENTIFIER() throws RecognitionException {
        try {
            int _type = IDENTIFIER;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:84:12: ( ( 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '#' | '_' | '@' | '$' )+ )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:84:14: ( 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '#' | '_' | '@' | '$' )+
            {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:84:14: ( 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '#' | '_' | '@' | '$' )+
            int cnt6=0;
            loop6:
            do {
                int alt6=2;
                int LA6_0 = input.LA(1);

                if ( ((LA6_0 >= '#' && LA6_0 <= '$')||(LA6_0 >= '0' && LA6_0 <= '9')||(LA6_0 >= '@' && LA6_0 <= 'Z')||LA6_0=='_'||(LA6_0 >= 'a' && LA6_0 <= 'z')) ) {
                    alt6=1;
                }


                switch (alt6) {
            	case 1 :
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:
            	    {
            	    if ( (input.LA(1) >= '#' && input.LA(1) <= '$')||(input.LA(1) >= '0' && input.LA(1) <= '9')||(input.LA(1) >= '@' && input.LA(1) <= 'Z')||input.LA(1)=='_'||(input.LA(1) >= 'a' && input.LA(1) <= 'z') ) {
            	        input.consume();
            	    }
            	    else {
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        recover(mse);
            	        throw mse;
            	    }


            	    }
            	    break;

            	default :
            	    if ( cnt6 >= 1 ) break loop6;
                        EarlyExitException eee =
                            new EarlyExitException(6, input);
                        throw eee;
                }
                cnt6++;
            } while (true);


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "IDENTIFIER"

    // $ANTLR start "NUMBER"
    public final void mNUMBER() throws RecognitionException {
        try {
            int _type = NUMBER;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:86:9: ( '0' ( 'x' | 'X' ) ( '0' .. '9' )+ | ( '0' .. '9' )+ ( '.' ( '0' .. '9' )* ( EXPONENT )? )? | '.' ( '0' .. '9' )+ ( EXPONENT )? )
            int alt14=3;
            switch ( input.LA(1) ) {
            case '0':
                {
                int LA14_1 = input.LA(2);

                if ( (LA14_1=='X'||LA14_1=='x') ) {
                    alt14=1;
                }
                else {
                    alt14=2;
                }
                }
                break;
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                {
                alt14=2;
                }
                break;
            case '.':
                {
                alt14=3;
                }
                break;
            default:
                NoViableAltException nvae =
                    new NoViableAltException("", 14, 0, input);

                throw nvae;

            }

            switch (alt14) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:86:11: '0' ( 'x' | 'X' ) ( '0' .. '9' )+
                    {
                    match('0'); 

                    if ( input.LA(1)=='X'||input.LA(1)=='x' ) {
                        input.consume();
                    }
                    else {
                        MismatchedSetException mse = new MismatchedSetException(null,input);
                        recover(mse);
                        throw mse;
                    }


                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:86:29: ( '0' .. '9' )+
                    int cnt7=0;
                    loop7:
                    do {
                        int alt7=2;
                        int LA7_0 = input.LA(1);

                        if ( ((LA7_0 >= '0' && LA7_0 <= '9')) ) {
                            alt7=1;
                        }


                        switch (alt7) {
                    	case 1 :
                    	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:
                    	    {
                    	    if ( (input.LA(1) >= '0' && input.LA(1) <= '9') ) {
                    	        input.consume();
                    	    }
                    	    else {
                    	        MismatchedSetException mse = new MismatchedSetException(null,input);
                    	        recover(mse);
                    	        throw mse;
                    	    }


                    	    }
                    	    break;

                    	default :
                    	    if ( cnt7 >= 1 ) break loop7;
                                EarlyExitException eee =
                                    new EarlyExitException(7, input);
                                throw eee;
                        }
                        cnt7++;
                    } while (true);


                    }
                    break;
                case 2 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:87:5: ( '0' .. '9' )+ ( '.' ( '0' .. '9' )* ( EXPONENT )? )?
                    {
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:87:5: ( '0' .. '9' )+
                    int cnt8=0;
                    loop8:
                    do {
                        int alt8=2;
                        int LA8_0 = input.LA(1);

                        if ( ((LA8_0 >= '0' && LA8_0 <= '9')) ) {
                            alt8=1;
                        }


                        switch (alt8) {
                    	case 1 :
                    	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:
                    	    {
                    	    if ( (input.LA(1) >= '0' && input.LA(1) <= '9') ) {
                    	        input.consume();
                    	    }
                    	    else {
                    	        MismatchedSetException mse = new MismatchedSetException(null,input);
                    	        recover(mse);
                    	        throw mse;
                    	    }


                    	    }
                    	    break;

                    	default :
                    	    if ( cnt8 >= 1 ) break loop8;
                                EarlyExitException eee =
                                    new EarlyExitException(8, input);
                                throw eee;
                        }
                        cnt8++;
                    } while (true);


                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:87:15: ( '.' ( '0' .. '9' )* ( EXPONENT )? )?
                    int alt11=2;
                    int LA11_0 = input.LA(1);

                    if ( (LA11_0=='.') ) {
                        alt11=1;
                    }
                    switch (alt11) {
                        case 1 :
                            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:87:17: '.' ( '0' .. '9' )* ( EXPONENT )?
                            {
                            match('.'); 

                            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:87:21: ( '0' .. '9' )*
                            loop9:
                            do {
                                int alt9=2;
                                int LA9_0 = input.LA(1);

                                if ( ((LA9_0 >= '0' && LA9_0 <= '9')) ) {
                                    alt9=1;
                                }


                                switch (alt9) {
                            	case 1 :
                            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:
                            	    {
                            	    if ( (input.LA(1) >= '0' && input.LA(1) <= '9') ) {
                            	        input.consume();
                            	    }
                            	    else {
                            	        MismatchedSetException mse = new MismatchedSetException(null,input);
                            	        recover(mse);
                            	        throw mse;
                            	    }


                            	    }
                            	    break;

                            	default :
                            	    break loop9;
                                }
                            } while (true);


                            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:87:35: ( EXPONENT )?
                            int alt10=2;
                            int LA10_0 = input.LA(1);

                            if ( (LA10_0=='E'||LA10_0=='e') ) {
                                alt10=1;
                            }
                            switch (alt10) {
                                case 1 :
                                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:87:35: EXPONENT
                                    {
                                    mEXPONENT(); 


                                    }
                                    break;

                            }


                            }
                            break;

                    }


                    }
                    break;
                case 3 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:88:5: '.' ( '0' .. '9' )+ ( EXPONENT )?
                    {
                    match('.'); 

                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:88:9: ( '0' .. '9' )+
                    int cnt12=0;
                    loop12:
                    do {
                        int alt12=2;
                        int LA12_0 = input.LA(1);

                        if ( ((LA12_0 >= '0' && LA12_0 <= '9')) ) {
                            alt12=1;
                        }


                        switch (alt12) {
                    	case 1 :
                    	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:
                    	    {
                    	    if ( (input.LA(1) >= '0' && input.LA(1) <= '9') ) {
                    	        input.consume();
                    	    }
                    	    else {
                    	        MismatchedSetException mse = new MismatchedSetException(null,input);
                    	        recover(mse);
                    	        throw mse;
                    	    }


                    	    }
                    	    break;

                    	default :
                    	    if ( cnt12 >= 1 ) break loop12;
                                EarlyExitException eee =
                                    new EarlyExitException(12, input);
                                throw eee;
                        }
                        cnt12++;
                    } while (true);


                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:88:23: ( EXPONENT )?
                    int alt13=2;
                    int LA13_0 = input.LA(1);

                    if ( (LA13_0=='E'||LA13_0=='e') ) {
                        alt13=1;
                    }
                    switch (alt13) {
                        case 1 :
                            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:88:23: EXPONENT
                            {
                            mEXPONENT(); 


                            }
                            break;

                    }


                    }
                    break;

            }
            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "NUMBER"

    // $ANTLR start "EXPONENT"
    public final void mEXPONENT() throws RecognitionException {
        try {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:93:10: ( ( 'e' | 'E' ) ( '+' | '-' )? ( '0' .. '9' )+ )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:93:12: ( 'e' | 'E' ) ( '+' | '-' )? ( '0' .. '9' )+
            {
            if ( input.LA(1)=='E'||input.LA(1)=='e' ) {
                input.consume();
            }
            else {
                MismatchedSetException mse = new MismatchedSetException(null,input);
                recover(mse);
                throw mse;
            }


            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:93:24: ( '+' | '-' )?
            int alt15=2;
            int LA15_0 = input.LA(1);

            if ( (LA15_0=='+'||LA15_0=='-') ) {
                alt15=1;
            }
            switch (alt15) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:
                    {
                    if ( input.LA(1)=='+'||input.LA(1)=='-' ) {
                        input.consume();
                    }
                    else {
                        MismatchedSetException mse = new MismatchedSetException(null,input);
                        recover(mse);
                        throw mse;
                    }


                    }
                    break;

            }


            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:93:37: ( '0' .. '9' )+
            int cnt16=0;
            loop16:
            do {
                int alt16=2;
                int LA16_0 = input.LA(1);

                if ( ((LA16_0 >= '0' && LA16_0 <= '9')) ) {
                    alt16=1;
                }


                switch (alt16) {
            	case 1 :
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:
            	    {
            	    if ( (input.LA(1) >= '0' && input.LA(1) <= '9') ) {
            	        input.consume();
            	    }
            	    else {
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        recover(mse);
            	        throw mse;
            	    }


            	    }
            	    break;

            	default :
            	    if ( cnt16 >= 1 ) break loop16;
                        EarlyExitException eee =
                            new EarlyExitException(16, input);
                        throw eee;
                }
                cnt16++;
            } while (true);


            }


        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "EXPONENT"

    // $ANTLR start "COMMENT"
    public final void mCOMMENT() throws RecognitionException {
        try {
            int _type = COMMENT;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:95:10: ( '//' (~ ( '\\n' | '\\r' ) )* LINE_END | '/*' ( options {greedy=false; } : . )* '*/' )
            int alt19=2;
            int LA19_0 = input.LA(1);

            if ( (LA19_0=='/') ) {
                int LA19_1 = input.LA(2);

                if ( (LA19_1=='/') ) {
                    alt19=1;
                }
                else if ( (LA19_1=='*') ) {
                    alt19=2;
                }
                else {
                    NoViableAltException nvae =
                        new NoViableAltException("", 19, 1, input);

                    throw nvae;

                }
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 19, 0, input);

                throw nvae;

            }
            switch (alt19) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:95:12: '//' (~ ( '\\n' | '\\r' ) )* LINE_END
                    {
                    match("//"); 



                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:95:17: (~ ( '\\n' | '\\r' ) )*
                    loop17:
                    do {
                        int alt17=2;
                        int LA17_0 = input.LA(1);

                        if ( ((LA17_0 >= '\u0000' && LA17_0 <= '\t')||(LA17_0 >= '\u000B' && LA17_0 <= '\f')||(LA17_0 >= '\u000E' && LA17_0 <= '\uFFFF')) ) {
                            alt17=1;
                        }


                        switch (alt17) {
                    	case 1 :
                    	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:
                    	    {
                    	    if ( (input.LA(1) >= '\u0000' && input.LA(1) <= '\t')||(input.LA(1) >= '\u000B' && input.LA(1) <= '\f')||(input.LA(1) >= '\u000E' && input.LA(1) <= '\uFFFF') ) {
                    	        input.consume();
                    	    }
                    	    else {
                    	        MismatchedSetException mse = new MismatchedSetException(null,input);
                    	        recover(mse);
                    	        throw mse;
                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop17;
                        }
                    } while (true);


                    mLINE_END(); 


                     _channel=HIDDEN; 

                    }
                    break;
                case 2 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:96:5: '/*' ( options {greedy=false; } : . )* '*/'
                    {
                    match("/*"); 



                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:96:10: ( options {greedy=false; } : . )*
                    loop18:
                    do {
                        int alt18=2;
                        int LA18_0 = input.LA(1);

                        if ( (LA18_0=='*') ) {
                            int LA18_1 = input.LA(2);

                            if ( (LA18_1=='/') ) {
                                alt18=2;
                            }
                            else if ( ((LA18_1 >= '\u0000' && LA18_1 <= '.')||(LA18_1 >= '0' && LA18_1 <= '\uFFFF')) ) {
                                alt18=1;
                            }


                        }
                        else if ( ((LA18_0 >= '\u0000' && LA18_0 <= ')')||(LA18_0 >= '+' && LA18_0 <= '\uFFFF')) ) {
                            alt18=1;
                        }


                        switch (alt18) {
                    	case 1 :
                    	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:96:40: .
                    	    {
                    	    matchAny(); 

                    	    }
                    	    break;

                    	default :
                    	    break loop18;
                        }
                    } while (true);


                    match("*/"); 



                     _channel=HIDDEN; 

                    }
                    break;

            }
            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "COMMENT"

    // $ANTLR start "PADDING"
    public final void mPADDING() throws RecognitionException {
        try {
            int _type = PADDING;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:99:10: ( ( ' ' | '\\t' )+ )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:99:12: ( ' ' | '\\t' )+
            {
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:99:12: ( ' ' | '\\t' )+
            int cnt20=0;
            loop20:
            do {
                int alt20=2;
                int LA20_0 = input.LA(1);

                if ( (LA20_0=='\t'||LA20_0==' ') ) {
                    alt20=1;
                }


                switch (alt20) {
            	case 1 :
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:
            	    {
            	    if ( input.LA(1)=='\t'||input.LA(1)==' ' ) {
            	        input.consume();
            	    }
            	    else {
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        recover(mse);
            	        throw mse;
            	    }


            	    }
            	    break;

            	default :
            	    if ( cnt20 >= 1 ) break loop20;
                        EarlyExitException eee =
                            new EarlyExitException(20, input);
                        throw eee;
                }
                cnt20++;
            } while (true);


            _channel=HIDDEN;

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "PADDING"

    // $ANTLR start "STRING"
    public final void mSTRING() throws RecognitionException {
        try {
            int _type = STRING;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:101:9: ( '\"' ( '`' ( 'b' | 'B' | 't' | 'T' | 'n' | 'N' | 'f' | 'F' | 'r' | 'R' | '\"' | '`' ) |~ ( '`' | '\"' ) )* '\"' )
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:101:11: '\"' ( '`' ( 'b' | 'B' | 't' | 'T' | 'n' | 'N' | 'f' | 'F' | 'r' | 'R' | '\"' | '`' ) |~ ( '`' | '\"' ) )* '\"'
            {
            match('\"'); 

            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:101:15: ( '`' ( 'b' | 'B' | 't' | 'T' | 'n' | 'N' | 'f' | 'F' | 'r' | 'R' | '\"' | '`' ) |~ ( '`' | '\"' ) )*
            loop21:
            do {
                int alt21=3;
                int LA21_0 = input.LA(1);

                if ( (LA21_0=='`') ) {
                    alt21=1;
                }
                else if ( ((LA21_0 >= '\u0000' && LA21_0 <= '!')||(LA21_0 >= '#' && LA21_0 <= '_')||(LA21_0 >= 'a' && LA21_0 <= '\uFFFF')) ) {
                    alt21=2;
                }


                switch (alt21) {
            	case 1 :
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:101:17: '`' ( 'b' | 'B' | 't' | 'T' | 'n' | 'N' | 'f' | 'F' | 'r' | 'R' | '\"' | '`' )
            	    {
            	    match('`'); 

            	    if ( input.LA(1)=='\"'||input.LA(1)=='B'||input.LA(1)=='F'||input.LA(1)=='N'||input.LA(1)=='R'||input.LA(1)=='T'||input.LA(1)=='`'||input.LA(1)=='b'||input.LA(1)=='f'||input.LA(1)=='n'||input.LA(1)=='r'||input.LA(1)=='t' ) {
            	        input.consume();
            	    }
            	    else {
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        recover(mse);
            	        throw mse;
            	    }


            	    }
            	    break;
            	case 2 :
            	    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:101:97: ~ ( '`' | '\"' )
            	    {
            	    if ( (input.LA(1) >= '\u0000' && input.LA(1) <= '!')||(input.LA(1) >= '#' && input.LA(1) <= '_')||(input.LA(1) >= 'a' && input.LA(1) <= '\uFFFF') ) {
            	        input.consume();
            	    }
            	    else {
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        recover(mse);
            	        throw mse;
            	    }


            	    }
            	    break;

            	default :
            	    break loop21;
                }
            } while (true);


            match('\"'); 

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "STRING"

    // $ANTLR start "LINE_END"
    public final void mLINE_END() throws RecognitionException {
        try {
            int _type = LINE_END;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:103:10: ( ( '\\r' ( '\\n' )? ) | '\\n' )
            int alt23=2;
            int LA23_0 = input.LA(1);

            if ( (LA23_0=='\r') ) {
                alt23=1;
            }
            else if ( (LA23_0=='\n') ) {
                alt23=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 23, 0, input);

                throw nvae;

            }
            switch (alt23) {
                case 1 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:103:12: ( '\\r' ( '\\n' )? )
                    {
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:103:12: ( '\\r' ( '\\n' )? )
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:103:14: '\\r' ( '\\n' )?
                    {
                    match('\r'); 

                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:103:19: ( '\\n' )?
                    int alt22=2;
                    int LA22_0 = input.LA(1);

                    if ( (LA22_0=='\n') ) {
                        alt22=1;
                    }
                    switch (alt22) {
                        case 1 :
                            // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:103:19: '\\n'
                            {
                            match('\n'); 

                            }
                            break;

                    }


                    }


                    }
                    break;
                case 2 :
                    // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:103:29: '\\n'
                    {
                    match('\n'); 

                    }
                    break;

            }
            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "LINE_END"

    public void mTokens() throws RecognitionException {
        // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:8: ( T__21 | T__22 | T__23 | T__24 | T__25 | T__26 | T__27 | T__28 | T__29 | T__30 | T__31 | T__32 | T__33 | T__34 | T__35 | T__36 | PARAMETER | ASSIGN | SEPARATOR | OR | AND | NOT | COMPARE | BITWISE | SHIFT | UNARY | IDENTIFIER | NUMBER | COMMENT | PADDING | STRING | LINE_END )
        int alt24=32;
        alt24 = dfa24.predict(input);
        switch (alt24) {
            case 1 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:10: T__21
                {
                mT__21(); 


                }
                break;
            case 2 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:16: T__22
                {
                mT__22(); 


                }
                break;
            case 3 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:22: T__23
                {
                mT__23(); 


                }
                break;
            case 4 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:28: T__24
                {
                mT__24(); 


                }
                break;
            case 5 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:34: T__25
                {
                mT__25(); 


                }
                break;
            case 6 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:40: T__26
                {
                mT__26(); 


                }
                break;
            case 7 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:46: T__27
                {
                mT__27(); 


                }
                break;
            case 8 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:52: T__28
                {
                mT__28(); 


                }
                break;
            case 9 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:58: T__29
                {
                mT__29(); 


                }
                break;
            case 10 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:64: T__30
                {
                mT__30(); 


                }
                break;
            case 11 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:70: T__31
                {
                mT__31(); 


                }
                break;
            case 12 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:76: T__32
                {
                mT__32(); 


                }
                break;
            case 13 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:82: T__33
                {
                mT__33(); 


                }
                break;
            case 14 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:88: T__34
                {
                mT__34(); 


                }
                break;
            case 15 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:94: T__35
                {
                mT__35(); 


                }
                break;
            case 16 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:100: T__36
                {
                mT__36(); 


                }
                break;
            case 17 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:106: PARAMETER
                {
                mPARAMETER(); 


                }
                break;
            case 18 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:116: ASSIGN
                {
                mASSIGN(); 


                }
                break;
            case 19 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:123: SEPARATOR
                {
                mSEPARATOR(); 


                }
                break;
            case 20 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:133: OR
                {
                mOR(); 


                }
                break;
            case 21 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:136: AND
                {
                mAND(); 


                }
                break;
            case 22 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:140: NOT
                {
                mNOT(); 


                }
                break;
            case 23 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:144: COMPARE
                {
                mCOMPARE(); 


                }
                break;
            case 24 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:152: BITWISE
                {
                mBITWISE(); 


                }
                break;
            case 25 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:160: SHIFT
                {
                mSHIFT(); 


                }
                break;
            case 26 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:166: UNARY
                {
                mUNARY(); 


                }
                break;
            case 27 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:172: IDENTIFIER
                {
                mIDENTIFIER(); 


                }
                break;
            case 28 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:183: NUMBER
                {
                mNUMBER(); 


                }
                break;
            case 29 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:190: COMMENT
                {
                mCOMMENT(); 


                }
                break;
            case 30 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:198: PADDING
                {
                mPADDING(); 


                }
                break;
            case 31 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:206: STRING
                {
                mSTRING(); 


                }
                break;
            case 32 :
                // C:\\Users\\Anthony\\Dropbox\\AHK Scripts\\Compiler\\Grammar\\AutoHotkey.g:1:213: LINE_END
                {
                mLINE_END(); 


                }
                break;

        }

    }


    protected DFA24 dfa24 = new DFA24(this);
    static final String DFA24_eotS =
        "\4\uffff\1\40\1\42\1\44\1\45\1\51\1\53\1\uffff\1\55\1\56\3\60\2"+
        "\26\1\uffff\3\32\1\uffff\1\55\2\32\15\uffff\1\71\12\uffff\2\72\1"+
        "\57\3\32\1\37\2\uffff\1\61\1\76\1\32\1\uffff";
    static final String DFA24_eofS =
        "\77\uffff";
    static final String DFA24_minS =
        "\1\11\3\uffff\1\52\1\53\1\55\1\60\1\52\1\72\1\uffff\1\75\1\43\1"+
        "\75\1\46\1\75\1\76\1\74\1\uffff\1\122\1\116\1\117\1\uffff\1\75\2"+
        "\56\15\uffff\1\0\12\uffff\2\75\1\43\1\104\1\124\1\60\1\0\2\uffff"+
        "\2\43\1\60\1\uffff";
    static final String DFA24_maxS =
        "\1\176\3\uffff\6\75\1\uffff\1\75\1\172\1\174\2\75\1\76\1\74\1\uffff"+
        "\1\162\1\156\1\157\1\uffff\1\75\1\170\1\71\15\uffff\1\uffff\12\uffff"+
        "\2\75\1\172\1\144\1\164\1\71\1\uffff\2\uffff\2\172\1\71\1\uffff";
    static final String DFA24_acceptS =
        "\1\uffff\1\1\1\2\1\3\6\uffff\1\17\7\uffff\1\23\3\uffff\1\27\3\uffff"+
        "\1\33\1\36\1\37\1\40\1\5\1\22\1\4\1\7\1\6\1\11\1\10\1\12\1\34\1"+
        "\uffff\1\35\1\13\1\16\1\15\1\20\1\32\1\21\1\24\1\30\1\25\7\uffff"+
        "\1\14\1\31\3\uffff\1\26";
    static final String DFA24_specialS =
        "\47\uffff\1\1\20\uffff\1\0\6\uffff}>";
    static final String[] DFA24_transitionS = {
            "\1\33\1\35\2\uffff\1\35\22\uffff\1\33\1\27\1\34\2\32\1\1\1\16"+
            "\1\uffff\1\2\1\3\1\4\1\5\1\22\1\6\1\7\1\10\1\30\11\31\1\11\1"+
            "\uffff\1\21\1\26\1\20\1\12\1\32\1\24\14\32\1\25\1\23\13\32\3"+
            "\uffff\1\17\1\32\1\uffff\1\24\14\32\1\25\1\23\10\32\1\14\2\32"+
            "\1\uffff\1\15\1\uffff\1\13",
            "",
            "",
            "",
            "\1\36\22\uffff\1\37",
            "\1\41\21\uffff\1\37",
            "\1\43\17\uffff\1\37",
            "\12\46\3\uffff\1\37",
            "\1\50\4\uffff\1\47\15\uffff\1\37",
            "\1\52\2\uffff\1\37",
            "",
            "\1\54",
            "\2\32\13\uffff\12\32\6\uffff\33\32\4\uffff\1\32\1\uffff\32"+
            "\32",
            "\1\37\76\uffff\1\57",
            "\1\61\26\uffff\1\37",
            "\1\37",
            "\1\62",
            "\1\63",
            "",
            "\1\64\37\uffff\1\64",
            "\1\65\37\uffff\1\65",
            "\1\66\37\uffff\1\66",
            "",
            "\1\26",
            "\1\46\1\uffff\12\31\36\uffff\1\67\37\uffff\1\67",
            "\1\46\1\uffff\12\31",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "\75\50\1\70\uffc2\50",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "\1\37",
            "\1\37",
            "\2\32\13\uffff\12\32\6\uffff\33\32\4\uffff\1\32\1\uffff\32"+
            "\32",
            "\1\73\37\uffff\1\73",
            "\1\74\37\uffff\1\74",
            "\12\75",
            "\0\50",
            "",
            "",
            "\2\32\13\uffff\12\32\6\uffff\33\32\4\uffff\1\32\1\uffff\32"+
            "\32",
            "\2\32\13\uffff\12\32\6\uffff\33\32\4\uffff\1\32\1\uffff\32"+
            "\32",
            "\12\75",
            ""
    };

    static final short[] DFA24_eot = DFA.unpackEncodedString(DFA24_eotS);
    static final short[] DFA24_eof = DFA.unpackEncodedString(DFA24_eofS);
    static final char[] DFA24_min = DFA.unpackEncodedStringToUnsignedChars(DFA24_minS);
    static final char[] DFA24_max = DFA.unpackEncodedStringToUnsignedChars(DFA24_maxS);
    static final short[] DFA24_accept = DFA.unpackEncodedString(DFA24_acceptS);
    static final short[] DFA24_special = DFA.unpackEncodedString(DFA24_specialS);
    static final short[][] DFA24_transition;

    static {
        int numStates = DFA24_transitionS.length;
        DFA24_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA24_transition[i] = DFA.unpackEncodedString(DFA24_transitionS[i]);
        }
    }

    class DFA24 extends DFA {

        public DFA24(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 24;
            this.eot = DFA24_eot;
            this.eof = DFA24_eof;
            this.min = DFA24_min;
            this.max = DFA24_max;
            this.accept = DFA24_accept;
            this.special = DFA24_special;
            this.transition = DFA24_transition;
        }
        public String getDescription() {
            return "1:1: Tokens : ( T__21 | T__22 | T__23 | T__24 | T__25 | T__26 | T__27 | T__28 | T__29 | T__30 | T__31 | T__32 | T__33 | T__34 | T__35 | T__36 | PARAMETER | ASSIGN | SEPARATOR | OR | AND | NOT | COMPARE | BITWISE | SHIFT | UNARY | IDENTIFIER | NUMBER | COMMENT | PADDING | STRING | LINE_END );";
        }
        public int specialStateTransition(int s, IntStream _input) throws NoViableAltException {
            IntStream input = _input;
        	int _s = s;
            switch ( s ) {
                    case 0 : 
                        int LA24_56 = input.LA(1);

                        s = -1;
                        if ( ((LA24_56 >= '\u0000' && LA24_56 <= '\uFFFF')) ) {s = 40;}

                        else s = 31;

                        if ( s>=0 ) return s;
                        break;

                    case 1 : 
                        int LA24_39 = input.LA(1);

                        s = -1;
                        if ( (LA24_39=='=') ) {s = 56;}

                        else if ( ((LA24_39 >= '\u0000' && LA24_39 <= '<')||(LA24_39 >= '>' && LA24_39 <= '\uFFFF')) ) {s = 40;}

                        else s = 57;

                        if ( s>=0 ) return s;
                        break;
            }
            NoViableAltException nvae =
                new NoViableAltException(getDescription(), 24, _s, input);
            error(nvae);
            throw nvae;
        }

    }
 

}