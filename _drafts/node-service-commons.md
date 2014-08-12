---
layout: post
title: A Common Service Library for Node
---
All of our applications separate web front end development and delivery from the back end.  Our backend services are REST only services--no templates, HTML generation, or views; just REST with JSON responses.  Components common to all REST services including bootstrap, factories, validation delegates and services are contained in a set available through npm called [node-service-commons](https://github.com/darrylwest/simple-node-logger).

The commons are complete enough to provide many components and flexible enough to allow other modules for logging, database, etc.  It mainly provides a framework for application configuration and startup.  With base classes for boot strap, config, application and service factories.

## Common Web Service Flow

![service-architecture]({{ site.url }}/images/web-service-architecture.png)

## Application Bootstrap

### The bin Folder

### Internal and External Configuration

### Application Factory

## Web Service API

## Data Service Layer





