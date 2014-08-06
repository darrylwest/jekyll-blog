---
layout: post
title: A Node Production Logger
---
What started out as a simple node logger to replace more heavy-weight loggers has become our standard logger for simple scripts as well as production servers.  And as of version 0.91.84, with the ability to log domain, category, and levels we will begin using this logger even for clustered applications. 

This multi-level logger can easily write to console, file, or rolling files.  Some of the features include:

- levels: trace, debug, info, warn, error and fatal levels (plus all and off)
- flexible appender/formatters with default to HH:MM:ss.SSS LEVEL message
- add appenders to send output to console, file, etc
- change log levels on the fly
- domain and category columns
- overridable format methods in base appender

The open-source project is [hosted on github](https://github.com/darrylwest/simple-node-logger) and [published to npm](https://www.npmjs.org/package/simple-node-logger).  Installation from npm is as easy as:

~~~
	npm install simple-node-logger --save
~~~

From there you are good to go for simple commandline scripts all the way through multi-service production installations.

## Use

Here are a few examples.  First, create a simple stdout console logger...

~~~
	var log = new require('simple-node-logger').createSimpleLogger();
~~~

or create a stdout and file logger...

~~~
	var log = require('simple-node-logger').createSimpleLogger('project.log');
~~~

or, crate a rolling file logger based on date/time...

~~~
    var opts = {
        logDirectory:'/mylogfiles',
        fileNamePattern:'roll-<DATE>.log',
        dateFormat:'YYYY.MM.DD'
    };

    var log = require('simple-node-logger').createRollingFileLogger( opts );
~~~

The first use will simply log to the console.  The second will log to the console and to the project.log file.  The third logs to the file only. The forth creates a rolling file log system in the target log folder that rolls daily.  The date format controls when the file rolls, giving you the ability to roll hourly, daily, monthly, etc.

## Log Levels

The standard log levels range from 'trace' to 'fatal'.  The default level is 'info' and is set by doing this:

~~~
	log.setLevel('warn');
~~~
	
This sets the log level to warn and suppresses trace, debug and info messages.

## Log Statement Formats

### Simple Logger

The default format is HH:mm:ss.SSS LEVEL message. For example, the log message:

~~~
log.info('subscription to ', channel, ' accepted at ', new Date().toJSON());
~~~

Yields:

~~~
14:14:21.363 INFO  subscription to /devchannel accepted at 2014-04-10T14:20:52.938Z
~~~
	
### Category Logger

If you create a logger with a category name, all log statements will include this category.  Typically a category is a class or module name.  If you create a logger with the category name 'MyCategory', the log statement would format like this:

~~~
14:14:21.363 INFO  MyCategory subscription to /devchannel accepted at 2014-04-10T14:20:52.938Z
~~~

### Domain Logger

For multi-service or clustered loggers, you will want to spearate log statements by domain. For this you would set up a configuration script (e.g., conf.js) to specify domain, category, and other options.  You main also want your application to re-read the configuration file periodically during run-time to modify parameters, probably the log level.

Here is what the configuration file would look like:

~~~
	'use strict';
	
	module.exports.readLoggerConfig = function() {
		var config = {
			logDirectory: process.env.HOME + '/logs',
			filenamePattern: 'client-app-<date>.log,
			domain: 'MyAwsomeApplication',
			refresh: 120, // re-read each 2 minutes
			level: 'warn'
		};
		
		return config;
	};
	
~~~

 
## Appenders

### Console

Writes to the console.  This is the simplest appender typically used for command line applications or for development.

### File

Writes to the specified file.  This appender is typically used for services that periodically start and stop or that have a limited number of log statements.  An example would be to log just error & fatal messages separate from other logs.

### Rolling File Appender

The rolling file appender offers a full production logger where files roll based on date and time.  The minimum roll time is a single hour.  A typical application would be a production environment where log files are rolled throughout the day then archived to a separate location.

The rolling file appender requires a valid date format and file name pattern.  The filename must contain the key word <DATE> that will be replaced with the formatted date.  The configuration must also include a target log directory where the files will be written.

#### Valid Filename Patterns

~~~
	mylog-<DATE>.log
	ApplicationName.log.<Date>
	<DATE>.log
	<date>
~~~

#### Valid Date Formats

Date formats must map to acceptable file names so have more restrictions than typical dates.  If you use delimiters, you are restricted to a dash or dot delimiter to separate year, month, day and hour.  Valid examples include:

~~~
	MMDD  // simple month day that rolls at midnight (no delimiters)
	YYYY.MM.DD-HH // year month day and hour that can roll up to once per hour
	YYYY-MM-DD.a // year month day and am/pm that rolls twice per day
	YYYY-MMM-DD // year month day where month is the short name (Mar, Apr, etc)
~~~
	
The default format YYYY.MM.DD is used if the format is not supplied.

## Dynamic Configuration

Create a javascript configuration that implements 'readConfig' to return configuration details.  

## Examples

The examples folder includes a handful of simple to not so simple cases for console, file, multi-appender, category, etc.

## Customizations

### Appenders

Adding a new appender is as easy as implementing write( logEntry ).  The easiest way to implement is by extending the base class AbstractAppender.  You may also easily override the formatting, order, etc by overriding or providing your own abstract or concrete appender.

For example, you can extend the AbstractAppender to create a JSON appender by doing this:

~~~
    var AbstractAppender = require('simple-node-logger').AbstractAppender;

    var JSONAppender = function() {
    	'use strict';
    	var appender = this;
    	
        var opts = {
            typeName:'JSONAppender'
        };
        
        AbstractAppender.extend( this, opts );
        
        // format and write all entry/statements
        this.write = function(entry) {
        	var fields = appender.formatEntry( entry );
        	
        	process.stdout.write( JSON.stringify( entry ) + '\n' );
        };
    };
~~~

## Conclusion

You might consider using this as your new go-to logger for simple command line scripts or production applications.

