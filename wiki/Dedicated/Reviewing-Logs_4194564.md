To be able to debug your setup u need to check the logs. The command tail -f xxx.log will open the logfile and present a live 
running
 view
 
Essential log files are:
 /var/log/2600hz/kazoo.log
The main log of the Kazoo platform, tells u roughly what is happening on your systems in terms of Kazoo. It requirs some getting used to, but after that its your best friend.
If u need it too show u more details u can set the verbose level: 
/opt/kazoo/utils/sup/sup whistle_maintenance syslog_level debug
  (
https://en.wikipedia.org/wiki/Syslog#Severity_levels
)
 
/var/log/haproxy.log
Underestimated tiny log file, really descriptive. It tells you if haproxy is doing the needed magic, if not your system wont run nicely.
Used by Kazoo to access mulitple systems as if they where one (Bigcouch DB) 
 
/var/log/kamailio/kamailio.log
Kamailio is your SBC, it receives registration requests  (+some) and validates them.
/var/log/freeswitch/debug.log
Freeswitch should be obvious, all calls are handles by it. This file will give u a lot of info.
One could also use fs_cli on a freeswitch box. 
 
/var/log/rabbitmq/rabbit.log
Rabbitmq is the communication tool used by Kazoo to communicate  internally
 
Typical usage:
 
User case: 
Inbound call fails
Just imagine what should happen for a call to be accepted.
A call needs to be placed by someone, then delivered to kazoo platform, then accepted by Freeswitch, then dealt with.
So.. can u confirm that someone (you?) is dialing the right number? Is the number configured at the DID provider to be routed to Kazoo?
ARE U SURE??...
Ok, so lets first shutdown one FS box or tail -f /var/log/freeswitch/debug.log on all FS boxes.
Place a test call.... do you see an invite coming in that file? Yes? Great... find the CALL ID and close the log file, then grep CALL ID /var/log/freeswitch/debug.log
The result of that action should be relevant log lines for that call. Check it line for line to see what happened and why it did not do what u expected.
Most errors in the early stage of the kazoo learning curve have to do with acls. Also check  
Inbound Calls Fail
 and 
this page
 
No invite? 
Oei... that suggest that the call is not delivered to your systems. 
So.. can u confirm that someone (you?) is dialing the right number? Is the number configured at the DID provider to be routed to Kazoo?
ARE U SURE??...
If so, please check if u dont have a firewall in place thats messing stuff up. One easy but dangerous way to test is to disable the firewall for a while.
Still nothing?
If u are using a sip address when directing calls to Kazoo, please check DNS and DNS propagation, if unsure try to use the ip address instead of domain name.
Still nothing
U could check the Kazoo log, i dont think it will contain anything but u (actually i) never know.
 
 
 
 
 
 
 
