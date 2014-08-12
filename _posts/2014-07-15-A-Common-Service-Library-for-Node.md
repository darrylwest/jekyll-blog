---
layout: post
title: A Common Service Library for Node
---
All of our applications separate web front end development and delivery from the back end.  Our backend services are REST only services--no templates, HTML generation, or views; just REST with JSON responses.  Components common to all REST services including bootstrap, factories, validation delegates and services are contained in a set available through npm called [node-service-commons](https://github.com/darrylwest/simple-node-logger).

The commons are complete enough to provide many components and extensible enough to allow other modules for logging, database, etc.  It mainly provides a framework for application configuration and startup.  With base classes for boot strap, config, application and service factories.

The service leverages [express js](http://expressjs.com/) (4.0) to supply routing, middleware and HTTP service.  Most of the express details are behind the scenes so upgrading to newer versions of express, or even swapping out with another framework is relatively easy.

## Common Web Service Flow

![service-architecture]({{ site.url }}/images/web-service-architecture.png)

## Application Bootstrap

### The bin Folder

There are three or four scripts used to start/stop and get the status of a web service container.  The scripts run on the local/host machine.  They include:

- start.sh
- stop.sh
- status.sh
- run.sh

The start script starts the service with the appropriate environment, logger and configuration.  The script runs in the background.

The status script reports status of the application and machine environment using curl to access the status end point.  For applications that use an API key, the script sets the header value like this:

~~~
	curl -H 'x-api-key: <key>' -X GET http://localhost:<port>/ServiceName/status
~~~

The stop script is used to stop the web container using a shutdown end point.  It must be run locally and looks like this:

~~~
	curl -H 'x-api-key: <key>' -X POST http://127.0.0.1:<port>/shutdown
~~~

The run script is for development.  It starts the service in the foreground and is stopped with control-c.

### Internal and External Configuration

On start up boot strap parses the command line and returns an object that specifies the run-time environment.  This environment name is used to access the Config script by name (development, staging, production, etc).

Most applications also include external configuration that contains keys for database, S3, email, etc.  This sensitive data is contained in a separate file to enable storing outside of source code control.

### Application Factory

All major components are created in a separate application factory.  The application factory usually instantiates other factories to assist, e.g., service and delegate factories.  Separating component construction into factories keeps the main-line code more readable and much more testable.

## Web Service API

Web service APIs are end points that are exposted to the public.  Typcial end point verbs include just three methods:

- query (get)
- find (get)
- save (post, put, del)

Exposing these three verbs to a single resource give the application the ability to locate lists of data, find a single row, and/or insert, update and delete a single row.  Sticking with these three verbs also keeps the interface very consistent and easy to use.

## Data Service Layer

The data service layer support methods that are invoked from the web service layer (see service flow diagram above) to coordinate resources to access data from database, files, and other remote services.  

An important rule to follow for this layer is that it's job is to proxy work to other components.  So, any actual database access is done through the DAO layer--remote services are done through service delegates.  This approach restricts the data service layer to being the arbitor and coordinator of work rather than the real worker.  It not only keeps this layer clean and testable, but it makes locating errors much easier.

## Conclusion

The base classes offered in [common service library](https://github.com/darrylwest/simple-node-logger) provide an industrial strength platform for delivering well tested REST services.  By enforcing a factory generated separation of concerns and some common sense REST rules, your back end services are easy to develop, test and maintain.








