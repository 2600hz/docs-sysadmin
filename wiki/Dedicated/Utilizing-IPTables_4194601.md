Ports
Ports to leave open...
 
Example 2
This example should provide some basic security without limiting access or operation of Whistle. It assumes single server so obviously it would be split up into it's various ports for multi server. This does not currently include the obvious need for a cluster of bigcouch DB servers to talk to each other and to Whistle in a multi server setup. One way to simply secure that is with bind-address statements in the CouchDB config and/or static IP allow statements in the iptables. The BigCouch DB servers talk to each other directly on TCP port 5986 and to Whistle on TCP 5984. However, since there are no passwords on CouchDB with the current Whistle defaults, opening those ports to the world do not appear to be an option.
 
# iptables -A INPUT -i lo -j ACCEPT
# iptables -A INPUT -p icmp -m icmp --icmp-type an -j ACCEPT
# iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
# iptables -A INPUT -p udp -m state --state NEW -m udp --dport 
5060
:
5070
-j ACCEPT
# iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 
22
-j ACCEPT
# iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 
80
-j ACCEPT
# iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 
443
-j ACCEPT
# iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 
8000
-j ACCEPT
# iptables -A INPUT -j DROP
# service iptables save
 
Example 3
This is a bash script to directly input the rules into iptables and saves it.  Cut and Paste this into a file and name it for example iptables_script.sh then chmod +x 'filename_you_chosen.sh' then run it with a ./'filename.sh.  For 7 server setup i'd input the IP's of all the servers where the home/office section is so all the servers are talking to each other.  If 7server setup then Bigcouch servers don't need the RTP ports so you can comment out a few lines such as them with a # in front of the iptables command.  This is just a basic example and lots you can do with iptables, this is just recommended to secure your setup as there may be other iptables options out there.  Feel free to add more lines if needed and leave comments plz.  
 
#!/bin/bash
# flush all existing rules and chains
iptables -F
iptables -X
# allow inbound ssh connection on external/public interface
iptables -A INPUT -p tcp --dport 22 --sport 1024:65535 -m state --state NEW,ESTABLISHED -j ACCEPT
# set default policies (allow any outbound, block inbound, restrict forwarding between interfaces)
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
# allow all inbound traffic coming in on loopback and the internal/private interfaces.  IF YOU ENABLE eth0 or whatever device u have then this iptables is worthless cuz u #just allowed all traffic in
#iptables -A INPUT -i eth0 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
# allow your home / office IP.  If 7 server setup it is advisable to add all 7 servers to this list including your home IP address for ssh control
iptables -A INPUT -s 
you.home.ip.address
 -j ACCEPT
# Allow TCP 80 for Winkstart if you installed winkstart via git
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
# Allow TCP 8000 for Crossbar
iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
# Allow TCP 10000 for 'Webmin' access if you have webmin installed
iptables -A INPUT -p tcp --dport 10000 -j ACCEPT
# Allow RTP traffic
iptables -A INPUT -p udp --dport 16384:32768 -j ACCEPT
# Allow OpenSIPS traffic
iptables -A INPUT -p tcp --dport 5060 -j ACCEPT
iptables -A INPUT -p tcp --dport 7000 -j ACCEPT
iptables -A INPUT -p udp --dport 5060 -j ACCEPT
iptables -A INPUT -p udp --dport 7000 -j ACCEPT
# block spoofed packets coming in on external/public interface with internal/private source ips
#-A INPUT -s xxx.yyyy.zzz.0/24 -j DROP
# block traffic coming into db unless ACCEPTED in INPUT above which 7server setup IP's are placed in home/office
iptables -A INPUT -p tcp --dport 5984 -j DROP
iptables -A INPUT -p tcp --dport 5986 -j DROP
iptables -A INPUT -p tcp --dport 15984 -j DROP
# block packets coming in with invalid source ips
iptables -A INPUT -s 10.0.0.0/8 -j DROP
iptables -A INPUT -s 172.16.0.0/12 -j DROP
iptables -A INPUT -s 192.168.0.0/16 -j DROP
iptables -A INPUT -s 224.0.0.0/4 -j DROP
iptables -A INPUT -s 240.0.0.0/5 -j DROP
iptables -A INPUT -s 0.0.0.0/8 -j DROP
iptables -A INPUT -s 169.254.0.0/16 -j DROP
iptables -A INPUT -s 127.0.0.0/8 -j DROP
# SYN flood limiter
iptables -A INPUT -p tcp --syn -m limit --limit 5/s -j ACCEPT
# allow inbound traffic for established connections on external/public interface
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# ICMP
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/sec -j ACCEPT
# allow DNS query replies on external/public interface
#iptables -A INPUT -p udp -s 4.2.2.2 --sport 53 --dport 1024:65535 -j ACCEPT
#iptables -A INPUT -p udp -s 4.2.2.3 --sport 53 --dport 1024:65535 -j ACCEPT
# catch-all for end of rules
# LOG and DENY other traffic to help identify additional filters required
iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix 
iptables denied: 
 --log-level debug
iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited
# Save settings
#
 iptables-save
#
# List rules
#
 iptables -L -v
