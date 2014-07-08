---
layout: post
title: "Daily Journal"
date: 2014-06-29 19:29
comments: true
categories: 
flashcards:
  - front: "Where do file descriptors live for subprocess file-y operator"
    back: "/tmp/fd"
  - front: "Run a command, capture its output in a file descriptor"
    back: "<(echo wat)"
  - front: "What happens if i just this command: `<(echo 'wat')`"
    back: "Permission denied, because <(echo 'wat') evaluates to a tmp/fd/3 path and is interpreted as attempted to execute a file, but it doesn't have these permissions"
  - front: "`ps`, but with hierarchy"
    back: "`pstree`"
  - front: ""
    back: ""
  - front: ""
    back: ""
  - front: ""
    back: ""

---

## DAS thangs

Ctrl-Z suspends a task, but you can resume a task via `%1` or `%2`, etc,
referencing the number next to the job as displayed in `jobs`:

    [1]- suspended bleh
    [2]+ suspended lol
    [3]  suspended lol

You can also do `%-` and `%+`. 

### Inline loops

    while true; do echo "wat"; sleep 1; done

ctrl-z to suspend, `bg` to convert a suspended job to a background job.

Open the output of a command in `vim`: `echo woot | view -`

- `view` is a `vim -R` alias that opens in read-only mode
- `-` option reads the file from stdin

The man page for `vim` / `view` mentions that commands are read from
stderror. So how would we run a command that reads input from stdin and
commands from stderr? TODO: this.

    machty.github.com :: <(echo "wat")
    -bash: /dev/fd/63: Permission denied
    machty.github.com :: echo <(echo "wat")
    /dev/fd/63

`<()` will run a command and put its output in a file descriptor which
is file-like enough to work as an input to most commands. Gary's example
is the "diff of diffs", which is mostly useful to see if two branches
(e.g. one rebased and the other not) have the same content.

    diff -u <(git diff master~5..master~1) <(git diff master~4..master)

Can diff google com and fr, e.g. 

    diff <(curl www.google.com | tidy) <(curl www.google.fr | tidy) | view -

This is stupidly cool. Another use case is diffing localhost w deployed
site.

## subterfuge

I thought this word was a synonym for "plasma", as in the liquid-y
filler part of blood that's revealed when you spin blood in a
centrifuge. I think the centrifuge's involvement in that tripped me up.

http://www.merriam-webster.com/dictionary/subterfuge

It actually just means

- deceit used in order to achieve one's goal

## Cordova My Mac 64-bit

This was the only thing showing up after I changed the project name in
config.xml away from what I'd had it as when I first generated the iOS
platform. Remember this crap; I'm sure I'll have to fight it again.



