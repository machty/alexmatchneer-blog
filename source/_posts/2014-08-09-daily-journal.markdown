---
layout: post
title: "Daily Journal"
date: 2014-08-09 16:15
comments: true
categories: 
---


## iOS State Preservation

https://developer.apple.com/library/ios/documentation/iphone/conceptual/iphoneosprogrammingguide/StatePreservation/StatePreservation.html

## Session token storage in localStorage

Do not store session identifiers in local storage as the data is always accessible by JavaScript. Cookies can mitigate this risk using the httpOnly flag.

It's risky? SAY MORE THINGS.

## Loading Ember CLI addons in jsbin


## Forking in xargs

Holy shitters, this is how I simultaneously uploaded three tracks to s3
(using my `to_s3`) script.

    find ~/Desktop -name "Audio*" -print0 | xargs -0 -n 1 -P 5 to_s3

`-n 1` means each invocation takes a max of one arg, and `-P 5` means a
max of 5 simultaneous processes. So cool.

## Web audio api

Finish this: http://emberjs.jsbin.com/ucanam/5964/edit

## Liquid Fire Global

http://jsbin.com/mifuq/1/edit


