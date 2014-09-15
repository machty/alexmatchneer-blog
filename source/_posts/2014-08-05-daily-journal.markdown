---
layout: post
title: "Daily Journal"
date: 2014-08-05 08:47
comments: true
categories: 
---

## ES6 fat arrow

    var a = this;
    var fn = () => {
      console.log(this === a); // true
    }

http://tc39wiki.calculist.org/es6/arrow-functions/

yuno CoffeeScript single arrow syntax?

> However, we don't want CoffeeScript's ->, it's confusing to have two arrows and dynamic this binding is an oft-fired footgun.

## SaltStack

http://docs.saltstack.com/en/latest/

## Open Core

http://en.wikipedia.org/wiki/Open_core

Open Source core functionality with paid/proprietary add-ons, e.g.
Sidekiq, or MySQL

Related:

- [Crippleware](http://en.wikipedia.org/wiki/Crippleware): free versions
  cripple the ability to save/export/whatever
- [Freemium](http://en.wikipedia.org/wiki/Freemium): free core features,
  pay for higher usage/capacity, e.g. most heroku add-ons

## Ember First Class Actions

http://emberjs.jsbin.com/ucanam/5919/edit

Questions:

- singleton vs multiples?
- actions that depend on others?
- link-to?
  - idea: a LinkView asks the router or url service for an Action
    using the route params, query params, etc.
  - LinkView's active CP is `action.pending` || present day isActive
  - action will internally delegate to a shared transitionTo action
    that everyone in the world can see; everyone can know where it's 
    going, etc etc etc.

    `{{link-to action=myAction}}`
    any reason for this? what do you gain? nothing?

We need to separate fake link font decoration style from the underlying
action.

Link's display components:

    routeDescriptor: function() {
      // when resolvedParams change, we need to recalculate
      // our route object... this should refire only when
      // params change, not when the URL changes
      this.urlService.getRouteObject('articles', 1)


      this.urlService.createRouteDescriptor({
        routeName: alias('_linkView.params.firstObject'),
        contexts: alias('_linkView.contexts'),
        queryParams: alias('_linkView.queryParams'),
        _linkView: this
      });
    }//.property('resolvedParams')

    createRouteDescriptor: function(_attrs) {
      var attrs = {
        router: this.router, // or maybe just `this`?
      };
      Ember.merge(attrs, _attrs);
      return RouteDescriptor.createWithMixins(attrs);
    }

    RouteDescriptor = Ember.Object.extend({
      // required
      router: null,
      routeName: null,
      contexts: null,
      queryParams: null,

      allParams: computed('routeName', 'contexts', 'queryParams', function() {
        // this is just a perfy thing; since all calculations depend
        // on all these params, we'll avoid the overhead of multiple
        // CPs depending on each of these params
        return this.getProperties(['routeName', 'contexts', 'queryParams']);
      }),

      path: computed('router.url', 'allParams', function() {
        var allParams = this.get('allParams');
        var router = this.get('router');

        // presently we only use router.url as a cue that the router
        // is at a new route
        var url = this.get('router.url');
        
        // pass crap to routerJS
      }),

      perform: function() {
        // invoke, blah blah blah, same logic as in link to.
        this.get('allParams');
      }
    });

    service.getRouteDescriptor('articles', 1)
    
    {
      action:   FCA,
      isActive: true,
      path: "/some/dynamic/thing"
    }

RouteDescriptors are objects

- inactive: !routeObject.active
- active:   routeObject.active
- visited

Weird thing: ember link-to's concept of "active" doesn't match with
`<a>` tag's concept of active; link-to 'active' means you're currently
in the route specified by that link; `<a>` tag's active means you're
currently clicking this link. 
    
I think I know how to refactor link-to and LinkView and all that

Goals

- make linking/routing/active calc logic shareable
- make it possible to click a link to make it active before a slow
  transition has completed.
- support calculating activeness for bootstrap wrapper `<li>`s and
  anything else in general too.

    {{#link-wrapper tagName="li" |w|}}
      {{w.link-to "wat" 1 2 3 (query-params)}}
    {{/link-wrapper}}

    {{#link-to 'articles' article.id |l|}}
      {{! providing block params kicks it into
          wrapper mode }}

      <li class="{{l.active}}">
        {{#l.tag}}
          {{article.title}}
        {{/l.tag}}
      </li>
    {{/link-to}}


## RFCs

Rust tempered it's freewheeling feature additions by requiring RFCs.

https://github.com/rust-lang/rfcs/blob/master/active/0001-rfc-process.md
https://github.com/rust-lang/rfcs/blob/master/active/0039-lifetime-elision.md

Sounds like we'll be doing this for Ember.

## Elide

> omit (a sound or syllable) when speaking: (as adj. elided) : the indication of elided consonants or vowels.

## Variadic

http://en.wikipedia.org/wiki/Variadic_function

A function that is variadic has an indefinite number of arguments.
`.bind` 


> 8:50 PM <spion> bind is variadic and I think it also has to do some stuff with constructors
> 8:51 PM <spion> (additional arguments can be used for partial application)
> 8:52 PM <spion> the constructor stuff: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind#Bound_functions_used_as_constructors
> 8:53 PM <spion> (creates significant additional overhead)
> 8:53 PM <spion> so a simple non-variadic closure implementation of bind has a lot less work to do :P


## React forms

https://github.com/wingspan/wingspan-forms

Powerded by KendoUI

## Reflux

https://github.com/spoike/refluxjs

```
╔═════════╗       ╔════════╗       ╔═════════════════╗
║ Actions ║──────>║ Stores ║──────>║ View Components ║
╚═════════╝       ╚════════╝       ╚═════════════════╝
     ^                                      │
     └──────────────────────────────────────┘
```

Rationale: http://spoike.ghost.io/deconstructing-reactjss-flux/

## Promixo dedicated

https://addons.heroku.com/proximo#dedicated

## CIDR: Classless Inter-Domain Routing

http://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing

Classful allocation of IP addresses (pre 1993) defined class A, B, C
network groups split along the 8 bit chunks. Problem is the smallest
allocation (256 addresses, assuming you were allocated something like
123.456.789.XXX) was often too small for companies, whereas the next
step up from that (123.456.XXX.XXX) was generally too huge (65536) for
companies/entities to efficiently take advantage of. SOLUTION: CIDR
blocks and subnet masks.

> This led to inefficiencies in address use as well as routing because the large number of allocated small (class-C) networks with individual route announcements, being geographically dispersed with little opportunity for route aggregation, created heavy demand on routing equipment.

In other words, class C allocations are 123.456.789.XXX allocations,
each containing 256 addresses, with no requirement that they be
geographically grouped, such that routers had to maintain large tables
for very similar looking addresses rather than being able to rely on
some grouping rules to minimize the routing information they had to know
about. But now subnet masking is a thing and blah blah blah I'm done
learning this shit.

192.168.2.0/24 means that the network is identified by the first 24 bits 

> 192.168.100.0/24 represents the given IPv4 address and its associated routing prefix 192.168.100.0, or equivalently, its subnet mask 255.255.255.0 (i.e. 24 "1" bits).

> the IPv4 block 192.168.100.0/22 represents the 1024 IPv4 addresses from 192.168.100.0 to 192.168.103.255.

## TokenEx client-side encryption

Original misconception:

- You post directly to TokenEx via AJAX, and they give you an encrypted
  value that you can pass to your server and exchange for a token

Correction:

- You only use JSEncrypt to encrypt the PAN via a public key.

Wait, I don't understand, with tokenizing, if you have a token saved in
the database, then your server, if compromised, could still send data
through to TokenEx, which would proxy it through to whomever.

## Form Factor

https://www.pcisecuritystandards.org/documents/Mobile_Payment_Security_Guidelines_Merchants_v1.pdf

> The PCI Security Standards Council charter provides a forum for collaboration across the payment space 
> to develop security standards and guidance for the protection of payment card data wherever it may be 
> stored, processed, or transmitted—regardless of the _form factor_ or channel used for payment. 

the physical size and shape of a piece of computer hardware.

http://en.wikipedia.org/wiki/Mobile_phone_form_factor

or phone. 

what a stupid fucking phrase/word/definition.






