#!/bin/sh

SHARNESS_TEST_EXTENSION="sh"

test_description="Ignoring files"

. sharness/sharness.sh

DIR_TEST=$SHARNESS_TEST_DIRECTORY/t0002

test_expect_success "Ignoring a single file" '
    mkdir repo &&
    cd repo &&
    git init &&
    touch file1 &&
    git ignore -i file1 &&
    git status --porcelain > ../out &&
    diff $DIR_TEST/single.status ../out
'

test_expect_success "Ignoring a bunch of files" '
    mkdir repo &&
    cd repo &&
    git init &&
    touch file1 &&
    touch file2 &&
    git ignore -i "file*" &&
    touch file3 &&
    git status --porcelain > ../out &&
    diff $DIR_TEST/bunch.status ../out
'

test_done
