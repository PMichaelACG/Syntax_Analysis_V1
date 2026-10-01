/* One driver for the combined scanner and parser. */
#include <stdio.h>
#include "parser.tab.h"

int yylex_destroy(void);
extern int lexical_error;

int main(void) {
    int status = yyparse();
    yylex_destroy();

    if (status != 0 || lexical_error) {
        puts("PARSE_ERROR");
        return status == 2 ? 2 : 1;
    }
    puts("PARSE_OK");
    return 0;
}
