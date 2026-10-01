/* QuectoC syntax baseline: return token kinds to Bison. */
%option noyywrap noinput nounput never-interactive nodefault
%{
#include <stdio.h>
#include "parser.tab.h"

int lexical_error = 0;
%}
%%
"let"                   { return KW_LET; }
"int"                   { return KW_INT; }
"print"                 { return KW_PRINT; }
[A-Za-z_][A-Za-z0-9_]*    { return IDENTIFIER; }
[0-9]+                  { return INT_LITERAL; }
"="                     { return ASSIGN; }
"+"                     { return PLUS; }
"-"                     { return MINUS; }
";"                     { return SEMICOLON; }
"("                     { return LPAREN; }
")"                     { return RPAREN; }
"//"[^\n]*              { /* Skip a line comment. */ }
[ \t\r\n]+              { /* Skip whitespace. */ }
<<EOF>>                 { return 0; }
. {
    fprintf(stderr, "LEX_ERROR unexpected character: %s\n", yytext);
    lexical_error = 1;
    return LEX_ERROR;
}
%%
