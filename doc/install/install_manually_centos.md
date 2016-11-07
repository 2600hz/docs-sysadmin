
Skip to end of metadata
Created by Darren Schreiber, last modified by James Aimonetti on Jun 03, 2013 Go to start of metadata
Pre-Requirements
Packages
CentOS / RedHat
 
yum install -y make ncurses-devel.x86_64 openssl.x86_64 openssl-devel.x86_64 gcc gcc-c++.x86_64 java-1.6.0-openjdk.x86_64 java-1.6.0-openjdk-devel.x86_64 unixODBC-devel.x86_64
Debian / Ubuntu
 
apt-get install make libncurses5-dev libssl-dev gcc g++ openjdk-6-jdk unixodbc-dev
Installing from sources
Download R14B03(R14B01 at a minimum):
 
wget http://erlang.org/download/otp_src_R15B03-1.tar.gz -P /usr/src/
Unpack and install it:
 
tar -C /opt/ -zxf /usr/src/otp_src_R15B03-1.tar.gz
cd /opt/otp_src_R15B03-1/
./configure && make && make install
*Only UnixODBC-Devel package is mentioned as it will also check and install UnixODBC package if needed




Install AMQP

Pre-Requirements
See Installing Erlang
Packages
CentOS / RedHat
 
yum install -y hg libxslt python python-devel python-simplejson.x86_64 zip unzip
Debian / Ubuntu
 
apt-get install -y mercurial libxslt1-dev xsltproc python python-dev python-simplejson zip
Installing from source
Download from Mercurial
 
hg clone http://hg.rabbitmq.com/rabbitmq-codegen /opt/rabbitmq-codegen
hg clone http://hg.rabbitmq.com/rabbitmq-server /opt/rabbitmq-server/
cd /opt/rabbitmq-server/ && make
Modify the following files by replacing 'sname' to 'name':
 
sed -i 's/sname/name/g' /opt/rabbitmq-server/scripts/rabbitmqctl
 
 
sed -i 's/sname/name/g' /opt/rabbitmq-server/scripts/rabbitmq-server
Create rabbitmq-env.conf (replacing YOUR_NODENAME by your hostname):
 
mkdir -p /etc/rabbitmq/
echo "NODENAME=rabbit@YOUR_NODENAME" > /etc/rabbitmq/rabbitmq-env.conf
Install the RabbitMQ Erlang client (replace the XXXXXXXXXXXX by the actual directory name):
 
wget http://hg.rabbitmq.com/rabbitmq-erlang-client/archive/tip.tar.gz -P /usr/src/
tar -C /opt/ -zxf /usr/src/tip.tar.gz
cd /opt/rabbitmq-erlang-client-XXXXXXXXXXXX/
make
launch it
 
cd /opt/rabbitmq-server/scripts/
./rabbitmq-server -detached
 
If it complains about '''ERROR: epmd error for host ...''', make sure your hostname is in your /etc/hosts.
Check Status
 
/opt/rabbitmq-server/scripts/rabbitmqctl status
/opt/rabbitmq-server/scripts/rabbitmqctl list_users
ensure rabbitmq server stays up before proceeding further. Issues related to rabbitmq startup and constant core-dumps can sometimes be resolved by ensuring /var/lib/rabbitmq/mnesia/ is clean





Installing BigCouch

Pre-Requirements
Packages
CentOS / RedHat
 
yum install -y git js-devel libicu libicu-devel openssl openssl-devel python python-devel
CentOS / RedHat 6
Add the EPEL repo.
 
rpm -i http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-5.noarch.rpm
 
 
yum install -y js js-devel
Debian / Ubuntu
 
apt-get install -y git-core nodejs-dev libicu-dev openssl libssl-dev python python-dev libtool xulrunner-dev
 
or follow instructions here for dependencies.
We also need cURL:
 
wget http://curl.haxx.se/download/curl-7.20.1.tar.gz -P /usr/src/
tar -xzf /usr/src/curl-7.20.1.tar.gz -C /usr/src/
cd /usr/src/curl-7.20.1
./configure --prefix=/usr/local && make && make install
Installing from source
Download the code from github
 
git clone git://github.com/cloudant/bigcouch.git /opt/bigcouch
cd /opt/bigcouch/
./configure -p /opt/bigcouch && make dev
 

The make dev target will build a three-node cluster under the rel/ directory. The following steps are used for demonstrating bigcouch cluster situation. for better understand, please refer to the local development couch section at http://bigcouch.cloudant.com/develop
 
 
	If the git complains of an SSL certificate problem, prepend the command with env GIT_SSL_NO_VERIFY=true
The command would then be
 
env GIT_SSL_NO_VERIFY=true git clone git://github.com/cloudant/bigcouch.git /opt/bigcouch
OR
env GIT_SSL_NO_VERIFY=true ./configure -p /opt/bigcouch
 
Edit "/opt/bigcouch/rel/dev1/etc/default.ini" by replacing "YOUR_IP_ADDRESS" with the machine IP address in the following command:
 
sed -i -e 's/127.0.0.1/YOUR_IP_ADDRESS/' /opt/bigcouch/rel/dev1/etc/default.ini
 
Add 'bind_address = 127.0.0.1' at the end of the chttpd section, it should look like this:
 
[chttpd]
port = 15984
backlog = 512
docroot = /opt/bigcouch/rel/dev1/share/www
bind_address = 127.0.0.1
 
	Do the same for "/opt/bigcouch/rel/dev2/etc/default.ini" "/opt/bigcouch/rel/dev3/etc/default.ini" including the chttpd section
 
 
	For a SINGLE Server setup, single interface setup, these IPs can be set to 0.0.0.0 to prevent "connection refused" messages by not knowing what IP to point to
 
Update the bigcouch vm.args for each dev instance so -noinput reads -detached
 
sed -i 's/noinput/detached/' /opt/bigcouch/rel/dev1/etc/vm.args
sed -i 's/noinput/detached/' /opt/bigcouch/rel/dev2/etc/vm.args
sed -i 's/noinput/detached/' /opt/bigcouch/rel/dev3/etc/vm.args
Launching BigCouch:
 
/opt/bigcouch/rel/dev1/bin/bigcouch &
/opt/bigcouch/rel/dev2/bin/bigcouch &
/opt/bigcouch/rel/dev3/bin/bigcouch &
Tell each Node about each other
 
curl localhost:15986/nodes/dev2@127.0.0.1 -X PUT -d '{}'
curl localhost:15986/nodes/dev3@127.0.0.1 -X PUT -d '{}'
This is a one-time step to enable the nodes to replicate amongst themselves.
Node
Port
Admin Port
dev1	15984	15986
dev2	25984	25986
dev3	35984	35986
Setup and Configure HAProxy
Install HAProxy
 
yum install -y haproxy
Add the following at the end of "/etc/haproxy/haproxy.cfg":
 
listen  bccluster 0.0.0.0:5984
    balance roundrobin
    server  bccluster1 127.0.0.1:15984 check
    server  bccluster2 127.0.0.1:25984 check
    server  bccluster3 127.0.0.1:35984 check
 
listen  bccluster_admin 0.0.0.0:5986
    balance roundrobin
    server  bccluster1 127.0.0.1:15986 check
    server  bccluster2 127.0.0.1:25986 check
    server  bccluster3 127.0.0.1:35986 check
Check the configuration file syntax:
 
haproxy -f /etc/haproxy/haproxy.cfg -c
Start HAProxy
 
haproxy -f /etc/haproxy/haproxy.cfg
Start HAProxy automatically
 
chkconfig haproxy on
You can test your BigCouch by issuing the following curl command:
This one will test if the nodes have been linked properly:
 
curl http://127.0.0.1:5984/_membership
This one will show the databases you have, which should be empty now, but it can be useful later:
 
curl http://127.0.0.1:5984/_all_dbs
Note: Only IF BigCouch complains about not finding libcurl.so.4 and DOES NOT run properly , here is how to fix it:
 
yum install -y curl-devel
ln -s /usr/local/lib/libcurl.so.4 /usr/lib64/
 
These instructions apply if you see something similar to this in the logs (/opt/bigcouch/rel/dev[123]/var/log/bigcouch.log)
 
[Wed, 01 Jun 2011 21:33:08 GMT] [error] [<0.1188.0>] [0378f40b] OS Process Error <0.1539.0> :: {os_process_error,{exit_status,127}}
[Wed, 01 Jun 2011 21:33:08 GMT] [info] [<0.101.0>] [--------] couch_proc_manager <0.1520.0> died normal
 
or you can run the couchjs process and if you see output similar to the following:
 
bigcouch@localhost:~# /opt/bigcouch/rel/dev1/bin/couchjs 
/opt/bigcouch/rel/dev1/bin/couchjs: error while loading shared libraries: libmozjs.so: cannot open shared object file: No such file or directory
 
Common errors
Whapps won't start with the following error:
 
1> {"init terminating in do_boot",{{case_clause,{error,{shutdown,{whistle_couch_app,start,[normal,[]]}}}},[{whistle_apps,ensure_started,1},{whistle_apps,start,0},{init,start_it,1},{init,start_em,1}]}}
 
This is generally caused because Whistle can't reach your BigCouch nodes. Things to ensure:
Your $WHISTLE/lib/whistle_couch/priv/startup.config is pointing to your HAProxy IP/Ports (usually 5984 and 5986).
Your HAProxy IPs for the BigCouch nodes match what's in your BigCouch etc/default.ini (or etc/local.ini) bind_address / port.
Test, using curl, both HAProxy's IP/Ports and each BigCouch nodes' IP/Ports that they return a JSON string.
Check BigCouch's default.ini for "bind_address = 0.0.0.0". If you're having issues connecting to this host from the HAProxy server, change the bind_address IP to the IP HAProxy is trying to connect on.
Any changes to the configs require a restart of the corresponding service.


Install FreeSWITCH
This guide is based on the official FreeSWITCH installation Guide
Pre-Requirements
See Installing Erlang
Packages
CentOS / RedHat
 
yum install -y git gcc gcc-c++.x86_64 ncurses-devel.x86_64 autoconf automake libtool libjpeg-devel sox libvorbis libvorbis-devel libogg libogg-devel
CentOS / RedHat 6
 
yum install -y patch
Debian / Ubuntu
 
apt-get install -y git-core gcc g++ ncurses-base ncurses-bin autoconf libjpeg8-dev libtool sox libcurl4-openssl-dev libvorbis-dev libogg-dev
Installing from sources
Fetch the latest code from the FreeSWITCH git repo
 
git clone git://git.freeswitch.org/freeswitch.git /usr/src/freeswitch
Note that it is recommend to get code from https://github.com/2600hz/FreeSWITCH
Bootstrap
 
cd /usr/src/freeswitch
./bootstrap.sh
Uncomment "#formats/mod_shout", "#event_handlers/mod_erlang_event" and "#formats/mod_shout" from "modules.conf"
 
sed -i -e 's|#formats/mod_shout|formats/mod_shout|g' -e 's|#event_handlers/mod_erlang_event|event_handlers/mod_erlang_event|g' -e 's|#formats/mod_shout|formats/mod_shout|g' modules.conf
Run the configure script and compile FreeSWITCH
 
./configure -C && make all install sounds-install moh-install mod_erlang_event-install mod_shell_stream-install
Make sure that there is a freeswitch user
 
grep freeswitch /etc/passwd
If not, go ahead and create one.
 
/usr/sbin/useradd -c "FreeSWITCH USER" -d /usr/local/freeswitch -s /sbin/nologin freeswitch
Create FreeSWITCH init script
 
cd /etc/init.d
touch freeswitch
chmod a+x ./freeswitch
Then copy and paste the script below into your freeswitch file.
 
#!/bin/bash
#
#       /etc/rc.d/init.d/freeswitch
#
#       The FreeSwitch Open Source Voice Platform
#
#  chkconfig: 345 89 14
#  description: Starts and stops the freeswitch server daemon
#  processname: freeswitch
#  config: /opt/freeswitch/conf/freeswitch.conf
#  pidfile: /opt/freeswitch/run/freeswitch.pid
#
 
# Source function library.
. /etc/init.d/functions
 
PROG_NAME=freeswitch
PID_FILE=${PID_FILE-/usr/local/freeswitch/run/freeswitch.pid}
FS_USER=${FS_USER-freeswitch}
FS_FILE=${FS_FILE-/usr/local/freeswitch/bin/freeswitch}
FS_HOME=${FS_HOME-/usr/local/freeswitch}
LOCK_FILE=/var/lock/subsys/freeswitch
FREESWITCH_ARGS="-nc"
RETVAL=0
 
# Source options file
if [ -f /etc/sysconfig/freeswitch ]; then
    . /etc/sysconfig/freeswitch
fi
 
# <define any local shell functions used by the code that follows>
 
start() {
        echo -n "Starting $PROG_NAME: "
        if [ -e $LOCK_FILE ]; then
            if [ -e $PID_FILE ] && [ -e /proc/`cat $PID_FILE` ]; then
                echo
                echo -n $"$PROG_NAME is already running.";
                failure $"$PROG_NAME is already running.";
                echo
                return 1
            fi
        fi
    cd $FS_HOME
        daemon --user $FS_USER --pidfile $PID_FILE "$FS_FILE $FREESWITCH_ARGS $FREESWITCH_PARAMS >/dev/null 2>&1"
        echo
        RETVAL=$?
        [ $RETVAL -eq 0 ] && touch $LOCK_FILE;
    echo
        return $RETVAL
}
 
 
stop() {
        echo -n "Shutting down $PROG_NAME: "
        if [ ! -e $LOCK_FILE ]; then
            echo
            echo -n $"cannot stop $PROG_NAME: $PROG_NAME is not running."
            failure $"cannot stop $PROG_NAME: $PROG_NAME is not running."
            echo
            return 1;
        fi
    cd $FS_HOME
    $FS_FILE -stop > /dev/null 2>&1
        killproc $PROG_NAME
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] &&  rm -f $LOCK_FILE;
        return $RETVAL
}
 
rhstatus() {
    status $PROG_NAME;
}
 
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status $PROG_NAME
    RETVAL=$?
        ;;
    restart)
        stop
        start
        ;;
    reload)
#        <cause the service configuration to be reread, either with
#        kill -HUP or by restarting the daemons, in a manner similar
#        to restart above>
        ;;
    condrestart)
        [ -f $PID_FILE ] && restart || :
    ;;
    *)
        echo "Usage: $PROG_NAME {start|stop|status|reload|restart}"
        exit 1
        ;;
esac
exit $RETVAL
Save the file, add the service (We will start it after a few more configuration changes)
 
/sbin/chkconfig --add freeswitch
/sbin/chkconfig --level 345 freeswitch on
Checkout our Whistle FreeSWITCH configuration repositoryand replace the default FS config
 
rm -Rf /usr/local/freeswitch/conf
git clone https://github.com/2600hz/whistle-fs.git /usr/local/freeswitch/conf
 
 
	If the git complains of an SSL certificate problem, prepend the command with env GIT_SSL_NO_VERIFY=true
The command would then be
 
env GIT_SSL_NO_VERIFY=true git clone https://github.com/2600hz/whistle-fs.git /usr/local/freeswitch/conf
 
 
	It was found useful to create a Domain entry in the $FREESWITCH_HOME/conf/directory folder to allow for the local domain used in the FQDN of the Nodename/Hostname in earlier steps.
This can be done via:
 
# vim /usr/local/freeswitch/conf/directory/%DOMAIN%.xml ////where %DOMAIN% is replaced by the domain part of the hostname FQDN
<include>
    <domain name="example.com">
        <user id="ecallmgr">
                <params>
                </params>
        </user>
    </domain>
</include>
Modify "erlang_event.conf.xml" by replacing "MY_HOSTNAME" by the machine hostname in the following command
 
sed -i -e 's/%HOSTNAME%/MY_HOSTNAME/g' /usr/local/freeswitch/conf/autoload_configs/erlang_event.conf.xml
Change the rights
 
chmod 600 /usr/local/freeswitch/conf/autoload_configs/.erlang.cookie
 
Then copy the FreeSWITCH cookie in "/usr/local/freeswitch/conf/autoload_configs/.erlang.cookie"
 
///Change this to something different than the default cookie string
Edit "/usr/local/freeswitch/conf/autoload_configs/modules.conf.xml" to enable "mod_shout" at startup
 
<load module="mod_native_file"/>
<!--For icecast/mp3 streams/files-->
<load module="mod_shout"/>          <!-- NEW -->
Fix files ownership
 
chown -R freeswitch:freeswitch /usr/local/freeswitch
Start FreeSWITCH and Open the FreeSWITCH cli
 
/sbin/service freeswitch start
/usr/local/freeswitch/bin/fs_cli
Type those commands to load the modules
 
reload mod_erlang_event
reload mod_shell_stream
reload mod_shout
/exit
Restart FreeSWITCH
 
/sbin/service freeswitch restart




Install Kazoo
Pre-Requirements
See Installing Erlang
See Installing FreeSWITCH
See Installing Big Couch
See Installing AMQP
Packages
CentOS / RedHat
 
sudo yum install -y git zip unzip
Debian / Ubuntu
 
sudo apt-get install -y git-core zip unzip
Download Kazoo
Via git:
 
git clone https://github.com/2600hz/kazoo.git /opt/kazoo
 
	If the git complains of an SSL certificate problem, prepend the command with env GIT_SSL_NO_VERIFY=true
The command would then be
 
env GIT_SSL_NO_VERIFY=true git clone https://github.com/2600hz/kazoo.git /opt/kazoo
 
Via rpm: (coming soon)
 
wget 'http://somewhere.2600hz.org/kazoo.rpm'; rpm -i kazoo.rpm
Via deb: (coming soon)
 
wget 'http://somewhere.2600hz.org/kazoo.deb'; dpkg -i kazoo.deb
First, Create a Kazoo user and change permission:
 
useradd -m -d /opt/kazoo -s /bin/bash kazoo
chown -R kazoo:kazoo /opt/kazoo
su - kazoo
alias sup="/opt/kazoo/utils/sup/sup" # I like to add this to the kazoo user's bash profile
Build the project:
 
export ERL_LIBS=/opt/kazoo/lib
cd /opt/kazoo
make clean all
Update $YOUR_COOKIE in "/opt/kazoo/ecallmgr/conf/vm.args" with the string you put in the "/usr/local/freeswitch/conf/autoload_configs/.erlang.cookie"
 
///Change: -setcookie $YOUR_COOKIE
Update $YOUR_COOKIE in "/opt/kazoo/whistle_apps/conf/vm.args" to something else
 
///Change: -setcookie $YOUR_COOKIE
The default Kazoo-RabbitMQ interface is localhost, it is recommended that you change that here:
 
vim /opt/kazoo/lib/whistle_amqp-1.0.0/priv/startup.config
///change localhost to the interface you wish to use
The default interface, port, username and password for CouchDB are stored here, it is recommended that you change those:
 
vim /opt/kazoo/whistle_apps/lib/whistle_couch-1.0.0/priv/startup.config
/// you can change the default interface, port, username and password for CouchDB
The default WhApps can be modified here:
 
vim /opt/kazoo/whistle_apps/priv/startup.config
/// select the default WhApps you wish to run here
The Crossbar listening interface and port are set here, it is recommended that you change that here:
 
vim /opt/kazoo/whistle_apps/apps/crossbar/priv/crossbar.config
/// modify the Crossbar listening interface and port here
For simplicity's sake, match the cookie value in /usr/local/freeswitch/conf/autoload_configs/.erlang.cookie with the one in:
 
/opt/kazoo/ecallmgr/conf/vm.args
Start ecallmgr in dev mode:
 
cd /opt/kazoo/ecallmgr/
./start-dev.sh
You should see output related to AMQP, loading the initial list of FreeSWITCH nodes, etc.
When you're ready to run long term, use the start.sh script to start ecallmgr in daemon mode.
Replace $NODENAME by the nodename you gave mod_erlang_event in the FS conf file, it should be something like freeswitch@your_hostname:
 
sup -n ecallmgr ecallmgr_maintenance add_fs_node freeswitch@$NODENAME
Verify it connected:
 
sup -n ecallmgr ecallmgr_maintenance list_fs_nodes
Start WhApps
Start it in dev mode:
 
cd /opt/kazoo/whistle_apps/
./start-dev.sh
You should logging related to connecting to AMQP and BigCouch, and starting the initial set of whapps.
Start a Whapp (like crossbar, registrar or callflow for example):

 
sup whapps_controller start_app WHAPP_NAME
Check what whapps are running:
 
sup whapps_controller running_apps
Additional notes
To get default media prompts, you must
Start the media manager Whapp:
 
sup whapps_controller start_app media_mgr
Import the freeswitch media files to Kazoo:
 
cd /opt/kazoo/utils/media_importer
./media_importer /opt/kazoo/confs/system_media/*.wav




Install Kamailio

How to install Kazoo-enabled Kamailio
Clone Kamailio
git clone git://git.sip-router.org/sip-router kamailio
Clone the Kazoo Kamailio extensions
git clone https://github.com/2600hz/kamailio-qa
Clone the rabbitmq-c lib
git clone https://github.com/2600hz/rabbitmq-c
 
Build the lib
cd rabbitmq-c
autoreconf -fi
./configure
make
sudo make install
cd ../
Clone the json-c lib
git clone https://github.com/2600hz/json-c
 
Build the lib
cd json-c
autoreconf -fi
./configure
make
sudo make install
cd ../
Enter the kamailio repositiory
cd kamailio
Checkout the 4.0 branch
git checkout -b 4.0 origin/4.0
Apply the Kazoo patch
git apply ../kamailio-qa/db_kazoo-blf-reg.patch
Set build variables and compile
EXCLUDE_MODULES="alias_db \
path \
cfg_rpc \
corex \
mi_rpc \
async \
auth_diameter \
avpops \
avp \
benchmark \
blst \
call_control \
cfg_db \
counters \
db2_ops \
db_cluster \
db_flatstore \
debugger \
diversion \
dmq \
domainpolicy \
domain \
drouting \
enum \
exec \
group \
imc \
ipops \
malloc_test \
mangler \
matrix \
mediaproxy \
mi_datagram \
mqueue \
msilo \
msrp \
mtree \
nat_traversal \
pdb \
pdt \
pipelimit \
prefix_route \
print_lib \
print \
p_usrloc \
qos \
ratelimit \
rtimer \
rtpproxy \
sca \
sdpops \
seas \
sipcapture \
siptrace \
sms \
speeddial \
sqlops \
sst \
statistics \
timer \
tmrec \
topoh \
uid_auth_db \
uid_avp_db \
uid_domain \
uid_gflags \
uid_uri_db \
uri_db \
userblacklist \
xhttp_rpc \
xhttp \
xprint"
 
INCLUDE_MODULES="pua_dialoginfo \
presence \
presence_dialoginfo \
snmpstats"
 
make FLAVOUR=kamailio cfg skip_modules="${EXCLUDE_MODULES}" include_modules="${INCLUDE_MODULES}" prefix=/opt/kamailio/ modules_dirs="modules"
 
make install
Edit 'prefix' in the make command to change the install path for Kamailio.
Remove 'snmpstats' if you want.
Configure Kamailio
First setup the Kazoo configs in place of the stock Kamailio
cd /opt/kamailio/
rm -rf etc/*
ln -s /etc/kazoo/kamailio etc/kamailio
Now edit etc/dbtext/dispatcher:
### Dispatcher Set IDs:
### 1 - Primary media servers
### 2 - Backup media servers
### 3 - Alternate media server IPs (used only for classification)
### 10 - Presence servers (if not locally handled)
### 20 - Registrar servers (if not locally handled)
# setid(integer) destination(sip uri) flags (integer, optional)
1 sip:ip.of.fs1.srv:port 0
1 sip:ip.of.fs2.srv:port 0
Now edit etc/local.cfg:
Edit lines starting with "listen" to reflect the interfaces you want Kamailio to listen on 
edit the "db_url" parameters to point to your RabbitMQ broker
Run Kamailio
/opt/kamailio/sbin/kamailio -f /opt/kamailio/etc/kamailio.cfg



