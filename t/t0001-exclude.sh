#!/bin/sh

test_description="Excluding files"

. ./setup.sh

test_expect_success "exclude a single file" '
    git init
    export COVERAGE_NAME=exclude
    cp ../.simplecov .
    touch file1
    $COMMAND file1
    rm .simplecov
    test "" = "$(git status --porcelain)"
'

test_expect_success "exclude a bunch of files" "
    git init
    cp ../.simplecov .
    export COVERAGE_NAME=exclude
    touch file1
    touch file2
    $COMMAND 'file*'
    rm .simplecov
    touch file3
    test \"\" = \"$(git status --porcelain)\"
"

test_done
