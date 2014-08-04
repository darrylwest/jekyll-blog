---
layout: post
title: A Database for nodejs Projects
---


LevelDb is a key/value store written three or four years ago by engineers at Google.  Since then it has been adopted by many projects including Google Chrome, Bitcoin, Apache ActiveMQ, and others.  It was introduced to the node community as levelup/leveldown in July of 2012.  Since then there have been over 13K downloads and many extensions.

When I first started experimenting with LevelDb I was pleased with it's speed and ease of use but also surprised as how easy it was to configure. Simply give it a file name and you are good to go.  Or if you want an in-memory database, use memdown as the database backing store.

SimpleNodeDb is an extension to LevelDb that adds query, insert, update, delete and backup/restore capabilities.  The keys are domain specific and data values are stored as objects with JSON encoding.

The project is published to the npm registry and can be installed using this:

	npm install simple-node-db
	
The project includes a full suite of unit tests and examples.  If you get a chance to try it out, let me know what you think.  For more info on leveldb, check out [this video](http://www.infoq.com/presentations/leveldb-nodejs) from Richard Astbury.
