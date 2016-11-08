Don't lose your data
When using ETS tables, when the owner dies, typically the ETS table will be deleted as well. On some occasions, this is not desired behaviour. See 
Steve Vinoski's blog article
 for more.
Kazoo's Approach
We have an implementation of an ETS manager server process that will handle creating the ETS table, handing off control to the process that will actually use the table for work, receiving notifications when that process dies, and handing off control once a replacement process is available.
How it works
If you navigate over to 
kazoo_etsmgr_srv.erl
, you will find the gen_server code to manage an ETS table. To make use of the server, here's the typical steps involved:
Define the ETS properties
Define the ETS table's name
Define the find_me_function, a function that returns either the PID of the new process to pass control to, or 'undefined' if no process is ready to assume control yet.
Define the table_options; see 
ets:new/2
 for those.
Define the gift_data; typically this is ignored.
Start the manager process in the supervisor
Handle gaining control of the ETS table from the manager process
How it might look
This might go in your gen_server, gen_listener, etc
1. Defining the ETS properties
-export([table_id/0
         ,table_options/0
         ,find_me_function/0
         ,gift_data/0
        ]).
 
table_id() -
 ?MODULE. %% Any atom will do
table_options() -
 [].
find_me_function() -
 whereis(?MODULE).
gift_data() -
ok
.
This might go in your application's supervisor
Start the manager process
-define(CHILDREN, [?WORKER_ARGS(
kazoo_etsmgr_srv
, [[{
table_id
, your_srv:table_id()}
                                                       ,{
table_options
, your_srv:table_options()}
                                                       ,{
find_me_function
, fun your_srv:find_me_function/0}
                                                       ,{
gift_data
, your_srv:gift_data()}
                                                    ]])
                   ,...
                  ]).
In your gen_server/gen_listener, handle receiving control of the ETS table
Gain control
handle_info({
ETS-TRANSFER
, TableId, From, GiftData}, State) -

  %% Now this process can write to the ETS table
  {
noreply
, State};
 
Now your process should be all set to write to the ETS table (and you can do the reads in the calling processes to parallelize reading, unless you want to serialize the reads through the server as well).
