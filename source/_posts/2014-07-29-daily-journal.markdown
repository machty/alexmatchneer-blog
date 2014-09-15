---
layout: post
title: "Daily Journal"
date: 2014-07-29 07:50
comments: true
categories: 
---

## tar

Short for Tape Archives.

Had a tar.xz file, just needed to 

    tar xf thefile.tar.xz

## Dexing

Convert string names to numbers to be referenced within compiled Java
whilst packaging android apps.

## Good Food

Prince St Cafe on Prince and Mott. 

- Awesome burger
- Awesome lamb thing

## ls -l

Was curious about an `@` sign I saw next to a .txt file, from `ls(1)`:

> The Long Format
>     If the -l option is given, the following information is displayed for
>     each file: file mode, number of links, owner name, group name, number
>     of bytes in the file, abbreviated month, day-of-month file was last
>     modified, hour file last modified, minute file last modified, and the
>     pathname.  In addition, for each directory whose contents are dis-
>     played, the total number of 512-byte blocks used by the files in the
>     directory is displayed on a line by itself, immediately before the
>     information for the files in the directory.  If the file or directory
>     has extended attributes, the permissions field printed by the -l
>     option is followed by a '@' character.  Otherwise, if the file or
>     directory has extended security information (such as an access control
>     list), the permissions field printed by the -l option is followed by a
>     '+' character.

- `@` extended attributes
- `+` extended security info

## Interrupted System Call

http://infohost.nmt.edu/~eweiss/222_book/222_book/0201433079/ch10lev1sec5.html

I'm getting some shit about foreman and interrupted system calls. So
what is it.

## "data at the edge"

Keeping secure data at the edge of your infrastructure, e.g. using
tokens instead of storing CC's in your db.

## PAN (primary account number)

Bank card number. 

http://en.wikipedia.org/wiki/Primary_account_number

## CP (card present)

e.g AuthorizeNetCP

Cheaper rates if you can prove card present (via CVV).

## TokenEx

ProcessTransaction


ProcessTransactionWithPAN

- pass in all the CC data; no

## Levenshtein Distance

The minimum number of single-element operations (add, remove,
substitute) between two sequences. Often used for spell-checking
suggestions. 

I was thinking of using it to do an array diffing for React-ish stuff.

    Array 1: B C D E F
    Array 2: A B C D E

Clearly the answer to how to get from 1 to 2 is 

    shift A
    delete E

But how to programmatically detect that? 

## Ruby String Substring Shorthand

https://speakerdeck.com/headius/jruby-the-hard-parts

I can't believe I didn't know this...

    s = "alex is quite maudlin"
    s['quite'] = 'very'
    s => "alex is very maudlin"

and if the substring isn't in there, then

    IndexError: string not matched

http://www.ruby-doc.org/core-2.1.2/String.html#method-i-5B-5D-3D

## JRuby the Hard Parts

Goal: understand this talk https://speakerdeck.com/headius/jruby-the-hard-parts

## Learn about encodings

I had to resort to this shit:

    line = line.force_encoding("iso-8859-1")

for a bigass file because I was running into

    http://stackoverflow.com/questions/15399530/ruby-match-invalid-byte-sequence-in-utf-8

Apparently you can open files as a certain encoding. Seems good.

## Auto-inline CSS with Roadie

https://github.com/Mange/roadie

Useful for supporting a vast array of shitty email clients that require
inline CSS. This wouldn't be a problem if web components.














