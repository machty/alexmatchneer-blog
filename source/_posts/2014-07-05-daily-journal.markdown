---
layout: post
title: "Daily Journal"
date: 2014-07-05 16:44
comments: true
categories: 
flashcards: 
 - front: "Capacity equation (bandwidth and signal-noise ratio)"
   back: "C (bits per sec) = BW (Hz) * log2(1 + S/N (watts))"
 - front: "Total capacity (bits per sec) of wireless transitions is proportional to..."
   back: "Bandwidth (Hz)"
---

## Bandwidth

Grigorik's book confused me when he switched from the bits/second
definition of bandwidth to the more signal processing definition. 

    http://en.wikipedia.org/wiki/Bandwidth_(computing)
    vs
    http://en.wikipedia.org/wiki/Bandwidth_(signal_processing)

Computing bandwidth refers to bits/s. Signal bandwidth is the difference
in the max and min Hz that you transmit on. 

This is interesting:

> A key characteristic of bandwidth is that any band of a given width can
> carry the same amount of information, regardless of where that band is
> located in the frequency spectrum. For example, a 3 kHz band
> can carry a telephone conversation whether that band is at baseband
> (as in a POTS telephone line) or modulated to some higher frequency.

My understanding of this is that regardless of the modulation alphabet
you use, modulation will always cause a signal to vary between a
minimumm and maximum frequency, which determines the bandwidth of a
signal. For example, transmitting a "01" might mean squeezing the waves
together tightly until the next "letter" to transmit, and the tightest
those waves are squeezed determines the maximum frequency, while "10"
might might loosening the waves, and other letters could be some
combination of the two, but the key thing here is that bandwidth
determines the min and max frequencies that those waves can compress
or expand to; any more and you might be interfering with someone else's
band.

And as to the ability to transmit the same amount of information, I
don't understand that; I'll have to read up on that a bit more. 


