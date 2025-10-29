%option noyywrap c++ yylineno

%{
#include <iostream>
#include <stdlib.h>
%}

DIGIT  		[0-9]
WS          [ \t\n]
LETTER      [a-zA-Z]


%%

program     std::cout << "T_PROGRAM" << std::endl;
begin       std::cout << "T_BEGIN" << std::endl;
end         std::cout << "T_END" << std::endl;
integer     std::cout << "T_INTEGER" << std::endl; 
boolean     std::cout << "T_BOOLEAN" << std::endl;
skip        std::cout << "T_SKIP" << std::endl;
if          std::cout << "T_IF" << std::endl;
then        std::cout << "T_THEN" << std::endl;
else        std::cout << "T_ELSE" << std::endl;
endif       std::cout << "T_ENDIF" << std::endl;
while       std::cout << "T_WHILE" << std::endl;
do          std::cout << "T_DO" << std::endl;
done        std::cout << "T_DONE" << std::endl;
read        std::cout << "T_READ" << std::endl;
write       std::cout << "T_WRITE" << std::endl;
";"         std::cout << "T_SEMICOLON" << std::endl;
":="        std::cout << "T_ASSIGN" << std::endl;
"="         std::cout << "T_EQ" << std::endl;
"<"         std::cout << "T_LESS" << std::endl;
">"         std::cout << "T_GR" << std::endl;
"+"         std::cout << "T_ADD" << std::endl;
"-"         std::cout << "T_SUB" << std::endl;
"*"         std::cout << "T_MUL" << std::endl;
and         std::cout << "T_AND" << std::endl;
or          std::cout << "T_OR" << std::endl;
not         std::cout << "T_NOT" << std::endl;
div         std::cout << "T_DIV" << std::endl; 
mod         std::cout << "T_MOD" << std::endl;
"("         std::cout << "T_OPEN" << std::endl;
")"         std::cout << "T_CLOSE" << std::endl;


true        std::cout << "T_TRUE" << std::endl;
false       std::cout << "T_FALSE" << std::endl;

"#".*\n    // nothing to do

(({LETTER}|_)*)([02468]({DIGIT}{DIGIT})*|[13579]({DIGIT}{DIGIT})*{DIGIT})    std::cout << "T_ID2" << std::endl;

0b[01]*|0o[0-7]*|0x{DIGIT}*[a-fA-F]*|14{DIGIT}*[a-dA-D]*|60([0-5]{DIGIT})* 	std::cout << "T_NUM2" << std::endl;


\/\*[^*]*\*\/       std::cout << "T_MULTI_LINE_COMMENT" << std::endl;


\"([^"][^"][^"])+\"       std::cout << "T_STRING" << std::endl;


{WS}+   // nothing to do

. {
    std::cerr << "Line " << lineno() << ": Lexical error." << std::endl;
    exit(1);
}

%%
