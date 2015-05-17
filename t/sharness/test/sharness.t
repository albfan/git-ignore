#!/bin/sh
#
# Copyright (c) 2011-2013 Mathias Lafeldt
# Copyright (c) 2005-2013 Git project
# Copyright (c) 2005-2013 Junio C Hamano
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see http://www.gnu.org/licenses/ .

test_description='Test Sharness itself'

. ./sharness.sh

test_expect_success 'success is reported like this' '
	:
'
test_expect_failure 'pretend we have a known breakage' '
	false
'

run_sub_test_lib_test () {
	name="$1" descr="$2" # stdin is the body of the test code
	mkdir "$name" &&
	(
		cd "$name" &&
		cat >".$name.t" <<-EOF &&
		#!$SHELL_PATH

		test_description='$descr (run in sub sharness)

		This is run in a sub sharness so that we do not get incorrect
		passing metrics
		'

		# Point to the test/sharness.sh, which isn't in ../ as usual
		. "\$SHARNESS_TEST_DIRECTORY"/sharness.sh
		EOF
		cat >>".$name.t" &&
		chmod +x ".$name.t" &&
		export SHARNESS_TEST_DIRECTORY &&
		./".$name.t" --chain-lint >out 2>err
	)
}

check_sub_test_lib_test () {
	name="$1" # stdin is the expected output from the test
	(
		cd "$name" &&
		! test -s err &&
		sed -e 's/^> //' -e 's/Z$//' >expect &&
		test_cmp expect out
	)
}

test_expect_success 'pretend we have a fully passing test suite' "
	run_sub_test_lib_test full-pass '3 passing tests' <<-\\EOF &&
	for i in 1 2 3
	do
		test_expect_success \"passing test #\$i\" 'true'
	done
	test_done
	EOF
	check_sub_test_lib_test full-pass <<-\\EOF
	> ok 1 - passing test #1
	> ok 2 - passing test #2
	> ok 3 - passing test #3
	> # passed all 3 test(s)
	> 1..3
	EOF
"

test_expect_success 'pretend we have a partially passing test suite' "
	test_must_fail run_sub_test_lib_test \
		partial-pass '2/3 tests passing' <<-\\EOF &&
	test_expect_success 'passing test #1' 'true'
	test_expect_success 'failing test #2' 'false'
	test_expect_success 'passing test #3' 'true'
	test_done
	EOF
	check_sub_test_lib_test partial-pass <<-\\EOF
	> ok 1 - passing test #1
	> not ok 2 - failing test #2
	#	false
	> ok 3 - passing test #3
	> # failed 1 among 3 test(s)
	> 1..3
	EOF
"

test_expect_success 'pretend we have a known breakage' "
	run_sub_test_lib_test failing-todo 'A failing TODO test' <<-\\EOF &&
	test_expect_success 'passing test' 'true'
	test_expect_failure 'pretend we have a known breakage' 'false'
	test_done
	EOF
	check_sub_test_lib_test failing-todo <<-\\EOF
	> ok 1 - passing test
	> not ok 2 - pretend we have a known breakage # TODO known breakage
	> # still have 1 known breakage(s)
	> # passed all remaining 1 test(s)
	> 1..2
	EOF
"

test_expect_success 'pretend we have fixed a known breakage' "
	run_sub_test_lib_test passing-todo 'A passing TODO test' <<-\\EOF &&
	test_expect_failure 'pretend we have fixed a known breakage' 'true'
	test_done
	EOF
	check_sub_test_lib_test passing-todo <<-\\EOF
	> ok 1 - pretend we have fixed a known breakage # TODO known breakage vanished
	> # 1 known breakage(s) vanished; please update test(s)
	> 1..1
	EOF
"

test_expect_success 'pretend we have fixed one of two known breakages (run in sub sharness)' "
	run_sub_test_lib_test partially-passing-todos \
		'2 TODO tests, one passing' <<-\\EOF &&
	test_expect_failure 'pretend we have a known breakage' 'false'
	test_expect_success 'pretend we have a passing test' 'true'
	test_expect_failure 'pretend we have fixed another known breakage' 'true'
	test_done
	EOF
	check_sub_test_lib_test partially-passing-todos <<-\\EOF
	> not ok 1 - pretend we have a known breakage # TODO known breakage
	> ok 2 - pretend we have a passing test
	> ok 3 - pretend we have fixed another known breakage # TODO known breakage vanished
	> # 1 known breakage(s) vanished; please update test(s)
	> # still have 1 known breakage(s)
	> # passed all remaining 1 test(s)
	> 1..3
	EOF
"

test_expect_success 'pretend we have a pass, fail, and known breakage' "
	test_must_fail run_sub_test_lib_test \
		mixed-results1 'mixed results #1' <<-\\EOF &&
	test_expect_success 'passing test' 'true'
	test_expect_success 'failing test' 'false'
	test_expect_failure 'pretend we have a known breakage' 'false'
	test_done
	EOF
	check_sub_test_lib_test mixed-results1 <<-\\EOF
	> ok 1 - passing test
	> not ok 2 - failing test
	> #	false
	> not ok 3 - pretend we have a known breakage # TODO known breakage
	> # still have 1 known breakage(s)
	> # failed 1 among remaining 2 test(s)
	> 1..3
	EOF
"

test_expect_success 'pretend we have a mix of all possible results' "
	test_must_fail run_sub_test_lib_test \
		mixed-results2 'mixed results #2' <<-\\EOF &&
	test_expect_success 'passing test' 'true'
	test_expect_success 'passing test' 'true'
	test_expect_success 'passing test' 'true'
	test_expect_success 'passing test' 'true'
	test_expect_success 'failing test' 'false'
	test_expect_success 'failing test' 'false'
	test_expect_success 'failing test' 'false'
	test_expect_failure 'pretend we have a known breakage' 'false'
	test_expect_failure 'pretend we have a known breakage' 'false'
	test_expect_failure 'pretend we have fixed a known breakage' 'true'
	test_done
	EOF
	check_sub_test_lib_test mixed-results2 <<-\\EOF
	> ok 1 - passing test
	> ok 2 - passing test
	> ok 3 - passing test
	> ok 4 - passing test
	> not ok 5 - failing test
	> #	false
	> not ok 6 - failing test
	> #	false
	> not ok 7 - failing test
	> #	false
	> not ok 8 - pretend we have a known breakage # TODO known breakage
	> not ok 9 - pretend we have a known breakage # TODO known breakage
	> ok 10 - pretend we have fixed a known breakage # TODO known breakage vanished
	> # 1 known breakage(s) vanished; please update test(s)
	> # still have 2 known breakage(s)
	> # failed 3 among remaining 7 test(s)
	> 1..10
	EOF
"

test_set_prereq HAVEIT
haveit=no
test_expect_success HAVEIT 'test runs if prerequisite is satisfied' '
	test_have_prereq HAVEIT &&
	haveit=yes
'
donthaveit=yes
test_expect_success DONTHAVEIT 'unmet prerequisite causes test to be skipped' '
	donthaveit=no
'
if test $haveit$donthaveit != yesyes
then
	say "bug in test framework: prerequisite tags do not work reliably"
	exit 1
fi

test_set_prereq HAVETHIS
haveit=no
test_expect_success HAVETHIS,HAVEIT 'test runs if prerequisites are satisfied' '
	test_have_prereq HAVEIT &&
	test_have_prereq HAVETHIS &&
	haveit=yes
'
donthaveit=yes
test_expect_success HAVEIT,DONTHAVEIT 'unmet prerequisites causes test to be skipped' '
	donthaveit=no
'
donthaveiteither=yes
test_expect_success DONTHAVEIT,HAVEIT 'unmet prerequisites causes test to be skipped' '
	donthaveiteither=no
'
if test $haveit$donthaveit$donthaveiteither != yesyesyes
then
	say "bug in test framework: multiple prerequisite tags do not work reliably"
	exit 1
fi

clean=no
test_expect_success 'tests clean up after themselves' '
	test_when_finished clean=yes
'

if test $clean != yes
then
	say "bug in test framework: basic cleanup command does not work reliably"
	exit 1
fi

test_expect_success 'tests clean up even on failures' "
	test_must_fail run_sub_test_lib_test \
		failing-cleanup 'Failing tests with cleanup commands' <<-\\EOF &&
	test_expect_success 'tests clean up even after a failure' '
		touch clean-after-failure &&
		test_when_finished rm clean-after-failure &&
		(exit 1)
	'
	test_expect_success 'failure to clean up causes the test to fail' '
		test_when_finished \"(exit 2)\"
	'
	test_done
	EOF
	check_sub_test_lib_test failing-cleanup <<-\\EOF
	> not ok 1 - tests clean up even after a failure
	> #	Z
	> #	touch clean-after-failure &&
	> #	test_when_finished rm clean-after-failure &&
	> #	(exit 1)
	> #	Z
	> not ok 2 - failure to clean up causes the test to fail
	> #	Z
	> #	test_when_finished \"(exit 2)\"
	> #	Z
	> # failed 2 among 2 test(s)
	> 1..2
	EOF
"

test_expect_success 'cleanup functions tun at the end of the test' "
	run_sub_test_lib_test cleanup-function 'Empty test with cleanup function' <<-\\EOF &&
	cleanup 'echo cleanup-function-called >&5'
	test_done
	EOF
	check_sub_test_lib_test cleanup-function <<-\\EOF
	1..0
	cleanup-function-called
	EOF
"

test_expect_success 'We detect broken && chains' "
	test_must_fail run_sub_test_lib_test \
		broken-chain 'Broken && chain' <<-\\EOF
	test_expect_success 'Cannot fail' '
		true
		true
	'
	test_done
	EOF
"

test_done

# vi: set ft=sh :
