---
layout: post
title: "Daily Journal"
date: 2014-05-24 07:56
comments: true
categories: 
flashcards:
  - front: "Variable Timing"
    back: "Messaging, as opposed to synchronous communication (e.g. RPC/RPI), doesn't peg the sender's performance time on the receiver's performance time, e.g. a sender isn't just as fast as the receiver"
  - front: "Throttling"
    back: "RPC/RPI can overload a receiver if too many come in at the same time; messaging involves queues == throttling"
  - front: "Reliable Communication"
    back: "Storing the message means retrying, handling failures. "
  - front: "Disconnected Operation"
    back: "Offline apps can use messaging to queue data to sync when reconnected"
  - front: "Mediation"
    back: "Mediator pattern from GoF; if an app gets disconnected from others, it only needs to reconnect to the single messaging system"
  - front: "Thread Management"
    back: "Because async, threads no longer blocked on a response (unless they want / need to be)"
  - front: "CORBA"
    back: "Common Object Request Broker Architecture: a platform-neutral RPC spec"
  - front: "n-tier"
    back: "(multi-tier): client-server architecture in which presentation, application processing, and data management are physically separated; 3-tier is most common; some similarities w MVC? Also, n-tier is distribution, not integration."
  - front: "git predecessor"
    back: "BitKeeper, no longer free of charge in 2005."
  - front: "git checksum"
    back: "SHA-1 hash"
  - front: "`git add` will store things in..."
    back: ".git/objects"
  - front: "3 locations for git config"
    back: "/etc/gitconfig, ~/.gitconfig, .git/config"
  - front: "git bakes this into your commits"
    back: "user.name and user.email"
  - front: "git config a.b.c lol"
    back: "puts [a \"b\"]\n  c = lol  in .git/config"
  - front: "what config is totally necessary to use git?"
    back: "user.name and user.email"
  - front: "git globs files"
    back: "so you can do git add log/\\*.log"
  - front: "git log with diff"
    back: "git log -p (the p stands for patch)"
  - front: "git log limit to 2"
    back: "git log -2"
  - front: "difference b/w git author and committer"
    back: "author wrote the code, committer merged or applied to repo"
  - front: "can only push to this kind of git url"
    back: "SSH URL, e.g. git@github.com:machty/ember.js"
  - front: "command to display lots of live info about a remote"
    back: "git remote show origin"
  - front: "difference between lightweight and annotated tags"
    back: "lightweight just points to a commit; annotated are full git objects, checksummed, contain tagger name, message, can be GPG (GNU Privacy Guard) signed"
  - front: "how to annotate tag"
    back: "git tag -a v1.4 -m lol"
  - front: "command to inspect a tag for more info"
    back: "git show tagname"
  - front: "GPG signed tag"
    back: "git tag -s v3.0 -m haha"
  - front: "tag previous commit"
    back: "git tag v.retro shortsha"
  - front: "How many chars is a short sha?"
    back: "any number of chars so long as it can be matched to a longer one"
  - front: "how to push a single tag?"
    back: "git push tagname"
  - front: "how to add git auto complete"
    back: "you need bash, source gitrepo/contrib/completion/completion-something.bash"
  - front: "shorthand for declaring a git alias"
    back: "git config --global alias.something 'reset --HEAD'"
  - front: "what's in a git commit?"
    back: "pointer to snapshot, author, message, 0+ pointer to parent commits"
  - front: "HEAD"
    back: "pointer to the branch you're currently on"
  - front: "When can you fast forward?"
    back: "When the current branch head is an ancestor of the named commit. You're literally just moving a pointer."
  - front: "Upstream"
    back: "The originator of the data, which flowed to you at some point, e.g. when you cloned a repo, or you created a branch."
  - front: "What are the 3 components of a 3-way-merge?"
    back: "Common ancestor, current HEAD, and to-be-merged branch."
  - front: "What's unique about a merge commit?"
    back: "It has more than one parent."
  - front: "show all branches and last commit for each"
    back: "git branch -v"
  - front: "Show merged / unmerged branches"
    back: "git branch --merged ; git branch --no-merged"
  - front: "git push origin master expand to..."
    back: "git push origin refs/heads/master:refs/heads/master"
  - front: "command to create a new branch starting off of another one"
    back: "git checkout -b newbranch existingbranch"
  - front: "`git branch -d branch to delete` will yell at you under this circumstance"
    back: "it's not merged into the current branch"
  - front: "what happens if you do `git checkout origin/some-remote-branch`?"
    back: "Detached head state. To create a tracking branch, do `git checkout localbranch origin/some-remote-branch`"
  - front: "tracking branch"
    back: "a local branch that have a direct relationship to a remote branch; `git push` and `git pull` will go to the tracking branch"
  - front: "another way to write `git checkout foo origin/foo`"
    back: "`git checkout --track origin/foo`; creates local foo tracking origin/foo"
  - front: "Delete remote branch foo"
    back: "git push origin :foo; remember: `git push origin [localbranch]:[remotebranch]`"
  - front: "dog-ear"
    back: "bend a page to make it easily findable later"
  - front: "The rule for when _not_ to rebase"
    back: "Don't rebase commits that you've pushed to a public repo"
  - front: "difference b/w `git clone /path/to/repo` and `git clone file:///path/to/repo`"
    back: "`file:///` uses the remote file transfer stuff that it would use for anything remote, whereas direct path directly copies and uses hard links and what not; `file:///` gives you a more pristine copy, less junk"
  - front: "limitation of SSH repo access"
    back: "no anonymous access, possibly bad for open source"
  - front: "git protocol"
    back: "daemon packaged w git but w no authentication; no pushing (in general, since it opens to the door to anyone)"
  - front: "Speed of git protocol relative to SSH"
    back: "way faster since no authentication and encryption overhead"
  - front: "solution to SSH non-anonymity and git non-auth"
    back: "configure server to use both; git protocol for cloner/pullerss, ssh for repo write access homies"
  - front: "git command to init a bare repo in folder foo"
    back: "`git init --bare foo`"
  - front: "after creating a bare repo and running http server, git clone fails. Why? How to fix?"
    back: "HTTP hosting implies you have static files to serve, but these don't magically exist by default. They can be generated via the post-update.sample hook, which runs `git update-server-info`.  You can either manually run this or enable the hook and push to it once (not via HTTP)"
  - front: "start a ruby server hosting files in this directory"
    back: "`ruby -run -e httpd . -p 5001`"
---

### Enterprise Integration Patterns

Reading this here Fowler book.

Operating systems have begun to ship with messaging middleware and
related tools:

- Windows: MS Message Queueing (MSMQ), accessible via APIS like COM
  components and System.Messaging (part of .NET). 

Application Servers

- Java Messaging Service (JMS)

EAI (Enterprise Application Integration) suites:

- IBM WebSphere MQ
- Microsoft BizTalk
- TIBCO
- WebMethods
- SeeBeyond
- Vitria
- CrossWorlds

Many of the above include JMS as a supported client API, while
others focus on implementing merely JMS-compliant infrastructures.

### Pro Git

#### VCS: Version Control System

Keeps patch sets between versions of files, reconstruct a version be
applying/unapplying patches. Example: `rcs`.

Git's predecessor was BitKeeper, whose free-of-charge status was
revoked in 2005.

#### git config

`git config lol.wat "imadork"`

will put the following into `./.git/config`:

    [lol]
      wat = imadork

what if you did `git config a.b.c lol` ?

    [a "b"]
      c = lol

followed by `git config a.b.z lol`:

    [a "b"]
      c = lol
      z = lol

So basically `git config` just prettily formats things into groups using
everything about the key you provide except the trailing segment. Makes
sense.

#### Staging

Staging means you're building up snapshots for a commit. By the time you
commit, you're just creating a commit object with meta data that points
to that same snapshot.

#### Simple git repo hosting via HTTP

You can host a git repo via HTTP file hosting, which implies:

- anonymity (no authentication, no way to know who's cloning your repo)
- read-only access (can't push, unless doing crazy WebDAV things)

So just for fun, here's the simplest number of steps to push to a
localhost http git server.

1. Create bare repo: `git init --bare fun.git`. This creates a folder
   called `/fun.git`. The `.git` extension is optional, but
   conventional.
2. Start a server hosting `ruby -run -e httpd . -p 5000`
3. Try and clone via http: `git clone http://localhost:5000/fun.git`

This will give you an error:

    fatal: repository 'http://localhost:5000/fun.git/' not found

and your Ruby server will show the log

    [2014-05-25 12:03:13] ERROR `/fun.git/info/refs' not found.
    localhost - - [25/May/2014:12:03:13 EDT] "GET /fun.git/info/refs?service=git-upload-pack HTTP/1.1" 404 287
    - -> /fun.git/info/refs?service=git-upload-pack

So it's looking for files that aren't there. If you look at various 
git manuals, it'll tell you something about how you should 
`mv hooks/post-update.example hooks/post-update` and give it executable
chmod permissions, but even if you do that and try and clone again,
it'll fail.

The reason for the failure is that there are static files that need to
be generated in order for a plain ol static http git hosting solution to
work, and these files haven't been generated yet. If you enabled the
`post-update` hook and then pushed to the repo via some other means,
those files would be generated, but just to get this example working,
you can `cd` into `fun.git` and run

    sh fun.git/hooks/post-update.example

or you can just run the single command that the above script runs:

    git update-server-info

Then when you `git clone http://localhost:5000/fun.git`, the clone will
succeed (though the repo's still totally empty).

### `ruby -run`

Also, here's the breakdown of the `ruby -run -e httpd . -p 5001`

- There's a very intentionally-named Ruby library called `un`, which
  [contains some useful tools](http://ruby-doc.org/stdlib-2.0.0/libdoc/un/rdoc/index.html)
- The `-r` option requires the following lib; `-run` requires `un.rb`,
  which is part of the Ruby standard library.
- `un.rb` contains top-level method definitions, like `httpd`
- `-e httpd` executes the top-level `httpd` method in `un.rb`, which
  makes use of the rest of the command line args provided: `. -p 5001`,
  and starts up a WEBBrick server.

Here's another dumb example of a `ruby -r`:

Put a file named `aunchy.rb` with the following contents into new
subdirectory `ma`:

    def lephant
      puts "i am so raunchy"
    end

Then run `ruby -Ima -raunchy -elephant`:

    i am so raunchy

This works because

- `-Ima` adds `ma` to the load path (which `require` uses)
- `-raunchy` requires `aunchy.rb`
- `-e` executes the method `lephant`

