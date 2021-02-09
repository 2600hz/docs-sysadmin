# Installation Guide for CentOS 7

This is a reference guide for installing all of the necessary components for Kazoo. Once you have completed this guide, you should have an all-in-one installation of Kazoo complete and ready to configure for use.

The CentOS packages for the various dependencies are installed along with a wrapper that sets up the various configs and scripts that Kazoo needs. So when you install \`kazoo-kamailio\` you get the vanilla Kamailio packages along with the \`kazoo-kamailio\` overlay. Be aware that you'll need to use \`kazoo-kamailio\` when interacting with systemd.

## A living guide

This guide is an attempt to make installing all the various components straightforward to get a working All-in-One Kazoo installation for testing purposes. However, packages are updated in the CentOS repos, new versions of Kazoo get released, and other things that can cause this guide to bitrot.

We need your help to keep this up to date by:

1. Reporting on the [forum](https://forums.2600hz.com/forums/) about where in the guide things broke down, or that you didn't understand.
2. Using the [edit link](https://github.com/2600hz/sysadmin/edit/master/doc/install/install_via_centos7.md) to edit this document and issue a pull request.

## Setup the server

This guide builds a server using the [CentOS 7 Minimal ISO](http://isoredirect.centos.org/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1804.iso). Once you have that installed on a server (or virtual machine), it is time to setup the host. Some of the commands below are optional (and noted as such) - check whether you need to run them first.

!!! note
    Please remember to replace '172.16.17.18' with your server's actual IP address (not localhost either). Please remember to replace 'aio.kazoo.com' with your actual Host Name(FQDN).

```bash

# pre-configure custom defaults:
export IP_ADDR=172.16.17.18
export _HOSTNAME=aio.kazoo.com

# You can find the latest Release RPM here: https://packages.2600hz.com/centos/7/stable/2600hz-release/
# Currently, 4.3 is considered 'stable' so:
# https://packages.2600hz.com/centos/7/stable/2600hz-release/4.3/2600hz-release-4.3-0.el7.centos.noarch.rpm

export RELEASE_BASE=https://packages.2600hz.com/centos/7/stable/2600hz-release
export RELEASE_VER=4.3
export META_PKG=2600hz-release-${RELEASE_VER}-0.el7.centos.noarch.rpm
export LATEST_RELEASE=${RELEASE_BASE}/${RELEASE_VER}/${META_PKG}

# Install all system updates
yum update -y

# Install Extra Packages for Enterprise Linux
yum install -y epel-release

# Install required packages
yum install -y yum-utils psmisc

# Hostname setup
hostnamectl set-hostname ${_HOSTNAME}

echo "${IP_ADDR} ${_HOSTNAME} `hostname -s`" >> /etc/hosts
echo "127.0.0.1 ${_HOSTNAME} `hostname -s`" >> /etc/hosts
echo "::1 ${_HOSTNAME} `hostname -s`" >> /etc/hosts

# /etc/hosts setup
If you are running a multi-server environment, define the private IPs for your CouchDB servers and public IPs for your other Kazoo-apps/Kamailio/FreeSWITCH/RabbitMQ servers. An example would be:

127.0.0.1       app001.domain.com localhost localhost.localdomain localhost4 localhost4.localdomain4
::1             app001.domain.com localhost localhost.localdomain localhost4 localhost4.localdomain4
10.1.1.1        bc001.domain.com
10.1.1.2        bc002.domain.com
10.1.1.3        bc003.domain.com
38.222.222.222  fs001.domain.com
38.222.222.223  kam001.domain.com
38.222.222.225  rab001.domain.com

# System time to UTC: required by kazoo
ln -fs /usr/share/zoneinfo/UTC /etc/localtime

# Setup networking to auto-start (if necessary)
sed -i 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-eth0
systemctl restart network

# Add 2600Hz RPM server
yum install -y ${LATEST_RELEASE}
Example:  yum install -y https://packages.2600hz.com/centos/7/stable/2600hz-release/4.3/2600hz-release-4.3-0.el7.centos.noarch.rpm

# Clear yum cache
yum clean all

# Setup NTPd
yum install -y ntp
systemctl enable ntpd
systemctl restart ntpd
```

## Setting up RabbitMQ

```bash
# Install the Kazoo-wrapped RabbitMQ
# This installs an older (perfectly fine) version 3.3.5
yum install -y kazoo-rabbitmq

## If you want to run newer versions follow these steps:
## yum remove erlang erlang-* -y
## wget https://github.com/rabbitmq/erlang-rpm/releases/download/v20.3.8.15/erlang-20.3.8.15-1.el7.centos.x86_64.rpm
## yum install erlang-20.3.8.15-1.el7.centos.x86_64.rpm
## curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
## yum install rabbitmq-server-3.7.8-1.el7.noarch kazoo-rabbitmq-4.2-4.el7.centos.noarch -y
## sed -i s/',{loopback_users, \[\]}'/',{loopback_users, \[\]}\n,{channel_max, 0}'/g /etc/kazoo/rabbitmq/rabbitmq.config
## systemctl daemon-reload
## systemctl start kazoo-rabbitmq

# Enable and start
systemctl enable kazoo-rabbitmq
systemctl start kazoo-rabbitmq

# Check that RabbitMQ is listening
ss -lpn | grep "5672"
tcp    LISTEN     0      128       *:25672                 *:*                   users:(("beam.smp",pid=10826,fd=8))

# For testing purposes (optional), it can be useful to disable iptables
systemctl stop firewalld

# Check the RabbitMQ UI (optional)
# http://${IP_ADDR}:15672/
# Use 'guest' as username and password

# Check out the API (optional, build monitoring tools around this)
curl -i -u guest:guest http://localhost:15672/api/aliveness-test/%2F

HTTP/1.1 200 OK
Server: MochiWeb/1.1 WebMachine/1.10.0 (never breaks eye contact)
Date: {{ current date and time }}
Content-Type: application/json
Content-Length: 15
Cache-Control: no-cache

{"status":"ok"}

# Check the status of the broker
kazoo-rabbitmq status
```


## Setting up Kamailio

```bash
# Install Kazoo-wrapped Kamailio
yum install -y kazoo-kamailio

# Update the hostname in the config
sed -i "s/kamailio\.2600hz\.com/${_HOSTNAME}/g" /etc/kazoo/kamailio/local.cfg

# Update the IP addresses
sed -i "s/127\.0\.0\.1/${IP_ADDR}/g" /etc/kazoo/kamailio/local.cfg

# Disable Kamailio bundled systemctl script
systemctl disable kamailio

# Note: If RabbitMQ is running on a separate server, update the local.cfg file (above):
# #!substdef "!MY_AMQP_URL!amqp://guest:guest@${RABBITMQ_IP_ADDR}:5672!g"

# Start Kamailio
systemctl enable kazoo-kamailio
systemctl restart kazoo-kamailio

# Check that Kamailio is listening (optional)
ss -ln | egrep "5060|7000"
udp    UNCONN     0      0         *:7000                  *:*
udp    UNCONN     0      0         *:5060                  *:*
tcp    LISTEN     0      128       *:5060                  *:*
tcp    LISTEN     0      128       *:7000                  *:*

# check the dispatcher status
kazoo-kamailio status
error: 500 - No Destination Sets

## This error is expected! You haven't added any FreeSWITCH servers for Kamailio to use.
```


## Setting up FreeSWITCH

```bash
# Install Kazoo-wrapped FreeSWITCH
yum install -y kazoo-freeswitch

# Disable freeswitch bundled systemctl script
systemctl disable freeswitch

# Enable and start FreeSWITCH
systemctl enable kazoo-freeswitch
systemctl start kazoo-freeswitch

# Check FreeSWITCH status (you will not see any connected Erlang modules)
kazoo-freeswitch status
UP 0 years, 0 days, 0 hours, 0 minutes, 0 seconds, 192 milliseconds, 384 microseconds
FreeSWITCH (Version 1.6.20  64bit) is ready
0 session(s) since startup
0 session(s) - peak 0, last 5min 0
0 session(s) per Sec out of max 200, peak 0, last 5min 0
5000 session(s) max
min idle cpu 0.00/100.00
Current Stack Size/Max 240K/8192K

Running mod_kazoo v1.4.0-1
Listening for new Erlang connections on 0.0.0.0:8031 with cookie change_me
Registered as Erlang node freeswitch@k4c7.pdx.2600hz.com, visible as freeswitch
No erlang nodes connected

# Get the sipify script for FreeSWITCH log parsing (optional)
curl -o /usr/bin/sipify.sh \
https://raw.githubusercontent.com/2600hz/community-scripts/master/FreeSWITCH/sipify.sh
chmod 755 /usr/bin/sipify.sh
```

!!! note
    mod_sofia isn't loaded on boot. FreeSWITCH is shipped with no dialplan as Kazoo itself controls all of the routing decisions, thus FreeSWITCH isn't of much use until Kazoo is connected.

!!! note
    Kamailio will still not know about FreeSWITCH in the destination sets. FreeSWITCH will be auto-discovered later in the process and added.

## Setting up BigCouch

At this time, BigCouch is still "recommended" solely because we don't have the history in production of running CouchDB. Kazoo works just fine with CouchDB 1.6 and 2.0 so feel free to install and configure those packages instead.

```bash
# Install Kazoo-wrapped BigCouch
yum install -y kazoo-bigcouch

# Enable and start BigCouch
systemctl enable kazoo-bigcouch
systemctl start kazoo-bigcouch

# Check that BigCouch is listening (optional)
ss -ln | egrep "5984|5986"
tcp    LISTEN     0      128       *:5984                  *:*
tcp    LISTEN     0      128       *:5986                  *:*

# Check the BigCouch UI (optional): http://localhost:5984/_utils

# Check the status of bigcouch
kazoo-bigcouch status
BigCouch (pid 21325) is running...
{"all_nodes":["bigcouch@aio.kazoo.com"],"cluster_nodes":["bigcouch@aio.kazoo.com"]}
```

## Setting up HAProxy

```bash
# Install the Kazoo-wrapped HAProxy
yum -y install kazoo-haproxy socat

# Edit /etc/kazoo/haproxy/haproxy.cfg to setup the backend server to point to BigCouch
# For AiO installs, it should look something like:

cat >> /etc/kazoo/haproxy/haproxy.cfg << EOF
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
    server ${_HOSTNAME} 127.0.0.1:5984 check

listen bigcouch-mgr 127.0.0.1:15986
  balance roundrobin
    server ${_HOSTNAME} 127.0.0.1:5986 check

listen haproxy-stats 127.0.0.1:22002
  mode http
  stats uri /

EOF

# Depending on the kazoo apps you intend on running, this file may need to be edited to include:
# frontend kazoo-smtp
#    bind ${IP_ADDR}:2525
#    mode tcp
#    default_backend kazoo-smtp-backend
#
# backend kazoo-smtp-backend
#    balance source
#    mode tcp
#    option smtpchk HELO
#    server ${HOSTNAME} ${IP_ADDR}:19025 check
#
# frontend kazoo-websocket
#    bind *:5000
#    bind *:5443 ssl crt /etc/kazoo/certs/combined.pem  // file path for combined SSL certificate
#    default_backend kazoo-websocket-backend
#
# backend kazoo-websocket-backend
#    balance source
#    option tcp-check
#    server ${HOSTNAME} ${IP_ADDR}:5555 check
# frontend kazoo-api
#    bind *:8000
#    bind *:8443 ssl crt /etc/kazoo/certs/combined.pem  // file path for combined SSL certificate
#    default_backend kazoo-api-backend
#
#backend kazoo-api-backend
#    balance source
#    http-send-name-header Host
#    option httplog
#    option forwardfor except 127.0.0.1/8
#    server ${HOSTNAME} ${IP_ADDR}:16000 check

# Enable and start HAProxy
systemctl enable kazoo-haproxy
systemctl start kazoo-haproxy

# Check the status of haproxy
kazoo-haproxy status
|Host                      |Backend         |Status |Active |Rate   |1xx    |2xx    |3xx    |4xx    |5xx    |Ping   |
|aio.kazoo.com             |bigcouch-data   |UP     |0      |0      |0      |0      |0      |0      |0      |1ms    |
|aio.kazoo.com             |bigcouch-mgr    |UP     |0      |0      |0      |0      |0      |0      |0      |1ms    |

curl localhost:15984
{"couchdb":"Welcome","version":"1.1.1","bigcouch":"0.4.2"}

curl localhost:15986
{"couchdb":"Welcome","version":"1.1.1"}

curl localhost:15984/_all_dbs
[]
```

## Setting up Kazoo Applications

At this point, we're ready to install Kazoo as all the infrastructure that Kazoo relies on is in place and ready to be taken control of. The first thing to do is install the Kazoo applications.

```bash
# Install all the Kazoo applications (at this time, 4.3.36 for most of the kazoo-application-* packages)
yum install -y kazoo-applications

# Start Kazoo Applications
systemctl enable kazoo-applications
systemctl start kazoo-applications

# Check that the databases are created (may take some time while things initialize)
# Results may vary a bit - should be at least 5 system databases for sure)
curl localhost:15984/_all_dbs
["accounts","acdc","alerts","anonymous_cdrs","dedicated_ips","faxes","global_provisioner","oauth","offnet","pending_notifications","port_requests","ratedeck","services","sip_auth","system_auth","system_config","system_data","system_media","system_schemas","tasks","token_auth","webhooks"]

# You should have > 20 DBs
curl localhost:15984/_all_dbs | python -mjson.tool | wc -l
26

# Import System Media prompts (takes a while)
sup kazoo_media_maintenance import_prompts /opt/kazoo/sounds/en/us/

# If you need to import other languages (optional)
# sup kazoo_media_maintenance import_prompts /opt/kazoo/sounds/fr/ca fr-ca

# It can be a good idea to run a refresh over the installed databases - there are sporadic reports of partial installations hanging at this point
sup kapps_maintenance refresh
<10016.9661.0> (24/24) refreshing database 'system_config'
...

# Create the admin account for the Monster UI, remember to replace the braced fields
# Example: To create an account with the username root, replace {ADMIN_USER} with root
sup crossbar_maintenance create_account \
	{ACCOUNT_NAME} \
	{ACCOUNT_REALM} \
	{ADMIN_USER} \
	{ADMIN_PASS}
View updated for account%2Fed%2F1f%2F03d6cf3b8135fe3b008847d92c65!
created new account 'ed1f03d6cf3b8135fe3b008847d92c65' in db 'account%2Fed%2F1f%2F03d6cf3b8135fe3b008847d92c65'
created new account admin user '002bc4e8687292f9e4085a590fa61eab'
promoting account ed1f03d6cf3b8135fe3b008847d92c65 to reseller status, updating sub accounts
updated master account id in system_config.accounts
ok

# Use SUP command to communicate with the running VM


# Check the status of the Kazoo cluster
kazoo-applications status
Node          : kazoo_apps@aio.kazoo.com
md5           : o4fNOLAQ3LJSAzliaNiT1A
Version       : 4.3.36 - 19
Memory Usage  : 71.24MB
Processes     : 1787
Ports         : 20
Zone          : local
Broker        : amqp://127.0.0.1:5672
Globals       : local (4)
Node Info     : kz_amqp_pool: 150/0/0 (ready)
                amqp://guest:guest@127.0.0.1:5672: {"channel_count":210}
WhApps        : blackhole(5m15s)         callflow(5m15s)          cdr(5m14s)               conference(5m14s)
                crossbar(5m14s)          fax(5m12s)               hangups(4m52s)           media_mgr(4m52s)
                milliwatt(4m52s)         omnipresence(4m52s)      pivot(4m52s)             registrar(4m52s)
                reorder(4m52s)           stepswitch(4m52s)        sysconf(5m16s)           tasks(4m52s)
                teletype(3m51s)          trunkstore(3m46s)        webhooks(3m46s)

Node          : kamailio@kazoo2.lan.com
Version       : 5.1.8-rc2
Memory Usage  : 16.24MB
Zone          : local
Broker        : amqp://127.0.0.1:5672
WhApps        : kamailio(13m53s)
Roles         : Dispatcher Presence Proxy Registrar
Presentities  : presence (0)  message-summary (0)  dialog (0)
Subscribers   : presence (0)  message-summary (0)  dialog (0)
Subscriptions : presence (1)  message-summary (1)  dialog (1)
Listening on  : 192.168.1.190 tcp (5060 7000) udp (5060 7000)
Registrations : 0

ok
```


## Setting up ecallmgr

```bash

# Start Kazoo eCallMgr
systemctl enable kazoo-ecallmgr
systemctl start kazoo-ecallmgr

# eCallMgr will attempt to auto-connect to the local FreeSWITCH if possible
kazoo-applications status
...
Node          : ecallmgr@aio.kazoo.com
md5           : H5AnAyj8ESMlFPfqhmSAqw
Version       : 4.3.36 - 19
Memory Usage  : 46.11MB
Processes     : 1168
Ports         : 14
Zone          : local
Broker        : amqp://127.0.0.1:5672
Globals       : total (0)
Node Info     : kz_amqp_pool: 150/0/0 (ready)
                amqp://guest:guest@127.0.0.1:5672: {"channel_count":162}
WhApps        : ecallmgr(1m41s)
Channels      : 0
Conferences   : 0
Registrations : 0
Media Servers : freeswitch@aio.kazoo.com (1m34s)

# If you don't see the "Media Servers" line:
# you can explicitly add FreeSWITCH servers to ecallmgr
sup -n ecallmgr ecallmgr_maintenance add_fs_node freeswitch@${_HOSTNAME}

# Add Kamailio to the SBC ACLs
sup -n ecallmgr ecallmgr_maintenance allow_sbc kam1 ${IP_ADDR}
updating authoritative ACLs kam1(ip.add.re.ss/32) to allow traffic
issued reload ACLs to freeswitch@aio.kazoo.com

# List SBC ACLs
sup -n ecallmgr ecallmgr_maintenance sbc_acls
+--------------------------------+--------------------+---------------+-------+------------------+----------------------------------+
| Name                           | CIDR               | List          | Type  | Authorizing Type | ID                               |
+================================+====================+===============+=======+==================+==================================+
| kam1                           | ${IP_ADDR}/32    | authoritative | allow | system_config    |                                  |
+--------------------------------+--------------------+---------------+-------+------------------+----------------------------------+

# Check FreeSWITCH for ecallmgr connection info
kazoo-freeswitch status
...
Running mod_kazoo v1.4.0-1
Listening for new Erlang connections on 0.0.0.0:8031 with cookie change_me
Registered as Erlang node freeswitch@aio.kazoo.com, visible as freeswitch
Connected to:
  ecallmgr@${_HOSTNAME} (${IP_ADDR}:8031) up 0 years, 0 days, 0 hours, 7 minutes, 38 seconds

# Check that Kamailio sees FreeSWITCH
kazoo-kamailio status
{
	NRSETS: 1
	RECORDS: {
		SET: {
			ID: 1
			TARGETS: {
				DEST: {
					URI: sip:${IP_ADDR}:11000
					FLAGS: AP
					PRIORITY: 0
				}
			}
		}
	}
}
```

## Setting up MonsterUI

```bash
# Install Monster UI, UI Apps, and Apache
yum -y install monster-ui* httpd

# Update Monster's config for Crossbar's URL
sed -i "/define({/a \ \ \ \ api: { 'default': 'http://${IP_ADDR}:8000/v2/' }," /var/www/html/monster-ui/js/config.js

# Initialize Monster Apps
sup crossbar_maintenance init_apps \
	/var/www/html/monster-ui/apps \
	http://${IP_ADDR}:8000/v2
trying to init app from /var/www/html/monster-ui/apps/numbers
 saved app numbers as doc 94d5eadd9a0531fff63dd886882fe5a1
   saved NumberManager_app.png to 94d5eadd9a0531fff63dd886882fe5a1
   saved numbermanager1.png to 94d5eadd9a0531fff63dd886882fe5a1
   saved numbermanager2.png to 94d5eadd9a0531fff63dd886882fe5a1
trying to init app from /var/www/html/monster-ui/apps/callflows
 saved app callflows as doc 10c442ad16813b8339b36c5c5da373eb
   saved Callflows_app.png to 10c442ad16813b8339b36c5c5da373eb
   saved callflows_1.png to 10c442ad16813b8339b36c5c5da373eb
   saved callflows_2.png to 10c442ad16813b8339b36c5c5da373eb
   saved callflows_3.png to 10c442ad16813b8339b36c5c5da373eb
trying to init app from /var/www/html/monster-ui/apps/fax
 saved app fax as doc 7b15d543fd1cb6cba7988ff15fbf81f4
   saved Fax_app.png to 7b15d543fd1cb6cba7988ff15fbf81f4
   saved OutboundFaxes.png to 7b15d543fd1cb6cba7988ff15fbf81f4
trying to init app from /var/www/html/monster-ui/apps/voicemails
 saved app voicemails as doc 7685e788208c53aa88adea31419db2c0
   saved Voicemail_app.png to 7685e788208c53aa88adea31419db2c0
   saved PlayVoicemail.png to 7685e788208c53aa88adea31419db2c0
   saved SelectedVoicemails.png to 7685e788208c53aa88adea31419db2c0
trying to init app from /var/www/html/monster-ui/apps/webhooks
 saved app webhooks as doc b74bcdd908472f793529a2252f512808
   saved WebHooks_app.png to b74bcdd908472f793529a2252f512808
   saved webhooks1.png to b74bcdd908472f793529a2252f512808
   saved webhooks2.png to b74bcdd908472f793529a2252f512808
trying to init app from /var/www/html/monster-ui/apps/voip
 saved app voip as doc 8258579e9af38d7ac21c61d4f35ec85f
   saved SmartPBX_app.png to 8258579e9af38d7ac21c61d4f35ec85f
   saved smartpbx1.png to 8258579e9af38d7ac21c61d4f35ec85f
   saved smartpbx2.png to 8258579e9af38d7ac21c61d4f35ec85f
   saved smartpbx3.png to 8258579e9af38d7ac21c61d4f35ec85f
   saved smartpbx4.png to 8258579e9af38d7ac21c61d4f35ec85f
   saved smartpbx5.png to 8258579e9af38d7ac21c61d4f35ec85f
trying to init app from /var/www/html/monster-ui/apps/accounts
 saved app accounts as doc eae7a2a348976fb4a56671792dafd0a0
   saved Accounts_app.png to eae7a2a348976fb4a56671792dafd0a0
   saved Account-AvailableApps.png to eae7a2a348976fb4a56671792dafd0a0
   saved Account-Limits.png to eae7a2a348976fb4a56671792dafd0a0
   saved AccountOverview.png to eae7a2a348976fb4a56671792dafd0a0
trying to init app from /var/www/html/monster-ui/apps/pbxs
 saved app pbxs as doc 507f424503a1beb47b383c180b81ca17
   saved PBXconnector_app.png to 507f424503a1beb47b383c180b81ca17
   saved pbxconnector1.png to 507f424503a1beb47b383c180b81ca17
   saved pbxconnector2.png to 507f424503a1beb47b383c180b81ca17
ok

# Start Apache to serve Monster
systemctl enable httpd
systemctl start httpd

# Create the virtual host
echo "<VirtualHost *:80>
  DocumentRoot \"/var/www/html/monster-ui\"
  ServerName ${_HOSTNAME}
</VirtualHost>
" > /etc/httpd/conf.d/${_HOSTNAME}.conf

# Reload Apache
systemctl reload httpd

# Check that Crossbar (the API server) is accessible (responding to requests)
curl http://${IP_ADDR}:8000/v2
{"data":{"message":"invalid credentials"},"error":"401","message":"invalid_credentials","status":"error","timestamp":"2018-05-16T19:08:00","version":"4.2.28","node":"o4fNOLAQ3LJSAzliaNiT1A","request_id":"aeceb6ad9c4f754f92ff8f34e2e8b605","auth_token":"undefined"}

curl http://${IP_ADDR}:8000/v2/webhooks
{"page_size":6,"data":[...],"revision":"19d2d48e5fcc9a7dd0769c2314506eda","timestamp":"2018-05-16T19:08:28","version":"4.2.28","node":"o4fNOLAQ3LJSAzliaNiT1A","request_id":"3f49acd2586eb0ecc4e82a9d397611b0","status":"success"}

# You can now load MonsterUI in your browser at http://${IP_ADDR}
# Use the credentials from the create_account step to log in
```

# Troubleshooting

## Kamailio
There was an issue with librabbitmq versions when installing/updating kazoo-kamailio. If you see something like:

```bash
Error: Package: kamailio-kazoo-5.0.4j-3.1.x86_64 (2600hz-stable)
           Requires: librabbitmq.so.1()(64bit)
```

You can workaround this by disabling the `base` repo (hat-tip btel):

```bash
yum remove librabbitmq
yum --disablerepo="*" --enablerepo=epel install librabbitmq
yum install kazoo-kamailio
```

## CouchDB / Bigcouch

If creating the first account fails, or you see the following in `/var/log/bigcouch/bigcouch.log`:

```
[Tue, 15 May 2018 04:03:03 GMT] [info] [<0.124.0>] [--------] couch_proc_manager <0.3773.0> died normal
[Tue, 15 May 2018 04:03:03 GMT] [error] [<0.254.0>] [941cd296] OS Process Error <0.3792.0> :: {<<"unnamed_error">>,
                                                               <<"(new TypeError(\"cmd is undefined\", \"/opt/bigcouch/share/couchjs/main.js\", 1474))">>}
[Tue, 15 May 2018 04:03:03 GMT] [info] [<0.124.0>] [--------] couch_proc_manager <0.3781.0> died normal
```

This was caused by a CentOS update to the `js` package from `1.8.5-19` to `-20`.

2600Hz is hosting the `-19` version now; if you've installed `-20` you'll need to downgrade:

```shell
yum downgrade js-1:1.8.5-19.el7.x86_64
```

See the [CouchDB issue](https://github.com/apache/couchdb/issues/1293) if you want more info.
