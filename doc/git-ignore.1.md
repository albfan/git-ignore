# NAME

**git-ignore** - Get rid of those noisy files

# SYNOPSIS

| *git* *ignore* [-x|--exclude | -i|--ignore | -f|--file]
|            [-l|--list | -e|--edit] [-u|--untracked]
|            [--remove-last] [-h|--help]

# DESCRIPTION

Easy configuration of git ignored and excluded files

# OPTIONS

-r, --relative
:   File target .gitignore in current directory.

-g, --global
:   File target global ignore config (defined on git config --global --get core.excludesFile).

-x, --exclude
:   File target .git/info/exclude (default).

-i, --ignore
:   File target .git/../.gitignore.

-f, --file
:   Use custom target file FILE

-l, --list
:   Show content of target file.

-e, --edit
:   Opens editor for target file.

-u, --untracked
:   Exclude all untracked files.

--remove-last
:   Remove last line of target file.

-a, --add=REGEX
:   Add REGEX to target file (must take care of shell expansion) though as a verbose command for scripting.

-h, --help
:   Shows this help.

-v, --version
:   Shows git ignore version.

# FILES

.git/info/exclude

:   Per-repo excludes.

.gitignore

:   Shared repo ignores.

# EXAMPLES

$ git ignore target/
: Any target directory is excluded

$ git ignore -i .project .classpath .settings/
: These files and directories are ignored 

$ git ignore -i .idea/ '*.ipr' '*.iws' -x target/
: These directory and regex matching files are ignored. target dir is excluded
$ git ignore -x --add '*.bak'
: Add to exclude config file

$ git ignore -x -e
: Edit exclude config file

# REPORTING BUGS

Issue tracker: <https://github.com/albfan//git-ignore/issues>

# AUTHOR

Alberto Fanjul <albertofanjul@gmail.com>

# SEE ALSO

**git(1)**, **git-config(1)**
