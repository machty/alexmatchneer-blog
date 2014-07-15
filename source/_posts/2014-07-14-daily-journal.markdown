---
layout: post
title: "Daily Journal"
date: 2014-07-14 09:33
comments: true
categories: 
---

## Website Push != Push Notifications

So when you're rummaging through the Apple Dev Portal, don't confuse the
two and generate the wrong certs. K?

## WWDC 2011 video on UIViewController Containment

    https://developer.apple.com/videos/wwdc/2011/

First off, WWDC stands for the Apple World-Wide Developer Conference.

## Why view controllers

- Make it easy to make high quality apps
- Reusable

A View Controller just a Controller. Mediates model data with many
views. View controllers maintain entire hierarchies of views. They're
heavyweight, meant to manage a "screenful of content". Often packaged
with a model, e.g.

- TweetViewController
- ImagePickerController

View Controllers are social, meant to connect to each other. They push
and pop each other, etc. They talk to each other a lot. 

The "manage a screenful of content":

View Controllers anticipate being presented in different ways. More
accurately: they should maintain a unit of content. Only
`rootViewController` manages a "screenful of content", specifically the
`rootViewController` property of the window object. Knows how to forward
rotation events, decides overall layout. 

How to use View Controllers

- subclass UIViewController
- associate VC w view hierarchy
- override callbacks

Apperance callbacks: viewWillAppear, viewDidAppear, etc
Rotation callbacks: viewWillRotate, etc

ViewControllers manage an entire view hierarchy. Not just one to one
with a view. 

View Controller Containers, a tale of Two Hierarchies: view hierarchies
and view controller hierarchies. 

Container controllers

- responsible for parent child relationships
  - API like `initWithRootViewController` implies parent-child in nav
    controller
  - split view controllers lets you set view controller children.

Controller container api

- addChildViewController
  - not meant to be called by anyone but its own implementation; don't
    call it on other controllers, basically
- remoteFromParentViewController
  - ^^ ditto
- childViewControllers array
- callbacks
  - willMoveToParentViewController
  - didMoveToParentViewController

Shouldn't be able to walk up view hierarchy and totally skip over a
parent view controller: UIViewControllerHierarchyInconsistencyException,
prevents you from manually adding views into the wrong view controller
hierarchy. 

When are appearance callbacks called?

viewWillAppear etc has nothing to do w addChildViewController, which has
nothing to do w view appearance.

viewWillAppear just means it's in the window view hiearchy, but doesn't
mean it's actually visible (same w viewDidAppear).

TODO: what is view layoutSubviews?

viewDidAppear after the view added to viewHierarchy. Called after
layoutSubviews.

When implementing transitions, you have to implement
didTransitionToBlahBlah, one of the options is `animations` lambda. 

VS Layout callbacks:

- viewWillLayoutSubviews...

Presentation and Dismissal of VCs

set presentation style and then do presentViewController

Can also present VCs by direct subview manipulation. 

    [root.someView addSubview: vc.view]

But this is bad form; better to make the VC a child of the root VC. VC
knows where subviews should go rather than the ass backwards way.

When to create a custom view controller container?

- Hopefully you don't need to, so think twice first
- Aesthetics
- Custom app flows
- Your app manipulates view hiearchy directly

Use case: make split view show up in both landscape and portrait: no
need to make custom VC because now there's API to just better configure
split view.

View controllers know themselves if they're moving to or from parent
view controllers within viewWillAppear and viewDidAppear by checking:

    // used in viewDid/WillAppear
    - (BOOL)isMovingToParentViewController;

    // used in viewDid/WillDisappear
    - (BOOL)isMovingFromParentViewController;

    - isBeingPresented;
    - isBeingDismissed;

Lol:

    - (BOOL) automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers;









