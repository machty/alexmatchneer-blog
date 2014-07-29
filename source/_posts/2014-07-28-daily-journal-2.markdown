---
layout: post
title: "Daily Journal 2"
date: 2014-07-28 20:43
comments: true
categories: 
---

## User and Kernel

http://blog.codinghorror.com/understanding-user-and-kernel-mode/

Non-idle tasks.

The CPU graph is tasty. Red means kernel.

CPU hardware knows all about kernels n shit. It isn't just a software
divide. CPU instructions and certain memory locations can only be
accessed by the kernel, enforced by hardware. User mode makes it so that
only the app crashes, not the entire system. 

http://en.wikipedia.org/wiki/Ring_(computer_security)

Interesrserseting. 

x86 CPU hardware:

- 0 is kernel
- 3 is user

1 and 2 are device drivers but they're not often used. On Windows, 
device drivers can be user or kernel mode, mostly to the user, but video
cards are often kernel level since they so perfy. In Vista+, the Windows
Driver Display Model is such that only kernel mode is used for executing
the GPU commands, but the translation from API to GPU now takes place in
userland. 

Exceptions fire in kernel land I guess? Sometimes?

## Old Foreman Orphans Sidekiq

After lots of starts/stops of foreman, I noticed lots of sidekiq
instances with ppid 1. They was orphans. I killed em.

## fspawn

Refers to the fork+exec approach to spawning a process.

## Daemons

https://github.com/ghazel/daemons

Library of fun little trinkets. 

- given some-server.rb, let's you write a some-server-control.rb 
- inline the server inside such a daemon (you can still run it
  without forking via `run` command)
- manage multiple daemons
- Ability to take existing server and daemonize it; you do lose control
  over the daemon unless you're a `ps`/`kill` JOURNEYMAN. 
  - this takes advantage of the `fork` `getsid` 

## .pid file

It's a file in a well known location that contains only the pid of 
some running process, usually a daemon. Useful because daemons are often
hard to detect, kinda look like forgotten orphan processes, and there
might be multiple similar ones. But pid files let you look up the pid of
the running process so that you can send it signals.

## `$0` or `$PROGRAM_NAME`

If you run this script

    fork {
      $PROGRAM_NAME = "WAT"
      sleep
    }

then `ps | grep WOOT` yields

    62724 ttys022    0:00.00 WOOT
    
Woot wat wat wotasoasdas lol.
    
## `pidof`

    brew install pidof

    $ pidof bash
    754 1246 1748 2308 2498 5380 20397 23552 26224 26973 48454 79258 81847 5226 5346 5443 5851 10659 25008 26375 27009 52684 88768 88882 18853 19116 19246 20275 20476 21364 43211 52269 52390 52637 54869 54974 58037 58950 59080











