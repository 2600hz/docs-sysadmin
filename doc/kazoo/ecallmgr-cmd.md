## Kazoo ECallMgr



Also, you are the only person receiving `low_balance` (code change).  I have also stopped the `jonny5` reconciler:
         
`sup jonny5_maintenance stop_reconciler`
 

## The following functions are now available for conferences:       

```
sup -necallmgr ecallmgr_maintenance conference_summary  

sup -necallmgr ecallmgr_maintenance conference_details
```


## To fix any errors there is also:
```         
sup -necallmgr ecallmgr_maintenance sync_conferences 

sup -necallmgr ecallmgr_maintenance sync_conferences freeswitch@server.com

```
## This brings the complete list to:        
```
sup -necallmgr ecallmgr_maintenance add_fs_node freeswitch@server.com       

sup -necallmgr ecallmgr_maintenance remove_fs_node freeswitch@server.com         

sup -necallmgr ecallmgr_maintenance node_summary

sup -necallmgr ecallmgr_maintenance node_details

sup -necallmgr ecallmgr_maintenance node_details freeswitch@server.com       

sup -necallmgr ecallmgr_maintenance authz_summary

sup -necallmgr ecallmgr_maintenance channel_summary

sup -necallmgr ecallmgr_maintenance channel_summary freeswitch@server.com

sup -necallmgr ecallmgr_maintenance channel_details

sup -necallmgr ecallmgr_maintenance channel_details 1913218612@192.168.1.133

sup -necallmgr ecallmgr_maintenance  sync_channels

sup -necallmgr ecallmgr_maintenance sync_channels freeswitch@server.com

sup -necallmgr ecallmgr_maintenance conference_summary

sup -necallmgr ecallmgr_maintenance conference_summary freeswitch@server.com

sup -necallmgr ecallmgr_maintenance conference_details

sup -necallmgr ecallmgr_maintenance conference_details b57f3183a8f11ba31b3b5163057e2adc

sup -necallmgr ecallmgr_maintenance sync_conferences

sup -necallmgr ecallmgr_maintenance sync_conferences freeswitch@server.com

sup -necallmgr ecallmgr_maintenance flush_node_channels freeswitch@server.com

sup -necallmgr ecallmgr_maintenance flush_node_conferences freeswitch@server.com

sup -necallmgr ecallmgr_maintenance flush_registrar

sup -necallmgr ecallmgr_maintenance flush_registrar bea1.sip.2600hz.com

sup -necallmgr ecallmgr_maintenance flush_registrar 105 bea1.sip.2600hz.com

sup -necallmgr ecallmgr_maintenance registrar_summary

sup -necallmgr ecallmgr_maintenance registrar_summary bea1.sip.2600hz.com

sup -necallmgr ecallmgr_maintenance registrar_details

sup -necallmgr ecallmgr_maintenance registrar_details bea1.sip.2600hz.com

sup -necallmgr ecallmgr_maintenance registrar_details 105 bea1.sip.2600hz.com

sup -necallmgr ecallmgr_maintenance flush_authn

sup -necallmgr ecallmgr_maintenance flush_util

```






 
 
