---
layout: post
title: "Daily Journal"
date: 2014-09-15 19:57
comments: true
categories: 
---

## FTP

Plaintext, unless you're using SFTP or some variant.

FTP uses multiple connections: 1 control connection for sending
commands and tracking current directory, etc, and a connection for
actually streaming the file data. 

How the second connection (data) is established depends on active vs
passive mode: in active mode, the server will try to connect back to the
client at PORT+1, and in most modern cases, this will fail due to NATs
and firewalls, hence passive mode (via PASV) command is meant to get
around this. In passive mode, the client requests an IP and port from
the server (via the control connection), and then the client makes the
second connection to whatever the server returns. This works as clients can
generally connect to servers without NAT/firewall issues.

Note that active connections are rare. The man page for `ftp` is
telling:

    -A          Force active mode ftp.  By default, ftp will try to use passive mode
                ftp and fall back to active mode if passive is not supported by the
                server.  This option causes ftp to always use an active connection.
                It is only useful for connecting to very old servers that do not
                implement passive mode properly.

## Application-level gateway

http://en.wikipedia.org/wiki/Application-level_gateway

TODO: learn more.

## Process per connection

One way of handling a new connection is to fork and let the forked
process handle that connection. Makes sense for the parent instance to
use Ruby's `Process.detach`, which doesn't have a native kernel
equivalent but is just a Ruby convenience that spins up a thread that
calls `wait()` on the forked process to prevent it from becoming a
zombie if the parent process exits before the forked one.

Remember that forking isn't available on Windows or JRuby.

`shotgun` is a Ruby server that forks per connection. Why? Isn't this
wasteful (relative to pre-forking solutions like Unicorn)? Yes, but it
has specific purpose: assuming it's not painfully expensive to spin up
your server (like Rails), and that you don't have a mechanism for
reloading after code changes (like Rails), `shotgun` will fork per
connection and entirely reload / spin up the rack server, less reloading
the latest version of any Ruby code, thus not requiring you to manually
restart your server.

## Thread per connection

Typical state-sharing caveats apply when working with threads, hence
it's useful to thing about the simple unit of concurrency that will keep
your threads isolate and minimize their access to shared data. That unit
would be a connection; each thread should get its own connection object.
Create a connection object, immediately create a new thread, and let
that connection object fall out of scope in the creator thread so that
only the newly spawned thread has access to it. Simple enough.

## How to verify your code is on multiple cores

You have to dig in a little bit to verify that Ruby code you're writing
is actually being processed on multiple CPU cores. There are many
variables:

1. Does your system even have more than one core? (try `system_profiler | grep 'Total Number of Cores'` to find out, probably some other ways too)
2. Does your Ruby have a GIL? (MRI does, Rubinius and JRuby don't)
3. Some third thing to pad my arbitrary list of bullshit.

Anyway, one easy way is to run the following code:

    NUM_CORES = 2

    threads = []
    NUM_CORES.times do |t|
      threads << Thread.new do
        log_every = 1000000
        i = 0
        loop do
          i += 1
          if i == log_every
            i = 0
            putc t.to_s
          end
        end
      end
    end

    threads.each(&:join)

Running this on MRI Ruby results in 100% CPU usage. Running in JRuby
yields 200%, which means two cores are operating at 100%. Pretty rad,
yes?

CPU usage reported by activity monitor or `top -o cpu`. 

## Preforking

e.g Unicorn

What's nice is that the kernel will handle load-balancing for us: when
there are no incoming requests, you have N forked instances blocked on
`accept`, and the kernel will choose which instance gets the next
incoming request. If all forked instances are busy, the kernel will just
queue up the request internally. If the queue gets full, you'll get an
ECONNREFUSED. Easy peazy.

Unicorn (and probably Rainbows) does some extra tracking on child
processes to make sure it's not getting stuck on long requests, etc.

Main disadvantage is memory usage. By the time you fork, if the parent
process is 100 mb, then 4 forks and you're at 500 mb... unless 1) your
OS has COW and 2) you don't write to it all that much. 

## Reactor

e.g. Node.js, Twisted, EventMachine

High levels of concurrency (not necessarily parallelism) achievable,
relative to threading/forking models, which hit their RAM limit much
faster (Reactor patterns mean that everything is just heap allocations
on the same thread).

Impacts on programming model:

- No processes/threads, so no shared memory, synchronization, etc, to
  have to worry about
- Don't block the single Reactor thread (because nothing else will be able to
  run). You wouldn't have to worry about this in thread/processland.
  This is why if you're using EventMachine, your gems must be
  event-machine aware, otherwise they'll block (which would be fine in a
  threading/forking environment).

## Node cluster

http://nodejs.org/api/cluster.html

Based on the fact that you can use child process forking to split heavy
duty work into process that can each live on a different core, if that's
what you're about.

Note that there's no C-like or Ruby-like fork in Node; you can't just
call fork and then have both the parent and newly forked child process
continue execution from that `fork()` invocation...
















