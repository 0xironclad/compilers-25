
#pragma once

#include "Parserbase.h"
#include <FlexLexer.h>

#undef Parser
class Parser: public ParserBase
{
        
    public:
        Parser(std::istream& inFile) : lexer( &inFile, &std::cerr ) {}
        int parse();

    private:
        yyFlexLexer lexer;
        #if BISONCPP_VSN >= 602
            void error();    // called on (syntax) errors
        #endif
        void error(char const *msg);    // called on (syntax) errors
        int lex();                      // returns the next token from the
                                        // lexical scanner. 
        void print();                   // use, e.g., d_token, d_loc

    // support functions for parse():
        #if BISONCPP_VSN >= 602
            void executeAction_(int ruleNr);
            void errorRecovery_();
            void nextCycle_();
            void nextToken_();
            void print_();
            void exceptionHandler(std::exception const &exc);
        #else
            void executeAction(int ruleNr);
            void errorRecovery();
            void nextToken();
            void print__();
            void exceptionHandler__(std::exception const &exc);
        #endif

        int lookup(bool recovery);

        int get_line_number();
        void set_line_number(int);
};
