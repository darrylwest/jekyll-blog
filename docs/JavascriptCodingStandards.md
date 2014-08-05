# Javascript Coding Standards

## Overview

Our standards document describes platform, testing, formatting, and best practices for developing applications in javascript. The objectives for these standards are based on the following:

- provide an environment to produce stable, cross-browser web applications
- provide a well established framework to enable team development for both server and client side operations
- establish rules that promote "readable" code enforcing easily recognizable patterns
- promote testable and well tested code

### Our Standards are based on the following references:


- Writing Testable Javascript, Shane Tomlinson
- Expert Javascript, Mark Daggett
- Test-Driven JavaScript Development, Christian Johansen
- JavaScrip Ninja, John Resig/Bear Bibeault
- Maintainable Javascript & Best of Fluent Video, Nicholas Zakas
- Building iPhone Apps With HTML, CSS and Javascript, Johathan Stark
- Introducing HTML5, Bruce Lawson
- Javascript Patterns, Stoyan Stefanov
- Javascript: The good parts, Douglas Crockford (http://javascript.crockford.com)

Other Resources:

- Javascript Interview Questions: http://www.toptal.com/javascript/interview-questions
- Coders at Work, Peter Seibel
- Videos from Yahoo theater especially the multi-part series from Douglas Crockford
- Our MVC JavaScript Platform Slide Deck
- For Javascript/CSS Browser Compatibility see can i use.
- Javascript Code Complexity, JSComplexity

### ECMA Script 5

Every attempt should be made to comply with the ECMA 5 standard and be aware of it's capabilities.  At a minimum, 'use strict' should be placed at the top of all function/classes.  JSHint will warn if 'use strict' is not found, including support scripts.

## Development Platform

### Javascript IDE

Our preferred javascript IDE is WebStorm.  We have a roundpeg.xml configuration file to enforce our formatting standard.  For Mac users the file goes in ~/Library/Preferences/WebIde50/codestyles.  If WebStorm isn't used, we encourage Eclipse with the javascript plugin, Sublime or Mate with appropriate plugins.   Any IDE will work but using WebStorm with our configuration settings is the easiest way to create format-compliant code.   Using an alternate IDE may require a post processor to help enforce standards.

### Development Web Services

Our web applications use REST services and WebSockets to exchange data between client and server.  Client development requires node to run tests. 
 
### Logging

Logging for test, development and production debugging is a big part of our JavaScript  development.  We have developed a Remote Logging lib/utility similar to log4j that is used to log to the local console (Safari, Chrome, FF5, & IE9) as well as to a remote service listener.  Developers are encouraged to add log and assert statements to help debug and validate code.

Examples of typical use:
    log.debug('event handler: ', event.type, ', data: ', event.data);
    log.info('initialize service');
    log.warn('this should not happen here...');
    log.error('exception caught', error);


Loggers are always created by ApplicationFactory for major each class.  So you would see this:

    var MyClass = function(options) {
        var clz = this,
            log = options.log;
 
        // more code...
 
        // constructor tests
        if (!log) throw new Error('MyClass must be constructed with a valid log object');
    };

### MVC Package Layout

All javascript projects use a standard MVC layout with components, controllers, models, views, services, events, and delegates.  Testing packages use a similar layout but add mocks and fixtures.  A single index page (index.html) accesses ApplicationFactory to construct application components based on a set of options that inject values and components that are mapped from their DOM counterparts.

Below is an example of a typical project.

	project/
    	app/
        assets/
        components/
        controllers/
        delegates/
        events/
        models/
        services/
        views/
        index.html
    build/
        application.js
        application.css
        index.html
        app.cache
        favicon.ico
    
    config/
        Config.js
        site-config.json
    libs/
    mocha/
    	mocks/
    	fixtures/
        components/
        controllers/
        delegates/
        events/
        models/
        services/
    	mocha/
    
    includes.js
    Gruntfile.js
    Makefile
    package.json
    
#### Components

Components are instantiated from component factories.  All components have full unit tests.  Components never reference services but have callback hooks to controllers to request data when needed.  Controllers populate data directly to components.

An alternative to creating component classes is to create/use a builder class, usually called ComponentBuilderDelegate.  This can be used to build all pages, buttons, panels, tables, etc. for small applications or can be combined with component classes, usually page containers to create larger applications.  These components usually rely somewhat on Bootstrap.css.

Building an entire application using components creates a very extensible platform.  Pages, views, containers, dialogs and low level components can be specified in configuration and built dynamically as the application loads.  But, the downside is that this approach requires a specialized skill set foreign to most HTML/CSS coders.

#### Controllers

Controllers are the glue between view/components and data models.  Most of their logic concerns event and callback management.  At a minimum, each project has at least one  controller called ViewController.  The view controller coordinates actions between services and UI views and actions.

The controllers package also includes all factories.  At a minimum there is a single ApplicationFactory.  In larger applications there are service, delegate, and component factories.

#### Delegates

Delegates are the worker classes.  Workers include parsers, calculators, formatters, validators, etc.  Delegates are also created to simply offload work from controllers, data access or service objects.   Below is an example of a typical validator delegate.    As you can see, this validator actually uses another validation delegate to access a library of validation methods.

	var ValidationDelegate = function(options) {
    	'use strict';
    	var delegate = this,
        	log = options.log,
        	validator = options.commonValidator;
 
    	this.validateCountry = function(country, errors) {
        	log.info('validate the country object');
 
        	if (!errors) {
            	errors = [];
        	}
 
        	validator.validateLength( 'countryCode:', country.countryCode, 3, 10, errors );
        	validator.validateLength( 'countryName:', country.countryName, 1, 50, errors );
 
        	return errors;
    	};
 
    	// constructor validation
    	if (!log) throw new Error("validation delegate must be constructed with a log");
    	if (!validator) throw new Error("validation delegate must be constructed with a validation object");
	};

#### Events

The events package includes all custom event types used throughout the system.  It is supported by dispatcher class (EventDispatcher or the newer CentralDispatcher) used as the system's central event bus.   Event classes should include static constructor methods as well as static event type definitions.  Here is a typical example:

	var ApplicationStateEvent = function(type, data) {
    	'use strict';
    	this.type = type || ApplicationReadyEvent.READY;
    	this.data = data;
	};

	ApplicationStateEvent.APPLICATION_READY = 'ApplicationStateEvent_ApplicationReady';

	ApplicationStateEvent.createReadyEvent = function(obj) {
    	return new ApplicationStateEvent( ApplicationStateEvent.APPLICATION_READY, obj );
	};
	
All event handler methods should end with the key word "Handler" and their function parameter should always be "event".  This removes any ambiguity or question that this method is invoked by some triggered event, either from the central dispatcher or from a support system (ajax, button clicks, etc).

#### Callbacks

Callbacks follow the node standard signature of callback(err, result).  The naming convention for the callback function is either the word "callback", or somethingCallback, e.g., completeCallback or updateCallback.  In any case, the word callback should be at the end of the name.  
Callbacks should be defined as functions or methods like this:

	var myfunction = function(id, completeCallback) {
    	var foundCallback = function(err, result) {
        	if (err) return callback( err, null );
 
        	customer = result;
        	// do some stuff with the customer...
 
        	return completeCallback( err, customer );
    	};
 
    	dao.findCustomerById( getPool().getConnection(), id, foundCallback );
	};
	

#### Models

##### Data Models
All data models are stored in the models package.  Models are usually simple value objects but sometimes have additional functionality.  Below is a typical example of a value object.  The constructor accepts a params argument that acts as a copy-constructor.  Some of the values are set to defaults.  All value members are public.  Here are two examples of the data model pattern.
	var UserQuestion = function(params) {
    	'use strict';
    	if (!params) params = {};
 
    	this.token = params.token;
    	this.name = params.name;
    	this.email = params.email;
    	this.topic = params.topic;
    	this.text = params.text
    	this.questionSource = params.questionSource || 'web';
	};
	
##### Request Models

Each service request must have an associated request model used for query, find, and save.  These models inherit from abstract classes to insure that the proper userSessionToken accompanies each request.

#### Services

The services package is were all remote connections are made, usually through Ajax or WebSocket communications.  Success and error handling methods are implemented a single class, CommonDataService.  Request objects, parsing delegates, and specific data events are required.    Application factory configures each data service with the appropriate parser, event class, logger etc.   Events are typically listened to and handled in view controllers.

Service methods should always accept a single request object with a "createParams()" method to pull prepared parameters.  There are two abstract request classes, AbstractQueryRequest and AbstractUpdateRequest that should be extended to provide a common interface.   Request objects are created in the models package and should have associated tests.
Common Data Service

All data services use CommonDataService to pull standard json response data from remote servers.  This class has a number of supporting classes including request models,  parse delegate and an event class with event types to support success and failure for the three implemented methods:query: given a concrete implementation of AbstractQueryRequest, query returns a page-able list of domain objects.  Objects are parsed by accessing parseList() in the domain parser save: given a domain class and AbstractUpdateRequest, post the domain class to the server for update or insert.  A successful return is always a single data model parsed by parseModel()
find: a find request object populated with the domain object's id is sent to the server.  Successful response is parsed by parseModel()

#### Views

#### Assets

The assets folder is where css, images, icons, etc. are stored.  The assets folder is ignored for unit tests.  Most projects use less to compile css.  Including Javascript Files

### Unit and Integration Testing

##### Getting Started
Before you can run unit tests effectively you will need to install grunt and grunt-cli.  See this getting-started page for help...

Tests are organized by package, e.g., controllers, services, delegates, etc.  Each controller, component, service, delegate, and data model has it's own set of unit tests.  Event classes are also tested mainly for naming consistency and validation.    

Tests use mocha/should as the test framework. 

##### Running Unit Tests

All projects have at least one Makefile that help coordinate building and running of tests.  For most projects, you can run "make test" to run unit tests and jshint static file tester.  Some projects use grunt to actually run test and jshint, others run tests and jshint without the use of grunt.  Those projects require that jshint is installed on the target machine.

#### Continuous Unit Testing

There is a build task called watch to run the full suite of tests while developing.  You can launch this from make by invoking "make watch"


#### Integration Testing
Integration testing is created using two tools, casperjs and selenium.  Casperjs tests access phantomjs, a headless browser.  Selenium opens a browsers and plays back scenarios.

#### Accessing Private Methods and Variables 

Most methods defined in javascript classes are public to enable full testing.  This is not always practical, so when private variables and methods are required they should be made public for testing using the following convention:

	var MyClass = function(options) {
    	'use strict';
    	
    	var cls = this,
        	log = options.log,
        	myLocalVar = 5;
 
    	var myLocalMethod = function() {
    	};
 
    	this.__protected = function() {
        	return {
            	myLocalVar:myLocalVar,
            	myLocalMethod:myLocalMethod
        	};
    	};
	};
	
	var cls = new MyClass();assert cls.__protected.myLocalVar === 5;assert typeof 	cls.__protected.myLocalMethod === 'function';
	
### Asynchronous Operations

Javascript is single threaded.  That's good.  But to take advantage of our ever increasing multi-processor world, we need to adopt functional solutions.  Thats where asynchronous operations come in.  
Javascript applications that run in the browser or in node have asynchronous events occurring all the time.  This is especially true in node where most actions return results through asynchronous callbacks rather than direct return values.  This takes some time to get used to.
Consider the following recursive function:

	var list = getList();
 
	var nextListItem = function() {
    	var item = list.pop();
 
    	if (item) {
        	// process the item...
        	nextListItem();
    	}
	};
 
	nextListItem();
	
The recursive list item processor will work fine if the list is a reasonable size.  But, if the list is huge, then one has to worry about the size of call stack.  With every iteration it grows by one call, so it may exceed memory limits and fail (in a very bad way) if there are too many iterations.
Now consider this small change: 
	var list = getList();
 
	var nextListItem = function() {
    	var item = list.pop();
 
    	if (item) {
        	setTimeout(function() {
            	// process the item...
            	nextListItem();
        	}, 0);
    	}
	};
 
	nextListItem();
	
The stack over-flow problem is now eliminated.  Why?  Because javascript's event system handles the recursion–not the call stack.  When nextListItem runs, if 'item' is true (not null) then the timeout function is defined and pushed to the event queue, then the function exits–and the call stack is now clear. When the event queue runs it's timed' out event, the item is processed and nextListItem is recursively called.  Again, the method is processed from start to finish without a direct recursive call, so the call-stack is again clear–regardless of the number of iterations.

Now consider this example:

	var userList,
    	cleverProgrammerBonus = 10000;

	var userUpdateCallback = function(err) {
    	if (err) return updateCompleteCallback( err );
    	nextUser();
	};
 
	var nextUser = function() {
    	var user = userList.pop();
 
    	if (user) {
        	user.pay += cleverProgrammerBonus;
        	dao.updateUser( user, userUpdateCallback );
    	} else {
        	updateCompleteCallback();
    	}
	};
 
	var userFetchCallback = function(err, list) {
    	if (err) return updateCompleteCallback( err );
    	userList = list;
    	nextUser();
	};
 
	dao.fetchUsers( userFetchCallback );
	
As with most functional, asynchronous solutions, it's best to start at the bottom–the dao fetch of users.  The fetch callback sets the user list then invokes the recursive nextUser() to get the iteration started.  Then the user is updated asynchronously, and when it completes updateUpdateCallback is invoked.  This callback continues the recursion by invoking nextUser.  This is repeated until the list is empty.  There isn't a need for setInterval ( or nextTick() ) because the dao calls to update the user are asynchronous–always invoked from the event queue, not the call stack.  So the call stack remains static no matter how many users are in the list.
  
Its also important to realize that the function dao.updateUser doesn't really start working until nextUser has exited.   It's queued to do some work, but not at the direction of the call stack–just the event queue. 

### Source Code Formatting Standards

Standards are influenced by JavaScript Patterns, written by Stoyan Stefanov and other published coding standards.  All source code should be checked with jshint.  The code must comply or the tests will fail.

#### General Guidelines
- each statement should be terminated by a semi-colon
- code indentation should always be used and should be 4 spaces (not tabs).
- tabs should be converted to spaces
- all code should be encapsulated in a "Class" like function (see examples above)
- each class should be in a separate file  
- each service, controller and delegate must have an associated unit test file
- classes names should be capitalized camel case, e.g. RegistrationService, User, ComponentFactory
- class files must match the class name, e.g., UserService defined in the file UserService.js
- method names should be camel case, e.g., calculateTotal(), startWorker(), etc 
- use the log (see above) and avoid using the native console
- use the triple equals and non-equals operators ( === and !== ) to bypass unwanted type coercion
- use {} instead of new Object(). use [] instead of new Array().
- use an array to create long strings rather than multi-line strings with +
- use array iterators when appropriate (filter, forEach, every, map, some, reduce, reduceRight)

#### Naming Conventions

Use mixed case nouns when naming classes, objects, and variables.  Classes begin with uppercase, objects and variables use lower case.  Constants use all uppercase and underscores.   Use verbs to name message receptors, functions, etc.  Accessors that provide method based access to private variables should use get or set with the exception of booleans that may us is or has.

#### Boolean Methods

Methods that return boolean values should be named using "is" or "has" or "was", i.e., isValid(), wasReceived(), hasMember().  It is important that these methods return only true or false.  A common mistake is to let a boolean method return null or undefined to represent false, but this leads to difficult to find bugs.

#### Curly Braces

Braces should be used in all loops and conditional statements.  Always place the curly brace on the same line as the statement, never on a line by itself. Curly brace should be proceeded by a single space.  Here are a few examples:

	// private method
	var calculateTotal = function(option) {
    	if (option) {
        	// do something
    	} else {
        	// do something else
    	}

    	while (isRunning()) {
        	log.debug('running...');
        	// do something else...
    	}
	};
	
#### Declaring Function Variables

Javascript has no block scope, just function scope, so variables should only be declared inside functions.  The lack of block scope also means that variables should be defined at the top of the function, rather than in line.   The preferred style defines multiple variables with a single "var" statement, like this:

	var MyClass = function(options) {
    	"use strict";
    	var myclass = this,
        	log = RemoteLogger.createLogger('MyClass'),
        	dispatcher = options.dispatcher;

    	// other public access methods
	};
	
JSHint will fail if you don't use this form.

#### Creating Very Long Strings

When constructing long strings, you should not use the + operator on multiple lines.   It's much more efficient to create an array with a series of "push" calls or in-line [ 'this', 'that' ] then use join to create the string.  Here is an example:

	var myLongString = [
   		"the rain in spain",
   		"falls mainly on the ground.",
   		"the rain in Seattle falls",
   		"mainly on the trees."
	].join(' ');
	
#### Code Comments

##### Class Files
At a minimum, each class (psuedo-class) file should have a header that briefly describes the intention of the class.  It should also include the date it was created, the author's name, and any dependencies.

##### Comment Blocks

Normally, blocks of code that are commented out is a bad practice--that's what source code control is for.  But, if you do find the need to comment out a block of code, it's better to use the // rather than /\* \*/ form.  The reason is that some regular expressions can contain */ and will mess up the compiler.  The /\* */ should be used outside of functions with the exception of Class definitions.  Inside functions it's better to use multiple single line comments using //.

The // form should always be followed by a single space, e.g. // this is a comment, not //this...

- - -
<small><em> Version 00.90.01 | darryl.west </em></small>