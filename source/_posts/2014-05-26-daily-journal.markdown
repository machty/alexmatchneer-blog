---
layout: post
title: "Daily Journal"
date: 2014-05-26 13:17
comments: true
categories: 
flashcards:
  - front: "4 Application Integration Options"
    back: "1. File transfer. 2. Shared Database. 3. Remote Procedure Invocation. 4. Messaging"
  - front: "EIP: freshness"
    back: "File-based integrations have staleness considerations; e.g.  process address change at night, but a shipment happened that day after the request. Also, the longer the length of time to sync, the more conflicts can sneak in."
  - front: "File Transfer relative to Messaging"
    back: "High-frequency file transfer is like messaging, but way inefficient, error prone, etc. Similarities include storage, fire and forget, etc."
  - front: "Semantic dissonance"
    back: "aka conceptual impedance mismatch e.g. two very similar seeming applications have subtly different specific definitions of a concept that can result in differing implementations"
  - front: "Political considerations of shared DB"
    back: "Challenging/delaying to conform multiple applications to a single schema, irresistible pressure to split"
  - front: "Shared DB limitations"
    back: "External packages have their own schemas which also might change b/w versions; company merges occur later, thwarting the previously consolidated plan."
  - front: "When to use RPI?"
    back: "To integrate application's functionality rather than data."
  - front: "WSDL"
    back: "Web Services Description Language; XML-based description of a service: expected params, structure of data produced, error format"
  - front: "UDDI"
    back: "Universal Description, Discovery, and Integration; dictionary of WSDLs"
  - front: "SOAP"
    back: "simple object access protocol; XML-based protocol for structuring messages to web services"
  - front: "List of RPC implementers"
    back: "CORBA, COM, .NET Remoting, Java RMI"
  - front: "RPI's familiarity w normal method invocations has this weakness"
    back: "Familiarity conceals major performance/reliability implications"
  - front: "RPI relative to Messaging suffers from ______"
    back: "Tight coupling; interfaces are designed for specific applications, not resilient to change"
  - front: "Cohesion / Adhesion"
    back: "(in regards to working w remote applications) cohesion is local work and adhesion is remote queries"
  - front: "to avoid or not to avoid semantic dissonance"
    back: "a corporate merger or necessary integration w 3rd party software is going to require it anyway, so best to address the issue w messaging rather than design applications that avoid it "
  - front: "How do you transfer packets of data?"
    back: "Sender sends a Message via a Message Channel that connects sender and receiver"
  - front: "How do you know where to send the data?"
    back: "Sender can send to Message Router, and it can decide"
  - front: "How do you know what format of data to send?"
    back: "If sender/receiver can't agree, sender can send to Message Translator, which translates and forwards"
  - front: "If you're an app dev, how do you connect your app to messaging system?"
    back: "Implement Message Endpoints to perform sending and receiving"
  - front: "Message Channel"
    back: "Virtual pipe that connects sender and receiver; newly installed messaging systems typically don't contain any; up to you to define for application's need"
  - front: "Pipes and Filters"
    back: "Any validations/transformations/etc that happen b/w sender and receiver"
  - front: "Endpoints (messaging)"
    back: "Layer of code in an application that touches both app and messaging code; a bridge between worlds"
  - front: "Message consists of N parts:"
    back: "1. Header (origin, destination, describes data). 2. Body, generally ignored by system and simply transmitted onward"
  - front: "HEAD in git"
    back: "a reference to the currently checked-out commit"
  - front: "Abstract Pipe"
    back: "an interface for IO (such as used by filters) that could either be local memory or a full on Message Channel"
  - front: "Potential downside of Filters and Pipes"
    back: "Each pipe is a connector between filters, and if implemented via a Message Channel could consume much memory and CPU cycles for storage, translation, etc"
  - front: "Throughput and Filters"
    back: "Filters with their own thread/process and connected via async cross-process/cross-thread channels can achieve higher throughput, pipeline style"
  - front: "Parallelize"
    back: "(vs. sequential); add more instances of a some process working at the same time; multiply process X by N so that as input comes in, one of the N processes can process it"
  - front: "Filter overloading"
    back: "Filter can mean 1. a step in a process that applies some logic / transformation, or 2. something that removes data from a set based on some criteria"
  - front: "predictive / reactive routing"
    back: "Message Router knows destinations vs Pub Sub channel consumers choosing themselves"
  - front: "Failover"
    back: "Automatic switching to redundant system in case of failure"
  - front: "Content-based routing"
    back: "Routing based on message content"
  - front: "Context-based routing"
    back: "Routing based on environmental conditions, e.g. load balancing, etc."
  - front: "Message Channels and load-balancing"
    back: "Rather than using a router for load-balancing, you might already have load balancing if Competiting Consumers are pulling messages off of a channel as fast as they can; tradeoff is that Message Routers have more information to make this decision"
  - front: "Round robin"
    back: "maintaining a list of output channels (could be ip addresses) and cycling through them in some manner"
  - front: "Live update a router"
    back: "Using a Control Bus"
  - front: "Integration equivalent of GoF Mediator"
    back: "Message Broker"
  - front: "HTTP"
    back: "Hypertext Transfer Protocol; application protocol"
  - front: "Application Protocol"
    back: "Sit on top of transport layer. Controls message body format to do application-specific things without having to be concerned about TCP/IP considerations, etc"
  - front: "HTTP is this kind of protocol"
    back: "application-layer"
  - front: "Internet protocol suite"
    back: "More commonly known as TCP/IP. Transmission Control Protocol + Internet Protocol"
  - front: "SOAP and caching"
    back: "SOAP is shitty at caching because resources are not a first class concept like they are in REST, which deprives of verbs"
  - front: "transport vs transfer"
    back: "The dumb/blind carrying of data from A to B (transport) vs (transfer) the consideration of message content / what's being sent to effectively process the transfer. HTTP is transfer, evidence of this is all its verbs and status codes."
---

### EIP: Notes

Consider reading _Data and Reality_ by William Kent.

Semantic dissonance is ironed out by shared database schema; each app is
forced to conform its data to that schema before saving to that
database. 

Coming up with unified schemas that meet the needs of multiple
applications is extremely difficult, and there are political
considerations; the delay of a flagship product so that a shared
database can be adhered to often leads to splitting. 

#### RPI: Remote Procedure Invocation

#### Web Service / WSDL

Seems like I come across this term enough without actually knowing how
it's specifically defined; presumably a REST API is a kind of web
service, but what's the official definition?

[Wikipedia says](http://en.wikipedia.org/wiki/Web_service):

> A Web service is a method of communication between two electronic devices 
> over a network. It is a software function provided at a network address 
> over the web with the service always on as in the concept of utility computing.

A web service allows two software systems to interact with each other
over the internet. You can interact with a web service so long as you
have its publicly available address.

Rules for communication between web services are defined in WSDLs (Web
Services Description Language). A searchable dictionary of discoverable
WSDLs is a UDDI (Universal Description, Discovery and Integration).
Interacting with these services often involves using the SOAP protocol
(Simple Object Access Protocol), an XML format for structuring messages
for web services. 

#### Messaging

Senders don't just barf information into a messaging cloud but rather
adds this information to a particular Message Channel, likewise w
receivers who must explicitly specify Message Channels. 

Channels are "logical addresses" which hide implementation details of
how the underlying messaging system actually delivers these messages.

It's often possible but rare for channels to be dynamically created at
runtime; receivers would also need to know to look for such a channel,
so channels are usually decided by deploy time (apparently there are
exceptions?).

In Java et all, `new MessageQueue` won't actually create a new channel,
but will just create a wrapper for a channel pre-defined in
administrative tools. 

Channel names are generally boring ol alphanumeric names like
`MyChannel`, but hierarchical conventions exist to, e.g.
`BlahCorp/Prod/OrderProcessing/NewOrders`. 

Two types of Message Channels: - _Point-to-Point_ and
_Publish-Subscribe Channels_.

From the application dev's perspective, there are a few different types
of messages:

- Command Message: invoke a procedure in another app
- Document Message: pass data to another app
- Event Message: notify another app of a change in this app
- Request-Reply: receiver should send back a response

A SOAP message is a _Message_, but it itself could be wrapped in another
outer message. Recursive, babeh.

### Git: detached HEAD state

`HEAD` is a reference to the currently checked-out commit. Usually it
points to a branch you have checked out, but if you try and check out a
specific commit, tag, or remote branch, you'll go into detached HEAD
state.

Don't call it "headless" state; you're probably mixing terminology with
headless webkit or something, like I did; there's no "headless" state
in Git, you always have a HEAD, but if it's detached, it means you're
not tied to a branch any more. 

So `HEAD` always refers to the currently checkout out commit, which is
why if you run `git checkout HEAD~1` many times in a row, you'll be
rewinding to a previous commit every time you run it rather than
repeatedly checking out the tip of the current branch minus one, which is what I
originally thought. Also, there is no "current branch" once you're run
`git checkout HEAD~1`; the commit you've checked out could be an
ancestor in many different branches, so if you want to re-attach, you
have to be explicit.

### Filters and Pipes

A pipe connects filters. A filter is a single purpose component that can
be reused. Filters have an input pipe and output pipe, and don't
generally have knowledge of where the output pipe is pointing.

Why is it called a pipe and not a channel? Because a channel is named,
and anyone pushing or pulling from it is doing so according to some
logical intent, whereas filters are way dumber.

Filters can/should be implement via an abstract pipe interface, so that
all filtering could potentially happen within one machine, but at any
point the pipe could be turned into a full on Message Channel that might
go to some other machine. 

Filters lend themselves nicely to testability as individually testable components.

Filters connected via async channels in their own processes/threads also
allow for higher throughput for typical pipeline reasons; 3 messages
that come in at the same time that need to be decrypted, authenticated,
and deduped can begin w the decryptor, which, once finished with the
first, can move on to the next. Assembly line style.

Parallelizing filters works best if the filter is stateless, e.g.
de-dupe would be a challenge to parallelize since it depends stores
previous messages to check for dupes, and wouldn't function unless that
storage was shared.

### Message Router

- Doesn't modify message contents
- Only decides destination message
- Message Routers are meant to decouple, but if list of destinations
  changes often, Router might become coupled bottleneck, in which case
  it's better to let recipients (i.e. that which Router would output to)
  decide which messages they're interested in, i.e. Pub Sub channel.
- _Predictive routing_ means putting control in Message Router; _reactive
  routing_ means Pub Sub.

Decoupling is nice but comes at the expense of reasonability about the
system; harder to see a flow.

Brainless router: single input, single output; meant as a stub for when
we're pretty sure we'll want a more intelligent router later.

Content-based router: decides where to go based on message content.

Context-based routers: decide where to go based on environmental
conditions, e.g. load-balancing, test, failover.

Failover: switching to redundant / standby system automatically if
primary one fails.

Note that some Message Channels come with their own form of load balancing
if Competing Consumers are consuming off the channel as fast as they
can, but Message Routers have the benefit of being able to use more
complicated logic, which a Competing Consumer free-for-all would not be
able to make use of.

Routers can connect to Control Bus to live-update decision criteria
without requiring code change.

Routers play in important role in Message Broker pattern, which is the
integration equivalent to the Mediator GoF pattern.

### EDI: Electronic Data Interchange

Source: EIP, using EDI 850 Purchase Order as an example.

[Wikipedia](http://en.wikipedia.org/wiki/Electronic_data_interchange)

Electronic communication system that provides standards for exchanging
data via any electronic means.

Origins: military logistics


ERP: Enterprise Resource Planning

### Why HTTP isn't a transport layer

[Source](http://restpatterns.org/Articles/Why_HTTP_Isn't_A_Transport_Protocol)

So many things to dissect. I'm sad I still don't have this shit stuck in
my brain. Gosh damn.

Alright, what's a transport layer? TCP's a transport layer. It's
concerned with getting data from A to B and doesn't care about the
format of the data. UDP is also one, but doesn't guarantee delivery,
packet order, etc. 

HTTP (Hypertext Transfer Protocol) is an application-layer protocol.

Good explanation of layers:

    http://en.wikipedia.org/wiki/File:Internet_layering.svg

IP is the Internet layer, the addressing layer that describes how
different systems can access each other.

Blah blah blah. Anyway, armed with this knowledge, what does it mean for
HTTP to even be considered a transport protocol? 

Some people expand HTTP to Hypertext _Transport_ Protocol, which is NOT
the same as the actual correct _Transfer_ protocol.  It's not transport, 
it's transfer, you dummy. 

Subtle differences between transfer and transport:

- Transport as agnostically carrying something from A to B
- Transfer pays attention to the content of what's being transferred.

That's why HTTP offers so many different verbs (GET POST PUT PATCH
DELETE CONNECT OPTIONS HEAD) and status codes. You'd only need to GET/PUT and 200/500/400
(success, server failure, client failure) if HTTP were a transport
protocol, but the fact that it has all these expressive differences in
intent implies it's most of an application/transfer layer. 

OK, so well done, article, but terrible job at explaining exactly _who_
is using HTTP as a transport layer protocol and how and what the cut off
is. I still don't know.

Oh I get it, from the wiki article an example SOAP message:

    POST /InStock HTTP/1.1
    Host: www.example.org
    Content-Type: application/soap+xml; charset=utf-8
    Content-Length: 299
    SOAPAction: "http://www.w3.org/2003/05/soap-envelope"
     
    <?xml version="1.0"?>
    <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
      <soap:Header>
      </soap:Header>
      <soap:Body>
        <m:GetStockPrice xmlns:m="http://www.example.org/stock">
          <m:StockName>IBM</m:StockName>
        </m:GetStockPrice>
      </soap:Body>
    </soap:Envelope>

So in this case there is a SOAP message that itself adheres to an XML
schema, but in most cases it is transported within the body of an HTTP
request. So it uses HTTP as its transport layer. A SOAP message _could_
be transported over TCP socket, but it's generally done over HTTP. 

I've resolved my confusion: for any given message format, a message
needs to be transported. SOAP is a message format, and it just so
happens to be wrapped in HTTP. You could wrap a message in many
different layers which might be intended as application layers, each one
treating its wrapper as a transport layer.

SOAP is shitty for caching because resources are not a first class
consideration in the way they are for REST. HTTP headers and resource
URLs provide information that lends itself nicely to caching.








