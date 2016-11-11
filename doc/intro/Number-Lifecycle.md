**Number Lifecycle**

This document describes the lifecycle of direct inward dialing (DID) numbers.
  
Figure
Discovery

This is an internal number state used to temporarily hold information regarding numbers users can acquire from the system owner carriers.

Populated (usually) by API requests to the carriers.  

Does not participate in number hunts.

No accounts have authority to transition to/from this state.

There are no public fields for discovery numbers.
Any account can transition an available number to reserved.

**Port In**

This is a temporary state for a newly added number by an account via the porting API.
Automatically transitions to `in_service` the first time hunted by the system (first call to it). Does not participate in the off-net number hunt, meaning it is only used to route inbound and will not keep calls on-net. No accounts have authority to transition to/from this state.

Any account can create a `port_in` number if it does not exist in the system.
The public fields of a `port_in`number can be managed by the assigned account or an ancestor of the assigned account.
Only numbers in the `port_in` state allow the porting documents to be managed.

These numbers can only exist in states: 

`in_service`, `port_out`, and `disconnected`. None of these transitions can be preformed by accounts.
 
**Available**

This is a number that has been routed to the cluster but has no account assignment.
Any account can transition these numbers to `reserved` or `in_service` if they wish to obtain control of it.  
Does not participate in number hunts. Any account can transition an `available` number to `reserved`.
Any account can transition an `available` number to `in_service` if it is not of type `wnm_local`.
There are no public fields for available numbers, but they can be created during a transition.
  
**Reserved**

This is a number that an account has acquired for themselves or their children.  Some accounts can create reserved numbers.
*Does not participate in number hunts.* Numbers coming from the discovery state will be acquired via the carrier modules.
An account can transition a reserved number to `in_service` if one of the following criteria is met:

The requesting account is the same as the assigned account.

The requesting account is an ancestor of the assigned account.

The requesting account is an descendant of the assigned account.

The new account assignment is the same or a descendant of the current assignment.

An account can reserve a 'reserved number' if one of the following criteria is met:

The requesting account is an ancestor of the assigned account.

The requesting account is an descendant of the assigned account.

The new account assignment is a descendant of the current assignment.

When a number is reserved the new assignment is added to the history of assignments.

A flagged account can create a reserved number of type `wnm_local`.  

These numbers can only be acquired and managed by the creating account or a descendant.

E911 assignments will be maintained, if present.
The public fields of a reserved number can be managed by the assigned account or an ancestor of the assigned account.
  

**In Service**

This is a number that belongs to an account.

*Participates in number hunts.*

An `in_service` number can be transitioned to `reserved` if the requesting account is, or an ancestor of, the assigned account for the number.

E911 assignments will be maintained, if present.

The public fields of an `in_service` number can be managed by the assigned account or an ancestor of the assigned account.


**Released**

This is an aging state that numbers added to the system via discovery remain for a period of time till moving back to available to start the cycle again.

*Does not participate in number hunts.*

If a `reserved` number is released:

With an assignment history it remains `reserved` but is re-assigned to the previously assigned account.

Without an assignment history and is of type `wnm_local` it transitions to disconnected.

Any other type completes the transition to released.

If an `in_service` number is released:

With an assignment history it becomes `reserved`and is re-assigned to the previously assigned account

Without an assigment history and is of type `wnm_local` it transitions to `disconnected`

Any other type completes the transition to `released`

The public fields of an released number are removed.

Released numbers can be transitioned to  available by the system or system admin accounts only.

E911 is disconnected, if present.
  
  
**Port Out**

This is an administrative step to releasing numbers. It operates like 'Port In' except that inbound requests do not move it to In Service.


**Disconnected**
This is an internal number state, and marks the number for a permanent move from the active datastore to the archive.
 
