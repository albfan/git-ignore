#!/bin/sh

SHARNESS_TEST_EXTENSION="sh"

test_description="Ignoring files"

. ./setup.sh

DIR_TEST=$SHARNESS_TEST_DIRECTORY/t0002


test_expect_success "Ignoring a single file" "
    git init
    cp ../.simplecov .
    export COVERAGE_NAME=ignore
    touch file1
    $COMMAND -i file1
    rm .simplecov
    git status --porcelain > out
    diff $DIR_TEST/single.status out
    rm out
"

test_expect_success "Ignoring a bunch of files" "
    git init
    cp ../.simplecov .
    export COVERAGE_NAME=ignore
    touch file1
    touch file2
    $COMMAND -i 'file*'
    rm .simplecov
    touch file3
    git status --porcelain > out
    diff $DIR_TEST/bunch.status out 
    rm out
"

test_done
