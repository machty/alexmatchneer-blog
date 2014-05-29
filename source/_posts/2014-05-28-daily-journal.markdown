---
layout: post
title: "Daily Journal"
date: 2014-05-28 15:42
comments: true
categories: 
flashcards: 
  - front: "Message Endpoint"
    back: "code custom to application and messaging system's API"
  - front: "Magnet"
    back: "a url hashed by the content of the file it points to"
  - front: "btih"
    back: "BitTorrent Info Hash; SHA1 of the bitorrent metadata"
  - front: "When do CPs get overridden?"
    back: "When they're get only (CP fns have <= 1 arity)"
  - front: "Why is Ember.computed.reads in the docs"
    back: "Because defeaturify doesn't run before the API docs are generated (maybe that'll change?)"
  - front: "Difference b/w computed.defaultTo and the CP severing behavior"
    back: "defaultTo isn't a binding; it only retrieves the target defaultValue when the cur value is null"
  - front: "Coneheads antagonist"
    back: "Michael McKean"
  - front: "Thread.current[:a] = 5"
    back: "Store a=5 in Fiber-local var."
  - front: "IEEE"
    back: "Institute of Electrical and Electronics Engineers; not-for-profit corporation, specified telephony, networking; produces 30% of world's literature on EE and CS"
  - front: "IEEE 802"
    back: "Family of standards dealing with LAN and metro area networks"
  - front: "WLAN standard"
    back: "IEEE 802.11; media access control (MAC) and physical layer (PHY)"
  - front: "IEEE 1003"
    back: "POSIX"
  - front: "POSIX"
    back: "Portable Operating System Interface (1988): family of standards specified by IEEE for maintaining compat b/w operating systems. POSIX defines API, command line shells and utilities, e.g. awk, echo, ed, threading lib"
  - front: "Holder of UNIX trademark"
    back: "Open Group"
  - front: "Linux and POSIX"
    back: "TODO"
  - front: "What is Linux?"
    back: "It's just a kernel; Linux distros are Linux kernel + lots of other utilities, mostly from GNU"
  - front: "Solaris"
    back: "Unix operating system originally by Sun, now by Oracle"
  - front: "What does it mean for an OS to be considered a 'Unix OS'"
    back: ""
  - front: "A free UNIX OS"
    back: "OpenSolaris"
  - front: "The X in OS X"
    back: "Signifies relationship to uniX"
  - front: "Logivision POS / LPOS users" 
    back: "Union Market, Gourmet Garage"
  - front: "ruby: break x" 
    back: "force the method that yielded me to return x"
  - front: "RSS (memory)" 
    back: "Resident set size: portion of process's memory that is held in RAM, as opposed to swap or filesystem"
  - front: "Enumereable Lazy" 
    back: "Ruby 2.0's ability to lazy eval what might be an infinite sequence; not eval'd until something like `to_a` called"
  - front: "Why couldn't Ruby pre 2.0 use OS COW semantics while forking?" 
    back: "Because setting FL_MARK was rightfully interpreted as a write; bitmap marking got around this"
---

### Rubymotion

The next version will support Android. Ruby on Android. By PHH.

http://blog.rubymotion.com/post/87048665656/rubymotion-3-0-sneak-peek-android-support

### Magnet Link

[Wikipedia](http://en.wikipedia.org/wiki/Magnet_uri)

e.g. for all my illegal torrent downloads

    magnet:?xt=urn:btih:7O4OWESOQIXMYWY6U36MXWRICAUDB2OU&dn=Louie.S04E05.HDTV.x264-LOL&tr=udp://tracker.openbittorrent.com:80&tr=udp://tracker.publicbt.com:80&tr=udp://tracker.istole.it:80&tr=udp://open.demonii.com:80&tr=udp://tracker.coppersurfer.tk:80

- "de facto" standard; no official spec
- The scheme is "magnet", even though there's not "magnent" protocol in
  the way "http" is a scheme that refers to the Hyper Text Transfer
  Protocol.
- URI has target file's contents built into hash; anyone with the file
  can generate the URL without needing to refer to a central authority.
  This makes search results guaranteed; the server either has the thing
  you're looking for or it doesn't, and if you'd, say, like to continue
  downloading the latest episode of Louie from a source, you could
  search by content hash rather than by "Louie S04E07" which might yield
  a bunch of different encodings and other things you don't actually
  want.
- magnet URIs have no [hierarchical part](http://en.wikipedia.org/wiki/URI_scheme#Generic_syntax),
  but rather immediately begin with a query param.
- `xt` query param refers to "exact topic"; this is followed by the hash
  type, such as sha1, or in the example above, "btih", which is a SHA1
  hash of a BitTorrent Info Hash (TODO: write about bittorrent meta)
- `dn` = display name, e.g. `Louie.S04E05.HDTV.x264-LOL`
- `tr` = tracker url for bittorrent downloads; note in the above sample
  magnet URL `tr` appears multiple types; wiki suggests appending an
  incrementing `.N` to query param keys, but I guess that's not a
  requirement.

> The Pirate Bay migrated from .torrent files to magnet URI in February 2012. This migration made the storage footprint of The Pirate Bay exceptionally small. A user demonstrated that the total size of The Pirate Bay magnets would be approximately 90MB of compressed data.[2]

### STOMP

[Wikipedia](http://en.wikipedia.org/wiki/Streaming_Text_Oriented_Messaging_Protocol)

Streaming Text Oriented Messaging Protocol: protocol designed for
working with Message-Oriented Middleware (MOM). It's language-agnostic,
so you could have a Ruby STOMP client talking to a Java STOMP server,
etc. 

Go figure the Ruby Server that I found depends on EventMachine. How
could it not? I should probably figure out how servers queue up
requests. Is that the job of Thin/Mongrel/Unicorn?

### Ember overwriting get-only computed properties

Best explained in a [JSBin](http://emberjs.jsbin.com/ucanam/5139/edit).

Setting a computed property that is get-only (which is determined
by the fact that the supplied function has an arity of <= 1) will
overwrite that CP with whatever static value you're setting it to.

Relevant
[Ember](https://github.com/emberjs/ember.js/blob/master/packages/ember-metal/lib/computed.js#L490-L492)
[links](https://github.com/emberjs/ember.js/blob/master/packages/ember-metal/lib/computed.js#L1224-L1228)

### Defeaturify doesn't get run before Ember API docs get generated 

This is probably the least timeless thing I could write about.

### Drop permissions in a server setting

It's an OS requirement that running a server on port 80 requires root
permissions, which means you need to be logged in as root or running
sudo to start up a server on port 80, but it can be risky to leave a
server running with full permissions, so it's common practice to _drop
permissions_ after the server has been start up. 

I stumbled upon this concept while reading
[WEBrick code](https://github.com/ruby/ruby/blob/trunk/lib/webrick.rb#L14-L15):

    # WEBrick also includes tools for daemonizing a process and starting a process
    # at a higher privilege level and dropping permissions.

### Michael McKean

![Michael McKean](http://f.cl.ly/items/0x23191Z3K1J0M0Z1e3D/coneheads03.jpg)

A total hateable 90s "that guy".

### Ruby Fiber-local variables

`Thread#[]` is [a thing](http://www.ruby-doc.org/core-2.1.1/Thread.html#method-i-5B-5D)

It's an accessor for fiber-local variables. What does that mean? It
means even though you're saying `Thread.current[:a]`, which looks as if
you're grabbing `a` as tied to the current thread, it'll actually be
grabbing `a` from the currently active Fiber within that Thread, which
is a little misleading (and obviously wasn't a problem before Fibers
were a thing in 1.9.2).

Example:

    Thread.new {
      Thread.current[:a] = "lol"
      Fiber.new {
        puts "in new fiber: #{Thread.current[:a]}"
      }.resume
      puts "in original fiber: #{Thread.current[:a]}"
    }.join

This prints

    in new fiber:
    in original fiber: lol

### Thread#join

I knew this but I'm forgetful.

The following program prints "DONE" and exits:

    Thread.new {
      sleep 1
      puts "OMG"
    }
    puts "DONE"

The following program waits a second, prints "OMG", prints "DONE" and quits:

    Thread.new {
      sleep 1
      puts "OMG"
    }.join
    puts "DONE"

`Thread#join` pauses the current thread until the `.join`d thread
completes. Dur.

### Rack Request Store

[GitHub](https://github.com/steveklabnik/request_store)

Apparently `Thread.current` is already well known as common storage
place for global state for whichever thread you're on (which is safer
than sharing/clobbering some truly global var shared b/w threads). The
problem is that servers don't agree on Thread re-use:

    def index
      Thread.current[:counter] ||= 0
      Thread.current[:counter] += 1
      render :text => Thread.current[:counter]
    end

> If we ran this on MRI with Webrick, you'd get 1 as output, every time. But if you run it with Thin, you get 1, then 2, then 3...

Presumably that's because WEBrick spawns a new thread for every request
while Thin reuses threads. (TODO: confirm this?)

So anyway, Rack RequestStore is a thread-local storage mechanism that
gets cleared at the beginning of every web request. The functioning code
is literally no more than:

    module RequestStore
      def self.store
        Thread.current[:request_store] ||= {}
      end

      def self.clear!
        Thread.current[:request_store] = {}
      end
    end

and 

    module RequestStore
      class Middleware
        def initialize(app)
          @app = app
        end

        def call(env)
          RequestStore.clear!
          @app.call(env)
        end
      end
    end

and then you'd write in your app code:

    def index
      RequestStore.store[:foo] ||= 0
      RequestStore.store[:foo] += 1
      render :text => RequestStore.store[:foo]
    end

so you still have to use `||=` to initialize values but you have the
guarantee that a previous value doesn't stick around.

### Deadlock detected

    1.9.3p484 :004 > Thread.current.join
    fatal: deadlock detected

Dur. 

### POSIX: Portable Operating System Interface

I had no idea what this was. It always "the thing that has something to
do with linux/unix and has opinions about utilities that you might find
both on linux and Mac OS". 

It's a family of standards specified by the IEEE, specifically IEEE
1003. Linux, UNIX, and Mac OS X are POSIX-compliant, I believe, but what
does that mean?

[good SO question](http://stackoverflow.com/questions/1780599/i-never-really-understood-what-is-posix)

[Readable POSIX Standard](http://pubs.opengroup.org/onlinepubs/9699919799/)

The C programming language was standardized by POSIX, also BSD variant
exists.

### Difference b/w linux and unix

[Source](http://www.cyberciti.biz/faq/what-is-the-difference-between-linux-and-unix/)

UNIX is a copyrighted name; most UNIX system sare commercial in nature.
Open Group holds UNIX trademark.

Linux is a UNIX clone created by Linus Torvalds and aims for POSIX
compliance.  

Linux is just a kernel; everything else that goes into a Linux distro is
GUI systems and GNU utilities, filled in by third parties, whereas with
a UNIX OS, everything comes from a single source/vendor so it's
considered a "complete operating system".

Linux is free, redistributable under GNU licenses. Most UNIX-like
systems not free, w OpenSolaris as exception. But some Linux systems
are accompanied by Linux support, consultancy, bug fixing, and training
for additional fees, e.g. Redhat.

Some UNIX OS's

- HP-UX
- IBM AIX
- Sun Solaris
- Mac OS X (the X emphasizes relation w UNIX)
- IRIX

Some Linux Distributions

- Redhat Enterprise Linux
- Fedora Linux
- Debian Linux
- Suse Enterprise Linux
- Ubuntu Linux

Commonalities b/w Unix and Linux

- GUI, file, windows manager
- Shells (ksh, csh, bash)
- Various office apps (open office)
- Development tools (perl, php, python, GNU C/C++ compilers)
- POSIX interface (wat? i guess this means both are POSIX compliant)

[Unix History graphic](http://en.wikipedia.org/wiki/File:Unix_history.svg)

### IEEE: Institute of Electrical and Electronics Engineers

A professional association with corp office in NYC, dedicated to
technical advancement and excellence. Known for their conferences, 
educational activities, and in particular their standards development.

How do they make money? Let's look at their
[annual report](http://sites.ieee.org/annualreport/files/2013/10/IEEE-2012-Annual-Report-Full.pdf).

Members pay dues. Full year membership is $187. They have 429,000
members. Membership bolsters your tech career, I guess. Hear about
conferences n shit.

$406M in revenue, mostly in periodicals and conferences, then
membership, then standards, then other things.

So how do they make money off of standards? Someone approaches them and
says "hey you usually do a good job on this stuff; we'll pay you to help
out on these standards?" 

[what a nice resource](http://standards.ieee.org/develop/process.html)

> The development of a new standard is typically triggered by a formal request, submitted to an SDO (Standards Development Organization) by a Sponsoring Body (individual or entity, such as an industry society) for review and evaluation. The SDO mandates, oversees, and helps facilitate the process for standards development. The Sponsor for the standards project assumes responsibility for the respective area of standards development, including the organization of the standards development team and its activities.

[then there's this](http://standards.ieee.org/develop/projstart.html)

- An idea or concept needs to be standardized
- Sponsorship organization comes along to coalesce the ideas of
  individuals and to financially back the standardization process.

What are some of their most "popular" standards? These are based on the
Wikipedia search autocomplete of "IEEE ":

- IEEE 802.11: MAC (media access control) and physical layer (PHY) specs
  for implementing wireless LAN (WLAN) in certain frequency bands. IEEE
  802 is the 
- IEEE 802.11g-2003 et al: enhancements to the original spec, expanding
  to other frequencies.
- IEEE 1394: FireWire
- IEEE 1003: POSIX

"IEEE 802" refers to the family of standards dealing with LAN. Different
suffixes refer to different standards (rather than versions of
standards). 

Also, when an amendment comes out, e.g. 802.11g-2003, it is 
revoked when fully incorporated into the main standard, but
manufacturers will still refer to the amendment code as a means to
concisely advertise a product's capability:

> While each amendment is officially revoked when it is incorporated in the latest version of the standard, the corporate world tends to market to the revisions because they concisely denote capabilities of their products. As a result, in the market place, each revision tends to become its own standard.

### Pass a return value to "break" in Ruby

![twitter convo](http://f.cl.ly/items/0Q311t0Y1R2v1O29081u/Image%202014-05-29%20at%2011.51.58%20AM.png)

    [1,2,3].map { |i| break "shit" } # => "shit"
 
More generally:

    def foo
      yield
      "shit"
    end

    foo { break "naw" } # => "naw"

`break x` means "force the method that yielded me to return x".

### Ruby Garbage Collection

Phrasing from [this article](http://samsaffron.com/archive/2014/04/08/ruby-2-1-garbage-collection-ready-for-production)

Ruby 2.0: collect GC every 8MB; too small for most Rails apps
Ruby 2.1: Revised to have defaults make sense for both script and web apps

Specifically, expand GC limit every time limit hit, with ceilings. 

But there was a 2.1 bug fixed in 2.1.1. In addition, there's still a
"memory doubling" issue under 2.1.1 due to the generational GC added to
2.1.

The gist of generational GC is that: 

- Oftentimes, an allocated piece of memory is transient; it's used once
  and immediately its consumer lets go of it, and it can be released
  back to the system
- Objects that survive a first sweep are statistically likely to
  maintain in use for a long time, so it doesn't make sense to
  constantly sweep these objects in every GC pass.
- So separate garbage collection into two generations, old and new.
  New-gen allocations get moved to old-gen if they survive the first
  sweep, and old-gen sweeps (major GC events) happen way less
  frequently.

This apparently made Ruby 2.1 10x faster on average. But according to
this article, the 2.1 algo was too simplistic for web apps since web
apps perform lots of "medium" allocations (allocations that survive a
first sweep but can thereafter very quickly be swept up), e.g. most
(all?) allocations will take place during a web request, so if a GC hits
in the middle of a request, a lot of new-gen allocations will be moved
to old-gen, even though much of the new-genners could be cleaned up at
the end of the request. 

Bad side effects:

- Major GC events run more often (triggered by oldgen growth)
- Oldgen grows beyond what we need (saturated by medium-gen)

.NET and Java use 3 generations, gen0 survivors go to gen1, then gen1 to
gen2, where they remain.

The planned (and I guess implemented at this point) refactor is to
requires that objects will have to survive 2 minor GCs to be promoted to
oldgen, therefore, if no more than 1 minor GC runs during a request,
heaps will stay at optimal sizes. Slated for 2.2 release (not yet
released).

BTW, RSS refers to "resident set size", the portion of a process's
memory that is held in RAM, as in 'in residence'. If it weren't in
residence, it might be in swap or in filesystem. 

So the Ruby algo is called `RGenGC`. 

### Bitmap marking

[source](http://patshaughnessy.net/2012/3/23/why-you-should-be-excited-about-garbage-collection-in-ruby-2-0)

In MRI, lots data stored as metadata + RValue, e.g. "abc" stored as an
RString which is flags + "abc" stored on an RValue heap with lots of
other strings.

    [a,b,c,s,o,m,e,o,t,h,e,r,s,t,r,i,n,g]

Fun fact: your ruby code itself is converted into RValue structures as
it is parsed and converted into byte code.

GC is run when we're out of RValue storage, loop over references an set
`FL_MARK` to mark the obj. Then leftover unmarked freeable objs are
collected into a singly-linked list, which will then be used for future
RValue allocs. If a heap (collection of RValue pointers) can't free up
any more space, and additional heap is alloc'd. 

#### Copy-on-Write optimization

(brought to you by POSIX, right? or BSD? TODO: nail this down)

Linux/UNIX/UNIX-like systems have COW (copy on write). Semantically, a
fork of a process means copying all of memory from starting process. But
a full copy doesn't actually need to happen until one of the proces
writes.

Presumably this same thing happens if it's the parent process that
writes to COW data, right? How does that work? Are they both considered
child processes? TODO!!!

But before bitmap sweeping, COW didn't work for Ruby, because Ruby's GC
involves writing to `FL_MARK` to mark a piece of data as referenced by
some other thing, and this sets off the OS's copy-on-write behavior;
writing to `FL_MARK` looks like any other kind of memory write and the
OS doesn't know the difference.

(note: [Ruby Enterprise Edition](http://www.rubyenterpriseedition.com/) 
fixed this, if you're interested)

The MRI fix came with replacing `FL_MARK` with a bitmap of marked
values. It's not a 2D bit map, it just means bits mapped to RValue
heap array elements. Obviously the bitmaps themselves are heavily
modified so they'll definitely be fully copied, but they're small so no
biggie. 

Heaps now must be "aligned" with their maps, so we can't just use boring
ol malloc, but rather `posix_memalign` to alloc something that
presumably doesn't align with a word. 

### Enumerable Lazy

This is in 2.0. You don't want to use it all the time for performance
reasons (the construction of all the intermediate blocks outweighs the
cost of evaluating some array you might not entirely consume), but it
allows you to do things like:

    require 'prime'
    Prime.lazy.select {|x| x % 4 == 3 }.take(10).to_a

[Read more](http://railsware.com/blog/2012/03/13/ruby-2-0-enumerablelazy/)







