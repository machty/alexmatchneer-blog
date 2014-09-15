---
layout: post
title: "Daily Journal"
date: 2014-09-06 14:30
comments: true
categories: 
---

## netcat (nc)

Utility to spinning up arbitrary tcp servers for testing, sending
packets, etc.

    Socket.new(Socket::AF_INET, Socket::SOCK_STREAM)
    or symbols:
    Socket.new(:INET6, :STREAM)

INET = internet, specifically IPv4, `SOCK_STREAM` means a TCP stream
will be set up, as opposed to `DGRAM`, which would set up UDP.

Set up bullshit listener:

    nc -l localhost 4481

## Loopback

`localhost` is a loopback, which is a virtual interface where any data
sent to the loopback is immediately received. `127.0.0.1` is the IP. 

Check dat `/etc/hosts` file:

    ##
    # Host Database
    #
    # localhost is used to configure the loopback interface
    # when the system is booting.  Do not change this entry.
    ##

Funny how I never notice stuff like that until someone officially
defines it for me. 

## "well-known" ports

Hosted by IANA.org, the Internet Assigned Numbers Authority.

## Gerrymandering

> manipulate the boundaries of (an electoral constituency) so as to favor one party or class.

Knew what this was, forgot the word for it. 

## AWS Spot Instances

Running interruption-tolerant applications on EC2 unused capacity, where
you can bid on price per hour and maximum bid price. 

## Chekhov's Gun

http://en.wikipedia.org/wiki/Chekhov's_gun

> Remove everything that has no relevance to the story. If you say in the first chapter that there is a rifle hanging on the wall, in the second or third chapter it absolutely must go off. If it's not going to be fired, it shouldn't be hanging there.

Anton Chekhov is considered to be among the greatest writers of short
stories in history. Guess I should start reading.

## Binding to an interface

You can bind to a single interface, or ALL interfaces, lol!

`0.0.0.0` means all interfaces. I guess that means that requests to
localhost, and potentially some other external facing interface, will
route requests to this socket. So what if someone has already bound
specifically to localhost:12345 and you try to bind to `0.0.0.0:12345`?

Answer: I don't know... need to learn about what other interfaces are
available

REVISED ANSWER: I can use the IP provided by my router.

    ruby -run -e httpd . --port=4124 --bind-address=192.168.1.3

Then if I type `localhost:4124` in the browser, it don't work, but if I
type `192.168.1.3:4124` in the browser, IT WORKS. :)

But to the original question, it turns out you can run ALL THREE of
these:

    ruby -run -e httpd . --port=4123 --bind-address=0.0.0.0
    ruby -run -e httpd . --port=4123 --bind-address=192.168.1.3
    ruby -run -e httpd . --port=4123 --bind-address=localhost

So the first and 3rd of these should be able to respond to 

    curl localhost:4123 > /dev/null

It seems that the third (localhost) always wins. Makes sense. What about 

    curl 192.168.1.3:4123 > /dev/null

And the more specific second one always wins. So I guess the OS will
look for a match of interface+port before falling back to 0.0.0.0. 
Makes sense.

## listen queue size

    socket.listen(10)

This means your socket will buffer up to 10 connections before
`ECONNREFUSED` is return to the shits on the other side. 

If you're getting a lot of ECONNREFUSED, it probably means users are
already experiencing some some queue-based lag, and you should rethink
your architecture, spin up more server instances, etc. But you can also
just set to the max size via 

    server.listen(Socket::SOMAXCONN)

## A connection is a socket

When you accept() after binding, you'll get a connection object, which
is just a Socket, but different from your server socket; it's just a
file wrapper for that particular connection that you can write shit to. 

## quadruple of remote/ip/port must be unique

You can't have more than one connection where

    local addr, local port, remote addr, and remote port

are not totally unique. Hmmm, so where is this prevented? TODO

## Close socket file descriptors

Why, doesn't this happen automatically on exit/GC?

1. GC might not clean up for you fast enough;
2. Might hit file descriptor limit

Wat wat wat wat in the boot.

You can close the read side, or close the write side, or both. This make
use of `shutdown`, and shutdown will close a side of a connection even
if you're dup'd file descriptors (explicitly or via fork). `close`
wouldn't actually close unless there were no other file descriptors
holding on to that socket. 

## Keybase

Uses social media accounts to prove crypto identity.

## Clients don't need to bind

to a port when connecting to a server. For obvious reasons. Namely that
a server needs to have a known/consistent port in order for clients to
reach it, but a client can just send from any ol po,]rt. 

## Long ass timeouts

    require 'socket'
    socket = Socket.new(:INET, :STREAM)
    remote_addr = Socket.pack_sockaddr_in(666, 'machty.com')
    socket.connect(remote_addr)

This won't fail any time soon. (Note if i'd given a BS DNS then it would: SocketError
exception from getaddrinfo). Only after a long ass time do you get a
ETIMEDOUT. 

getaddrinfo seems cool. I guess it's the C function that does a DNS
lookup? Nevermind, man `getaddrinfo` makes me cry.

So when does ECONNREFUSED happen vs just a long ass timeout? I guess it
means you've hit a server but a) no app is bound to the requested port
or b) the queue is full, and probably c) some other reason. No that's
not valid; google.com:70 hangs for a while rather than ECONNREFUSED. 

Maybe localhost knows what's connected or not? I have NO IDEA.

## `TIME_WAIT`

If you close a socket with pending outbound data, it won't discard that
data but rather finish sending (and wait for ack) before totally closing
the socket. This is the `TIME_WAIT` state. Unless you've enabled
`REUSEADDR`, you'll get an `EADDRINUSE` if you try to bind to a socket
that's still in `TIME_WAIT` state. 

## `EAGAIN`

Commonly seen in non-blocking IO operations when there's no data
available to read. Reading nonblockingly from a socket that hasn't had EOF set yet but
doesn't have data at the moment would cause that.

Non blocking reads will find any data in Ruby buffers, followed by
kernel buffers. If there's nothing in there, then blocking read is
necessary.

## Ruby IO.write

`IO.write_nonblock` behavior maps to sys call `write()`, in that it can
fail to write all the data you provided it. Ruby's `IO.write` tries to
be helpful and might internally call `write()` many times.

A saturated `write()` followed immediately by `write()` will cause an
`EAGAIN` because you haven't given the kernel/network enough time to
flush the data you gave it. This is when you'd use `IO.select` to let
you know when a socket is available for writing/reading again.

Wat wat wat. In the BOOT.

`select` returns an array of descriptors that are ready to be written
to. I guess it blocks? 

Writes are blocked by TCP congestion prevention algo requirements 
(cwnd, rwnd, etc). 

There's also `accept_nonblock` which `EAGAIN`s if there are no pending
connection on dat queue.  

`connect_nonblock` is sp

## TPC Resets

http://en.wikipedia.org/wiki/TCP_reset_attack

There's a usually-0 flag in a packet that can be set to 1 that tells the
receiver to stop using this TCP connection. Useful, for instance, when a
computer's crashed, gets a packet it has no context for, so it tells the
sender to stop it, so that it might make a new connection and start from
there.

## Edge Device

http://en.wikipedia.org/wiki/Edge_device

Basically, all the stuff that separates the public network (internet)
from your private network.

- routers
- routing switches

## traceroute

I've already written about this before, but traceroute is useful for
tracing all the gateways your packet goes through to get to its
destination.

A gateway is any node that might forward packets along to some other
destination. Could be a router, switch, etc. Could also be a protocol
converter. Gateways could be software too.

Anyway, traceroute makes use of ICMP `TIME_EXCEEDED` response.

[What is ICMP?](http://en.wikipedia.org/wiki/Internet_Control_Message_Protocol)

One of the many protocols that can be communicated via packets. Packets
have an 8 bit protocol field. The protocol values are decided by the
IANA (just like common/reserved ports... MIND BLOWN).

The list is here: http://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml

## `host google.com`

I noticed that the DNS lookup results via `host google.com` differed
almost each time I ran it.

    google.com has address 74.125.226.72
    google.com has address 74.125.226.65
    google.com has address 74.125.226.68
    google.com has address 74.125.226.67
    google.com has address 74.125.226.64
    google.com has address 74.125.226.70
    google.com has address 74.125.226.78
    google.com has address 74.125.226.69
    google.com has address 74.125.226.73
    google.com has address 74.125.226.71
    google.com has address 74.125.226.66
    ...

and then 
    
    google.com has address 74.125.226.2
    google.com has address 74.125.226.5
    google.com has address 74.125.226.8
    google.com has address 74.125.226.9
    google.com has address 74.125.226.6
    google.com has address 74.125.226.4
    google.com has address 74.125.226.3
    google.com has address 74.125.226.14
    google.com has address 74.125.226.7
    google.com has address 74.125.226.0
    google.com has address 74.125.226.1
    ...

I'm asking the friendly folk at `##networking`. They turned me on to
`dig`. `dig` is the most raw and flexible DNS lookup tool. `host` is
apparently for chumps (i.e. it's useful/quick/easy but not as much
functionality).

    dig google.com @ns1.google.com +short | sort | md5

This queries a specific name server...

OK i have a bunch of questions:

Why do DNS records contain
[Fully Qualified Domain Names](http://en.wikipedia.org/wiki/Fully_qualified_domain_name)
as references to name servers? That seems to make no sense... you have
to turn something like `ns1.google.com` into an IP by querying... the
DNS system? 

Answer: http://en.wikipedia.org/wiki/Domain_Name_System#Circular_dependencies_and_glue_records

- GET www.example.com /
  - Look up record, find its NS records
  - NS ns1.example.com
  - Need to get IP of ns1.example.com (we need to issue another DNS
    request)
  - ... circular dependency: you have to look up a name server's IP
    using that name server. Need some way to break dependency
  - Dependency broken by `AUTHORITY SECTION`, e.g. 
  
    ;; AUTHORITY SECTION:
    google.com.             60      IN      SOA     ns1.google.com. dns-admin.google.com. 1566886 7200 1800 1209600 300

This is called the "glue". It's either in Authority or Additional
section? (I should find this out.)

Related: http://support.dnsimple.com/articles/vanity-nameservers/

DNSimple allows "vanity" name servers, which lets you pretend like
you're a bigass enough company to own/maintain your own name servers,
and anyone looking at your DNS records will see your fake name servers,
like ns1.machty.com, but these servers obviously don't actually exist;
DNSimple provides this service by sending "glue" that maps your fake
name servers to the IP addresses of their actual name servers. 

Top-level domains live under root (.).

http://www.tldp.org/HOWTO/DNS-HOWTO-5.html

That's why sometimes you'll see stuff ending in a period, like
`ns1.dnsimple.com.`.

    ;; ANSWER SECTION:
    dnssimple.com.          597     IN      A       184.168.221.96

The dot is important! You know how you can just put `www` is the record
value? You could also do a fully qualified shit e.g. `www.machty.com.`
(note the period at the end).

So my question is: when does the glue record get sent?

Gimme the NS records for www.machty.com
    
    $ dig machty.com NS
    ...
    ;; ANSWER SECTION:
    machty.com.             3481    IN      NS      ns1.dnsimple.com.
    machty.com.             3481    IN      NS      ns1a.dnsimple.com.
    machty.com.             3481    IN      NS      ns2.dnsimple.com.
    machty.com.             3481    IN      NS      ns2a.dnsimple.com.
    machty.com.             3481    IN      NS      ns3.dnsimple.com.
    machty.com.             3481    IN      NS      ns3a.dnsimple.com.
    machty.com.             3481    IN      NS      ns4.dnsimple.com.
    machty.com.             3481    IN      NS      ns4a.dnsimple.com.

Cool, so internally it'd need to look up ns1.dnsimple.com, so something
like:

    $ dig @ns1.dnsimple.com. www.machty.com

http://www.tldp.org/HOWTO/DNS-HOWTO-5.html

> +norec means that dig is asking non-recursive questions so that we get to do the recursion ourselves. The other options are to reduce the amount of dig produces so this won't go on for too many pages:

    a.root-servers.net.	518400	IN	A	198.41.0.4
    a.root-servers.net.	518400	IN	AAAA	2001:503:ba3e:0:0:0:2:30

AAAA records serve the same purpose as A records, just that they are
IPv6.

WebPageTest.org: breaks your requests down into blah blah blah why is
this different than Network tab in devtools? Ah because it does it from
many different browsers. 


162.212.105.24


## Turntable.fm

Me: "there should be an app where multiple people have a playlist, but
there's a single player that alternates between different people's
playlists."

Person next to me: "yes, that's turntable.fm"

Should probably check that out.

## non-blocking connect

http://stackoverflow.com/questions/8277970/what-are-possible-reason-for-socket-error-einprogress-in-solaris

There are two error codes for "shit is underway" when doing a
non-blocking connect/accept:

     [EALREADY]         The socket is non-blocking and a previous connection attempt
                        has not yet been completed.

     [EINPROGRESS]      The socket is non-blocking and the connection cannot be com-
                        pleted immediately.  It is possible to select(2) for comple-
                        tion by selecting the socket for writing.

Nice docs yo. The difference is that `EINPROGRESS` is the error that
gets returned if the operation has started but hasn't finished (as
opposed to not yet being able to start because it can't allocate the
resources it needs, file handlers, sockets, etc.). Most likely, the 3
way handshake packets have been sent, but SYN-ACK hasn't been sent. 

## Inversion of Control / DI

Matthew Beale and I were discussing whether the proposed
`Ember.service()` violated the inversion of control that dependency
injection is meant to provide, e.g.:

    export default Controller.extend({
      foo: Ember.service() // request that 'service:foo' be injected
    });

The fact that the consumer is requesting a specific thing to be injected
into it seems like it might be an IOC violation, but to me, all that's
happening is that you're specifying a provider, and it's still up to the
outside world to decide what it'll specifically inject into you. Also,
regardless of whether it's explicit or not, if you use whatever is
injected into you, you are implicitly specifying a duck-typed provider
interface by the consumer; in other words, if we do things the classic
way and use `app.inject('controller:article', 'articleLookup', 'service:article-lookup')`,
this may seem like we're moving all "control" to the injector, but
still, the article controller is going access `articleLookup`'s
properties and methods in a very specific way, which is the most
powerful / crucial way that you could specify a dependency (by
describing / using the duck type interface).

So, tl;dr, your consumer is always going to be specifying its
dependency, whether explicitly (`Ember.service()`) or implicitly (by
whatever methods/properties it uses from `this.injectedThing`), and it's
therefore not a violation for a consumer to specify a Provider of the
dependency, so long as it's still possible for the injector to disregard
the specifically-requested provider and substitute another one (e.g. a
stub) in its place. 

This is what Angular's [di.js](https://github.com/angular/di.js) does
and I think it's correct. I want it.

## Password-less SSH

I've done this a bunch of times before but always forget, now I'm
writing about it:

The remote server you're SSHing into needs to have your public key if
you want to be able to skip providing a password every time you ssh in.
I wanted to use a different public rsa key, so I made a new one:

    ssh-keygen

The optional passphrase you're asked to supply is NOT the same password
you would have otherwise needed to use to log into SSH (which we're
trying to avoid). Rather, it's an additional security measure that's
required every time you want to use your private RSA key to try and
decrypt data. I guess: if private RSA keys are a kind of password, the
passphrase is a password for your password. It means that someone who
steals your private key also needs to know your passphrase in order to
use it.

Anyway, let's say I save the newly generated key pair to
`~/.ssh/shortcut_rsa` and `~/.ssh/shortcut_rsa.pub`, now I want to make
it possible to just type `ssh shortcut` and have it never ask me for a
password again. This means I need a few things:

1. `ssh shortcut` should translate into the IP I'm connecting to
   (because I'd rather not type the IP every time and `shortcut` is not
   a domain name that'd do the translating for me)
2. `ssh shortcut` should supply the user name that the remote machine
   expects (so that I don't have to do `ssh remote_user_name@shortcut`).
3. `ssh shortcut` should use the key pair I just generated w
   `ssh-keygen`.

To do all of these things, I need to append the following to
`~/.ssh/config`.

    Host shortcut
      HostName 162.123.123.123
      User remote_user_name
      IdentityFile "/Users/machty/.ssh/shortcut_rsa"
      IdentitiesOnly yes

Pretty self explanatory and does the job. Note that you'll be prompted
for the passphrase you provided for your RSA private key, but that'll be
cached for a little while, and if you want, you can just save it to your
Apple keychain if you feel safe doing that.

The SSH config file also allows for wildcards, so you could literally do 

    Host *
      HostName 162.123.123.123
      User remote_user_name
      IdentityFile "/Users/machty/.ssh/shortcut_rsa"
      IdentitiesOnly yes

and then this would cause `ssh somerandombullshit` to connect to the
same remote machine. Obviously that use case is a little nuts, but it's
useful if you wanna say "every remote machine I connect to should use
this same RSA key pair". 

## say+say+say = choir

I devised the most badass script.

    #!/usr/bin/env sh
    
    # use/uncomment this instead to weed out the annoying singing voices
    #voices=`say -v ? | grep en_US | grep -v Cellos | grep -v Good | grep -v Hysterical | grep -v Bad | grep -v Pipe | grep -v Bells | cut -f1 -d ' '`
    voices=`say -v ? | grep en_US | cut -f1 -d ' '`
    num=`echo $voices | wc -w`
    echo $voices | xargs -n 1 -P $num say $* -v

## How many segments are sent per SSH character?

http://blog.hyfather.com/blog/2013/04/18/ssh-uses-four-tcp-segments-for-each-character/

Answer: 4

1. You: Hey SSH server, user pressed 'b'
2. SSH: cool, got it (ack)
3. SSH: hey btw, this is what `bash` (or whatever shell) ended up doing
   with that character you type (description of screen update)
4. You: cool, got it (ack)

What's the difference between a segment and a packet?

- Segment: TCP header + application data
- Packet: wraps segment w IP header information; a packet is a routable
  piece of data

This seems like the best answer: http://superuser.com/a/505134

A TCP segment is not enough information to know where to route data
within a network; you need IP headers for that, and where do those shits
live? In packets.

Take a packet and rip off its IP head: voila, a packet. Take a packet
and rip off its TCP (or UDP) head: voila, application data.

Don't forget "frames": frames wrap packets. If you wanna send your shit
over an ethernet, you need to wrap in a frame, whether wired or
wireless. Frames have MAC addresses. MAC addresses are generally
hard-wired into some hardware and are never expected to collide, lest
undefined behavior.

Now my question is: does TCP ever have access to IP headers? I guess it
must get forwarded along in some way... then again I dunno.

## RFC3439: Some Internet Architectural Guidelines and Philosophy

http://tools.ietf.org/html/rfc3439

Clearly I need to read this.

## Nagle's Algo

When sending data:

1. If there's enough data in local packet buffer to comprise a whole TCP
   packet, send that shit.
2. If no pending data in buffers and no pending acks, send immediately.
3. If there's a pending ack, and not enough data to fill a packet, put
   data in local buffer. 

This prevents protocols like telnet from saturating with
one-packet-per-char traffic. For telnet, if you type a bunch of chars in
a row, you could expect that the first char would send immediately and
the following ones would buffer and then send once the first char's ack
came back.

All Ruby servers disable this since Ruby does its own internal buffering
in the socket lib. You disable by sending with NODELAY.

## URG flag

Apparently you can break the FIFO-ness of TCP with Urgent data. 

`Socket#send` is the same as `write` except that you can pass flags to
`send`, e.g.

    socket.send 'urgent data', Socket::MSG_OOB

OOB stands for out of band. Note that the receiver must use the same
flag w `recv` to read the OOB data or else it won't notice it.

OOB is rarely used because:

- only one byte of urgent data can be sent
- there are issues w `select` wherein consumed urgent data continues to
  be reported as unread, requires additional state tracking to get
  right, etc.

You could also use OOBINLINE flag to stick in an urgent byte amidst
normal queued data, and `read` will stop once it hits an urgent thing. 

I'm guessing OOB is only a TCP thing since in UDP there's no concept of
connection and "in order".

## Datagram

Data + telegram. From RFC 1594:

> “A self-contained, independent entity of data carrying sufficient information to be routed from the source to the destination computer without reliance on earlier exchanges between this source and destination computer and the transporting network.”

> The term datagram is often considered synonymous to packet but there are some nuances. The term datagram is generally reserved for packets of an unreliable service, which cannot notify the sender if delivery fails, while the term packet applies to any packet, reliable or not. Datagrams are the IP packets that provide a quick and unreliable service like UDP, and all IP packets are datagrams;[4] however, at the TCP layer what is termed a TCP segment is the sometimes necessary IP fragmentation of a datagram,[5] but those are referred to as "packets".

So, datagrams imply unreliability of delivery, whereas packet could
refer to reliable or unreliable packets. I guess a TCP segment is a
packet. But you can't call it a datagram, since the protocol makes it
its business to be a shit.

## Bill Burr

How's your danish?


















