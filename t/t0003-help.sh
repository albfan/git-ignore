#!/bin/bash

test_description="show help info"

. ./setup.sh

test_expect_success "show help file" "
    git init
    cp ../.simplecov .
    export COVERAGE_NAME=help
    diff $DIR_TEST/help.out <($COMMAND -h 2>&1)
"

test_done
