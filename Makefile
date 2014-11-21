EXECUTABLE=git-ignore
MAN_DIR=doc/man
MAN_PAGE=git-ignore.1

BIN_PATH=/usr/bin
MAN_PATH=/usr/share/man

all:

install:
	install -Dm 644 $(MAN_DIR)/$(MAN_PAGE)   $(MAN_PATH)/man1/$(MAN_PAGE)
	install -Dm 775 $(EXECUTABLE) $(BIN_PATH)/$(EXECUTABLE)
	gzip -f9 $(MAN_PATH)/man1/$(MAN_PAGE)

uninstall:
	rm -f $(BIN_PATH)/$(EXECUTABLE)
	rm -f $(MAN_PATH)/man1/$(MAN_PAGE).gz

.PHONY: install uninstall
