## Getting to Know BigCouch



## Manually Editing Database Documents

These are the steps required to complete a self install using any of the currently available methods ( Chef-Solo, Packages, or Source Installation). You will access most of these database documents by using the Futon web interface for **Bigcouch**. You can reach it by going to  http://ip.address:15984/_utils . Insert the IP Address of your server in the url. Currently we need to manually create the master account on a new deployment. Please replace the (ACCOUNTNAME SIP.REALM.COM USERNAME PASSWORD) placeholders with values that fit your environment.

`/opt/kazoo/utils/sup/sup crossbar_maintenance create_account ACCOUNTNAME SIP.REALM.COM USERNAME PASSWORD`

Open your browser and go to **BigCouch** Futon web interface. In the `system_config` database, verify that the `autoload_modules` list in the crossbar document is correct:
 
http://ip.address:15984/_utils/document.html?system_config/crossbar
 ```
"autoload_modules": [
    "cb_user_auth",
    "cb_simple_authz",
    "cb_vmboxes",
    "cb_schemas",
    "cb_connectivity",
    "cb_temporal_rules",
    "cb_webhooks",
    "cb_global_provisioner_templates",
    "cb_shared_auth",
    "cb_users",
    "cb_global_resources",
    "cb_phone_numbers",
    "cb_templates",
    "cb_signup",
    "cb_accounts",
    "cb_groups",
    "cb_limits",
    "cb_local_provisioner_templates",
    "cb_callflows",
    "cb_local_resources",
    "cb_faxes",
    "cb_configs",
    "cb_api_auth",
    "cb_braintree",
    "cb_whitelabel",
    "cb_onboard",
    "cb_conferences",
    "cb_directories",
    "cb_registrations",
    "cb_token_auth",
    "cb_clicktocall",
    "cb_media",
    "cb_menus",
    "cb_cdrs",
    "cb_servers",
    "cb_devices",
    "cb_queues",
    "cb_rates"
]
```

Add the FreeSWITCH nodes to the `ecallmgr` document in the `system_config` database. This will instruct `ecallmgr` on which servers to connect to on startup and also what commands to run. In this example, `ecallmgr` will connect to `server1.domain.com` and `server2.domain.com`, run the command `load mod_sofia` and reload the ACLs using the "acls" field. Note that your proxy servers (OpenSIPs or Kamailio) should be in the "authoritative" list while your DID providers should be in the "trusted" list.
 
http://ip.address:15984/_utils/document.html?system_config/ecallmgr
 ```
{
    "_id": "ecallmgr",
    "default": {
        "fs_nodes": [
            "freeswitch@server1.domain.com",
            "freeswitch@server2.domain.com"
        ],
        "syslog_log_level": "info",
        "fs_cmds": [
            {
                "load": "mod_sofia",
                "reloadacl": ""
            }
        ],
        "acls": {
            "Your Proxy server": {
                "type": "allow",
                "network-list-name": "authoritative",
                "cidr": "xxx.xxx.xxx.xxx/32"
            },
            "Your DID provider": {
                "type": "allow",
                "network-list-name": "trusted",
                "cidr": "xx.xx.xx.x/24"
            }
        }
    }
}
```
After performing any edits the database documents we will need to flush the cache and restart crossbar.
```
/opt/kazoo/utils/sup/sup whapps_config flush
/opt/kazoo/utils/sup/sup -n ecallmgr ecallmgr_config flush 
/opt/kazoo/utils/sup/sup whapps_controller restart_app crossbar
```
You can now point your browser to  http://ip.address to start using the **Kazoo** web interface. Use the credentials from Step 1 to log in, then hover on the white arrow next to your user and account info on the top right of the page and click on "App Store" to turn on the apps you want to use. Have fun and thanks for using **Kazoo**!
