#!/bin/bash

test_description="Ignoring files"

. ./setup.sh

test_expect_success "Ignoring a single file" "
    echo $0
    ps -p $$
    ls -l /proc/$$/exe | sed 's%.*/%%'
    tree /proc/$$
    git init
    cp ../.simplecov .
    export COVERAGE_NAME=ignore
    touch file1
    $COMMAND -i file1
    rm .simplecov
    diff $DIR_TEST/single.status <(git status --porcelain)
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
    diff $DIR_TEST/bunch.status <(git status --porcelain) 
"

test_done
