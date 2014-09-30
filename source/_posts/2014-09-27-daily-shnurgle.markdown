---
layout: post
title: "Daily Shnurgle"
date: 2014-09-27 09:29
comments: true
categories: 
---

## lseek

"long" (int) seek. There used to just be a `seek` that took a smaller
int.

You can seek past EOF and the kernel will be fine with it; reads yield 0
and set EOF flag, but writing will cause a "file hole" to exist, wherein
null bytes are returned but aren't actually written to disk until
someone writes into the hole. 

    File.open("seektestfile", "r+") do |f|
      f.write("begin")
      f.seek(10, IO::SEEK_SET)
      f.write("end")
    end

Then open `seektestfile` in vim to see the null bytes. Pretty rad. But
again keep in mind that those null bytes aren't actually there on disk
(well actually I guess it's up to the kernel to figure out whether the
hole is large enough to warrant the overhead of splitting into a
different block; some file systems don't offer file holes at all). 

A file is just a collection of allocated disk blocks. No guarantee their
in the same order. But you could use `posix_fallocate` to reserve
multiple blocks even if you're writing to different places in it to make
sure that future writes will succeed rather than risk some other
application filling a hole and blah.

How many bytes in a block/sector in OS X? `diskutil info /` reveals
(among other things):

    Device Block Size:        512 Bytes

That's the hardware block size, which can be different than the file system
block size (the fs block size must of course be >= device block size).

The `stat` command tells you information about files, like their size n
shit. It has a format option which is like printf. You could be like
`stat -f "hello world"` and "hello world" would be the output, having
run `lstat` on STDIN and printing out no actual information about it.

`ioctl` is useful for special-cased IO scenarios, like controlling a
terminal device special file. You pass it an op code which determines
what the remaining parameters are.

## syscalls and atomicity

Examples of system calls that accept flags to ease race condition pain:

1. `O_EXCL` when opening a file throws an error if it already exists;
   otherwise you'd have to try and open it (to see if it exists), and
   then try to create it if it doesn't, in which time another process
   could have come in and created it. `O_EXCL` guarantees that if the
   open succeeds, that process is the owner of the new file.
2. `O_APPEND` opens a file AND moves its pointer to the end in one shot,
   otherwise two processes trying to append might clobber each other
   between their `seek` and `write`s. Some systems like NFS don't
   support it and are prone to this race condition. WRONG. I wrote the
   wrong thing. `O_APPEND` actually works by opening the file, flagging
   it in such a way that all writes also atomically include an EOF seek.
   If `O_APPEND` worked the way I first described (an `open` + a
   `seek`), the race condition described could still happen.

## File descriptors vs open files

You can have multiple file descriptors point to the same open file. This
for example happens automatically every time you fork a program (its FDs
get dup'd).

The kernel maintains

- a per-process table of descriptors
  - close-on-exec flag
  - reference to the system-wide open file description
- a system-wide table of open file descriptions (the open file table)
  - current file offset (from reads/writes/seeks)
  - status flags from when the file was open()ed (read-only, etc)
  - reference to the i-node
- file system i-node table

Note that there's an on-disk i-node and an in-memory i-node that has a
lot more information about locks and other kernel-specific things that only make sense
to open files rather than just static files living on a disk somewhere.

`fork`ing and UNIX domain sockets are two (of many? maybe?) ways for two
processes to have a file descriptor that points to the same system wide
descriptions.

I originally thought the file offset was stored per descriptor, but
apparently it lives in the shared description record? Only one way to
find out:

    File.open('shareddesctest.txt', 'w') do |f|
      if fork
        # parent
        f.seek(1, IO::SEEK_SET)
        Process.wait
      else
        # child
        sleep 1
        f.write "wat"
      end
    end

If I open vim, I see `^@wat`, which means in fact the offset is shared:
parent seeks to offset 1, child waits for this to happen, and then
writes to a file descriptor it hasn't touched yet, and it starts writing
at where the parent `seek`ed to. So indeed offsets are stored in the
shared system-level open file description.

## Redirection and dup2

`./a.out > wat 2>&1` will pipe both STDOUT and STDERR into the `wat`
file, using a single system-level file description. How does this work?
Pretty hilariously-jankly.

- File descriptors are just integers (stdout=1, stderr=2)
- To redirect stderr to stdout, you have to duplicate stdout's file
  descriptor but make sure that that final descriptor has a value of 2,
  so that code that writes to stderr (2) is unaffected and will
  successfully keeping writing to the newly redirected stream.
- File descriptor integers are reused; the various syscalls that
  allocate file descriptors always choose the smallest unused file
  descriptor int.
- So you could 1. close stderr and 2. dup stdout, and this would work,
  but not if stdin (0) had already been closed, since the new handle
  would take the lower value 0. LOL.
- So you have to use `dup2`, which lets you specify the number of the
  file descriptor you'd like to allocate. Which is what shells with
  stream redirection support. :)

Duping FDs can also be done w `fcntl` and `F_DUPFD`.

## IO at specific offset

Good for concurrent processes in some cases, you can use `pread` and
`pwrite` to perform IO at a specific offset without modifying the file
pointer. 

A single syscall is way more performant than multiple ones, hence the
value in `pread` and friends. You also sidestep certain race conditions.
Then again the time to do IO often dwarfs syscall overhead.

## Scatter IO

`readv` reads a contiguous chunk of data from a file descriptor and
distributes into multiple buffers supplied to the syscall. `writev`
writes a contiguous chunk of data to the file.

This avoids certain race conditions, allows you to combine multiple
reads/writes.

## `/dev/fd`

Virtual directory of file descriptors, e.g. 0, 1, 2 (stdin, stdout,
stderr, and some others). Useful for passing a command line utility a
filename when you really want it to read from stdin, e.g.

    echo 'wat' | diff /dev/fd/0 olderwat

Note that you could also do process substitution:

    diff <(echo 'wat') olderwat

which has the same effect but creates a new descriptor rather than
reusing the stdin descriptor.

Note that these process subsitution file handles also live in `/dev/fd`:

    echo <(echo wat) 
    # /dev/fd/63

## "Header Search Paths" vs "User Header Search Paths"

User: `#include "wat.h"`
Non-user: `#include <wat.h>`

## Process vs Program

A Process is an instance of a Program. A Program is a description of how
to construct a Process. 

Program consists of:

- Binary format ID: describes the format of the executable.
- Machine code
- Program entry point address; address to `int main`, or something that
  quickly calls `int main`.
- data (constants, default starting values)
- symbol/relocation tables: locations and names of functions, for
  debugging purposes but also dynamic linking
- shared libs: list of dynamic libs for run time linking

A process has an initialized data segment and uninitialized data
segment. The former contains all starting values for a program, hence
it's stored in disk space, whereas uninitialized data gets initialized
at process start up through a more dynamic process and hence the space
it occupies doesn't need to be stored on disk. Uninitialized data gets
zeroed out.

- Program break: the "top" of the heap

Application Binary Interface (ABI) set of rules for what registers are
set, etc., when interacting with some low-level service, like the
kernel. SUSv3 standardizes this API so that you're using a higher level
than some ultra low level API.

## Locality of reference

In regards to memory access and optimizations based thereupon.

- spatial locality: tendency for memory accesses to be near recent
  memory accesses (e.g. traversing a data structure, sequential
  execution of code)
- temporal locality: tendency to access a recently accessed location
  (e.g. a loop)

This is part of what makes virtual memory possible; it's largely pretty
rare to suddenly need to access a non-resident page.

Each process has a page table, which maps pages to their physical RAM
locations. If you access a page that's not in RAM, then page fault
occurs (kernel takes over). 

Not all virtual memory address regions have a corresponding page, in
which case, SIGSEGV.

The range of valid virtual addresses changes as the stack grows and more
stuff is allocated on the heap (malloc). Also when you run `mmap`. 

Virtual memory requires hardware support, specifically a Paged Memory
Management Unit, which needs to be smart enough to do address
translating but also notify the kernel of page faults.

VM keeps memory isolated between processes unless you really really want
to share: `shmget` and `mmap` let you do this as a means of
Inter-Process Communication. It works by having page table entries point
to the same region of RAM, allowing for the different process page table
entries to have different permissions, e.g. one process might have read
access but other has write access to the same page frame in physical
memory.

There's a per-process kernel stack which maps to kernel RAM and is
therefore inaccessible when not in kernel mode. This is used for syscall
stacks. I need to read more about this; why can't there be a system-wide
kernel stack shared between processes? Isn't only one process going to
be in kernel mode at any given time? Maybe not... if multiple processes
are blocked on IO, does that mean they're all in kernel mode? TODO: come
back to dis shiz.

## argv argc

`argv[0]` is the process name which can be used to switch the behavior
of multiple commands that all point to the same executable.
`gzip/gunzip/etc` is an example of this. `ls -lai` yields:

    343041 -rwxr-xr-x  4 root  wheel  43200 Oct 31  2013 /usr/bin/gzip
    343041 -rwxr-xr-x  4 root  wheel  43200 Oct 31  2013 /usr/bin/gunzip

Same inode 343041. Here's all of em (`find /usr/bin -inum 343041`):

    /usr/bin/gunzip
    /usr/bin/gzcat
    /usr/bin/gzip
    /usr/bin/zcat

Apparently there's no easy way to find all the files that link to an
inode (the above was simple only because they all happened to be in the
same directory).

Note that you can't hard-link directories.

Short of stashing global vars, you can't access argv and argc (Ruby
facilitates this for you though), unless you're willing to do some
non-portable stuff.

    kernel
    argv,environ
    stack
    ...
    heap
    uninitialized data
    initialized data
    text (program code)
    ...?

`argv` lives right above the stack.

## env vars

If you just do

    wat=lol

that sets a shell variable, not strictly an env var tied to the shell
process that gets with children. Functionally, it's an environment var
that doesn't get passed to children when forked. 

You could then put it into the process env via

    export wat

or in one shot

    export wat=lol

You can set a child processes env var (without polluting parent shell
variable list or environment vars) via

    wat=lol somecommand

in which case ARGC for somecommand will be 0. If you did

    somecommand wat=lol

ARGC would be 1, and ARGV[1] would be "wat=lol" rather than an env var.

Order of env vars is implementation specific; you don't want to rely on
this shiznittletons.

## Streams and LazyValue

LazyValue is coming to Ember along with HTMLbars. LazyValues are a kind
of / relative of Observables, with the unique feature that they avoid
the back pressure of pushing values into the stream by merely replacing
the current value and notifying an end consumer that the stream has been
invalidated, letting the final consumer decide when it should consume
and actually flush the lazy value through all of its transformations. 

I was wondering what the technical term for a stream that doesn't mind
"dropping" "samples" before it has a chance to consume the latest value.
Apparently the word for that is a "signal"...?

## brk and sbrk

    #include <stdio.h>
    #include <unistd.h>

    int main() {
      void *curBrk;

      for (int i = 0; i < 1; ++i) {
        curBrk = sbrk(0);
        printf("brk is %p\n", curBrk);
      }

      return 0;
    }

brk sets the brk lowest address of a process's data segment
(uninitialized) to addr.

These are mad deprecated. Use malloc. Malloc will grow the heap for you
rather than making you set the break. `free` won't shrink the break but
rather just return a chunk to the free list. Why?

- most frees are in the middle of the heap (as opposed to the edge,
  where shrinking the break makes sense)
- syscalls are expensive

Mac OS X specifics: just from a few experiments I can verify that the
stack grows downward, the break is really small, but malloc seems to be
producing pointer values much closer to the stack than the break. What
gives? No idea.

`free(NULL)` is a noop. `malloc(NULL)` might return a small piece of
memory that can be freed.

`malloc` scans the free list for something >= the required amount. If >
than the required amount, the free block is split. Different
implementations might be first-fit or best-fit. If nothing found, `sbrk`
is called to increase it, by some multiple of the virtual memory page
size. 

`free` knows the size of the block to free because malloc sneakishly
inserts the length at the beginning of a chunk of allocated memory.

Wow, the algorithm for free and malloc is pretty awesome.

Let's see nothing's been allocated on the heap. Your free list is a
single element doubly-link list

    |Length of Block|prevBlock*|nextBlock*|empty space|

Then you `malloc(4)`. It'll start at the beginning of that list, see
that `4` is less than the length of the block, and then it'll split that
block. Hmm, so the pointer to the free list needs to remain the same...
so either malloc'd block could get put at the end, length of block is
decremented. Yeah that's probably how it works.

TL;DR: the free list is a doubly-linked list whose nodes are stored in
the same chunk of memory that'll be distributed when mallocs occur. I
always wondered where the "free list" lived... it seemed like one of
those problems where it'd be mallocs all the way down, but this is
a pretty elegant solution, but it also explains how quickly shit can go
haywire if you accidentally futz with freed values. 

The specific algorithm can vary; glibc uses a boundary tag approach,
wherein an allocated chunk includes size of previous chunk, size of
current chunk, and then user space, then size of chunk. 

So how are SIGSEGVs detected on double-frees? 

http://www.opensource.apple.com/source/Libc/Libc-594.1.4/gen/malloc.c

I think Apple's version of malloc tracks allocated blocks (rather than
just a free list). So it'll loop through that list and make sure it's
actually in there. I think glibc see does something else, where it loops
through the free list to see if it's already in there? Or some other
efficient thing using the boundaries stored in adjacent blocks? Unsure.

`alloca` lets you dynamically allocate on the stack by moving the stack
frame pointer downward. It gets "collected" one you return from the
function. Not standardized but most systems have it? It's useful if
you're actually writing a program that necessitates `longjump` since
heap-allocated memory in the stack frames you're skipping over can't
possibly be freed, but you get the "free" for free if it was allocated
via `alloca`. That being said, you probably shouldn't use it. :)

## Users and Groups

You can have multiple usernames/passwords map to the same UID. This
means multiple users can be granted the exact same privileges by nature
of them literally being distinguishable by username but not UID.

`wheel` comes from the phrase "big wheel" ("she's a big wheel at
Microsoft"), it refers to a group with admin privileges. `admin` is
also one such group. `root` is a member of both:

    wheel:*:0:root
    admin:*:80:root

On Mac OpenDirectory is used instead; you can see all of the
`/etc/group` groups in Directory Utility. `wheel` is System Group,
`admin` is Administrators, and there's a bunch of other ones specific to
applications, which seem to be prefixed via underscore blah blah blah
who cares.

## groups, permissions

A process with effective user ID of 0 is a _privileged process_. 

A process starts off with a real user and group ID and can change its
effective user and group ID.

Processes that don't start off with the privileges they need can be
granted the ability to set their effective user and group ids, but only
to the owner or group, e.g. I, user `peon`, can execute `a.out` (if it
has `a+x` perms) and have `a.out` grant itself the permissions that its
owner has.

    machty.github.com :: ls -la wat
    -rw-r--r--  1 machty  staff  0 Sep 28 09:23 wat
    machty.github.com :: chmod u+s wat
    machty.github.com :: ls -la wat
    -rwSr--r--  1 machty  staff  0 Sep 28 09:23 wat

The capital `S` means set-user-id-able but non-executable (this is rare
and maybe useless?). If I do `chmod u+x wat` it becomes:

    -rwsr--r--  1 machty  staff  0 Sep 28 09:23 wat

If I set group, it'd be the next column of bits.

Note that there's no setUID call that the process has to make to enter
this mode; rather, the bit causes the kernel to set the effective user
or group ID once the process begins to run. 

Here's all the `/usr/bin`s that have set-user-id

    machty.github.com :: ls -la /usr/bin | grep '^...[Ss]'
    -r-sr-xr-x     4 root   wheel     75648 Mar 10  2014 at
    -r-sr-xr-x     4 root   wheel     75648 Mar 10  2014 atq
    -r-sr-xr-x     4 root   wheel     75648 Mar 10  2014 atrm
    -r-sr-xr-x     4 root   wheel     75648 Mar 10  2014 batch
    -rwsr-xr-x     1 root   wheel     35136 Oct 31  2013 crontab
    -rws--x--x     1 root   wheel     23008 Oct 31  2013 ipcs
    -r-sr-xr-x     1 root   wheel     68240 Mar 10  2014 login
    -r-sr-xr-x     1 root   wheel     44416 Mar 10  2014 newgrp
    -r-sr-xr-x     1 root   wheel     19664 Oct 31  2013 quota
    -r-sr-xr-x     1 root   wheel     20720 Mar 10  2014 rlogin
    -r-sr-xr-x     1 root   wheel     19856 Mar 10  2014 rsh
    -rwsr-xr-x     1 root   wheel     21488 Oct 31  2013 su
    -r-s--x--x     1 root   wheel    164896 Oct 31  2013 sudo
    -r-sr-xr-x     1 root   wheel     83856 Oct 31  2013 top

and all the set-group-ids

    machty.github.com :: ls -la /usr/bin | grep '^......[Ss]'
    -rwxr-sr-x     1 root   mail      24640 Oct 31  2013 lockfile
    -rwxr-sr-x     1 root   mail      84656 Oct 31  2013 procmail
    -r-xr-sr-x     1 root   tty       20832 Mar 10  2014 wall
    -r-xr-sr-x     1 root   tty       19920 Oct 31  2013 write

`wall` writes some nonsense to everyone's terminal: `echo wat | wall`.

Processes have the ability to switch in and out of their set-uids and
set-group ids. In other words, a program might have its set-uid enabled
(and its owner is root), but it's bad/unsafe practice to let a program
just run in root mode the whole time; rather, it should only switch into
root mode when doing stuff that requires privileges, and then switch
back. 

In Linux there's also the concept of file-system IDs and groupd IDs,
which follow effective ID/group except when `setfsuid` and `setfsfid`
are called. But they're seldom used. They only exist to cover use cases
of `NFS`.

## Ruby Base64

    require 'base64'
    Base64.encode64("borf") # => "Ym9yZg==\n"
    Base64.strict_encode64("borf") # => "Ym9yZg=="

- `encode64` implements the base64 referenced in 
  [IETF 2045](https://www.ietf.org/rfc/rfc2045.txt),
  the RFC on Multipurpose Internet Mail Extensions (MIME).
- `strict_encode64` implements the base64 specified
  in [IETF 4648](http://tools.ietf.org/html/rfc4648), which
  goes into more detail, gets rid of the newlines

I used to have to do `gsub(/\n/, "")` after encoding to get Ruby's
`encode64` to be compatible with some other that was more picky about
Base64.

Also, I was wondering why the `==` exist. Base64 converts any bytestream
to a 64 bit alphabet. In other words, 2^6 characters. Consider the
following random 3 byte stream:

    01011010 00001111 10101111

We're used to thinking of them split by 8 bits, but a base64 character
can only account for 6 bits, so you'd actually think of it like:

    010110 100000 111110 101111

This explains why encoding as base 64 has a 4/3 size overhead, an
important consideration before willy nilly encoding a bunch of giant
assets at base 64. 

It also explains why encoding strings whose lengths aren't a multiple of
3 end up adding `=` padding ("borf" => "Ym9yZg==\n").

## `ls -d`

e.g. `ls -ld somedir` to show the directory entry rather than expanding
it and listing all of its files.

## Y2K for epoch 32 bit = year 2038

The epoch + 32 bit signed int max = year 2038. 

## Service Workers

http://www.w3.org/TR/service-workers/#motivations

https://github.com/slightlyoff/ServiceWorker/blob/master/explainer.md

Alex Russell's been working on this. It's a huge improvement over the
declarative app cache. A ServiceWorker is a WebWorker that can get
installed on page load, and then once installed, is consulted on future
page loads, even if there isn't any internet.

> Documents live out their whole lives using the ServiceWorker they start with.

This means if no service worker existed at initial doc download, then
installing a ServiceWorker on the first load means the ServiceWorker
will have to completely sit out for the lifetime of that page. It's only
on feature reload where it might get consulted. This slightly off
behavior results in:

- better fallback for unsupporting browsers
- makes sure that people write good URLs whether using ServiceWorkers
  or not
- Zalgo issues with pages suddenly switching in and out of being managed
  by a ServiceWorker

Other things of note:

- ServiceWorkers can die, be aborted, be restarted
- So don't write them to be stateful.
- Or if so, use IndexedDB. (If ServiceWorkers are available, IndexedDB
  is available)

## `od`: octal decimal dumps

    echo "a" | od

    0000000    005141
    0000002

I'd expect just one stupid byte, why are there multiples?

Oh duh because `echo` includes a newline.

    echo -n "a" | od 

    0000000    000141
    0000001

Wat.

    echo -n "aa" | od
    0000000    060541
    0000002

Oh right, this is an octal dump. Here's binary

    echo -n "aa" | od -b
    0000000   141 141
    0000002

Makes more sense. The leftmost column is just a row indicator.
At some point it'll wrap, and you always look at the last one for an
indicator of the length thus far.

    echo -n "big ass set of bytes" | od -b
    0000000   142 151 147 040 141 163 163 040 163 145 164 040 157 146 040 142
    0000020   171 164 145 163
    0000024

See? It wraps automagically.

## cwd

Processes have `cwd`s. They're the starting point for filename lookups.
A shell's current directory is that shell's `cwd`. You can use
`getcwd(3)` to get the current one. 

What's the difference between `pwd` and `cwd`? `pwd` is a command that
stands for Print Working Directory. It prints the `cwd`. But it does so
with the `PWD` 

`$PWD` is an env var you can check. `$OLDPWD` is set when you `cd` and
`cd -` uses it.

Soooo I believe the answer to everything is this: the kernel knows about
`cwd`, but doesn't track the absolute path to it in string form; it's
just a pointer, which is all it needs in conjunction with relative file
paths to locate and open/create/unlink files, etc. 

Shells on the other hand provide a convenience built-in `pwd` and
expose/manage the `$PWD` var (et al) to provide a string.

## Hard-linking directories.

Forbidden in most things, allowed in Mac OS X; twas responsible for 
the data loss bug in Broccoli, since `rm -rf` ing a directory would
follow that link and kill shit.

Why does Mac allow it? Apparently it's used in Time Machine. If a
directory hasn't changed, a new snapshot can just point to the same
directory inode without duplicating it.

Great explanation: http://stackoverflow.com/a/4707231/914123

By the way `ln` and `link` are the same executable:

    $ ls -lai `which link`
    11551 -rwxr-xr-x  2 root  wheel  14976 Oct 31  2013 /bin/link
    $ ls -lai `which ln`
    11551 -rwxr-xr-x  2 root  wheel  14976 Oct 31  2013 /bin/ln


































