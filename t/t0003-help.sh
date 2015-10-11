#!/bin/sh

SHARNESS_TEST_EXTENSION="sh"

test_description="show help info"

. ./setup.sh

DIR_TEST=$SHARNESS_TEST_DIRECTORY/t0003

test_expect_success "show help file" '
    git init
    cp ../.simplecov .
    export COVERAGE_NAME=help
    if test "$COVERAGE" = "yes"
    then
       $COMMAND -h 2>&1 | head -n -3 > out
    else
       $COMMAND -h > out 2>&1
    fi
    diff out $DIR_TEST/help.out
    rm out
'

test_done
