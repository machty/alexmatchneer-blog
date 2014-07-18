---
layout: post
title: "Daily Journal"
date: 2014-07-16 00:40
comments: true
categories: 
---

## WeakMap

Use objects as keys. If you lose access to a key, it and its value will
eventually be removed by GC because references to keys are weak. This
also means WeakMaps are non enumerable since GC is non-deterministic and
a key that might exist pre GC might not exist after.

## ES6 Symbols

They're nothing like Ruby symbols.

They're used to create unique, non-enumerable, keys that can't be
determined publicly unless the symbol is exported. So you could prevent
tampering with a player's score by storing the score on the player using
an unshared symbol as the key:

http://tc39wiki.calculist.org/es6/symbols/

## ES6 === Harmony === ES.next

They're all the same thing.

## JS 1.7 vs ES6, etc

[jeresig clears this up a bit](http://ejohn.org/blog/versions-of-javascript/)

All modern browsers support ECMAScript; JavaScript is a variant of it
that Mozilla's largely been adding features to. ES3 === JS 1.5.

So I see `let` was added to JavaScript 1.7, so why is it now being
described as a new upcoming feature of ES6? Ah, because all browsers
track ECMAScript standards, even if they call their enhanced language in
the browser something else. Mozilla has been blazing ahead and trying
new shit, but other browsers won't pick it up until it's actually
standardized into ECMAScript.

Why would Microsoft follow ECMAScript? Well, for starters, it delivered
JScript to Ecma back in the day for standardization.

> The name "ECMAScript" was a compromise between the organizations involved in standardizing the language, especially Netscape and Microsoft, whose disputes dominated the early standards sessions.

Interesting, and:

> While both JavaScript and JScript aim to be compatible with ECMAScript, they also provide additional features not described in the ECMA specifications

Also, some reason I thought TC39 was part of Mozilla. I see that I am
obviously incorrect: http://www.ecma-international.org/memento/TC39.htm

It's Ecma-TC39. The things I don't know.

W3C Tag, Ecma-TC39. W3C Tag, Ecma-TC39.

## `let`

`let` behaves like C++ declarations; the obj is only available in the
curlies, or in for loops, or whatever, and there's no hoisting. Outside
of the block, the variable is undefined.

## Cloudfront TTL

TTL lets you specify a min time before CF checks the origin to see if it
has a new version of the file/response. You still need your origin
server's Cache-Control headers setup correctly. 

[TTL can be 0](http://stackoverflow.com/questions/10621099/what-is-a-ttl-0-in-cloudfront-useful-for).
Why? TTL 0 means that it delegates Cache-Control entirely to the origin.
This means CF will always make a GET request w `If-Modified-Since`
header to let the server return `304 Not Modified`. 

## Drag and Drop

Draggable elements need to be marked as `draggable="true"`.

Then listen to the `ondragstart` event, e.g.
`ondragstart="drag(event)"`.

And then say what data is associated with the dragged el...

    ev.dataTransfer.setData("Text", ev.target.id);

This seems strange.

https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer

It really is a class associated only w drag and drop.

Should probably be reading this rather than fucking w3schools. Why do I
still do that?
https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Drag_and_drop

Ah I get it, you use dataTransfer as part of the mechanism for
dynamically determining drop targets. You have to prevent bubbling
(return false or preventDefault) on droppable targets, and in that fn
they have the option of looking up the data transfer to see if they want
to accept the data from that drag drop.

You can also configure drag drag visual details to indicate copying,
moving, etc. LOL such drag and drop. 

Oof apparently it's a fucking disaster: http://www.quirksmode.org/blog/archives/2009/09/the_html5_drag.html

Criticisms:

- 7 fucking events, such API surface
- "For the drop event to fire at all, you have to cancel the defaults of both the dragover and the dragenter event."

## Cordova events: sticky != buffered

Sticky events (e.g. deviceready) just mean that once fired, they stay in
a fired state. This means you can't have multiple events fire if it's a
sticky event. I was originally thinking sticky meant all the events were
cached until the first handler was registered.

Ended up making this: https://gist.github.com/machty/e1cc485060f2951aeb6c

## Why `-print0` in `find`? 

Often you pipe the results of `find` into `xargs` to pass the results of
a `find` so that some utility can operate on each file found. GOOD
ENGRISH, MATCHNEER.

But since `xargs` splits based on whitespace by default, this will break
for files with newlines or or spaces in them, so `-print0` separates
files w null bytes, and `-0` tells xargs to split via null bytes as
well. Win win win. No difference if you have no files with spaces in
them.






