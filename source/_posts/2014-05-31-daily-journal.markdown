---
layout: post
title: "Daily Journal"
date: 2014-05-31 13:03
comments: true
categories: 
---

### Git relative revisions

    git checkout 08h398se~1 

### Lazy CPs stripped down examples

Observing a CP requires consuming it with a get
before its observers will fire upon change: 

http://emberjs.jsbin.com/ucanam/5200/edit

But, for some reason, future changes to that property
don't fire that observer:

http://emberjs.jsbin.com/ucanam/5203/edit

This is because firing the observer tears down the chain
nodes unless they're activated again by future gets:

http://emberjs.jsbin.com/ucanam/5204/edit


But firing the observer tears down the chain
nodes, so future fires also need to be preceded by
a get to make the observer alive again:

http://emberjs.jsbin.com/ucanam/5201/edit

http://emberjs.jsbin.com/ucanam/5198/edit



    // CRUCIAL REALIZATION!!!! THIS IS HOW OBSERVERS
    // STAY LIVE IN VIEWS; RE-RENDERED METAMORPH TEMPLATES
    // CALL .get() to get the LATEST VALUE OF THE FUCK.
    // BUT GENERALLY SPEAKING YOU JUST NEED TO CALL .GET()
    // ON THE THING TO MAKE IT ALIVE AGAIN!
    http://emberjs.jsbin.com/ucanam/5208/edit



    /*
    Ember.addObserver(pojo, 'foo', function() {
      console.log('foo observer fired');
    });
    */



    // These additional changes
    // don't fire the fooAlias
    // observer, unless we continue
    // consuming (uncomment the stuff)
    //Ember.get(pojo, 'fooAlias');
    Ember.set(pojo, 'foo', 7);
    //Ember.get(pojo, 'fooAlias');
    Ember.set(pojo, 'foo', 8);
