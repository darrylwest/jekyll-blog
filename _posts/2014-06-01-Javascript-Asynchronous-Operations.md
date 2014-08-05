---
layout: post
title: Javascript Asynchronous Operations
---
Javascript is single threaded.  That's good.  But to take advantage of our ever increasing multi-processor world, we need to adopt functional solutions.  Thats where asynchronous operations come in.

Javascript applications that run in the browser or in node have asynchronous events occurring all the time.  This is especially true in node where most actions return results through asynchronous callbacks rather than direct return values.  This takes some time to get used to.

Consider the following recursive function/snippet:

~~~
var list = getList(); 
var nextListItem = function() {
    var item = list.pop();
 
    if (item) {
        // process the item...
        nextListItem();
    }
};

nextListItem();
~~~

The recursive list item processor will work fine if the list is a reasonable size. But, if the list is huge, then one has to worry about the size of call stack. With every iteration it grows by one call, so it may exceed memory limits and fail (in a very bad way) if there are too many iterations. 

Now consider this small change: 

~~~
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
~~~

The stack over-flow problem is now eliminated. Why? Because javascript's event system handles the recursion–not the call stack. When nextListItem runs, if 'item' is true (not null) then the timeout function is defined and pushed to the event queue, then the function exits–and the call stack is now clear. When the event queue runs it's timed' out event, the item is processed and nextListItem is recursively called.

Again, the method is processed from start to finish without a direct recursive call, so the call-stack is again clear–regardless of the number of iterations. 

Now consider this example: 

~~~
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
~~~

As with most functional, asynchronous solutions, it's best to start at the bottom–the dao fetch of users. The fetch callback sets the user list then invokes the recursive nextUser() to get the iteration started. Then the user is updated asynchronously, and when it completes updateUpdateCallback is invoked. This callback continues the recursion by invoking nextUser. This is repeated until the list is empty.

There isn't a need for setInterval ( or nextTick() ) because the dao calls to update the user are asynchronous–always invoked from the event queue, not the call stack. So the call stack remains static no matter how many users are in the list. 

Its also important to realize that the function dao.updateUser doesn't really start working until nextUser has exited. It's queued to do some work, but not at the direction of the call stack–just the event queue. 

Asynchronous event driven operations.  Another reason to love coding in javascript.
