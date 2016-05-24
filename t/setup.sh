. sharness/sharness.sh

export GEM_PATH=$GEM_PATH:/home/alberto/.gem/ruby/2.2.0

if test "$COVERAGE" = "yes"
then
    COMMAND="$COV_PROGRAM git-ignore"
else
    COMMAND="git ignore"
fi

export COMMAND

DIR_TEST=$SHARNESS_TEST_DIRECTORY/${0%%-*}

SHARNESS_TEST_EXTENSION="sh"
