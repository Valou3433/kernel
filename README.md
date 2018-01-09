# VK
VK is a Kernel

C kernel project ; current architecture : x86

Current status : the kernel can load an ELF executable, and execute the code, from an ATA disk with a FAT32/EXT2 fs or
an ATAPI cd-rom with an ISO9660 fs.

The scheduler is working, but i'm pretty sure it still contains some bugs.

I will need to redesign the whole VFS architecture, because i realised it was really bad cause not optimized, taking to much memory
and not suitable in a real environment (with multitasking).
I also want to get ACPI support, at least for ACPI shutdown but also to use things like HPET...

After that, i will have to clean up the code, and add system calls.
Then i'll try to port a libc, like newlib, and binutils/gcc (that would be really great).
