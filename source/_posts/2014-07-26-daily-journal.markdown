---
layout: post
title: "Daily Journal"
date: 2014-07-26 15:10
comments: true
categories: 
---

## top

> display and update sorted information about processes

`top` will display a sampled, updating list of processes, ordered by pid
by default. Order by cpu:

    top -o cpu

Filter by a pid

    top -pid 12345

Show a single sample of the pid and thread number for a given pid

    top -l1 -pid 1234 -stats pid,th

## Spawn 50 ruby threads...

and you wind up w 52: `Thread.main` + the 50 you created + Ruby
housekeeping thread (listening for OS signals and piping them
synchronously to main thread).

Ruby creates legit OS threads, vs `_____` threads, whatever the
terminology is for threads that live entirely in the code.

## Thread#join

Yes, you have to call it on a spawned thread so that the main thread
will wait on it before prematurely exiting. But did you know that
exceptions thrown in a spawned thread get re-raised on the main thread
if you do `.join`?

`Thread#value` joins and returns the last value of the thread. 

`Thread#status` returns status for live, dead, erroed, dying threads.

`Thread.stop` puts the thread to sleep and it won't wake up until
someone calls `wakeup` on it

`Thread.pass` hints the OS to schedule another thread, but this may be
ignored by the scheduler.

`Thread#raise` lets you externally fire exceptions within another thread
but should not be used because `ensure` is busted. `Thread#kill` does
what you expect but should also be aborted for the same reasons. 

Multiple threads mean concurrency; they _might_ mean parallelism. One
CPU switching b/w threads means concurrency but not parallelism;
multiple cores means paralleilism if they're both executing.

Code can't be parallel, only concurrent. The executation of concurrent
code can be parallel if the scheduler so chooses. 

## golang concurrency vs parallelism

http://concur.rspace.googlecode.com/hg/talk/concur.html#slide-2

Concurrency is defined as:

> Programming as the composition of independently executing processes

not Linux processes, but rather the famously harder to define Process.

Parallelism is 

> Programming as the simultaneous execution of (possibly related) computations.

> Concurrency provides a way to structure a solution to solve a problem that may (but not necessarily) be parallelizable

Concurrency facilitates but doesn't guarantee parallelism.

Goroutines aren't threads; they're similar but cheaper, won't block
other goroutines, and multiplexed onto OS threads as necessary.

Synchronize via channels. I guess this is like Ruby Queue? Sounds like
you'd never do someGoroutine.value but rather use the channel primitive.

## ruby concurrency and you

https://blog.engineyard.com/2011/ruby-concurrency-and-you

Green threads

- scheduled by VM, rather than underlying OS
- pre 1.9 Ruby was this way (MRI)
- managed in user space rather than kernel space

Test: if i run Ruby 1.8.7 and do a top of new threads, I would expect
the thread count to be only whatever I started with. 

BEHOLD, on 1.8.7:

    PID    #TH
    84752  1

So old ruby didn't even spawn another thread for housekeeping... I guess
maybe it wasn't necessary because it didn't have to coordinate the
signals landing at any random currently-active thread? Pretty cool.

I guess green threads are easy to implement in any interpreted language:
in the main loop of the interpreter you can just check if 100ms has gone
by and then move to another other known threads. 

Early Java had green threads... I don't know enough about Java to
comment here. 

Ruby <1.9 was smart enough to know when one of these threads was blocked
on external data so that it could "sleep" until the data arrived:

> MRI 1.8.7 is quite smart, and knows that when a Thread is waiting for some external event (such as a browser to send an HTTP request), the Thread can be put to sleep and be woken up when data is detected.

1.9 uses native threads, but there's still a GIL because the non-Ruby
parts of MRI 1.9 aren't thread-safe. 

MRI 1.9 uses the same technique as MRI 1.8 to improve the situation, 
namely the GIL is released if a Thread is waiting on an external 
event (normally IO) which improves responsiveness.

Great read:

http://yehudakatz.com/2010/08/14/threads-in-ruby-enough-already/

Threads are hard, but requests are an extremely clean concurrency
primitive: controllers and the models loaded and views rendered, etc.,
are not shared between threads that are processing requests. It's only
if you start using global state that problems arise, but why are you
doing that?

Why the Ruby/Rails thread FUD?

- Early Rails wasn't threadsafe; essentially a mutex around each request
- Mongrel explicitly mutexed around its Rails adapter, so even when
  `threadsafe!` was added, you'd still have zero concurrency in mongrel.

> For safety, Ruby does not allow a context switch while in C code unless the C code explicitly tells the VM that it’s ok to do so.

And mysql was poorly written in this case. So mysql would block.

 > A lot of people talk about the GIL (global interpreter lock) in Ruby 1.9 as a death knell for concurrency. For the uninitiated, the GIL disallows multiple CPU cores from running Ruby code simultaneously. That does mean that you’ll need one Ruby process (or thereabouts) per CPU core, but it also means that if your multithreaded code is running correctly, you should need only one process per CPU core. I’ve heard tales of six or more processes per core. Since it’s possible to fully utilize a CPU with a single process (even in Ruby 1.8), these applications could get a 4-6x improvement in RAM usage (depending on context-switching overhead) by switching to threadsafe mode and using modern drivers for blocking operations.

Node vs Ruby Threading:

Yehuda: "the main difference is that a callback is smaller in size than a stack"

In other words, the context switch that happens when switching threads
includes copying over an entire stack of the thread you're resuming and
some other details I don't know of off the top of my head. But with
callbacks, the callbacks have no stack (is this true in Rubyland? maybe
there's stack trace information but probably no stack. The only stack
starts from where the callback/block was created, and the same is true w
threads, but the point is that in a thread-per-request model, the stack
goes all the way up to when the request was first received, which can be
a pretty tall stack). 

So what about Fibers? They're cooperative, but why is their context
switch not a big deal? They have a stack size limit of 4kb. How can I
test this?

Here's a nice article: 

http://timetobleed.com/fixing-threads-in-ruby-18-a-2-10x-performance-boost/

Seems to suggest that the stack that needs to be copied when context
switching includes interpreter code, which has many local vars and
sometimes the stack is up to 4kb, which is cray cray.

Green threads: pre-emptible userland threads. userland = not kernel
land. 

You can hack into the thread-yielding code of old Ruby to allocate
stacks on the heap so that all you have to do to context switch is
change what rsp (pointer to the bottom of the stack) points to. This
means the stack won't grow (so you have to pick a sensible size). 

Ruby 1.9 performs way better in the benchmarks than his hacks... why?
"Thanks. 1.9 uses pthreads which create stacks in a similar manner to
what I did." Awesome. 

pthreads = POSIX threads


http://timetobleed.com/threading-models-so-many-different-ways-to-get-stuff-done/

Threads models:

### 1:1 (native threads)

One kernel thread for every user thread. 

Pros

- execute threads on different CPUs
- threads don't block each other
- shared memory b/w threads

Cons

- Setup overhead since creating a thread requires a system call (and
  those are slow) 
- Low upper bound on the number of threads that can be created

`pthread_create` is the fn that makes the system call to create the
thread. 

### 1:N (green threads)

"lightweight threads"

- thread creation, execution, cleanup are cheap
- lots of threads can be created 

Cons

- kernel doesn't know about it, so no parallel execution across CPUs
- blocking IO can block all green threads

Forking + threading and cross-process communication is one way around
limitations.

### M:N

Hybrid of above

- Multi CPUs
- Not all threads blocked by blocking system calls
- Cheap

Cons

- Really really hard to synchronize userland and kernel scheduler
- Green threads will block within same kernel thread
- Difficult to maintain

1:1 has shown itself to be more performant, but in some cases M:N might
be the right choice. 

TODO: read this http://www.akkadia.org/drepper/nptl-design.pdf

    b = nil

    t = Thread.new do
      b = Fiber.new {
        puts "FIBER"
      }
    end

    while !b
      # just wait
    end

    b.resume

This results in 

    fiberthread.rb:13:in `resume': fiber called across threads (FiberError)
            from fiberthread.rb:13:in `<main>'

Of course it would.

Use strace / dtruss to trace sys calls. 

Spinlocks are locks that, rather than sleeping, actively busy-wait until
the lock is free. This only makes sense if the wait is expected to be
short, otherwise it might block other threads. 

Interesting, from the wiki:

> Most operating systems (including Solaris, Mac OS X and FreeBSD) use a hybrid approach called "adaptive mutex". The idea is to use a spinlock when trying to access a resource locked by a currently-running thread, but to sleep if the thread is not currently running. (The latter is always the case on single-processor systems.)

The idea is that a lock by an active thread is likely to be finished
soon, and since spinlocks avoid the scheduling overhead of a context
switch, then hooray.

Busy-waiting in general means while-looping until some condition is
true. You can even do this in JS:

    var end = +new Date() + 1000;
    while (+new Date() < end) {}

So whether Node or EventMachine, the concept is the same: both run on
callbacks. 

Realization: I was thinking that I could demonstrate the difference b/w
green threads and OS threads by seeing if a while(true) in a green
thread would yield to others, but the answer is:

- of course it would yield; each iteration of the while true is
  an iteration of the interpreter loop that's running commands, so its
  timer would fire at that point. 
- the only time it'd block is if you called out to a C extension that
  looped and didn't yield back control.

It seems a Fiber's 4k stack begins at the point at which it is created.
Hmm. So does it or does it not include interpreter stuff? Well for one
it's in the same thread as a requirement. 

Reasons why Fibers are faster than threads:

- limited 4kb stack for quick context switching
- no pre-emption means no aggressive/frequent context switching;
  context-switch as infrequently as you'd like.

https://github.com/eventmachine/eventmachine/blob/master/docs/old/LIGHTWEIGHT_CONCURRENCY

Lightweight Concurrency generally means

- putting thread scheduling under the control of your program

> By "lighter," we mean: less
> resource-intensive in one or more dimensions, usually including memory and
> CPU usage. In general, you turn to LC in the hope of improving the
> performance and scalability of your programs.

NOTE: race conditions can happen in concurrent environments, even if
parallelism isn't there, e.g. preempting

Mac has a max 2048 thread limit.

"IO Bound" means your program is mostly bottlenecked by IO, such that
swapping for a faster IO would boost your program performance immensely.

In such a case, going multi-threaded is a no-brainer rather than
serially getting blocked on each slow thing. But if you over do it then
you might just be wasting memory/CPU resources from thread stacks and
context switching that it's not justified. 

"CPU bound" means doubling CPU would mean the job would get done that
much faster.

Quad-core with 4 threads on CPU bound means mega-wins for Rubinius but
obviously not GIL'd MRI. If you make it 5, then you get the
context-switching overhead.

Rails apps are combo of IO-bound and CPU-bound

IO:

- Database
- Third party APIs
- Files read

CPU:

- Rendering templates
- Rendering JSON

Measure measure measure.

This is comically incorrect:

    Mutex.new.synchronize do
      puts "LOL please never do this"
    end

should be

    m = Mutex.new

    # ...create thread...

    m.synchronize do
      puts "LOL please never do this"
    end

"critical section" refers to the part of your concurrent code that
alters shared data.

Memory Models describe the guarantees made to threads when
reading-from/writing-to memory, which mostly become important to think
about in a multi-threaded settings. The memory model describes how
caching occurs in the registers before actually writing out to memory,
and it describes the scope of compiler/hardware optimizations that can
be made that lead to non-determinant order of memory operations which
can fuck your shit unless you use `volatile` in Java or explicit mutexes
in Ruby.  Ruby doesn't have a memory model spec yet. Java and Go and
others do. I guess Rust nips this in the bud w ownership.

Mutex is a form of a memory barrier, and I think `volatile` is too.

Livelocking is when `try_lock`s repeatedly fail, so the threads are
still technically alive but stuck in the same loop.

Best solution is to declare mutex grabbing in the same order via a mutex
hierarchy. 


## Signals in ruby

Rubyz

    Signal.trap("USR1") do
      puts "lol handling your custom user handler"
    end
    puts Process.pid # => e.g. 12345

Shellz

    kill -s USR1 12345

So many ways to kill a program:

- Abort: often self-initiated by `abort`


## Difference b/w seg fault and bus error

http://stackoverflow.com/questions/838540/bus-error-vs-segmentation-fault

On most architectures I've used, the distinction is that:

- a SEGV is caused when you access memory you're not meant to 
  (e.g., outside of your address space).
- a SIGBUS is caused due to alignment issues with the CPU 
  (e.g., trying to read a long from an address which isn't a multiple of 4).

## Signals in C

This is just for fun, but you can set up signal masks and signal
handles and all that fun crap. 

    #include <stdio.h>
    #include <signal.h>
    #include <unistd.h>
    
    static int gotSignal = 0;
    
    void wat(int s) {
      printf("Got Signal %d", s);
      gotSignal = 1;
    }
    
    int main() {
      /* SIGUSR1 == 16 */
      signal(SIGUSR1, &wat);
    
      pid_t pid = getpid();
      printf("The process id is %d", pid);
    
      // prevent signal from getting here
      sigset_t s;
      sigaddset(&s, SIGUSR1);
      // uncomment to block the signal from arriving
      //sigprocmask(SIG_BLOCK, &s, NULL);
    
      while(!gotSignal) {
        printf(".");
        fflush(stdout);
        sleep(1);
      }
    
      printf("\nDone!\n");
    }

and you can send it usr1 via

    kill -s USR1 12345

## Signals in Node

    var done = false;
    
    process.on("SIGUSR1", function() {
      done = true;
    });
    
    console.log("pid: ", process.pid);
    
    var timerId = setInterval(function() {
      if (done) {
        console.log("DONEZO");
        clearInterval(timerId);
      } else {
        process.stdout.write(".");
      }
    }, 500);

Note that SIGUSR1 is reserved by node.js to start the debugger.
The above code will work but if the debugger's enabled then that'll also
cause it to start.

Seems that signals are often used to start a debugger, or some kind of
debugging operation. Interesting.

## Condition Variables

A provider and consumer both use the same mutex. Provider locks when
providing an update. Consumer locks when trying to perform an operation,
but internally does a `condvar.wait(mutex)` with the locked `mutex` to
unlock until the `condvar` is `signal`ed by the provider.

So why wrap the consumer in a while loop rather than an if (see page 104
of storimer)? Because there could be multiple consumers. 

`ConditionVariable#signal` wakes up a single thread, `ConditionVariable#broadcast` 
wakes up all threads.

## `thread_safe` gem

- ThreadSafe::Array
- ThreadSafe::Hash
- ThreadSafe::Cache
  - similar to Hash, but insertion order enumeration isn't preserved,
    which means it can be faster

## Immutable = threadsafe

Read more about it.

## Globals

The Ruby AST is a global (is it really an AST at that point? is
dynamically adding a method an example of modifying an AST? ASTs are for
parsing, not so much adding/removing methods from a class obj).

Anyway, Kaminari was bitten by this:

https://github.com/amatsuda/kaminari/issues/214

## Thread-locals

Variables that are global to everything in the current thread but hidden
to everyone else. So you could do

    Thread.current[:some_service] = SomeService.new

which could open a new connection. Connections are nice concurrency
primitives, much like request objects in Rails. But if you have too many
threads, you might hit a max connection limit, so in that case, use
pools, lol.

Pools let you specify max concurrency, which is likely less than the
number of threads that might want to consume it, and then when
requesting access to a thing in a pool, it'll block until a slot's
available. 

See: https://github.com/mperham/connection_pool

mperham is Mr Sidekiq. Mr. Concurrency in general I guess.

Question: is a connection pool the same as a thread pool? Probably not,
connection pool is just a resource pool that is thread-aware, but
doesn't constitute individual threads. 

## Rubinius Actor

https://github.com/rubinius/rubinius-actor

Depends on core Rubinius class `Channel`. TODO: find out why `Channel`
doesn't/can't exist in MRI.

## Rubinius Ruby JITting

Talking to IRC folk: one of the major reasons for Ruby all the way down
or at least Ruby most of the way down is that more of it can be JITted
rather than having the hard C/C++ boundary after which no more
optimizations can be made. 

Also, in some benchmarks b/w Rubinius and JRuby and MRI, etc., one thing
that comes up a lot is the suggestion that the tests run for longer so
that the JIT is primed, all the optimizations have been made, etc etc
etc.

## Rails Batches

http://api.rubyonrails.org/classes/ActiveRecord/Batches.html
 
    Article.find_each do |a|
      a.wat
    end

this internally splits DB queries into batches of 1000 so that you're
not instantiating potentially a billion Ruby objects for each row. In
the end you'll still allocate the same amount of memory but it can be
GC'd along the way vs causing an insane spike and possibly crashing your
server.

## Server-sent events

http://tenderlovemaking.com/2012/07/30/is-it-live.html

1. A stream obj is added to Rails request object, quacks like IO obj.
   You can write to it and close it, but it doesn't actually stream live
   to the client; it buffers, and then flushes.
2. With `ActionController::Live`, it'll actually stream live.
3. Some WebServers, like WEBrick will thwart this by buffering the
   response until it's complete. Unicorn could work, but it's meant for
   fast responses; anything taking longer than 30s might get terminated.
   Rainbows/Puma/Thin would work.

## Celluloid

Transforms method invocations into blocking messages. Precede w `async`
to prevent blocking (obviously still happens async);

    require 'celluloid'
    
    class DoesStuff
      include Celluloid
    
      attr_accessor :i
    
      def foo
        # currently this displays
        # one item per second.
        # if you swap comments with
        # the line after it'll wait
        # until the very end to print them all
        # at once because the each at the end
        # will evaluate the "longest" future first
        sleep i
        #sleep (11 - i)
        i
      end
    end
    
    
    futures = []
    
    10.times do |i|
      thing = DoesStuff.new
      thing.i = i
    
      futures << thing.future.foo
    end
    
    
    futures.each do |f|
      puts "Completed: #{f.value.i}"
    end
    
    sleep

This is interesting: https://github.com/celluloid/celluloid/wiki/Frequently-Asked-Questions#q-can-i-do-blocking-io-inside-an-actor-or-do-i-have-to-use-celluloidio

It's fine to have blocking IO such as waiting for a DB query to return,
or slow HTTP response, but you shouldn't have it waiting on 
_indefinite_ IO; for that, use Celluloid::IO.

I believe that an actor can't be handling multiple messages at the same
time. Wrong! That's only if Erlang/Exclusive mode is on, and you have to
be careful about that because it means a higher risk of deadlock:

https://github.com/celluloid/celluloid/wiki/Exclusive

Sidekiq doesn't make use of return values a whole lot; rather actors are
expected to send messages back to their "callers".

Accessing localvars is faster than ivars: https://github.com/puma/puma/commit/fb4e23d628ad77c7978b67625d0da0e5b41fd124

## Compare and set (CAS)

aka check-and-set

For platforms that support it, CAS is a mutex-free approach to
thread-safety

    a += 1

is not thread safe, but

    cur = a.value
    new_value = cur + 1
    if (!a.compare_and_set(cur, new_value)) 
      # try again
    end

is.

Worth pointing out that Redis supports a form of this using WATCH.

    MULTI # begin transaction
    SET foo lol
    SET bar wat
    EXEC # execute

so basically if you do

    WATCH someval
    MULTI
    set someval lol
    EXEC

and someval changed after the MULTI then it will fail.

So why use CAS over a mutex?

> If the cost of retrying the operation is cheap, or rare, it may be much less expensive than using a lock. 

Logic checks out.

    require 'atomic'
    v = Atomic.new(0)
    v.update do |current|
      current + 1
    end

This is the shorthand to the idempotent loop with CAS. 

Lockless showed mega improvements relative to locking in Rubinius but
not JRuby for some reason.

Hamster is the immutability gem to check out.

## oni

https://github.com/olery/oni

Uses SQS, look into it because i am such a nooblet.

## SQS

Uses a visibility timeout after a consumer has started to receive a
message in which time it is hidden from other consumers, and in this
time it should be deleted. 

- Supports GET/POST requests to public URLs, presuming you pass in a
  valid signature
  - This means you could fire requests directly to SQS rather than
    having to go to a server first... that is badass. 
- Reports of scalability problems

[Alternative: RabbitMQ](http://nsono.net/amazon-sqs-vs-rabbitmq/)

- SQS: consumers must poll for messages, and SQS charges by the request,
  even if the response is empty.
- RabbitMQ supports push
- is free and open source
- based on erlang
- adheres to AMQP (standard for high performance messages queues)
- supports durable queues (crash-recoverable, written to disk)
- delivered in order unless message requeued
- more consistent (much less likely to deliver a message twice unless
  the message actually failed)

cons

- not necessarily highly available (because it's a server that runs on
  whatever instance you wanna put it on, so you have to manage failover,
  redundancy, etc, whereas SQS is a system that handles all of that)
- this is configurable, but the default is for RabbitMQ to drop messages
  if there are no consumers; surprising to SQS folk. 

## Heartbeats

https://www.rabbitmq.com/reliability.html

> In some types of network failure, packet loss can mean that disrupted TCP connections take some time to be detected by the operating system. AMQP offers a heartbeat feature to ensure that the application layer promptly finds out about disrupted connections (and also completely unresponsive peers). Heartbeats also defend against certain network equipment which may terminate "idle" TCP connections. In RabbitMQ versions 3.0 and higher, the broker will attempt to negotiate heartbeats by default (although the client can still veto them). Using earlier versions the client must be configured to request heartbeats.


Re: 'Heartbeats also defend against certain network equipment which may 
terminate "idle" TCP connections.': I bet that's referring to NAT, which
manages a cache of IP translations and will go inactive if nothings been
sent to / received from an IP for a while. 

YAY I WAS RIGHT http://stackoverflow.com/questions/865987/do-i-need-to-heartbeat-to-keep-a-tcp-connection-open#comment1713801_866003

So Heartbeats

- reassure you the connection is alive in some cases where the failure
  conditions aren't otherwise detectable
- keep the NAT state tables warm for your IP

## Celluloid::IO

https://github.com/celluloid/celluloid-io

Provides a different class of Actor that's heavier than normal Celluloid
actors, but contains a high performance reactor like EventMachine or
cool.io (todo: check out cool.io). So unlike EventMachine you can have
multiple loops, e.g. one in each actor (resources permitting). (Also,
does EM really force you to just have one?) 

## Autoload

Yes we know it's not threadsafe in MRI. Recent JRuby versions make it
thread safe, but just eager load your shits before spawning threads.

## Requests as concurrency unit

I guess in general you should always look for the concurrency unit; that
domain object that encapsulates all the data you need to get a job done
so that hopefully you're not sharing data between threads. Each request
gets handled by its own thread. 


## Queue

`Queue#pop` will suspend a thread until data is in the queue. Like a
mofuggin stream.

Queue is apparently the only thread-safe data structure that ships with
Ruby.

## JRuby 

Foreign function interface

http://en.wikipedia.org/wiki/Foreign_function_interface

Mechanism for languages to invoke routines from other languages.

Write your extension code in Ruby, FFI will call the write C / Java /
whatever stuff. It won't even be compiled. I guess it just links into
dynamic libs? 

JRuby obviously doesn't support C extensions, but FFI extensions will
work.

JRuby

- has no fork(), since JVMs mostly can't safely be forked
  (`NotImplementedError: fork is not available on this platform`)
- Fibers are native threads, rather than MRI green threads, which means
  you are constrained to native thread overhead/limits. 

## Rubinius (rbx)

- Designed for concurrency, speed.
- Rubinius 2.0 has no GIL
- All tools written in Ruby, including bytecode VM, compiler,
  generational GC, JIT, etc
- No continuations (because dependent on callcc, a C thing)
- At some point, when dealing with locks and low level things, you'll
  find C++.

http://rubini.us/2011/02/25/why-use-rubinius/

## Ruby Enterprise Edition

By Phusion. No longer alive.

- Compatible w 1.8.7
- End of Life since 2012
- No more work being done, reasons being:
  - Rails 4 no longer supporting 1.8
  - COW patch accepted on Ruby 2.0
  - Many Ruby Enterprise Edition patches addressed in 1.9, 2.0

## MacRuby

Implementation of 1.9 Ruby directly on top of Mac OS X core tech, e.g.

- Obj-C runtime and GC
- LLVM compiler infrastructure

## Reactive manifesto

TODO: read this http://www.reactivemanifesto.org/

