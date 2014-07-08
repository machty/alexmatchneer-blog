---
layout: post
title: "Daily Journal"
date: 2014-07-01 10:03
comments: true
categories: 
---

## window vs document events

`window` and `document` have different events. Duh.

`window`:

- resize

`document`:

- DOMContentLoaded

Breakdown of events and their originators:

https://developer.mozilla.org/en-US/docs/Web/Events

Fun fact: DOMContentLoaded is considered a DOM mutation event.

## Treat stubbed cordova as its own platform

I'm doing a Phonegap/Cordova app and it's been tricky settling on a
pattern for stubbing out the cordova library when I'm just running in
Chrome or anywhere not in the actual native cordova wrapper, and I think
I found the final solution: clone https://github.com/apache/cordova-js,
define a new platform with a fake exec, have the fake exec look up some
stubbed handlers that you can define in your app, (e.g.
`window._stubbedCordovaHandlers[blahblah]`) and basically leave it up to
your app to stub out all the native plugin services/actions. The effect
of all of this is that your index.html always loads a cordova.js (which 
has some other conveniences like stick event handlers, pub sub channels,
etc) but you don't have to have a bunch of conditionals asking whether
this is a stubbed version of the app or not.


