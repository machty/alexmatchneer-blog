---
layout: post
title: "Daily Juggernaut"
date: 2014-09-20 12:30
comments: true
categories: 
---

## Rust is a "Systems" programming language

Seems vague. You can use it for games (`#rust-gamedev` or
`/r/rust_gamedev`). What does systems mean?

`#rust` tells me more vague stuff, but basically:

- Rust doesn't impose garbage collection, so you maintain fine-grained
  control over memory in that regard
- Rust integrates nicely with C

These features are often compared with Go. Go has GC. Go apparently
doesn't integrate as nicely with C (not sure how true this is, need to
dig in). Apparently Go used to advertise itself as systems, then they
stopped, and Rust adopted that term to make it clear how it is different
from the oft-compared Go.

## `source` and `export`

I always knew the `source` command as the command you use when you want
to run a script with a bunch of `export` definitions, but all it really
means is that `source` doesn't actually make new process but just runs
the code in the source file as shell commands. As such, it means that
any environment vars set in the sourced command don't get set in a
separate child process that dies and forgets set vars.

`export` makes sure that an env var gets passed to child processes. Just
setting an env var without `export` won't mark it to be shared with
child processes. 

You can verify all of this by `source`ing a script with a long `sleep`
and then checking `ps` to verify that `sleep` is a direct child of
`bash`; there's no intermediate process running that execution.

## prey project

Protect your devices from theft:

https://preyproject.com/

TODO: look into this shit.

## awesome cheese

Stompetoren Grand Cru. With Effie's Homemade Oatcakes.

So fucking good.

http://bedfordcheeseshop.com/products/stompetoren-gouda-grand-cru

## Why is CORS disabled for XHR but not a 3rd party post?

CSRF is still a thing, but falls outside of CORS because CORS intends to
make JavaScript-initiated requests safe. Then again didn't
Chrome/Mozilla just make fonts CORS-y? 

## Access-Control-Allow-Origin

I'd get this error in devtools console whenever my Rails code errored
out during an XHR request:

    XMLHttpRequest cannot load http://localhost:5000/wat
    No 'Access-Control-Allow-Origin' header is present on the requested resource.
    Origin 'http://localhost:4200' is therefore not allowed access. 

It's misleading since I have CORS set up correctly, but apparently not
for erroring requests? Basically, using XMLHTTPRequest (ajax) is going
to set the `Origin` request header, which flags the server to send back
CORS headers. If the browser doesn't see those CORS headers, or the
provided ones don't match / grant proper permissions, then the XHR
request will fail.

So basically I have an error in my server code I need to fix. Maybe it's
good that CORS fails upon error? Because if not, then I might be opening
up some third party door that's sniffing my site due via erroneous
requets? I can't really see it but maybe.

## Why won't my dumbass server work?

Scenario: I have a remote Minecraft server. It runs from a persistent
tmux session so that I can log in and run server commands on it. I can
ping it successfully but when I try to join, it fails to connect with
authentication servers. There's lots of reported issues online with
authentication servers but I think in my case no outbound requests are
succeeding. `curl google.com` yields no response, and neither do pings.

Whoops. I just remotely turned off the server's wifi and got
disconnected. I figured I'd turn it off and on again to see if that
"rebooted" things. But, uh, kinda need internet through that whole
process. Dumbest moment of 2014.

## Do shells fork to start new processes?

Yes. Bash will fork itself and then calls execve to transform itself
into a new process. 

There's also an `exec` built-in command that will replace your bash
instance with whatever you wanna run, which means when the new command
terminates, your bash terminal will close, e.g.:

    exec sleep 1

An "Environment list" maintains the key value pairs of env vars. When
you exec a new process, it either inherits the env of its parent or gets
a new one. In C-land, the `char ** environ` variable is exposed contain
all env vars, testable via:

    #include <stdio.h>
    extern char **environ;
    int main() {
      printf("%s\n", environ[0]);
      return 0;
    }

## mmap

Virtual memory mapping. It's a syscall to map a region of virtual memory
to a file, or to create an anonymous mapping that doesn't write to a
file. 

## CGI / Rack limitations

[Common Gateway Interface](http://en.wikipedia.org/wiki/Common_Gateway_Interface)

http://blog.plataformatec.com.br/2012/06/why-your-web-framework-should-not-adopt-rack-api/

Shortcoming: middlewares that allocate/release resources

## Mac Desktop Shell Scripts

Save this with `+x` chmod permissions as `~/Desktop/wat.command`.

    #!/bin/bash
    echo "wat"

## htop

`brew install htop`

It's top but way way more bitchin. OMG, it even has a tree mode.

## man vs info

Just discovered that there's both `man bash` and `info bash`. `info` was
added in the 90s by GNU, who felt `man` was too crappy a manual system for
sophisticated software.

## Job control / monitor mode

Bash (et al, but apparently not Bourne?) implement job control, the
ability to suspend resume jobs (process groups) via an interactive
shell. Job control is enabled when "monitor mode" is on. In bash, this
is enabled by default. To disable: `set +m`. To enable: `set -m`. When
disabled, you'll see things like:

    $ fg
    -bash: fg: no job control

You also won't be able to ^Z out of a running process (a SIGTSTP still
fires but bash ignores it). `ruby -e "Process.kill(:TSTP,0)"` runs to
completion when monitor mode is disabled. 

Actually hmm, interesting, if you disable monitor mode and run

    ruby -e "Process.kill(:STOP, 0); puts 'done'"

then it just runs to completion? How is that possible? 
My guess is that the process stops, and then is immediately resumed
because there's nothing to take its place? Seems SIGSTOP is ignored even
when you sent it from another terminal to a terminal with -m.

Also, you can display all the shell options via `echo $-`

    himBH
    hiBH # monitor mode disabled

## Dollar signs

http://stackoverflow.com/a/5163260/914123

     1. Positional parameters `$1,$2,$3…` and their corresponding array representation, count and IFS expansion `$@`, `$#`, and `$*`.
     2. `$-` current options set for the shell.
     3. `$$` pid of the current shell (not subshell)
     4. `$_` most recent parameter (or the abs path of the command to start the current shell immediately after startup)
     5. `$IFS` the (input) field separator
     6. `$?` most recent foreground pipeline exit status
     7. `$!` PID of the most recent background command
     8. `$0` name of the shell or shell script

## syscalls

Example: [waitpid](http://www.opensource.apple.com/source/tcl/tcl-5/tcl/compat/waitpid.c)

Wrapper C functions stash args in registers, stash syscall id in `%eax`,
and then runs a `trap` machine instruction, which tells the processor to
switch into kernel mode. (Recent hardware uses `sysenter` instead of
slower `trap`, which incurred interrupt overhead... TODO: learn about
interrupts!). The rest is obvious enough.













