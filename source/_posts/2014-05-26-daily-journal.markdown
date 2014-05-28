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
  - front: "XSL"
    back: "Extensible Stylesheet Language: family of languages to transform and render XML docs (XSLT, XSL-FO, XML Path)"
  - front: "ActiveX"
    back: "Microsoft framework that adapts earlier Component Object
    Model"
  - front: "Create an XML doc in JS"
    back: "document.implement.createDocument()"
  - front: "SGML"
    back: "Standard Generalized Markup Language; derivatives include XML and HTML"
  - front: "XML rel to SGML"
    back: "subset of features to allow for easier parsing among other things"
  - front: "DOMString"
    back: "UTF-16 string; JavaScript already uses these, so a DOMString is just String. (there is no DOMString class in JS)"
  - front: "XML Namespace"
    back: "A URI, e.g. URL for the author's webpage, e.g.  http://www.w3.org/1999/xhtml. The URI/URL doesn't need content, just uniquely refers to that spec"
  - front: "set an Element's attribute in js"
    back: "element.setAttribute('onclick', "alert('wat')")"
  - front: "Difference b/w Node and Element"
    back: "Nodes could be text nodes. Just nodes in trees. Elements are named, can have classes and IDs, etc. An Element IS a Node."
  - front: "Inline event and translation"
    back: "onclick='alert(\"shit\")' becomes anonymous fn that gets `call`'d with clicked element as the context"
  - front: "DOM Level 0 events"
    back: "inline and traditional; only single handlers supported"
  - front: "Standardizes ECMAScript"
    back: "TC39"
  - front: "Standardizes Web Architectures"
    back: "W3C TAG (Technical Architecture Group)"
  - front: "Mr. Promises is a member of ..."
    back: "W3C Tag"
  - front: "Rick Waldron is member of ..."
    back: "W3C Tag"
  - front: "Yehuda Katz is member of ..."
    back: "TC39 and W3C TAG"
  - front: "iOS click events"
    back: "don't bubble up to document, unless 1. native button/link clicked, 2. handler explicitly added, 3. cursor: pointer (which prevents copy/paste from working as expected)"
  - front: "Start of xml doc"
    back: "<?xml version="1.0" encoding="UTF-8"?>"
  - front: "XSLT is a member of this family of languages"
    back: "XSL, extensible stylesheet language"
  - front: "XSLT"
    back: "Extensible stylesheet language transformations"
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

### ActiveX!!!

I never really knew what this was. It implies security risk and
executable code within Internet Explorer. But wat it be?

[Wikipedia](http://en.wikipedia.org/wiki/ActiveX)

It's a Microsoft framework, picking up where Component Object Model
(COM) left off. It enabled extra features in Internet Explorer but made
it easy for malicious dicks to run code that was automatically
downloaded from an `OBJECT` tag. 

There's a word that keeps on getting thrown around: control. An ActiveX
control. What kind of shitty name is that? Is that like the short-lived
Ember.Control? What a control is?

> ActiveX controls are essentially pieces of software and have access to your entire computer if you opt to install and run them.

> An object in a window or dialog box. Examples of controls include push-buttons, scroll bars, radio buttons, and pull-down menus.

> ActiveX controls are small programs, sometimes also called "add-ons," used on the Internet. They can make browsing more enjoyable by allowing animation or they can help with tasks such as installing security updates at Windows Update.

> These are objects that are like small programs or "applets" and a number of Microsoft programs like Office and Internet Explorer (IE) are designed to be able to interact with them. An example is a spell checker. Since Word comes with a spell checker, other Microsoft programs such as Outlook Express can make use of it. In fact, any program with the appropriate interface can use this spell checker.

So they're plugins / addons. Sometimes they've visible, other times
they're hidden. But they were originally used to enhance the
functionality of Internet Explorer to view things like PDFs and
Macromedia Flash. So basically, ActiveX controls are components that
could be reused in many different settings. Building blocks. Yesterday's
technology: tomorrow. 

> ActiveX controls are actually not Internet Explorer-only. They also work in other Microsoft applications, such as Microsoft Office.

ActiveX increases the attack surface by malicious dicks; even a
well-intentioned but carelessly implemented ActiveX control could 
open the door to hackery, such as the Java ActiveX control. 

### XSL: Extensible Stylesheet Language



### document.implementation

[MDN](https://developer.mozilla.org/en-US/docs/Web/API/document.implementation)

Returns a DOMImplementation object associated with the current document.

`document.implementation.createDocument(namespaceURI, qualifiedNameStr, documentType)` 
creates an XML doc.

- `namespaceURI`, e.g. 'http://www.w3.org/1999/xhtml'
- `qualifiedNameStr`: qualified name of the document to be created,
  which is an optional prefix + the local root element name; if you're
  creating an html document, you'll provide 'html' because that's the
  root element name of an html doc.
- `documentType`, optional, often just null

Many examples use Document.load to load xml data, but it's not part of
the [Load and Save](http://www.w3.org/TR/2004/REC-DOM-Level-3-LS-20040407/)
spec any more, or it is, but Load and Save is really old? 

This spec is/was

> a platform- and language-neutral interface that allows programs and scripts to dynamically load the content of an XML document into a DOM document and serialize a DOM document into an XML document

### Level N

DOM Level 3 wtf does it mean? I guess it just means a more complex
layering on top of a previous level. Additional levels enhance and
expand scope, while versions are meant to refine, fix issues, etc,
limited to that scope. As DOM Levels increase, features are added that
don't conflict with lower DOM features but just add more stuff on top.
So you can just use DOM Level 1 features and never touch anything above,
but those above Levels will never thwart DOM Level 1. 

- DOM Level 0: pre-specification DOM API, e.g. IE3
- DOM Level 1: (1998) full specification for HTML/XML doc, partly
  implemented by IE5
- DOM Level 2: (late 2000) added `getElementById` and an event model
- DOM Level 3: (late 2004) added XPath and keyboard event handling and
  support for serializing docs as XML (?)
- DOM Level 4: currently being developed, last call working draft
  released in Feb 2014. 

The terminology used as that DOM Level 3 is the latest "release". But
not to be confused with versions... presumably each level has its own
version.

### Events

Informed by this [Wikipedia article](http://en.wikipedia.org/wiki/DOM_Events#DOM_Level_0)

DOM event handling has evolved over the years. 

#### DOM Level 0 events

(DOM Level 0 meaning pre-spec DOM).
  
- inline, e.g. `onclick="alert('shit'); return false;"`, which
  essentially gets invoked as
  `(function() { alert('shit'); return false; }).call(clickedElement)`
- traditional; event handlers can be added/removed by script, but only
  one event handler could be registered; `node.onclick = handler`,
  `node.onclick = newHandler;`, etc.

Did you know that `document.onclick = someFn` still works? Ridiculous!

#### DOM Level 2 events

`addEventListener`, `removeEventListener`, `dispatchEvent`, along with
`stopPropagation` and `preventDefault`.

Fun fact: I thought the third param to addEventListener was some
ActionScript-y thing about weak references, but it's actually
`useCapture`. Capture events occur starting from the root of the DOM
(document) and move toward the event target; any capture event listeners
registered in that direct line will be invokved first and have the
opportunity to `stopPropagation`. 

Fun fact; the ancestor chain of bubbling events is determined before the
event is fired, so that any DOM modifications that happen
(e.g. moving the EventTarget to some other part of the DOM) within an
event handler doesn't affect the predetermined chain.

`event.target` refers to the `EventTarget`; this is the receiver of the
event

#### Event Delegation

From [learn.jquery.com](http://learn.jquery.com/events/event-delegation/):

> Event delegation allows us to attach a single event listener, to a parent element, that will fire for all descendants matching a selector, whether those descendants exist now or are added in the future.

If this feature didn't exist, then you would have to do a lot more
manual adding and removing of event handlers as DOM elements were added
and removed, whereas delegation allows you to define an event handler on
a parent node that only fires when the event passes through a child
described by a selector, e.g.

    $('#table').on('click', 'td', function() { });

One of jQuery's original APIs for event delegation was `.live`, e.g.
`$('a').live(...)`, but this had some issues:

- The selector eagerly fired when it didn't to (perf)
- Chaining methods didn't work, which is a surprising and bad API,
  e.g. $('a').find('p').live('click');
- `.live()` events always attached to `document`, which means events
  take the longest and slowest path before being handled, e.g. a click
  on an `a` tag 20 levels deep in the DOM needs to go all the way
  through those 20 levels before being handled.
- `click` doesn't bubble to `document` on iOS so `live` can't work
  without other workarounds, e.g. (cursor:pointer), natively clickable
  elements, etc
- stopPropagation doesn't work since event already propagated to
  `document` by the time `live` logic fires
- `.live` interacted weird with other methods, e.g. `$(document).off()`
  would disable `live` handlers, even though `live` selector seemed to
  imply some other magic.

That's why things shifted to `delegate` and eventually `on`, which hits
the sweet spot.

    `$('#root').on('click', 'a', handler)`

Benefits of this approach include:

- 'a' isn't unnecessarily queried up front
- Chaining will work as expect (i.e. continued modifications to `#root`)
- No longer throw everything on `document`
- Explicit syntax suggests workarounds for iOS

#### Historical shit

[source: quirksmode](http://www.quirksmode.org/js/events_order.html)

Netscape 4 had capture only.

Microsoft had bubble only.

jQuery provides event bubbling for all, along with event delegation,
which _depends_ on event bubbling in order to work (the italics are
probably overkill; if you have event capture you can implement event
bubbling... even if you didn't have event capture, you can walk the tree
and implement yourself).

Proof that you can implement it yourself: 

http://jsbin.com/tofop/1/edit

Just loop over parentNode until you get there.

jQuery never provided an API for event capturing because it's not
possible on old IE. I guess it's possible, but you'd have to introduce
some async-ness, which would probably break other assumptions. So for
IE6, which only supported bubbling, if you wanted something like

    $('a').capture('click', handler);
 
you would have to first manually walk the tree up to the document,
then refire a fake event back to the target, calling any capture
handlers, 

So if all you had was Netscape

Ember depends on jQuery for event delegation. This will probably go away
soon. 

### What's wrong w iOS anyway?

Non-native click events don't bubble up to document unless

- the clicked thing is a native clickable, e.g. link or button
- the clicked thing has a handler explicitly attached to it, e.g.
  onclick= attr or addEventListener on that thing.
- [example](http://jsbin.com/xuwuvu/1/edit)

### W3C: World Wide Web Consortium

The standards organization founded and led by Tim Berners-Lee.

W3C TAG is the Technical Architecture Group in charge of documenting and
building consensus around principles of Web architecture. People whose
names my dumb brain should remember on the TAG:

- Yehuda Katz
- Domenic Denicola
- David Herman

Not to be confused with TC39, which standardizes ECMAScript. Membership
can be determined by those present in the
[meeting notes](https://github.com/rwaldron/tc39-notes/blob/master/es6/2014-04/apr-9.md)

So W3C Tag reviews things like 
[quote management](https://dvcs.w3.org/hg/quota/raw-file/tip/Overview.html)
APIs and stuff that browsers need to expose, and TC39 handles language
features for ECMAScript. 

### XSLT

OMG so many dumb things to learn. Here's a 
[JSBin](http://jsbin.com/davew/1/edit) for farting around w
XSLT transformations. Kinda reminds me of `<content select="asd">` in
Web Components land, though probably way more complicated.

