---
layout: post
title: "Ember Meta"
date: 2014-05-31 07:27
comments: true
categories: 
  - ember-metal
flashcards:
  - front: "META_DESC"
    back: "The ES5 descriptor for the meta property on an object; non-enumerable and non-configurable"
  - front: "EMPTY_META"
    back: "The read-only, empty meta object returned by `meta(obj, false)` when obj has no meta already"
  - front: "How do I find all the properties that have property as a dep key?"
    back: "obj.meta.deps[changingPropName]"
  - front: "What causes the forgetful consumption behavior of lazy observers?"
    back: "didChange on CP removes dependentKeys"
  - front: "If CP#didChange removes dependent keys, who adds it back in template situations?"
    back: "The view that was installed will call get() on that CP, and .get() on a cacheable property will call addDependentKeys"
  - front: "Why is it that an observer can be properly set up, but it doesn't look like it when you inspect the containing object?"
    back: "It might be declared on the prototype, which doesn't show up in Chrome by default. defineProperty on the obj itself would reveal `listeners`, but rest assured in the prototype, it exists"
  - front: "Observers aren't lazy when observing static values, but only CPs... why?"
    back: "Static values have different rules... really the lazy CP behavior kicks in when you have Observer -> CP -> Depkey and nothing has consumed to CP, hence when the depkey changes, no change event fires unless someone has consumed cp"
---

### Ember Meta

_This will start off in my typical meandering daily journal form and
hopefully evolve into something good enough for an ARCHITECTURE.md_

Ember's internals make heavy use of meta objects, which are generated
and attached to objects in order to keep track of bindings, computed
properties, observers, and all sorts of other things evolving Ember magic.

#### `EMPTY_META`

`EMPTY_META` is a default, empty meta object that represents an object
with no observers, bindings, or computed properties.

`Ember.meta` is the function that takes an object and returns its meta
object; asking Ember.meta for a read-only meta object for a POJO
will return `Ember.EMPTY_META`

    Ember.meta({}, false) === Ember.EMPTY_META // true

    http://emberjs.jsbin.com/ucanam/5173/edit

This is an optimization that lets us pretend as if every object in
Emberland had a meta object, simplifying our binding/observer algorithms
while not wastefully generating meta objects for objects that don't need
their own separate copies. It's a form of copy-on-write. 

    var pojo = {
      foo: 'wat'
    };

    console.assert(Ember.meta(pojo, false) === Ember.EMPTY_META);

    // Add a computed property, which requires writing to meta.
    Ember.defineProperty(pojo, 'fooAlias', Ember.computed.alias('foo'));

    console.assert(Ember.get(pojo, 'foo') === 'wat');

    var newMeta = Ember.meta(pojo, false)

    console.assert(newMeta !== Ember.EMPTY_META);

    // http://emberjs.jsbin.com/ucanam/5176/edit

#### `META_DESC`

This is the ES5 descriptor for the property stashed on an object that
points to its meta object:

    {
      writable: true,
      configurable: false,
      enumerable: false,
      value: null
    };

This makes the property non-enumerable, which is why the meta object
won't show up when iterating over an object with `for..in`.

#### Meta obj structure

`EMPTY_META` is just `new Meta(null)`, and here's the meta structure:

    Meta.prototype = {
      // Set to {} by constructor

        // dictionary of all Ember.Descriptor properties
        // defined on for the obj, e.g computed properties
        descs: null,    

        // dictionary of properties on the object that are
        // being observed, where the key is the observed
        // property name and the value is the number of
        // active observers of this property.
        // e.g. meta.watching.foo === 2 means that two
        // observers are watching obj.foo for changes.
        watching: null,

        // TODO
        cache: null,

        // TODO
        cacheMeta: null,

        // The owner of this meta object; important to keep track
        // of because when prototypal inheritance is involved, a
        // child object will initially point to the same meta obj
        // as its prototype, even though they should have separate
        // meta obj. `Ember.meta()` detects this by checking to see
        // if meta.source equals the passed in object, and if not,
        // it generates a new meta object
        source: null,

      // Left as null by constructor
      deps: null,
      listeners: null,
      mixins: null,
      bindings: null,
      chains: null,
      chainWatchers: null,
      values: null,

      // The prototype of source
      //   meta.proto.isPrototypeOf(meta.source) // true


      proto: null
    };

    //    ret = o_create(ret);
    //    ret.descs     = o_create(ret.descs);

    // why is this o_create? 
    // if proto.foo is being watched, and obj.foo is overwritten
    // to some other value, then it's definitely disconnected at
    // that point, right? Even if it's not overwritten, if you have
    // 
    // proto = {
    // }
    // 
    //    ret.watching  = o_create(ret.watching);
    //    ret.cache     = {};
    //    ret.cacheMeta = {};
    //    ret.source    = obj;

    // TODO: categorize this realization
    // removeDependentKeys calls iterDeps, which loops
    // over deps[propName] > 0,
    // and then the cp.didChange method decrements
    // the deps in the meta in removeDependentKeys();
    // this method is called in two places:
    // - didChange()
    // - teardown()
    // 
    // note that it doesn't do this for non-cacheables CPs.

If CP#didChange removes dependent keys, who adds it back in template situations?
The view that was installed will call get() on that CP, and .get() on a cacheable property will call addDependentKeys


So the rule is that if you want an observer be/stay alive, you need to
call get on that changed prop. AH HA.


