---
layout: post
title: "Daily Journal"
date: 2014-08-22 16:32
comments: true
categories: 
---

## Difference b/w XSD and DTD

They both define the structure of an XML document, but what's the
difference?

Awesome SO:
http://stackoverflow.com/questions/1544200/what-is-difference-between-xml-schema-and-dtd

DTD's are arguably easier to grok, but the XSD has more features, but at
the expense of understanding the abstractions of data types and what
not. Seems easier to describe recursive structures in XSD than the other
bullsharticles.

XSD is XML, DTD stems from SGML.

I guess XML And HTML also stem from SGML. WHAT DO I KNOW? NOTHING!

## Wolf3d in React

Apparently I missed this https://github.com/petehunt/wolfenstein3D-react.git

## Breaking the chain in React

For when you want to tell React "don't mess with my DOM, I'm doing funky
jQuery shit".

Render a div that won't invalidate:

https://gist.github.com/rpflorence/4c5044b217e0a67c2c4d#file-react-opt-out-js-L47

Re-render your own children:

https://gist.github.com/rpflorence/4c5044b217e0a67c2c4d#file-react-opt-out-js-L15-L18

## Retcon: retroactive continuity

http://en.wikipedia.org/wiki/Retroactive_continuity

"alteration of previously established facts in the continuity of a
fictional work"

## CVV can mean lower rates

http://security.stackexchange.com/questions/21168/how-does-amazon-bill-me-without-the-cvc-cvv-cvv2

There are fraud-prevention benefits to using CVV, and as such, payment
handlers will often give you a discount if the CVV is present.

## X-Forwarded-For

Some servers fall prey to IP spoofing via setting the `X-Forwarded-For`
header. If your server isn't careful, then given a 
`curl -H "X-Forwarded-For: 1.2.3.4" http://www.machty.com`, your
server's logs and maybe even IP-dependent application logic (e.g.
language detection) might use 1.2.3.4. 

In Rails you can add your known proxy/load-balancing IPs to
`TRUSTED_PROXIES`. Then the `RemoteIp` rack middleware will filter out
all of those and pick the most recently set IP, which handles the case
where you might have multiple `X-Fowarded-By` headers. So the rule is:
use the rightmost, untrusted IP and treat that as the remote ip. Why?
Because when your first proxy is hit, it'll see IP X.X.X.X and move that
to the list of `X-Forwarded-By` headers. Note that the previous
`X-Forwarded-By` headers, present or no, are untrustable and totally
spoofable. 

http://blog.gingerlime.com/2012/rails-ip-spoofing-vulnerabilities-and-protection

So that's IP spoofing via HTTP header. How else can you IP spoof?

http://en.wikipedia.org/wiki/IP_address_spoofing

You just rewrite the source IP in the TCP/UDP packet header, which also
means when the application responds, it'll send it back to the forged
IP.

There are valid use cases for this as well, such as testing load
balancing software/hardware.

## Types of NAT

http://think-like-a-computer.com/2011/09/16/types-of-nat/

### Full cone NAT (Static NAT) (port forwarding)

Manual mapping of public IP and port to LAN IP and port.

e.g. all incoming traffic to port 12345, forward to 192.168.0.10:9999.

Blocks (drops connection): 

- Ports that haven't been forwarded

### Restricted cone NAT (dynamic)

Don't allow incoming data from an IP unless I've sent packets to it
already. Note that depending on the strictness, if I initiate a
connection to WAN IP 1.2.3.4:1234, I could potentially get data from
1.2.3.4:5678, but in stricter schemes, the port must also match.

But regardless of this strictness, the one requirement is that they send
data to exactly my public IP and port that I sent data out of.

### Symmetric NAT

http://think-like-a-computer.com/2011/09/19/symmetric-nat/

Sym NAT is like port-restricted cone NAT, but randomly generates
different public source ports when sending to different destinations.

Sym NATs are the only ones that cause problems with other devices behind
NATs.

## Vim registers

So if I have 

    <a href="WAT"></a>

and I want to replace the href with a yanked "LOL", then I can `di"` in
WAT to delete it, then `"0P` to use the last-yank register 0. Registers
1,2,3,4,5... get populated with cuts. Unnamed register gets replaced by
any yanking/cutting command. Weird terminology.

## Ember-cli + divshot

Holy shit this was awesome.

Divshot.com is a static deployment heroku, basically, and ember-cli has
an addon for letting you deploy there.

    npm install --save-dev ember-cli-divshot && ember generate divshot

## brew install fuck

naw, but this is a cool script for killing them all:

    #!/usr/bin/env ruby
    # coding: utf-8
    
    abort "Usage: fuck you <name>" unless ARGV[0] == "you" && ARGV.size == 2
    
    a = "abcdefghijklmnopqrstuvqxyz".each_char.to_a
    b = "ɐqɔpǝɟƃɥıɾʞʃɯuodbɹsʇnʌʍxʎz".each_char.to_a
    ws = Hash[a.zip(b)]
    ws.default = ->(f){f}
    
    puts "\n  (╯°□°）╯︵ #{ARGV[1].reverse.each_char.map{|f|ws[f]}.join}\n\n"
    
    system("killall -9 #{ARGV[1]}")
    exit $?.exitstatus

