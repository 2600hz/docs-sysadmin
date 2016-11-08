Some high-performance components in telephony require temporary storage. To scale, they require partitioning and clustering as well. And finally, the data must be consistent across the cluster.
This document describes our research in selecting an in-memory data store for this purpose.
Use Cases:
* Call Center
    - Keep track of who is logged in/out across the cluster
    - Keep track of what calls are in queue (not handled)
    - Keep track of last call time
    - Keep track of real-time incremental stats / trends
* Trunk Store
    - Current account balance (doing this on disk probably won't scale long-term)
    - # of in-use circuits
* Presence
    - bleh
* Troubleshooting
    - Last X registrations
    - Last Y calls
* System State
    - Number of calls up, per account
    - Number of calls up total
* Billing
    - $s made today
    - $s spent (hard costs) today
 
 
 
General Requirements:
    - If a server crashes or DC goes down, state is retained
    - Quick read/writes for constant activity
 
 
What the above have in common:
    - Need to store replicas across different data centers
    - Data is transient (comes 
 goes, often temporary / never stored)
    - Need to partition data
    - Needs to be as consistent as possible based on above
    - Needs to be fast
    - Automatic recovery abilities
    - Automatic partition
    - Still need this to fit on embedded hardware someday so small is the goal, or small memory footprints
 
 
 
Requirements:
- Write-heavy
- Need to be able to search primary keys
 
 
Choices:
 
Karl
- CouchBase
    You must declare why your solution is better then James's.
 
- Redis
 
James
- Scalaris: James
    You must declare why your solution is better then Karl's.
 
- Riak Database
    Pros: Erlang Natively, Handles the Distribution Assignments of Partitioned Data
    Cons: Persistent Store, not really designed for temporary
 
Jon: You are the judge!
 
How to Research:
* Email friends and family
* Email users of this for support of your points
* Read / skim the docs
* Install a test
 
THINGS YOU DON'T NORMALLY THINK ABOUT AND NEED TO:
* Idiots must be able to setup and view status and restart and reboot and manage a node on the cluster or a cluster
    * I don't care if they can see the data inside the cluster, that's for our software to do.
* Least amount of extra cruft on install (i.e. avoid Java, avoid 8283MB installs, large memory footprint, etc.)
* We must be able to upgrade without taking down the cluster
* Keeping everything in Erlang is nice :-)
 
 
