# Intro
This tries to commplete a missing command from git toolchain.

By the years I found that powerful of git ignore is hide by complexity of touch internal .git directory.
It is scary for some people, but the fact is all the git commands just touch .git directory internals, that's 
obvious but is good to be rememeber.

This tools focus to mitigate this fear and allow easy configuration of ignored files from your projects, allowing
a good distinction between what you want to exclude privately or what you want to ignore publicly

# Install

```bash
sudo make install
```
# Uninstall
```bash
sudo make uninstall
```

# Examples

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

 $ git ignore target
 $ git ignore -i .project .classpath .settings
 $ git ignore -i .idea/ '*.ipr' '*.iws' -x target
 $ git ignore -x --add '*.bak'
 $ git ignore -x -e
```

