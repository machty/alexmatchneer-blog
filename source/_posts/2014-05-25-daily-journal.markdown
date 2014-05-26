---
layout: post
title: "Daily Journal"
date: 2014-05-25 13:26
comments: true
categories: 
- Web notifications
flashcards:
  - front: "API for growl-esque notifications in websites"
    back: "Web Notifications"
  - front: "Conway's law"
    back: "Organizations which design systems are constrained to produce designs which are copies of the communication structures of these organizations"
  - front: "Information Portal"
    back: "Aggregation of multiple sources of information into a single display"
  - front: "Data Replication"
    back: "e.g. user's address may be redundantly stored in many places, but needs to be updated if they change it in one, which requires integration"
  - front: "Shared Business Function"
    back: "Multiple components need to perform the same operation; integration means exposing this one thing as an integrated service"
  - front: "Service-Oriented Architecture"
    back: "a Service is well-defined function that responds to requests from Service Consumers. 1. Needs a service directory for discovery.  2. Each service needs to describe its API."
  - front: "Distributed Business Process"
    back: "Mediator; one component handles the coordination of a single business process among many other components."
  - front: "Business-to-business integration"
    back: "Basically, all the above, but not restricted to within a single enterprise (business). So you might use a 3rd party company to calculate shipping rates"
  - front: "Loose coupling tradeoff"
    back: "The more assumptions can be made, the more efficient the communication, but the more brittle in response to change or interruptions"
  - front: "Making remote invocations feel like local calls"
    back: "RPC/RMI"
  - front: "RPC/RMI difference?" 
    back: "RPC is C-based, not necessarily object oriented. RMI is method / OO-based"
  - front: "RPC/RMI Advantage"
    back: "1. Local invocation well-established and familar. 2. Defer the design decision to make a procedure call remote or local."
  - front: "RPC/RMI Fail"
    back: "Waldo et al in 1994 reminded us that object interaction in distributed system fundamentally different; so many things can fail/mismatch, how to recover, what if args mismatch, etc."
  - front: "EIP: Problems w just transmitting TCP/IP bytes to request deposit"
    back: "1. converting integer bits has incompatibility w different number representations, 2. big-ending / little-endian. 3. brittle if destination changes, or needs to go to multiple destinations. 4. TCP/IP is connection-oriented, so both machines must be present at the same time. 5. Data format changes requires updating both server and client"
  - front: "EIP: Solutions to TCP"
    back: "1. XML for self-description and platform-independence. 2. Use named channel rather than hard-wired hostname. 3. Queue up sent messages so that receiver doesn't need to be online to send messages. 4. Channel can convert messages in case either side changes."
  - front: "MOM"
    back: "Message-oriented middleware, handles sending and receiving messages b/w distributed systems"
  - front: "Sneakernet"
    back: "Transfer of data by physically moving the stored data from one place to another, because you wear sneakers to get it from a to b."
  - front: "EIP: Channel"
    back: "How data gets from A to B, e.g. TCP/IP connections, shared file, shared DB, floppy disk + Sneakernet"
  - front: "EIP: Message"
    back: "snippet of data with agreed-upon meaning to both sides; format may be different, but intent/meaning is the same"
  - front: "EIP: Translation"
    back: "translate FIRST_NAME and LAST_NAME fields to Customer_Name, etc."
  - front: "EIP: alternative to having customer service broadcast address changes to everyone else"
    back: "Have a routing component (e.g. a message broker) split the message to many components"
  - front: "EIP: the thing that monitors what's going on inside the entire system"
    back: "Systems management; monitors flow, makes sure all apps and components up and running, reports errors to central location"
  - front: "EIP: message endpoint"
    back: "connects a system explicitly to an integration solution; useful for legacy code"
  - front: "Process Manager (two responsibilities)"
    back: "1. storing data b/w messages (inside a 'process instance'). 2. Keeping track of progress and determining the next step (by using a 'process template')"
  - front: "React and Object.observe"
    back: "At odds, because the re-render everything upon change doesn't take advantage of the fact that Object.observe is a thing that will tell us exactly what changed and what needs to be re-rendered"
  - front: "NIH (also, what's the antonym?)"
    back: "Not invented here; antonynm: Proudly Found Elsewhere"
---

### Web Notifications

[Web notifications were added to ember-cli](https://github.com/stefanpenner/ember-cli/pull/804)
not long ago, and I forgot they were a thing. IRRCloud uses them too.
Like so many other new HTML5-y things, there's a
[spec](http://www.w3.org/TR/notifications/) for web notifications.
Basically, you ask for permissions and then you can broadcast.

### Not invented here (NIH)

[Wikipedia](http://en.wikipedia.org/wiki/Not_invented_here)

Antonym: Proudly Found Elsewhere (PFE)

Often a criticism of OSS communities reinventing the wheels in 
already-solved problem spaces.


