---
layout: post
title: "Daily Snaggletooth"
date: 2014-09-23 11:18
comments: true
categories: 
---

## Nginx Heroku Buildpack

https://github.com/ryandotsmith/nginx-buildpack

> Some application servers (e.g. Ruby's Unicorn) halt progress when
> dealing with network I/O. 

This was confusing at first but I think it just means that since
Heroku's router only buffers headers and not the entire request, it's
possible that a slow client with a large payload will hog a unicorn
worker due to a slow blocking `read()`, in which time that worker isn't
available to process other requests.

The proposed nginx buildpack solution is to put nginx in front of an
IO-bound (and poorly designed/optimized) server and buffer the entire
request and not engage the app server until all the data is there, and
then it can barf the entire request into the app server in one shot,
minimizing blocking IO.

In general though Unicorn is non-ideal in the following cases:

- Slow client and/or large payload
- The app server is internally IO-bound and makes, say, lots of long
  slow 3rd party API requests, because in that time it's blocking
  requests that otherwise could have been handled in a less IO-bound
  setting

## TTL: Time to Live

http://en.wikipedia.org/wiki/Time_to_live#IP_packets

Some reason I always pronounced "live" as a-live. Rather than the verb
"live". Why? I don't know. Time to Live (verb) makes way more sense. How
much time it has to live, rather than, how much time until it is live.
Ridiculous. 

- IP: a per-gateway decrementing value (as opposed to a unit of time).
  In other words: IP TTL is max hop.
- DNS: time in seconds that a DNS record can be cached. Low values tax
  authoritative name servers. Higher values risk staleness. 86400 (24
  hours) is common. Before a DNS change, DNS admins might change to a
  lower number in advance. QUESTION: why would I, selfish DNS admin, not
  just choose a TTL of 1 all the time? Presumable answer: DNS is another
  roundtrip unless cached; I might be making my application slower.
  Additionally, if DNS goes down (probably rare?), my clients can
  still use 
  `#networking` validates my presumable answer.

## HTTPSAP

HTTPS Ain't a Protocol. It's just HTTP layered over TLS, an encrypted
transport layer.

## Resetting Wifi of Remote Mac server

Heh, this worked

    #!/bin/bash
    
    networksetup -setairportpower en1 off
    sleep 10
    networksetup -setairportpower en1 on

Run via `nohup ./thisdumbscript &`.

SSH will be unresponsive for 10+ seconds and then recover. The Magic of
the INTERNET!

## WebSockets and proxy servers

http://www.infoq.com/articles/Web-Sockets-Proxy-Servers

Websockets work on port 80 and 443:

> HTML5 Web Sockets do not require new hardware to be installed, or new ports to be opened on corporate networks--two things that would stop the adoption of any new protocol dead in its tracks.

Transparent proxy server: let's stuff through, might manipulate content?

## BOSH: Bidirectional-streams Over Synchronous HTTP

http://en.wikipedia.org/wiki/BOSH

Isn't this just long polling? It's long polling with the assurance that
immediately after receiving a "push", the client makes a new long-lived
request on the same keep-alive connection. And it can make no more than
one connection whenever it needs to send data. Why does this have its
own stupid name?

## SSH Tunneling

First off, you can just execute commands like

    ssh machty@whatever.com ls

and assuming I've already done the keygen stuff, that'll log in, run
`ls`, and output the result of that.

But you can use `ssh` to spin up a local server that makes your SSH
connection act as a proxy to some other IP/port, map that to a local
port, and then connect other things through to that local port. 

If I did 

    ssh machty@wat.com -L 8080:somesite.com:80

Then I could do

    curl localhost:8080

and then see the contents of somesite.com as a request originating from
the wat.com server I "logged" into. (Except that most sites don't
respond the way you'd like if `Host` and other headers are incorrect).

## What is my public IP?

You need some third party to tell your your public IP after all the NAT
traversals. You shouldn't use this for super sensitive stuff (it's
possible the 3rd party server was compromised and maaaaybe there's some
exploit if you use this fake IP for some internal thing?). 

But this worked for me: 

    curl icanhazip.com

Someone on SO suggested this: http://www.moanmyip.com/

I can't believe that exists.

## SOCKS proxy

https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-tunneling-on-a-vps

http://en.wikipedia.org/wiki/SOCKS

With a SOCKS proxy 

## tcptraceroute

Instead of ICMP ECHO packets, which often get filtered out at some point
by some asshole proxy along the way to the destination, tcptraceroute
uses TCP SYN packets instead. What's that you say? Don't we still need
the incrementing TTL that ICMP uses? TRICK QUESTION: TTL is an octet in
the IP packet, which wraps TCP/UDP/ICMP. So `tcptraceroute` still uses
TTL. It's also nice enough to send a TCP RST (reset) package if the the
destination responds with a SYN|ACK so that you don't leave it in a
connection-half-opened state (normally you're supposed to send an ACK
and then start sending application data). 

Interesting: you need root privileges to run tcptraceroute. Why? Because
the custom SYN packets it creates requires root privileges, probably to
prevent non-privileged users from doing malicious things with packets.
I'd be curious to know exactly where that takes place though.

## IP packets have no port

Why? Because ports map to applications, a concept which IP packets don't
care about; they're all about getting messages to an address. Leave it
to the UDP/TCP packets to provide a source and destination 

So hmmm how does ICMP traceroute work? How do the ECHO'd packets know to
come back to that specific traceroute command?

## ICMP

- No port

There's a single ICMP socket apparently?

https://www.cs.utah.edu/~swalton/listings/sockets/programs/part4/chap18/ping.c

    /*
     * pr_pack --
     *	Print out the packet, if it came from us.  This logic is necessary
     * because ALL readers of the ICMP socket get a copy of ALL ICMP packets
     * which arrive ('tis only fair).  This permits multiple copies of this
     * program to be run without having intermingled output (or statistics!).
     */

- ident = getpid() & 0xFFFF;
  - this is how a pong that returns is identified as originating from a
    pong.

Anyway here's a little Ruby program you can run with `sudo`
that'll open a raw socket and print a Base64'd ping packet if you 
`ping localhost`.

    require 'socket'
    require 'base64'

    rsock = Socket.open(:INET, :RAW)

    loop do
      s = rsock.recv(1024)
      enc = Base64.encode64(s)
      puts enc
    end
























