---
layout: post
title: Node Web Application Runner
---

Our web applications always separate development efforts between backend services and client front end.  This allows us to independently develop either back or front end then tie the two together with JSON encode REST calls.

This approach requires a separate HTTP server for our client front end, usually run in a small cluster of instances with common logging and configuration.  The client side is mostly static, usually compiled down to a single application.js and application.css with additional app-cache for off-line use.

We have developed an open source runner for these mostly-static sites to enable running them in the background.  The runner has the ability to start/stop instances for upgrades or maintenance.  There is also a set of non-static middleware components to show status, do some initial landing page routing, and to gate authorized or denied users to/from the site.

The project is hosted at [github](https://github.com/darrylwest/web-app-runner) and [published to npm](https://www.npmjs.org/package/web-app-runner).  The runner is described on those sites like this:

> Simple HTTP server that implements middleware for banning or re-routing authorized connections based on ip, agent or other requiest attributes. The server can be used stand alone or as middleware for connect or express.
>
> _NOTE: this server is designed to deliver simple HTML applications that connect to alternate services.  It has a bit more features when compared with http-server, but isn't intended to be a full REST-type back-end._ 

## Installation

Installing from npm is the easies way to get started.  It's as simple as...

~~~
	npm install web-app-runner --save
~~~
	

You would do this from your static static site then add a few scripts and write a single line script like this:

~~~
	// by default the server returns public/index.html listening on port 3000
	require('web-app-runner').createInstance().start();
~~~

## Basic Server

Adding options and middleware gives you a bit more flexibility.  You can modify the basic script to specify the listening port, home folder and environment like this:

~~~
	var opts = {},
		runner;
	
	opts.port = 3002;
	opts.env = 'staging';
	opts.home = './';
	
	runner = require('web-app-runner').createInstance( opts );
	runner.createApp().use( someMiddleWare() );
	
	runner.start();
~~~

## Configuring a Production Server

This example shows a more realistic environment where the environment is set to production, configuration is set int the run script and the server runs in a background daemon.

~~~
	// IP & agent accept/reject lists defined in config
	var configFile = __dirname + '/config.js',
    	logfile = process.env.HOME + '/logs/web-app.log',
    	log = require('simple-node-logger').createRollingFileLogger( logfile ),
    	opts = { 
        	log:log,
        	env:'production',
        	port:18004,
        	home:'./public',
        	daemon:true,
        	clustered:true
    	},
    	favicon = require('serve-favicon'),
    	connect = require('connect'),  
    	runner = require('web-app-runner').createInstance( opts ),
    	app = runner.createApp();
    
	runner.start();	
~~~

The advantage to this approach is that it exposes the connect 'app', allowing you to use additional middleware.  The disadvantage is that the script is static, so can't be re-read while the service is running.

You can stop this server from the local host by doing this:

~~~
	curl -d token=<appkey> http://127.0.0.1:<port>/shutdown
~~~
	
Where appkey is defined in options and the port is the current listening port.  Alternatively, you can find the PID by looking in the logs and send a kill signal (-2 or -9).  There is also a convenient script in the bin folder that will stop a service, daemon or not as long as it's run from the origin server like this:

~~~
	./bin/stop.js
~~~

## More Features

This just scrates the surface of what is available.  Other features include:

- Querying server status to get process stats
- adding ip and/or browser agent filters to accept or deny users
- implementing an application token to reject token-less requests (bots)

The github site includes simple and more complex examples.  When you get a chance, give it a try and let me know what you think...
