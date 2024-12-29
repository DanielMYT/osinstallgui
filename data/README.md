# osinstallgui/data
This directory contains static data files, primarily about locales and keymaps,
which will be used to provide descriptions to the user in the osinstallgui
program.

For robustness, osinstallgui searches all available locales and keymaps at
runtime, but descriptions about each are usually not included on the system, so
we need to hardcode them in these data files.

If osinstallgui finds any which do not have definitions here, i.e., after an
update to glibc or kbd, then it will simply use "Unknown" as the description.

Note that osinstallgui only lists UTF-8 locales, so definitions will not be
provided for other locales.
