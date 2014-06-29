---
layout: post
title: "Daily Journal"
date: 2014-06-20 10:44
comments: true
categories: 
---

## Push Notifications

Apple uses APNS (Apple Push Notification Service) and Android uses 
GCM (Google Cloud Message). Compare/contrast:

Apple:
- Max payload size: 256 bytes
- When the app is inactive:
  - Read `aps` hash:
    - Display `alert`
    - Play `sound`
    - Update app's `badge` number

Android
- Max payload size: 4096 bytes
- Has no `badge` option
- Supports `collapse_key` to collapse identical messages, like "New
  Mail" messages, which only need to be responded to once, and require
  only one server fetch. 

About payload size: this includes all the JSON padding. The smallest
message is an empty message, represented by the following payload:

    {"aps":{"alert":""}}

This is 20 chars/bytes, meaning you have 236 bytes left for a message.
But push notification payloads often include a badge number, and an
alert to play. 

Source: [this lovely SO](http://stackoverflow.com/a/6308462/914123)


[From the docs](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/ApplePushService.html):

> If the target application isn’t running when the notification 
> arrives, the alert message, sound, or badge value is played or 
> shown. If the application is running, the system delivers the 
> notification to the application delegate as an NSDictionary
> object. The dictionary contains the corresponding Cocoa 
> property-list objects (plus NSNull).


## DAS: Boundaries

https://www.destroyallsoftware.com/talks/boundaries

Integration tests a scam because:
- if 50 conditionals in your app, 2^50 paths, and no way to 
- as code grows, time of each test grows (due to more setup, DB stuff,
  etc)


## `after_commit`

This is a hook available within `ActiveRecord::Base` subclasses
that let you run some code post-transaction. I was confused by this
because a lot of the examples made it seem like you could just 
run a method called `after_commit` in controller code or something,
but nay.

Controller code isn't run in a transaction; transactions are only
automatic within `.save`.


## Sidekiq serializers params via JSON.dump

This answers my question as to whether symbolized keys are preserved
when passing hash args to a Sidekiq worker: JSON.dump turns string
keys into symbols.

## Difference between `Fiber#resume` and `transfer`

Both will transfer control to the fiber you call it on; the difference
is that if that new fiber calls yield, it

    f0 
      f1.resume
        Fiber.yield

FUCK! i don't know. TODO come back to this.

Followup: transfer transfers control to another Fiber. The transfer-er
doesn't necessarily expect to get returned to, so if the transfer-ee
yields, it'll yield the value back to whoever spawned the transfer-er,
rather than return control back to the transfer-er. It's mega fucking
confusing. 

Also, you have to `require 'fiber'` to even use this shit.

## ~~2.5 in js

    ~~2.5  // 2
    ~~2    //-3
    ~~-4.2 // 4

Removes everything to the right of the decimal point, so it's like
Math.floor except Math.floor doesn't remove stuff to the right of the
decimal point for negative numbers.

## `void` operator

`void 0` or `void(0)` evaluates the expression and then returns
undefined. So I could do `void (anyNumberOfBullshits())` and it'd be
undefined. Compared to just writing undefined, it:

- works even if `undefined` (a variable) has been redefined
- is shorter than writing `undefined`

