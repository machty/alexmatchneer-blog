---
layout: post
title: "Daily Journal"
date: 2014-07-18 03:50
comments: true
categories: 
---

## Cookies

What ends up in `document.cookie`? 

Test: kill a previous localhost:5000 server, start a server for a
separate project. Reload the page. Request headers sent include
a transient cookie from the previous server. I bet it was due to
Turbolinks. I was right!

From http://tools.ietf.org/html/rfc6265#section-4.1.1

>  Origin servers MAY send a Set-Cookie response header with any
>  response.  User agents MAY ignore Set-Cookie headers contained in
>  responses with 100-level status codes but MUST process Set-Cookie
>  headers contained in other responses (including responses with 400-
>  and 500-level status codes).  An origin server can include multiple
>  Set-Cookie header fields in a single response.  The presence of a
>  Cookie or a Set-Cookie header field does not preclude HTTP caches
>  from storing and reusing a response.

So you can send multiple headers with the same key. Makes sense, since
comma separation will conflict with the UTC date (e.g. `Aug 12, 2014`).

So how do you set multiple cookies in Rack?

Interesting: https://github.com/rack/rack/blob/master/lib/rack/utils.rb#L266

Anyway, split cookies with newlines and Rack will cause this to send two
`Set-Cookie` headers, which is totally fine. 

You can also use `set_cookie` on `Rack::Response` if you're into that
sort of thing..

I psyched myself out thinking cookies were overwriting each other by doing:

    "Set-Cookie" => "foo\nbar\nbaz"

`document.cookie` was only revealing `baz`. But, I'm a dumb: cookies
need to be key-value pairs, which fixed it.

You can use `HttpOnly` to prevent JS (and other APIs?) access to the
cookie sent by the server. Makes sense; less likely that'll break
something. 

Getting `document.cookie` returns all the cookies available to JS.
Setting it will only set the cookie you provide.

> Notice that servers can delete cookies by sending the user agent a
> new cookie with an Expires attribute with a value in the past.

## JavaScript set focus

`focus()` is a method on input elements. So is `blur()`.

`document.activeElement` in modern browsers points to the focused
element, which might also include scroll windows. 

https://developer.mozilla.org/en-US/docs/Web/API/document.activeElement

In older browsers, to `blur` the active element, you'd have to know what
that element was; there was no way to query. Might be wrong about this.

## React Nested Router

http://www.youtube.com/watch?v=P6xTa3RRzfA

- State is just data
- Your route is data, e.g. you could render a top-level App component
  and tell it what its route is, and render everything a la React,
  pretend like you're redrawing the whole page.
- Rather than switch-statement-based routing, the `activeRoute` just
  gets passed in via `props` like any other property
  - `router.match` handlers will create all the routes, and pass in a
    single `activeRoute`; every route segment along the way just knows
    about with its activeRoute child is, if one exists.
  - e.g. `contact/profile`, app.activeRoute = contact,
    contact.activeRoute = profile
- API
  - Route component
    - handler = a React Class
- Differences w Ember
  - No auto-gen 'index' routes
  - paths don't inherit parent paths
    - this means if you're "overwriting" a parent dynamic segment, the
      dynamic segment must appear _somewhere_ in the child route so you
      can actually load that data.
      - AH, the router will detect when children omit ids that their
        parents have declared. That's nice.
      - also yells at you if you use the same path in two places.
    - nice that it lets you have `/profile` vs `/user`
  - Ember is less typing, but
    - React makes it easier to share handlers
    - Overwriting URL is nice when you need it, error checking is nice
- So each non leaf handler gets `activeRoute`, all handlers get all 
  `params`. 
- Refactorability/decoupling:
  - Because route names and paths are fully specified and all params are provided to
    each handler, changing the nesting of a route means you don't have
    to rewrite all your link-tos from "wat.foo" to "foo". Then again
    if you're using resources you don't have to do that either.
- Question: what about other `props` you'd want to pass into a
  component?
  - Answer: Route components aren't concerned with props other than how
    to be a route handler. 

http://jsbin.com/vukacule/6/edit

It is really cool that you can switch between rendering a route with App
as a handler vs just rendering App. The difference is that, when
route-driven, it gets passed props. 

The `Route` components you use are obviously stateless; all state lives
on the Handlers. 

Ah, in React `{{blah: "wat"}}` syntax just means `{blah: "wat"}` inside
the normal single-curly.

How do Links work? They call transitionTo and there's a single URLStore
singleton. 

## TLS Replay?

I had it in my head that man-in-the-middle wasn't a problem for TLS but
maybe they could replay the messages? Turns out I am wrong; TLS includes
a sequence mechanism.

That being said, your app might send repeat messages, which demands its
own double checking / application-level sequencing or some other
prevention mechanism.

## chroot

http://en.wikipedia.org/wiki/Chroot

Learned about this when speculating w Ember Core about how the front
page Rust evaluator works at http://www.rust-lang.org/

It runs a program with the assumption that `/` is somewhere else, and it
can't access it. 

Change

## process.nextTick

`process` doesn't exist on the browser, so therefore neither does
`nextTick`, but you can hack it if you're on a browser that has a native
`Promise` object, since the [spec](http://promisesaplus.com/) mentions
that resolution callbacks must happen when the execution context
consists only of platform code.

> onFulfilled or onRejected must not be called until the execution 
> context stack contains only platform code. [3.1].

So here's how you could write nextTick, note that there's no need to 
 
    var p = Promise.resolve();
    function nextTick(cb) {
      p.then(cb);
    }

## Visibility API

[mdn](https://developer.mozilla.org/en-US/docs/Web/Guide/User_experience/Using_the_Page_Visibility_API)

e.g. 

- pause video when you tab-away
- stop requestAnimationFrame

## Closing over `let i`

    var fns = [];
    for (var i = 0; i < 10; ++i) {
      fns.push(function() {
        console.log(i);
      });
    }

The above code has the gotcha that by the time the `fns` functions run,
they'll all print out `10`, rather than the value of `i` when the
closing-over function was created. This is part of the reason why jshint
will yell at you for creating functions in a loop, e.g.

    var fns = [];
    for (var i = 0; i < 10; ++i) {
      fns.push(makeCallback(i));
    }

    function makeCallback(num) {
      return function() {
        console.log(num);
      }
    }

Then `i` will be uniquely preserved for each callback.

The es6 `let` keyword gives you block scope, which includes everything
declared within the for loop. If you just use `let` in the original
code, you can do

    var fns = [];
    for (let i = 0; i < 10; ++i) {
      fns.push(function() {
        console.log(i);
      });
    }

`i` doesn't get hoisted; rather, each iteration gets its own `i` value
that gets closed over.








