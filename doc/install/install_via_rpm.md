## Install via RPM



Overview
 
This document explains how to install Kazoo 3.0 on a multi-server environment. For a single server installation, see Kazoo Single Server Install or via Kazoo Single Server ISO.
 
Deploying a Kazoo v3.0 cluster
Prerequisites for every server
Setup Kazoo yum repository
curl -o /etc/yum.repos.d/2600hz.repo http://repo.2600hz.com/2600hz.repo
Ensure that each node has a FQDN
hostname -f
Ensure that all nodes can reach each other and the hostnames are resolvable to each other

 Verify that SELINUX is disabled.
sestatus
Clear yum repository cache
yum clean all
Bigcouch Servers
We recommend that you provision at least 3 Bigcouch servers.
Install Bigcouch package and tools
yum install -y kazoo-bigcouch-R15B
If you are using multiple Bigcouch servers, you must cluster them together. To do this, run the following commands on only your first Bigcouch server:
curl -X PUT db01.yourhostname.com:5986/nodes/bigcouch@db02.yourhostname.com -d {}
curl -X PUT db01.yourhostname.com:5986/nodes/bigcouch@db03.yourhostname.com -d {}
Verify your Bigcouch nodes are clustered
curl 127.0.0.1:5984/_membership
FreeSWITCH Server
 We recommend that you provision at least 2 FreeSWITCH servers.
Install FreeSWITCH package and tools
yum install -y kazoo-freeswitch-R15B haproxy
Edit the cookie for the Kazoo Erlang module in FreeSWITCH. If you changed the Cookie on any other servers, it needs to match here as well. The file is /etc/kazoo/freeswitch/autoload_configs/kazoo.conf.xml
<param name="cookie" value="change_me" />-->
Start epmd
epmd -daemon
Restart FreeSWITCH
service freeswitch restart
Create a symlink from /etc/kazoo/haproxy/haproxy.cfg to /etc/haproxy/haproxy.cfg
rm -rf /etc/haproxy/haproxy.cfg
ln -s /etc/kazoo/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg
Configure /etc/haproxy/haproxy.cfg to look like this, adding your database nodes' hostnames and IP addresses, so FreeSWITCH can grab the media directly from the database:
 Expand source
Start/restart HAProxy
service haproxy restart
Set HAProxy and FreeSWITCH to start on boot
chkconfig haproxy on
chkconfig freeswitch on
To enter the FreeSWITCH CLI, use this command:
fs_cli
Kazoo Server
We recommend that you provision at least 2 Kazoo servers.
Install Kazoo packages and tools
yum install -y kazoo-R15B kazoo-kamailio haproxy rsyslog
If you also want the web portal to be on this server, install those packages
yum install -y httpd kazoo-ui
Update Kamailio configurations by adding the server's IP address
#Replace $RABBIT_IP with the IP address of the node that you are going to run the main RabbitMQ messaging bus on (generally the first Kazoo server)
#Replace $HOST_IP with the current host IP address
#Replace $HOSTNAME with the current host hostname
sed -i 's/guest:guest@127.0.0.1:5672\/dialoginfo/guest:guest@'$RABBIT_IP':5672\/dialoginfo/g' /etc/kazoo/kamailio/local.cfg
sed -i 's/guest:guest@127.0.0.1:5672\/callmgr/guest:guest@'$RABBIT_IP':5672\/callmgr/g' /etc/kazoo/kamailio/local.cfg
sed -i 's/127.0.0.1/'$HOST_IP'/g' /etc/kazoo/kamailio/local.cfg
sed -i 's/kamailio.2600hz.com/'$HOSTNAME'/g' /etc/kazoo/kamailio/local.cfg
Update Kazoo configuration by adding the correct RabbitMQ server IP address
#Replace $RABBIT_IP with the IP address of the node that you are going to run the main RabbitMQ messaging bus on (generally the first Kazoo server)
#You should not run this command on your RabbitMQ server
  
sed -i "s|uri = \"amqp://guest:guest@127.0.0.1:5672\"|uri = \"amqp://guest:guest@$RABBIT_IP:5672\"|g" /etc/kazoo/config.ini


If you made any changes to the "cookie" value in the mod_kazoo configuration, you'll need to update config.ini to reflect that change for ecallmgr
# /etc/kazoo/config.ini
 
[ecallmgr]
cookie = should_match_mod_kazoo_cookie
Create a symlink from /etc/kazoo/haproxy/haproxy.cfg to /etc/haproxy/haproxy.cfg
rm -rf /etc/haproxy/haproxy.cfg
ln -s /etc/kazoo/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg
Configure /etc/haproxy/haproxy.cfg by adding your database nodes' hostnames and IP addresses. See this example:
 Expand source
Configure the UI (If you are running the UI on this node)
#Replace $HOST_IP with current host IP address
/bin/sed -i s#https://api.zswitch.net:8443/v1#http://$HOST_IP:8000/v1#g /var/www/html/kazoo-ui/config/config.js
 
 
#OPTIONAL | This sets the default document of your web-server to the Kazoo-UI
/bin/sed -i 's#/var/www/html#/var/www/html/kazoo-ui#g' /etc/httpd/conf/httpd.conf
Configure the list of FreeSWITCH Servers Kamailio should distribute calls amongst by editing /etc/kazoo/kamailio/dbtext/dispatcher
# Add your FreeSWITCH Servers like this:
1 sip:IP.OF.FS1.SERVER:11000 2
1 sip:IP.OF.FS2.SERVER:11000 2
1 sip:IP.OF.FS3.SERVER:11000 2
1 sip:IP.OF.FS4.SERVER:11000 2
Start services
#Only start RabbitMQ on your designated RabbitMQ servers
service rabbitmq-server start
  
service rsyslog restart
service haproxy start
service kz-whistle_apps start
service kz-ecallmgr start
service kamailio start
service httpd start
If Kamailio fails to start, ensure that /etc/kazoo/kamailio/local.cfg is properly configured with the host IP address and the RabbitMQ node IP address. Also ensure that rabbitmq-server is running on the RabbitMQ node.

Set services to start on boot
chkconfig --add kz-whistle_apps
chkconfig --add kz-ecallmgr
chkconfig kz-whistle_apps on
chkconfig kz-ecallmgr on
chkconfig haproxy on
  
#Only set RabbitMQ to start on your designated RabbitMQ servers
chkconfig --add rabbitmq-server
chkconfig rabbitmq-server on
#If this is a web interface server
chkconfig httpd on
Post Installation
Once you have installed all the tools and ensured that everything is running, make sure that the Kazoo servers can reach the database through HAproxy. On each Kazoo node, run the following command, you should receive a short string back from Bigcouch:
curl localhost:15984
If this command fails, ensure Bigcouch and HAproxy are running and configured properly, the hostnames are resolvable to each other, and there are no IPtables rules blocking ports 15984, 15986, 5984, or 5986 between nodes.
Create the admin level account for Kazoo by running this command on a Kazoo node (MAKE SURE EVERYTHING YOU SET IS LOWERCASE!!!):
# Restart whapps to make sure all the crossbar modules are loaded
service kz-whistle_apps restart
  
## Create the account

/opt/kazoo/utils/sup/sup crossbar_maintenance create_account ACCOUNTNAME SIP.REALM.COM USERNAME PASSWORD
Connect Ecallmgr to your FreeSWITCH servers
#Run this command for each FreeSWITCH server
/opt/kazoo/utils/sup/sup -n ecallmgr ecallmgr_maintenance add_fs_node freeswitch@hostname.of.freeswitchserver.com
If you don't see connection attempts from ecallmgr to FreeSWITCH in the fs_cli, there is a good chance the default IP tables rules are blocking ecallmgr from connecting to the FreeSWITCH server. Disable iptables or add the appropriate rules to accept traffic from the ecallmgr server and all should be well.
Flush your WHAPPS cache to have changes take effect
/opt/kazoo/utils/sup/sup whapps_config flush
/opt/kazoo/utils/sup/sup -n ecallmgr ecallmgr_config flush
To check if Ecallmgr is connected to FreeSWITCH, run the following command in your FreeSWITCH CLI:
erlang nodes list
Check that Kamailio is properly distributing calls amongst your FreeSWITCH servers. You should see the IPs of your servers with flags=AP after each server.
kamctl fifo ds_list
Import media files to Kazoo
sup whistle_media_maintenance import_prompts /opt/kazoo/system_media/en-us/
Add Kamailio IP's to ACL's as "authoritative" and incoming servers as "trusted" (see Inbound Calls Fail).
/opt/kazoo/utils/sup/sup -necallmgr ecallmgr_maintenance allow_sbc hostname.of.kazooserver.com IP.OF.KAZOO.SERVER

Kazoo should now be configured and ready for use. You should probably add some IPtables rules to prevent unwanted access.
Access the web interface at "http://yourdomain.com" using the account you created in "Post Installation" step 2.

ADVANCED CONFIG / CONFIGURATION GOODIES (smile)

Platform management: The platform is managed via API or the SUP command from a shell. You can find all the available SUP commands here: How to use the SUP command.
Cookies...num......num.....num - Well not that kind of cookie. Cookies are what allow all of the different programs to communicate with one another. If you modify the cookie set in this file, you must also adjust the corresponding cookie within each application's configuration file. By default we set "cookie = change_me" with the value of the cookie being "change_me". For testing and development this default configuration is fine. 
/etc/kazoo/config.ini   - Main Kazoo Configuration File
; section are between [] = [section]
; key = value
; to comment add ";" in front of the line
 
[amqp]
uri = "amqp://guest:guest@127.0.0.1:5672"
 
[bigcouch]
compact_automatically = false
cookie = change_me
ip = "127.0.0.1"
port = 15984
;username = ""
;password = ""
admin_port = 15986
 
[whistle_apps]
cookie = change_me
 
[ecallmgr]
cookie = change_me
 
[log]
syslog = info
console = notice
file = error 
LikeJunchen Li likes this
No labels Edit Labels
3 Comments
 User icon: martexx
martin splinter
And then what? rpm -i kazoowhateverVersion    ??
ReplyEditDeleteLike•Oren Yehezkely likes thisJun 14, 2013
 User icon: vladimir.ralev
Vladimir Ralev
It looks like the freeswitch RPM doesn't include the /etc/kazoo config dirs and fails to boot?
It gives the following:
14-02-21 13:47:06.448639 [INFO] switch_event.c:669 Activate Eventing Engine.
2014-02-21 13:47:06.450068 [WARNING] switch_event.c:651 Create additional event dispatch thread 0
2014-02-21 13:47:06.451333 [ERR] switch_xml.c:1386 Couldnt open /etc/kazoo/freeswitch/freeswitch.xml (No such file or directory)
Cannot Initialize [Cannot Open log directory or XML Root!]
 
I did 
`rpm -ql kazoo-freeswitch-R15B`
to list the files inside the RPM and it is missing.
ReplyEditDeleteLikeFeb 21, 2014
User icon: 
Anonymous
I'm having this issue also on my bigcouch server.
Error in PREIN scriptlet in rpm package kazoo-configs-3.0-56.el6.noarch
find: `/etc/kazoo': No such file or directory
find: `/etc/kazoo/freeswitch/': No such file or directory
error: %pre(kazoo-configs-3.0-56.el6.noarch) scriptlet failed, exit status 1
error: install: %pre scriptlet failed (2), skipping kazoo-configs-3.0-56.el6
Installing : kazoo-bigcouch-R15B-0.4.x-1.el6.x86_64 2/2
Starting bigcouch: [ OK ]
Verifying : kazoo-bigcouch-R15B-0.4.x-1.el6.x86_64 1/2
Verifying : kazoo-configs-3.0-56.el6.noarch 2/2
Installed:
kazoo-bigcouch-R15B.x86_64 0:0.4.x-1.el6
Failed:
kazoo-configs.noarch 0:3.0-56.el6
