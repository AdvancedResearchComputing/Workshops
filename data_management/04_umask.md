
---

⬅️ [Previous: File and directory permissions](03_file_permissions.md) | [Next: File and directory ownership ➡️](05_file_ownership.md)


## umask

An octal system of digits that is used as a "reference" to set
file and directory permissions from _**base permissions**_.

A umask is a user-specified value.

#### File Permissions Using Umask

Procedure for specifying file permissions.

1. Given a base permission on files of 0666.
2. Given a umask of 0007.  (This is the current system default for each user.)
3. Convert the base permission to binary.
4. Convert the umask to binary.
5. Take the complement of the umask (keep the leading zero).
6. Perform a bit-wise AND operation on the binary base permission
   and the complement of the binary umask.
8. Convert the binary result to octal.
9. The result is the file permission.


Example

1. base permission 0666.
2. umask 0007.
3. binary base permission:  0  110   110   110
4. binary umask:            0  000   000   111
5. Take the complement of the umask:    0  111  111  000
6. Bit-wise AND on the following:
   - 0  110   110   110
   - 0  111   111   000
   - ==================
   - 0  110   110   000
7. The conversion of the above result is: 0660
8. The file permission is 660, which is what you will get for permissions on a new file.


#### Directory Permissions Using Umask

Procedure for specifying directory permissions.

1. Given a base permission on directories of 0777.
2. Given a umask of 0007.  (The umask is same for directories and files.)
3. Convert the base permission to binary.
4. Convert the umask to binary.
5. Take the complement of the umask (keep the leading zero).
6. Perform a bit-wise AND operation on the binary base permission
   and the complement of the binary umask.
8. Convert the binary result to octal.
9. The result is the directory permission.


Example

1. base permission 0777.
2. umask 0007.
3. binary base permission:  0  111   111   111
4. binary umask:            0  000   000   111
5. Take the complement of the umask:    0  111  111  000
6. Bit-wise AND on the following:
   - 0  111   111   111
   - 0  111   111   000
   - ==================
   - 0  111   111   000
7. The conversion of the above result is: 0770
8. The directory permission is 770, which is what you will get
   for permissions on a new directory.


And this is how the current default permissions are set on files and directories.






---

⬅️ [Previous: File and directory permissions](03_file_permissions.md) | [Next: File and directory ownership ➡️](05_file_ownership.md)