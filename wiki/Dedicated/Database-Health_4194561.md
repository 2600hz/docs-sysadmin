Kazoo utilizes Cloudant's BigCouch database software. BigCouch allows for clustering the powerful Apache CouchDB product. This is what allows your cluster to scale across multiple servers, zones and continents.
BigCouch is a NoSQL, append-only database. Information is never deleted when updated or changed. Instead, revisions are continuously written to an ever-expanding file. Previous versions of data are always accessible.
Compaction
Writing to an ever-expanding file will eventually exhaust all your diskspace. Therefore, a process known as compaction (which is really just a glorified database copy) is performed periodically. During this process, a database's latest non-deleted contents are copied to a new file, resulting in only the latest data being preserved. When the copy is complete, the old database is destroyed and the new, smaller (compact) database takes the place of the old database. This all happens seamlessly once compaction is started.
Compaction should be performed continuously, preferably during low-activity times, on any CouchDB database. Compaction must be started by the software application using the database.
Kazoo normally takes care of compaction for you, running continuously in the background and traversing each database in the system periodically, making the contents smaller as the cluster grows.
When using the commands below, if you are working with a specific account database, the account ID and database name must be entered as: 
account/ab/cd/3084a2394ddc820482b09420
 
Checking Compaction is Working
There are two ways to see if compaction is running. First, check the config:
sup whapps_config get whistle_couch compact_automatically
Then check to see if the compactor process is running:
sup couch_compactor_fsm status
You should see a response like
{ok,[{node,
bigcouch@db001-abc-server.2600hz.com
},
 {db,
offnet
},
 {wait_left,9178},
 {queued_jobs,none}]}
This is good news! Automatic compaction is running. Based on the above, it's working on db001-abc-server.2600hz.com and currently compacting the offnet database.
If instead of a pid you saw 'undefined', then its not running.
 
Configuring Couch Compaction
Couch compaction is set as a variable in the system configuration whistle_couch document. You will need to have 
compact_automatically
 : 
true
 in your whistle_couch document, as such:
{
   
_id
: 
whistle_couch
,
   
default
: {
       
compact_automatically
: true,
       
sleep_between_poll
: 5000,
       
sleep_between_compaction
: 60000,
       
max_wait_for_compaction_pid
: 360000,
       
bigcouch_cookie
: 
couch_cookie

   }
}
 
If you change the compact_automatically value you'll need to reload the system configuration documents that are in-memory and then restart Couch Compactor:
sup whapps_config flush

sup couch_compactor_fsm stop_auto_compaction
sup couch_compactor_fsm start_auto_compaction
 
Forcing Compaction Manually
You can not manually compact a database while auto compaction is running. If you must compact a database manually, you must first stop auto-compaction with
sup couch_compactor_fsm stop_auto_compaction
sup couch_compactor_fsm cancel_all_jobs
 
Make sure that worked:
sup couch_compactor_fsm status
You should see {ok, ready}
 
Then run your manual compaction. When manual compaction is complete, re-start auto-compaction.
 
Sometimes you have a lot of databases and one has grown too big too fast, or some other emergencies prompts manual compaction. You can run one time compaction with one of these options (only choose one):
1
 sup couch_compactor_fsm compact_db 
some_db
     # compact the DB 
some_db
 across all known DB servers
 
2
 sup couch_compactor_fsm compact_db 
bigcouch@db1.somehost.com 
some_db
     # compact the DB 
some_db
 on the server db1.somehost.com
 
3
 sup couch_compactor_fsm compact_node 
bigcouch@db1.somehost.com
       # compact the all DBs on the DB server

 
You can verify your job has been queued by running:
 
4
 sup couch_compactor_fsm status
Monitoring Couch Compactor
To determine what the compactor is up to, you can grep the logs for either 
couch_compactor
 or the pid # from the above commands.
The speed of compaction is a function of the size of the DB shard on disk, plus the pause time in between shard compactions. It defaults are to poll every five seconds while compacting a shard, then to wait 30 seconds until starting to compact the next shard (it defaults to 60 seconds, check system_config for values on your system).
Troubleshooting The Compactor
Improper Cookie
If you receive an error like:
1
 couch_compactor_fsm:compact_db(
bigcouch@db.somehost.com
,
some_db
).
** exception error: no match of right hand side value {error,{conn_failed,{error,econnrefused}}}
     in function  couch_util:get_new_conn/3
     in call from couch_compactor:get_conns/5
     in call from couch_compactor:compact_db/2
This means the cookie we have store for your Bigcouch nodes is wrong. On your DB server, in /opt/bigcouch/etc/vm.args, there's a 
-setcookie YOUR_COOKIE
 line that you will need to look up. Once you have that value, the following steps should get you going:
sup whapps_config get whistle_couch bigcouch_cookie         # returns the wrong cookie

monster


sup whapps_config set whistle_couch bigcouch_cookie 
YOUR_COOKIE
        # Fix the cookie
{ok,...}

sup whapps_config get whistle_couch bigcouch_cookie           # returns the right cookie, confirming the fix!

YOUR_COOKIE
 
Ignorable Warning
When you run the compaction commands manually, or with the whapps shell in dev mode, you may see warnings like:
5
 couch_compactor_fsm:compact_db(
bigcouch@db01.somehost.com
,
some_db
).
=ERROR REPORT==== 16-May-2012::23:39:09 ===
global: 
whistle_con_1337211446@whapps.somehost.com
 failed to connect to 
bigcouch@db01.somehost.com

=ERROR REPORT==== 16-May-2012::23:39:09 ===
global: 
whistle_con_1337211446@whapps.somehost.com
 failed to connect to 
bigcouch@db02.somehost.com

=ERROR REPORT==== 16-May-2012::23:39:10 ===
global: 
whistle_con_1337211446@whapps.somehost.com
 failed to connect to 
bigcouch@db03.somehost.com

=ERROR REPORT==== 16-May-2012::23:39:10 ===
global: 
whistle_con_1337211446@whapps.somehost.com
 failed to connect to 
bigcouch@db04.somehost.com

done


These are mostly-ignorable errors; if compaction runs despite their presence, they are of little consequence.
 
Couch Compactor Internals
Currently, Couch Compactor is a long-running process that runs constantly through the list of known BigCouch nodes, locates the names of the shards within each node, locates the names of the design documents in each database, and chooses whether to compact said database or view based on two criteria: minimum disk size, and ratio of disk size to dataset size.
The size of a database varies between the actual dataset and the size the database occupies on disk. This is because old revisions of documents are not removed from disk until a compaction has been triggered. As such, it is not uncommon to see a 10MB dataset occupy 5GB of disk space (if new documents are frequently created or current documents updated frequently, for instance). Compaction removes the stale revisions from disk, freeing that space back up to the operating system.
The compaction routine can be manually triggered using the 
couch_compactor_fsm:force_compaction/{0,2
} function call. 
couch_compactor_fsm:force_compaction/0
 is the equivalent of calling 
couch_compactor_fsm:force_compaction(0,1)
. The two parameters are the minimum disk space and the ratio of disk-space/dataset. If set higher than 0, minimum disk space, or MDS, disregards any database or design that occupies less than the MDS. This is a simple way to ignore trivial databases, especially ones with a minimum number of documents and changes.
The more interesting parameter is the ratio of disk-space/dataset. The more a database changes, the larger the ratio becomes, and the more disk space that can be reclaimed through compaction. Not much benefit is gained by compacting a database with a ratio of 2, but a ratio of 500 suddenly becomes quite meaningful in terms of disk space freed.
The force_compaction/2 allows you to play with the settings to tailor the impact of a compaction run (running compaction is not without cost, in CPU and temporary disk space utilization). This force_compaction/2 function can be used to reclaim disk space on a busy BigCouch node that is reaching critical levels in free disk space.
If you want to compact a single database, you can call 
couch_compactor_fsm:compact_db/1
, passing the unencoded (so 
foo/bar
 instead of 
foo%2Fbar
) version of the database (the compaction will be run with MDS=0 and ratio=1).
In all compaction routines, there is a self-imposed, random delay of 1-10 seconds between compactions, so as to not overload a node with requests. A compaction includes compacting the database, the views, and the view index (see 
CouchDB compaction
 for more).
For maximum effectiveness, a little setup is necessary to enable couch_compactor to peek behind the HAProxy veil. There is a config paramater (settable at runtime as well) in 
whistle_couch/priv/startup.config
 called 'bigcouch_cookie'. Set this config parameter to the cookie you setup your BigCouch nodes with (or set it via 
couch_mgr:set_node_cookie/1
), and couch_compactor will be able to directly connect to the individual BigCouch nodes to compact their sharded databases.
