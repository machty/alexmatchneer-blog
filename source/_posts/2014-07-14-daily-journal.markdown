---
layout: post
title: "Daily Journal"
date: 2014-07-14 09:33
comments: true
categories: 
---

## Website Push != Push Notifications

So when you're rummaging through the Apple Dev Portal, don't confuse the
two and generate the wrong certs. K?

## WWDC 2011 video on UIViewController Containment

    https://developer.apple.com/videos/wwdc/2011/

First off, WWDC stands for the Apple World-Wide Developer Conference.

## Why view controllers

- Make it easy to make high quality apps
- Reusable

A View Controller just a Controller. Mediates model data with many
views. View controllers maintain entire hierarchies of views. They're
heavyweight, meant to manage a "screenful of content". Often packaged
with a model, e.g.

- TweetViewController
- ImagePickerController

View Controllers are social, meant to connect to each other. They push
and pop each other, etc. They talk to each other a lot. 

The "manage a screenful of content":

View Controllers anticipate being presented in different ways. More
accurately: they should maintain a unit of content. Only
`rootViewController` manages a "screenful of content", specifically the
`rootViewController` property of the window object. Knows how to forward
rotation events, decides overall layout. 

How to use View Controllers

- subclass UIViewController
- associate VC w view hierarchy
- override callbacks

Apperance callbacks: viewWillAppear, viewDidAppear, etc
Rotation callbacks: viewWillRotate, etc

ViewControllers manage an entire view hierarchy. Not just one to one
with a view. 

View Controller Containers, a tale of Two Hierarchies: view hierarchies
and view controller hierarchies. 

Container controllers

- responsible for parent child relationships
  - API like `initWithRootViewController` implies parent-child in nav
    controller
  - split view controllers lets you set view controller children.

Controller container api

- addChildViewController
  - not meant to be called by anyone but its own implementation; don't
    call it on other controllers, basically
- remoteFromParentViewController
  - ^^ ditto
- childViewControllers array
- callbacks
  - willMoveToParentViewController
  - didMoveToParentViewController

Shouldn't be able to walk up view hierarchy and totally skip over a
parent view controller: UIViewControllerHierarchyInconsistencyException,
prevents you from manually adding views into the wrong view controller
hierarchy. 

When are appearance callbacks called?

viewWillAppear etc has nothing to do w addChildViewController, which has
nothing to do w view appearance.

viewWillAppear just means it's in the window view hiearchy, but doesn't
mean it's actually visible (same w viewDidAppear).

TODO: what is view layoutSubviews?

viewDidAppear after the view added to viewHierarchy. Called after
layoutSubviews.

When implementing transitions, you have to implement
didTransitionToBlahBlah, one of the options is `animations` lambda. 

VS Layout callbacks:

- viewWillLayoutSubviews...

Presentation and Dismissal of VCs

set presentation style and then do presentViewController

Can also present VCs by direct subview manipulation. 

    [root.someView addSubview: vc.view]

But this is bad form; better to make the VC a child of the root VC. VC
knows where subviews should go rather than the ass backwards way.

When to create a custom view controller container?

- Hopefully you don't need to, so think twice first
- Aesthetics
- Custom app flows
- Your app manipulates view hiearchy directly

Use case: make split view show up in both landscape and portrait: no
need to make custom VC because now there's API to just better configure
split view.

View controllers know themselves if they're moving to or from parent
view controllers within viewWillAppear and viewDidAppear by checking:

    // used in viewDid/WillAppear
    - (BOOL)isMovingToParentViewController;

    // used in viewDid/WillDisappear
    - (BOOL)isMovingFromParentViewController;

    - isBeingPresented;
    - isBeingDismissed;

Lol:

    - (BOOL) automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers;

## RFC

RFC's (Request for Comments):

> Memos in the Requests for Comments (RFC) document series contain technical and organizational notes about the Internet

http://www.ietf.org/about/

So many standards organizations. How am I supposed to keep this separate
from IEEE? 

Anyway, RFCs are docs produced by IETF. I don't think anyone else
(notable) produces docs called RFCs. 

## Push Notifications

Two levels of trust involved in publishing a push notifications:

### Connection Trust

- Provider-side: provider proves it is an authorized provider that
  Apple's agreed to publish notifications for
- Device-side: APNs must validate the connection is a with a legit
  device

### Token Trust

Establishes certainty that messages are routed correctly; a provider
shouldn't be able to send messages to random iPhones. 

- APNs gives device a token
- Devices gives it to provider
- Provider uses it when publishing to APNs
- APNs uses it to route back to device

A `device token` is not a device `UDID`; aside from being a totally
different string, it is conceptually different in that it identifies not
only the unique device, but the application the Push Notification is
delivered to.

Maybe that's what's confusing: don't call it a `device token`, call
it... an app-token? I get confused by the easiest things. 

### Providers must maintain persistent connection

If you want to send a notification through APNS (and GCM), 
you must maintain a persistent connection to the server. In other words,
you can't just connect-sendmessage-disconnect a la HTTP, which makes
push notifications inconvenient for Rails-y architectures without
using Sidekiq/Resque to reuse a persistent connection. 

I both:

1. failed to realize that this was a requirement for a while and
2. failed to understand why

The best justification for this architecture that I can determine from
the docs and people I've talked to is that constantly
connecting/disconnecting to what is a high-performance, low-latency,
distributed system would be a colossal waste of resources and a latency
hit. An app capable of notifications is essentially a stream that APNS
consumes, and might be sending thousands of messages, so either way
they'd at least need to support a persistent connection for performance
reasons, and if they're going to support that, why bother supporting
an obviously deficient connect/disconnect-based server interaction. 

How many other services can be considered consumers of your stream?

### Service-to-Device Connection Trust

Device identity is established via TLS peer-to-peer auth (internally;
iOS devs don't need to implement this).

- Device TLS auths w APNs
- APNs returns certificate, which it validates
- Device sends device certificate to APNs
- APNs valiates device certificate

So I guess this prevents:

- an iPhone mimicker pretending to be something it's not
- an APNs ripoff pretending to be something it's not

### Provider-to-APNS connection trust

Same process as above, just w provider (your server) and APNS.

A connection to APNs can only serve a single application, identified by
the topic (bundle ID) specified in the certificate, presumably the
one you generate in the online dev console. Also, APNs has a certificate
revocation list; if a provider is on that list, it's connection will be
refused/closed. I think this would happen if you didn't implement a
persistent connection to APNs but rather treated it like HTTP and kept
closing/opening the connection.

### Token Generation and Dispersal / token trust

Jesus christ why don't I just RTFM? It solves all the problems. Ah yes,
arm-chair ADD. 

- Application asks system to register
- System (iOS) forwards this to APNs
- APNs generates device token using info in the certficate (presumably
  the one established as described above) and encrypts it, and sends
  back the encrypted token
- App gets the encrypted key as an `NSData`, and must send it to the
  provider in hexidecimal format

This guarantees that only APNs generated the token used for routing
(since it's encrypted by some private key within APNs). This token can
only be used for the device that originally connected to receive
notifications.

### Trust components

e.g. keys/certificates you need to create/provide to APNs for all of
this shit to work:

- Provider
  - unique provider certificate and private key for validating
    connection to APNs
  - certificate identifies a topic that the provide can publish to (the
    app's bundle id). 
  - Provider provides device token.
  - Provider can additionally validate that it's talking to APNs using
    the public server certificate provide... at connection time?

- Device
  - obvious stuff already covered

Note: "topic" today is literally the bundle ID of the app. A certificate
identifies which apps it's allowed to broadcast notifications to via
this topic. Maybe in the future, topics can refer to multiple apps?
Right now it's coupled to bundle ID, in the future, this could be a
configurable thing... multiple apps could subscribe to the same topic?
This is all bullshit atm but what I think based on their terminology.
It's really just a really constrained pub-sub, where apps can't
subscribe to message channels other than the one that uniquely
identifies their app+device tuple. 

### Coalescing 

APNs is last-write wins in that that in the case of multiple
notifications, only the last one will be stored-forwarded to the app.
This isn't to say they coalesce within your device (validated by the
fact that you'll see multiple messages from IRCCloud rather than a
single one saying "new messages available"), but specifically refers to
the storage of messages undeliverable because the client app's turned
off. GCM gives you more fine-grained control over this.

### Summary

So, given that I've been fighting this bullshit, realizations:

I need to stop revoking/re-creating the APNs app certificate generated
in the Apple Dev console. It's not like it's tied to some private/public
key or anything.

## Difference b/w .pem and .cer, etc

I had to run this to convert .cer to .pem

    openssl x509 -in aps_development.cer -inform DER -out aps_development.pem

### X.509

    http://en.wikipedia.org/wiki/X.509

X.509 is an ITU-T (Telecommunication Standardization Sector)
standard that describes certificate generation, revocation, and other
utilities. `openssl` just happens to support x509 certificate
generation. 

Remember: x509 means one thing: certificates. If you see x509 in the
wild, it's probably talking about certificates. x509 certificates.
Certificates.

x509 is unlike PGP in that it maintains a hierarchical chain of
certificate signers, each validated by the previous, with a root CA
(Certificate Authority) starting the chain. PGP relies (or at least
originally relied on) a Web of Trust.

### PEM

`---BEGIN CERTIFICATE---` and `---END CERTIFICATE---`.

Can contain multiple certificate and even the prviate key. "The private
key"? Which private key? Answer: the one that's automatically generated
by Keychain Access and similar utilities when you create a Certificate
Signing Request (CSR). 

[See here](http://stackoverflow.com/a/7947362/914123)

TODO: can you even use an existing public/private key? Probably, but
possibly less secure:

[Read the wiki, you dingus](http://en.wikipedia.org/wiki/Certificate_signing_request)

## PKCS

(public key cryptography standards) created by RSA Security in the 90s.
It's a family of standards relating to cryptography.

PCKS 1 is a standard, PCKS 9 is a standard, PCKS 12 is a standard.

Exporting multiple cryptography shits in a single file falls under the
PKCS 12 standard. PKCS 12 also handles bundling all the members of a
CHAIN OF TRUST. 

> It is commonly used to bundle a private key with its X.509 certificate or to bundle all the members of a chain of trust.

Makes sense, must be a common thing. Apple obviously does that. AWS SNS
expects you to upload a `.p12` that it splits into a cert and priv key.

File name extension is `.p12` (which I've seen) or `.pfx` which I've
not.

[Wiki](http://en.wikipedia.org/wiki/PKCS_12)

So if I understand correctly, the purpose of certificate is so that you
can encrypt data, and anyone who wants to validate that you are who you
say you are can look up the certificate chain.

You create a pub/priv key pair, create a CSR with it, and then the
approving authority gives you a certificate that you can hand to other
people. The certificate can be used to validate that whatever you
encrypted with your (still unshared and totally) private key, can be
guaranteed to have originated from you. Without certification, you're
just some entity with a pub/priv key pair... and... I don't know, need
to read up more on the implications of this. Amazing how hard this stuff
is.

Anyway, `pkcs12` is the `openssl` file utility for creating/parsing
pkcs12 file. 

## `man` page sections

Valid:

    man crontab
    man 1 crontab # equiv to above
    man -s 1 crontab # equiv to above
    man 5 crontab 
    man -s 5 crontab # equiv to above

Invalid:

    man 2 crontab # No entry for crontab in section 2 of the manual
    man 3 crontab # ditto
    man 4 crontab # ditto

Why would it have pages 1 and 5 but not 2-4? 

[Ahhhh!](http://en.wikipedia.org/wiki/Man_page)

Turns out there are sections (that vary by platform):

    1	General commands
    2	System calls
    3	Library functions, covering in particular the C standard library
    4	Special files (usually devices, those found in /dev) and drivers
    5	File formats and conventions
    6	Games and screensavers
    7	Miscellanea
    8	System administration commands and daemons

`crontab` has no system calls, lib fns, special files, but it does have
general commands and file formats.

`man` isn't just unix commands, but also lib, system calls, C functions,
etc.

These sections also handle cases when unrelated concepts have the same
name... there might be an `exit` C fn (there is) and an `exit` terminal
command.

This explains the wording here:

    No entry for printf in section 4 of the manual

You don't look up the `printf` page, and then its section 4
subsection... rather, you look up entries in a section of `man`.

That's the same reason it's `man 3 printf` rather than `man printf 3`

God, such an obvious thing I never understood/remembered.












