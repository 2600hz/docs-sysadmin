## Inbound Call Failure


If you are unable to receive inbound calls (but outbound calls work), you have one of four problems:

1. The carrier who is calling in isn't in your allowed list of inbound IP addresses.

2. The phone number being called to isn't formatted in a way we understand (by default it must be E.164 formatted)

3. The phone number being called to isn't in the database properly

4. The inbound INVITE packet is malformed or contains required features we don't support


The steps below will help you identify which issue is causing the problem:

1. Ensure Carrier is Allowed (ACLs)

2. While ACLs in **FreeSWITCH** generally are controlled within local files on each FS instance, **Kazoo** has moved control of the **FS** ACLs within it's own database under: `system_config ecallmgr`
 
3. Your ACLs should be between the `fs_cmds` and `authz_enabled` elements.


*** IT'S VERY IMPORTANT YOU DO NOT SIMPLY CUT AND PASTE THIS INTO YOUR DB DOCUMENT. IT IS A GENERIC EXAMPLE AND REQUIRES YOUR CUSTOM DATA ***


An example for this format is as follows:
`
{_id: ecallmgr,default: {
       
       fs_nodes: [freeswitch@kazoofsserver1.example.com
       ,freeswitch@kazoofsserver2.example.com ]
       ,fs_cmds: [{load: mod_sofia},{reloadacl: }]    
       ,acls: {
         e164: {
         type: allow
    ,network-list-name:trusted
    ,cidr:198.22.64.214/32
       }
 ,les.net1: { type: allow
 ,network-list-name: trusted
 ,cidr:64.34.181.47/32 }
 ,les.net2: {
 ,type:allow
 ,network-list-name:trusted
 ,cidr: 64.34.176.212/32
   },
           
flowroute1: {
   type:allow
  ,network-list-name: trusted
  ,cidr: 216.115.69.144/32

           },
           
flowroute2: {
   type: allow
     ,network-list-name: trusted
     ,cidr: 70.167.153.130/32
           }
           
    ,kamailio-proxy1: {
               
    type: allow
     ,network-list-name: authoritative
     ,cidr: kamailio1.ip.goes.here/32

           },
           
    kamailio-proxy2: {           
    type:allow
     ,network-list-name: authoritative
     ,cidrkamailio2.ip.goes.here/32
           }
       }
       
     ,authz_enabled: false
     ,default_ringback: %(2000,4000,440,480)
     ,distribute_presence: true
     ,distribute_message_query: false
     ,node_down_grace_period: 10000
     ,authz_dry_run: false
     ,fax_file_path: /tmp/
     ,default_recording_extension: .mp3
     ,recording_file_path: /tmp/
     ,record_waste_resources: false
     ,default_fax_extension: .tiff
  }
}
`
**NOTE:** Sections `opensips-proxy1` and `opensips-proxy2` should have your `opensips` server IPs in the 'cidr' field. These sections are required, as they tell **FS** to allow connections from your own **Opensips** servers.
 
Once you have changed this document, you must issue 
`sup -necallmgr ecallmgr_config flush` to clear the local `ecallmgr` and `sysconf` caches. You can check to see what will be retrieved by issuing: `sup -necallmgr ecallmgr_config get acls`
 
 
## Identifying This Issue

To determine if this is the problem preventing your inbound calls:

1. Login to all your **FreeSWITCH** servers.

2. Enter the **FreeSWITCH** CLI by typing 'cli'

3. Call the number in question that is not routing properly.

4. In your **FreeSWITCH** console you should see a line with the word INVITE in it that looks like this:

`2012-03-18 03:30:55.435847 [WARNING] sofia_reg.c:1428 SIP auth challenge (INVITE) on sofia profile sipinterface_1
for [2125551234@your.ip.add.ress] from ip 22.33.44.55`

5. If you see the above line and you are sure it is for the phone number you are testing you are challenging (requesting username/password) your carrier. You probably shouldn't be.


## Other Identification Tips

Note that each carrier behaves differently when unable to reach your box. Your caller may:

1. Hear a recording that the number is unavailable, out of service or disconnected

2. Hear dead-air

3. Hear a busy signal

4. Hear ringing forever


## Note that this problem will never result in:

1. Callers reaching voicemail

2. Callers reaching your main menu / IVR

3. Callers ringing your phone but being unable to hear or speak with you (i.e. if your phone does actually ring, but you have no audio, ACLs are not your issue)
 
## Fixing Your ACLs

1. See the format for ACLs above and correct your database document. The IP address displayed on your **FreeSWITCH** console is NOT the IP address of your carrier if you are using **OpenSIP**s in your cluster, it's the IP address of your own server! Do NOT add the **OpenSIP**s server to your trusted list above. You need to find out your carrier's real IP address through some other method.

2. Reload the ACLs within FreeSWITCH by typing: `cli -x reloadacl` You should see a SUCCESS and an `OK acl reloaded` result
Once you've updated your ACLs your calls should process properly.
 
## Ensure Number Formatting

We expect inbound calls to be in a format we can understand, with the INVITE URI containing the desired number for routing. Some carriers put the phone number they are trying to reach in a different header, and some carriers simply don't format the number properly. 

You can identify this issue as follows: *XXX*
 
## Ensure Number Mapping in Database

Each phone number processed for inbound calls exists as a small document in a numbers/XXXXX database. These databases check the first five digits of a dialed number and contain a mapping for identifying which account that number belongs to. Sometimes these mappings can break. Before assuming that's what's happened you should check if the number is mapped incorrectly. 

There are two ways to do this:

*XXX*


## Check Using a Maintenance Command

From the **WhApps** console (./conn-to-apps.sh), run this command: `stepswitch_maintenance:lookup_number(+14155555555).`

If the number is known, you will get an `{ok,document_id} ` response. 

Otherwise you'll get an error. A sample is below:

    Eshell V5.8.4  (abort with ^G)
    (whistle_apps@apps001-aa-ord.2600hz.com)1
    stepswitch_maintenance:lookup_number(
    +14158867900).
    {ok,
    503d96f14def94f23458cf3e1a025375
    ,false}


## Check Using the Database

Go into your **CouchDB** via port 5984 and enter the numbers/+1415 database, where +1415 is the first 5 characters (usually +1
areacode in the U.S.) of the phone number in E.164 format.
 

## Identify Malformed INVITE Packets

Sometimes, carriers send bad INVITE packets. This can happen for a number of reasons:

1. Additional features cause the INVITE packet to be too big

2. Broken firewalls or routers change the INVITEs incorrectly

3. The INVITEs contain requested features that your system doesn't support

You can identify that this is happening by reviewing the logs. You will see:

1. *XXXX*
 
