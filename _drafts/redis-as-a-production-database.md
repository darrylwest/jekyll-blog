---
layout: post
title: Redis as a Production Database
---

Redis has now moved from a simple replacement for memcache to a full-blow production database for non-SQL applications.  A production database must support some level of query capabilities, which in turn requires indexing.  For SQL this is done for you--in Redis, it's a manual approach.  The tradeoff is superiour scalability and speed plus maximum control over index composition.

For small to medium datasets querying in Redis is done through simple iteration and filtering, analogous to SQL's full-table scans.  When the dataset becomes large, indexing can be used to reduce the amount of data to be scanned and filtered.   Indexes can be by created by domain, similar to SQL's table indexes, or they can by defined by other criteria such as company or organization where your application has many organizations stored in the same Redis db.  

## Consider this use case...

A single application has many sales organizations, each having multiple sales reps and thier own customer/contact lists.  Each sales rep has multiple sales initiatives with multiple projects per initiative.  Each project has multiple teams with multiple team members.  Each project also has multiple milestones, deliverables and resources.

An initiative typically has 6 projects.  A project has 8 teams, each with 2 to 4 team members.  A project typically has 4 milestones and 6 deliverables with 10 resources.  If a sales org has 10 reps that support 5 new initiatives per week, a years worth of data would create 10 sales reps times 5 initiatives per week = 50, or about 2,500 initiatives per year.  This volume would generate about 15,000 projects, 120,000 teams, 360,000 team members, and 300,000 milestone/deliverable/resource events.

Multiply this by 10 sales organizations and we start to reach very large numbers.

## Query Definitions...

For the most part, the application user wants to find initiatives that they are responsible for, i.e., a sales rep needs to quickly locate initiatives that they are working on or responsible for.  Considering that, we can create an initiative index for each sales rep.  When the rep queries for an initiative either by company, date, name, or whatever, the iteration would be across their own index, not the entire set.  A sales manager may have 10 reps that report to him, and would need an index specifically for his use that included all initiatives for his sales reps.  This still reduces the set to a managable amount for filtered queries.

Another feature of the application is syncing data between the primary database and the user's device.  For the most part, initiatives are always in sync because they are created by the user on their device.  But customers and contacts are created off-device, sometimes through data feeds from customer management systems.  To keep that data in sync, a sales org would have a list of recent customer and contact updates to be pulled by date.  Typically a sales rep logs in each day, and the sync happens then.  Other times, a simple periodic sync could be used.  Or a message could be sent to the client device indicating new customer/contact data is available.  The recent update queue would be queried by date and the new data loaded from the main database.

## Creating Indexes

The easiest way to create an index is with a named set where the name includes an identifier, such as SalesOrg, SalesRep, Project, etc.  To create an index of all initiatives belonging to a specific SalesOrg, you would create a key = SalesOrgInitiatives:<id> where <id> is the SalesOrg's unique identifier.  The set would be populated with initiative identifiers.  A simiar approach would be used to create indexes for projects, or InitiativeProjects:<id> where <id> is the initiative's identifier.  The list would be populated with project identifiers.

~~~
var projectList = [ 
	'd8d6dafe9c054059a701c0760172476e', 
	'fa998524df34434393a7b33c3fdc6135', 
	'84b9cbef36324122827c9d4ea35165f1', 
	'ebacd1e217634863a1a3ab101ad428eb' 
];
var initiative = new Initiative({ id:'cba0058c271149c088120e5744e83b30' , name:'My Initiative' });

var client = RedisClient();
var key = 'InitiativeProjects:' + initiative.id;
client.sadd( key, projectList, function(err, result) {
	if (err) throw err;
	console.log('index created')
});
~~~

As projects are added or removed from an initiative, the index is updated to stay in sync.  This is easily done by overriding the project DAO's insert/update methods like this:

~~~
// in the project DAO...
this.insert = function(client, project, callback) {
	var indexUpdateCallback = function(err, model) {
		if (err) return callback(err);
		
		var indexKey = 'InitiativeProjects:' + project.initiative.id;
		client.sadd( indexKey, project.id, function(err, result) {
			if (err) return callback( err );
			
			// return the new project data model
			callback( null, model );
		});
	};
	
	super.insert(client, project, indexUpdateCallback);
};
~~~

Or a faster implementation would be to index in the background like this...

~~~
this.indexUpdateCallback = function(err, result) {
	if (err) {
		log.error( 'index update error: ', err)
		// queue and index re-build
	}
};

this.insert = function(client, project, callback) {
	var insertCallback = function(err, model) {
		if (err) return callback( err );
		
		var indexKey = 'InitiativeProjects:' + project.initiative.id;
		client.sadd( indexKey, project.id, dao.indexUpdateCallback );
		
		callback( null, model );
	};
	
	super.insert(client, project, )
};
~~~

Or from a data service outside the DAO...

~~~
// inside the project DAO
this.updateProjectIndex(client, project, callback) {
	var indexKey = 'InitiativeProjects:' + project.initiative.id;
	client.sadd( indexKey, project.id, callback );
};
~~~

This is probably the best choice.

## Query With Index

Now that we have a set of InitiativeProject indexes, the project DAO's query implementation would be refactored to this...

~~~
// inside ProjectDao
this.queryByInitiative = function(client, initiativeId, completeCallback) {
	var queryCallback = function(err, list) {
		if (err) return completeCallback( err );
		
		var projects = list.map(function(project) {
			return new Project( project );
		});
		
		completeCallback( null, projects );
	};
	
	var indexCallback = function(err, idList) {
		if (err) return completeCallback( err );
		
		var keys = idList.map(function(id) {
			return dao.createDomainKey( id );
		});
		
		client.mget( keys, queryCallback )
	};
	
	var indexKey = 'InitiativeProjects:' + initiativeId;
	client.smembers( indexKey, indexCallback );
};

~~~

This replaces the original default code that called super.query() which returns the entire list of projects then filters them out by initiative id.  Much faster this way with relatively small bit of additional code.  And it provides a good pattern for creating indexes for other queries as well.

## Conclusions

Once you wrap your head around how Redis works, it's easy to apply SQL rules to create a rich set of query options.  The main difference is that you need to know up front what the queries will look like, then augment them with filtering.  This approach is way faster and more scaleable than the SQL counterpart.






