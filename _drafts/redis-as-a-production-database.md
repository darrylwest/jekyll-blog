---
layout: post
title: Redis as a Production Database
---

Redis has now moved from a simple replacement for memcache to a full-blow production database for non-SQL applications.  A production database must support some level of query capabilities, which in turn requires indexing.  For SQL this is done for you--in Redis, it's a manual approach.  The tradeoff is superiour scalability and speed.

For small to medium datasets querying in Redis is done through simple iteration and filtering, analogous to SQL's full-table scans.  When the dataset becomes large, indexing can be used to reduce the amount of data to be scanned and filtered.   Indexes can be by created by domain, similar to SQL's table indexes, or they can by defined by other criteria such as by organization where your application has many organizations stored in the same Redis db.  

## Consider this use case...

A single application has many sales organizations, each having multiple sales reps and thier own customer/contact lists.  Each sales rep has multiple sales initiatives with multiple projects per initiative.  Each project has multiple teams with multiple team members.  Each project also has multiple milestones, deliverables and resources.

An initiative typically has 6 projects.  A project has 8 teams, each with 2 to 4 team members.  A project typically has 4 milestones and 6 deliverables with 10 resources.  If a sales org has 10 reps that support 5 new initiatives per week, a years worth of data would create 10 sales reps times 5 initiatives per week = 50, or about 2,500 initiatives per year.  This volume would generate about 15,000 projects, 120,000 teams, 360,000 team members, and 300,000 milestone/deliverable/resource events.

Multiply this by 10 sales organizations and we start to reach very large numbers.

## Query Definitions...

For the most part, the application user wants to find initiatives that they are responsible for, i.e., a sales rep need to be able to quickly locate initiatives that they are working on or responsible for.  Considering that, we can create an initiative index for each sales rep.  When the rep queries for an initiative either by company, date, name, or whatever, the iteration would be across their own index, not the entire set.  A sales manager may have 10 reps that report to him, and would need an index specifically for his use that included all initiatives for his sales reps.  This still reduces the set to a managable amount for filtered queries.

Another feature of the application is syncing data between the primary database and the user's device.  For the most part, initiatives are always in sync because they are created by the user on their device.  But customers and contacts are created off-device, sometimes through data feeds from customer management systems.  To keep that data in sync, a sales org would have a list of recent customer and contact updates to be pulled by date.  Typically a sales rep logs in each day, and the sync happens then.  Other times, a simple periodic sync could be used.  Or a message could be sent to the client device indicating new customer/contact data is available.  The recent update queue would be queried by date and the new data loaded from the main database.




