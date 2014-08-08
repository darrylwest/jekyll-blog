---
layout: page
title: About
---

I am currently Director of Engineering for Roundpeg.  I manage a small international group of software engineers working on custom web applications.  My duties include software architecture, team management, and implementation of customer facing web solutions for mobile and desktop users.  Our projects specialize in medical publication and learning management systems for on-line education but also include web applications for real-time control applications (my roots).

Our technologies include javascript for single-page client applications targeted for mobile and desktop.  We use REST and socket technologies to commuicate with our backend services written in node.  Prior to 2014 our servers were written in groovy using embedded jetty as the web container but used the same REST data-exchange structure as our node projects.

All of our projects are hosted on Amazon using EC2 (centos 6), S3, SES, SQS and MySQL RDS for primary database.  We also use redis and leveldb for caching and temporary storage.  Our production servers are hosted behind Amazon's load balancers as well as cloud front for static file delivery.  Each EC2 server has a number of services running on various ports and reverse-proxied using haproxy.  

We use lightweight services based on node and embedded jetty allowing us to have many services running on a single machine (usually a small but sometimes micro instance).  Applications are easily scaled up to thousands of users by adding more EC2 instances behing the load balancer.  Scaling down is also as easy as switching off machines when loads are light.

I also am responsibile for creating and publishing coding standards for our team.  These standards include frameworks for both client and server applications and unit/integration testing minimums.  Our documents cover javascript MVC client framework, node MVC server framework, groovy/jetty web container framework, and work-flow   expectations for git and subversion.  A common thread throughout all the frameworks is to prioritize unit and integration testing to insure high quality projects.  As of 2014, all of our projects require 100% test coverage.

## Rain City Software

As president and owner of Rain City Software, Inc, I managed the full life cycle development of a wide range of business applications including reservations, front desk, back office, night audit modules for hospitality and interim housing, order taking, picking and fulfillment, invoicing, inventory control, purchasing and customer relations management for retail/wholesale, distribution and scheduling for office copier leasing and maintenance, and other business related projects.  As an independent contractor I often worked on multiple projects concurrently.

Between 2006 and 2009 I worked for The Code Works implementing custom projects for Robert Half.  The software was primarily java client/server with Hibernate/Spring/WebLogic on the backend.  My projects included identity services, low-level pessimistic locking framework, and multi-tabbed input panels using swing components.

Between 2000 and 2006 I worked on a large project for Sun Microsystems providing a solution that enabled them to track high-dollar hardware scheduled for trade-in return. The Sun project uses Java/Groovy, Apache/Tomcat, XML, J2EE, Java Mail, I-Planet, Oracle 9i and Solaris. It includes a public web site and internal intranet based java application (swing based) that is running on Solaris, Windows NT/2K/XP, Linux, and Mac OSX and supports English, Spanish, French, German and Japanese.

Prior to working at Sun, I was on a multi-year project that managed and developed two hospitality related systems, one for Encore Computers, another for the US Suites, and a third project for The Hotel Alternative. These applications are windows based products using SQL Server/VC++ and Java for e-commerce and internet applications.

Highly experienced in UNIX development environments using Informix SQL/4GL. Typical systems were 20 to 50 users, and included General Accounting modules that fully integrated with specialized front-end modules. Development of all modules was done by Rain City Software using our own automated code generation tools, written in Perl. Smaller projects such as menu systems, specialized interfaces were created in C, as well as Perl, shell, awk, and other UNIX utilities.

Summary of programming languages include Javascript, Java, Swing, REST, XML/SOAP, Servlets, JDBC, UNIX shell, postscript/PDF, Perl, C, C++, Pascal, Forth, Intel and Rockwell assembly languages. Databases include Mongo, Redis, Oracle, MySQL, SQL Server, Informix SQL/4GL, and Sybase. Operating systems include Solaris 8/9, Linux, UNIX System 5, AIX, and Berkeley 7, and MS Windows NT/2K. Lifecycle tools include git, Subversion, CVS, RCS, MS SourceSafe, Erwin ER diagramming, Poseidon UML, JUnit, Ant.  Search engines include Solr/Lucene and custom search solutions.

## Photography

I'm an amature.  But I love photography and image processing.  And thanks to the mentoring of my amazing Berkeley neighbor Daniel Moore I'm actually able to get some good shoots.   If you're interested, visit [my flickr site](https://www.flickr.com/photos/darrylwest/sets/) to see some of my work.  Here's a small sample...

> Sasha on a windy day...
![sasha]({{ site.url }}/images/sasha-windy-b+w.jpg)

> Pirate Sunset...
![pirate]({{ site.url }}/images/pirate-sunset.jpg)

> Bay Bridge Fog...
![bay bridge]({{ site.url }}/images/bay-bridge-fog.jpg)

> Bay Flight...
![bay flight]({{ site.url }}/images/bay-flight.jpg)

## Cirrus Pilot

I was lucky enough to be able to fly our small SR20 all across the US from Duluth to Seattle, down to Portland, and eventually to the Bay Area.  Being an instrument rated pilot gave me the opportunity to fly and see places on the Oregon and California coast, Arizona, Grand Canyon, Utah, and New Mexico.  Great fun.

## Contact me

[darryl.west@raincitysoftware.com](mailto:darryl.west@raincitysoftware.com) \| skype: cirruspilot \| twitter: @cirrus1426c

~~~

~~~


