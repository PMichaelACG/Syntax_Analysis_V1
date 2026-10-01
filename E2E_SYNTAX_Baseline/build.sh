#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
export LC_ALL=C
mkdir -p build
bison -Wall -Werror -d -o build/parser.tab.c parser.y
flex -o build/lex.yy.c scanner.l
gcc -std=c11 -Wall -Wextra -Werror -I build \
    build/parser.tab.c build/lex.yy.c main.c -o build/quectoc-parser
printf '%s\n' 'Built build/quectoc-parser'
