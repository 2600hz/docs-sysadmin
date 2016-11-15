## Setting up IPTABLES



For your **Kazoo** / **Kamailio** servers create a file called `secure.sh`. Paste the below script into `secure.sh` and modify to fit your environment.  

After saving the file you need to make it executable.  
`chmod +x secure.sh`

Now let's run our new script. 
`./secure.sh`


## IPTABLES - Kazoo Server
```
#!/bin/bash
# cwd=/etc/sysconfig/
#
# flush all existing rules and chains
iptables -F
iptables -X
# allow inbound ssh connection on external/public interface
iptables -A INPUT -p tcp --dport 22 --sport 1024:65535 -m state --state NEW,ESTABLISHED -j ACCEPT
# set default policies (allow any outbound, block inbound, restrict forwarding between interfaces)
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
# Allow TCP 80 and 443 for Winkstart if you installed KAZOO-UI
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
# Allow RTP traffic
iptables -A INPUT -p udp --dport 16384:32768 -j ACCEPT
# Allow KAMAILIO traffic
iptables -A INPUT -p tcp --dport 5060 -j ACCEPT
iptables -A INPUT -p tcp --dport 7000 -j ACCEPT
iptables -A INPUT -p udp --dport 5060 -j ACCEPT
iptables -A INPUT -p udp --dport 7000 -j ACCEPT
# allow all inbound traffic coming in on loopback and the internal/private interfaces
#iptables -A INPUT -i eth0 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
# allow your home / office ip
iptables -A INPUT -s "XXX.XXX.XXX.XXX" -j ACCEPT # YOUR STATIC IP
#iptables -A INPUT -s "" -j ACCEPT #  whatever IP u want if u want someone else to see the db
#PUBLIC IP ADDRESSES OF YOUR SERVERS - REPLACE X'S
iptables -A INPUT -s "XXX.XXX.XXX.XXX" -j ACCEPT # - FREESWITCH LOCATION-1 SERVER-1
iptables -A INPUT -s "XXX.XXX.XXX.XXX" -j ACCEPT # - FREESWITCH LOCATION-2 SERVER-1
iptables -A INPUT -s "XXX.XXX.XXX.XXX" -j ACCEPT # - BIGCOUCH-DB  LOCATION-1 SERVER 001
iptables -A INPUT -s "XXX.XXX.XXX.XXX" -j ACCEPT # - BIGCOUCH-DB  LOCATION-1 SERVER 002
iptables -A INPUT -s "XXX.XXX.XXX.XXX" -j ACCEPT # - BIGCOUCH-DB  LOCATION-2 SERVER 001
iptables -A INPUT -s "XXX.XXX.XXX.XXX" -j ACCEPT # - BIGCOUCH-DB  LOCATION-2 SERVER 002
iptables -A INPUT -s "XXX.XXX.XXX.XXX" -j ACCEPT # - WHAPPS/KAZOO LOCATION-1 SERVER-1
iptables -A INPUT -s "XXX.XXX.XXX.XXX" -j ACCEPT # - WHAPPS/KAZOO LOCATION-2 SERVER-1
#INTERNET / PRIVATE NETWORK IP ADDRESSES OF YOUR SERVERS
iptables -A INPUT -s "XXX.XXX.XXX.XXX" -j ACCEPT # - FREESWITCH LOCATION-1 SERVER-1
iptables -A INPUT -s "XXX.XXX.XXX.XXX" -j ACCEPT # - FREESWITCH LOCATION-2 SERVER-1
iptables -A INPUT -s "XXX.XXX.XXX.XXX" -j ACCEPT # - BIGCOUCH-DB  LOCATION-1 SERVER 001
iptables -A INPUT -s "XXX.XXX.XXX.XXX" -j ACCEPT # - BIGCOUCH-DB  LOCATION-1 SERVER 002
iptables -A INPUT -s "XXX.XXX.XXX.XXX" -j ACCEPT # - BIGCOUCH-DB  LOCATION-2 SERVER 001
iptables -A INPUT -s "XXX.XXX.XXX.XXX" -j ACCEPT # - BIGCOUCH-DB  LOCATION-2 SERVER 002
iptables -A INPUT -s "XXX.XXX.XXX.XXX" -j ACCEPT # - WHAPPS/KAZOO LOCATION-1 SERVER-1
iptables -A INPUT -s "XXX.XXX.XXX.XXX" -j ACCEPT # - WHAPPS/KAZOO LOCATION-2 SERVER-1
# block traffic coming into db unless ACCEPTED in INPUT above which 8server setup IP's are placed in with home/office IP's above.
iptables -A INPUT -p tcp --dport 15984 -j DROP
iptables -A INPUT -p tcp --dport 15986 -j DROP
# Allow TCP 8000 and 8443 for Crossbar
iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
iptables -A INPUT -p tcp --dport 8443 -j ACCEPT
# allow inbound traffic for established connections on external/public interface
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# block packets coming in with invalid source ips
iptables -A INPUT -s 10.0.0.0/8 -j DROP
iptables -A INPUT -s 172.16.0.0/12 -j DROP
iptables -A INPUT -s 192.168.0.0/16 -j DROP
iptables -A INPUT -s 224.0.0.0/4 -j DROP
iptables -A INPUT -s 240.0.0.0/5 -j DROP
iptables -A INPUT -s 0.0.0.0/8 -j DROP
iptables -A INPUT -s 169.254.0.0/16 -j DROP
iptables -A INPUT -s 127.0.0.0/8 -j DROP
# ICMP
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/sec -j ACCEPT
# SYN flood limiter
iptables -A INPUT -p tcp --syn -m limit --limit 5/s -j ACCEPT
# catch-all for end of rules
# LOG and DENY other traffic to help identify additional filters required
iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level debug
iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited
# Save settings
# 
# On CentOS / Fedora this will output the current IPTables to the stdout, which we can pipe to a file that sets these on boot
iptables-save > /etc/sysconfig/iptables
#
# List rules
#
iptables -L -v

```
