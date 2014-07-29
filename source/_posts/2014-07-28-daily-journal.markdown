---
layout: post
title: "Daily Journal"
date: 2014-07-28 08:16
comments: true
categories: 
---

## Them processes

Kernel

<!--more-->

- sits on top of hardware, doing things like
  - read/write from filesystem
  - sending/receiving network data
  - playing audio
- programs don't have access to this stuff, only the kernel

System call is the barrier b/w userland and kernel.

What about memory? I think userland can read memory.

Common man pages for FreeBSD or Linux

`wat(2)` means section 2 of manual, wat: `man 2 wat`

Can't execute code without a process.

`Process.pid == $$` global var in Ruby, from Perl/bash, but
`Process.pid` is way more obvious, duh.

Processes have parents, identified via `ppid`, `Process.ppid`, but not
super often used.

In Unixland, everything is a file.

When opening resources, you're given a file descriptor number, unique to
your process, unshareable with unrelated processes. These resources are
closed when you exit process, cept forking.

All Ruby `IO` objects have a `fileno`, e.g.

    2.0.0-p353 :007 > $stdin.fileno
     => 0
    2.0.0-p353 :007 > $stdout.fileno
     => 1
    2.0.0-p353 :008 > $stderr.fileno
     => 2
    
File descriptors are assigned lowest unused value, and are reusable when
old file handlers are closed.

Streams are lovely, before them, each program had to explicitly handle
different keyboard types, etc, but the stream abstraction unified all of
that.

`fsync` flushes file descriptor state to disk, but disk might reorder
writes. The `F_FULLFSYNC` will ask the drive to write it immediately and
preserve order, useful for things like databases, see `fsync`

     For applications that require tighter guarantees about the integrity of their
     data, Mac OS X provides the F_FULLFSYNC fcntl.  The F_FULLFSYNC fcntl asks the
     drive to flush all buffered data to permanent storage.  Applications, such as
     databases, that require a strict ordering of writes should use F_FULLFSYNC to
     ensure that their data is written in the order they expect.  Please see fcntl(2)
     for more detail.

`F_FULLFSYNC` probably isn't available on everything, possibly mac only.

To find the limit of file descriptors you can do `Process.getrlimit(:NOFILE)`

This translates to `getrlimit(2)`, control max system resource
consumption. `r` is resource, `NOFILE` means "The maximum number of open
files for this process".

    2.0.0-p353 :001 > Process.getrlimit(:NOFILE)
     => [2048, 2048]
        #soft, hard

Soft means an exception will raise but you can reconfigure. Hard limit
might be reconfigurable by superuser, or if the process has permissions.

`sysctl` lets you get or set kernel state, useful for configuring
system-wide kernel details. 

`EMFILE` is too many files open. Testable via

    machty.github.com :: ruby -e "Process.setrlimit(:NOFILE, 3); File.open('/dev/null')"
    -e:1:in `initialize': Too many open files - /dev/null (Errno::EMFILE)

`ulimit` is a built in command to control resource usage for this shelll
and any of its children. It's different from system wide `sysctl` stuff.
I can change the result above

So I remember `ulimit` resets the soft limit. If I set to 2046, then

    machty.github.com :: ruby -e "puts Process.getrlimit(:NOFILE)"
    2046
    2046

> (Built-in command) In computing, a shell builtin is a command or a function, called from a shell, that is executed directly in the shell itself, instead of an external executable program which the shell would load and execute. ..

Use cases for overriding limits

- stress-testing utilities (e.g. 5000 simultaneous connections)
- limiting resources for 3rd party stuff, removing permissions to change

Environment is nothing more than Env vars, key values pairs.
Set by parent, inherited by children.

    machty.github.com :: A=lol ruby -e "puts ENV['A']"
    lol

Note that env var assignment on its own shell line sets them for the
rest of the process, but followed by a command only sets them for that
command. 

Process names are changeable, e.g. `$PROCESS_NAME = "fuckles"`

      PID TTY           TIME CMD
    45874 ttys011    0:00.68 fuckles

Note that TIME is CPU time.

Ah, `time` makes sense to me now:

    machty.github.com :: time sleep 1
    
    real    0m1.012s
    user    0m0.001s
    sys     0m0.003s

`sleep` suspends execution thread, consuming no CPU. I think `sys` means
system call time, such as telling the pthread to sleep. IT IS ALL MAKING
SENSE. 

Processes have exit codes, 0 is successful. 

All the ways to exit

- exit, `Kernel#exit`, exits w 0 by default but you can pass a code,
  runs `Kernel#at_exit` blocks. `exit!` does a code 1 and doesn't run
  exit blocks.
- abort accepts a string in ruby, runs exit handlers, returns 1
- raised exceptions yield exit code 1 and still raise things.

Processes can fork, unless you're JRuby. That means Unicorn won't work
for JRuby.

Forking copies all memory (or copy on write). File descriptors are also
provided to forked thinger. 

    2.0.0-p353 :016 > fork { puts Process.pid; puts Process.ppid}
     => 46054
    2.0.0-p353 :017 > 46054
    45874
    2.0.0-p353 :018 >   Process.pid
     => 45874

Parent and child can share file descriptors, open files, sockets, etc.
Because forking is faster than booting up fresh copies of servers... it
is good...? 

Awesome example:

    if fork
      puts "YES"
    else
      puts "NO"
    end

Hahaha, don't run this in irb though, because you'll have two processes
reading from the same $stdin, e.g. your keyboard.

Blockless `fork` returns twice

- parent gets child pid
- child gets nil

Explains this output 

    ruby -e "cid=fork; puts cid || 'none'"
    46650
    none

What about threads? Do thread ids change after forking?

    machty.github.com :: ruby -e "puts Thread.current; fork; puts Thread.current"
    #<Thread:0x007fa7710677a8>
    #<Thread:0x007fa7710677a8>
    #<Thread:0x007fa7710677a8>

No it seems they don't... forking really makes everything seem totally
the same. I wonder how that works at the pthread level. 

http://pubs.opengroup.org/onlinepubs/009695399/functions/fork.html

> A process shall be created with a single thread. If a multi-threaded process calls fork(), the new process shall contain a replica of the calling thread and its entire address space, possibly including the states of mutexes and other resources. Consequently, to avoid errors, the child process may only execute async-signal-safe operations until such time as one of the exec functions is called. [THR] [Option Start]  Fork handlers may be established by means of the pthread_atfork() function in order to maintain application invariants across fork() calls. 

So only a single thread is created, and the kernel knows it's a separate
thread, but the forked instance still thinks the address of that thread
is the same as before, even though it's obviously a different thread.

Forking allows (but doesn't guarantee) a process to run on multiple
cores. If the system is busy the forked processes might all run on the
same CPU. 

Forking duplicates memory (assuming no copy-on-write; TODO: learn the
terminology for total memory vs not-yet-copied-on-write memory).
Running out of memory due to over-forking is called a fork bomb.

Forking means orphaning if the parent process finishes before children.

Daemon processes are intentionally orphaned so that they can stay
running forever. Orphaned children can be communicated with via signals. 

Fork-and-forget vs remembering child process. `Process.wait` will wait
for ONE child process to terminate before quitting, and returns the pid
of the child process that terminates. Spawn 3 processes, must wait three
times. `wait2` returns `[pid, status]`, so you can get codes n shit.
`waitpid` and `waitpid2` wait on specific pids. But they are aliased to
the same thing: `wait 

The kernel queues child process return info so that waiting on a process
that has already did will return its shit. That said, waiting on
non-existent children raises `ECHILD`.

Unicorn forks N times, makes sure the processes are still alive,
restarts if necessary, etc.

If you don't do `Process.wait` though, the kernel will keep on storing
information about exit codes, etc. You either need to `wait` or `detach`,
or else you get a zombie process. 

http://en.wikipedia.org/wiki/Zombie_process

A Zombie process is a process that has called exit but whose parent
hasn't called `wait` or `detach`.

- Zombie: un-reaped, terminated child process
- Orphan: still active child process whose parent has died.

Orphans get attached to `init` (or `launchd` in OS X land), which has a
pid of 1. 

Oh man, fork bombs are hilarious: http://en.wikipedia.org/wiki/Fork_bomb

So ppid actually automatically updates:

    fork do
      loop do
        puts "(#{Process.pid}, #{Process.ppid})"
        sleep 1
      end
    end
    
    sleep 1
    
    abort "k i'm done #{Process.pid}"

Output:

    (47598, 47597)
    (47598, 47597)
    k i'm done 47597
    (47598, 1)
    (47598, 1)

Pretty cool. 

Also if you `brew install pstree` and take a look at that, pid 1 is
`launchd`. 

You can check the status of process and how it changes into a zombie and
then when it gets removed from the process table when we call
`Process.wait`:

    cpid = fork {}
    puts `ps -p #{cpid} -o state`
    sleep 1
    puts `ps -p #{cpid} -o state`
    Process.wait
    puts `ps -p #{cpid} -o state`

Yields:

    STAT
    R+
    STAT
    Z+
    STAT

Note the last STAT is empty because no such pid; shit is dead.
The `+` means process is in the foreground process group of its control
terminal. 

Note that no memory is allocated to the zombie process itself; just the
slot in the process table is used; zombie processes prevent other
processes from taking their place and reusing their PID. Which is
another thing: a parent process might not want a child pid to be reused
when creating a child pid, so it'll create the new child, and THEN
`wait`/`detach` on original.

`Process.detach` spins up a thread to `wait` on a process. Here's a
really roundabout way to detach and then wait and get the return value:

    t = Process.detach(cpid)
    puts `ps -p #{cpid} -o state`
    puts t.value

`t.join` before a `t.value` is a noop; `value` must always `join` in
order to get the value. 

Fork-and-forget is rare. `Process.detach` has no system call equiv; it's
just a ruby convenience. 

SIGCHLD fires when a child process exits. You can trap it and `wait` for
that process to finish. Problem is, signal delivery is unreliable; if
you're handling a signal and another one comes in, you might not receive
that signal. Solution is to pass a second param to `wait` to describe
how the kernel should wait for this thing, e.g. `Process::WNOHANG`

Shit is so messy

    Process.trap(:CHLD) do
      nil while Process.wait(-1, Process::WNOHANG) rescue Errno::ECHILD
    end

Yes you could unravel but come on.

Signals are async, ignorable, actionable, defaultable. Processes use the
kernel to as an intermediary to send messages.

    echo "puts 'lol'" | ruby

Who knew? It accepts input from stdin. So you can pipe Ruby code to it.
Ctrl-C sends an interrupt. You can trap it and ignore. You can also say
`trap(:INT, "IGNORE")`

It's good form in lib code to define a trap, though it's possibly to
preserve other people's callbacks and call them in yours. But you can't
restore default behavior. This is fine if your'e writing a server
though. 

> USR2 - reexecute the running binary. A separate QUIT should be sent to the original process once the child is verified to be up and running.

https://github.com/ice799/memprof does some cool stuff with trapping
signals, printing out useful shits.

This guy is boundlessly smart. 

Make a pipe, give someone one end to yell into and the other person the
put their ear up to it. Methinks you see where this is going.

Source and Sink, Writer and Reader. Pipe persists until all associated
descriptors are closed. Half-closed pipes are "widowed". Writing to a 
widowed pipe yields `SIGPIPE`, but widowing it is how the reader gets an
EOF signal. `SIGPIPE` can be disabled via F_SETNOSIGPIPE in fcntl, which
we saw above in this journal for telling a hard drive to actually
preserve write order.

In Ruby you can pass an encoding which tags the read input with that
encoding. 

http://ruby-doc.org/core-2.0/IO.html#method-c-pipe

    rd, wr = IO.pipe
    
    if fork
      wr.close # REQUIRED
      puts "Parent got: <#{rd.read}>"
      rd.close
      Process.wait
    else
      rd.close # REQUIRED
      puts "Sending message to parent"
      wr.write "Hi Dad"
      wr.close
    end

The `# REQUIRED` closes are there because otherwise the data won't
flush, EOF's won't be called. 

So that's a neat little primitive, but how is it different than just
using a StringIO? Well, aside from the fact that I don't think you can
just progressively write into StringIO as you read from it (maybe you
can), Pipe goes through the kernel; there's system calls and overhead.
Check this bitchin benchmark:

    require 'benchmark'
    require 'stringio'

    n = 100000
    Benchmark.bm do |x|
      x.report("pipes:") {
        n.times do
          rd, wr = IO.pipe
          wr.write "HELLO"
          wr.close
          raise "wat" unless rd.read == "HELLO"
          rd.close
        end
      }

      x.report("StringIO") {
        n.times do
          s = StringIO.new("HELLO")
          raise "wat" unless s.read == "HELLO"
          s.close
        end
      }
    end

yields

                  user     system      total        real
      pipes:  0.630000   0.730000   1.360000 (  1.363994)
    StringIO  0.080000   0.000000   0.080000 (  0.077973)

This is skewed by the fact that you're not going to be creating and
dumping pipes all the time, but it just highlights the inner workings of
Pipe: because it involves syscalls, much of the time is spent in
`system`.

With streams (pipes/TCP sockets), you write to a stream followed by a
delimiter. Newline is the delimiter. Unix sockets are intra machine, and
fast. 

Use sockets to communicate in datagrams vs delimited stream chunks. You
still have pairs, but rather than read/write pairs, you just have
bidirectional shits, one of which needs to get closed per process.
Sockets are bidirectional!

http://stackoverflow.com/questions/731233/activemq-or-rabbitmq-or-zeromq-or
http://wiki.secondlife.com/wiki/Message_Queue_Evaluation_Notes

From http://www.ruby-doc.org/core-2.1.0/IO.html

> In the example below, the two processes close the ends of the pipe that they are not using. This is not just a cosmetic nicety. The read end of a pipe will not generate an end of file condition if there are any writers with the pipe still open. In the case of the parent process, the rd.read will never return if it does not first issue a wr.close.

Fuckles and shittles.

    man socketpair

Thom Ass Tover says:

http://www.thomasstover.com/uds.html

So these sockets are Unix Domain Sockets, or local sockets.

Pipes

- can be given a name
- writing to a full one yields `SIGSTOP`
- are faster than Unix domain sockets
- require context switches w kernel to use read/write

Solaris pipes are special in that they are full duplex, where as on
Linux and BSD you'd need two pipes for full duplex. fifos are named
pipes. I guess they're like files.

http://en.wikipedia.org/wiki/Named_pipe

wow:

    mkfifo my_pipe
    gzip -9 -c < my_pipe > out.gz &

So, Matt Daemon.

`init` or `launchd` has ppid 0 and pid 1.

`exit if fork` will fork and close the parent process.

`Process.setsid` creates a new session. It talks about a process groups
and what not. If you call it, your process becomes

- session leader of new session
- process group leader of new process group
- and has no controlling terminal
- and becomes the only new thing in the thing

returns the new process group ID. 

Job control is the way processes are managed by terminal. Process group
id is generally same as process ID. Fork and the process group id will
be the same. If they fork and so on then yeah yeah yeah this is how you
know they all came from the same shit. When you do `irb` in a terminal
it'll set the process group to the pid of the command you run.

This is why interrupting a Ruby script that's shelled out to thing will
kill all the things if it gets an interrupt; if it's still alive, it'll
kill children. It's only upon normal exiting that you lose
thisetoisjdoiasj.

Session groups are higher up, a collection of process groups. One
session group: `echo "lol" | echo "lol"`. EPERM fires if you are already
leader (can only call w children).

Look at http://rubygems.org/gems/daemons

`exec` totally transforms your shit, better fork first.

    Thread.new {
      sleep 2
      puts "THIS WILL NEVER PRINT"
    }
    Thread.new {
      sleep 1
      exec 'ls'
    }

It entirely nukes your process context, including any outstanding
threads. You must escape via a fork. 

Ruby's `exec` will close file handles, database connections, etc, before
passing control to the new shit, though native `exec` calls would leave
them open. Sensible default given `echo` doesn't care about your
database. You might accidentally exec another process that doesn't do
anything with a db connection, and it never totally closes. But you can
override this default if you want to pass the fileno to the new process
and keep open that handle when it opens it for reading. 

Unlike fork, no memory is shared with the resulting process of an exec.

I am so tired.

`system` returns a true or false. Output barfs to stdout.
    
`popen` opens a bi-directional pipe; you can write to and read from the
process spawned

`popen3` gives you access to all 3.

Forking means a copy of all the parent process's context before
`exec`-ing something super small like `ls`, but you can use gems that
wrap `posix_spawn(2)`

https://github.com/rtomayko/posix-spawn

Also check out `man vfork` for virtual memory friendly forking.

Resque forks for memory management; bloating Ruby tasks tend not to
shrink, so fork makes it possible for forked workers to bloat and
disappear.

http://rubydoc.info/github/defunkt/resque/Resque/Worker

> A Resque Worker processes jobs. On platforms that support fork(2), the worker will fork off a child to process each job. This ensures a clean slate when beginning the next job and cuts down on gradual memory growth as well as low level failures.

> It also ensures workers are always listening to signals from you, their master, and can react accordingly.

Preforking, is it cool. haidjasoidjasiodj


What's the rules on writing to stdout between multiple processes.
You can do it; there's not going to be thread-unsafety, i don't think.

http://stackoverflow.com/questions/1326067/how-to-lock-io-shared-by-fork-in-ruby

Preforking has load balancing wins similar to message queuing with
multiple consumers; when a consumer is ready, it just listens for the
same thing. A socket is shared b/w forked processes, and kernel makes
sure only one gets it

I need to understand more about $stdout and buffering and what not. It's
not thread safe, but process-safe? syscall-safe? 

- fork-safe if the action in question fits within a single syscall

I have no fucking IDEA MY BRAIN IS DEAD.


























