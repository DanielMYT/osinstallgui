# osinstallgui
Extremely fast and minimal GUI installer for GNU/Linux operating systems.

![](osinstallgui.png)

# Information
**osinstallgui** is an extremely fast and minimal GUI installer for GNU/Linux
operating systems written entirely in Bash. It makes use of **yad** to provide
an intuitive dialog-based GTK3 graphical interface, which aims to be fast,
intuitive, and no-nonsense. **osinstallgui** has also been designed to be
easily adaptable and customisable, to allow it to be used by almost any
GNU/Linux distribution.

**osinstallgui** was originally created in December 2024, as a full rewrite of
the TUI-based installation program from MassOS, using GTK3-based **yad**
instead of ncurses-based **dialog**. However, it has also been redesigned
and reimagined from the ground-up to be more distribution-independent, through
the use of a single well-documented configuration file which can be customized
to suit the needs of other distribution maintainers. The underlying logic has
also been completely revamped, so as to make the program more reliable under
the hood, as well as easier to maintain.

**osinstallgui** is the defacto installation program used in MassOS, as of the
development of MassOS being picked up in January 2025.

# Development Status
As of **April 2025**, **osinstallgui** is still in development. Some features
are not yet present, and some functionality is in the process of being added or
improved. However, the installer itself is usable and should be mostly stable
and bug-free.

All additional functionality we want to be present in **osinstallgui**, and are
continuously working on implementing, is expected to be present when the
project gets its first **1.x.x** release. The current versions of the software
are given as **0.x.x**, to indicate that they are pre-releases and may be
subject to change at short notice. The [FAQ document](FAQ.md) has more
information about how **osinstallgui** is and will be versioned.

# Dependencies
Please note that all dependencies listed here use their upstream package names.
Many distros package libraries, services and utilities separately. Unless
otherwise stated, when a package is listed here, it is referring to the ENTIRE
package, but particularly its command-line utilities.

## Required dependencies
- **Bash**, to run the program (version **4.0** or higher is required).
- **dosfstools**, to allow creation of a FAT32 EFI System Partition.
- **e2fsprogs**, to allow the user to use ext4 for the root partition (even if
  **btrfs-progs** is installed as mentioned below, this package is still
  mandatory for compatibility reasons).
- **gptfdisk**, for the erase disk functionality.
- **GRUB**, for the bootloader (installed on the target system).
- **libxkbcommon**, for finding available X11 keyboard layouts.
- **parted**, for the erase disk functionality.
- **squashfs-tools**, for extracting rootfs images. Mandatory for compatibility
  reasons, even if a tar-based rootfs is used instead.
- **yad**, for the GTK3 GUI.
- **yq**, for finding available X11 keyboard layouts.

## Recommended dependencies
- **btrfs-progs**, to allow the user to use btrfs for the root partition (if
  present, the user will be given the choice as to whether they want to use
  ext4 or btrfs, unless `OSINSTALLGUI_ALLOW_BTRFS` is set to `0` in the
  osinstallgui configuration file).
- **cryptsetup**, to allow the user to enable disk encryption using LUKS (if
  not present, the user will not be given such a choice - if it IS present,
  you can set `OSINSTALLGUI_ALLOW_LUKS` to `0` in osinstallgui's configuration
  file to forcibly disable it). Please note that the GRUB bootloader may need
  modifications to be able to properly support booting from a LUKS encrypted
  partition - see the FAQ document for details.
- **dmidecode**, to allow the system model to be determined, for the default
  hostname (if not present, "PC" will be used as a fallback, but the user can,
  of course, still customize the hostname themselves and override the default).
- **gparted**, to allow the user to manually create/modify partitions using
  this external program. The manual partitioning option will be unavailable if
  this is not present.
- **polkit**, for the `pkexec` utility, which is required for osinstallgui to
  run unprivileged (running wholly as root does not require `pkexec`).

## Optional dependencies
- **cracklib**, to enable enforcing of strong passwords for user accounts.
  Requires `OSINSTALLGUI_USER_PWSCORE` to be set to `1` in the osinstallgui
  configuration file. It only really makes sense to use if your distro's build
  of shadow was configured to use libcrack, so as to be consistent with the
  behaviour of `passwd`. Using this option may annoy "those" users who for some
  reason are completely incapable of setting and using semi-secure passwords.
- **systemd**, for finding available keymaps using `localectl`, as a faster
  alternative to manually searching through system files. If present, you can
  also set the `OSINSTALLGUI_KEYMAPS_SYSTEMD` option to decide whether you want
  `localectl` to be used or not.

# Installation
osinstallgui uses a Makefile-based approach to installation. The `make` utility
will be needed to interact with this.

First, you have to prepare the program for installation. This is because in its
default state from the source tree, it is not configured to understand where to
search for its configuration and data files. You can prepare it by running the
following command:
```
make
```
By default, this will set the directory for config and data to
`/usr/share/osinstallgui`. If this is undesired, you can customize it by
instead using the following command:
```
make DATADIR=/path/to/custom/datadir
```
After the program is prepared, it can be installed with the following command,
which may require root privileges depending on your environment:
```
make install
```
If you customized the data directory as mentioned above, then instead run the
following command to ensure the files get installed in the same place:
```
make DATADIR=/path/to/custom/datadir install
```
You may also wish to customize where the binary gets installed (the default
location is `/usr/bin`). Note that this option only needs to be passed during
installation, and doesn't need to be set during the preparation stage. It can
be set instead of or as well as the DATADIR option:
```
make BINDIR=/path/to/custom/bindir DATADIR=/path/to/custom/datadir install
```
If creating a distro package, then you can also use the `DESTDIR` option as you
should be familiar with from packaging other software. `DESTDIR` doesn't affect
the other options, which should still be relative to where the program will
be run from when the package is installed.

# Configuration
osinstallgui needs to be correctly configured to function properly (or at all)
as an installer for your distro. The sample configuration file in the source
tree, **osinstallgui.conf**, should be modified as necessary for your distro.
All possible configuration options are described in detail in this file. You
can either edit the file directly in the source tree, or edit it after it has
been installed (see the **Installation** section above). The comments in the
configuration file describe which options are **mandatory** (the program won't
run without them), and which are **optional** (the program will assume defaults
if they are unset). For robustness, we always recommend ensuring every possible
configuration option is set, however.

# Running
As of **osinstallgui** version `0.13.0`, the program now supports being run
either wholly privileged (as root), or unprivileged (as a normal user). The
former option was the only available method in older versions, and it has the
limitation of not being able to run under Wayland sessions, which are more
restrictive/hardened in nature compared to Xorg sessions.

The latter option is now recommended for use on modern systems. This will cause
the program itself to run unprivileged, and only elevate privileges as and when
it needs to as part of the system installation process. It will do this by
using `pkexec` - thus, it requires **Polkit** to be installed on the host
system. Furthermore, a suitable Polkit rule is also strongly recommended to be
in use for the live system user, which succeeds authentication by default
without prompting for a password (as should be consistent with sudo and other
authentication programs that may be used by the live user under a live CD). If
there is no such rule, then the user will be bombarded with password prompts
throughout the program's execution, which is not ideal. A suitable Polkit rule
may look like the following:
```js
// Potential location for this file: /etc/polkit-1/rules.d/49-live.rules
// Example rule to auto-succeed elevation without password in live environment.
// Remember to replace the placeholder with the actual username of live user.
polkit.addRule(function(action, subject) {
  if (subject.isInGroup("<USERNAME-OF-LIVE-USER>")) {
    return polkit.Result.YES;
  }
});
```

# Desktop Integration
Two example desktop files are provided in this source tree, but they do not get
installed by default. The file named **osinstallgui.desktop.example** is the
_TRADITIONAL_ running method, where the program runs entirely as root. As
discussed above, as of version of `0.13.0`, the program can now run
unprivileged. For this, there is a new separate desktop entry called
**osinstallgui.desktop.example.unprivileged**. To integrate properly into a
desktop environment, you should customize one of the aforementioned files, and
install it into a suitable location, such as
`/usr/share/applications/osinstallgui.desktop` (taking note that the
**.example** part is removed). You can also place the file on the desktop of
the live user's account, if desired, for additional convenience.

In both files, you can customize the `Name=` and `Comment=` fields, to make it
specific for your own distro. You can put your distro's name/version here. You
can also point the `Icon=` field to your distro's logo or something similar.

The **.example.unprivileged** file does not require any further customization.
However, the **.example** (wholly-privileged) file will require the following
further customization:

You also need to replace the `<user>` placeholder in the `Exec=` line in order
for the program to launch properly. It should be set to the username of the
Live CD user. For example, the full line might look like this when edited:
```
Exec=pkexec env DISPLAY=":0" XAUTHORITY="/home/live/.Xauthority" osinstallgui
```

Note that the `pkexec` command listed in the desktop entry file is written in
such a way to ensure the program runs successfully. Unlike `sudo`, which would
respect the user's environment variables, `pkexec` does not. As a result, GUI
programs will not correctly run as root unless the `DISPLAY` and `XAUTHORITY`
environment variables are manually set. This is why a modification is required
as described above. Alternatively, you can use the other desktop file, which
runs the program unprivileged, and therefore does not require any such quirk or
modification (but may instead require a Polkit rule as described above).

# Troubleshooting
If something goes wrong during the installation, it's very possible that it was
caused by misconfiguration. When a problem occurs, the utility will inform you
of where the log file is saved; you can examine this file in a text document to
hopefully gauge some information as to what exactly went wrong. It may also be
beneficial to observe the command-line output if any, i.e., by running
`osinstallgui` from a terminal instead of from a desktop entry. It's also
possible that the program does not yet have a failsafe to gracefully deal with
your specific misconfiguration - if this is the case, please open an issue on
the GitHub repository and ensure you include the contents of the aforementioned
log file.

Please also see the [FAQ document](FAQ.md), which lists various known issues
that could occur, and potential solutions/workarounds for them.
