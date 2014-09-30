---
layout: post
title: "Daily Journeaux"
date: 2014-09-17 08:08
comments: true
categories: 
---

## nginx book

This is nice: http://aosabook.org/en/nginx.html

Some random notes:

For CPU-bound loads, number of nginx workers should equal the number of
cores ("TCP/IP, doing SSL, or compression"). For IO-bound stuff 
("serving different sets of content from storage, or heavy proxying" --
presumably teh "different sets" is important because if it were
the same stuff, it'd probably be cached which I guess means the IO would
be negligible? unsure) -- you might want 1.5-2 times the number of
cores. 

## SSL/TLS random questions:

I have so many misconceptions? For anyone who reads this, this is stream
of thought as I try to answer my own questions before looking shit up.

How come domains are signed and not IPs? 

Reasoned guess: first off, everyone can encrypt data. It's just that the
key thing that TLS brings in is certification of a sending. It's not
enough to say "yo here's my public key", you still have to answer the
question "uh ok yes but who are you?". Certificate authority to the
rescue.

So what if CA's certified IPs, rather than domain names (maybe they do,
I don't actually know at this point)? Some ideas come to mind:

- DNS can map to multiple IPs, and a single IP might load balance to
  many different servers, all of which should be able to (de)/encrypt
  incoming traffic. 

That's actually probably the only reason. I was originally thinking
that since IPs can change, you might certify server A and then the next
day the IP changes to server B, and that that would mean the CA is
giving a stamp of approval to the wrong server, but then, duh, it's key
pairs that are being validated, and server B wouldn't have these keys
and wouldn't know how to do the handshake. I think this is close to
correct, it's just I'm forgetting everything that happens internally
within the handshake.

http://en.wikipedia.org/wiki/Transport_Layer_Security

## Symmetric Key

A single key encrypts plaintext and decrypts the ciphertext generated
from the encryption. 

Example: AES.

## Cipher suite

https://www.iana.org/assignments/tls-parameters/tls-parameters.xhtml#tls-parameters-4

A triple of

- authentication
- encryption
- and message authentication c

## SSL / TLS

Lots of people use them interchaangeably, but SSL was originally created
at Netscape and used to be implemented at the application layer, living
on top of TCP. When it was IETF standardized, it was renamed TLS and
moved out of the application layer.

TLS provides:

- encryption
  - obfuscate data transmitted from one computer to another
  - example: plaintext means zero encryption and easily breakable
    ciphertext means shitty encryption
- authentication
 - verify that you're talking to who you think you're talking to
 - example: the CA validates the certificate that a server sends you
- integrity
  - detect message forgery or tampering
  - example: 

## Beware the intermediaries

Intermediaries are caching servers, gateways, web accelerators, content
filters, blah blah blah, all the stuff that's come out to aid and extend
HTTP. They're often transparent to the end user, but they come with the
limitation that if you start wanting to deviate from HTTP on port 80 in some
application specific way, you're boned. And it's kinda rare to find
other ports that are open: 80 and 443 (HTTPS) are usually open but
everything else is often closed. These intermediaries might improperly
try to apply their logic to the non HTTP, etc, there's no easy way to
detect when or when not to apply. 

Solution: HTTPS tunnel all the things. All data is obfuscated from
intermediaries and intermediaries have no way of known whether the
encrypted data is HTTP or some custom proprietary crazy thing. 

## Self-signed certificates

http://www.akadia.com/services/ssh_test_certificate.html

Things learned:

- "If the private key is no longer encrypted, it is critical that this file only be readable by the root user!" 
- You can remove the DES from the private key so that you don't have to
  type in the password all the god damn time when your server starts.
  (Verified this with a node app)

Turns out you could also just run the following:

    openssl req -new 

So why is DES required at all? I'm guessing it's possible to generate a
CSR without it, right?

## ALPN: Application-Layer Protocol Negotiation

Note to dummy: there's no TLS 3 way handshake. You're thinking of TCP
ACK SYN SYNACK that has to happen before app data is exchanged.

ALPN takes place during the

## SNI: Server Name Indication

[rfc, page 8](https://www.ietf.org/rfc/rfc3546.txt)

If you have a server that you want to host multiple sites with their own
respective TLS certificates,

## self-signed-certificate

Useful for testing SSL before you go ahead and buy a certificate for 3rd
party validation.

## AES vs RSA

AES is symmetric, and generally speaking symmetric encryption/decryption
is a lot faster than assymetric, hence AES is used for the
encryption/decryption of data. 

## Sprite gotchas

I used to think sprites were bitchin; save HTTP requests, combine all
your images into one. Obviously, these are lame application-level
optimizations/hacks to cover the ass of the transport layer's (HTTP's)
shortcomings (addressed in SPDY / HTTP 2.0).

Downsides of sprites:

- all the application-layer crap you have to do to handle it
- change a single pixel of a single image and you've busted a massive
  cached of all the other images in the sprite
- memory intensive; you might not be using each image but you have to
  load all of it in memory, might be too much for mobile clients

## Octet

It means byte. Saw it all over the place in the 
[HTTP 2 spec draft](https://datatracker.ietf.org/doc/draft-ietf-httpbis-http2/?include_text=1)

## nginx

After `brew install nginx`

    Docroot is: /usr/local/var/www
    
    The default port has been set in /usr/local/etc/nginx/nginx.conf to 8080 so that
    nginx can run without sudo.
    
    To have launchd start nginx at login:
        ln -sfv /usr/local/opt/nginx/*.plist ~/Library/LaunchAgents
    Then to load nginx now:
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
    Or, if you don't want/need launchctl, you can just run:
        nginx
    
    WARNING: launchctl will fail when run under tmux.

What is docroot?

- It's a file... not a directory?
- But you can delete it and replace with a directory and put an
  index.html in there and it works
- So I guess there's some default configuration of nginx that just hosts
  static files from this doc root directory

What do them commands does?

    ln -sfv /usr/local/opt/nginx/*.plist ~/Library/LaunchAgents

What are launchd and launchctl?

`launchd` is a daemon (conventions dictate that daemons end in a `d`).
`launchctl` is what you use to control that daemon. So if you want to 
schedule something to start 

What's the `mxcl` in `homebrew.mxcl.redis.plist`?

It refers to `mxcl`, maintainer of Homebrew. Just normal reverse domain
name notation. So does that mean any homebrew-installed domains get
prefixed like that? I'm guessing `mxcl` also made the Redis recipe.
Or maybe every homebrew daemon gets prefixed like that? Not sure, who
cares.

     In the launchd lexicon, a "daemon" is, by definition, a system-wide service of
     which there is one instance for all clients. An "agent" is a service that runs
     on a per-user basis. Daemons should not attempt to display UI or interact
     directly with a user's login session. Any and all work that involves interacting
     with a user should be done through agents.

[TN2083 - Daemons and Agents](https://developer.apple.com/library/mac/technotes/tn2083/_index.html)

Wow, "Daemonomicon" is an awesome word: "formal definition of the types
of bg programs you can write". 

- bootstrap server: launchd
- root session: first and last session. Boot-time processes and daemons
  live here. User-independent. e.g. `mDNSResponder`
- login session: proceses launched by or for a user live in login
  session. Login sessions are associated w authenticated users. Each
  user 

If I 

## Origins of TTY

http://www.linusakesson.net/programming/tty/

- stock tickers, then ASCII teletype within a network called Telex.
- Telex was a network that used level of current to respresent different
  characters, vs different voltages used by analog telephone shit
- Telex existed before integration w computers
- When command lines became the norm, teletypes were used as input and
  output since they were readily available on the market
- Lots of different models, needed to standardize in some way; UNIX
  philosophy dictated letting kernel handle low level word length, baud
  rate, flow control, etc., later things like color output, cursor
  movement, etc, was left to application (not kernel)
- Line editing is managed by OS-provided line discipline. Default is
  cooked/canonical mode. raw mode disables things like editing,
  backspace, and generally disables any IO processing within the line
  discipline. 

Skipping ahead, you can force your terminal into stty raw mode via

    stty raw #enable
    stty -raw #disable

Now I know how to write a Ruby impl of Press Any Key

    print "Press any key... "

    begin
      system("stty raw -echo")
      c = STDIN.getc
    ensure
      # re-enable
      system("stty -raw echo")
    end

    puts "Thanks!"

Note that it'll consume CTRL-C as well rather than signalling an
interrupt (hence CTRL-C prints "Thanks!" rather than terminating
immediately).

This is also how any text editor functions. 

This must be what's happening when I kill some script when it doesn't
expect it and then my terminals fucked. Typing in `stty -raw` even
though I can't see it probably would fix it... need to try.

Back to the thing:

- Kernel provides many line disciplines, only one attached to serial
  device at a time. Default is `n_tty`. I guess that's what we're
  configuring when we futz w `stty`
- Other disciplines are for things like packet switched data
- [tty C source code](http://www.cs.fsu.edu/~baker/devices/lxr/http/source/linux/drivers/char/n_tty.c)
- UART (Universal Async Receiver and Transmitter): converts teletype
  signal into bytes that the OS can process. OS has a UART driver.
- TTY driver: allows user to kill/suspend an infinite looped program,
  bg processes can process til they try to write to terminal (at which
  point they suspend), and user input to fg process only.
  (implemented in `tty_io.c`)
- TTY Device: triplet of UART driver, line discipline, and TTY driver. 
- TTY devices live in `/dev` w file mode `c` for "Character special
  file". To manipulate one, you need ownership of the device file
  (e.g. via `login`). 
- TTYs are just objects. Not alive. Other things plug into it. Those
  other things have execution contexts.
- pty = pseudoterminal, as opposed to TTY. 

`ps -o stat` prints out `Ss` `Ss+`, etc... here's what the capital
letters mean:

    R	Running or runnable (on run queue)
    D	Uninterruptible sleep (waiting for some event)
    S	Interruptible sleep (waiting for some event or signal)
    T	Stopped, either by a job control signal or because it is being traced by a debugger.
    Z	Zombie process, terminated but not yet reaped by its parent.

Most things are in `S`. An example of `R`:

    ruby -e 'loop {}'

`s` means session group leader. `+` means process is part of foreground
process group.

- Ctrl Z suspends a process, puts it in `T` state. 

Jobs, e.g. `fg` and `bg` are just process groups. Consider

    ruby -e 'loop {}'  | grep a | grep a | grep a

This causes as CPU-intensive loop and will be in R state. 

    USER     PID  PPID  PGID   SESS JOBC STAT   TT       TIME COMMAND
    machty 45754 45014 45754      0    4 R+   s045    7:03.43 ruby -e loop {}
    machty 45755 45014 45754      0    4 S+   s045    0:00.00 grep a
    machty 45756 45014 45754      0    4 S+   s045    0:00.00 grep a
    machty 45757 45014 45754      0    4 S+   s045    0:00.00 grep a

and when I suspend:

    USER     PID  PPID  PGID   SESS JOBC STAT   TT       TIME COMMAND
    machty 45754 45014 45754      0    4 T    s045    7:29.05 ruby -e loop {}
    machty 45755 45014 45754      0    4 T    s045    0:00.00 grep a
    machty 45756 45014 45754      0    4 T    s045    0:00.00 grep a
    machty 45757 45014 45754      0    4 T    s045    0:00.00 grep a

Everything below it suspends.

`jobs` are tied to session leaders, and terminals are session leaders.
If I go to another tmux pane and type `jobs`, the suspended job _won't_
show up; I have to be in the same terminal that started it. TODO: can I
change session IDs? 

If I `bg 1`, the following happens: 

    USER     PID  PPID  PGID   SESS JOBC STAT   TT       TIME COMMAND
    machty 45754 45014 45754      0    4 R    s045    7:39.63 ruby -e loop {}
    machty 45755 45014 45754      0    4 S    s045    0:00.00 grep a
    machty 45756 45014 45754      0    4 S    s045    0:00.00 grep a
    machty 45757 45014 45754      0    4 S    s045    0:00.00 grep a

Note how it's back to running, but note the missing foreground `+`. `fg 1`
would bring it back. 

Note that we could turn one of those greps into `R` if it was actively
processing data, e.g. 

    USER     PID  PPID  PGID   SESS JOBC STAT   TT       TIME COMMAND
    machty 46054 45014 46054      0    4 R+   s045    0:37.84 ruby -e loop { puts "a" }
    machty 46055 45014 46054      0    4 R+   s045    0:45.56 grep a
    machty 46056 45014 46054      0    4 R+   s045    0:27.01 grep b
    machty 46057 45014 46054      0    4 S+   s045    0:00.00 grep a

(Actually, the first 3 R's might be S's if you re-run this command;
there's a race condition as to whether the CPU is actually running code
or whether it's blocked on an IO syscall waiting for piped data to come
in, but the last grep is always S+ because it never gets output from the
`grep b`).

A Job is a Processs Group.

If you're just starting/stopping/piping processes, all those child
processes with have a parent process ID of `bash`'s pid.

What constitutes a job/process group? Piped commands for one. 
Let's see about Process Subsitution. Answer: process substitution
doesn't consider it as a pipe. It considers it as a shit of epic
fartitude. In other words, process substitution ends up being miserably
old and mortal and definitely going to die. In other words, process
substitution is not in the same process group. It's its own process
group. If you do `echo <(some long living thing)`, the long living thing
will survive as a sibling process, in its own process GROUP WHO CARES.

You can only read from  / write to TTY if you're foreground. If you're
not `fg` and you try and write to TTY, kernel will suspend your ass. 

- `ioctl` is the UNIX swiss army knife; manipulates special files like
  terminals.
- `ioctl` requests must be initated from processes, so the kernel can't
  asyncly communicate w an application unless the app asked for it.
- Signals are how kernel communicates asyncly w a process. Messy and
  error prone they are.

Question: nohup detaches into its own session id to prevent closing on
SIGHUP... why does it have to do that? Why can't it just ignore that
signal? Let's see.

    Signal.trap(:HUP) do
      puts "I WILL NOT"
    end
    sleep

If I ssh localhost and run that in background (with `&`) and then
logout, it stays running, PPID changes to 1 (root). So how is that
different than nohup? TODO: find out. Something with setsid, etc.

SIGINT's originate from the terminal... is it correct to say they
originate from TTY? I think it is based on the `n_tty.c` code.
Also, in raw mode it doesn't even fire. COOL. 

- SIGPIPE isn't just an error but also a way to know whoever was
  listening to you has stopped listening to you, e.g. `yes | head`.
- SIGSTOP is to SIGTSTP as SIGKILL is to SIGQUIT.
- SIGCONT can be sent to a ^Z-suspended process. It behaves as if you
  started the process with `&`. It's running, but it's bg. In other
  words, if you have a suspended process 12345, `bg 1` or 
  `kill -CONT 12345` would do the same thing; it'd start running in the
  background, spitting out output
- You can break shit with 
  `ruby -e 'Signal.trap(:TTIN) { puts "wat" }; sleep 1; gets' &`
  (recursive SIGTTIN). You try and write to TTY in the background and
  then keep ignoring the signal that it's failing. I don't know what
  causes the deadlock though, but _something_ screwing up sounds right.
- If you press ^Z, that sends a message to the foreground process group.
  The line discipline sends `SIGTSTP` to the foreground process group. 
  This will suspend the whole process group, whatever the main 

Question: if you use pipes combined with `&`, what gets put into the
background? All tasks? Answer (I think): `&` ultimately results in a
process group getting put into the background, and a process group
contains any pipes, child processes, etc, so it _must_ apply to all of
the different processes as a whole, and there's no way to say that only
one of the pipe segments runs in the background. 

Fun fact: you can reimplement the default ^Z behavior as follows:

    has_ignored = false
    Signal.trap(:TSTP) do
      if has_ignored
        Process.kill(:STOP, Process.getpgrp)
      else
        has_ignored = true
        puts "ignoring"
      end
    end

    sleep

TL;DR the default SIGTSTP ^Z handler fires a STOP. You can catch TSTP
and immediately do the same for the same effect. 

Vim's source code (and probably everyone's) does some variant of

    settmode(TMODE_COOK);
    kill(0, SIGTSTP);	    /* send ourselves a STOP signal */

So, you return TTY mode to cook mode. 


- If you run something like `echo "wat" | less &`, you'll immediately
  see `[2]+  Stopped   echo "wat" | less` because `less` is always going
  to try and write to TTY in a raw manner...? 
- If you suspend, say, vim, vim will catch the SIGTSTP, move the cursor
  to the last line of the screen w control signals (it's still attached
  to TTY) and then fires a SIGSTOP.
- Once stopped, a SIGCHLD is sent to the session leader with the pid of
  the suspended process. When all processes in fg have been suspended
  (T'd), the current TTY config is stashed for later restoration
  (`stty -g` is one way of doing this). 

So why doesn't ^Z suspend bash? 

Ahh, so here's how you get TTOU to fire (and cause a process to suspend)

    ruby -r "io/console" -e "IO.console.raw { puts 'wat' }" &

Note that if we hadn't used `.raw` to put TTY in raw mode, it would have
just printed "wat" into the same terminal even though the process is
running in the background, but if you grab full control of the TTY with
`raw`, it'll cause a TTOU.

You can go in and configure another TTY to update its rows/cols. I can
fuck w the vim in another tmux pane, tell it its skinnier/wider than it
is, but once i resized a tmux pane then BOOM it fires its own tty
commands, and tty fires a SIGWINCH, and then that causes vim to query
the tty for the current width and repaint.

Ah: realization: the ultimate decider in whether TTOU fires is whether
topstop 

## `read`

    read words < <(echo "wat")
    echo $words

## resetting the keyboard when things go crazy

`reset`, or typing Escape and c.

    stty raw
    reset

and we're back. It resets your TTY driver, I guess.

## `yes`

Repeatedly enter `y` for saying yes to everything. Like the dropper bird
from the simpsons when homer gets fat. You can also do `yes no` to say
other things.

## Ack

is written in Perl.

## 100 Continue status

An HTTP 1.1 mechanism.

http://www.w3.org/Protocols/rfc2616/rfc2616-sec8.html

In some cases, a server knows just by looking at request headers that it
won't process the request, making it potentially wasteful for the client to send a
giant doomed-to-fail payload. In these cases, the client can decide not
the send the full payload unless the server has told it "based on your
headers, you should Continue sending this full payload because I don't
see any reason why it should fail, just by looking at the headers."

To opt into this, the client must provide the following header:

    Expect: 100-continue

The server will see this, decide if the request will succeed, and if so,
it send back 100 Continue and keeps reading from the input stream.
Client then sends the whole payload.

Proxies can reject if it knows the next-hop server is HTTP 1.0 or less
with a 417 Expectation Failed. 

## IOS8 breaks file uploads in Safari

http://blog.fineuploader.com/2014/09/10/ios8-presents-serious-issues-that-prevent-file-uploading/

Jesus. No workaround? Apple, you suck.













