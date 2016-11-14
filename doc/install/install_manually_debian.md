## Install Debian Manually


This guide is a bit outdated and will install on a unrecommended platform. Its not impossible, nut also not for the weak of heart.
 
Try the single server install (script), the **Kazoo** single server ISO install (experimental) or follow the general install instructions.


## Introduction

This installation guide is written to install **Kazoo**, **FreeSWITCH**, **RabbitMQ** and **BigCouch** on a single **Ubuntu** box. I have tested it on **Ubuntu** 12.04 and 13.04. **FreeSWITCH** is build from source as deb packages. **Erlang**, **RabbitMQ** and **BigCouch** are installed using Debian/Ubuntu package manager that is `apt-get`.

I have prepared few scripts to automate the build process. I have copied these scripts **FreeSWITCH** wiki and other sources from Internet.  None of these scripts are my own creation but I have modified them to fix the bugs or to make them run on latest version of **Ubuntu**. I am thankful to the original others for providing these scripts.


## Prepare Build Process

Create a `src` directory in your home folder where we will run the build process. Please note build process will be run as normal user. You must have permissions to `sudo` command.

`mkdir ~/src`

Clone the script git repository to checkout the utility scripts.

`git clone https://github.com/rajbsaini/scripts`


## Install **Erlang** & **RabbitMQ**

**Kazoo** depends on `esl-erlang R15B03-1`. **Erlang** form **Ubuntu** repository does not include `erlang-nox` package, therefore, we would need to create a dummy `erlang-nox` package and its dependencies to install `esl-erlang` properly. I have found a script (https://gist.github.com/RJ/2284940) which does this job. However, out of the box this does not install the R15B03-1 version. I have modified this script to install the correct version. This script will also install the latest **RabbitMQ** from **RabbitMQ** repository.
Change to the script directory and Install `esl-erlang` and **RabbitMQ Erlang**:

`sudo ./install-esl-erlang.sh`

Verify if **RabbitMQ** is running.

`service rabbitmq-server status`

If **RabbitMQ** is not running you start the **RabbitMQ** using:

`service rabbitmq-server start`


## Install BigCouch

Follow the **BigCouch** install and user guide at http://bigcouch.cloudant.com/use to install **BigCouch**. In summary:
```
echo "deb http://packages.cloudant.com/ubuntu `lsb_release -cs` main" | sudo tee /etc/apt/sources.list.d/cloudant.list
sudo apt-get update
sudo apt-get install bigcouch
```

You will see unauthenticated repository error/warning. You can ignore them for now. This will install the **BigCouch** in /opt/bigcouch directory. You can start/stop **BigCouch** using:
```
sv start bigcouch #start BigCouch
svn stop bigcouch #stop BigCouch
```

Configure **BigCouch**

To set admin users and database folder edit the `local.ini` in `/opt/bigcouch/etc folder`:
```
; local customizations are stored here
[admins]
admin = your admin password
kazoo = your admin password

;location of database folder
[couchdb]
database_dir = /var/lib/bigcouch
view_index_dir = /var/lib/bigcouch

;log file location
[log]
file = /var/log/bigcouch/bigcouch.log
level = info
include_sasl = true
[couch_httpd_auth]
secret = <some password>
Create database and log folder and assign proper ownership:
mkdir /var/lib/bigcouch
mkdir /var/log/bigcouch

chown bigcouch:daemon/var/lib/bigcouch /var/log/bigcouch
 
Edit vm.args file in /opt/bigcouch/etc, to set the cookies and -name
# Each node in the system must have a unique name. A name can be short
# (specified using -sname) or it can by fully qualified (-name). There can be
# no communication between nodes running with the -sname flag and those running 
# with the -name flag
#Fqdn examle: bigcouch@example.com-name bigcouch@<your fqdn>  

# All nodes must share the same magic cookie for distributed Erlang to work.
# Comment out this line if you synchronized the cookies by other means (using
# the ~/.erlang.cookie file, for example).
-setcookie <some cookie name>

# Tell SASL not to log progress reports
-sasl errlog_type error

# Use kernel poll functionality if supported by emulator
+K true

# Start a pool of asynchronous IO threads
+A 16

# Comment this line out to enable the interactive Erlang shell on startup
+Bd -noinput
```

You will need to restart **BigCouch** for this to take effect:

`sv restart bigcouch`


## Install FreeSWITCH

**FreeSWITCH** wiki have a nice guide to install the **FreeSWITCH** using **Debaian** build process. You can copy the script from http://wiki.freeswitch.org/wiki/Ubuntu_Quick_Start#Introduction_to_Ubuntu_and_FreeSWITCH to automate the build. **Kazoo** needs few extra **FreeSWITCH** modules which are not enabled out of the box in **FreeSWITCH** **Ubuntu/Debian** build process. Therefore, You will need to create a `modules.conf` file in the build folder i.e. `~/src`. Git repository cloned in "Prepare Build" step has a `modules.conf` file. This file has all the requisite modules and you can copy this file instead of creating your own.

Run **FreeSWITCH** build from your build directory that is `~/src`.

`./scripts/install-freeswitch.sh `

Build **FreeSWITCH** sound and music packages:

`./script/install-freeswitch-sound.sh`


## Install FreeeSWITCH
```
cd ~/src

#move debug deb packages to a folder
mkdir dbg
mv *dbg*.deb dbg

#install FreeSWITCH lib
sudo dpkg -i libfreeswitch1_1.2.11~n20130730T132523Z-1~precise+1_amd64.deb 

#install other FreeSWITCH packages.
sudo dpkg -i freeswitch*

#Fix file and folder ownership ownership
sudo chown -R freeswitch:daemon /etc/freeswitch/

#fix music paths
cd /usr/share/freeswitch/sounds/music
sudo ln -s default/8000 8000
sudo ln -s default/16000 16000
sudo ln -s default/32000 32000
sudo ln -s default/48000 48000
```

We will configure **FreeSWITCH** along with **Kazoo**. You can start/stop the **FreeSWITCH** with:
```
sudo service freeswitch start     #Start FreeSWITCH
sudo service freeswitch stop      #Stop FreeSWITCH
sudo service freeswitch restart   #Restart FreeSWITCH

```

## Installing **Kazoo**

Install dependencies:

`apt-get install -y xsltproc zip`

Download Kazoo from git repository. I have tested branch 3.0 and 2.12, Master branch may work but I did not test it.

`git clone -b 3.0  git://github.com/2600hz/kazoo.git /opt/kazoo`

Compile **Kazoo**:
```
cd /opt/kazoo
make
```
TO configure **Kazoo**, checkout the configuration repository to /etc/kazoo folder:

`sudo git clone https://github.com/2600hz/kazoo_configs /etc/kazoo`

Edit the `config.ini` in `/etc/kazoo` folder:
```
; section are between [] = [section]
; key = value
; to comment add ";" in front of the line
[amqp]
uri = "amqp://guest:guest@127.0.0.1:5672"

[bigcouch]
compact_automatically = true
cookie = <your unique cookie>
ip = "127.0.0.1"
port = 5984
username = "kazoo"
password = "<password set in BigCouch admin"
admin_port = 5986

[whistle_apps]
cookie = <your unique cookie>

[ecallmgr]
cookie = <your unique cookie>

[log]
syslog = info
console = notice
file = error
Test  Kazoo applications:
cd /opt/kazoo/scripts
./dev-start-apps.sh
```

You will see plenty of log messages on terminal window. Make sure you don't see any database connectivity or **RabbitMQ** connectivity errors. If there are any errors, fix them and restart applications in dev mode. If applications start properly, start the **Kazoo** applications in background:

`./start-appp.sh`

Test **Kazoo** `ecallmgr`:
```
cd /opt/kazoo/scripts
./dev-start-ecallmgr.sh
```
If applications start properly, start the **Kazoo** `ecallmgr`  in background:

`./start-ecallmgr.sh`


## Configure FreeSWITCH

**Kazoo** configuration repository checked out in `/etc/kazoo folder` in previous step have a configuration folder for **FreeSWITCH**. You  will need to move the configuration files installed with out of the box **FreeSWITCH** and copy the **Kazoo** specific configuration files to **FreeSWITCH** configuration folder .i.e. `/etc/freeswitch`

```
#Make a back of freeswitch files 
mkdir ~/freeswitch-backup
sudo mv /etc/freeswitch ~/freeswitch-backup
#Copy configuration files from kazoo configuration folder to FreeSWITCH configuration folder.
sudo cp -r /etc/kazoo/freeswitch/* /etc/freeswitch
#Fix ownership
chown -R freeswitch:daemon /etc/freeswitch  
Fix the cookie name in /etc/freeswitch/autoload-configs/kazoo.conf.xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration name="kazoo.conf" description="General purpose Erlang C-node produced to better fit the Kazoo project">
    <settings>
        <param name="listen-ip" value="0.0.0.0" />
        <param name="listen-port" value="8031" />
        <!--<param name="cookie-file" value="/etc/freeswitch/autoload_configs/.erlang.cookie" />-->
        <param name="cookie" value="<your unique cookie" />
        <param name="shortname" value="false" />
        <param name="nodename" value="freeswitch" />
        <!--<param name="kazoo-var-prefix" value="ecallmgr" />-->
        <!--<param name="compat-rel" value="12"/> -->
    </settings>
</configuration>
SIP profile in  /etc/freeswitch/sip_profiles/sipinterface_1.xml have port set to 11000. You do not want to use non standard port, change it to 5060
<!-- SIP -->
<param name="sip-ip" value="$${local_ip_v4}"/>
<param name="ext-sip-ip" value="auto"/>
<param name="sip-port" value="5060"/>
Restart the FreeSWITCH
sudo service freeswitch restart
```

## More Kazoo Configurations

To make **Kazoo** `ecallmgr` to talk to **FreeSWITCH** instance, you will need to create/update ecallmgr document in **BigCouch** DB. Follow the "Manually Editing Database Documents" guide to configure `ecallmgr` application.
 
 
