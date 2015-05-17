#!/bin/sh

SHARNESS_TEST_EXTENSION="sh"

test_description="Excluding files"

. sharness/sharness.sh

test_expect_success "exclude a single file" '
    git init
    touch file1
    git ignore file1
    test "" = "$(git status --porcelain)"
'

test_expect_success "exclude a bunch of files" '
    git init
    touch file1
    touch file2
    git ignore "file*"
    touch file3
    test "" = "$(git status --porcelain)"
'

test_done
