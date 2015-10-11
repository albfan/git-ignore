# git-ignore [![Build Status](https://travis-ci.org/albfan/git-ignore.svg?branch=master)](https://travis-ci.org/albfan/git-ignore) [![Coverage Status](https://coveralls.io/repos/albfan/git-ignore/badge.svg?branch=master&service=github)](https://coveralls.io/github/albfan/git-ignore?branch=master)

## Intro

This tries to commplete a missing command from git toolchain, ignoring files.

By the years I found that powerful of git ignore is hide by complexity of touch internals on `.git` directory. It is scary for some people, but the fact is all the git commands just touch `.git` directory internals, that's obvious but is good to be remember.

So at this point, should you edit by yourself `.git/info/exclude` or cat `.gitignore` to check actual ignored files? Knowing the existence of `git config -e` and `git config -l` there must be no doubt here.

This tool focus on mitigate fear about `.git` directory -hiding its complexitys- and allow easy configuration of ignored files from your projects, allowing a good distinction between what you want to exclude privately or what you want to ignore publicly.

## Install

```bash
./autogen.sh
make
make check
sudo make install
```

## Uninstall

```bash
sudo make uninstall
```

## Examples

Take a look to the contents of command line:
 
```
Target file configuration:
   -x, --exclude    File target $FILE_EXCLUDE (default)
   -i, --ignore     File target $FILE_IGNORE
   -f, --file=FILE  Use custom target file FILE

Commands:
   -l, --list       Shows de content of target file
   -e, --edit       Opens editor for target file
   -h, --help       Shows this help

Porcelain commands:
   -a, --add=REGEX  Add REGEX to target file (must take care of shell expansion)
                     though as a verbose command for scripting

Examples:

 $ git ignore target    #ignore maven compilation on exclude file (locally)
 $ git ignore -i .project .classpath .settings    #ignore IDE config files on .gitignore
 $ git ignore -i .idea/ '*.ipr' '*.iws' -x target    #oneliner for the two commands above
 $ git ignore -x --add '*.bak'    #example for sane usage on scripts
 $ git ignore -x -e    #edit exclude file
```
# FAQ

Q: But ignoring files is a one-shot-action on projects, why should I care?
A: I would agree, in theory, but in practice I found myself revamping and modifying ignored files all the time.

Q: Why must I use '' on glob files?
A: Glob expansion is executed prior to command line arguments gets to git-ignore, you can only disable that way.

Q: `git-ignore` do not detect I have added that ignore already, I have duplicates?
A: Yes, it is not supposed that `git-ignore` parses and checks input, for reorder and strike out use `-e` option 
