#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
export LC_ALL=C
bash build.sh
mkdir -p tests/observed
{
    date -u '+Run date (UTC): %Y-%m-%dT%H:%M:%SZ'
    uname -sm
    bison --version | head -n 1
    flex --version
    gcc --version | head -n 1
    printf '%s\n' 'Build: bash build.sh' 'Tests: bash run_tests.sh'
} > tests/observed/environment.txt
printf 'id\tresult\n' > tests/observed/results.tsv
passed=0
failed=0
while IFS=$'\t' read -r id input; do
    [[ "$id" == id ]] && continue
    if ./build/quectoc-parser < "$input" \
        > "tests/observed/$id.stdout" 2> "tests/observed/$id.stderr"; then
        status=0
    else
        status=$?
    fi
    printf '%s\n' "$status" > "tests/observed/$id.status"
    match=1
    for stream in stdout stderr status; do
        if ! diff -u "tests/expected/$id.$stream" "tests/observed/$id.$stream"; then
            match=0
        fi
    done
    if [[ "$match" == 1 ]]; then
        printf 'PASS  %s\n' "$id"
        printf '%s\tPASS\n' "$id" >> tests/observed/results.tsv
        passed=$((passed + 1))
    else
        printf 'FAIL  %s\n' "$id"
        printf '%s\tFAIL\n' "$id" >> tests/observed/results.tsv
        failed=$((failed + 1))
    fi
done < tests/cases.tsv
printf 'Tests: %s passed, %s failed\n' "$passed" "$failed"
[[ "$failed" == 0 ]]
