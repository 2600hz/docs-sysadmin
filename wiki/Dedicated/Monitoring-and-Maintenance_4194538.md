Connect to the erlang whistle_apps shell
 
whistle_apps/conn-to-apps.sh
 
Flushing the cache (callflows, CID, ect)
 
wh_cache:flush()
.
 
Flushing the config (db cached system config)
requires restart of sysconf whapp
 
whapps_config:flush()
.
whapps_controller:restart_app(sysconf)
.
 
Erlang-based Application list (full)
 
application:which_applications()
.
 
Start, stop WhApps and verify running WhApps
 
whapps_controller:start_app(crossbar)
.
whapps_controller:stop_app(crossbar)
.
whapps_controller:running_apps()
.
 
Determine which couchdb/bigcouch server it is connected to
 
couch_mgr:get_host()
.
couch_mgr:get_creds()
.
 
Forcing Compaction
 
couch_compactor:start_link()
.
couch_compactor:force_compaction()
.
 
Determine which rabbimq you are connect to
 
amqp_mgr:get_host()
.
amqp_mgr:is_available()
.
 
Stepswitch Commands
 
stepswitch_maintenance:reconcile()
.
stepswitch_maintenance:reconcile(ACCOUNT_ID)
.
stepswitch_maintenance:reload_resources()
.
stepswitch_maintenance:lookup_number
(
5552223333
).
stepswitch_maintenance:process_number
(
5552223333
).
 
Whapps Maintenance (useful for updating the global views in BigCouch on an install)
 
whapps_maintenance:refresh()
.
whapps_maintenance:refresh
(
Account ID
).
 
NOTE: THIS REPLACED 
crossbar:refresh()
.
Callflow Refresh Command (useful for after upgrade)
 
callflow_maintenance:refresh()
.
 
Whistle Number Manager (iterates thru each account checking all DID's exist in the numbers db)
 
whistle_number_manager_maintenance:reconcile()
.
