Please use 
Install Nagios monitoring
 for now, at least until this is updated.
(maybe that this will be romoved by original author)
 
*** UNDER CONSTRUCTION ***
What is Nagios
Nagios
 is 
a 
complete monitoring and alerting solution for servers, switches, applications, and services. Great for NOC (Network Operation Center) Applications. Perfect for monitoring Kazoo clusters, and even CPE equipment and IT infrastructure. The diagram below gives a basic overview of how this works:
Installation Overview
This tutorial is based on CentOS 6.x using Nagios Core. Since Nagios is built on CentOS, it's a natural fit for the Kazoo enviroment. The summary of programs we will be installing...
Nagios Core 
Nagios Plug-ins
NRPE (Nagios Remote Plugin Executor)
snmp utilities (Optional - if you plan to monitor CPE routers, switches, etc)
There are 2 parts to a Nagios Deployment
. There is the Nagios Core and Plug-ins, which is the heart of your monitoring platform. The second part will be the NRPE (Nagios Remote Plugin Executor). This is specifically placed on remote Linux servers you wish to monitor. In this case it will be our Kazoo Cluster. 
 
Nagios Core Installation
First we will focus on the server that will run Nagios Core and be the central hub to your monitoring deployment.
Download source for Nagios Core and Nagios Plug-ins for Monitoring Server
Download the latest stable Nagios Core Source:
Nagios NRPE and Nagios Plug-ins for remote Linux servers(s)
As detailed in the introduction, the NRPE (Nagios Remote Plugin Executor) is a plugin that operates on the system you wish you monitor and allows the Nagios Core to poll information from it. 
Download source for the Nagios NRPE Add-on and Nagios Plug-ins
Add user for Nagios and set it's password.
adduser nagios
passwd nagios
 
 
Download the lastest stable Nagios NRPE Add-on
cd /usr/local/src
Set some enviroment flags
export LDFLAGS=-ldl
download plugins
wget 
http://sourceforge.net/projects/nagiosplug/files/nagiosplug/1.4.16/nagios-plugins-1.4.16.tar.gz
