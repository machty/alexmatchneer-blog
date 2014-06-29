---
layout: post
title: "Daily Journal"
date: 2014-06-03 11:57
comments: true
categories: 
---

### `<base>` tag

From [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/base):

> The HTML Base Element (`<base>`) specifies the base URL to use for 
> all relative URLs contained within a document. There is maximum
> one `<base>` element in a document.

You can also specify the target for all links in the base tag. Crazy?

http://jsbin.com/tedik/1/edit

Note that it also supports values like "../", which is how I got my
ember-cli tests.html to work when I got rid of the base url config.

### bootleg

> (esp. of liquor, computer software, or recordings) made, 
> distributed, or sold illegally: bootleg cassettes | bootleg whiskey.

### Ember proto CPs

You can get the proto of an Ember class via `Klass.proto()` and
you can even invoke its CPs, but where are they cached? Answer: on the
meta of the prototype, and invoking the CP on an instance of that class
will not reuse that cache but rather use its own instance cache.

http://emberjs.jsbin.com/ucanam/5351/edit

Later realization: _obviously_ it had to work this way. What, would all
instances just magically share the proto cached CP value? That's
idiotic.

### CrossWalk

Like Cordova but you get your own browser runtime, so no platform
browser discrepancies.

https://crosswalk-project.org/#documentation/about


