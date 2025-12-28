# Get the software version from the 'version.txt' file.
OSINSTALLGUI_VERSION := $(shell cat version.txt)

# Specify where the binary will get installed to.
BINDIR ?= /usr/bin

# Specify where the configuration file and data files will be saved.
# Should NOT use /etc because it is not intended to be user-modifiable.
DATADIR ?= /usr/share/osinstallgui

all: osinstallgui

osinstallgui:
	sed -e "s|@@VERSION@@|$(OSINSTALLGUI_VERSION)|g" -e "s|@@CONFPATH@@|$(DATADIR)|g" osinstallgui.in > osinstallgui
	chmod 0755 osinstallgui

install:
	install -t "$(DESTDIR)$(BINDIR)" -Dm755 osinstallgui
	install -t "$(DESTDIR)$(DATADIR)" -Dm644 osinstallgui.conf
	install -t "$(DESTDIR)$(DATADIR)/data" -Dm644 data/{locales,keymaps}.desc

uninstall:
	rm -f "$(DESTDIR)$(BINDIR)/osinstallgui"
	rm -f "$(DESTDIR)$(DATADIR)/osinstallgui.conf"
	rm -f "$(DESTDIR)$(DATADIR)/data/locales.desc"
	rm -f "$(DESTDIR)$(DATADIR)/data/keymaps.desc"

clean:
	rm -f osinstallgui

distclean: clean

help:
	@echo "This is the Makefile for osinstallgui $(OSINSTALLGUI_VERSION):"
	@echo ""
	@echo "  Run 'make' to prepare the program for installation."
	@echo "  Run 'make install' as root to install the program."
	@echo "  Run 'make clean' to clean up the source tree."
	@echo ""
	@echo "Supported options (add with 'make OPTION=value'):"
	@echo ""
	@echo "  BINDIR : Program location (/usr/bin)"
	@echo "  DATADIR: Config file and data location (/usr/share/osinstallgui)"

version:
	@echo "$(OSINSTALLGUI_VERSION)"
