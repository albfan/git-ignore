#!/bin/bash

test_description="Excluding untracked files"

. ./setup.sh

test_expect_success "exclude untracked files" "
    git init
    export COVERAGE_NAME=untracked
    cp ../.simplecov .
    touch file1
    touch file2
    touch file3
    git add file2
    $COMMAND --untracked
    rm .simplecov
    diff $DIR_TEST/untracked.status <(git status --porcelain)
"

test_done
