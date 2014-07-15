---
layout: post
title: "Daily Journal"
date: 2014-07-05 16:44
comments: true
categories: 
flashcards: 
 - front: "Capacity equation (bandwidth and signal-noise ratio)"
   back: "C (bits per sec) = BW (Hz) * log2(1 + S/N (watts))"
 - front: "Total capacity (bits per sec) of wireless transitions is proportional to..."
   back: "Bandwidth (Hz)"
 - front: "thrashing (vm)"
   back:  "degradation of performance due to too much swapping/paging"
 - front: "'zones' w.r.t Cocoa and alloc"
   back:  "regions of memory; alloc'ing in the same zone may prevent virtual memory thrashing"
 - front: "The two implicit vars provided when running a method in Objective C"
   back:  "`self` and `_cmd`; `_cmd` is the message sent"
 - front: "Pre-ARC approach for preventing thrashing in allocated Cocoa objects"
   back:  "allocWithZone and -zone"
 - front: "Cocoa: when do you use `finalize`?"
   back:  "When you're using ARC and you have things like legacy allocated objects to release or file handles to close"
 - front: ""
   back:  ""
 - front: ""
   back:  ""
 - front: ""
   back:  ""
 - front: ""
   back:  ""
---

## Bandwidth

Grigorik's book confused me when he switched from the bits/second
definition of bandwidth to the more signal processing definition. 

    http://en.wikipedia.org/wiki/Bandwidth_(computing)
    vs
    http://en.wikipedia.org/wiki/Bandwidth_(signal_processing)

Computing bandwidth refers to bits/s. Signal bandwidth is the difference
in the max and min Hz that you transmit on. 

This is interesting:

> A key characteristic of bandwidth is that any band of a given width can
> carry the same amount of information, regardless of where that band is
> located in the frequency spectrum. For example, a 3 kHz band
> can carry a telephone conversation whether that band is at baseband
> (as in a POTS telephone line) or modulated to some higher frequency.

My understanding of this is that regardless of the modulation alphabet
you use, modulation will always cause a signal to vary between a
minimumm and maximum frequency, which determines the bandwidth of a
signal. For example, transmitting a "01" might mean squeezing the waves
together tightly until the next "letter" to transmit, and the tightest
those waves are squeezed determines the maximum frequency, while "10"
might might loosening the waves, and other letters could be some
combination of the two, but the key thing here is that bandwidth
determines the min and max frequencies that those waves can compress
or expand to; any more and you might be interfering with someone else's
band.

<!-- more -->

And as to the ability to transmit the same amount of information, I
don't understand that; I'll have to read up on that a bit more. 

## allocWithZone

Cocoa's `alloc` method calls `allocWithZone` zone with some sensible
default. The whole point of `allocWithZone` is to allow you to
explicitly specify which memory zone an object lives in, allowing you to
put related objects into the same zone so as to avoid thrashing. 

NOTE: `allocWithZone` is old school, and as memory becomes cheap and
approaches to memory management improve, the zone passed in becomes
ignored, particularly with ARC.

Also, if any instance vars need to be `alloc`d, they should be done
within the same zone, or else you're defeating the whole purpose of zone
allocation (then again, ARC ignores this, so...). Anyway, you can do
things like `self.label = [[NSString allocFromZone:[self zone]] initWithString:@"balls"]`

## Designated Initializer 

In Cocoa, the designated initializer is the one initializer in a class
that all others defer to perform the full initialization of an object.
As such, it's usually the one with the most arguments, and other
initializers will usually choose sensible defaults to pass to the
designated initializer. 

Designated Initializers in subclasses must call the Designated
Initializers in its superclass.

NOTE: sometimes a class might have multiple Designated Initializers,
e.g. NSCell.

Drawback: having to know what the Designated Initializer is for a given
class... yeah, that sucks.

## Two-Stage Creation

e.g. `[[Thing alloc] init]`

1. Assign implicit `self` local var to `[super init]`, which might
   return something other than `self` where alloc fails or singleton
   pattern returns another instance.
2. If `self` not nil, continue to perform initialization.

Step 2 is extremely defensive and possibly overkill, but nil is a valid
return value for initializers so you have to watch out for it. Aren't
nils awesome?

## `self` and `cmd`

These are the two implicit variables provided within a method
invocation. 

1. `self` is the instance, durr
2. `_cmd` is the message received that caused the method to be run

Question: what happens if you don't assign `self`? Does it actually make
a difference outside of the method? Is it a reference or just a value
used within the method?

## ARC

Automatic Reference Counting: been around since Mac OS X 10.5, but if
you're writing a class with ARC, all consumers must also be using ARC
(but it's possible for ARC to consume non-ARC). Hence, it's important to
understand old school memory management. 

## `dealloc` and `finalize`

No-ARC:

`dealloc` called automatically (don't call it yourself) when reference count down
to 0. 

ARC:

`finalize` called instead of `dealloc`, but often doesn't need to be
implemented unless any non-ARC objects were alloc'd that need to be
manually released, or some file handles need to be closed, etc.

## `stringWithString` vs `[alloc] initWithString`

`autorelease` is called within these convenience methods like
`stringWithString`, but not called with the `alloc` + `init` pattern.
`autorelease` is often idiomatically meant for temporary vars. 
You must call `retain` on something that's autoreleased if you want to
hold on to it.

One drawback to the convenience methods is that their allocation is
hard-wired to their initialization; you can't swap the approach to
allocation, or pick zones or anything like that.

## `drawRect` and `setNeedsDisplay`

`drawRect` is a template method which you're never supposed to call
yourself; if you're tempted to use it, chances are you want
`setNeedsDisplay` instead.

## Template Methods vs Delagate

Template Methods as an approach to customizing/overriding a super
class's default behavior in a subclass result in tight coupling to the
super class. Also, if you need to override lots of different unrelated
behaviors in a superclass, likely the super class should have been
designed to use Delegates instead.

## `NSClassFromString` =~ `const_get`

Objective-C's runtime supports class lookup from strings via
`NSClassFromString`. I had no idea. And like in Ruby, Objective C
classes are objects as well.

## NSBundle

Makes use of NSClassFromString (or some variety of it?) to look up
classes in a bundle. Can either use `+classNamed` if you know the class,
or `+principalClass`, which uses the class defined in the Bundle's
plist.

## Obj-C Categories =~ `reopen`

    @interface Horseshit (SomeCategory)
    - (void)newMethod;
    @end

    @implementation Horseshit (SomeCategory)
    - (void)newMethod
    {
      // stuff
    }
    @end
    
This can be used to reopen classes, which, like `Module#reopen` in Ruby,
is inherited by subclasses as well.

This is familiar:

> but there is no good way to force exist- ing compiled code to 
> return instances of your subclass instead of instances of NSMutableArray.

The same gotcha is true for Ruby, where you can't trivially subclass 
`Array` without running into the often undesirable behavior of methodsl
like `#map` returning an instance of `Array`, rather than your subclass.

The Ruby approach to this (credit to Avdi Grimm), is something like

    require 'forwardable'
    class MyArray
      include Enumerable
      extend Forwardable

      def initialize
        @a = []
      end

      def_delegators :@a, :each, :<<
    end

    a = MyArray.new
    a << 123
    a.map { |i| i*2 } # => [246] # works because Enumerable#map uses #each

But in the case of `NSMutableArray`, since you'd have to override a
great many methods in a subclass of `NSMutableArray` to return instances
of your subclass, it might just make more sense to reopen
`NSMutableArray` by declaring a new category, and just throw methods
onto that; that way, these methods will still return their hard-wired
`NSMutableArray` instances, but they'll have the new methods that you
were tempted to put on an `NSMutableArray` subclass. A little sucky but
hey that's framework code.

### Categories for Framework Division

Kinda like how Ember progressively reopens ControllerMixin and other
classes in the various `ember-xxx` libraries that get combined into the
final complete Ember package, Cocoa uses categories to "reopen" certain
classes as libraries/frameworks are added. For instance,
`NSAttributedString` exists in Cocoa Foundation and can be used in
non-graphical contexts, but once Application Kit is added, categories
that included string-drawing logic are added to `NSAttributedString`.

Reserving judgement as to whether it makes sense to keep dumping code
into `NSAttributedString` vs adding utility classes that know how to
draw `NSAttributedString`s.

## (Informal) Protocols

A formal protocol, or just protocol, is a language construct in Obj-C
that is used to declare methods than an object must implement in order
to work in certain scenarios. The compiler can guarantee that a protocol
is adhered to and will throw errors (warnings?) if not.

An _informal protocol_ is a protocol where no compiler time checks are
made to make sure an object/class actually implements the methods in the
informal protocol. Informal protocols are implemented as categories of 
`NSObject` (which means virtually all classes inherit those informal
protocol methods), but Cocoa will often only provide an interface to
these categories, but no implementation; the compiler doesn't check
this, so lots of Cocoa classes use runtime checks to see if these
methods have been implemented on an object before sending such a
message.

One of the crappiest parts about informal protocols is that you have to
know, when subclassing, whether a super class provides an implementation
of an informal protocol method. If you just do `[super method]` and
`method` doesn't exist, then boom. The safest way around this if you
don't have the original source code is a run-time check, a la

    if ([Superclass instancesRespondToSelector:@selector(method)]) {
      [super method];
    }
    // more crap

Additionally, you could just stub out all the methods that Apple
"forgot" to implement via a new NSObject category, but this

1. Overrides the method definitions for classes that _do_ provide an
   implementation
2. Might interfere with runtime logic that checks if a method is
   implemented and performs some additional logic if it is.

But mean that just seems to scream with mega design flaws.
Tell-don't-ask, much?

> it’s a best practice to provide a default implementation for each 
> method you declare in your informal protocol.

If that's the case, then why not just do a normal ol category? Answer:
because the key difference w informal protocols is that they're declared
on `NSObject`, so any object/class has the option of providing it.

Note that Obj-C 2.0 (Mac OS X 10.5) provides `@required` and `@optional`
keywords in plain ol protocols to allow informal protocol semantics on
formal protocols.

## Category (and reopen) gotchas

1. Collisions are more likely when reopening is the norm
2. Apple (or whatever vendor) might add methods in future versions that
   clash with the ones you've added
3. Replacing methods means you have to be very careful to duplicate all
   of the effects of a method (but why do methods have so much logic in
   them in the first place?). Replacing should kinda be a last resort.

If you're going to extend Cocoa classes, it's wise to use a prefix. 

One nice convention is when you're extending NSArray with your custom
Wat category, you could throw it in a file named `NSArray+Wat.h`.

## Anonymous type: `id`

Unlike C++ and Java (et al), knowing the receiver type of a message is
not a requirement and can be deferred until runtime. This supports duck
typing. Bark bark. 

Selectors can be dynamically constructed from strings as run-time. (But
beware of standard security issues surrounding code injection.)

`id` as a type says nothing more than "this object can receive
messages". An `id` var can point to `nil` (as opposed to `NULL`), which
evaluates to zero. Also, sending messages to `nil` is NOT an error, and
returns `nil`.

`id` can be an alternative to forward class declaration, but obviously
the tradeoff is that you're giving the compiler less information to use
for catching errors/typos.

Unrecognized messages/methods are warnings rather than errors because
sometimes the compiler cannot guarantee that the object definitely
cannot respond to a message.

Two ways to do a runtime check to see if an object/class responds to a
selector:

    [SomeClass instancesRespondToSelector:@selector(method)]
    [instance respondsToSelector:(SEL)aSelector]

Check if an `id` is an instance of some class via

    [someIdVar isKindOfClass:[NSArray class]]

What about `nil`? I guess it'll always return falsy (`nil`) for all
selectors, so `isKindOfClass` would correctly return falsy.

There is also a `conformsToProtocol` selector. In addition to a
`NSObject` class, there is an `NSObject` protocol... why? How is it
useful? Dunno.

You can use anonymous types scoped to protocols so that you can get all
those lovely compiler warnings you expect, e.g.:

    id <MyDumbProtocol> wat = something;
    [wat someMessage]

If you catch yourself doing this a bunch:
    
    id <MyDumbProtocol, NSObject> woot;

then maybe consider having MyDumbProtocol inherit from NSObject.

Of note: the presence of an anonymous type prevents the need for generic
programming features, like C++ templates. Then again you could just
store everything as a void pointer, right? But then in C++ you have to
do address translation in some cases. I think. I forget.

## NSEnumerator

Simple interface:

- nextObject: call until nil
- allObjects: returns an array of all remaining untraversed items;
  nextObject guaranteed to be nil after calling this

NSEnumerators retain the underlying container until traversal is
complete so that it's not dealloc'd mid-traversal.

Unsafe to modify collection mid-traversal.

Common example:

    id instance;
    NSEnumerator *enumerator = [myCollection objectEnumerator]; while (instance = [enumerator nextObject])
    {
      // do something with instance 
    }

Fast enumeration:

    id instance;
    for (instance in myCollection) {
      // do something with instance 
    }
    // or, alternatively:
    for (id instance2 in myCollection) {
      // do something with instance2 
    }

An object needs to support Fast Enumeration to be used in a for-in loop.
Enumerators themselves support fast enumeration, so you can do:

    id instance;
    for (instance in [myArrayInstance reverseObjectEnumerator]) {
      // do something with instance 
    }

Internal Enumeration is like `each` in Ruby, where the iteration is
internal to the collection or enumerator. Cocoa offers:

    - (void)makeObjectsPerformSelector:(SEL)aSelector
    - (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(id)anObject

## Objective-C runtime files

Explore `/usr/include/objc/*.h` for fun and profit.

## Selectors

    SEL aSelector = @selector(myDumbMethod);

NSObject has the following method for running `aSelector` later:

    -(id)performSelector:(SEL)aSelector

Interchangeable:

    id result1 = [someObject update];
    id result2 = [someObject performSelector:@selector(update)];
    id result3 = [someObject performSelector:aSelector];

Get a SEL from a String:

    SEL NSSelectorFromString(NSString *)

Passing an arg to performSelector

    - (id)performSelector:(SEL)aSelector withObject:(id)anObject

Need to use NSInvocation if

- more than one arg
- non object arg
- returns non-object value

Perform a method async...?

    - (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay

This schedules the event to fire via NSRunLoop, which only guarantees
that it won't fire before `delay`, but you might catch it mid slow
operation and it won't fire til after that's done. Obvious parallels to
Ember's Backburner.js.

Async performs are cancelable via `cancelPreviousPerformRequestsWithTarget`.

`NSRunLoop` runs in different modes which govern which sources of input
are read by the loop; async schedules are put in to `NSDefaultRunLoopMode`, and
the run loop might not be in that mode, which would cause that to be
ignored. Interesting, will need to follow up on that. Maybe that's
because there are different threads? And you can set up the different
threads to listen for different events? And a performSelector afterDelay
is just like any other events, like user tapped something, etc.

## Implementation of Obj-C message sending

First off, a `runtime` is any collection of functions/functionality that
comes with the compiled language and is depended upon to perform certain
tasks at runtime. That was a shitty definition. A runtime is any
collection of functionality you need at runtime that comes with the
language you're using. Handlebars has a runtime; even though your
templates are precompiled, they all depend on shared functionality that
lives within the Handlebars runtime that must be present to actually
render a template. I knew that, kinda, but it just clicked as a generic
concept. JVM is a runtime. C++ has a runtime. 

Two most important C functions:

    id objc_msgSend(id self, SEL op, ...);
    id objc_msgSendSuper(struct objc_super *super, SEL op, ...);

These fns search for a handling method on the receiver.

Here's the typedef for a C function pointer of a method that responds to
a selector:

    typedef id (*IMP)(id self, SEL _cmd, ...);
    // e.g.:
    IMP fn = &someFn;
    // i think this is valid C, I forget.

The search for the method on the receiver is slow, but the result is
cached on the receiver class so future lookups are fast.

You can convert a message send into a C fn pointer via:

    - (IMP)methodForSelector:(SEL)aSelector;
    + (IMP)instanceMethodForSelector:(SEL)aSelector;

The late binding provided by all of the above makes it possible for
other threads to schedule operations on the main thread via super
convenient methods like 

    - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait
    - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray * )array

## Accessors

Some obvious general benefits mixed w Cocoa-specific:

- Uniform access principle: flexibility to switch from simple instance
  variable storage to some other complex logic. In Ember this like how
  you can effortlessly switch between a raw value property and a
  computed property and any consuming code won't need to change if it
  has been using `.get()` from the start.
- Facilitate Cocoa's non-ARC memory maintenance
- Facilitate Cocoa Key-value coding and observation
- Facilitate special logic when (re)-connecting Interface Builder outlets.

Naming conventions: if you're returning a value, just name the getter
the name of the property (i.e. not prefixed with "get"):

    - (float) interestRate 
    {
      return interestRate;
    }

If you're returning by reference (via pointers), prefix with get:

    - (void)getInterestRate:(float * )aFloatPtr {
      if(NULL != aFloatPtr) {
        *aFloatPtr = interestRate; 
      }
    }

Apparently this is seldom-used, hence there's not many `get` methods in
Cocoa, but common in some cases where size of array returned is not
known ahead of time, or there are more than one "return" values, e.g.:

    -(void)getRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha

Setters are obviously prefixed by set

    - (void)setInterestRate:(float)aRate 
    {
      interestRate = aRate; 
    }

They make a good point about debugging utility:

> During debugging, if a property has an incorrect or suspicious value, 
> a debugger break-point set within the implementation of an accessor 
> halts execution whenever the property is changed and helps track 
> down how and why the value is being changed incorrectly.

This isn't super easy to do in Ember as a general capability unless it's
one of the rare cases where you're writing a getter-setter computed
property... maybe we can do something in ember-inspector that hooks into
ember-metal?

## Thread safety + Memory Management

Thread safety w memory management: consider the following:

    - (NSString * ) aString {
      return _myString ;
    }

An obvious getter that returns an NSString instance var. But lets say
there are two threads, where Thread A is retrieving `aString` and
intends to `retain` it, and Thread B releases the object that `aString`
lives on, thus causing it to be deallocated. In this case, there's a
race condition in multi-threaded environments:

    A: NSString * str = [alexObject aString];
    B: [alexObject release]; 
    B: // ref count is now 0, dealloc occurs
    B: // _myString gets `release`d and dealloc'd because ref count is 0
    A: [str retain];
    A: // BOOM. can't `retain` a dealloc'd obj

Realization: the "intending to _retain_" distinction isn't so important;
more important is "intending to use in any way"; sending a message to a
suddenly dealloc'd obj is going to break, it's just that the obvious way
to prevent dealloc is to immediately `retain` the return value of a
getter, but then you're still exposed to the race condition above. So
the retain needs to happen in the getter, a la:

    - (NSString * )title {
      id result;

      // Lock
      result = [[_myTitle retain] autorelease];
      // Unlock

      return result; 
    }

Makes sense, but I need to learn about when autorelease actually fires
its release... this would cause issues if the autorelease just happened
at the end of a thread's run loop, since another thread might not have
had time to use/retain an obj before the other thread released it at the
end of its run loop. AH CRUCIAL MISTAKE: I was some reason thinking that
the getting would happen in one thread and that retaining of that return
value would happen in another thread; no, all of that happens on one
thread, and autorelease, assuming my assumptions about the run loop are
correct, will always correctly fire after the code that called the
getter had a chance to use/retain its return value.

So actually, it sounds like consumers of getters don't need to call
`retain` unless they really intend to hold on to that value beyond the
end of the run loop.

    - (void)setTitle:(NSString * ) aTitle {
     ￼[aTitle retain];
  ￼￼￼￼[ _myTitle release];
      _myTitle = aTitle; 
    }

So if you had no locks on the above getters and setters, there'd be a
race condition where `[_myTitle release]` and `[_myTitle retain]` are
called at the same time, release happens first, and then `retain` gets
called on a dealloc'd my obj. So really you'd need

    - (void)setTitle:(NSString * ) aTitle {
     ￼[aTitle retain];

      // Lock
  ￼￼￼￼[ _myTitle release];
      _myTitle = aTitle; 
      // Unlock
    }

The above handles all the following cases:

- changing a value from nil to aTitle
- changing a value from somethingElse to aTitle
- changing a value from aTitle to aTitle
- changing a value from somethingElse to nil
- changing a value from nil to nil

This is due to the precise ordering of retains/release and assignment,
as well as the fact that sending messages to `nil` is harmless so long
as you don't count on the return value.

Hmm, I'm told that the following is actually the correct answer, but I'm
not sure why:

    - (void)setTitle:(NSString * )aTitle {
      id oldValue; 
      [aTitle retain];

      // Lock
      oldValue = _myTitle; 
      _myTitle = aTitle; 
      // Unlock

      [oldValue release]; 
    }

## NSKeyValueCoding

An informal protocol. Allows properties to be read/written by string
name.

## Archiving / Unarchiving

Objects can be (de)serialized into a binary format (or XML) and back,
and Cocoa handles all the issues of cross-platform byte ordering and 32
vs 64 bit, etc, issues that normally crop up when you try to store in
binary (apparently though it doesn't have to handle big/little-endian
issues?).

When Archiving, an object can conditionally or unconditionally
reference another obj; if unconditional, force the object to be stored;
if conditional, only store the object if something else has declared it
as unconditional, and if not, when unarchived, that object will be
`nil`.

So in Cocoa, a View knows about its subviews, but little to nothing about
its parent view, so it conditionally references its parentView, and
unconditionally references child views.

To archive an object:

    [NSKeyedArchiver archivedDataWithRootObject:someObject];
    +(NSData *)archivedDataWithRootObject:(id)rootObject

`rootObject` conforms to `NSCoding` protocol, and is sent a message to
unconditionally archive itself, causing the chain reaction that
ultimately archives the whole thing and returns `NSData` that can be
written to a file.

`NSUserDefaults` is the standard way of storing user preferences, but
it only supports storing `NSData`, `NSString`, and a few others... how
to encode something like an `NSColor`? Answer: "reopen" `NSUserDefaults`
by adding a custom category to it that defines `setColor` and
`colorForKey` to use `NSKeyedArchiver` to archive and unarchive to the
color to and from an `NSData`, which _can_ be stored in UserDefaults.

To implement `NSCoder` protocol, implement:

    - (void)encodeWithCoder:(NSCoder * )coder
    - (id)initWithCoder:(NSCoder * )

To encode/decode arbitrary C structs/unions:

> Either wrap the unsupported data types in objects that conform to the 
> NSCoding protocol and then encode those objects, or break the data 
> types down to supported components like int and float and encode
> the individual components.

Cocoa supports object substitution when encoding. I don't know what it's
used for, need to research more.

`-awakeFromNib` is almost like a `didInsertElement`, or rather an
`afterRender` callback called on an object after all the objects in the
archive have been unpacked, so you have the guarantee when the hook is
called that all `IBOutlet`s are connected. 

"Simulation" mode in Interface Builder encodes and decodes all objects
to simulate the real thang.

A `.nib` specificies a File Owner that will "own" the objects decoded
from the `.nib`. The owner object also receives an `awakeFromNib`
anytime a `.nib` is unarchived with that file as the owner. Obviously
this means you can associate a `.nib` with whichever owner you want (not
sure if you can do this dynamically?), and a single owner can own (be
associated with) multiple `.nib`s. That's kinda rad. 

## Copying

Some things don't make sense to be copied, like singletons e.g.
`NSApplication`, which is meant to contain a single connection to OS X's
Quartz window server. 

`NSCopying` in Cocoa is meant to produce shallow copies. One approach
for deep copies, if everything adheres to `NSCoding` protocol, is to
archive and then unarchive.

On mutability: Cocoa provides lots of immutable classes, like `NSString`
and `NSArray`. Why? Issues surrounding concurrency come to mind, e.g. if
you can only create new modifies versions of a string rather than
modify the string, then threads will each have their own copies of
strings to fart around with rather than have to manage complex locking
procedures when making changes to the thing. 

But the other thing to realize is that immutable objects can be shared,
and passed by reference without fear of someone mucking with them.
Multiple objects can "own" the same immutable object. Maybe this will
help me remember:

> Everyone owns immutable objects

or 

> There is no tragedy of the commons with immutable objects

`NSCopying` returns immutable copies, but there's also
`NSMutableCopying`.

If you're implementing copy on an immutable object, it's as easy as:

    - (id)copyWithZone:(NSZone * )aZone 
    {
      return [self retain]; 
    }

Optimal as fuck.

There is no formal `NSDeepCopying` protocol, but you can make your own
`deepCopy` method using Archiving and Unarchiving. 

`NSDictionary` copies objects used as keys, so those need to conform to
`NSCopying`. 

In Obj-C 2.0, it's common to have a public interface with `readonly`
properties, only to have an anonymous category class extension redefine
them as `readwrite` so that they are mutable within the implementation
but immutable to the public.

> The compiler allows redeclarations to replace readonly with readwrite, 
> but no other attributes of the property can be changed in a redeclaration.

So you could change something from

    @property (readonly, retain) NSString *word;

to 

    @property (readwrite, retain) NSString *word;

`retain` means setters retain their args rather than copy them.

Note that `assign` is the default among `assign`, `copy`, or `retain`,
so the following are equivalent:

    @property (readonly, assign)
    @property (readonly)

But the Obj-C 2.0 compiler will warn you if you use the default `assign` for a
property that adheres to `NSCopying`. 

## Strong and Weak pointers

Obj-C 2.0 supports `__strong` and `__weak` pointers. Presumably that
means `__strong` pointers can "own" the referenced object and increase
its retain count, while `__weak` pointer can only refer to an object but
have no ownership. It probably circumvents cycles. And it probably
implies that there's no mark and sweep phase? Is that true? There's no
weak reference in JavaScript, but maybe there's some other use case.
Mark and Sweep gets rid of the need for strong and weak pointers in the
case of handling circular dependencies, but are there use cases beyond
that? I guess there are, if you want to say "let this weak pointer
reference this thing that might disappear at any point." That could
exist even if mark and sweep were used... right? Yeah, it could. It just
means that the sweeper wouldn't traverse weak pointers.

So weak pointers can make sense in mark and sweep or reference counting. 

But mark and sweep is better at cycles and don't require manual cycle
breaking before garbage can be collected.

## Singletons

Given Obj-C classes are objects, why use instances over class objects?

Answer: rewriting all the references to the superclass when you
subclass. Class object or no, you're treating it as an instance, and
tightly coupling to that instance. Also, I don't really know enough
about how class objects work, but can you also inherit/override methods
with class objects the same way? Well, you can't store a pointer to a
class object without it looking really weird, right? Like:

    id foo = [NSObject class];
    [foo classMethod];

Is there a more specific type than `id` that lets you store classes?
Dunno. Point is: you could get in the habit of storing pointers to class
objects but using the factory pattern to avoid initializing them, and so
long as the interface the same you would have maintained loose coupling.
But this is no different than just saying Obj-C supports duck-typing so
your factory could return anything that conforms to whatever
informal informal protocol you're conforming to.

So to sum it up: the main reason not to do this is it becomes really
really confusing what you're trying to accomplish and subclassing
becomes extremely convoluted.

The Cocoa pattern is to have a class object encapsulate access to the
singleton instance and have the singleton encapsulate all the stuff
unique to what that object is doing. Derp.

`+sharedInstance` is usually the name of the singleton accessor.

    + (MySingleton * )sharedInstance {
      static MySingleton *myInstance = nil; 
      if (!myInstance) {
        myInstance = [[[self class] alloc] init];
      }
     ￼return myInstance; 
    }

Note the `[[self class] alloc]`, rather than `[MySingleton alloc]`. This
lets you subclass and defer the alloc to which subclass you're using it.
You can choose the subclass that locks in in an app ready hook by doing

    [MySingletonSubclass sharedInstance];

But you'd have to be careful that this ran before anyone else called
`[MySingleton sharedInstance]`, which is the API anywhere else in your
code. This parallels to Ember requiring that you've registered/injected
everything before your first lookup. Both feel kinda jank.

Also, obviously this won't work for `NSApplication` singleton because
it's created before your code even runs; to handle that, you have to set
the Principal Class in the XCode info panel when the application target
is selected, whatever that means. This actually writes through to the
Info.plist file. You could rewrite the above code to similarly look up
`infoDictionary` in `mainBundle` and choose which class to init.

Prediction: this code isn't thread-safe, right? 

    Thread A: [MySingleton sharedInstance]
              if (!myInstance) {
    Thread B: [MySingleton sharedInstance]
              if (!myInstance) {
                myInstance = ALLOC INIT STUFF;
    Thread A:   myInstance = ALLOC INIT STUFF;

Boom. Needs moar mutex.

There's also `alloc` and `allocWithZone` and a bunch of others and use a
`hiddenAlloc` not defined in the public interface. It's really messy and
error-prone. Kinda like a lot of Cocoa? 
  
But if you're using a singleton in Interface Builder (I guess this just
means referencing it as a File Owner?) you have to preserve normal alloc
and init semantics, so you end up having `alloc` return sharedInstance
and adding code to `init` to make sure it only inits once.

Singleton examples:

- `NSApplication`: maintains Quartz window server connection. Apparently
  it receives and distributes events via First Responder pattern. That's
  rad. Event delegation, or something else? What does it mean?
- `NSWorkStation`: encapsulates connection to Finder and underlying file
  system
- `NSFontManager`: maintains per-font singleton flyweights
- and friends

`+new` is old school Obj-C, deprecated as eff, and not to be used in
Cocoa.

Some classic Cocoa singletons became instances over time as their
assumptions changed, like `NSPrintPanel` and `NSPageLayout`. Be careful
about your assumptions, then?

## Random: parallel b/w calculus and OO?
    
The relationship between an instance and a class object could be
described as an integral relative to its derivative. 

    derivative(class) = instance
    integral(instance) = class + C

where `C` is all the methods declared on an object's singleton class. 

What's the derivative of an instance? Often it's 0.

## Notifications / Observers / Run loop scheduling

This is like Evented in Ember, except that the observer state lives in a
global `NSNotificationManager` in Cocoa whereas it lives on instance
meta in Ember. The Ember benefit is that testing becomes easier when you
don't have to remember to flush a global instance. It also means
you don't have to remember to teardown observers when you destroy an
object, observer or observee (I think; need to verify this).

Notifications are synchronous, so be mindful of performance implications
when complex interactions are involved. You can asyncify by doing a 

    [self performSelector:@selector(doSlowAssShit:) 
          withObject:[aNotification object]
          afterDelay:0.0f];

I wonder if the 0.0f performs in the same run loop or not? In Ember, I
remember making the change so that Ember.run.later would guarantee
running on a separate run loop.

For more complex async messaging, you can use `NSNotificationQueue`,
which handles the async-ness, and then posts notifications later, after
which point it's back in sync-land.

Oo oo oo:

> The NSPostASAP style directs the queue to post the notification 
> at the beginning of the next run loop iteration and is effectively
> identical to the -performSelector:withObject:afterDelay:

So afterDelay 0.0f forces onto the next run loop iteration. 

Three styles of async flags for a notification queue's 
`-enqueueNotification`:

- NSPostASAP: same as afterDelay:0.0f approach above
- NSPostWhenIdle: runs when run loop is ideal, e.g. no user input events
  or other things.
- NSPostNow: post the notification immediately and synchronously. Will
  still perform `NSNotificationQueue`-specific coalescing if there are
  other events with NSPostASAP or NSPostWhenIdle whose args match. This
  is like Ember.run.once except that it works cross run loop, whereas
  Ember.run.once only guarantees once-ness within a run loop. 

So far I don't think I've seen an example of enqueuing and action to the
same run loop... or maybe there was something earlier.

Cocoa lets you describe how once-ness coalesces via the following
`coalesceFlags` masks:

- NSNotificationNoCoalescing: same as Ember.run.schedule. No coalescing occurs
- NSNotificationCoalescingOnName: coalesce if notification names match
- NSNotificationCoalescingOnSender: `postNotification` includes a string
  `sender`, which Ember doesn't have, but this flag will cause events to
  coalesce on sender.

Ember doesn't let you specify coalesce options for `run.once`. It will
coalesce on action names, and replace any args present on a previously
scheduled action with the same name.

Since NSRunLoop supports multiple modes of operations (which I still
don't understand), you can also specify run loop modes in `forModes`.

`NSDistributedNotificationCenter` lets you post inter-process
notifications. Other apps must `addObserver` to register to receive them
of course. You can control suspended app behaviors, etc etc etc.

One downside about framework notifications is that you end up posting
notifications that no one may ever use, or you might not post a crucial
one that people would love to have, and there's a performance cost to
un-judicious use.

Notifications are similar to delegates, except that delegates are meant
to be the sole receiver/manager of these events.

## Delegation

Delegation is a benefit over subclassing and overriding hooks (Template
Pattern) because subclass-superclass coupling is bad, and it's also
hardwired at compile time whereas you can switch delegates dynamically
at runtime.

Another way to think about it is that sometimes model/controller state
dictate constraints on the view layer, e.g. `NSWindow` sizing and what
not, but subclassing `NSWindow` to pollute it with model/controller
concerns would break the separation of concerns. Delegates obviously do
this to some degree, but this breakage, if it can be considered that,
is way more encapsulated. 

`setDelegate` should only assign an instance variable but not retain it;
an object doesn't own its delegate, but a delegate knows about the
object. This avoids cycles and makes conceptual sense. Delegate objects
are responsible sending `setDelegate:nil` to all the objects it stands
in for upon `dealloc`. 

Data Sources are like delegates, but provides data rather than 
responding to a change. 

`NSOutlineView` and `NSTableView` use a data source.

## UIKit is iOS-only!

UIKit is iOS only (Cocoa Touch), dweebleton. Apparently UIKit is based on
`Application Kit`. 

    Cocoa:ApplicationKit::CocoaTouch:UIKit

## Prefix.pch for globally used framework headers

Save on typing by adding an `import` to `YourApp-Prefix.pch`, which
literally prepends it to every Objective-C source file in your proj.

Also, `.pch` means Pre-Compile Header.

## View Hierarchy

Non-opaque views let clicks through. Like `pointer-events` in CSS land.

Each view tracks two rectangles:

- bounds: always `0,0` origin unless reset at some point (there's a
  method to use this, apparently scrollview uses it). 
- frame: the box within the parent view's coord system.

Scaling is supported, resetting the origin (which affects bounds) is
supported. There are methods for translating between coord systems.

TODO: finish this bitchass book.


























