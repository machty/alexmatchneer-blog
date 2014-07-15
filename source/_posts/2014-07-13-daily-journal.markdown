---
layout: post
title: "Daily Journal"
date: 2014-07-13 15:18
comments: true
categories: 
---

## HTML is an API, getAttribute

HTML is just a string of characters that get converted into DOM. You can
also create DOM via the JavaScript DOM API. Seems like an obvious thing
I guess but it just clicked for me. 

What's an attribute? It's any key-value pair (or occasional boolean)
within an open tag. 

    <div id="lol" snaggletooth="blorg"></div>

`id` and `snaggletooth` are attributes. During HTML parsing, the browser
will convert this isn't an HTML element (which is a node). HTML elements
have a fixed set of _properties_. All the _attributes_ you provide in
your HTML that map to known properties will set the values of those
properties, hence `.id` gets set to "lol", but `.snaggletooth` would
yield `undefined`, because that's obviously not a real property name. 

http://jsbin.com/bejog/1/edit

This also explains why you can set an `<input>`'s value to "wat", then
type in a new value in the input field, and `getAttribute("value")` will
still yield `"wat"` even though `inputElement.value` will equal whatever
you typed in.






