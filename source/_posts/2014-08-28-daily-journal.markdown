---
layout: post
title: "Daily Journal"
date: 2014-08-28 13:10
comments: true
categories: 
---

## Why can't React render() return multiple elements?

you can't do 

    return <div/><div/>


Pete Hunt tells me it's because of how `ref`s work; it's a common
pattern to do `this.refs.x.getDOMNode()`, but if the component returns
multiple DOM nodes, which one do you return?

It's an admitted shortcoming but not a major major push to fix any time
soon.

## Ruby Fixnum vs Bignum

    2.0.0-p353 :004 > (100).class
     => Fixnum
    2.0.0-p353 :005 > (100234234234234234234).class
     => Bignum

## Postgres indexing

I need to optimize. Most of the queries in my app are very specific
"SELECT WHERE bleh = wat, lol = yeah, foo = bar". By default Rails
creates a btree index, which handles many common indexing use cases, but
there's also a "hash" index, which Postgres only considers for usage for
`bleh = bleh` queries (you can't use it for ordering, sorting,
whatever), so it seemed ideal for me:

> Hash indexes can only handle simple equality comparisons. The query planner will consider using a hash index whenever an indexed column is involved in a comparison using the = operator. 

But then I'd like it to match multiple columns, not just a single one,
so I'd like to consider a multi-column index, but then:

> Currently, only the B-tree, GiST and GIN index types support multicolumn indexes. Up to 32 columns can be specified. (This limit can be altered when building PostgreSQL; see the file pg_config_manual.h.)

So I guess Hash is out of the question. So the final thing I need to
figure out is: does it make sense for me to use a multi-column index if
I have three columns that need to be `=` matched?




Partial indexes: http://www.postgresql.org/docs/8.2/static/indexes-partial.html

Useful for when you'd like to exclude common values from consideration
in an index (because indexes lose value the more duplicates there are in
a database).

## V8 optimizes based on AST size

...and comments are part of the AST:

https://github.com/broccolijs/broccoli-kitchen-sink-helpers/commit/092a680f1ff8fe2d54419dd57fa9ba8a81f6f297

## General Theory of Reactivity

https://github.com/kriskowal/gtor

Reactivity: reacting to external stimuli and propagating events.

- (functional) reactive programming
- bindings
- operational transform

- Spatial Singular is a value, e.g. 5
- Spatial Plural is an enumberable/iterable of values
- Temporal Singular is an eventual value, e.g. a Promise
- Temporal Plural is eventual values, e.g. Observable of values

But this glazes over many particulars, and things like Rx boil too much
into a single Observable type that can perform any role.

### Value

- Singular
- Spatial
- Accessible
- Modifiable
- Composed of a getter and a setter
- Data flows from setter to getter

Every reactive primitive features getter/setter, producer/consumer, or
writer/reader. See http://channel9.msdn.com/Events/Lang-NEXT/Lang-NEXT-2014/Keynote-Duality

Arrays are the above, but plural. Generators are the
producing/writing/setting side, iterators are the read/get/consume. 

Promises are singular and temporal. Promises are getters, and
corresponding setter is a resolver. Together, they're a kind of
deferred. 

Streams are a getter/setter pair of temporal plurals. Producer is a
writer and consumer is a reader. Reader is an async iterator and writer
is an async generator. 

Remember that a value encapsulates a getter and setter... values are:
Deferred (promise + resolver, singular, temporal), Stream (reader +
writer, plural, temporal), Array (iterator + generator, spatial,
plural), and value (getter + setter, spatial, singular).

Promises (singular + temporal) model dependency. The API/experience of
multiple resolvers is the same regardless of who wins the race, and same
w consumers. 

Because consumers cannot interfere with another consumer, aborting
promises is not possible; promise is only the result, not the work
leading to that result.

A task, similar to promise, but is unicast.

Unicast: http://en.wikipedia.org/wiki/Unicast - sending messages to a
  single destination

Broadcast: multiple possible destinations (or none)

Because tasks are unicast, consumers can't clobber each other (because
there's only one), hence they are cancellable. Can be explicitly forked
to create a task that depends on the same result 























