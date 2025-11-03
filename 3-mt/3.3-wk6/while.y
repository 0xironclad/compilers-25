%baseclass-preinclude <iostream>

%union {
    std::string *name;
    int *value;
}

%lsp-needed


%token T_PROGRAM T_BEGIN T_END

%token T_INTEGER T_BOOLEAN

%token T_SEMICOLON
%token T_SKIP
%token T_IF T_THEN T_ELSE T_ENDIF
%token T_WHILE T_DO T_DONE
%token T_READ T_WRITE
%token T_ASSIGN
%token T_COLON T_QUESTION
%token T_PARALLEL
%token T_OPEN_SQ T_CLOSE_SQ
%token T_COMMA
%token T_LIST T_APPENDMENT

%token T_OPEN T_CLOSE
%token T_TRUE T_FALSE
%token <value> T_NUM
%token <name> T_ID

// later line = the operator has higher priority
%left T_SHIFT
%left T_OR T_AND
%left T_EQ
%left T_LESS T_GR
%left T_ADD T_SUB
%left T_MUL T_DIV T_MOD
%left T_PLUS_PLUS

%nonassoc T_NOT T_DOT

%start program

%%

program:
    T_PROGRAM T_ID declarations T_BEGIN statements T_END
    {
        std::cout << "start -> T_PROGRAM T_ID(" << *$2 << ") declarations T_BEGIN statements T_END" << std::endl;
    }
;

type_sequence:
    type
    {
        std::cout << "type_sequence -> type" << std::endl;
    }
|
    type_sequence T_COMMA type
    {
        std::cout << "type_sequence -> type" << std::endl;
    }
;

declarations:
    // empty
    {
        std::cout << "declarations -> (epsilon)" << std::endl;
    }
|
    declaration declarations
    {
        std::cout << "declarations -> declaration declarations" << std::endl;
    }
;

declaration:
    type variable_sequence T_SEMICOLON
    {
        std::cout << "declaration -> type variable_sequence T_SEMICOLON" << std::endl;
    }
|
    type T_LIST T_ID T_SEMICOLON
    {
        std::cout << "declaration -> type T_LIST T_ID T_SEMICOLON" << std::endl;
    }
|
    T_LESS type_sequence T_GR T_ID T_SEMICOLON
    {
        std::cout << "declaration -> T_LESS type_sequence T_GR T_ID T_SEMICOLON" << std::endl;
    }
;

type:
    T_INTEGER
    {
        std::cout << "type -> T_INTEGER" << std::endl;
    }
|
    T_BOOLEAN 
    {
        std::cout << "type -> T_BOOLEAN" << std::endl;
    }
;

variable_sequence:
    T_ID
    {
        std::cout << "variable_sequence -> T_ID" << std::endl;
    }
|
    variable_sequence T_COMMA T_ID
    {
        std::cout << "variable_sequence -> variable_sequence T_COMMA T_ID" << std::endl;
    }
;

statements:
    statement
    {
        std::cout << "statements -> statement" << std::endl;
    }
|
    statement statements
    {
        std::cout << "statements -> statement statements" << std::endl;
    }
;

statement:
    T_SKIP T_SEMICOLON
    {
        std::cout << "statement -> T_SKIP T_SEMICOLON" << std::endl;
    }
|
    assignment
    {
        std::cout << "statement -> assignment" << std::endl;
    }
|
    read
    {
        std::cout << "statement -> read" << std::endl;
    }
|
    write
    {
        std::cout << "statement -> write" << std::endl;
    }
|
    branch
    {
        std::cout << "statement -> branch" << std::endl;
    }
|
    loop
    {
        std::cout << "statement -> loop" << std::endl;
    }
|
    T_OPEN_SQ statement_no_semi T_PARALLEL statement_no_semi T_CLOSE_SQ T_SEMICOLON
    {
        std::cout << "statement -> T_OPEN_SQ statement_no_semi T_PARALLEL statement_no_semi T_CLOSE T_SEMICOLON" << std::endl;
    }
;

statement_no_semi:
    assignment_no_semi
    {
        std::cout << "statement_no_semi -> assignment_no_semi" << std::endl;
    }
|
    read_no_semi
    {
        std::cout << "statement_no_semi -> read_no_semi" << std::endl;
    }
|
    write_no_semi
    {
        std::cout << "statement_no_semi -> read_no_semi" << std::endl;
    }
;

list_sequence:
    expression
    {
        std::cout << "list_sequence -> expression" << std::endl;
    }
|
    list_sequence T_COMMA expression
    {
        std::cout << "list_sequence -> list_sequence T_COMMA expression" << std::endl;
    }
;
    
    

assignment:
    T_ID T_ASSIGN expression T_SEMICOLON
    {
        std::cout << "assignment -> T_ID(" << *$1 << ") T_ASSIGN expression T_SEMICOLON" << std::endl;
    }
|
    T_ID T_APPENDMENT expression T_SEMICOLON
    {
        std::cout << "assignment -> T_ID T_APPENDMENT expression T_SEMICOLON" << std::endl;
    }
|
    T_ID T_OPEN_SQ T_NUM T_CLOSE_SQ T_ASSIGN expression T_SEMICOLON
    {
        std::cout << "assignment -> T_ID T_OPEN_SQ T_NUM T_CLOSE_SQ T_ASSIGN expression T_SEMICOLON" << std::endl;
    }
|
    T_ID T_DOT T_NUM T_ASSIGN expression T_SEMICOLON
    {
        std::cout << "assignment -> T_ID T_DOT T_NUM T_ASSIGN expression T_SEMICOLON" << std::endl;
    }
;

assignment_no_semi:
    T_ID T_ASSIGN expression
    {
        std::cout << "assignment_no_semi -> T_ID T_ASSIGN expression" << std::endl;
    }
;

read:
    T_READ T_OPEN T_ID T_CLOSE T_SEMICOLON
    {
        std::cout << "read -> T_READ T_OPEN T_ID(" << *$3 << ") T_CLOSE T_SEMICOLON" << std::endl;
    }
|
    T_READ T_OPEN T_ID T_DOT T_NUM T_CLOSE T_SEMICOLON
    {
        std::cout << "read -> T_READ T_OPEN T_ID T_DOT T_NUM T_CLOSE T_SEMICOLON" << std::endl;
    }
;
read_no_semi:
    T_READ T_OPEN T_ID T_CLOSE
    {
        std::cout << "read_no_semi -> T_READ T_OPEN T_ID T_CLOSE" << std::endl;
    }
;

write:
    T_WRITE T_OPEN expression T_CLOSE T_SEMICOLON
    {
        std::cout << "write -> T_WRITE T_OPEN expression T_CLOSE T_SEMICOLON" << std::endl;
    }
;

write_no_semi:
    T_WRITE T_OPEN expression T_CLOSE
    {
        std::cout << "write_no_semi -> T_WRITE T_OPEN expression T_CLOSE" << std::endl;
    }
;

branch:
    T_IF expression T_THEN statements T_ENDIF
    {
        std::cout << "branch -> T_IF expression T_THEN statements T_ENDIF" << std::endl;
    }
|
    T_IF expression T_THEN statements T_ELSE statements T_ENDIF
    {
        std::cout << "branch -> T_IF expression T_THEN statements T_ELSE statements T_ENDIF" << std::endl;
    }
;

loop:
    T_WHILE expression T_DO statements T_DONE
    {
        std::cout << "loop -> T_WHILE expression T_DO statements T_DONE" << std::endl;
    }
;

list:
    T_OPEN_SQ T_CLOSE_SQ
    {
        std::cout << "list -> T_OPEN_SQ T_CLOSE_SQ" << std::endl;
    }
|
    T_OPEN_SQ list_sequence T_CLOSE_SQ
    {
        std::cout << "list -> T_OPEN_SQ list_sequence T_CLOSE_SQ" << std::endl;
    }
;

expression:
    T_NUM
    {
        std::cout << "expression -> T_NUM(" << *$1 << ")" << std::endl;
    }
|
    T_TRUE
    {
        std::cout << "expression -> T_TRUE" << std::endl;
    }
|
    T_FALSE
    {
        std::cout << "expression -> T_FALSE" << std::endl;
    }
|
    T_ID
    {
        std::cout << "expression -> T_ID(" << *$1 << ")" << std::endl;
    }
|
    expression T_ADD expression
    {
        std::cout << "expression -> expression T_ADD expression" << std::endl;
    }
|
    expression T_SUB expression
    {
        std::cout << "expression -> expression T_SUB expression" << std::endl;
    }
|
    expression T_MUL expression
    {
        std::cout << "expression -> expression T_MUL expression" << std::endl;
    }
|
    expression T_DIV expression
    {
        std::cout << "expression -> expression T_DIV expression" << std::endl;
    }
|
    expression T_MOD expression
    {
        std::cout << "expression -> expression T_MOD expression" << std::endl;
    }
|
    expression T_LESS expression
    {
        std::cout << "expression -> expression T_LESS expression" << std::endl;
    }
|
    expression T_GR expression
    {
        std::cout << "expression -> expression T_GR expression" << std::endl;
    }
|
    expression T_EQ expression
    {
        std::cout << "expression -> expression T_EQ expression" << std::endl;
    }
|
    expression T_AND expression
    {
        std::cout << "expression -> expression T_AND expression" << std::endl;
    }
|
    expression T_OR expression
    {
        std::cout << "expression -> expression T_OR expression" << std::endl;
    }
|
    T_NOT expression
    {
        std::cout << "expression -> T_NOT expression" << std::endl;
    }
|
    T_OPEN expression T_CLOSE
    {
        std::cout << "expression -> T_OPEN expression T_CLOSE" << std::endl;
    }
|
    expression T_SHIFT expression
    {
        std::cout << "expression -> expression T_SHIFT expression" << std::endl;
    }
|
    T_OPEN expression T_QUESTION expression T_COLON expression T_CLOSE
    {
        std::cout << "expression -> T_OPEN expression T_QUESTION expression T_COLON expression T_CLOSE" << std::endl;
    }
|
    T_ID T_OPEN_SQ T_NUM T_CLOSE_SQ
    {
        std::cout << "expression -> T_ID T_OPEN_SQ T_NUM T_CLOSE_SQ" << std::endl;
    }
|
    list
    {
        std::cout << "expression -> list" << std::endl;
    }
|
    expression T_PLUS_PLUS expression
    {
        std::cout << "expression -> expression T_PLUS_PLUS expression" << std::endl;
    }
|
    T_ID T_DOT T_NUM
    {
        std::cout << "expression -> T_ID T_DOT T_NUM" << std::endl;
    }
;
