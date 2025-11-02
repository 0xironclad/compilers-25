%option noyywrap c++ yylineno

%{
#include <iostream>
#include <stdlib.h>
#include "Parserbase.h"
%}

DIGIT  		[0-9]
WS          [ \t\n]
LETTER      [a-zA-Z]

%%

program     return Parser::T_PROGRAM;
begin       return Parser::T_BEGIN;
end         return Parser::T_END;
integer     return Parser::T_INTEGER; 
boolean     return Parser::T_BOOLEAN;
skip        return Parser::T_SKIP;
if          return Parser::T_IF;
then        return Parser::T_THEN;
else        return Parser::T_ELSE;
endif       return Parser::T_ENDIF;
while       return Parser::T_WHILE;
do          return Parser::T_DO;
done        return Parser::T_DONE;
read        return Parser::T_READ;
write       return Parser::T_WRITE;
";"         return Parser::T_SEMICOLON;
":="        return Parser::T_ASSIGN;
"="         return Parser::T_EQ;
"<"         return Parser::T_LESS;
">"         return Parser::T_GR;
"+"         return Parser::T_ADD;
"-"         return Parser::T_SUB;
"*"         return Parser::T_MUL;
"["         return Parser::T_OPEN_SQ;
"]"         return Parser::T_CLOSE_SQ;
"{"         return Parser::T_OPEN_CURLY;
"}"         return Parser::T_CLOSE_CURLY;
","         return Parser::T_COMMA;
and         return Parser::T_AND;
or          return Parser::T_OR;
not         return Parser::T_NOT;
div         return Parser::T_DIV; 
mod         return Parser::T_MOD;
"("         return Parser::T_OPEN;
")"         return Parser::T_CLOSE;
"++"        return Parser::T_PP;
"--"        return Parser::T_MM;
"for"       return Parser::T_FOR;
"to"        return Parser::T_TO;
time        return Parser::T_TIME;
hour        return Parser::T_HOUR;
minute      return Parser::T_MINUTE;

{DIGIT}+	return Parser::T_NUM;
true        return Parser::T_TRUE;
false       return Parser::T_FALSE;

array       return Parser::T_ARRAY;

"#".*\n    // nothing to do

{LETTER}({LETTER}|{DIGIT}|_)*    return Parser::T_ID;

(([01]{DIGIT})|2[0-3]):[0-5]{DIGIT}     return Parser::T_TIME_LITERAL;    


{WS}+   // nothing to do

. {
    std::cerr << "Line " << lineno() << ": Lexical error on token (" << YYText() << ")." << std::endl;
    exit(1);
}

%%
