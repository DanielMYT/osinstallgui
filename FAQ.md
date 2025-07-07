# osinstallgui - Frequently Asked Questions
This document aims to answer some frequently asked questions about
**osinstallgui**, particularly common questions relating to messages and errors
that the program can display.

## Why does it exist? Why not use an existing installer?
Great question! Generally, we'd recommend using an existing installer, as they
will likely offer more features and stability. However, there are some reasons
why this might not be practical. Here are some of the most well-known graphical
installers, and problems they can cause:

- **Calamares** - A graphical installer that is distro-independent and highly
customizable. However, it requires the Qt GUI frameworks to run, which could be
undesired to install on minimal distributions and/or ones which use a GTK-based
desktop environment (these are the main reasons why MassOS has avoided it).
- **Ubiquity** - The graphical installer used by Ubuntu and its derivatives.
Unfortunately, it is heavily Ubuntu-specific and may not be practical to use on
other distributions.
- **Anaconda** - The graphical installer used by Fedora and possibly some other
RHEL-based distributions. It may be somewhat specific to the structure of
RHEL-based distros, however it's possible that it may also be more customizable
and easier to port to other distros. The authors of **osinstallgui** don't have
any knowledge of or familiarity with it.

On the other hand, using **osinstallgui** has the following advantages:

- It is very minimal, fast and lightweight.
- It is simple to configure using a single well-documented configuration file.

However:

- It does not (yet) support all advanced features that other installers do.
- It is currently in an experimental development state and not fully stable.

If you can, by all means give **osinstallgui** a try! At this stage,
contributions are also highly welcome and encouraged, particularly for fixing
any bugs, improving the program (addressing the various **TODO** comments in
the code), and adding support for features that are currently missing, but are
supported by other installers.

## How is osinstallgui versioned?
Versions follow an **X.Y.Z** versioning scheme. Semantic versioning is loosely
followed, but not enforced by any means.

- **X** will only be incremented after a huge overhaul of the entire program.
- **Y** will be incremented when a new feature or new functionality is added.
- **Z** will be incremented for minor feature updates, as well as bug fixes.

All versions beginning with **0.x.x** are considered unstable, and are subject
to changes (i.e., in the configuration files) at any time. Stable releases will
not exist until the software reaches **1.x.x** versions. After stable releases
are reached, you should not expect the configuration files to change unless the
major (**X**) version is incremented. If it does change, this will be clearly
communicated and documented. If additional features are added in minor (**Y**)
releases, **osinstallgui** will not make them mandatory in the configuration
files, so existing deployments should not need altering (unless the default
behaviour in the newly added feature is undesired).

## The dependencies seem arbitrary
We can assure you they are not. While some of **osinstallgui**'s dependencies
are fairly self-explanatory, here is a detailed explanation of why others are
required:

- **gptfdisk** and **parted**: We know what you're thinking. Why are these
  antiquated partitioning tools needed? And the answer is, the partitioning
  tools themselves aren't. **osinstallgui** uses `fdisk` to partition the disk
  under the hood, and supports the **gparted** graphical utility for manual
  partitioning. However, both packages provide supplementary utilities which
  are required for the "Erase Disk" functionality of **osinstallgui**. The
  former utility provides the `sgdisk` command, whose `-Z` option can be used
  to wipe all GPT and MBR partition tables from disks, while the latter
  provides `partprobe`, which is used to sync the disk changes with the kernel
  after partitioning is done. While the disk erasure process could, in theory,
  be done without them, using them ensures consistency and redundancy, which is
  extremely important when you are dealing with operations which could
  potentially cause data loss or disk damage if they go wrong.
- **libxkbcommon** and **yq**: These programs are required for finding the
  available X11 keymaps on the system. The former is needed because it contains
  the `xkbcli` program, which, when run as `xkbcli list`, gives a full output
  of all supported keyboard layouts and variants, along with descriptions of
  each. The `yq` program is needed because `xkbcli list` provides its output in
  the **YAML** format; only `yq` is able to convert this into a format which is
  convenient for us to interpret and process the data from. If you're in any
  sort of graphical environment, you should already have the **libxkbcommon**
  package installed. As for **yq**, it has two versions - the Go version and
  the Python version. Either should suffice, but the Go one is what we
  generally recommend, as it has fewer dependencies, and is even available to
  download and use directly as a standalone binary from its
  [GitHub releases page](https://github.com/mikefarah/yq/releases).

## Why do I need to set the keyboard layout twice?
On GNU/Linux systems, there are two different keyboard layout systems which are
not directly compatible with each other. As such, **osinstallgui** allows you
to configure the keyboard layout for both.

The first system is the console keymap. This keymap system applies to virtual
consoles (TTYs). If you've only ever used a GUI, you may have no idea what a
virtual console is - simply put, it is the non-graphical terminal session you
would interact with if you didn't have a graphical desktop environment
installed on your system. In fact, even on a GUI-based system, you can access
this virtual console by pressing the key combination **Control+Alt+F3** (press
**Control+Alt+F7** to return to your desktop). The keymap for this system is
set up in the system file `/etc/vconsole.conf`.

The second system is the X11 keymap. This keymap system applies to graphical
sessions. While you can, of course, always override the default X11 keymap by
accessing the "Keyboard Settings" in your graphical environment, when you run
**osinstallgui**, you will set the system-wide default. This system uses the
configuration file `/etc/X11/xorg.conf.d/00-keyboard.conf`. It is incompatible
with console keymaps because it makes use of variants; while in the console
keymap system, each keymap+variant is a separate layout, in the X11 keymap
system, multiple variants can be associated with one single keymap. To simplify
this process for users, **osinstallgui** displays each possible variant as a
separate keymap which you can select, but under the hood, the layout and
variant options are set separately. Additionally, some layout names differ
between console and X11 maps. For example, **English (United Kingdom)** is `uk`
in the console keymap system, while it is `gb` in the X11 keymap system.

## Why am I asked about creating a fully portable installation?
The fully portable mode offered by **osinstallgui** is designed to faciliate
the installation onto a removable drive, such as a USB flash drive, or portable
HDD/SSD, instead of an internal drive on the system. Installing onto a
removable drive not only has the advantage that your internal disks will be
entirely untouched and unaltered, but it also gives you the ability to use the
new installation - along with all the data and programs on the installation -
on any other computer system. It's like a Swiss Army Knife in your pocket! Now
you might argue that this can be done with a regular Live ISO image written to
a flash drive - and this is true - but live environments do not have any form
of persistence. Once you finish using the live environment, all data on it is
gone, and the entire environment is reset to how it would be on its first
startup. By contrast, the fully portable OS installation on a removable drive,
preserves all your applications, files, and settings, so you can start on one
computer - switch to another in an entirely different place - and pick up right
where you left off! Additionally, the fully portable mode will install a hybrid
version of the **GRUB** bootloader - that is, one which will allow the drive to
boot on systems using either Legacy BIOS or UEFI - something that the normal
installation mode does not support - but maximises support across a wide range
of both old and new computer systems. It achieves this by partitioning the disk
in a certain way, such that both Legacy BIOS and UEFI systems can read from it
and boot from it.

Now the purpose of this option has been explained, the answer as to whether you
want to use it or not should be made obvious. You **MUST NOT** use it if you
are installing on an internal hard drive or SSD. You also probably don't want
to use it if the drive is "removable", but is still intended to be connected to
the same single system, and will not be moved to other systems. Additionally,
it should be noted that the fully portable installation always erases all data
on the entire drive - there is no option for "manual partitioning". Therefore,
if you want to use manual partitioning instead - you **CANNOT** use the fully
portable option. However, if you are OK with wiping the entire removable drive,
and want the benefits that come with fully portable mode, then it's ideal to
use. Note, however, that due to the nature of portable drives, and their easy
ability to get lost/stolen, you almost certainly want to use **encryption**.
So you may wish to read the **What is LUKS encryption and do I need it?**
section below.

This "fully portable" installation option replaces the older prompt given to
the user, in **osinstallgui** versions prior to `0.9.0`, as to whether they
wanted to install the UEFI bootloader in "internal" mode or "removable" mode.
The information about this has been kept in this document, and can be seen in
the **Why am I asked about installing GRUB in Internal or Removable mode?**
section below, as it is still somewhat relevant. Just like that older option,
the fully portable mode in newer versions of **osinstallgui** will install the
UEFI bootloader in removable mode, and will not touch the UEFI variables of the
system used to create the installation.

## What is an EFI system partition and why do I need one?
Modern computers generally boot in UEFI mode instead of the older Legacy BIOS
mode, primarily due to it being faster and easier to maintain. The main
difference between Legacy BIOS and UEFI mode is where the bootloader is stored.
On Legacy BIOS systems, the bootloader gets installed into the MBR (Master Boot
Record) of the disk, which is a small hidden area reserved for the bootloader.
By contrast, on UEFI systems, whereby disks commonly use the GPT partitioning
scheme instead of MBR, there is no such area. Instead, UEFI bootloaders are
installed onto a separate regular partition on the drive (known as, you guessed
it, the EFI system partition). This partition is generally small (around 100MiB
to 500MiB), but the main requirement is that the partition needs to use the
**FAT32** filesystem, which is the only filesystem supported by the majority of
UEFI firmware implementations. And, as you may already know, modern operating
systems cannot be installed onto a **FAT32** filesystem, as it has too many
limitations. Instead, Windows is installed on **NTFS**, and GNU/Linux is
generally installed on either **ext4** or **btrfs**. This is why a separate
partition is needed, and the root partition for the OS cannot be used.

When you choose the "Erase Disk" method of **osinstallgui**, the installer will
automatically create an EFI system partition as part of its process. If you are
instead using the "Existing partition" method, you are required to select the
EFI system partition to use for the installation. If you are dual-booting with
another OS, it is very likely that one already exists - and you can safely use
it. Multiple UEFI bootloaders (for different operating systems) can share the
same EFI partition, and will not conflict with each other, and the partition
will not need to be re-formatted if it is already **FAT32**.

## No physical disks were found
Here are the following most likely causes of your internal disk failing to be
detected, including how you may be able to fix them.

### SATA mode not set to AHCI
Your system may default to setting the **SATA Mode** or **Storage Mode** of
internal disks to **RAID** or **Intel RST**. This will cause them to be
unusable by GNU/Linux. To change it, you need to enter your BIOS settings
(usually by pressing **ESC**, **DEL**, or one of the function keys on startup).
You can also automatically reboot to the firmware setup on UEFI systems using
the following command:
```
systemctl reboot --firmware-setup
```

The option to change the SATA mode may be under **Advanced Settings**. Once
you've found it and changed it, you can save and exit the BIOS settings (often
by pressing the **F10** key), and the disk should now display in
**osinstallgui**.

Note that there may also be other RAID or RST-related options in the BIOS. If
changing the SATA mode alone doesn't fix it, then ensure those other options
are also turned off.

### Windows Bitlocker drive encryption
Modern versions of Windows have **Bitlocker** (or a similar disk encryption
system) enabled by default. In some cases, this can cause your internal drive
to fail to be detected. Since Bitlocker drive encryption is a security measure,
especially on portable devices like laptops which may be stolen, you may not
want to disable it. If this is the case, we recommend instead installing on a
different internal disk if you have one, or a portable SSD/HDD if you don't.

Note that on the Home edition of Windows, Bitlocker may instead be named
**Windows Device Encryption** or something similar, and accessible from normal
Windows settings instead of control panel.

Once Bitlocker is disabled, your disk should now show up.

## What is LUKS encryption and do I need it?
LUKS encryption is a method of encrypting the root filesystem of your new OS
installation, such that no-one with physical access to the machine can access
your data without a decryption passphrase created by and only known by you. It
may also sometimes be referred to as "full disk encryption", but this name is
misleading, since only the root filesystem of the OS you are installing needs
to be (and should be) encrypted, thus allowing the rest of the disk to be
managed by whatever other operating systems may be installed on your system.
Support for LUKS encryption was added to **osinstallgui** in version `0.8.0`.

Encryption of the data on your operating system, which includes both the system
files/apps, and the personal files in your home directory, is extremely useful
and often recommended for portable devices such as laptops, which may be at
risk of theft. If someone does steal your laptop, and your data is encrypted,
then the thief will have no way to access that data without knowing your
encryption passphrase. However, LUKS encryption can also come with some
downsides. This includes slightly (though often unnoticeable) more overhead
when performing IO-intensive disk operations, as well as less convenience when
it comes to performing system recovery or debugging an existing GNU/Linux
installation from a separate live environment.

### Important notes about LUKS encryption
- If you select to enable LUKS when prompted by **osinstallgui**, you will be
  required to create an encryption passphrase. This passphrase does not need to
  match the root password or user password you set up in a previous step of the
  installation process, but **SHOULD** be both secure and memorable.
- You will be required to enter the encryption passphrase every time you boot
  up the system.
- If you ever forget the encryption passphrase, your data will be gone forever.
  Due to the nature of encryption, and its goal of being secure, the **ONLY**
  way to decrypt your data is by using the same passphrase it was encrypted
  with. There is no other "recovery" option available.

### Requirements for LUKS support in osinstallgui
- The **cryptsetup** program must be installed on the system (that is, both the
  live environment running the installer, and inside the rootfs image that
  **osinstallgui** will install the full system from). If it is not installed,
  **osinstallgui** will automatically disable LUKS support at runtime, and
  therefore not ask the user about whether or not they want to use LUKS.
- `GRUB_ENABLE_CRYPTODISK="y"` must be set in the file `/etc/default/grub`, and
  not commented out, which may be the default. This only applies to the rootfs
  image that **osinstallgui** uses to install the full system. Without it, the
  GRUB bootloader will be unable to boot from the LUKS-encrypted volumes, thus
  rendering the new installation unusable.
- GRUB itself must be patched or have hooks in place to insert the necessary
  command-line parameters for booting from a LUKS-encrypted volume. The exact
  parameters needed will depend on the initramfs system in use. But GRUB, in
  its pure vanilla state, may make use of command-line arguments that are not
  appropriate for LUKS setups. The patch used in MassOS for dracut can be found
  [here](https://github.com/MassOS-Linux/MassOS/blob/development/patches/grub-2.12-luksdracut.patch).
- `OSINSTALLGUI_ALLOW_LUKS` must not be set to `0` in the **osinstallgui**
  configuration file (either set to `1`, or omitted, which defaults to `1`).

## Why am I asked about installing GRUB in Internal or Removable mode?
**NOTE:** This information is only relevant to an older version of
**osinstallgui**. Versions `0.9.0` and newer have replaced with option with a
new "fully portable" mode option, which is described in a section above. The
information is left here for historical purposes, and because it is interesting
to read and understand.

The GRUB UEFI bootloader can be installed in either "Internal" or "Removable"
mode. At the low-level, this is done by omitting or including the `--removable`
argument when running the `grub-install` command. The goal of this option is to
make it easier to boot the system based on which type of drive you are
installing the operating system to.

The default behaviour of GRUB, when installing in UEFI mode, is to install in
"Internal" mode. This installs the bootloader to a standard isolated location
on the EFI system partition (`EFI\<osname>\grubx64.efi`), and then creates a
boot-order entry in the system's UEFI NVRAM (which is part of the system's
firmware and unrelated to the disk). This is sufficient when the operating
system is being installed on an internal disk, and is necessary to ensure that
each installed operating system (in a dual-boot setup) does not conflict with
any others. Unfortunately, this causes a series of problems when the disk is
not internal, and is instead a removable drive, such as a portable SSD or USB
flash drive.

You see, when you are installing to a removable drive, you expect that, after
the initial installation is done, you will be able to move that drive to any
system and boot the same OS (with all your files and apps preserved) on any
other computer. And unfortunately for you, this will be inconvenient (or maybe
impossible) if the GRUB bootloader has been installed in "Internal" mode.
Because the only (trivial) way to boot the system is using that same boot-order
entry in the NVRAM, which, as previously mentioned, is part of the system's
firmware itself, and is not on the disk. Furthermore, that original system is
now tainted, because it contains a boot-order entry in its firmware which is
completely unusable, because it points to a disk that is no longer connected to
that system. Hopefully you are now understanding why this is problematic to say
the least.

By contrast, if you choose to install in "Removable" mode, the bootloader gets
installed to the fallback location (`EFI\BOOT\BOOTX64.EFI`) instead of the
standard location. This fallback location is what UEFI firmwares look for in
order to boot from a disk directly. As such, you are able to boot from the disk
by selecting the disk itself in the system's boot menu, instead of relying on a
boot-order entry. Furthermore, "Removable" mode takes care to ensure it does
not, under any circumstance, touch the system's NVRAM. Overall, this means that
the installation is now portable and usable on any other machine, as intended,
and the original system used for installation does not have its NVRAM tainted.

However, this does not, under any circumstance, mean that "Removable" should
always be used no matter what. "Internal" mode should still be used for
internal installations, because on internal disks, especially ones containing
a dual-boot, there may already a fallback loader installed at the fallback
location on the EFI system partition. As such, "Removable" mode would cause
that fallback loader to be overridden, which could cause problems. Indeed, the
boot-order in the UEFI NVRAM is crucial for these setups, and is likely what
your main system is already using, even if you aren't aware of it. So overall,
you should choose the option that is applicable to your installation type.

Most GNU/Linux installers exclude this option altogether. What this means is
that it will be far more difficult to make a persistent portable installation.
While the argument could be made that very few users want or need to do this,
this shouldn't have to mean that anyone who wants to is unable to. And indeed,
it means that anyone who does want to will have to manually re-install the
bootloader in removable mode, which will likely have to be done by manually
mounting the disk partitions, chrooting into the installation, running the
`grub-install` command themself, etc. It is for this reason that the developers
of **osinstallgui** have made the decision to include this option. We have made
sure that the process of selecting the option is as straightforward and trivial
as possible, including by displaying the choice as a menu, clearly indicating
"Internal" mode to be the default, as well as adding a "Help" option to help
users decide if they are completely unsure.

Note that this option is inapplicable to systems booted in Legacy BIOS mode,
since the Legacy BIOS bootloader always gets installed to the MBR (reserved
area) of the disk anyway. As a result, you won't be given this option if your
system is booted in Legacy BIOS mode instead of UEFI.

## There is no Windows boot option after installation for a dual-boot
There exists a known bug with the **os-prober** package, whereby it is unable
to detect a Windows installation while in a chroot environment. As a result,
Windows does not get added as a boot entry to the GRUB menu like it should.
This is not a bug specific to one distro, and in fact it has been reported on
many distros, including the following:

- https://www.reddit.com/r/archlinux/comments/10gyqjs/osprober_wont_detect_windows/
- https://www.reddit.com/r/artixlinux/comments/ldg00f/osprober_not_detecting_windows_in_the_chroot/

Since a chroot environment has to be used during the installation process (as
the system is not fully installed at that point), there is no way to solve this
problem. However, you can simply re-run the GRUB bootloader configuration
command **after** the installation has finished and once you are booted into
your new system:
```
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Note that you also need to ensure that (a) the **os-prober** package is
installed on your system to begin with, and (b) the `/etc/default/grub` file
contains the following line **uncommented**:
```
GRUB_DISABLE_OS_PROBER=false
```

Assuming both of these are true, Windows should now be detected when re-running
the `grub-mkconfig` command above, and should be added as an entry to the boot
menu.

## The program doesn't run
A few troubleshooting steps can help you work out why **osinstallgui** doesn't
run.

For starters, run it from a terminal instead of from the desktop entry. This
will allow you to see why the program refused to run, as such errors are not
normally written to the log file.

If the warning you see is similar to **GTK Warning: Cannot Open Display**, then
this is caused by the `DISPLAY` and `XAUTHORITY` environment variables not
being set, both of which are required for running GUI programs as root under a
non-root user's desktop session. The desktop entry should set these variables
automatically if it has been configured properly (as a reminder, the `.example`
extension indicates that it is just an example file and is not usable by
default). Ensure the `Exec=` line looks something like the following:

```
Exec=pkexec env DISPLAY=":0" XAUTHORITY="/home/<USERNAME-OF-LIVECD-USER>/.Xauthority" osinstallgui
```

And remember that `<USERNAME-OF-LIVECD-USER>` is a placeholder which should be
replaced with the actual username of the Live CD user, and also without the
angled brackets.

## Sometimes the program appears closed and nothing is happening
If the program appears closed, chances are something is happening! You just
need to be patient.

We have already implemented progress bars, or at least some form of visual
indicator, for most sections of the installation process which are very much
background-based, such as generating the initramfs and installing the
bootloader. And we are working on ensuring every other part that requires
waiting is able to have menu indicators too. These may be rudimentary, such as
progress bars that stay at 0% until the end (if so, they will be labelled as
such), or faked progress bars (i.e., we estimate the percentage of the task we
have completed thus far, if it involves multiple background commands). And we
aim for all ambiguity to be eliminated before **osinstallgui** gets its first
stable (**1.x.x**) release.

In the mean time, all we can say is, again, just be patient! If you suspect
something might've gone really wrong, then you may inspect the **osinstallgui**
log file, which is available at the following directory:
```
/tmp/osinstallgui.<XXXXXX>/osinstallgui.log
```
Where `<XXXXXX>` is a set of 6 random characters, designed to ensure the
directory is unique. You may run `ls /tmp` to check what the full directory is
named, or alternatively check the "About" screen of **osinstallgui**, which
will report its working directory. In any case, the `osinstallgui.log` file
will be within that directory.

The configuration file will tell you where the installer currently is, if it
is not giving any graphical output. If more text is subsequently appended to
this file, this should serve as evidence that the installer process did not
cancel itself and is not frozen or in an infinite loop.
