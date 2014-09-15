---
layout: post
title: "Daily Journal"
date: 2014-08-15 12:17[<32;77;0M
comments: true
categories: 
---

## Incremental GC

Tenderlove tweeted this: https://bugs.ruby-lang.org/issues/10137



- Generational GC already is implemented: distinguish/bucket old and new
  generation objects; sweeping new generation objects is fast (minor GC), and the
  ones that don't get swept up get promoted to old generation, which is
  less frequently swept (in a major GC)
- Generation GC is always incremental in that it doesn't collect ALL
  unreachables, ... todo http://stackoverflow.com/questions/5092134/whats-the-difference-between-generational-and-incremental-garbage-collection

