grammar Autonomy;

program
	:	ignore lines EOF
	;

statement
	:	expression ignore ((LINE | SEPARATOR | MAP | operator_left) | parameter_list)
	;

expression
	:	ignore null_denotation (ignore OPERATOR_LEFT /* something */ ignore operator_left)* //wip
	;

null_denotation
	:	OPERATOR_NULL operator_null | LINE null_denotation | SYMBOL | SELF | STRING | IDENTIFIER | NUMBER
	;

operator_null
	:	evaluate | block | array | unary
	;

operator_left
	:	call | assignment | subscript | subscript_identifier | comparison | ternary | boolean_short_circuit | binary
	;

unary
	:	statement
	;

binary
	:	statement
	;

evaluate
	:	lines ')'
	;

block
	:	lines? '}'
	;

array
	:	parameter_list? ']'
	;

call
	:	parameter_list? ']'
	;

assignment
	:	statement
	;

subscript
	:	(
			statement
		|	(ignore | statement) MAP (ignore | statement) (MAP (ignore | statement))?
		)
		']'
	;

subscript_identifier
	:	IDENTIFIER
	;

comparison
	:	statement (OPERATOR_LEFT statement)* //wip
	;

ternary
	:	statement (MAP statement)
	;

boolean_short_circuit
	:	statement
	;

ignore
	:	(WHITESPACE | COMMENT)*
	;

lines
	:	statement ((LINE | EOF) statement)* (LINE | EOF)?
	;

parameter_list
	:	statement (MAP statement)? (',' (ignore ',' | statement (MAP statement)?))*
	;

OPERATOR_NULL
	:	'!' | '-' | '~' | '&' | '(' | '{' | '[' //wip: check identifier chars
	;

OPERATOR_LEFT
	:	':=' | '+=' | '-=' | '*=' | '/=' | '//=' | '%=' | '%%=' | '**=' | '..=' | '|=' | '&=' | '^=' | '<<=' | '>>=' | '||=' | '&&=' | '?' | '||' | '&&' | '=' | '==' | '!=' | '!==' | '>' | '<' | '..' | '|' | '^' | '&' | '<<' | '>>' | '>>>' | '+' | '-' | '*' | '/' | '//' | '%' | '%%' | '**' | '(' | '}' | '[' | ']' | '.' //wip: check identifier chars
	;

SYMBOL
	:	'\'' ('a'..'z' | 'A'..'Z' | '0'..'9' | '_')+
	;

STRING
	:	'"' ('`"' | ~('"' | '\r' | '\n'))* '"'
	;

IDENTIFIER
	:	('a'..'z' | 'A'..'Z' | '_') ('a'..'z' | 'A'..'Z' | '0'..'9' | '_')*
	;

NUMBER
	:	(
			'0x' ('0'..'9' | 'a'..'f' | 'A'..'F')+
		|	'0b' ('0' | '1')+ ('.' ('0' | '1')+)?
		|	('0'..'9')+ ('.' ('0'..'9')+)?
		)
		(('e' | 'E') '-'? ('0'..'9')+)?
	;

LINE
	:	(('\r' | '\n' | ' ' | '\t') WHITESPACE)+
	;

SEPARATOR
	:	','
	;

MAP
	:	':'
	;

SELF
	:	'$'
	;

COMMENT
	:	';' ~('\n' | '\r')*
	|	'/*' (COMMENT | ( options {greedy=false;} : . )) '*/' {$channel=HIDDEN;}
	;

WHITESPACE
	:	(' ' | '\t')* {$channel=HIDDEN;}
	;
