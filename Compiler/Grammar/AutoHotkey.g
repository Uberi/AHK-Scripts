grammar AutoHotkey;

options { output=AST; }

//////////////////
// parser rules //
//////////////////

program		:	line ( LINE_END+ line )*;

line		:	( hotkey ) => hotkey
		|	( command ) => command
		|	expression;

hotkey		:	'::' line; //wip

//command		:	IDENTIFIER ( ( SEPARATOR | PADDING ) PARAMETER ( SEPARATOR! PARAMETER )* )?;
command		:	'a' ',' ~','*;

start		:	expression; //wip

expression	:	assignment ( SEPARATOR! assignment )*;

assignment	:	( ( access ASSIGN assignment ) => access ASSIGN^ assignment)
		|	ternary;

ternary		:	or ( '?'^ ternary ':'! ternary )?;

or		:	and ( OR^ and )*;

and		:	not ( AND^ not )*;

not		:	NOT^? comparison;

comparison	:	regex ( COMPARE^ regex )*;

regex		:	concatenation ( '~='^ concatenation )*;

concatenation	:	bitwise ( PADDING! '.'^ PADDING! bitwise )*; //wip: use separate symbol

bitwise		:	shift ( BITWISE^ shift )*; //wip: apparently the individual operators have their own precedences

shift		:	addition ( SHIFT^ addition )*;

addition	:	multiplication ( ( '+' | '-' )^ multiplication )*;

multiplication	:	unary ( ( '*' | '/' | '//' )^ unary )*;

unary		:	( UNARY^? exponentiation );

exponentiation	:	update ( '**'^ unary )?;

update		:	access ( '++' | '--' )* | ( '++' | '--' )+ access;

access		:	dynamic ( '.'^ dynamic )*;

dynamic		:	'%'^ IDENTIFIER '%'! | primary;

primary		:	NUMBER | STRING | IDENTIFIER | '('! expression ')'!;

/////////////////
// lexer rules //
/////////////////

PARAMETER	:	( ~( SEPARATOR | LINE_END ) )*;

ASSIGN		:	':=' | '+=' | '-=' | '*=' | '/=' | '//=' | '.=' | '|=' | '&=' | '^=' | '>>=' | '<<=';

SEPARATOR	:	',';

OR		:	( 'o' | 'O' ) ( 'r' | 'R' ) | '||';

AND		:	( 'a' | 'A' ) ( 'n' | 'N' ) ( 'd' | 'D' ) | '&&';

NOT		:	( 'n' | 'N' ) ( 'o' | 'O' ) ( 't' | 'T' );

COMPARE		:	'>' | '<' | '>=' | '<=' | '=' | '==' | '<>' | '!=';

BITWISE		:	'&' | '^' | '|';

SHIFT		:	'<<' | '>>';

UNARY		:	'-' | '!' | '~' | '&' | '*';

IDENTIFIER	:	( 'a'..'z' | 'A'..'Z' | '0'..'9' | '#' | '_' | '@' | '$' )+;

NUMBER		:	'0' ( 'x' | 'X' ) '0'..'9'+
		|	'0'..'9'+ ( '.' ( '0'..'9' )* EXPONENT? )?
		|	'.' ( '0'..'9' )+ EXPONENT?
		;

fragment
EXPONENT	:	( 'e'|'E' ) ( '+'|'-' )? ( '0'..'9' )+;

//wip
COMMENT		:	'//' ~( '\n' | '\r' )* LINE_END { $channel=HIDDEN; }
		|	'/*' ( options { greedy=false; } : . )* '*/' { $channel=HIDDEN; }
		;

PADDING		:	( ' ' | '\t' )+ {$channel=HIDDEN;};

STRING		:	'"' ( '`' ( 'b' | 'B' | 't' | 'T' | 'n' | 'N' | 'f' | 'F' | 'r' | 'R' | '"' | '`' ) | ~( '`' | '"' ) )* '"';

LINE_END	:	( '\r' '\n'? ) | '\n';