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
Refresh to get above changes  
`sup kapps_maintenance refresh "system_config"`  

Verify on kazoo in each zone that only freeswitch for that zone is visible.    
`sup ecallmgr_maintenance list_fs_nodes`

This example assumes ecallmgr is started as a kazoo app.  If it is started separately with systemd or init, the command would be:
`sup -necallmgr ecallmgr_maintenance list_fs_nodes`
