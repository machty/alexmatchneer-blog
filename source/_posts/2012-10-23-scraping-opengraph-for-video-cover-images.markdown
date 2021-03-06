---
layout: post
title: "Scraping OpenGraph for Video Cover Images"
date: 2012-10-23 21:35
comments: true
categories: 
- youtube
- vimeo
- video
- OpenGraph
---
I'm working on a site for a record company, and the folk in charge of
the content usually just host their videos on YouTube, Vimeo, or some
hosting service, so I needed to come up with a simple way for them to
enter their YouTube/Vimeo/Whatever URLs into our CMS so that the videos
could be added to a gallery.

This site also does a lot of magical things with images that
require us to know ahead of time the dimensions of the images we're working with,
so it was also important for us to be able to store the thumbnail for the video internally
(and also allow this automatically selected thumbnail to be overridden
with an image of their choice). 

<!-- more -->

## OpenGraph for Thumbnail Selection

I'd originally toyed with the idea of using a suite of Regex's to reason
the video ID from the YouTube/Vimeo/Whatever link that the user provided
and then use that ID to query a thumbnail from that particular service.
Problems with that idea:

- Annoying to have to research all the different URL formats to support
  in a giant Regex whack-a-mole
- What if the service adds a new format of URL that my regex suite
  doesn't catch?
- What if they want to use a new service?
- YouTube has [publicly accessible](http://www.tonylea.com/2011/how-to-get-youtube-thumbnail-images/)
  thumbnails if you've parsed the ID, but I think for Vimeo (and other
  services), you need to jump through the hoops of integrating their
  API.
  
Turns out there's a much lazier and more flexible alternative to a Regex
suite, and that is to information freely available on Facebook's
[Open Graph](http://developers.facebook.com/docs/opengraph/). In short,
Open Graph is a protocol for tagging content (both concrete things like
places/restaurants/etc and virtual content like videos/photos/etc) by
properly setting meta tags on in the `<head>` tag on the web pages that
represent that content. If a web page adheres to the OG protocol, you
can just scrape the page's meta tags for things like a title,
description, and, you guessed it, a representative image for that
content.

So, you can just navigate to [a random video's URL](http://www.youtube.com/watch?v=6GggY4TEYbk),
open the source, and find the following nested in the `<head>` tag:

`<meta property="og:image" content="http://i3.ytimg.com/vi/6GggY4TEYbk/mqdefault.jpg">`

which makes for a perfect cover image:

![OG Thumbnail](http://i3.ytimg.com/vi/6GggY4TEYbk/mqdefault.jpg)

This will work for any video hosting service that supports OG, which is
probably all of them, since they'd be cutting themselves out of
optimized Facebook sharing if they didn't provide those tags. Also, the
image provided is a lot more likely to be formatted for general use
rather than, say, using the previously linked YouTube approach for
determining a thumbnail URL, which might yield a thumbnail that's
cropped or black-bar'd for internal YouTube use.

## Using Nokogiri to Scrape for OG Tags

I used the [Nokogiri](http://nokogiri.org/) gem to scrape the
user-provided video URL for the og:image tag value via the following
code:

{% codeblock lang:ruby %}

  before_validation :set_attachment

  protected

  def set_attachment
    return if attachment.present?

    # Download and parse the video URL
    doc = Nokogiri::HTML(open(video_url))

    # Use CSS selection to query og:image url.
    image_url = doc.at_css('meta[property="og:image"]').try(:[], 'content')

    # Save the downloaded thumbnail image to paperclip attachment.
    self.attachment = open(URI.parse(image_url))
  rescue
    errors.add :attachment, "couldn't be determined by the video URL you supplied"
  end
{% endcodeblock %}

This fails quietly if there are no og:image tags at the provided URL
(which just means the user will have to uplaod their own thumbnail).

## On the front-end

Once you've got the video cover image into your back-end, you can use
any number of free or commercial plugins that handle the gallery
presentation of images, videos, Flash, etc. I used
[prettyPhoto](http://www.no-margin-for-errors.com/projects/prettyphoto-jquery-lightbox-clone/)
since it was free and easy enough to hack. 

