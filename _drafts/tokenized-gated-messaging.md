---
layout: post
title: Tokenized Gated Messaging
---

My friend and colleague [David Flajoe](https://www.linkedin.com/in/davidflajole) introduced a concept of controlling incoming messages from mulitple clients with a shared, single use token.  The way it works is if multiple clients submit a message at the same or near the same time to a centralized hub, the first one with a valid token wins--the rest are rejected. New tokens are regenerated and broadcast as messages are accepted.  It's a way of gating competing messages to give credit to the first responder.  Or, Tokenized Gated Messaging.

## A simple example: Multi-user Bidding

The bidding site uses gated messages to control who among many potential bidders is grated the current bid.  A token is generated and broadcast to the group.   The first bidder to accept sends an "accept" message along with the token.  If the token matches the current token, then the bid is awarded to that person and the new token is re-generated and broadcast.  If a second bidder attempts to claim the bid, their request is rejected.

## Other applications

Tokenized gating has other applications as well.  Short lived, single use tokens can be combined with other values to create a non-repeatable hash.  For example, a password combined with an access token plus known key can be used to generate a hash like this:

~~~
	pwhash = encode( password  + salt )
	hash = encode( session key + access token + pwhash )
~~~

Where the session key is known to the host and client (not other clients), the access token is the current gating token, and the password entered by the user plus salt is encoded using some algorithm (sha, md5, etc).

The hash is transmitted to the access hub where a lookup is done to find the session and encoded password, based on user profile.  The server side uses the same formula to generate a hash and compare to what was sent.  At the same time, a new access token is generated and broadcast to the group.  

This application isn't using gating as much as the short life of the broadcasted token to insure that the message cannot be re-sent.  So, the server hub would probably regenerate new access tokens at random periods, say every 100 to 300 milliseconds.

## Timing Diagram

![]({{site.url}}/images/tokenized-gated-messages.png)

## Websocket Implementation

There is a websocket implementation of this on [github](https://github.com/darrylwest/websocket-access-service) based on [node messaging commons](https://github.com/darrylwest/node-messaging-commons).  To install and try out, just create a test project do this:

~~~
	npm install websocket-access-service --save
~~~


