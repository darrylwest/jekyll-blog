---
layout: post
title: Javascript Coding Standards
---

I love coding in javascript. I love how it's flexible enough to be as expressive as you want.  The power of closures used in the traditional way or simply as function pointers like in the old C days.

Javascript's flexible nature enables an infinite combination of styles.  From prototypical, IIFE, to classical where functions are actually called "classes" when no actual classes exist.

This flexibility can lead to endless discussions of "what's best" or "what's most efficient" and worse can lead to project code that can resemble a big steamy bowl of pasta with brownish marinara.  As a team leader, the last thing you want is to have to code walk dozens of coding styles.  As a coder and team member the last thing you what to do is traverse hundreds of lines of code that has bad indentation or horrible style.

_**So, as a manager, you need to adopt a strict coding standard and ruthlessly enforce it.**_

### Coding Standard Objectives

Here is a short bullet list.  The standards should...

- match the team's current experience and talent,
- should closely follow at least one major published standard,
- should have justifications for each decision, and include team consensus.

### Team Experience

Javascript isn't new, but it's new to many programmers.  If your team has years of java and c++ experience, the wide-open flexibility of javascript will come as a frustrating surprise.  If your team has a ruby influence, then you have a leg up.  Understanding closures, dynamic typing, etc will ease the transition to production ready javascript.  If your team is primarily PHP based, then they know a bit about javascript but probably don't understand its full capability.


### For the Java Team

So lets begin with the java programming team--what standards would suite them best?  The choice is easy--use a classical implementation with factory generated components that implement IoC through parameter injection.  Think of it this way, every file is a class defined by a named function variable (the function is still technically anonymous).  Its injection is always through construction (think ruby opts), and always factory built.  Files are organized as pseudo-package folders that may (or may not) have package namespaces.

The coding style is very similar to the java specs.  K&amp;R formatting, title cased classes, mixed case variables, no underscores.  Complete separation of concerns, i.e. MVC plus services, delegates and factories.  And, unit tests--either TDD or BDD for everything.  And not just the normal tests, but also tests to find bugs that the compiler would normally find.  (mocha is probably the best test platform for both client and server javascript today).

### Published Standards

Douglas Crockford.  JSLint.  Javascript, the good parts.  If you can only read one javascript book, please read "the good parts".   Coding conclusions aren't drawn on what is best--just what the alternatives are.  But, he does describe what he feels are some best practices for coding style, indentation, curly braces, etc.  And, if you have the time, watch his video series on javascript.

For good published standards, start here:

- [google standards](http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml)
- [yahoo standards](http://javascript.crockford.com/code.html)

Standards you probably want stay away from: 

- if you are writing applications, the don't follow these standards; utility modules maybe, but... 
- M$ standards--known only to a few Seattle east-siders.

### Our Standards Document

Here is a link to our current javascript coding standards.  For the most part, this is for client applications, but most parts apply to node/server projects as well.

### Conclusions

My best advise is to find a good published standard, modify it for your team's abilities, then stick with it.  You will need to add rules as time goes on--because coders will always find differing ways to interpret the rules.  So be prepared for additions--not so much changes, just clarifications.

_Happy coding..._
