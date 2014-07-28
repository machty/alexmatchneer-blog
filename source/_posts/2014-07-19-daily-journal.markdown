---
layout: post
title: "Daily Journal"
date: 2014-07-19 11:30
comments: true
categories: 
---

## Crank

Meth.

An eccentric person, esp. one who is obsessed by a particular subject or 
theory: when he first started to air his views, they labeled him a 
crank | [ as modifier ] : I am used to getting crank calls from 
conspiracy theorists.

## Roko's modern basilisk

It's happening.

## Transactional UIs

People build forms. Ember gives you sweet syntax sugar for 2wb. 
Not for transactional UI, anything that needs a buffer.

Old mindset: if you need 1wb, just... don't set on the other side of a
2wb. 

TODO: ask kris more about the async/sync cocoa observer binding
limitations.

- Most observers just do something and stop.
- And they mostly want to know the last thing they cared about.


Bubbling doesn't describe actions; actions go wherever. Bubbling only in
route hierarchy.

Services:

- session/user
- timer
- websocket
- analytics

Idea: components provide services to the components the render. They
have a ServiceCertificate

Goal:

- Try and associate actions with objects.
- `actions` themselves can just be passed into the `actions` 

## Non-dynamic routes




    resolveEntry: function(params, model, transition) {
      return model || this.store.find(params.id);
    }

    resolveEntry: function(params, model, transition) {
      return model || this.store.find(params.id);
    }



Initializers vs `applicationRoute#beforeModel`. 

retcon for how to use controllers 

asop to data binding

HTMLbars knows what parts of the template are dynamic vs static.

In React, if you have a conditional

## Skunkworks project

> A skunkworks project is a project developed by a small and loosely 
> structured group of people who research and develop a project 
> primarily for the sake of radical innovation.[1] The terms 
> originated with Lockheed's World War II Skunk Works project.

http://en.wikipedia.org/wiki/Skunk_Works

> The designation "skunk works", or "skunkworks", is widely used
> in business, engineering, and technical fields to describe a
> group within an organization given a high degree of autonomy
> and unhampered by bureaucracy, tasked with working on advanced
> or secret projects.

Lockheed Martin's Skunk Works project made SR-71.

## Project Svelte

http://www.trustedreviews.com/opinions/android-4-4-kitkat-s-project-svelte-what-it-is-and-why-you-should-care

> ‘dogfooding’ – that is making its employees use and live with their own projects

They dogfooded their employees by forcing them to dev on handicapped
phones. Android 4.4 was the result, apparently it was way more
performant.

## RACK_ENV vs RAILS_ENV

`Rails.env` is decided by `RAILS_ENV || RACK_ENV || "development"`. It's
common to set `RACK_ENV` which will also set `RAILS_ENV`, but if you
have any rack middleware that behaves differently in different
environments, you might screw yourself if you're using `RAILS_ENV`.

## wythoughts on blocks

The reason `|i|` is ok is for the same reason you can't do the following
in Ruby:

    a = { |it| wat }

You have to do 

    a = proc { |it| wat }

Case in point you need an fn to save a block. 

## mythoughts on mutability

Can/should we swap POJOs when an observed property changes? Is there any
value to 

    var pojo = {
      a: {
        b: 123
      }
    };
    
    var a = pojo.a;
    Ember.set(pojo, 'a.b'

## ASI: automatic semicolon insertion

Nuff said.

## old browser disagreements on ws

    [ text ws text]

cloneNode produces:

- ie8: 1 node
- ie9: 2 nodes
- else: 3 nodes

## NoScope

http://www.thecssninja.com/javascript/noscope

tldr NoScope is an old IE categorization of nodes, and NoScope dictates
that innerHTML and cloneNode will strip these els.

## Ropes: DAG of string implementation for FF/Chrome

http://citeseerx.ist.psu.edu/viewdoc/download;jsessionid=181EEF66EB411F4277C009A1D492CF75?doi=10.1.1.14.9450&rep=rep1&type=pdf

Look into this more. Too lazy to read / comment.

How to force Chrome to not use a rope:

- Less than 12 chars

What does it mean to intern strings?

## CSP: Content Security Policy

http://www.html5rocks.com/en/tutorials/security/content-security-policy/

## String interning

    String.prototype.intern = (function() {
       "use strict";
       var o = {"- ": 0};
       delete o["- "];
       return function() {
           var str = this;
           o[str] = true;
           var ret = Object.keys(o)[0];
           delete o[str];
           return ret;
           try {} finally {}
       };
    })();

## Component pinning

Associating the re-render with the pre-existing fragment.

## localStorage on iOS Cordova webviews

1. Run dev, set `localStorage.wat = "lol"`
2. Stop and re-run the app, and `localStorage.wat` still is "lol"
3. Delete the app, re-install, still dev, `localStorage.wat` is undefined

I don't even have to check... your app can't run in both dev and prod.
You can't share userSessions across dev and prod apps. Then again, our
servers could maintain keys for both APNS and APNS_SANDBOX.

## GCM project number vs project ID

https://developers.google.com/compute/docs/faq#whatisthedifference

You pick project ID, they pick project number. Project number is the
Sender ID you use for GCM.

## Pointer comparisons for such perf

    if (wat === false) {
    }
    
`false` can be implemented to just refer to a unique memory location,
such that all browsers need to comparison in the above code is `wat`'s
memory address against `false`'s. 

Same goes with

    if (wat === undefined) {
    }

just that the presence of `foo` in `cache.foo` is ambiguous without
testing `foo in cache`; might be easier to do `cache.foo = UNDEFINED`
where

    function UNDEFINED() {}

Sentinel as fuck.

## PushPlugin 

Only starts firing PNs after `register`. We need a user session to
register, right? Seems weird we can't query it for information before
immediately registering... either way, works fine for us, at least we
killed Zalgo.








