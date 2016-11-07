#
Database Design

Created by Darren Schreiber on May 13, 2012 Go to start of metadata
Perform a Google search for "NoSQL vs. SQL", "CouchDB vs. MongoDB", "MySQL vs CouchDB" and other such similar comparisons and you'll get a slew of results, most of which will contradict each other. Let's be clear: we looked at and IMPLEMENTED prototypes of each and every one of these before making our decisions, so that we could decide with a level, non-biased, informed result. The winner was Couch.
We had a bunch of simple requirements based on our past experiences:
1. We need to be able to upgrade the database schema without taking down the database. This directly relates to our goal: phones can never go down - not for maintenance, configuration changes or upgrades.
2. We need to be able to scale to large numbers of endpoints. This most likely would happen over distributed systems, so automatic sharding (segmenting) was a must, with re-balancing near after.
3. We need to be able to query data in changing ways - reports, CDRs, configurations will likely need to be retrieved and displayed in varying manners as we grow.
4. We need to fit on small and large equipment comfortably (from memory to diskspace)
5. We need an easy way for people to access the raw data to look for errors or make direct modifications
6. We need something that's easy to install and get up and running
7. We need something that's resilient in the event of a failure (both in terms of software and hardware)
8. We need something that includes many-master writes and replication
9. We need something that's easy to backup
10. We need something that's easy to cluster
11. We need something that's easy to replicate data with, for both backups and splitting of data
We were OK with:
1. Eventual consistency (i.e. a configuration change on a phone might take a few seconds to propagate to all nodes)
2. Nodes going offline randomly
3. The requirement of more then a few servers (most people are used to putting a PBX on one server only)
MySQL was ruled out pretty quickly on #1, #5 and #8 (as it's not with sharding and on disk). In addition, to achieve #5, #6 we would need third-party GUI tools most likely.
MongoDB fit almost all these items but, at the time, didn't have sharding or multi-master replication.
But BigCouch, which allows CouchDB to be used with sharding and other items, was the clear winner. It had all the items listed above.
Schema-less
blue.box confirmed that the structure of our data was dynamic enough that updates occurred with some regularity; it also reconfirmed the pain caused by upgrading the schema of tables in a relational database.
With CouchDB, the concept of a schema (if any) is a purely application-level enforcement. Flexible, easily-read JSON objects comprise CouchDB documents; views utilizing map-reduce routines break down the collection of documents into targeted representations of your data. For instance, each device has a section for SIP credentials. These credentials are aggregated from all devices in all accounts to a SIP credentials database, which has a view that extracts the salient data, which is then queried by the Registrar WhApp to verify a registering device's credentials.
An additional benefit is that, since you can host your data, you can augment the documents with your own custom data (perhaps provided and consumed by your custom REST client that interfaces with Crossbar) without losing the functionality of the WhApps we and others provide.
Replication, replication, replication
The ability to quickly and easily shard your databases to other clusters hosted in all sorts of different environments. If Client A wants an on-premise server, no problem; replicate from your master BigCouch cluster to their premise server just the account databases associated with Client A. When the various WhApps are started, the documents from just Client A's databases will be replicated to their local versions of the aggregation databases. Plus, should their premise server go down, they can always fail back to your master cluster.
Replication also enables you to be strategic in where you host your clusters. If you have a large swath of customers in the Pacific Northwest, locating a BigCouch cluster in a data center in that geographic location and replicating all clients located there should reduce latencies when doing reads and writes to the cluster. With catastrophic failures, as if the entire data center(s) go down, requests can fail over to another data center in a geographically disparate area. Small increases in latency but continued service vs being completely down goes a long way in pleasing the customer.
Why BigCouch

CouchDB does not natively do clustering; BigCouch adds a nice layer of clustering on top of the already great replication and storage of CouchDB. With BigCouch, partitioning databases across several nodes increases data availability (because nodes inevitable come and go), making sure you can continue to route calls, but also so you can increase storage capacity seamlessly without the applications using the cluster being aware of it.
What are we modelling?
Our modelling was based on a few concepts that exist regularly in the phone world:
1. Distributed and nested identifiers. A unique identifier (like a device's ID) might be associated with lots of items, such as caller ID, voicemail, dialplan, etc. In typical phone systems you can often accidentally delete something like a device ID and, because the database doesn't make it easy to find all uses of that device, you break something else like a voicemail box or a dialplan without realizing it. We needed a way to search deeply for occurrences of identifiers across varying schemas, even when the schemas changed as new features were introduced.
2. Binary and ASCII data. We wanted a way to store, stream, replicate and manipulate both binary and ASCII metadata.
3. Increasing feature sets. Customers constantly want more features in the phone world. Typical phone systems are hard to upgrade and upgrade cycles are lengthy. We want short, simple, reliable upgrades.
4. Increasing ability to isolate features. Customer A wants one feature while customer B wants the same feature handled slightly different. We previously achieved this with blobs allowing random metadata, but this was unacceptable because it was hard to search (see #1). We also achieved it with separate database schemas per customer but this was hard to manage (see #3). We needed the ability to have separate AND aggregated data at times via some mostly-automated process.
Our Testing
Our graphical statistics are pending, but we took MongoDB and CouchDB for the heaviest ride. We tested the following items:
1. Inserting millions of database records into the system as fast as we could. MongoDB actually accepted the records and buffered them faster but it turned out it had a threshold where it wasn't writing them to disk fast enough and the buffer would fill too quick if that speed was sustained.
2. Crashing Couch/Mongo intentionally at random points to measure their recovery
3. Clustering Mongo and Couch to see how we could do master/master/master and how replication would synchronize conflicts and other issues
4. Ensuring that views and JSON schema would actually work for us in terms of upgrading schemas in-place, including views
We found Mongo had a lot of friendly built-in features we were used to in MySQL like counting (document-based counts) and deletes and searches, but CouchDB was more flexible and friendly when it came to replication, spinning up new servers and sharding. BigCouch tied things together even better, so it was the clear winner.
