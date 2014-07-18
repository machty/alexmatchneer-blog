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

