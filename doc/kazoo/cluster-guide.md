## Cluster Guide

Name: **Kazoo Dedicated Cluster Guide**

Description: *A guide for installing, configuring and managing your own dedicated Kazoo cluster.*

Let's assume the following 7 server clusters in 2 zones.
### Abbreviation
bc = Bigcouch  
fs = Freeswitch    
mq = RabbitMQ  
kz = Kazoo  
ka = Kamailio  

### IP addressing scheme  
10.100 = zone 100  
10.200 = zone 200  
10.x00.10.x = Bigcouch  
10.x00.20.x = Freeswitch  
10.x00.30.x = RabbitMQ  
10.x00.40.x = Kazoo  
10.x00.50.x = Kamailio  

### Server hostnames and IP addresses
Using the abbreviation and IP addressing scheme above.

| ZONE 1 | ZONE 2 |
| ---------- | ---------- |
|bc1.z100.somedomain.com  10.100.10.1  | bc1.z200.somedomain.com  10.200.10.1 |
bc2.z100.somedomain.com  10.100.10.2   | bc2.z200.somedomain.com  10.200.10.2 |
bc3.z100.somedomain.com  10.100.10.3   | bc3.z200.somedomain.com  10.200.10.3 |
fs1.z100.somedomain.com  10.100.20.1   | fs1.z200.somedomain.com  10.200.20.1 | 
mq1.z100.somedomain.com  10.100.30.1   | mq1.z200.somedomain.com  10.200.30.1 |
kz1.z100.somedomain.com  10.100.40.1   | kz1.z200.somedomain.com  10.200.40.1 |
ka1.z100.somedomain.com  10.100.50.1   | ka1.z200.somedomain.com  10.200.50.1 |

### Cluster Bigcouch
This needs to be done before installing kazoo.

On each Bigcouch node configure `z=2` on `/etc/kazoo/bigcouch/local.ini` as follows:
```
[cluster]  
q=3  
r=2  
w=2  
n=3  
z=2  
```

Cluster together the bigcouch nodes from `bc1.z100` (in this example).

```curl http://bc1.z100.somedomain.com:5986/nodes/bigcouch@bc1.z100.somedomain.com```  
Returns  
```{"_id":"bigcouch@bc1.z100.somedomain.com","_rev":"3-b13d076f367df4d0c52b236e654b836c"}```  

Now add the zone to this bigcouch server and cluster together the other servers.
```
curl -X PUT bc1.z100.somedomain.com:5986/nodes/bigcouch@bc1.z100.somedomain.com -d '{"_rev":3-b13d076f367df4d0c52b236e654b836c", "zone":"z100"}'
curl -X PUT bc1.z100.somedomain.com:5986/nodes/bigcouch@bc2.z100.somedomain.com -d '{"zone":"z100"}'
curl -X PUT bc1.z100.somedomain.com:5986/nodes/bigcouch@bc3.z100.somedomain.com -d '{"zone":"z100"}'
curl -X PUT bc1.z100.somedomain.com:5986/nodes/bigcouch@bc1.z100.somedomain.com -d '{"zone":"z200"}'
curl -X PUT bc1.z100.somedomain.com:5986/nodes/bigcouch@bc2.z100.somedomain.com -d '{"zone":"z200"}'
curl -X PUT bc1.z100.somedomain.com:5986/nodes/bigcouch@bc3.z100.somedomain.com -d '{"zone":"z200"}'
```
Verify cluster:  
`curl http://bc1.z100.somedomain.com:5984/_membership`  
Should return:  
```
{"all_nodes":["bigcouch@bc3.z200.somedomain.com","bigcouch@bc2.z200.somedomain.com","bigcouch@bc1.z200.somedomain.com",
"bigcouch@bc3.z100.somedomain.com","bigcouch@bc2.z100.somedomain.com","bigcouch@bc1.z100.somedomain.com"],

"cluster_nodes":["bigcouch@bc3.z200.somedomain.com","bigcouch@bc2.z200.somedomain.com","bigcouch@bc1.z200.somedomain.com",
"bigcouch@bc3.z100.somedomain.com"","bigcouch@bc2.z100.somedomain.com","bigcouch@bc1.z100.somedomain.com"]}
```
You can do that on each server to verify they all have the same configuration.

To verify zone configuration on each document on each server.
```
curl http://bc1.z100.somedomain.com:5986/nodes/bigcouch@bc1.z100.somedomain.com
curl http://bc1.z100.somedomain.com:5986/nodes/bigcouch@bc2.z100.somedomain.com
...
```

etc.  
### Kazoo Cluster

After installing kazoo in both zones edit `/etc/kazoo/core/config.ini`.  This is exactly the same on both.  
```
; section are between [] = [section]
; key = value
; to comment add ";" in front of the line
;[amqp]
;uri = "amqp://guest:guest@127.0.0.1:5672"

[zone]
name = "z100"
amqp_uri = "amqp://guest:guest@10.100.30.1"

[zone]
name = "z200"
amqp_uri = "amqp://guest:guest@10.200.30.1"

[bigcouch]
compact_automatically = true
cookie = change_me
ip = "127.0.0.1"
port = 15984
; username = "kazoo"
; password = "supermegaexcellenttelephonyplatform"
admin_port = 15986

[whistle_apps]
cookie = change_me

[kazoo_apps]
cookie = change_me
zone = "z100"
host = "kz1.z100.somedomain.com"

[kazoo_apps]
cookie = change_me
zone = "z200"
host = "kz1.z200.somedomain.com"

[ecallmgr]
cookie = change_me
zone = "z100"
host = "kz1.z100.somedomain.com"

[ecallmgr]
cookie = change_me
zone = "z200"
host = "kz1.z200.somedomain.com"

[log]
syslog = info
console = notice
file = error
```

### Assign Freeswitch to Ecallmgr zones
Edit the database using Futon or Fauxton by browsing to the following link.  
http://bc1.z100.somedomain.com:5984/_utils/document.html?system_config/ecallmgr

Add the following to the root of the document.  So at the same level as `"default":`
```
"z100": {
       "fs_nodes": [
           "freeswitch@fs1.z100.somedomain.com"
       ]
},
"z200": {
       "fs_nodes": [
           "freeswitch@fs1.z200.somedomain.com"
       ]
   },
```
Remove any other `"fs_nodes":[...]` entries in that document.

Refresh to get above changes  
`sup kapps_maintenance refresh "system_config"`  

Verify on kazoo in each zone that only freeswitch for that zone is visible.    
`sup ecallmgr_maintenance list_fs_nodes`

Our example cluster assumes ecallmgr is started as a kazoo app on the kazoo server.  If it is started separately, with systemd or init, on the kazoo server or on its own server, the command would be:  
`sup -necallmgr ecallmgr_maintenance list_fs_nodes`

### Kamailio Config

Each Kamailio configuration at `/etc/kazoo/kamailio/local.cfg` needs to be configured with it's hostname, IP address, and all RabbitMQ servers.  The following config would be for the `ka1.z100` server.
```
## CHANGE "" TO YOUR SERVERS HOSTNAME
#!substdef "!MY_HOSTNAME!ka1.z100.somedomain.com!g"

## CHANGE "127.0.0.1" TO YOUR SERVERS IP ADDRESS
##     Usually your public IP.  If you need
##     to listen on addtional ports or IPs
##     add them in "BINDINGS" at the bottom.
#!substdef "!MY_IP_ADDRESS!10.100.50.1!g"

## CHANGE "kazoo://guest:guest@127.0.0.1:5672" TO THE AMQP URL
##     This should be the primary RabbitMQ server 
##     in the zone that this server will service.
#!substdef "!MY_AMQP_URL!kazoo://guest:guest@10.100.30.1:5672!g"

## CHANGE "kazoo://guest:guest@127.0.0.1:5672" TO THE AMQP URL for the other zone.
##     This uses the existing MY_AMQP_SECONDARY_URL variable defined in default.cfg
##     Note the addition of the "zone=" part in the middle 
#!substdef "!MY_AMQP_SECONDARY_URL!zone=z200;kazoo://guest:guest@10.200.30.1:5672!g"
```
To view the entire cluster and zone setup enter the following on either kazoo server.  
```kazoo-applications status```

### Kamailio Dispatcher
Add all Freeswitch servers to the dispatcher configuration on each Kamailio server.  The following example is run on `ka1.z100` kamailio server.  Local zone freeswitch is given setid value of 1, Freeswitch servers in other zones are given setid value of 2.
```
sqlite3 /etc/kazoo/kamailio/db/kazoo.db "INSERT INTO dispatcher (setid, destination, flags, priority, attrs, description) \
VALUES ('1', 'SIP:10.100.20.1:11000', '0', '0', '', 'zone 100')"

sqlite3 /etc/kazoo/kamailio/db/kazoo.db "INSERT INTO dispatcher (setid, destination, flags, priority, attrs, description) \
VALUES ('2', 'SIP:10.200.20.1:11000', '0', '0', '', 'zone 200')"
```
Load the changes
`kamcmd dispatcher.reload`

Verify
`kamcmd dispatcher.list`

### Post Install
A properly configured cluster and zone setup will appear as follows.

```
# kazoo-applications status

Node          : kazoo_apps@kz1.z100.somedomain.com
md5           : jFoOSYRl8EM8hPzqzjSIEw
Version       : 4.1.13 - 18
Memory Usage  : 175.15MB
Processes     : 1951
Ports         : 33
Zone          : z100 (local)
Broker        : amqp://10.100.30.1
Globals       : local (1)
Node Info     : kz_amqp_pool: 150/0/0 (ready)
WhApps        : blackhole(2d20h48m47s)   callflow(2d20h48m46s)    cdr(2d20h48m46s)         conference(2d20h48m46s)
                crossbar(2d20h48m46s)    ecallmgr(2d20h48m47s)    fax(2d20h48m41s)         hangups(2d20h48m21s)
                media_mgr(2d20h48m21s)   milliwatt(2d20h48m21s)   omnipresence(2d20h48m21s)pivot(2d20h48m21s)
                registrar(2d20h48m21s)   reorder(2d20h48m21s)     stepswitch(2d20h48m21s)  sysconf(2d20h48m48s)
                teletype(2d20h48m21s)    trunkstore(2d20h48m15s)  webhooks(2d20h48m15s)
Channels      : 0
Registrations : 1
Media Servers : freeswitch@fs1.z100.somedomain.com (2d20h47m33s)

Node          : kazoo_apps@kz1.z200.somedomain.com
md5           : b3hEn9mtqfCgJnRJrOX_aA
Version       : 4.1.13 - 18
Memory Usage  : 87.64MB
Processes     : 1951
Ports         : 34
Zone          : ny
Broker        : amqp://10.200.30.1
Globals       : remote (1)
Node Info     : kz_amqp_pool: 150/0/0 (ready)
WhApps        : blackhole(2d22h43m58s)   callflow(2d22h43m58s)    cdr(2d22h43m58s)         conference(2d22h43m58s)
                crossbar(2d22h43m57s)    ecallmgr(2d22h43m59s)    fax(2d22h43m40s)         hangups(2d22h43m30s)
                media_mgr(2d22h43m30s)   milliwatt(2d22h43m30s)   omnipresence(2d22h43m30s)pivot(2d22h43m30s)
                registrar(2d22h43m30s)   reorder(2d22h43m30s)     stepswitch(2d22h43m30s)  sysconf(2d22h44m)
                teletype(2d22h43m30s)    trunkstore(2d22h43m7s)   webhooks(2d22h43m7s)
Channels      : 0
Registrations : 1
Media Servers : freeswitch@fs1.z200.somedomain.com (2d22h43m52s)

Node          : kamailio@ka1.z100.somedomain.com
Version       : 5.0.1
Memory Usage  : 16.30MB
Processes     : 0
Ports         : 0
Zone          : van (local)
Broker        : amqp://10.100.30.1
WhApps        : kamailio(719528d17s)
Registrations : 1

Node          : kamailio@ka1.z200.somedomain.com
Version       : 5.0.1
Memory Usage  : 16.34MB
Processes     : 0
Ports         : 0
Zone          : ny
Broker        : amqp://10.200.30.1
WhApps        : kamailio(719529d20h34m29s
Registrations : 1
```
  The above assumes ecallmgr is running as an app on the kazoo server.
If the ecallmgr apps are configured to start separately, with systemd or init, on the kazoo server or on their own servers, they will appear as their own node in the above.
