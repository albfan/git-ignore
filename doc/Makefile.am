PANDOC ?= /usr/bin/pandoc
MANSECTION ?= 1
PANDOCFLAGS=--metadata title=GIT-IGNORE \
	    --metadata date=12/06/2020 \
	    --metadata hyphenate=false \
	    --metadata=adjusting=l \
	    --metadata footer="Git Ignore 1.0" \
	    --metadata header="Git Ignore" \
	    --metadata section=$(MANSECTION)


PANDOC_COMMAND = $(PANDOC) --standalone $(PANDOCFLAGS) --to man

%.$(MANSECTION): %.$(MANSECTION).md
	$(PANDOC_COMMAND) $< -o $@

dist_man1_MANS = git-ignore.1
