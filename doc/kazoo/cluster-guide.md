## Cluster Guide

Name: **Kazoo Dedicated Cluster Guide**

Description: *A guide for installing, configuring and managing your own dedicated Kazoo cluster.*

Let's assume the following 7 server clusters in 2 zones.

### IP addressing scheme  
10.100 = zone 100  
10.200 = zone 200  
10.x00.10.x = CouchDB  
10.x00.20.x = Freeswitch  
10.x00.30.x = RabbitMQ  
10.x00.40.x = Kazoo  
10.x00.50.x = Kamailio  

### Server hostnames and IP addresses
Using the abbreviation and IP addressing scheme above.

| ZONE 1 | ZONE 2 |
| ---------- | ---------- |
|couch1.z100.somedomain.com  10.100.10.1  | couch1.z200.somedomain.com  10.200.10.1 |
couch2.z100.somedomain.com  10.100.10.2   | couch2.z200.somedomain.com  10.200.10.2 |
couch3.z100.somedomain.com  10.100.10.3   | couch3.z200.somedomain.com  10.200.10.3 |
freeeswitch1.z100.somedomain.com  10.100.20.1   | freeswitch1.z200.somedomain.com  10.200.20.1 | 
rabbit1.z100.somedomain.com  10.100.30.1   | rabbit1.z200.somedomain.com  10.200.30.1 |
kazoo1.z100.somedomain.com  10.100.40.1   | kazoo1.z200.somedomain.com  10.200.40.1 |
kamailio1.z100.somedomain.com  10.100.50.1   | kamailio1.z200.somedomain.com  10.200.50.1 |

### Cluster Bigcouch
This needs to be done before installing kazoo.

On each Bigcouch node configure `z=2` in `/etc/kazoo/bigcouch/local.ini` as follows:
```
[cluster]  
q=3  
r=2  
w=2  
n=3  
z=2  
```

Cluster together the bigcouch nodes from `couch1.z100` (in this example).

```curl http://couch1.z100.somedomain.com:5986/nodes/bigcouch@couch1.z100.somedomain.com```  
Returns  
```{"_id":"bigcouch@couch1.z100.somedomain.com","_rev":"3-b13d076f367df4d0c52b236e654b836c"}```  

Now add the zone to this bigcouch server and cluster together the other servers.
```
curl -X PUT couch1.z100.somedomain.com:5986/nodes/bigcouch@couch1.z100.somedomain.com -d '{"_rev":3-b13d076f367df4d0c52b236e654b836c", "zone":"z100"}'
curl -X PUT couch1.z100.somedomain.com:5986/nodes/bigcouch@couch2.z100.somedomain.com -d '{"zone":"z100"}'
curl -X PUT couch1.z100.somedomain.com:5986/nodes/bigcouch@couch3.z100.somedomain.com -d '{"zone":"z100"}'
curl -X PUT couch1.z100.somedomain.com:5986/nodes/bigcouch@couch1.z100.somedomain.com -d '{"zone":"z200"}'
curl -X PUT couch1.z100.somedomain.com:5986/nodes/bigcouch@couch2.z100.somedomain.com -d '{"zone":"z200"}'
curl -X PUT couch1.z100.somedomain.com:5986/nodes/bigcouch@couch3.z100.somedomain.com -d '{"zone":"z200"}'
```
Verify cluster:  
`curl http://couch1.z100.somedomain.com:5984/_membership`  
Should return:  
```
{"all_nodes":["bigcouch@couch3.z200.somedomain.com","bigcouch@couch2.z200.somedomain.com","bigcouch@couch1.z200.somedomain.com",
"bigcouch@couch3.z100.somedomain.com","bigcouch@couch2.z100.somedomain.com","bigcouch@couch1.z100.somedomain.com"],

"cluster_nodes":["bigcouch@couch3.z200.somedomain.com","bigcouch@couch2.z200.somedomain.com","bigcouch@couch1.z200.somedomain.com",
"bigcouch@couch3.z100.somedomain.com"","bigcouch@couch2.z100.somedomain.com","bigcouch@couch1.z100.somedomain.com"]}
```
You can do that on each server to verify they all have the same configuration.

To verify zone configuration on each document on each server.
```
curl http://couch1.z100.somedomain.com:5986/nodes/bigcouch@couch1.z100.somedomain.com
curl http://couch1.z100.somedomain.com:5986/nodes/bigcouch@couch2.z100.somedomain.com
...
```

etc.  
### Kazoo Config

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
host = "kazoo1.z100.somedomain.com"

[kazoo_apps]
cookie = change_me
zone = "z200"
host = "kazoo1.z200.somedomain.com"

[ecallmgr]
cookie = change_me
zone = "z100"
host = "kazoo1.z100.somedomain.com"

[ecallmgr]
cookie = change_me
zone = "z200"
host = "kazoo1.z200.somedomain.com"

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
           "freeswitch@freeswitch1.z100.somedomain.com"
       ]
},
"z200": {
       "fs_nodes": [
           "freeswitch@freeswitch1.z200.somedomain.com"
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

### HAProxy config

Edit `/etc/kazoo/haproxy/haproxy.cfg` on zone 100 Kazoo and Freeswitch server as follows.
```
global
        log /dev/log local0 info
        maxconn 4096
        user haproxy
        group daemon
        stats socket    /var/run/haproxy/haproxy.sock mode 777

defaults
        log global
        mode http
        option httplog
        option dontlognull
	option log-health-checks
        option redispatch
        option httpchk GET /
        option allbackups
        option http-server-close
        maxconn 2000
        retries 3
        timeout connect 6000ms
        timeout client 12000ms
        timeout server 12000ms
        
listen bigcouch-data 127.0.0.1:15984
  balance roundrobin
    server couch1.z100.somedomain.com 10.100.10.1:5984 check
    server couch2.z100.somedomain.com 10.100.10.2:5984 check
    server couch3.z100.somedomain.com 10.100.10.3:5984 check
    server couch1.z200.somedomain.com 10.200.10.1:5984 check backup
    server couch2.z200.somedomain.com 10.200.10.2:5984 check backup
    server couch3.z200.somedomain.com 10.200.10.3:5984 check backup

listen bigcouch-mgr 127.0.0.1:15986
  balance roundrobin
    server couch1.z100.somedomain.com 10.100.10.1:5986 check
    server couch2.z100.somedomain.com 10.100.10.2:5986 check
    server couch3.z100.somedomain.com 10.100.10.3:5986 check
    server couch1.z200.somedomain.com 10.200.10.1:5986 check backup
    server couch2.z200.somedomain.com 10.200.10.2:5986 check backup
    server couch3.z200.somedomain.com 10.200.10.3:5986 check backup

listen haproxy-stats 127.0.0.1:22002
  mode http
  stats uri /
```
### Kamailio Config

Each Kamailio configuration at `/etc/kazoo/kamailio/local.cfg` needs to be configured with it's hostname, IP address, and all RabbitMQ servers.  The following config would be for the `kamailio1.z100` server.
```
## CHANGE "" TO YOUR SERVERS HOSTNAME
#!substdef "!MY_HOSTNAME!kamailio1.z100.somedomain.com!g"

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
### Verify Dispatcher

After adding Freeswitch servers to CouchDB and completing Kamailio configuration above and restarting Kamailio, Kamailio should automatically populate /etc/kazoo/kamailio/db/kazoo.db with all Freeswitch servers.  Verify that all Freeswitch servers are there and that local zone Freeswitch servers have `ID: 1` and non-local zone servers have `ID: 2`.
```
kamcmd dispatcher.list
```

### Post Install

To view the entire cluster and zone setup, enter the following on either kazoo server.  
```kazoo-applications status```  

A properly configured cluster and zone setup will appear as follows.

```
# kazoo-applications status

Node          : kazoo_apps@kazoo1.z100.somedomain.com
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
Media Servers : freeswitch@freeswitch1.z100.somedomain.com (2d20h47m33s)

Node          : kazoo_apps@kazoo1.z200.somedomain.com
md5           : b3hEn9mtqfCgJnRJrOX_aA
Version       : 4.1.13 - 18
Memory Usage  : 87.64MB
Processes     : 1951
Ports         : 34
Zone          : z200
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
Media Servers : freeswitch@freeswitch1.z200.somedomain.com (2d22h43m52s)

Node          : kamailio@kamailio1.z100.somedomain.com
Version       : 5.0.1
Memory Usage  : 16.30MB
Processes     : 0
Ports         : 0
Zone          : z100 (local)
Broker        : amqp://10.100.30.1
WhApps        : kamailio(719528d17s)
Registrations : 1

Node          : kamailio@kamailio1.z200.somedomain.com
Version       : 5.0.1
Memory Usage  : 16.34MB
Processes     : 0
Ports         : 0
Zone          : z200
Broker        : amqp://10.200.30.1
WhApps        : kamailio(719529d20h34m29s
Registrations : 1
```
  The above assumes ecallmgr is running as an app on the kazoo server.
If the ecallmgr apps are configured to start separately, with systemd or init, on the kazoo servers or on their own servers, they will appear as their own nodes in the above status.
