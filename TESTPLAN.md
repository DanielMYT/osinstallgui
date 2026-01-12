# Test plan for osinstallgui
Whenever a major change is made to the **osinstallgui** code, it is important
to fully test the changes. The following options should be tested as necessary.
You may not need to test every single circumstance listed here every time,
depending on exactly what change was made.

# Firmware type

- Legacy BIOS
- UEFI
- Fully portable (fullport)

# Root password

- Set
- Not set

# Primary user

- Full name given
- Full name omitted

# Filesystem

- ext4
- Btrfs


# /boot structure

- Same partition as `/`
- Separate partition to `/`.

# Swapfile

- No swapfile
- Swapfile (any size)

# Encryption

- No encryption
- LUKS with PBKDF2
- LUKS with ARGON2
