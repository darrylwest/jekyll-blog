---
layout: post
title: Mock Browser for Client Testing in Node
---

We recently moved all client code development to node using browserify to compile and bundle javascript classes into a single file.  At the same time we replaced grunt with gulp.

While making the move we found it difficult to continue using phantomjs for unit tests.  At the same time we needed access to window, location, local storage, and most of all to document.  All globals inside the browser (bad).

So we made the choice to not access these globals directly but instead to create a single object with with accessor methods to get document, window, location, etc.  This made it possible to create a mock browser object to pass to all classes for testing.

A majority of the implementation is from the [jsdom project](https://github.com/tmpvar/jsdom) with enhancements for local and session storage plus some fixes for un-implemented document features (classList).

The mock browser eliminates the need for a headless browser like phantomjs to provide a much faster unit test framework.  It's perfect for browserify projects that run tests prior to compiling the bundle.

### Installation

The project is hosted on github and publised to npm so installation is easy.

~~~
	npm install mock-browser --save
~~~

This gives you access to MockBrowser, MockStorage, and AbstractBrowser.  The next sections explain their use.

### Using the Mock Browser

The typical use case is a browserify project with unit tests that need to provide access to browser globals like window, document, location, etc.  The best way to simulate this is to use a proxy wall between the normally global browser objects a require the application to get instances of window, document, etc.  That way you can supply a mock for all of these objects with a common interface (AbstractBrowser).  It looks like this...

~~~
    var MockBrowser = require('mock-browser').mocks.MockBrowser,
        mock = new MockBrowser();

    // and in the run-code inside some object
    var doc = mock.getDocument(),
        div = doc.createElement('div'),
        storage = mock.getLocalStorage();

    storage.setItem('mykey', 'my value');
    assert storage.getItem('mykey') === 'my value';
~~~

An alternative to this approach is to make the window, document, location etc. global to simulate what the browser does.  I think this is a bad idea--globals are just poor practice.  So, we will stick with the access API for all run-time code.

### The Mock Browser API

Here is the complete API most of which is inherited from AbstractBrowser.

~~~
Instance methods...

    getDocument()
    getWindow()
    getLocation()
    getHistory()
    getLocalStorage()
    getSessionStorage()

Object methods...

    MockBrowser.createDocument()
    MockBrowser.createWindow()

~~~

The two object methods make it easy to get either a window or DOM document mock when you don't need access to other objects.  Although, the window object actually has references to all the other objects document, location, localStorage, etc.

### Using the Mock Storage

The MockStorage object is used to mock out local and session storage.  When  used with mock browser, they are attached to the window object and can be accessed from AbstractBrowser instances by invoking getLocalStorage() or getSessionStorage().

This object may also be used standalone when you just need to mock out either local or session storage.  It looks like this:

~~~
    var MockStorage = require('mock-browser').mocks.MockStorage,
    	storage = new MockStorage();

    storage.setItem( 'mykey', 'my string value' );
    assert storage.getItem( 'mykey' ) === 'my string value';

    assert storage.length === 1;

    storage.clear();
    assert storage.length === 0;
~~~

### Using Abstract Browser

The AbstractBrowser object can be used as an interface for run-time client apps to access browser window related objects.  This approach enables code to be used both in and outside the browser.

~~~
    var AbstractBrowser = require('mock-browser').delegates.AbstractBrowser;

    // configure in some factory
    var opts = {};
    
    if (typeof window === 'object') {
    	// assign the browser window if it exists
    	opts.window = window;
    } else {
    	// create a mock window object for testing
    	opts.window =  MockBrowser.createWindow();
    }

    // create the browser object with a real window in brwosers and mock when not in browser
	var browser = new AbstractBrowser( opts );

    var doc = browser.getDocument();
    var element = doc.getElementById('my-dom-element');
~~~

### Abstract Browser API

~~~
Instance methods...

    getDocument()
    getWindow()
    getLocation()
    getHistory()
    getLocalStorage()
    getSessionStorage()

A single object method...

    AbstractBrowser.extend(child, options)  <- extend the abstract object

~~~

These methods are inherited by MockBrowser to provide a consistent interface between test and run-time environments.

### Extending AbstractBrowser

For run-time use you can extend AbstractBrowser to inherit the API.  This enables attaching other object to the browser object rather than using globals.

~~~
    var AbstractBrowser = require('mock-browser').delegates.AbstractBrowser;

    var MyBrowser = function(options) {
    	var browser = this,
        	builder = options.componentBuilder;

        // inherit getWindow(), getDocument(), getLocation(), getHistory(),
        // getLocalStorage(), getSessionStorage()
        AbstractBrowser.extend( this, options );

        // my browser API extension...
        this.getComponentBuilder = function() {
        	return builder;
        };
    };
~~~

### Conclusions

Using the MockBrowser for testing combined with an extended AbstractBrowser provides a solid framework for creating client applications in node and browserify.  The test-environment has the ability to provide a browser like environment for full testing and the run-environment executes independent of the browser globals.  You can download the project [from github](https://github.com/darrylwest/mock-browser) or through [npm](https://www.npmjs.org/package/mock-browser).
