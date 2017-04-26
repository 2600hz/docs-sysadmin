# Installation Guide for Centos 7

This is a reference guide for installing all of the necessary components for Kazoo. Once you have completed this guide, you should have an all-in-one installation of Kazoo complete and ready to configure for use.

The CentOS packages for the various dependencies are installed along with a wrapper that sets up the various configs and scripts that Kazoo needs. So when you install \`kazoo-kamailio\` you get the vanilla Kamailio packages along with the \`kazoo-kamailio\` overlay. Be aware that you'll need to use \`kazoo-kamailio\` when interacting with systemd.


## Setup the server

This guide builds a server using the [CentOS 7 Minimal ISO](http://isoredirect.centos.org/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1511.iso). Once you have that installed on a server (or virtual machine), it is time to setup the host. Some of the commands below are optional (and noted as such) - check whether you need to run them first.

Please remember to replace 'ip.add.re.ss' with your server's actual IP address (not localhost either).

```bash
# Install updates
yum update

# Install required packages
yum install -y yum-utils psmisc

# Hostname setup
hostnamectl set-hostname aio.kazoo.com

echo "ip.add.re.ss aio.kazoo.com aio" >> /etc/hosts
echo "127.0.0.1 aio.kazoo.com aio" >> /etc/hosts

# System time to UTC
ln -fs /usr/share/zoneinfo/UTC /etc/localtime

# Setup networking to auto-start (if necessary)
sed -i 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-eth0
systemctl restart network

# Add 2600Hz RPM server
# You can find the latest 4.0 RPM here: https://packages.2600hz.com/centos/7/stable/2600hz-release/4.0/
export RPMFILE=2600hz-release-4.0-2.el7.centos.noarch.rpm
RPMPATH=centos/7/stable/2600hz-release/4.0/; \
RPMSITE=https://packages.2600hz.com; \
curl -o $RPMFILE -k $RPMSITE/$RPMPATH/$RPMFILE
yum install $RPMFILE

# Set to stable branch (is recommended)
yum-config-manager --disable 2600hz-experimental
yum-config-manager --enable 2600hz-stable

# Clear yum cache
yum clean all


# Setup NTPd
yum install -y ntp
systemctl stop ntpd

# Feel free to use other NTP servers
echo "server ntp.2600hz.com" > /etc/ntp.conf
ntpdate ntp.2600hz.com
systemctl start ntpd
```


## Setting up RabbitMQ

```bash
# Install the Kazoo-wrapped RabbitMQ
yum install -y kazoo-rabbitmq

# Enable and start
systemctl enable kazoo-rabbitmq
systemctl start kazoo-rabbitmq

# Check that RabbitMQ is listening
ss -lpn | grep "5672"

# If you need to forward a port in an active SSH session
# In this case, forward the management port of RabbitMQ
~C
ssh> -L 15672:localhost:15672
Forwarding port.

# For testing purposes, it can be useful to disable iptables (optional)
systemctl stop iptables

# Check out the API (build monitoring tools around this)
curl -i -u guest:guest \
http://localhost:15672/api/overview

curl -i -u guest:guest \
http://localhost:15672/api/aliveness-test/%2F

# Check the status of the broker
kazoo-rabbitmq status
```


## Setting up Kamailio

```bash
# Install Kazoo-wrapped Kamailio
yum install -y kazoo-kamailio

# Update the hostname in the config
sed -i 's/kamailio\.2600hz\.com/aio.kazoo.com/g' /etc/kazoo/kamailio/local.cfg

# Update the IP addresses
sed -i 's/127\.0\.0\.1/ip.add.re.ss/g' /etc/kazoo/kamailio/local.cfg

# Start Kamailio
systemctl enable kazoo-kamailio
systemctl restart kazoo-kamailio

# Check that Kamailio is listening
ss -ln | egrep "5060|7000"

# Add FreeSWITCH to the dispatcher list (FreeSWITCH doesn't exist yet)
echo ":1:sip\:ip.add.re.ss\:11000:0:0::aio-fs" \
>> /etc/kazoo/kamailio/dbtext/dispatcher

# Reload the dispatcher
kamctl fifo ds_reload

# check the dispatcher status
kazoo-kamailio status

# Check stats for the kamailio
kamctl stats
```


## Setting up FreeSWITCH

```bash
# Install Kazoo-wrapped FreeSWITCH
yum install -y kazoo-freeswitch

# Enable and start FreeSWITCH
systemctl enable kazoo-freeswitch
systemctl start kazoo-freeswitch

# Check FreeSWITCH status
fs_cli -x status

# Check mod_kazoo status
fs_cli -x 'erlang status'

# Get the sipify script for FreeSWITCH log parsing
curl -o /usr/bin/sipify.sh \
https://raw.githubusercontent.com/2600hz/community-scripts/master/FreeSWITCH/sipify.sh
chmod 755 /usr/bin/sipify.sh
```

Do note that mod\_sofia isn't loaded on boot. FreeSWITCH is shipped with no dialplan as Kazoo itself controls all of the routing decisions, thus FreeSWITCH isn't of much use until Kazoo is connected.


## Setting up BigCouch

At this time, BigCouch is still "recommended" solely because we don't have the history in production of running CouchDB. Kazoo works just fine with CouchDB 1.6 and 2.0 so feel free to install and configure those packages instead.

```bash
# Install Kazoo-wrapped BigCouch
yum install -y kazoo-bigcouch

# Enable and start BigCouch
systemctl enable kazoo-bigcouch
systemctl start kazoo-bigcouch

# Check that BigCouch is listening
ss -ln | egrep "5984|5986"

# If you need to forward a port to access the API (optional)
~C
ssh> -L 5984:localhost:5984

# Check the API
curl localhost:5984

# Check the admin API
curl localhost:5986

# Check nodes involved in the cluster
curl localhost:5984/_membership | python -mjson.tool
```


## Setting up HAProxy

```bash
# Install the Kazoo-wrapped HAProxy
yum -y install kazoo-haproxy

# Edit /etc/kazoo/haproxy/haproxy.cfg to setup the backend server to point to BigCouch

# Enable and start HAProxy
systemctl enable kazoo-haproxy
systemctl start kazoo-haproxy

# Test the API via HAProxy
curl localhost:15984
```


## Setting up Kazoo Applications

```bash
# Install all the Kazoo applications
yum install -y kazoo-applications kazoo-application-*

# Start Kazoo Applications
systemctl enable kazoo-applications
systemctl start kazoo-applications

# Check all the databases created (may take some time while things initialize)
curl localhost:15984/_all_dbs

# You should have > 20 DBs
curl localhost:15984/_all_dbs | python -mjson.tool | wc -l
24

# Import System Media prompts (takes a while)
sup kazoo_media_maintenance import_prompts /opt/kazoo/sounds/en/us/

# If you need to import other languages (optional)
# sup kazoo_media_maintenance import_prompts /opt/kazoo/sounds/fr/ca fr-ca

# Create the admin account, remember to replace the branced fields
# Example: To create an account with the username root, replace {ADMIN_USER} with root
sup crossbar_maintenance create_account \
{ACCOUNT_NAME} \
{ACCOUNT_REALM} \
{ADMIN_USER} \
{ADMIN_PASS}

# Use SUP to communicate with the running VM
sup -h
```


## Setting up ecallmgr

Traditionally ecallmgr ran in its own VM. This is no longer required and ecallmgr can run in the same VM as the rest of the Kazoo applications if you choose.

```bash
# Start ecallmgr if needed
sup kapps_controller start_app ecallmgr

# Add FreeSWITCH to ecallmgr
sup ecallmgr_maintenance add_fs_node freeswitch@aio.kazoo.com

# Add Kamailio to the SBC ACLs
sup ecallmgr_maintenance allow_sbc kamailio1 ip.add.re.ss

# List SBC ACLs
sup ecallmgr_maintenance sbc_acls

# Check FreeSWITCH for ecallmgr connection info
fs_cli -x "erlang status"

# Check the status of the VM
kazoo-applications status

# Check that Sofia is loaded
fs_cli -x 'sofia status'

# Check that Kamailio sees FreeSWITCH
kazoo-kamailio status
```


## Setting up MonsterUI

```bash
# Install Monster UI, UI Apps, and Apache
yum -y install monster-ui* httpd

# Update Monster's config for Crossbar's URL
sed -i 's/localhost/ip.add.re.ss/' /var/www/html/monster-ui/js/config.js

# Initialize Monster Apps
sup crossbar_maintenance init_apps \
/var/www/html/monster-ui/apps \
http://ip.add.re.ss:8000/v2

# Start Apache to serve Monster
systemctl enable httpd
systemctl start httpd

# Create the virtual host
echo "<VirtualHost *:80>
  DocumentRoot \"/var/www/html/monster-ui\"
  ServerName aio.kazoo.com
</VirtualHost>
" > /etc/httpd/conf.d/aio.kazoo.com.conf

# Reload Apache
systemctl reload httpd

# Check that Crossbar is accessible
curl http://ip.add.re.ss:8000/v2

# You can now load MonsterUI in your browser at http://ip.add.re.ss
```
