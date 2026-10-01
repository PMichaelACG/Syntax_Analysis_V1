/* QuectoC syntax baseline: exactly one declaration. */
%require "3.0"
%{
#include <stdio.h>
int yylex(void);
void yyerror(const char *message);
extern int lexical_error;
%}
%token KW_LET KW_INT KW_PRINT
%token IDENTIFIER INT_LITERAL
%token ASSIGN PLUS MINUS SEMICOLON LPAREN RPAREN
%token LEX_ERROR
%start program
%%
program:
    KW_LET IDENTIFIER ASSIGN INT_LITERAL SEMICOLON
;
%%
void yyerror(const char *message) {
    if (!lexical_error)
        fprintf(stderr, "PARSER_ERROR %s\n", message);
}
