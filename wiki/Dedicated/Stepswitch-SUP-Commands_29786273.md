SUP Commands
 
sup stepswitch_maintenance flush
Stepswitch caches the properties of a number when it looks them up, including the account it belongs to. 
If the number is updated via the API it will be removed from the cache automatically. However, if a manual change is made you may want to flush the cache so it takes affect.
View Example
[root@apps001 example]# /opt/kazoo/utils/sup/sup stepswitch_maintenance flush
sup stepswitch_maintenance refresh
Stepswitch uses the 
offnet
 database which must be set up properly so resources can be queried (see CouchDB views). 
This command will ensure the database is present, properly configured to the version of Stepswitch and clean up any depreciated documents that might be present.
View Example
[root@apps001 example]# /opt/kazoo/utils/sup/sup stepswitch_maintenance refresh
sup stepswitch_maintenance reload_resources
Stepswitch monitors the 
offnet
 database for any changes (manual or API) and update the in-memory resource list. 
However, for older versions without this feature this command must be manually run on all servers with Stepswitch before new or updated resources are used.
View Example
[root@apps001 example]# /opt/kazoo/utils/sup/sup stepswitch_maintenance reload_resources
sup stepswitch_maintenance lookup_number 
NUMBER
When provided with a number Stepswitch will return the known parameters of that number. 
These are drawn from the local cache if present or looked up and cached if not. 
This provides insight into what account a number is associated with for inbound calls as well as if outbound calls to this number will stay on-net.
View Example
[root@apps001 example]# /opt/kazoo/utils/sup/sup stepswitch_maintenance lookup_number 4158867900
{ok,
43579fc0a3aa11e29e960800200c9a66
,[{force_outbound,false},{pending_port,false},{local,false},{inbound_cnam,false}]}


The return is formated as: {ok, ACCOUNT ID, LIST OF PARAMETERS}
Parameters:
force_outbound - If this is false when an account in the system calls this number it will no leave the Kazoo platform (known as on-net calls)
pending_port - If this is true then the number was created as a port request but no inbound request from the carrier has not 
occurred
 yet (port is not complete).
inbound_cnam - If this is true when inbound calls are made to this number a CNAM lookup will take place to update the caller id name in the US.
sup stepswitch_maintenance reload_resources 
NUMBER
This will return a ordered list of resource that would be attempted if the provided number was dialed.
View Example
[root@apps001-aa-ord example]# /opt/kazoo/utils/sup/sup stepswitch_maintenance process_number 4158867998
[{
bae2f840a3d311e29e960800200c9a66
,0,
sip:+14158867998@192.168.4.15
},{
bae2f840a3d311e29e960800200c9a66
,2,
sip:+14158867998@192.168.4.16
}]


The return is formatted as a list of: {RESOURCE ID, DELAY (in seconds), SIP URI}
