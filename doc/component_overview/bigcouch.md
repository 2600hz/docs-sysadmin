# Getting to Know BigCouch
## Manually Editing Database Documents



Skip to end of metadata
Created by Stephen Lum, last modified by Noah Mehl on Jul 09, 2013 Go to start of metadata
These are the steps required to complete a self install using any of the currently available methods ( Chef-Solo, Packages, or Source Installation).
You will access most of these database documents by using the Futon web interface for Bigcouch. You can reach it by going to  http://ip.address:15984/_utils . Insert the IP Address of your server in the url.
 
Currently we need to manually create the master account on a new deployment. Please replace the (ACCOUNTNAME SIP.REALM.COM USERNAME PASSWORD) placeholders with values that fit your environment.
/opt/kazoo/utils/sup/sup crossbar_maintenance create_account ACCOUNTNAME SIP.REALM.COM USERNAME PASSWORD


Open your browser and go to BigCouch Futon web interface. In the "system_config" database, verify that the "autoload_modules" list in the crossbar document is correct:
 
http://ip.address:15984/_utils/document.html?system_config/crossbar
 
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
Add the FreeSWITCH nodes to the ecallmgr document in the system_config database. This will instruct ecallmgr on which servers to connect to on startup and also what commands to run. In this example, ecallmgr will connect to server1.domain.com and server2.domain.com, run the command "load mod_sofia" and reload the ACLs using the "acls" field. Note that your proxy servers (OpenSIPs or Kamailio) should be in the "authoritative" list while your DID providers should be in the "trusted" list.
 
http://ip.address:15984/_utils/document.html?system_config/ecallmgr
 
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
After performing any edits the database documents we will need to flush the cache and restart crossbar.
/opt/kazoo/utils/sup/sup whapps_config flush
  
/opt/kazoo/utils/sup/sup -n ecallmgr ecallmgr_config flush
 
/opt/kazoo/utils/sup/sup whapps_controller restart_app crossbar
You can now point your browser to  http://ip.address to start using the Kazoo web interface. Use the credentials from Step 1 to log in, then hover on the white arrow next to your user and account info on the top right of the page and click on "App Store" to turn on the apps you want to use. Have fun and thanks for using Kazoo!
 
 
LikeBe the first to like this
No labels Edit Labels
7 Comments
 User icon: kjcsb
CSB
At step 2, it describes one of the autoload_modules values to create is "cb_schemas" however the value provided with a chef install is "cb_schema". Which one is correct?
ReplyEditDeleteLikeNov 11, 2012
 User icon: paul.kramer
paul kramer
I'm able to create a master account, however at step 5 I'm presented the error: "An error occured retreiving a list of all documents. No DB shards could be opened" by the futon interface. All bluepill services are started. 
 
[root@ip-<IP> ~]# rabbitmq-server status
Activating RabbitMQ plugins ...
0 plugins activated:
 
node with name "rabbit" already running on "ip-<IP>.ap-southeast-2.compute.internal"
 
DIAGNOSTICS
===========
 
nodes in question: ['rabbit@ip-<IP>.ap-southeast-2.compute.internal']
 
hosts, their running nodes and ports:
- ip-<IP>.ap-southeast-2.compute.internal: [{rabbit,39835},
                                                   {bigcouch,37019},
                                                   {whistle_apps,40209},
                                                   {ecallmgr,47383},
                                                   {freeswitch,8031},
                                                   {rabbitmqprelaunch1538,
                                                    39125}]
 
current node details:
- node name: 'rabbitmqprelaunch1538@ip-<IP>'
- home dir: /var/lib/rabbitmq
- cookie hash: at619UOZzsenF44tSK3ulA==
 
[root@ip-<IP> ~]# bluepill ecallmgr status
ecallmgr(pid:1968): up
 
[root@ip-<IP> ~]# bluepill whapps status
whapps(pid:1623): up
 
[root@ip-<IP> ~]# bluepill bigcouch status
bigcouch(pid:1011): up
 
 
ReplyEditDeleteLikeJan 23, 2013
 User icon: grahamsnz
Graham Nelson-Zutter
Running the initial command to create the 1st user and 1st account has some odd results for me.
/opt/kazoo/utils/sup/sup crossbar_maintenance create_account ACCOUNT REALM USER PASSWORD
There are 2 new documents created in the /accounts/ database. There is also a new account/XX/XX/XX/XXXX... database that includes a unique account that matches the account document created in the /accounts. database. However, in the new account/XX/XX/XX/XXXX... database, there is no new user document, under views users/list_by_usename there is no user.
Perhaps I'm missing something. It really seems like there should be a new user the new account/XX/XX/XX/XXXX... database.
Any idea how this could happen? 
ReplyEditDeleteLikeApr 14, 2013
 User icon: martexx
martin splinter
Steps 4,5,6,7 are obsolete, if one just logs in to the kazoo gui and goes to app store and enable all apps, then the datebase is filled.
It would be nice if the chef recipe would take the domainname from system and add it to the database when installing. This document would be not needed anymore
 
I dont know if step 8 is still needed but i guess not.
ReplyEditDeleteLikeJun 01, 2013
 User icon: xavier@2600hz.com
Xavier de la Grange
Hello Martin,
 
You are right, these steps are not needed anymore. We are working on the deployment procedures to remove all those manual steps actually, it should be coming soon. Stay tuned!

