---
layout: post
title: Mock Browser for Client Testing in Node
---

We recently moved all client code development to node using browserify to compile and bundle javascript classes into a single file.  At the same time we replaced grunt with gulp.

While making the move we found it difficult to continue using phantomjs for unit tests.  At the same time we needed access to window, location, local storage, and most of all to document.  All globals inside the browser (bad).

So we made the choice to not access these globals directly but instead to create a single object with with accessor methods to get document, window, location, etc.  This made it possible to create a mock browser object to pass to all classes for testing.

The mock project is ...