---
layout: post
title: "Daily Journal"
date: 2014-08-02 21:24
comments: true
categories: 
---

## NPM is killing me

Apparently this fixed everything.

    npm cache clear && npm install

https://www.npmjs.org/doc/cli/npm-cache.html

npm caches everything in `npm config get cache`, which for me is:

    ~/.npm

Folder structure is something like

    ~/.npm/PACKAGE_NAME/VERSION/

which contains:

- .cache.json
  - lots of overlap w the project's package.json, with additional
    cache-specific things like
  - etag, shasum
  - deployment-specific data about the package
- package.tgz 
  - the original tarball downloaded for this packaage
- package/
  - the unzipped tarball

In other words

> Additionally, whenever a registry request is made, a .cache.json file is placed at the corresponding URI, to store the ETag and the requested data. This is stored in {cache}/{hostname}/{path}/.cache.json.

## Food Shit

Pok Pok is a legit ass Thai place I need to check out.

    http://pokpokny.com/

## `sed` to select lines

    $ git branch
      cp-qp
    * master
      new-doctitle
      setup-controller-qp

I wanted to switch to the fourth one without typing
`setup-controller-qp`. Here's how you could do it by using the line
number

    $ git branch | sed -n '4p' | xargs git checkout
    Switched to branch 'setup-controller-qp'

Obviously this is just a dumb exercise since it's waaay more typing.
This is me practicing.

You can also display multiple lines using a syntax similiar to cut's
`-f1,2` syntax: 

    $ git branch | sed -n '3,4p' 
      new-doctitle
      setup-controller-qp

## commissary

From Orange is the New Black

> commissary: a restaurant in a movie studio, military base, prison, or other institution.

## HRT

[Hormone replacement therapy](http://en.wikipedia.org/wiki/Hormone_replacement_therapy)















