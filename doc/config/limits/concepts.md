Limits : Concepts

How limits work...
Enabling limits:
Ensure the default values are appropriate in system_config/jonny5
And those are.... 
Ensure jonny5 is configured to start in system_config/whapps_controller
Ensure jonny5 is running
Ensure you have a "default_to" email address in system_config/notify.system_alert to receive notices
Set "authz_enabled" to true on system_config/ecallmgr
Set "authz_default_action" to either "allow" or "deny" on system_config/ecallmgr.  This is used when jonny5 fails to reply.
If you just want to test (and not actually limit) set "authz_dry_run" to true on system_config/ecallmgr.
LikeBe the first to like this
